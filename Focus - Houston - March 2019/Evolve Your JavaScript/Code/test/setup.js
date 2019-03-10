// xrm-mock (https://github.com/camelCaseDave/xrm-mock) - used to mock D365 objects
const { XrmMockGenerator, ContextMock, ClientContextMock, UtilityMock } = require("xrm-mock");
// Any methods, properties, types, etc. that are used should be added to the global namespace
global.XrmMockGenerator = XrmMockGenerator;
global.ContextMock = ContextMock;
global.ClientContextMock = ClientContextMock;
global.UtilityMock = UtilityMock;

// sinon.js (https://sinonjs.org) - used to mock method responses and XMLHTTPRequests
const sinon = require("sinon");
global.sinon = sinon;

// chai (https://www.chaijs.com) - assertion framework used to make testing results easier
const chai = require('chai');
global.should = chai.should();
global.expect = chai.expect;
global.assert = chai.assert;

// chai-as-promised (https://github.com/domenic/chai-as-promised) - 
// chai extension to make testing promises easier
const chaiAsPromised = require('chai-as-promised');
chai.use(chaiAsPromised);

// mock-local-storage (https://github.com/letsrock-today/mock-local-storage) - 
// used to mock a browser's local & session storage
const storage = require("mock-local-storage");

// Declare the default namespace being tested and include the 
// common.js file used throughout the project
const Lat = {};
global.Lat = Lat;
Lat.Common = require("../src/lat_/scripts/common/common");

console.log("Setup.js loaded");