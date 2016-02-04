var express = require('express');

var routes = function (User) {
  var userRouter = express.Router();

  var userController = require('../Controllers/userController')(User);

  userRouter.route('/')
    .post(userController.post)
    .get(userController.get);

    userRouter.route('/auth')
        .put(function (req, res) {
          var username = req.body.username,
          passHash = req.body.passHash,
          query = {
            username: username.toLowerCase()
          };

          User.findOne(query, function (err, user) {
            if (err) {
              throw err;
            } else if (user === null) {
              res.status(404).json({
                message: 'Invalid username or password'
              });

            } else if (user.passHash === passHash) {
              var userSend = {
                username: user.nickname,
                token : user.token
              };

              res.json(userSend);
            } else {
              res.status(404).json({message: 'Invalid username or password'});
            }


          });

        });
        return userRouter;
};
module.exports = routes;
