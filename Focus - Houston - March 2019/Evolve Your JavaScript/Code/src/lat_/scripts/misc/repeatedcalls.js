

// Instead of:
if (Xrm.Page.getAttribute("field").getValue() === "test") {
    var x = Xrm.Page.getAttribute("field").getValue();
}

// Use:
var field = Xrm.Page.getAttribute("field").getValue();
if (field === "test") {
    var x = field;
}

// Executes faster
// Easier to read

