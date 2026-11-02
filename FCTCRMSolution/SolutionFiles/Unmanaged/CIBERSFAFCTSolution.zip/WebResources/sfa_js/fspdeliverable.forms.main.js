var setVisible = function (formContext, controlName, visible, requiredLevel) {
	"use strict";
    var control = formContext.ui.controls.get(controlName);
    if (control === undefined || control === null) {
        Xrm.Navigation.openAlertDialog({text: "Cannot find control : " + controlName});
        return;
    }

    control.setVisible(visible);

    if ((visible) && (requiredLevel !== undefined)) {
        setRequired(formContext, controlName, requiredLevel);
    } else {
        setRequired(formContext, controlName, "none");
    }
}

var setRequired = function (formContext, controlName, requiredLevel) {
	"use strict";
    //  'none' / 'required' / 'recommended'
    formContext.getAttribute(controlName).setRequiredLevel(requiredLevel);
}

var getValue = function (formContext, controlName) {
	"use strict";
    var value = formContext.getAttribute(controlName).getValue();
    return value;
}

function formLoad(executionContext) {
	"use strict";
    SettingOnChange(executionContext);
}

function SettingOnChange(executionContext) {
	"use strict";
	var formContext = executionContext.getFormContext();
    var setting = getValue(formContext, "sfa_settingid");
    if (setting) {
        setVisible(formContext, "sfa_settingvaluelistid", true);
    } else {
        setVisible(formContext, "sfa_settingvaluelistid", false);
    }
}
