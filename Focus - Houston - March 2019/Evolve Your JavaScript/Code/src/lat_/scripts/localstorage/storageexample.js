var Lat = Lat || { __namespace: true };
Lat.LocalStorage = Lat.LocalStorage || { __namespace: true };

(function () {

    /**
       * Caches an object in the browser's session storage and tags with the date/time it was added
       * Session storage is cleared when all instances of the browser are closed
       * 
       * @param {string} - Unique key to identified cached value
       * @param {*} - Value or object to be cached
       * @param [validForMinutes] - Number of minutes the cached value should be considered valid, 
       *                            no value will allow the value to be valid until session storage is cleared
       */
    this.SetCachedValue = function (key, value, validForMinutes) {
        var container = {};
        if (validForMinutes)
            container.endDate = new Date(new Date().getTime()
                + validForMinutes * 60000).toUTCString();
        else
            container.endDate = null;

        container.value = value;
        var jsonValue = JSON.stringify(container);
        sessionStorage.setItem(key, jsonValue);
        console.log("Set session storage value: " + key + ": " + value);
    }

    /**
     * Retrieves an object from the browser's session cache
     * 
     * @param {string} - Unique key to identified cached value
     * @returns {*} - Cached value or object, returns null if the cache expiration has expired
     */
    this.GetCachedValue = function (key) {
        var jsonValue = sessionStorage.getItem(key);
        if (!jsonValue) {
            console.log(key + " not found in session storage")
            return null;
        }

        var container = JSON.parse(jsonValue);
        if (!container.endDate) {
            console.log("Returning cached value from session storage (no expiration): " + key);
            return container.value;
        }

        if (new Date() < new Date(container.endDate)) {
            console.log("Returning cached value from session storage (within expiration): " + key);
            return container.value;
        }

        console.log("Returning null from session storage (expired): " + key);
        return null;
    }

}).call(Lat.LocalStorage);


if (typeof module !== 'undefined')
    module.exports = Lat.LocalStorage;