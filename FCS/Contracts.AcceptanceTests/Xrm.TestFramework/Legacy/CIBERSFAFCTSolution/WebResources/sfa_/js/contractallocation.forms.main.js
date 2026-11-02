function formLoad() {

	var deliveryOrganisationProvider = Xrm.Page.getAttribute("sfa_deliveryorganisationprovider").getValue();
	var UoP = Xrm.Page.getAttribute("sfa_unitofprocurementid").getValue();
	var LEP = Xrm.Page.getAttribute("sfa_lepname").getValue();
	var contractid = Xrm.Page.getAttribute("sfa_contractid").getValue()[0].id;
	var contractDetails = ContractDetails(contractid);
	var tab = Xrm.Page.ui.tabs.get("tabGeneral");

	if (deliveryOrganisationProvider !=null) {
		tab.sections.get("tab_details_section_DeliveryOrg").setVisible(true);
	}
	if (UoP !=null) {
		tab.sections.get("tab_details_section_UoP").setVisible(true);
	}
	if (LEP !=null) {
		tab.sections.get("tab_details_section_LEP").setVisible(true);
	}
	if (contractDetails.fundingTypeCode == "ESF") {

                tab.sections.get("section_ESFInformation").setVisible(true);
        }
        if (contractDetails.terminationReason != null)
        {
                 tab.sections.get("section_TerminationDetails").setVisible(true);
         }
}

function ContractDetails(contractid) {
	var fundingTypeCode;
        var terminationReason;
	// build endpoint URL
	if (contractid != null && contractid != "") {
		var serverUrl = Xrm.Page.context.getClientUrl();
		var oDataEndpointUrl = serverUrl + "/XRMServices/2011/OrganizationData.svc/";
		// query oData
		oDataEndpointUrl += "sfa_contractSet?$select=sfa_FundingType,sfa_terminationreason&$filter=(sfa_contractId eq guid'"+contractid +"')";

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
				var fundingTypeId = requestResults.results[0].sfa_FundingType.Id;
				if (fundingTypeId != null && fundingTypeId  != "")  {
					fundingTypeCode = FundingTypeCode(fundingTypeId) ;
				}
                                terminationReason = requestResults.results[0].sfa_terminationreason.Value;
			} 			
		}
	}
	return {terminationReason: terminationReason, fundingTypeCode: fundingTypeCode};
}

function FundingTypeCode(fundingtypeid) {
	var fundingTypeCode;
	// build endpoint URL
	if (fundingtypeid != null && fundingtypeid != "") {
		var serverUrl = Xrm.Page.context.getClientUrl();
		var oDataEndpointUrl = serverUrl + "/XRMServices/2011/OrganizationData.svc/";
		// query oData
		oDataEndpointUrl += "sfa_fundingtypeSet?$select=sfa_fundingtypecode&$filter=(sfa_fundingtypeId eq guid'"+fundingtypeid+"')";

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
				fundingTypeCode = requestResults.results[0].sfa_fundingtypecode;
			} 
		}
	}
	return fundingTypeCode;
}
