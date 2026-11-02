function formLoad() {

    var IS_SYSTEMADMIN = XrmServiceToolkit.Soap.IsCurrentUserRole("System Administrator")
    if (IS_SYSTEMADMIN !== true) {
        Xrm.Page.getControl("name").setDisabled(true);
        Xrm.Page.getControl("description").setDisabled(true);
        Xrm.Page.getControl("administratorid").setDisabled(true);


    }
}