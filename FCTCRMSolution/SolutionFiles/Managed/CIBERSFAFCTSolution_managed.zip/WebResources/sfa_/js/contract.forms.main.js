function NextActionValidation(executionContext) {
    //debugger;
    //story 14443 - if user selects "Initiate Publish To Provider" for contract approval type = electronic
	"use strict";
    var formContext = executionContext.getFormContext();
    var nextAction = formContext.getAttribute("sfa_nextaction").getValue();
    var fundingtype = formContext.getAttribute("sfa_fundingtype").getValue();
    var fundingperiod = formContext.getAttribute("sfa_periodid").getValue();

    if (nextAction !== null) {

        if (fundingtype !== null && fundingperiod !== null && nextAction[0].name === "Initiate Manual Publish To Provider") {
            var serverUrl = Xrm.Utility.getGlobalContext().getClientUrl();
				
			var url = "?$select=sfa_approvaltype&$filter=_sfa_fundingperiodid_value eq ('" + fundingperiod[0].id + "') and _sfa_fundingtypeid_value eq ('"+ fundingtype[0].id + "') and statecode eq 0"; 
			Xrm.WebApi.retrieveMultipleRecords("sfa_fundingtypefundingperiod", url).then(
				function success(result) { 
					if (result !== null) {
						var sfa_ApprovalType = result.entities[0].sfa_approvaltype;
						if (sfa_ApprovalType === 229660000) {
							Xrm.Navigation.openConfirmDialog({text:"'Initiate Manual Publication to Provider' is is not permitted for this type of contract"}).then(
								function (success) {
									
                                    if (success.confirmed) {
                                        // formContext.data.entity.save();
                                    } else
                                        formContext.getControl("sfa_nextaction").setFocus();
								});
						}
						else if (sfa_ApprovalType === 229660001) {
							Xrm.Navigation.openConfirmDialog({text:"Initiate 'Confirm Manual Publication to Provider' will stop automated publication of document to provider."}).then(
								function (success) {
									if (success.confirmed) {
                                        // formContext.data.entity.save();
                                    } else
                                        formContext.getControl("sfa_nextaction").setFocus();
								});
						}		
					} else {
						Xrm.Navigation.openAlertDialog("FundingTypeFundingPeriod entity record is not found");
					}

				},
				function (error) {
					Xrm.Navigation.openAlertDialog({text: "There was an issue:"+error.message});
				}
			);
				
		}
    }
}

function formLoad(executionContext) {
	"use strict";
    var formContext = executionContext.getFormContext();
	try {
		var hierarchyType = formContext.getAttribute("sfa_hierarchytype").getValue();
		var serviceResponse = formContext.getAttribute("sfa_serviceresponse").getValue();

		var contractStatus = formContext.getAttribute("sfa_contractstatus").getValue();
		var substatus = formContext.getAttribute("sfa_substatus").getValue();
		if (hierarchyType === 229660000) { // Contract Type

			var tab = formContext.ui.tabs.get("tabGeneral");
			//tab.sections.get("tabGeneral_section1").setVisible(true);
			setVisible(formContext, "sfa_description", true);
			setVisible(formContext, "sfa_parentcontractid", true);
			setVisible(formContext, "sfa_contractvalue", true);
			setVisible(formContext, "sfa_startdate", true);
			setVisible(formContext, "sfa_enddate", true);
			setVisible(formContext, "sfa_latestversion", true);
			setVisible(formContext, "sfa_version", true);
			setVisible(formContext, "sfa_contractstatus", true);
			setVisible(formContext, "sfa_substatus", true);
			setVisible(formContext, "sfa_lastapprovedversion", true);
			setVisible(formContext, "ownerid", true);
			setVisible(formContext, "sfa_nextaction", true);
			setVisible(formContext, "sfa_previousversion", true);
			setVisible(formContext, "sfa_nfainprogress", true);

			tab.sections.get("tabGeneral_section2").setVisible(true);
			tab.sections.get("tabGeneral_ContractAllocations").setVisible(true);
			formContext.ui.tabs.get("tabWorkflowHistory").setVisible(true);
	   
			var termstage = formContext.getAttribute("sfa_terminationinprogress").getValue();
			var contractTerminationReason= formContext.getAttribute("sfa_terminationreason").getValue();
			var contractTerminationInitiated = false;
			if (contractTerminationReason !== null) contractTerminationInitiated = true;
			var contractNewStartsSuspendedReason= formContext.getAttribute("sfa_defaultnewstartssuspendedreason").getValue();
			var contractModificationInitiated = false;
			if (contractNewStartsSuspendedReason !== null) contractModificationInitiated = true;
			
			tab.sections.get("tabGeneral_TerminationDetails").setVisible(false);
			tab.sections.get("tabGeneral_ModificationDetails").setVisible(false);
			tab.sections.get("tabGeneral_ContractAllocationsDO").setVisible(false);
			tab.sections.get("tabGeneral_ContractAllocationsTM").setVisible(false);
			tab.sections.get("tabGeneral_ContractAllocationsMODFN").setVisible(false);		
			tab.sections.get("tabGeneral_ContractAllocationsAll").setVisible(false); 
			tab.sections.get("tabGeneral_ContractAllocationsModAll").setVisible(false); 

			AllocationsHaveDeliveryOrg(formContext).then(
				function success(allocationsHaveDeliveryOrg) {    					
					if ((allocationsHaveDeliveryOrg) &&((contractTerminationInitiated)||(contractModificationInitiated))){
						tab.sections.get("tabGeneral_ContractAllocations").setVisible(false);
						tab.sections.get("tabGeneral_ContractAllocationsDO").setVisible(false);
						tab.sections.get("tabGeneral_ContractAllocationsMODFN").setVisible(false);            
						if (contractTerminationInitiated) {
							tab.sections.get("tabGeneral_TerminationDetails").setVisible(true); 
							tab.sections.get("tabGeneral_ContractAllocationsAll").setVisible(true);
						} else { 
							tab.sections.get("tabGeneral_ModificationDetails").setVisible(true); 
							tab.sections.get("tabGeneral_ContractAllocationsModAll").setVisible(true);
						}
					}  else if (allocationsHaveDeliveryOrg) {
						tab.sections.get("tabGeneral_ContractAllocations").setVisible(false);
						tab.sections.get("tabGeneral_ContractAllocationsDO").setVisible(true);        
					} else if (contractTerminationInitiated) {
						tab.sections.get("tabGeneral_ContractAllocations").setVisible(false);
						tab.sections.get("tabGeneral_ContractAllocationsMODFN").setVisible(false);
						tab.sections.get("tabGeneral_ContractAllocationsTM").setVisible(true);
						tab.sections.get("tabGeneral_TerminationDetails").setVisible(true);
					} else if (contractModificationInitiated) {
						tab.sections.get("tabGeneral_ContractAllocations").setVisible(false);
						tab.sections.get("tabGeneral_ContractAllocationsTM").setVisible(false);
						tab.sections.get("tabGeneral_ContractAllocationsMODFN").setVisible(true);
						tab.sections.get("tabGeneral_TerminationDetails").setVisible(false);			
						tab.sections.get("tabGeneral_ModificationDetails").setVisible(true);
					}
					
				},
				function (e) {
					Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
				}
			); 
			
			if (substatus !== null) {
				if (contractStatus === 229660001) {	
					if (substatus[0].name === "Approved") {
						UserHasTeam("Contract Advisers Team").then( 
							function success(teammember) {    		
								if (teammember) {
										if (termstage  === "TERM_INITIATED") {
											formContext.ui.tabs.get("tab_termdetails").setVisible(true); 
											formContext.ui.tabs.get("tab_modifydetails").setVisible(false);
										} else if (termstage  === "MODFN_INITIATED") { 
											formContext.ui.tabs.get("tab_modifydetails").setVisible(true);
											formContext.ui.tabs.get("tab_termdetails").setVisible(false); 
										} 
								}
							},
							function (e) {
								Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
							}
						);
					}	
					else if ((substatus[0].name === "Under Termination") || (substatus[0].name === "Modified")) {
						UserHasTeam("Contract Managers Team").then(
							function success(teammember) {    					
								if (teammember) {
									if (substatus[0].name === "Under Termination") {
										formContext.ui.tabs.get("tab_termdetails").setVisible(true); 
										formContext.ui.tabs.get("tab_modifydetails").setVisible(false);
									} else if (substatus[0].name === "Modified") { 
										formContext.ui.tabs.get("tab_modifydetails").setVisible(true);
										formContext.ui.tabs.get("tab_termdetails").setVisible(false); 
									} 
								} 
							},
							function (e) {
								Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
							}
						);
					} else {
						formContext.ui.tabs.get("tab_termdetails").setVisible(false);
						formContext.ui.tabs.get("tab_modifydetails").setVisible(false);   	
					}
				
				} else {
					formContext.ui.tabs.get("tab_termdetails").setVisible(false);
					formContext.ui.tabs.get("tab_modifydetails").setVisible(false);   	
				}
			}
		}
		if (hierarchyType !== 229660000) { // Contract Type

			var tab = formContext.ui.tabs.get("tabGeneral");
			//tab.sections.get("tabGeneral_section1").setVisible(true);
			setVisible(formContext, "sfa_description", false);
			setVisible(formContext, "sfa_parentcontractid", false);
			setVisible(formContext, "sfa_contractvalue", false);
			setVisible(formContext, "sfa_startdate", false);
			setVisible(formContext, "sfa_enddate", false);
			setVisible(formContext, "sfa_latestversion", false);
			setVisible(formContext, "sfa_version", false);
			setVisible(formContext, "sfa_contractstatus", false);
			setVisible(formContext, "sfa_substatus", false);
			setVisible(formContext, "sfa_lastapprovedversion", false);
			setVisible(formContext, "ownerid", false);
			setVisible(formContext, "sfa_nextaction", false);
			setVisible(formContext, "sfa_previousversion", false);
			setVisible(formContext, "sfa_nfainprogress", false);

			formContext.ui.tabs.get("tabWorkflowHistory").setVisible(false);
			tab.sections.get("tabGeneral_ContractAllocations").setVisible(false);
			tab.sections.get("tabGeneral_section2").setVisible(false);
		}

		if (substatus !== null) {

			//ContractStatus -- Draft = 229660000
			//ContractStatus -- Approved 229660001
			 if ((contractStatus === 229660001 && hierarchyType === 229660000 && substatus[0].name !== "Awaiting Closure Approval" 
		&& substatus[0].name !== "Awaiting Termination Initiation Approval" && substatus[0].name !== "Awaiting Modification Approval") || substatus[0].name === "Document Merge In Progress") {
				UserHasTeam("FCS Support Team").then(
					function success(teammember) {    					
						if (teammember) {
							 //Xrm.Navigation.openAlertDialog({text: "I am a member of FCS Support team"});
						}
						else {
							setVisible(formContext, "ownerid", false);
							setVisible(formContext, "sfa_nextaction", false);
						}
					},
					function (e) {
						Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
					}
				);
				
			} 
			else if (substatus[0].name === "Published to Provider" && (serviceResponse === 229660005 || serviceResponse === 229660008)) {
				//story 11785 for  DOCUMENT_PUBLISHED_FOR_ELECTRONIC_SIGNOFF = 229660005;
				//   DOCUMENT_PUBLISHED_FOR_AUTO_APPROVAL = 229660008;
				// and substatus = PUBLISHED_TO_PROVIDER = "Published to Provider";
				//hide next action field
				//story 11791 for Contract Managers Team they should be able to see these options
				UserHasTeam("Contract Managers Team").then(
					function success(teammember) {    					
						if (teammember) {
							 //Xrm.Navigation.openAlertDialog({text: "I am a member of Contract Managers Team"});
						}
						else {
							setVisible(formContext, "ownerid", false);
							setVisible(formContext, "sfa_nextaction", false);
						}
					},
					function (e) {
						Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
					}
				);
			
			}	
			else if ((contractStatus !== 229660001 && hierarchyType === 229660000) || substatus[0].name !== "Document Merge In Progress") 
			{
				setVisible(formContext, "ownerid", true);
				setVisible(formContext, "sfa_nextaction", true);
			} 

		}
	} catch (e) {
	   //Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
	}
}

function formSave(executionContext) {
		"use strict";
        var formContext = executionContext.getFormContext();
        var tab = formContext.ui.tabs.get("tabGeneral");
        tab.sections.get("tabGeneral_ReasonForRejection").setVisible(false);
        formContext.ui.controls.get("sfa_reasonforrejection").setVisible(false);
        formContext.getAttribute("sfa_reasonforrejection").setRequiredLevel("none");

}

function NextActionOnChange(executionContext) {
	"use strict";
    var formContext = executionContext.getFormContext();
    var nextAction = formContext.getAttribute("sfa_nextaction").getValue();
    var tab = formContext.ui.tabs.get("tabGeneral");
    var ServiceResponse = formContext.getAttribute("sfa_serviceresponse").getValue();

    if (nextAction !== null && (nextAction[0].name === "Reject"
        || nextAction[0].name === "Revise"
        || nextAction[0].name === "Reject Published Contract"
        || nextAction[0].name === "Withdraw Contract"
        || nextAction[0].name === "Reject Closure"
        || nextAction[0].name === "Reject Termination Initiation"
		|| nextAction[0].name === "Reject Modification"
        || nextAction[0].name === "Withdraw On Behalf Of Provider")) {
        tab.sections.get("tabGeneral_ReasonForRejection").setVisible(true);
        formContext.ui.controls.get("sfa_reasonforrejection").setVisible(true);
        formContext.getAttribute("sfa_reasonforrejection").setRequiredLevel("required");
    }
    else { 
        tab.sections.get("tabGeneral_ReasonForRejection").setVisible(false);
        formContext.ui.controls.get("sfa_reasonforrejection").setVisible(false);
        formContext.getAttribute("sfa_reasonforrejection").setRequiredLevel("none");

    }

    //CRM Bug Fix - Needed to avoid the reason field from displaying when visibility is set to false and control has focus
    if (formContext.getControl("sfa_nextaction").getVisible()) {
      formContext.getControl("sfa_nextaction").setFocus();
    } else {
      formContext.getControl("sfa_contractstatus").setFocus();
    }

}

function setVisible(formContext, controlName, visible) {
	"use strict";
    formContext.ui.controls.get(controlName).setVisible(visible);
}

function UserHasTeam(teamName) {
	"use strict";
	var teamId;
	return new Promise(function (resolve, reject) {
		var url = "?$select=name,teamid&$filter=name eq '"+teamName+"'";
		Xrm.WebApi.retrieveMultipleRecords("team", url).then(
			function success(result) {
				if (result !== null) {
					teamId = result.entities[0].teamid;
					var count = 0;
					var enable = false;
					var userId = Xrm.Utility.getGlobalContext().userSettings.userId.substr(1, 36);
					if (teamId !== null && teamId !== "") {
						var url = "?$filter=systemuserid eq '" + userId + "' and teamid eq '" + teamId + "'";
						Xrm.WebApi.retrieveMultipleRecords("teammembership", url).then(
							function success(result) {
								if (result !== null) {
									count = result.entities.length;
									if(count > 0)
									enable = true;
								} 
								resolve(enable);
							},
							function (error) {
								reject(error);
							}
						);
					}
				}
			}
		);
	});
}

function GuidsAreEqual(guid1, guid2) {
	"use strict";
    // compares two guids
    var isEqual = false;
    if (guid1 === null || guid2 === null) {
        isEqual = false;
    } else {
        isEqual = (guid1.replace(/[{}]/g, "").toLowerCase() === guid2.replace(/[{}]/g, "").toLowerCase());
    }
    return isEqual;
}

function AllocationsHaveDeliveryOrg(formContext) {
	"use strict";
	var contractid = formContext.data.entity.getId();
	var count = 0;
	var allochaveDO = false;
	return new Promise(function (resolve, reject) {
		if (contractid !== null && contractid !== "") {
			var url = "?$select=sfa_contractallocationnumber&$filter=(sfa_ContractId/sfa_contractid eq '"+contractid +"') and (sfa_deliveryorganisationprovider ne null)";
			Xrm.WebApi.retrieveMultipleRecords("sfa_contractallocation", url).then(
				function success(result) {
					if (result !== null) {
						count = result.entities.length;					
					}
					if (count > 0) {
						allochaveDO = true;
					}
					resolve(allochaveDO);
				},
				function (error) {
					reject(error);
				}
			);
		}	
	});
}
