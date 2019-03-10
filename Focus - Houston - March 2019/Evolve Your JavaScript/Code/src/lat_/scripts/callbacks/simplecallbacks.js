var Lat = Lat || { __namespace: true };
Lat.Callbacks = Lat.Callbacks || { __namespace: true };

(function () {

    this.CallbackMistake1 = function () {
        var req = new XMLHttpRequest();
        req.open("GET", Xrm.Utility.getGlobalContext().getClientUrl() +
            "/api/data/v9.1/accounts?$select=name", true);
        req.setRequestHeader("OData-MaxVersion", "4.0");
        req.setRequestHeader("OData-Version", "4.0");
        req.setRequestHeader("Accept", "application/json");
        req.setRequestHeader("Content-Type", "application/json; charset=utf-8");
        req.setRequestHeader("Prefer", "odata.maxpagesize=1");
        req.onreadystatechange = function () {
            if (this.readyState === 4) {
                req.onreadystatechange = null;
                if (this.status === 200) {
                    var results = JSON.parse(this.response);

                    if (results.value.length > 0) {
                        Lat.Console.LogBasic("Retrieved Account: " +
                            results.value[0]["name"] + " | " + results.value[0]["accountid"]);
                    }

                } else {
                    Xrm.Navigation.alertDialog(this.statusText);
                }
            }
        };
        req.send();

        Lat.Console.LogBasic("I expect this to happen after the record is retrieved");
    }

    this.CallbackMistake2 = function () {
        var req = new XMLHttpRequest();
        req.open("GET", Xrm.Utility.getGlobalContext().getClientUrl() +
            "/api/data/v9.1/accounts?$select=name", false);
        req.setRequestHeader("OData-MaxVersion", "4.0");
        req.setRequestHeader("OData-Version", "4.0");
        req.setRequestHeader("Accept", "application/json");
        req.setRequestHeader("Content-Type", "application/json; charset=utf-8");
        req.setRequestHeader("Prefer", "odata.maxpagesize=1");
        req.onreadystatechange = function () {
            if (this.readyState === 4) {
                req.onreadystatechange = null;
                if (this.status === 200) {
                    var results = JSON.parse(this.response);

                    if (results.value.length > 0) {
                        Lat.Console.LogBasic("Retrieved Account: " +
                            results.value[0]["name"] + " | " + results.value[0]["accountid"]);
                    }

                } else {
                    Xrm.Navigation.alertDialog(this.statusText);
                }
            }
        };
        req.send();

        Lat.Console.LogWarning("Now this to happens after the record is retrieved");
    }


    this.XhrCallbackAnonymous = function () {
        var entity = {};
        entity.name = "Delete Me";

        var req = new XMLHttpRequest();
        req.open("POST", Xrm.Utility.getGlobalContext().getClientUrl() +
            "/api/data/v9.1/accounts", true);
        req.setRequestHeader("OData-MaxVersion", "4.0");
        req.setRequestHeader("OData-Version", "4.0");
        req.setRequestHeader("Accept", "application/json");
        req.setRequestHeader("Content-Type", "application/json; charset=utf-8");
        req.onreadystatechange = function () {
            if (this.readyState === 4) {
                req.onreadystatechange = null;
                if (this.status === 204) {
                    var uri = this.getResponseHeader("OData-EntityId");
                    var regExp = /\(([^)]+)\)/;
                    var matches = regExp.exec(uri);
                    var newEntityId = matches[1];

                    Lat.Console.LogBasic("Created Account: " + entity.name
                        + " | " + newEntityId);
                } else {
                    Xrm.Navigation.alertDialog(this.statusText);
                }
            }
        };
        req.send(JSON.stringify(entity));
    }

    this.XhrCallbackFunction = function () {
        var entity = {};
        entity.name = "Delete Me";

        var req = new XMLHttpRequest();
        req.open("POST", Xrm.Utility.getGlobalContext().getClientUrl() +
            "/api/data/v9.1/accounts", true);
        req.setRequestHeader("OData-MaxVersion", "4.0");
        req.setRequestHeader("OData-Version", "4.0");
        req.setRequestHeader("Accept", "application/json");
        req.setRequestHeader("Content-Type", "application/json; charset=utf-8");
        req.onreadystatechange = function () {
            if (this.readyState === 4) {
                req.onreadystatechange = null;
                if (this.status === 204) {
                    CreateAccountCallback(this, entity);
                } else {
                    Xrm.Navigation.alertDialog(this.statusText);
                }
            }
        };
        req.send(JSON.stringify(entity));
    }

    function CreateAccountCallback(xhr, entity) {
        var uri = xhr.getResponseHeader("OData-EntityId");
        var regExp = /\(([^)]+)\)/;
        var matches = regExp.exec(uri);
        var newEntityId = matches[1];

        Lat.Console.LogBasic("Created Account: " + entity.name + " | " + newEntityId);
    }

    function ThisIsOutOfControl() {
        var req = new XMLHttpRequest();
        req.open("GET", Xrm.Utility.getGlobalContext().getClientUrl() +
            "/api/data/v9.1/accounts?$select=name&$filter=name eq 'Delete%20Me'", true);
        req.setRequestHeader("OData-MaxVersion", "4.0");
        req.setRequestHeader("OData-Version", "4.0");
        req.setRequestHeader("Accept", "application/json");
        req.setRequestHeader("Content-Type", "application/json; charset=utf-8");
        req.setRequestHeader("Prefer", "odata.include-annotations=\"*\"");
        req.onreadystatechange = function () {
            if (this.readyState === 4) {
                req.onreadystatechange = null;
                if (this.status === 200) {
                    var results = JSON.parse(this.response);
                    for (var i = 0; i < results.value.length; i++) {
                        var name = results.value[i]["name"];

                        var entity = {};
                        entity.accountnumber = "000";

                        var req2 = new XMLHttpRequest();
                        req2.open("PATCH", Xrm.Utility.getGlobalContext().getClientUrl() +
                            "/api/data/v9.1/accounts(" + results.value[i]["accountid"] + ")", true);
                        req2.setRequestHeader("OData-MaxVersion", "4.0");
                        req2.setRequestHeader("OData-Version", "4.0");
                        req2.setRequestHeader("Accept", "application/json");
                        req2.setRequestHeader("Content-Type", "application/json; charset=utf-8");
                        req2.onreadystatechange = function () {
                            if (this.readyState === 4) {
                                req2.onreadystatechange = null;
                                if (this.status === 204) {

                                    var entity = {};
                                    entity.subject = "Please stop";
                                    entity["regardingobjectid@odata.bind"] = "/accounts(" + results.value[i]["accountid"] + ")";

                                    var req3 = new XMLHttpRequest();
                                    req3.open("POST", Xrm.Utility.getGlobalContext().getClientUrl() + "/api/data/v9.1/tasks", true);
                                    req3.setRequestHeader("OData-MaxVersion", "4.0");
                                    req3.setRequestHeader("OData-Version", "4.0");
                                    req3.setRequestHeader("Accept", "application/json");
                                    req3.setRequestHeader("Content-Type", "application/json; charset=utf-8");
                                    req3.onreadystatechange = function () {
                                        if (this.readyState === 4) {
                                            req3.onreadystatechange = null;
                                            if (this.status === 204) {
                                                var uri = this.getResponseHeader("OData-EntityId");
                                                var regExp = /\(([^)]+)\)/;
                                                var matches = regExp.exec(uri);
                                                var newEntityId = matches[1];

                                                // And so on.......
                                            } else {
                                                Xrm.Navigation.alertDialog(this.statusText);
                                            }
                                        }
                                    };
                                    req3.send(JSON.stringify(entity));

                                } else {
                                    Xrm.Navigation.alertDialog(this.statusText);
                                }
                            }
                        };
                        req2.send(JSON.stringify(entity));
                    }
                } else {
                    Xrm.Navigation.alertDialog(this.statusText);
                }
            }
        };
        req.send();
    }


}).call(Lat.Callbacks);


if (typeof module !== 'undefined')
    module.exports = Lat.Callbacks;