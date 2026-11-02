function formLoad(executionContext) {
	var formContext = executionContext.getFormContext();
	var deliveryOrganisationProvider = formContext.getAttribute("sfa_deliveryorganisationprovider").getValue();
	var UoP = formContext.getAttribute("sfa_unitofprocurementid").getValue();
	var LEP = formContext.getAttribute("sfa_lepname").getValue();
	var contractid = formContext.getAttribute("sfa_contractid").getValue()[0].id;
	var tab = formContext.ui.tabs.get("tabGeneral");

	if (deliveryOrganisationProvider !=null) {
		tab.sections.get("tab_details_section_DeliveryOrg").setVisible(true);
	}
	if (UoP !=null) {
		tab.sections.get("tab_details_section_UoP").setVisible(true);
	}
	if (LEP !=null) {
		tab.sections.get("tab_details_section_LEP").setVisible(true);
	}	
	
	ContractDetails(contractid).then(
		function success(contractDetails) {    					
			if (contractDetails.fundingTypeCode == "ESF") {
				tab.sections.get("section_ESFInformation").setVisible(true);
			}
			if (contractDetails.terminationReason != null)
			{
				tab.sections.get("section_TerminationDetails").setVisible(true);
			} else if (contractDetails.newstartsReason != null)
			{
				tab.sections.get("section_ModificationDetails").setVisible(true);
			}
		},
		function (e) {
			Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
		}
	);

}

function ContractDetails(contractid) {
	var fundingTypeCode;
    var terminationReason;
	var newstartsReason;
	
	// build endpoint URL
	if (contractid != null && contractid != "") {
		return new Promise(function (resolve, reject) {
			var url = "?$select=sfa_FundingType,sfa_terminationreason,sfa_defaultnewstartssuspendedreason&$expand=sfa_FundingType($select=sfa_fundingtypecode)"; 
			Xrm.WebApi.retrieveRecord("sfa_contract", contractid, url).then(
				function success(result) { 
					if (result != null) {
						terminationReason = result.sfa_terminationreason;
						newstartsReason = result.sfa_defaultnewstartssuspendedreason;
						if ( result.sfa_FundingType != null) 
						  fundingTypeCode = result.sfa_FundingType.sfa_fundingtypecode;
					} 

					resolve({terminationReason: terminationReason, fundingTypeCode: fundingTypeCode, newstartsReason: newstartsReason});
				},
				function (error) {
					reject(error);
				}
			);
		});
	
	}

}

