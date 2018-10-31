

print("[HOME] [OK]");

var view = page.view;

view.set("background-color","#fff");

setTimeout(function(){
           
           print("[setTimeout] [OK]");
           
           },1000);

setInterval(function(){
           
           print("[setInterval] [OK]");
           
           },1000);

