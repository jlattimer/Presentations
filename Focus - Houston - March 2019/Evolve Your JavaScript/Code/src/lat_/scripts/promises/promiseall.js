var Lat = Lat || { __namespace: true };
Lat.Promises = Lat.Promises || { __namespace: true };

(function () {

    this.DoPromiseAll = function () {
        var p1 = PromiseAllTop1();
        var p2 = PromiseAllBottom1();

        Promise.all([p1, p2])
            .then(function (values) {
                var results1 = values[0];
                var results2 = values[1];
                var name1 = results1.value[0]["name"];
                var name2 = results2.value[0]["name"];

                Lat.Console.LogColor("Top1: " + name1 + " | Bottom1: " + name2);
            })
            .catch(function (error) {
                Xrm.Navigation.openAlertDialog("Error: " + error);
            });
    }

    function PromiseAllTop1() {
        return new window.Promise(function (resolve, reject) {
            var req = new XMLHttpRequest();
            req.open("GET", Xrm.Utility.getGlobalContext().getClientUrl() +
                "/api/data/v9.1/accounts?$select=accountid,name&$orderby=name asc", true);
            SetRequestHeaders(req);
            req.onreadystatechange = function () {
                if (this.readyState === 4) {
                    req.onreadystatechange = null;
                    if (this.status === 200) {
                        var results = JSON.parse(this.response);
                        resolve(results);
                    } else {
                        reject(this.statusText);
                    }
                }
            };
            req.send();
        });
    }

    function PromiseAllBottom1() {
        return new window.Promise(function (resolve, reject) {
            var req = new XMLHttpRequest();
            req.open("GET", Xrm.Utility.getGlobalContext().getClientUrl() +
                "/api/data/v9.1/accounts?$select=accountid,name&$orderby=name desc", true);
            SetRequestHeaders(req);
            req.onreadystatechange = function () {
                if (this.readyState === 4) {
                    req.onreadystatechange = null;
                    if (this.status === 200) {
                        var results = JSON.parse(this.response);
                        resolve(results);
                    } else {
                        reject(this.statusText);
                    }
                }
            };
            req.send();
        });
    }

    function SetRequestHeaders(req) {
        req.setRequestHeader("OData-MaxVersion", "4.0");
        req.setRequestHeader("OData-Version", "4.0");
        req.setRequestHeader("Accept", "application/json");
        req.setRequestHeader("Content-Type", "application/json; charset=utf-8");
        req.setRequestHeader("Prefer", "odata.maxpagesize=1");
    }

}).call(Lat.Promises);


if (typeof module !== 'undefined')
    module.exports = Lat.Promises;
