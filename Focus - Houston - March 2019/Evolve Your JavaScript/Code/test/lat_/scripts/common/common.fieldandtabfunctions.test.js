describe('Common Library Tests', () => {
    
    var testField = "name";
    var testValue = "ABC Company";
    var nameField;

    before(() => {
        // Initialize the Xrm GlobalContext
        XrmMockGenerator.initialise();

        // Create a fake text attribute with an initial value
        nameField = XrmMockGenerator.Attribute.createString(testField, testValue);
    });
    
    describe('Field level tests', () => {
  
        // Not using common library
        it('GetFieldValue - attribute found', () => {
            
            var val = nameField.getValue();

            expect(val).to.equal(testValue);

        });

        // Using common library
        it('GetFieldValue - no attribute found', () => {

            var val = Lat.Common.GetFieldValue("notfound");

            expect(val).to.equal(null);

        });

        it('GetFieldValue - pretending to send in form context', () => {

            var val = Lat.Common.GetFieldValue(testField, Xrm.Page);

            expect(val).to.equal(testValue);

        });

    });
});