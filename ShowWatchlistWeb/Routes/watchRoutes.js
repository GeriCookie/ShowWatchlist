'use strict';

var express = require('express'),
  passport = require('passport');

let auth = function() {
  return passport.authenticate('bearer', {
    session: false
  });
};

let convertToShowToWatch = function(show) {
  let userShow = {
    _id: show._id,
    title: show.title,
    seasons: show.seasons.map(season => {
      let episodes = season.episodes.map(episode => {
        return {
          title: episode.title,
          isWatched: false
        };
      });
      return {
        id: season.id,
        title: season.title,
        isWatched: false,
        episodes: episodes
      };
    })
  };
  return userShow;
};

var routes = function(Show, Update, User) {
  let router = new express.Router();

  function addShowToUser(user, showId) {
    let promise = new Promise(function(resolve, reject) {
      Show.findById(showId)
        .exec(function(err, show) {
          if (err) {
            return reject(err);
          }

          user.showsToWatch = user.showsToWatch || [];

          let userShow = convertToShowToWatch(show);
          user.showsToWatch.push(userShow);
          user.save(function(err) {
            if (err) {
              return reject(err);
            }
            return resolve(userShow);
          });
        });
    });
    return promise;
  }

  function changeSeasonStatus(user, showId, seasonId) {
    let promise = new Promise(function(resolve, reject) {

    });
    return promise;
  }

  function removeShowFromUser(user, showId) {
    let promise = new Promise(function(resolve, reject) {
      let index = user.showsToWatch.findIndex(show => show._id.toString() === showId);
      let removedShow = user.showsToWatch.splice(index, 1);
      user.save(function(err) {
        if (err) {
          return reject(err);
        }
        return resolve(removedShow[0]);
      });
    });
    return promise;
  }

  function findShowInUser(user, showId) {
    if (!user.showsToWatch) {
      return -1;
    }
    return user.showsToWatch.findIndex(show => show._id.toString() === showId);
  }

  function isShowInUser(user, showId) {
    return findShowInUser(user, showId) >= 0;
  }

  let controller = {
    get: function(req, res) {
      let user = req.user;
      let shows = user.showsToWatch;
      res.send({
        result: shows
      });
    },
    put: function(req, res) {
      let user = req.user;
      let showId = req.params.showId;

      if (isShowInUser(user, showId)) {
        removeShowFromUser(user, showId)
          .then(function(show) {
            return res.send({
              message: `${show.title} removed from user's watch list`
            });
          }, function(err) {
            res.status(400)
              .send(err);
          });
      } else {
        addShowToUser(user, showId)
          .then(function(show) {
            return res.send({
              message: `${show.title} added to user's watch list`
            });
          }, function(err) {
            return res.status(400)
              .send(err);
          });
      }
    },
    putSeason: function(req, res) {
      let showId = req.params.showId;
      let seasonId = +req.params.seasonId;
      let user = req.user;

      let promise = Promise.resolve();

      if (!isShowInUser(user, showId)) {
        console.log(`Adding ${showId} to user....`);
        console.log('----------------');
        promise
          .then(function() {
            return addShowToUser(user, showId);
          });
      }
      promise
        .then(function() {
          let showIndex = findShowInUser(user, showId);
          let shows = user.showsToWatch;
          let show = user.showsToWatch[showIndex];
          let seasonIndex = show.seasons.findIndex(s => s.id === seasonId);
          if (seasonIndex < 0) {
            return res.status(404)
              .send({
                message: 'Invalid season ID'
              });
          }
          let season = show.seasons[seasonIndex];
          season.isWatched = !season.isWatched;
          season.episodes.forEach(ep => ep.isWatched = !ep.isWatched);
          show.seasons[seasonIndex] = season;
          shows[showIndex] = show;
          User.update({
              _id: user._id
            }, {
              showsToWatch: shows
            })
            .exec(function(err) {
              if (err) {
                return res.status(400)
                  .send(err);
              }
              return res.send({
                message: `Season ${season.title} for show ${show.title} changed to ${season.isWatched}!`
              });
            });
        });
    },
    putEpisodeInSeason: function(req, res) {
      let showId = req.params.showId;
      let seasonId = req.params.seasonId;
      let episodeTitle = req.params.episodeTitle;
    }
  };

  router.get('/', auth(), controller.get)
    .put('/:showId/season/:seasonId/episode/:episodeTitle', auth(), controller.putEpisodeInSeason)
    .put('/:showId/season/:seasonId', auth(), controller.putSeason)
    .put('/:showId', auth(), controller.put);

  return router;
};

module.exports = routes;