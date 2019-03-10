/**
 * Setup.js will be loaded along with each individual *.test.js file and includes any 
 * imports that are common to all tests. Imports specific to a single test file can 
 * be added on that file if desired. 
 */

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
    });

    describe('Lat.Common.GetWebApiEndpoint', () => {

        it('returns 9.1 endpoint', () => {
            var expected = "https://org.crm.dynamics.com/api/data/v9.1/";

            expect(Lat.Common.GetWebApiEndpoint()).to.equal(expected);
        });

    });

    describe('Lat.Common.EndpointVersion', () => {

        it('returns 9.1', () => {
            expect(Lat.Common.EndpointVersion).to.equal("9.1");
        });

    });

    describe("Lat.Common.CleanId", () => {

        var id = "3218ef89-66b8-43df-88eb-07f9c11fce94";

        it('removes curly braces', () => {

            var testId = "{" + id + "}";
            var result = Lat.Common.CleanId(`${testId}`);
            expect(result).to.equal(id);

        });

        it('removes spaces', () => {

            var result = Lat.Common.CleanId(`${id} `);
            expect(result).to.equal(id);

        });

        it('handles null', () => {

            var result = Lat.Common.CleanId(null);
            expect(result).to.equal(null);

        });

        it('handles empty string', () => {

            var result = Lat.Common.CleanId("");
            expect(result).to.equal(null);

        });

    });
});