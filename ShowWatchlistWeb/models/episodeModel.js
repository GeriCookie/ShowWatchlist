var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var episodeModel = new Schema({
    episodeTitle: String,
    epImgUrl: String,
    description: String,
    actors: [Schema.Types.Mixed],
    comments: [Schema.Types.Mixed],
    season: [Schema.Types.Mixed],
    show: [Schema.Types.Mixed]
});

module.exports = mongoose.model('Episode', episodeModel);
