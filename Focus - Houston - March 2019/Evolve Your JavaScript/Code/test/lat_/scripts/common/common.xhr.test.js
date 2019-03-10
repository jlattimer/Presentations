describe('Common Library Tests', () => {

    before(() => {
        // Initialize the Xrm GlobalContext
        var xrm = XrmMockGenerator.initialise();
        const globalContext = new ContextMock(
            {
                clientUrl: "https://org.crm.dynamics.com"
            });
        xrm = XrmMockGenerator.initialise(globalContext);

        // Stub Xrm.Utility.getGlobalContext() to return our globalContext
        xrm.Utility = new UtilityMock();
        sinon.stub(Xrm.Utility, "getGlobalContext").returns(globalContext);

        // Overrides XHR with custom implementation that doesn't send data
        global.XMLHttpRequest = sinon.useFakeXMLHttpRequest();

        // Creates a faker server so test responses can be sent
        server = sinon.fakeServer.create();
    });

    describe("Lat.Common.CreateXhrAsync", () => {

        var entitySet = "contacts";
        var contact = {};
        contact.firstname = "Bob";
        contact.lastname = "Smith";
        var server;
        var url = /https:\/\/org.crm.dynamics.com\/api\/data\/v9.1\/contacts.*/g;

        afterEach(() => {
            // Resets the fake server
            server.restore();
        });

        // Note the done callback function parameter
        it('returns the id of a created record', (done) => {

            var id = "40082f12-b3fd-e811-a96e-000d3a18bab7";
            var response = `https://org.crm.dynamics.com/api/data/v9.1/contacts(${id})`;

            // Response to be returned from a POST to the specified url
            server.respondWith("POST", url, [204,
                { "Content-Type": "application/json", "OData-EntityId": response }, ""]);

            // Execute the method being tested
            // Uses Chai as Promised to test the promise result after calling its 
            // notify method to signal the promise is complete
            // This example shows a promise being resolved
            Lat.Common.CreateXhrAsync(entitySet, contact)
                .should.eventually.to.eql(id).notify(done);

            // Fake server issues the predefined response back to the XHR
            server.respond();

        });


        it('returns a 400 error for a bad request', (done) => {

            // This error response detail was pulled from a real error 
            var errorResponse = {
                error: {
                    code: "0x0",
                    message: "An error occurred while validating input parameters: Microsoft.OData.ODataException: Does not support untyped value in non-open type."
                }
            }

            server.respondWith("POST", url, [400,
                { "Content-Type": "application/json" }, JSON.stringify(errorResponse)]);

            contact.test = "test";
            var message = `Error in Lat.Common.CreateXhrAsync: ${errorResponse.error.message}`

            // This example shows a promise being rejected
            Lat.Common.CreateXhrAsync(entitySet, contact)
                .should.be.rejectedWith(message).notify(done);

            server.respond();
        });
    });

});