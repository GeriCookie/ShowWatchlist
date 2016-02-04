var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var showModel = new Schema({
  title: String,
  description: String,
  imgUrl: String,
  ratings: [Schema.Types.Mixed],
  genres: [String],
  seasons: [Schema.Types.Mixed],
  comments: [Schema.Types.Mixed],
  actors: [Schema.Types.Mixed]
});

module.exports = mongoose.model('Show', showModel);
