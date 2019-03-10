


// Traditional
function Form_OnLoad(executionContext) {
    executionContext.getFormContext()
        .getAttribute("name").setValue("help");
}

// Basic Closure
var Lat = (function () {

    // Private
    var _getValue = function () {
        return "test";
    }

    // Public
    return {
        go: function () {
            return _getValue();
        }
    }

})();

// Use
console.log(Lat.go()); // test
console.log(lat._getValue()); // not defined

// Namespace
var Lat = Lat || { __namespace: true };
Lat.Common = Lat.Common || { __namespace: true };

(function () {

    // Private
    function _getValue() {
        return "test";
    }

    // Public
    this.go = function () {
        return _getValue();
    }

}).call(Lat.Common);

// Use
console.log(Lat.Common.go()); // test
console.log(Lat.Common._getValue()); // not a function

