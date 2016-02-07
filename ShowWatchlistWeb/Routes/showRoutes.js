'use strict';

var express = require('express'),
  passport = require('passport');

var routes = function(Show, Update, Season, Episode, Actor) {
  var showRouter = express.Router();

  var showController = require('../Controllers/showController')(Show, Update);

  showRouter.route('/')
    .post(showController.post)
    .get(showController.get);

  showRouter.use('/:showId', function(req, res, next) {
    Show.findById(req.params.showId, function(err, show) {
      console.log('In middleware');
      if (err) {
        res.status(500).send(err);
      } else if (show) {
        req.show = show;
        next();
      } else {
        res.status(404).send('no show find');
      }
    });
  });

  showRouter.route('/:showId')
    .get(function(req, res) {
      console.log('In get');
      var returnShow = req.show.toJSON();
      returnShow = [returnShow].map(function(show) {
        var rating = 0;
        if (show.ratings) {
          var totalRatingSum = show.ratings.reduce(function(s, showRating) {
            return s + showRating.rating;
          }, 0);
          rating = totalRatingSum / show.ratings.length;
        }

        return {
          _id: show._id,
          title: show.title,
          actors: show.actors,
          genres: show.genres,
          description: show.description,
          imageUrl: show.imgUrl,
          seasons: show.seasons,
          rating: rating,
          comments: show.comments
        };
      });
      res.json(returnShow[0]);
    });

  showRouter.put('/:showId', passport.authenticate('bearer', {
    session: false
  }), function(req, res) {
    var user = req.user;

    if (!user) {
      return res.status(401)
        .json({
          message: 'Unauthorized user'
        });
    }

    var showId = req.body.showId;
    if (!showId) {
      return res.status(404)
        .json({
          message: 'Invalid show'
        });
    }

    var rating = req.body.rating | 0;
    if (isNaN(rating) || rating < 1 || 5 < rating) {
      return res.status(404)
        .json({
          message: 'Invalid status'
        });
    }

    Show.findById(showId, function(err, show) {
      if (err) {
        throw err;
      }
      if (!show) {
        return res.status(404)
          .json({
            message: 'No show found'
          });
      }

      if (!show.ratings) {
        show.ratings = [];
      }

      var index = show.ratings.findIndex(showRating => showRating.userId.toString() == user._id.toString());
      if (index >= 0) {
        show.ratings[index].rating = rating;
      } else {
        show.ratings.push({
          userId: user._id,
          rating: rating
        });
      }

      show.save(function() {
        var newUpdate = new Update({
          text: user.username + ' rated ' + show.title,
          date: new Date(),
          user: {
            username: user.username,
            id: user._id
          },
          show: {
            _id: show._id,
            title: show.title
          },
          rating: rating
        });
        newUpdate.save();

        res.json({
          result: show
        });
      });
    });
  });

  showRouter.put('/:showId/comment', passport.authenticate('bearer', {
    session: false
  }), function(req, res) {
    var user = req.user;

    if (!user) {
      return res.status(401)
        .json({
          message: 'Unauthorized user'
        });
    }

    var showId = req.body.showId;
    if (!showId) {
      return res.status(404)
        .json({
          message: 'Invalid show'
        });
    }

    var comment = req.body.comment;
    if (comment.length <= 0) {
      return res.status(404)
        .json({
          message: 'Invalid status'
        });
    }

    Show.findById(showId, function(err, show) {
      if (err) {
        throw err;
      }
      if (!show) {
        return res.status(404)
          .json({
            message: 'No show found'
          });
      }

      if (!show.comments) {
        show.comments = [];
      }
      show.comments.push({
        userId: user._id,
        comment: comment
      });

      show.save(function() {
        var newUpdate = new Update({
          text: user.username + ' commented ' + show.title,
          date: new Date(),
          user: {
            username: user.username,
            id: user._id
          },
          show: {
            _id: show._id,
            title: show.title
          },
          comment: comment
        });
        newUpdate.save();

        res.json({
          result: show
        });
      });
    });
  });

  showRouter.put('/:showId/seasons', function(req, res) {
    Show.findById(req.params.showId, function(err, show) {
      if (err) {
        throw err;
      }
      if (!show) {
        return res.status(404)
          .json({
            message: 'No show found'
          });
      }

      if (!show.seasons) {
        show.seasons = [];
      }
      var index = show.seasons.findIndex(season => season.title == req.body.seasonTitle);
      if (index < 0) {
        show.seasons.push({
          seasonId: show.seasons.length + 1,
          seasonTitle: req.body.seasonTitle,
          show: {
            title: show.title,
            showId: show._id
          },
          episodes: []
        });
      }
      show.save(function() {
        res.json({
          result: show
        });
      });
    });
  });

  showRouter.put('/:showId/seasons/:seasonNumber', function(req, res) {

    Show.findById(req.params.showId, function(err, show) {
      if (err) {
        throw err;
      }
      if (!show) {
        return res.status(404).json({
          message: 'No show found'
        });
      }
      var seasonNumber = req.params.seasonNumber | 0;
      if (!(show.seasons[seasonNumber - 1].episodes)) {
        show.seasons[seasonNumber - 1].episodes = [];
      }
      var index = show.seasons[seasonNumber - 1].episodes
        .findIndex(episode => episode.episodeTitle === req.body.episodeTitle);
      if (index < 0) {
        var episode = {
          episodeTitle: req.body.episodeTitle,
          epImgUrl: req.body.episodeImgUrl,
          description: req.body.description,
          episodeNumber: req.body.episodeNumber,
          season: {
            seasonTitle: show.seasons[seasonNumber - 1].title,
            seasonNumber: seasonNumber
          },
          show: {
            title: show.title,
            showId: show._id
          }
        };
        show.seasons[seasonNumber - 1].episodes.push(episode);
      }

      Show.update({
        _id: show._id
      }, {
        seasons: show.seasons
      }, function(err) {
        res.json({
          result: show
        });
      });
      // show.save(function(err) {
      //   console.log('-----------------------');
      //   console.log(show.seasons[seasonNumber - 1].episodes);
      //   if (err) {
      //     throw err;
      //   }
      //   res.json({
      //     result: show
      //   });
      // });
    });
  });


  return showRouter;
};

module.exports = routes;