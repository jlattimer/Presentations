var Lat = Lat || { __namespace: true };
Lat.BasicTests = Lat.BasicTests || { __namespace: true };

(function () {

    this.AddNumbers = function (number1, number2) {

        if (typeof number1 !== 'number' || typeof number2 !== 'number')
            throw (new Error ('Parameter is not a number'));


        return number1 + number2;

    }

}).call(Lat.BasicTests);


if (typeof module !== 'undefined')
    module.exports = Lat.BasicTests;