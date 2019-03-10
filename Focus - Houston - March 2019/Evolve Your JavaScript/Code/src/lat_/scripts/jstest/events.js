var Lat = Lat || { __namespace: true };
Lat.Events = Lat.Events || { __namespace: true };

(function () {

    this.TriggerConsoleLog_OnChange = function (executionContext) {
        var formContext = executionContext.getFormContext();

        var selectedLog = formContext.getAttribute("lat_triggerconsolelog").getValue();
        switch (selectedLog) {
            case 807990000:
                Lat.Console.LogBasic("Nothing special");
                break;
            case 807990001:
                Lat.Console.LogWarning("Something a bit more important");
                break;
            case 807990002:
                Lat.Console.LogError("Now it's serious");
                break;
            case 807990003:
                Lat.Console.LogColor("This stands out");
                break;
            case 807990004:
                var person = {};
                person["firstname"] = "Jason";
                person["lastname"] = "Lattimer";
                var message = "Show the person object ->";
                Lat.Console.LogObject(message, person);
                break;
            case 807990006:
                Lat.Console.LogStartGroup("JS Test Form Group");
                break;
            case 807990007:
                Lat.Console.LogStopGroup("JS Test Form Group");
                break;
        }
    }

    this.TriggerRequest_OnChange = function (executionContext) {
        var formContext = executionContext.getFormContext();

        var selectedRequest = formContext.getAttribute("lat_triggerrequest").getValue();
        switch (selectedRequest) {
            case 807990000:
                Lat.Promises.RetrieveMultipleWithPromise();
                break;
            case 807990001:
                Lat.Promises.DoPromiseAll();
                break;
            case 807990002:
                Lat.Callbacks.XhrCallbackAnonymous();
                break;
            case 807990003:
                Lat.Callbacks.XhrCallbackFunction();
                break;
            case 807990004:
                Lat.Callbacks.CallbackMistake1();
                break;
            case 807990005:
                Lat.Callbacks.CallbackMistake2();
                break;
            case 807990006:
                var entityXrm = {};
                entityXrm["name"] = "Created from common Xrm.WebApi";
                Lat.Common.CreateXrmAsync("account", entityXrm)
                    .then(function (id) {
                        Lat.Common.LogMessage("Created Account (Xrm.WebApi): " + id);
                    });
                break;
            case 807990007:
                var entityXhr = {};
                entityXhr["name"] = "Created from common XHR";
                Lat.Common.CreateXhrAsync("accounts", entityXhr)
                    .then(function (id) {
                        Lat.Common.LogMessage("Created Account (XHR): " + id);
                    });
                break;
        }
    }

    this.TriggerSessionStorage_OnChange = function (executionContext) {
        var formContext = executionContext.getFormContext();

        var selectedSessionStorage = formContext.getAttribute("lat_sessionstorage").getValue();

        switch (selectedSessionStorage) {
            case 807990000:
                Lat.LocalStorage.SetCachedValue("TheDate", new Date().toISOString(), 1);
                break;
            case 807990001:
                var result = Lat.LocalStorage.GetCachedValue("TheDate");
                console.log(result);
                break;
        }
    }

    this.ErrorHandling_OnChange = function (executionContext) {
        var formContext = executionContext.getFormContext();

        var selectedError = formContext.getAttribute("lat_errorhandling").getValue();

        switch (selectedError) {
            case 807990000:
                Lat.ErrorHandling.OpenErrorDialog();
                break;
            case 807990001:
                Lat.ErrorHandling.TryCatchFinally();
                break;
            case 807990002:
                Lat.ErrorHandling.CustomError();
                break;
            case 807990003:
                Lat.ErrorHandling.Unhandled();
                break;
        }
    }

    this.ApplicationInsights_OnChange = function (executionContext) {
        var formContext = executionContext.getFormContext();

        var selectedAppInsights = formContext.getAttribute("lat_applicationinsights").getValue();

        switch (selectedAppInsights) {
            case 807990000:
                Lat.AppInsights.Event();
                break;
            case 807990001:
                Lat.AppInsights.Exception();
                break;
            case 807990002:
                Lat.AppInsights.Metric();
                break;
            case 807990003:
                Lat.AppInsights.Trace();
                break;
            case 807990004:
                Lat.AppInsights.Dependency();
                break;
            case 807990005:
                Lat.AppInsights.TrackXhrDependency();
                break;
            case 807990006:
                Lat.AppInsights.MethodTimer();
                break;
        }
    }

    this.Ra

}).call(Lat.Events);


if (typeof module !== 'undefined')
    module.exports = Lat.Events;