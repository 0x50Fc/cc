
module.exports = function(options,app,page){

    var view = page.view;

    view.set("background-color","#fff");

    var config = new UIWebViewConfiguration();

    config.addUserScript(UI.getTextContent("wx.web.js"));

    var webview = UIView.create("WKWebView",config);

    view.addSubview(webview);

    webview.setFrame(0,64,page.width,page.height - 64);
    webview.set("background-color","#fff");

};
