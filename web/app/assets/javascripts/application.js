// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery3
//= require jquery_ujs
//= require_tree .


  OneSignal.on('subscriptionChange', function (isSubscribed) {
    if (isSubscribed) {
      OneSignal.getUserId(function(userId) {
        var user_params = { onesignal_id: userId };

        // these flows are operated for our service
        // i.e. Update user's column with userService.updateUser
        return userService.updateUser(user_params)
          .then(onSuccess);

        function onSuccess (response) {
          var user = response.data.user;

          OneSignal.push(["sendTag", "user_id", user.id]);
          OneSignal.push(["sendTag", "user_name", user.name]);
          OneSignal.push(["sendTag", "user_email", user.email]);
        }
      });
    }
  });
})
