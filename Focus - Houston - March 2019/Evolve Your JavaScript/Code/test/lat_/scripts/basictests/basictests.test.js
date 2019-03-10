/**
 * Setup.js will be loaded along with each individual *.test.js file and includes any 
 * imports that are common to all tests. Imports specific to a single test file can 
 * be added on that file if desired. 
 */

Lat.BasicTests = require("../../../../src/lat_/scripts/basictests/basictests");

// Create a suite to group multiple tests together
describe('Basic Tests', () => {

    // Runs once before any tests run
    before(() => { });
    // Runs before each test is run 
    beforeEach(() => { });
    // Runs after each test is run
    afterEach(() => { });
    // Runs once after all tests are run
    after(() => { });


    // Wrap tests in another function to allow test specific code
    describe('AddNumber Tests', () => {

        // Additional before/after functions can be here as well

        // Describe the test & execute the code to be tested then create 
        // assertions to determine if the expected result is achieved
        it('should add 2 positive numbers correctly', () => {

            // Arrange
            var number1 = 3;
            var number2 = 4;
            var expected = 7;

            // Act
            var result = Lat.BasicTests.AddNumbers(number1, number2);

            // Assert
            // This uses the chai assertion library
            expect(result).to.equal(expected);

            console.log(`${number1} + ${number2} = ${expected}`)
        });

        it('should add 2 negative numbers correctly', () => {

            // Arrange
            var number1 = -3;
            var number2 = -4;
            var expected = -7;

            // Act
            var result = Lat.BasicTests.AddNumbers(number1, number2);

            // Assert
            expect(result).to.equal(expected);

            console.log(`${number1} + ${number2} = ${expected}`)
        });

        // Testing handled exceptions
        it('should throw an exception if a parameter is not a number', () => {

            var number1 = 3;
            var number2 = 'orange';

            expect(() => Lat.BasicTests.AddNumbers(number1, number2))
                .to.throw('Parameter is not a number')

            console.log(`${number1} + ${number2} = Error`)
        });

    });

});