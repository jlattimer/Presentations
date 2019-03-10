var Lat = Lat || { __namespace: true };
Lat.ErrorHandling = Lat.ErrorHandling || { __namespace: true };

(function () {

    this.DontDo1 = function () {

        try {

            // Some code that returns a value

        } catch (error) {

            // Not providing an indication something 
            // happened doesn't help
            return null;

        }
    }

    this.DontDo2 = function () {

        try {

            // Some code 

        } catch (error) {

            // Don't swallow the exception

        }
    }

    this.Unhandled = function () {

        UndefinedFunction();
        
    }


    this.OpenErrorDialog = function () {

        try {

            UndefinedFunction();

        } catch (error) {

            var errorOptions = {};
            errorOptions.message = error.name;
            errorOptions.details = error.message;
            // Could also log to external source
            Xrm.Navigation.openErrorDialog(errorOptions).then(
                function () {
                    console.log("Handled the error");
                },
                function () {
                    console.log("Something went wrong handling the error");
                });

        } finally {
            console.log("Finally doesn't get hit");
        }

    }

    this.TryCatchFinally = function () {

        try {

            UndefinedFunction();

        } catch (error) {

            // Just log the error
            console.error(error);

        } finally {
            console.log("Finally gets hit");
        }

    }

    this.CustomError = function () {

        var data = {};
        data.somevalue = "test";

        try {

            // Something goes wrong
            throw new CustomException('Exception message!', data);

        } catch (error) {
            console.error(error);
        }

    }


    function CustomException(message, data) {
        this.message = message;
        this.data = data;
        if ("captureStackTrace" in Error)
            Error.captureStackTrace(this, CustomException);
        else
            this.stack = (new Error()).stack;
    }

    CustomException.prototype = Object.create(Error.prototype);
    CustomException.prototype.name = "CustomException";
    CustomException.prototype.constructor = CustomException;

}).call(Lat.ErrorHandling);


if (typeof module !== 'undefined')
    module.exports = Lat.ErrorHandling;