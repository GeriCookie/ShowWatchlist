require('../polyfills/array');
var showController = function(Show) {
  var post = function(req, res) {
    var show = new Show(req.body);

    Show.findOne({
      title: show.title
    }, function(err, dbShow) {
      if (err) {
        throw err;
      }
      if (dbShow) {
        res.status(400).json({
          message: 'Show already in DB'
        });
        return;
      }
      show.save(function(err, result) {
        if (err) {
          throw err;
        }
        res.status(201);
        res.send(show);
      });
    });
  };

  var get = function(req, res) {
    var page = +req.query.page | 1;
    var size = +req.query.size | 10;
    Show.find({}, function(err, shows) {
      if (err) {
        res.status(500).send(err);
      } else {

        if (req.query.genre) {
          var genre = req.query.genre.toLowerCase();
          shows = shows.filter(function(show) {
            return !!(show.genres.find(function(showGenre) {
              return showGenre.toLowerCase() === genre;
            }));
          });
        }
        shows = shows.slice((page - 1) * size, page * size);
        shows = shows.map(function(show) {
          return {
            _id: show._id,
            title: show.title,
            genres: show.genres,
            imageUrl: show.imgUrl,
            communityRating: show.communityRating
          };
        });
        res.json({
          result: shows
        });
      }
    });
  };

  return {
    post: post,
    get: get
  };
};

module.exports = showController;