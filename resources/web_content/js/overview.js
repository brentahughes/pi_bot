$(document).ready(function() {
    updateHostInfo();
    $.getJSON("/api/host", function(data) {
        setHostInfo(data);
    });

    $.getJSON("/api/host", function(data) {
        var cpuCount = data.processors.length;

        updateGraphData();
        $.getJSON("/api/metrics", function(data) {
            setGraphData(data);
        });
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

var setGraphData = function(data) {
    var chartLabels = [];
    var loadData = [];
    var memoryData = [];

    $.each(data, function(index, metric) {
        var time = moment(metric.created).format("HH:mm:ss")
        chartLabels.push(time);
        loadData.push(parseFloat((metric.load / cpuCount) * 100).toFixed(2));
        memoryData.push(parseFloat(metric.memoryPercent).toFixed(2));
    });

    metricsChart.data.labels = chartLabels;
    metricsChart.data.datasets[0].data = loadData;
    metricsChart.data.datasets[1].data = memoryData;
    metricsChart.update();
}

var updateHostInfo = function() {
    setTimeout(function() {
        $.getJSON("/api/host", function(data) {
            setHostInfo(data);
            updateHostInfo();
        });
    }, 10000)
}

var updateGraphData = function() {
    setTimeout(function() {
        $.getJSON("/api/metrics", function(data) {
            setGraphData(data);
            updateGraphData();
        });
    }, 10000)
}

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
