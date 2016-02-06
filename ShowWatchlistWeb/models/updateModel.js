var mongoose = require('mongoose'),
  Schema = mongoose.Schema;

var updateModel = new Schema({
  text: String,
  date: Date,
  user: Schema.Types.Mixed,
  show: Schema.Types.Mixed,
  comment: Schema.Types.Mixed
});

module.exports = mongoose.model('Update', updateModel);
