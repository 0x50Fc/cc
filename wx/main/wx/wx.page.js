
module.exports = function(options,path,page){

    print("[PAGE]");
    
    var view = page.view;

    page.setOptions(options);

    view.set("background-color","#fff");

    var config = new UIWebViewConfiguration();

    config.addUserScript(app.getTextContent("wx/wx.web.js"));
    config.addUserScript("debugger;",1);

    var webview = app.createView("WKWebView",config);

    view.addSubview(webview);

    webview.setFrame(0,64,page.width,page.height - 64);
    webview.set("background-color","#fff");
    webview.set("#text",app.getTextContent(path));
    
};
