function CallActionPlugin() {


    var parameters = {};
    parameters.ValueToProcess = "test";

    var lat_DemoActionRequest = {
        ValueToProcess: parameters.ValueToProcess,

        getMetadata: function () {
            return {
                boundParameter: null,
                parameterTypes: {
                    "ValueToProcess": {
                        "typeName": "Edm.String",
                        "structuralProperty": 1
                    }
                },
                operationType: 0,
                operationName: "lat_DemoAction"
            };
        }
    };

    Xrm.WebApi.online.execute(lat_DemoActionRequest).then(
        function success(result) {
            if (result.ok) {
                var results = JSON.parse(result.responseText);
                console.log(results.Message);
            }
        },
        function (error) {
            Xrm.Utility.alertDialog(error.message);
        }
    );



}