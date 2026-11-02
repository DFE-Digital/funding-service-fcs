function formLoad(executionContext) {

	var formContext = executionContext.getFormContext();
	var allocationid = formContext.getAttribute("sfa_contractallocationid").getValue()[0].id;
    var tab = formContext.ui.tabs.get("tabGeneral");

	GetContractAllocationDetail(allocationid).then(
		function success(allocationDetails) {    					
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
		},
		function (e) {
			Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
		}
	);
	
	

}

function GetContractAllocationDetail(allocationid) {
	var deliveryProvider = false;
	var LEPName = false;
	
	// build endpoint URL
	if (allocationid != null && allocationid != "") {
		return new Promise(function (resolve, reject) {
			var url = "?$select=_sfa_deliveryorganisationprovider_value,sfa_lepname"; 
			Xrm.WebApi.retrieveRecord("sfa_contractallocation", allocationid, url).then(
				function success(result) { 
					if (result != null) {
						var providerId = result._sfa_deliveryorganisationprovider_value;
						if (providerId != null && providerId  != "")  {
							deliveryProvider = true;
						}
						var lepName = result.sfa_lepname;
						if (lepName != null && lepName  != "")  {
							LEPName = true;
						}			
					} 

					resolve({deliveryOrg: deliveryProvider, LEP: LEPName});
				},
				function (error) {
					reject(error);
				}
			);
		});
	}		
}