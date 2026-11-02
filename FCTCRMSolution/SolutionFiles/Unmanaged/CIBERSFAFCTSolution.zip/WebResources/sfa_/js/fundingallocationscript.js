function RunListToHoldAllocations(selectedItems) { 
    var selectedIDs = "";
	var errMsg = "This Funding Allocation cannot be Held. It may be in the process of being Released or in some other state that prohibits being Held";
    try {
		if (selectedItems.length == 1) {
			FundingAllocationState(selectedItems[0].Id).then(
				function success(fundingAllocState) { 			
					if ((fundingAllocState.SubStatus == 229660000) && (fundingAllocState.RGStatus != 229660000)) {
						Xrm.Navigation.openAlertDialog({text: errMsg});
						return;
					} else if ((fundingAllocState.SubStatus != 229660000) && (fundingAllocState.SubStatus != 229660004))  {
						Xrm.Navigation.openAlertDialog({text: errMsg});
						return;
					} else {
						selectedIDs = selectedItems.map(e => e.Id ).join(";");		
						Xrm.Navigation.navigateTo({pageType:"webresource", webresourceName:"sfa_fundingallocationhold", data: selectedIDs}, {target: 2, position: 1,  height: 250, width: 450});
					}
				},
				function (e) {
					Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
				}
			);		
		} else {		
			selectedIDs = selectedItems.map(e => e.Id ).join(";");		
			Xrm.Navigation.navigateTo({pageType:"webresource", webresourceName:"sfa_fundingallocationhold", data: selectedIDs}, {target: 2, position: 1,  height: 250, width: 450});
		}
	} catch (e) {
		 Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
	}
}

function RunListToWithdrawAllocations(selectedItems) { 
    var selectedIDs = "";
	var errMsg = "This Funding Allocation cannot be Withdrawn. It may be in the process of being Released or in some other state that prohibits Withdrawal";
    try {
		if (selectedItems.length == 1) {
			FundingAllocationState(selectedItems[0].Id).then(
				function success(fundingAllocState) {    					
					if ((fundingAllocState.SubStatus == 229660000) && (fundingAllocState.RGStatus != 229660000)) {
						Xrm.Navigation.openAlertDialog({text: errMsg});
						return;
					} else if ((fundingAllocState.SubStatus != 229660000) && (fundingAllocState.SubStatus != 229660010)) {
						Xrm.Navigation.openAlertDialog({text: errMsg});
						return;
					} else {
						selectedIDs = selectedItems.map(e => e.Id ).join(";");		
						Xrm.Navigation.navigateTo({pageType:"webresource", webresourceName:"sfa_fundingallocationwithdrawal", data: selectedIDs}, {target: 2, position: 1,  height: 250, width: 450});
					}
				},
				function (e) {
					Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
				}
			);			
							
		} else {		
			selectedIDs = selectedItems.map(e => e.Id ).join(";");		
			Xrm.Navigation.navigateTo({pageType:"webresource", webresourceName:"sfa_fundingallocationwithdrawal", data: selectedIDs}, {target: 2, position: 1,  height: 250, width: 450});
		}
	} catch (e) {
		 Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
	}
}

function FundingAllocationState(faId) {
    var fundingallocSubStatus;
	var associatedRGStatus="NA";
	// build endpoint URL
	if (faId != null && faId != "") {
		return new Promise(function (resolve, reject) {
			var url = "?$select=sfa_substatus,sfa_releasegroup&$expand=sfa_releasegroup($select=sfa_releasestatus)"; 
			Xrm.WebApi.retrieveRecord("sfa_fundingallocation", faId, url).then(
				function success(result) { 
					if (result != null) { 
						fundingallocSubStatus = result.sfa_substatus;
						if (result.sfa_releasegroup != null) {
							associatedRGStatus = result.sfa_releasegroup.sfa_releasestatus;
						}
					} 
					resolve({SubStatus: fundingallocSubStatus,RGStatus: associatedRGStatus});
				},
				function (error) {
					reject(error);
				}
			);
		});

	} 
}

function RunListReleaseHeldAllocations(selectedItems) { 
    var workflowId = '73031D2A-EB42-4431-A1B6-B938737A60F9';
    var action = "release the Hold on the selected Funding Allocations?";
	var errMsg = "This Funding Allocation cannot be Released from Hold as it is not on Hold";
				
	try {
		if (selectedItems.length == 1) {
			FundingAllocationState(selectedItems[0].Id).then(
				function success(fundingAllocState) {    					
					if (fundingAllocState.SubStatus != 229660004) {
						Xrm.Navigation.openAlertDialog({text: errMsg});
						return;
					} else {
						executeListAction(selectedItems, "sfa_fundingallocation",action, workflowId);
					}
				},
				function (e) {
					Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
				}
			);				
		} else {
			executeListAction(selectedItems, "sfa_fundingallocation",action, workflowId);
		}
	} catch (e) {
		 Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
	}
}

function RunListReinstateAllocations(selectedItems) { 
    var workflowId = '3f909e65-08cc-42ba-8411-308386b7f956';
    var action = "reinstate the selected Funding Allocations?";
	var errMsg = "This Funding Allocation cannot be reinstated to 'Awaiting Release' as it does not have a sub status of 'Returned to Scheduling'";
	
	try {
		if (selectedItems.length == 1) {
			FundingAllocationState(selectedItems[0].Id).then(
				function success(fundingAllocState) {    					
					if (fundingAllocState.SubStatus != 229660010) {
						Xrm.Navigation.openAlertDialog({text: errMsg});
						return;
					} else {
						executeListAction(selectedItems, "sfa_fundingallocation",action, workflowId);
					}
				},
				function (e) {
					Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
				}
			);			
		
		} else {
			executeListAction(selectedItems, "sfa_fundingallocation",action, workflowId);
		}
	} catch (e) {
		Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
	}
}

function executeListAction(selectedItems, entityName, action, workflowId) {
    var confirmOptions = { height: 200, width: 600 };
    var workflowRequests = []; // array
    Xrm.Navigation.openConfirmDialog({text: "Are you sure you want to "+action}, confirmOptions).then(
    function (success) {
	    if (success.confirmed) {
			try {
				Xrm.Utility.showProgressIndicator("Processing");

				for (var i=0; i < selectedItems.length;i++ ) { 
					var entityId = selectedItems[i].Id;
					//make the request
					workflowRequests.push(new MakeWorkflowRequest(entityId, workflowId));
				}
				executeWorkflow(workflowRequests, entityName);

			} catch (e) {
                 Xrm.Utility.closeProgressIndicator();
				 Xrm.Navigation.openAlertDialog({text: "There was an issue: "+e.message});
			}
		}
	});
}

function MakeWorkflowRequest(recId, workflowId) {
    this.EntityId = {
        "guid": recId
    };
    this.entity = {
        id: workflowId,
        entityType: "workflow"
    };
    this.getMetadata = function () {
        return {
            boundParameter: "entity",
            parameterTypes: {
                "entity": {
                    "typeName": "Microsoft.Dynamics.CRM.workflow",
                    "structuralProperty": 5
                },
                "EntityId": {
                    "typeName": "Edm.Guid",
                    "structuralProperty": 1
                }
            },
            operationType: 0,
            operationName: "ExecuteWorkflow",
        };
    };
};

function executeWorkflow(requestObject, entityName) {
    Xrm.WebApi.online.executeMultiple(requestObject).then(
        function (result) { 

			var lookupOptions = { entityType: entityName };
			setTimeout(() => {  Xrm.Utility.closeProgressIndicator(); Xrm.Utility.refreshParentGrid(lookupOptions); }, 2000);           

        },
        function (error) {
            //error callback
			var error = JSON.parse(this.response).error;
			Xrm.Utility.closeProgressIndicator();
			Xrm.Navigation.openAlertDialog({text: "There was an issue with the attempted action. Please check status of record or try later"+error.message });
        });
}

//determine Team Visibility for Hold
function CheckFATeamVisibility() {
    return UserHasTeam('Contract Control Management Team');
}

function UserHasTeam(teamName) {
	var teamId;
	return new Promise(function (resolve, reject) {
		var url = "?$select=name,teamid&$filter=name eq '"+teamName+"'";
		Xrm.WebApi.retrieveMultipleRecords("team", url).then(
			function success(result) {
				if (result != null) {
					teamId = result.entities[0].teamid;
					var count = 0;
					var enable = false;
					var userId = Xrm.Utility.getGlobalContext().userSettings.userId.substr(1, 36);
					if (teamId != null && teamId != "") {
						var url = "?$filter=systemuserid eq '" + userId + "' and teamid eq '" + teamId + "'";
						Xrm.WebApi.retrieveMultipleRecords("teammembership", url).then(
							function success(result) {
								if (result != null) {
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
