///<reference path="../../vsdoc/XrmPage-vsdoc.js" />
var cnType = {
    Contract:   229660000,
    Master:     229660001,
    Allocation: 229660002
};

var setVisible = function (controlName, visible, requiredLevel) {
    var control = Xrm.Page.ui.controls.get(controlName);
    if (control === undefined || control == null) {
        alert("Cannot find control : " + controlName);
        return;
    } 

    control.setVisible(visible);

    if ((visible) && (requiredLevel !== undefined)) {
        setRequired(controlName, requiredLevel);
    } else {
        setRequired(controlName, "none");
    }
}

var setRequired = function (controlName, requiredLevel) {
    //  'none' / 'required' / 'recommended'
    Xrm.Page.getAttribute(controlName).setRequiredLevel(requiredLevel);
}

var getValue = function(controlName) {
    var value = Xrm.Page.getAttribute(controlName).getValue();
    return value;
}

function formLoad() {
    ContractNumberTypeOnChange();
}

function ContractNumberTypeOnChange() {
    var contractNumberType = getValue("sfa_contractnumbertype");
    switch (contractNumberType) {
    case cnType.Master:
        setVisible("sfa_agencyid", true, "required");
        setVisible("sfa_fundingtypeid", false);
        setVisible("sfa_fundingstreamid", false);
        break;
    case cnType.Contract:
        setVisible("sfa_agencyid", false);
        setVisible("sfa_fundingtypeid", true, "required");
        setVisible("sfa_fundingstreamid", false);
        break;
    case cnType.Allocation:
        setVisible("sfa_agencyid", false);
        setVisible("sfa_fundingtypeid", false);
        setVisible("sfa_fundingstreamid", true, "required");
        break;
    default:
        setVisible("sfa_agencyid", false);
        setVisible("sfa_fundingtypeid", false);
        setVisible("sfa_fundingstreamid", false);
        break;
    }
}
