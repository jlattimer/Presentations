var Lat = Lat || { __namespace: true };
Lat.Promises = Lat.Promises || { __namespace: true };

(function () {

    this.RetrieveMultipleWithPromise = function () {
        ExecutePromise()
            .then(function (results) {
                for (var i = 0; i < results.value.length; i++) {
                    var name = results.value[i]["name"];
                    var accountid = results.value[i]["accountid"];
                    Lat.Console.LogColor(name + " | " + accountid);
                }
                return results; // Passes to 2nd then
            })
            .then(function (results) {
                Lat.Console.LogColor("Found " + results.value.length + " Accounts");
            })
            .catch(function (error) {
                Xrm.Navigation.openAlertDialog(error);
            });
    }

    function ExecutePromise() {
        return new window.Promise(function (resolve, reject) {
            var req = new XMLHttpRequest();
            req.open("GET", Xrm.Utility.getGlobalContext().getClientUrl() +
                "/api/data/v9.1/accounts?$select=accountid,name", true);
            req.setRequestHeader("OData-MaxVersion", "4.0");
            req.setRequestHeader("OData-Version", "4.0");
            req.setRequestHeader("Accept", "application/json");
            req.setRequestHeader("Content-Type", "application/json; charset=utf-8");
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

}).call(Lat.Promises);


if (typeof module !== 'undefined')
    module.exports = Lat.Promises;