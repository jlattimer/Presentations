if (Xrm.Page.getAttribute("numberofemployees1").getValue() != null &&
    Xrm.Page.getAttribute("numberofemployees1").getValue() != 'undefined')
    console.log("??");

if (Xrm.Page.getAttribute("numberofemployees1") != null &&
    Xrm.Page.getAttribute("numberofemployees1") != 'undefined')
    console.log("???");

if (Xrm.Page.getAttribute("numberofemployees1") !== null &&
    Xrm.Page.getAttribute("numberofemployees1") !== undefined)
    console.log("???");

if (!Xrm.Page.getAttribute("numberofemployees1"))
    console.log("????");

// Executes faster
// Easier to read

