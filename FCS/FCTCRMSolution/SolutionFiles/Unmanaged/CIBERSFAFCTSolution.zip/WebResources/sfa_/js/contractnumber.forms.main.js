var cnType = {
    Contract:   229660000,
    Master:     229660001,
    Allocation: 229660002
};

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

var getValue = function(formContext, controlName) {
	"use strict";
    var value = formContext.getAttribute(controlName).getValue();
    return value;
}

function formLoad(executionContext) {
	"use strict";
    ContractNumberTypeOnChange(executionContext);
}

function ContractNumberTypeOnChange(executionContext) {
	"use strict";
	var formContext = executionContext.getFormContext();
    var contractNumberType = getValue(formContext, "sfa_contractnumbertype");
    switch (contractNumberType) {
    case cnType.Master:
        setVisible(formContext, "sfa_agencyid", true, "required");
        setVisible(formContext, "sfa_fundingtypeid", false);
        setVisible(formContext, "sfa_fundingstreamid", false);
        break;
    case cnType.Contract:
        setVisible(formContext, "sfa_agencyid", false);
        setVisible(formContext, "sfa_fundingtypeid", true, "required");
        setVisible(formContext, "sfa_fundingstreamid", false);
        break;
    case cnType.Allocation:
        setVisible(formContext, "sfa_agencyid", false);
        setVisible(formContext, "sfa_fundingtypeid", false);
        setVisible(formContext, "sfa_fundingstreamid", true, "required");
        break;
    default:
        setVisible(formContext, "sfa_agencyid", false);
        setVisible(formContext, "sfa_fundingtypeid", false);
        setVisible(formContext, "sfa_fundingstreamid", false);
        break;
    }
}
