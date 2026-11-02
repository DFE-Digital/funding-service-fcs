///<reference path="../../vsdoc/XrmPage-vsdoc.js" />


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

var getValue = function (controlName) {
    var value = Xrm.Page.getAttribute(controlName).getValue();
    return value;
}

function formLoad() {
    SettingOnChange();
}

function SettingOnChange() {
    var setting = getValue("sfa_settingid");
    if (setting) {
        setVisible("sfa_settingvaluelistid", true);
    } else {
        setVisible("sfa_settingvaluelistid", false);
    }
}
