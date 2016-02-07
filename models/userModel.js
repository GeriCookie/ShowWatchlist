var mongoose = require('mongoose'),
  Schema = mongoose.Schema;

var userModel = new Schema({
  username: String,
  nickname: String,
  passHash: String,
  token: String,
  showsToWatch: [Schema.Types.Mixed],
  friends: [Schema.Types.Mixed]
});

module.exports = mongoose.model('User', userModel);