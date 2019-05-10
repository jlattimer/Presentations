"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var L = require("leaflet");
var MapView = /** @class */ (function () {
    /**
     * Empty constructor.
     */
    function MapView() {
    }
    /**
     * Used to initialize the control instance. Controls can kick off remote server calls and other initialization actions here.
     * Data-set values are not initialized here, use updateView.
     * @param context The entire property bag available to control via Context Object; It contains values as set up by the customizer mapped to property names defined in the manifest, as well as utility functions.
     * @param notifyOutputChanged A callback method to alert the framework that the control has new outputs ready to be retrieved asynchronously.
     * @param state A piece of data that persists in one session for a single user. Can be set at any point in a controls life cycle by calling 'setControlState' in the Mode interface.
     * @param container If a control is marked control-type='starndard', it will receive an empty div element within which it can render its content.
     */
    MapView.prototype.init = function (context, notifyOutputChanged, state, container) {
        debugger;
        this._controlViewRendered = false;
        this._container = document.createElement("div");
        this._container.id = "mapid";
        this._context = context;
        container.appendChild(this._container);
        var map = L.map('mapid').setView([39.8283, 98.5795], 13);
        // Credits in lower right corner
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map);
        Object.keys(context.parameters.entityDataSet.records).forEach(function (key) {
            var record = context.parameters.entityDataSet.records[key];
            console.log(record.getValue("name"));
            L.marker([record.getValue("address1_latitude"), record.getValue("address1_longitude")]).addTo(map)
                .bindPopup(record.getValue("name"))
                .openPopup();
        });
        // L.marker([51.5, -0.09]).addTo(map)
        // 	.bindPopup('A pretty CSS3 popup.<br> Easily customizable.')
        // 	.openPopup();
    };
    /**
     * Called when any value in the property bag has changed. This includes field values, data-sets, global values such as container height and width, offline status, control metadata values such as label, visible, etc.
     * @param context The entire property bag available to control via Context Object; It contains values as set up by the customizer mapped to names defined in the manifest, as well as utility functions
     */
    MapView.prototype.updateView = function (context) {
        // Add code to update control view
    };
    /**
     * It is called by the framework prior to a control receiving new data.
     * @returns an object based on nomenclature defined in manifest, expecting object[s] for property marked as “bound” or “output”
     */
    MapView.prototype.getOutputs = function () {
        return {};
    };
    /**
     * Called when the control is to be removed from the DOM tree. Controls should use this call for cleanup.
     * i.e. cancelling any pending remote calls, removing listeners, etc.
     */
    MapView.prototype.destroy = function () {
        // Add code to cleanup control if necessary
    };
    return MapView;
}());
exports.MapView = MapView;
