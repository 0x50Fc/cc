


var context;

exports.setContext = function(v) {
    context = v;
};

exports.createCanvasContext = function(canvasId) {
    if(context) {
        return context.getCanvasContext(canvasId);
    }
};

exports.chooseLocation = function(data) {
    
    var res = {
        latitude: 0,
        longitude: 0,
        speed: 0,
        accuracy: 0,
        altitude: 0,             // >=1.2.0
        verticalAccuracy: 0,     // >=1.2.0
        horizontalAccuracy: 0    // >=1.2.0
    };
    
    if (data.success) {
        console.log("on chooseLocation");
        data.success(res);
    }
}
