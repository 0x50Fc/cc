

print("[HOME] [OK]");

var view = page.view;

view.set("background-color","#fff");

var webview = UIView.create("WKWebView");

view.addSubview(webview);

webview.setFrame(0,64,375,600);
webview.set("background-color","#f00");
webview.set("#text","<html><body style='background-color:rgba(0,0,0,0);'></body></html>");

var v = UIView.create("UIView");

webview.addSubview(v);

v.setFrame(20,20,200,200);
v.set("background-color","#ff0");
