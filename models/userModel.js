var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var userModel = new Schema({
  username: String,
  nickname: String,
  passHash: String,
  token: String,
  seriesToWatch: [Schema.Types.Mixed]

});

module.exports = mongoose.model('User', userModel);
