function setTimeout() {
    timeOut.running = true;
}

function clearTimeout() {
    timeOut.running = false;
}

function connectTimeout() {
    console.log("TimeOut");
    var i;
    for(i = 0;i < authlist.count;i++){
        authlist.setProperty(i, "totp", Hotp.totp("PEHMPSDNLXIOG65U",Hotp.get_timestamp()));
    }
}
