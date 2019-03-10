
// This:
if (Xrm.Page.getAttribute("title").getValue() === "1" ||
    Xrm.Page.getAttribute("title").getValue() === "2") {
    // something
}

// Is 200% slower than this:
var title = Xrm.Page.getAttribute("title").getValue();
if (title === "1" || title === "2") {
    // something
}

//It’s also more readable as conditions grow
//Using switch is usually faster yet as conditions grow


