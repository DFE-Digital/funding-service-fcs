function RunListReleaseGroupWorkflow(selectedItems) { 
    var action = "Release the selected Funding Allocation Groups";
	if (selectedItems.length == 1) {
	    ReleaseGroupStatus(selectedItems[0].Id).then(
			function success(releasestate) {    					
				if ((releasestate.releasestatus != 229660000)||(releasestate.releasecount == 0)) {
					Xrm.Navigation.openAlertDialog({text: "This Release Group is not in the correct state for Release. It has either been released before or has no Funding Allocations associated with it"});
				} else {
					executeListAction(selectedItems, action);
				}
			},
			function (e) {
				Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
			}
		);
	   
	} else {
		executeListAction(selectedItems, action);
	}

}

function ReleaseGroupStatus(releaseGroupId) {
    var releaseStatus;
	var releaseCount;
	//build endpoint URL
	if (releaseGroupId != null && releaseGroupId != "") {	
		return new Promise(function (resolve, reject) {
			var url = "?$select=sfa_releasestatus,sfa_associatedcount"; 
			Xrm.WebApi.retrieveRecord("sfa_releasegroup", releaseGroupId, url).then(
				function success(result) { 
					if (result != null) {
						releaseStatus = result.sfa_releasestatus;
						releaseCount = result.sfa_associatedcount;		
					} 

					resolve({releasestatus: releaseStatus,releasecount: releaseCount});
				},
				function (error) {
					reject(error);
				}
			);
		});
	}
}

function executeListAction(selectedItems, action) {
    var confirmOptions = { height: 200, width: 600 };
    Xrm.Navigation.openConfirmDialog({text: "Are you sure you want to "+action}, confirmOptions).then(
    function (success) {
	    if (success.confirmed) {
			try {
				Xrm.Utility.showProgressIndicator("Processing");
				var selectedIDs = "";
                selectedIDs = selectedItems.map(e => e.Id ).join(";");
				
                ReleaseGroups(selectedIDs);
			} catch (e) {
				 Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
			}
		}
	});
}

function ReleaseGroups(inpIds) {
	
    ////using action
    var req = {};
	req.inputIDs = inpIds;

	req.getMetadata = function () {
        return {
            parameterTypes: {
				"inputIDs": { typeName: "Edm.String", structuralProperty: 1 },
            },
            operationType: 0,
            operationName: "sfa_FundingAllocationRelease"
        };
    };

    Xrm.WebApi.online.execute(req).then( 
        function (result) { 
            if (result.ok) { 
					var lookupOptions = { entityType: "sfa_releasegroup" };
                    setTimeout(() => {  Xrm.Utility.closeProgressIndicator(); Xrm.Utility.refreshParentGrid(lookupOptions); }, 2000);
            }               

        },
        function (error) { 
            var errMsg = error.message; 
	        Xrm.Navigation.openAlertDialog({text: "error:"+errMsg});
        }
    );
}

// determine Team Visibility for Ready to Release
function CheckReleaseTeamVisibility() {

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
