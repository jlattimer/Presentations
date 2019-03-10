describe('Common Library Tests', () => {

    before(() => {
        // Initialize the Xrm GlobalContext
        XrmMockGenerator.initialise();
    });

    describe("Lat.Common.CreateXrmAsync", () => {
        var account = {};
        account.name = "test";

        // Note the done callback function parameter
        it('returns the id of a created record', (done) => {

            // Valid Xrm.WebApi.online.createRecord response
            var validResponse = {
                entityType: "account",
                id: "3218ef89-66b8-43df-88eb-07f9c11fce94"
            }

            // Stub Xrm.WebApi.online.createRecord to return a valid response
            sinon.stub(Xrm.WebApi.online, "createRecord").resolves(validResponse);

            // Execute the method being tested
            // Uses Chai as Promised to test the promise result after calling its 
            // notify method to signal the promise is complete
            // This example shows a promise being resolved
            Lat.Common.CreateXrmAsync("account", account)
                .should.eventually.to.equal(validResponse.id).notify(done);
        });

        it('returns a 400 error for a bad request', (done) => {

            // This error response detail was pulled from a real error 
            var errorResponse = {
                error: {
                    code: "0x0",
                    message: "An error occurred while validating input parameters: Microsoft.OData.ODataException: Does not support untyped value in non-open type."
                }
            }
            var message = `Error in Lat.Common.CreateXrmAsync: ${errorResponse.error.message}`

            // Invalid field
            account.test = "test";

            sinon.stub(Xrm.WebApi.online, "createRecord").rejects(errorResponse);

            // This example shows a promise being rejected
            Lat.Common.CreateXrmAsync("account", account)
                .should.be.rejectedWith(message).notify(done);
        });
    });

});