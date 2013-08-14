Qt.include("Hotp.js")
Qt.include("Storage.js")

function init() {
    Storage.initialize();
    var res = Storage.selectData();
    var result;
    var now = new Date().getTime() / 1000;
    var initTime = (get_timestamp() + 1) * 30 - now;
    for(var i = 0 ;i < res.length; i++){
        result = totp(res[i][1],get_timestamp());
        authlist.append({
                            name: res[i][0],
                            totp: result,
                            secretKey: res[i][1],
                            keepTime: initTime
                        });
    }
    console.log(initTime);
    initTimeOut.interval = initTime * 1000;
    initTimeOut.start();
    refreshTimer.start();
}
