var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var actorModel = new Schema({
  name: String,
  actorImg: String,
  wikiLink: String
});

module.exports = mongoose.model('Actor', actorModel);
