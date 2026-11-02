function formLoad() {

	var allocationid = Xrm.Page.getAttribute("sfa_contractallocationid").getValue()[0].id;
	var allocationDetails = GetContractAllocationDetail(allocationid);
        var tab = Xrm.Page.ui.tabs.get("tabGeneral");

	if ((allocationDetails.deliveryOrg) &&(allocationDetails.LEP)){
	    tab.sections.get("tab_details_section_allocation").setVisible(false);
            tab.sections.get("tab_details_section_allocation_DO_LEP").setVisible(true);
	} else if (allocationDetails.deliveryOrg)  {
            tab.sections.get("tab_details_section_allocation").setVisible(false);
            tab.sections.get("tab_details_section_allocation_DO").setVisible(true);
        } else if (allocationDetails.LEP) {
	    tab.sections.get("tab_details_section_allocation").setVisible(false);
            tab.sections.get("tab_details_section_allocation_LEP").setVisible(true);
	} 

}

function GetContractAllocationDetail(allocationid) {
	var deliveryProvider = false;
	var LEPName = false;
	
	// build endpoint URL
	if (allocationid != null && allocationid != "") {
		var serverUrl = Xrm.Page.context.getClientUrl();
		var oDataEndpointUrl = serverUrl + "/XRMServices/2011/OrganizationData.svc/";
		// query oData
		oDataEndpointUrl += "sfa_contractallocationSet?$select=sfa_deliveryorganisationprovider,sfa_LEPName&$filter=(sfa_contractallocationId eq guid'"+allocationid +"')";
		var service = new XMLHttpRequest();
		if (service != null) {
			// execute the request
			service.open("GET", oDataEndpointUrl, false);
			service.setRequestHeader("X-Requested-Width", "XMLHttpRequest");
			service.setRequestHeader("Accept", "application/json,text/javascript, */*");
			service.send(null);
			// parse the results
			var requestResults = eval('(' + service.responseText + ')').d;
			if (requestResults != null && requestResults.results.length > 0) {
				var providerId = requestResults.results[0].sfa_deliveryorganisationprovider.Id;
				if (providerId != null && providerId  != "")  {
					deliveryProvider = true;
				}
				var lepName = requestResults.results[0].sfa_LEPName;
				if (lepName != null && lepName  != "")  {
					LEPName = true;
				}
			} 			
		}
	}
	return {deliveryOrg: deliveryProvider, LEP: LEPName};
}