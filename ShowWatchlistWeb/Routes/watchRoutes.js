'use strict';

var express = require('express'),
  passport = require('passport');

let auth = function() {
  return passport.authenticate('bearer', {
    session: false
  });
};

var routes = function(Show, Update, User) {
  let router = new express.Router();

  let controller = {
    get: function(req, res) {
      let user = req.user;
      let shows = user.shows;
      res.send({
        result: shows
      });
    },
    put: function(req, res) {
      let user = req.user;
      let showId = req.body.showId;
      Show.findById(showId)
        .exec(function(err, show) {
          if (err) {
            return res.status(404)
              .send({
                message: 'Invalid show Id'
              });
          }
          if (!user.showsToWatch) {
            user.showsToWatch = [];
          }

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
          user.showsToWatch.push(userShow);
          user.save(function(err) {
            if (err) {
              return res.status(400)
                .send({
                  message: 'Invalid request'
                });
            }
            return res.send(user);
          });
        });
    }
  };

  router.get('/', auth(), controller.get)
    .put('/', auth(), controller.put);

  return router;
};

module.exports = routes;