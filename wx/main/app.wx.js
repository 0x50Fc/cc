var wx = require("wx/wx.js");
App({
    onLaunch: function (options) {
        // Do something initial when launch.
        console.log("on load");
        wx.chooseLocation({
            success: function(res){
                console.log(res);
            }
        });
    },
    onShow: function (options) {
        // Do something when show.
    },
    onHide: function () {
        // Do something when hide.
    },
    onError: function (msg) {
        console.log(msg)
    },
    globalData: 'I am global data'
});
