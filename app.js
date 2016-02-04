var express = require('express'),
    bodyParser = require('body-parser'),
    mongoose = require('mongoose'),
    passport = require('passport'),
    Strategy = require('passport-http-bearer');

passport.use(new Strategy(
  function(token, done){
    User.findOne({ token: token }, function (err, user) {
      if (err) {
        return done(err);
      }
      if (!user) {
        return done(null, false);
      }
      return done(null, user, {scope: 'all'});
    });
  }
));
var db = mongoose.connect('mongodb://localhost/shows');

var User = require('./models/userModel');
var Show = require('./models/showModel');
var Season = require('./models/seasonModel');
var Episode = require('./models/episodeModel');
var Actor = require('./models/actorModel');
var Update = require('./models/updateModel');
var app = express();
var port = process.env.PORT || 3000;

//app.use('/' express.static(__dirname + '/public'));

app.use(bodyParser.json());

var userRouter = require('./Routes/userRoutes')(User);
var showRouter = require('./Routes/showRoutes')(Show, Update);


app.use('/api/users', userRouter);
app.use('/api/shows', showRouter);
app.get('/profile',
  passport.authenticate('bearer', {
    session: false
  }),
  function(req, res) {
    res.json(req.user);
  });

  app.listen(port, function() {
    console.log('Running on PORT: ' + port);
  });

  module.exports = app;
