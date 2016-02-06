var mongoose = require('mongoose'),
  Schema = mongoose.Schema;

var seasonModel = new Schema({
  seasonNumber: Number,
  seasonTitle: String,
  episodes: [Schema.Types.Mixed],
  show: Schema.Types.Mixed
});

module.exports = mongoose.model('Season', seasonModel);