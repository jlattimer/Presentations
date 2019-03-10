var Lat = Lat || { __namespace: true };
Lat.AppInsights = Lat.AppInsights || { __namespace: true };

(function () {

    this.Event = function () {
        // This is also an example of sending custom measurements
        D365AppInsights.writeEvent("Button Click", null, { click: 1 });
    }

    this.Exception = function () {
        try {
            UndefinedFunction();
        }
        catch (e) {
            D365AppInsights.writeException(e, "ExceptionTest", AI.SeverityLevel.Error, null, null);
        }
    }

    this.Metric = function () {
        D365AppInsights.writeMetric("Custom Metric: Measurement", 5, 1);
        D365AppInsights.writeMetric("Custom Metric: Aggregate", 15, 3, 0, 30);
    }

    this.Trace = function () {
        // This is also an example of sending custom dimensions
        D365AppInsights.writeTrace("Test", AI.SeverityLevel.Warning, { myProp: "a value" });
    }

    this.Dependency = function () {
        // This could represent any external dependency being logged
        D365AppInsights.writeDependency("Test", "Some Method", 100, true, 0);
    }

    this.TrackXhrDependency = function () {
        var req = new XMLHttpRequest();
        req.open("GET", "https://httpbin.org/delay/2?test=1", true);
        req.setRequestHeader("Accept", "application/json");
        req.onreadystatechange = function () {
            if (this.readyState === 4) {
                req.onreadystatechange = null;
                if (this.status === 200) {
                    var result = JSON.parse(this.response);
                }
                else {
                    console.log(this.statusText);
                }
            }
        };
        D365AppInsights.trackDependencyTime(req, "DependencyTest");
        req.send();
    }

    var iterations = 50;
    var multiplier = 1000000000;

    this.MethodTimer = function () {
        var t = performance.now();
        try {
            var primes = calculatePrimes(iterations, multiplier);
            console.log(primes);
        }
        finally {
            D365AppInsights.writeMethodTime("TestMethod", t, performance.now());
        }
    }

    function calculatePrimes(iterations, multiplier) {
        var primes = [];
        for (var i = 0; i < iterations; i++) {
            var candidate = i * (multiplier * Math.random());
            var isPrime = true;
            for (var c = 2; c <= Math.sqrt(candidate); ++c) {
                if (candidate % c === 0) {
                    // not prime
                    isPrime = false;
                    break;
                }
            }
            if (isPrime) {
                primes.push(candidate);
            }
        }
        return primes;
    }


}).call(Lat.AppInsights);


if (typeof module !== 'undefined')
    module.exports = Lat.AppInsights;