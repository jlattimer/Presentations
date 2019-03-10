var Lat = Lat || { __namespace: true };
Lat.Common = Lat.Common || { __namespace: true };

(function () {

    var _enableMessages = true;
    var _enableWarnings = true;
    var _enableErrors = true;

    this.EndpointVersion = "9.1";

    // Public

    /**
     * Returns the current Web API URL with a trailing slash
     * 
     * @returns {String} The Web API URL
     */
    this.GetWebApiEndpoint = function () {
        return Xrm.Utility.getGlobalContext().getClientUrl() +
            "/api/data/v" + Lat.Common.EndpointVersion + "/";
    }

    /**
     * Logs a message to the console if enabled
     * 
     */
    this.LogMessage = function (message) {
        if (_enableMessages)
            console.log(message);
    }

    /**
     * Logs a warning to the console if enabled
     * 
     */
    this.LogWarning = function (message) {
        if (_enableWarnings)
            console.warn(message);
    }

    /**
     * Logs an error to the console if enabled
     * 
     */
    this.LogError = function (message) {
        if (_enableErrors)
            console.error(message);
    }

    /**
     * Trims spaces and removes braces from a guid
     * 
     * @param {string} id - The guid to clean
     * @returns {string} A trimmed guid with no braces
     */
    this.CleanId = function (id) {
        if (!id)
            return null;

        id = id.trim();
        return id.replace(/[{}]/g, "");
    }

    /**
     * Gets the value of the field passed in to the function.
     * 
     * @param {string} fieldName - The field to be looked up - required
     * @param {object} formContext - The context of the form. If not passed in this will default to Xrm.Page
     * @returns {object} - The value of the field on the form
     */
    this.GetFieldValue = function (fieldName, formContext) {
        var attribute = _getAttribute(fieldName, formContext);
        if (attribute !== null)
            return attribute.getValue();

        Lat.Common.LogWarning("No attribute found on page with name " + fieldName);
        return null;
    }



    /**
     * Creates a single record using Xrm.WebApi.online
     * 
     * @tutorial https://docs.microsoft.com/en-us/dynamics365/customer-engagement/developer/clientapi/reference/xrm-webapi/createrecord
     * @param {string} entity - Logical name of the entity
     * @param {object} payload - Object representing the entity to create
     * @returns {object} Id of the new record
     * @example CreateXrmAsync("account", account)
     */
    this.CreateXrmAsync = function (entity, payload) {
        return new Promise(function (resolve, reject) {
            Xrm.WebApi.online.createRecord(entity, payload)
                .then(function (result) {
                    resolve(result.id);
                }, function (error) {
                    var message = "Error in Lat.Common.CreateXrmAsync: " + _getXhrErrorMessage(error);
                    Lat.Common.LogError(message);
                    reject(message);
                });
        });
    }


    /**
     * Creates a single record using a XMLHTTPRequest
     * 
     * @param {string} entitySet - The entity set name
     * @param {object} payload - Object representing the entity to create
     * @returns {object} Id of the new record
     * @example CreateXhrAsync("accounts", account)
     */
    this.CreateXhrAsync = function (entitySet, payload) {
        return new Promise(function (resolve, reject) {
            var req = new XMLHttpRequest();
            var url = Lat.Common.GetWebApiEndpoint() + entitySet;
            req.open("POST", url, true);
            req = _createXhrBase(req, false);
            req.onload = function () {
                if (this.readyState === 4) {
                    if (this.status === 204) {
                        var regExp = /\(([^)]+)\)/;
                        var matches = regExp.exec(this.getResponseHeader("OData-EntityId"));
                        var newEntityId = matches[1];
                        resolve(newEntityId);
                    } else {
                        var message = "Error in Lat.Common.CreateXhrAsync: " + _getXhrErrorMessage(req.response);
                        Lat.Common.LogError(message);
                        reject(message);
                    }
                }
            };
            req.send(JSON.stringify(payload));
        });
    }


    // Private

    /**
    * Retrieves the available context
    * 
    * @param {object} formContext - Form context
    * @returns {object} Context
    */
    function _checkFormContext(formContext) {
        if (formContext !== null && formContext !== undefined) {
            return formContext;
        }
        if (Xrm === null || Xrm.Page === null) {
            if (parent.Xrm === null || parent.Xrm.Page === null) {
                Lat.Common.LogError("Context could not be found.");
                return null;
            }
            Lat.Common.LogWarning("No formContext passed into function using parent.Xrm.Page (warning: this will be deprecated).");
            return parent.Xrm.Page;
        }

        Lat.Common.LogWarning("No formContext passed into function using Xrm.Page (warning: this will be deprecated).");
        return Xrm.Page;
    }

    /**
     * Retrieves the attribute from the form context
     * 
     * @param {string} field - Field logical name
     * @param {object} formContext - Form context
     * @returns {object} Attribute
     */
    function _getAttribute(field, formContext) {
        formContext = _checkFormContext(formContext);
        if (formContext === null)
            return null;
        return formContext.getAttribute(field);
    }

    /**
     * Creates the request headers for an XHR
     * 
     * @param {object} req - XMLHTTPRequest
     * @param {boolean} includeFormatted - Return formatted values
     * @returns {object} XMLHTTPRequest with Web API headers
     */
    function _createXhrBase(req, includeFormatted) {
        req.setRequestHeader("Accept", "application/json");
        req.setRequestHeader("Content-Type", "application/json; charset=utf-8");
        req.setRequestHeader("OData-MaxVersion", "4.0");
        req.setRequestHeader("OData-Version", "4.0");
        if (includeFormatted)
            req.setRequestHeader("Prefer", "odata.include-annotations=\"*\"");

        return req;
    }

    /**
     * Retrieves error details from an XHR
     * 
     * @param {error} err 
     * @returns {string} Error details
     */
    function _getXhrErrorMessage(err) {
        if (!err)
            return null;
        var response = err;
        if (typeof err === 'string' || err instanceof String)
            response = JSON.parse(err);
        if (response.error && response.error.message)
            return response.error.message;
        return null;
    }

}).call(Lat.Common);


if (typeof module !== 'undefined')
    module.exports = Lat.Common;