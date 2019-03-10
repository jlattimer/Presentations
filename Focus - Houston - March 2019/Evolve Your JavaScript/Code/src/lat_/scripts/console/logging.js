var Lat = Lat || { __namespace: true };
Lat.Console = Lat.Console || { __namespace: true };

(function () {

    /**
     * Writes a plain message to the console
     * 
     */
    this.LogBasic = function (message) {
        console.log(message);
    }

    /**
     * Starts grouping console messages
     * 
     */
    this.LogStartGroup = function (name) {
        console.group(name);
    }

    /**
     * Stops grouping console messages
     * 
     */
    this.LogStopGroup = function (name) {
        console.groupEnd(name);
    }

    /**
     * Writes an warning message to the console
     * 
     */
    this.LogWarning = function (message) {
        console.warn(message);
    }

    /**
     * Writes an error message to the console
     * 
     */
    this.LogError = function (message) {
        console.error(message);
    }

    /**
     * Writes a colored message to the console
     * 
     */
    this.LogColor = function (message) {
        console.log("%c" + message, "color: green");
    }

    /**
     * Writes a message and an object to the console
     * 
     */
    this.LogObject = function (message, obj) {
        console.log(message, obj);
    }

    this.RunExample = function () {
        LogBasic("Nothing special");

        LogWarning("Something a bit more important");

        LogError("Now it's serious");

        LogColor("This stands out");

        var person = {};
        person["firstname"] = "Jason";
        person["lastname"] = "Lattimer";
        var message = "Show the person object ->";
        LogObject(message, person);
    }

}).call(Lat.Console);


if (typeof module !== 'undefined')
    module.exports = Lat.Console;