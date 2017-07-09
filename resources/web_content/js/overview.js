$(document).ready(function() {
    updateHostInfo();
    $.getJSON("/api/host", function(data) {
        setHostInfo(data);
    });
});

var setHostInfo = function(data) {
    $("#overview_hostname").text(data.host.hostname);
    $("#overview_uptime").text(getUptime(data.host.uptime));
    $("#overview_load").text(data.load.load15 + " " + data.load.load5 + " " + data.load.load1);
    $("#overview_os").text(data.host.platform + " " + data.host.platformVersion);
    $("#overview_memory").text(getMemory(data.memory.used) + "/" + getMemory(data.memory.total));
    $("#overview_processor").text(data.processors[0].modelName);
}

var updateHostInfo = function() {
    setTimeout(function() {
        console.log('here');

        $.getJSON("/api/host", function(data) {
            setHostInfo(data);
            updateHostInfo();
        });
    }, 10000)
};

var getMemory = function(bytes) {
    var thresh = 1000;
    if(Math.abs(bytes) < thresh) {
        return bytes + ' B';
    }
    var units = ['kB','MB','GB','TB','PB','EB','ZB','YB']
    var u = -1;

    do {
        bytes /= thresh;
        ++u;
    } while(Math.abs(bytes) >= thresh && u < units.length - 1);
    return bytes.toFixed(1)+' '+units[u];
}

var getUptime = function(seconds) {
    var returnString = "";
    var leftover = seconds;
    var breakdown = {
        "d": 86400,
        "h": 3600,
        "m": 60,
        "s": 1,
    };

    $.each(breakdown, function(name, divider) {
        var time = Math.floor(leftover / divider);
        if (time > 0) {
            returnString += time + name + " ";
        }

        leftover = leftover - (time * divider);
    });

    return returnString;
}