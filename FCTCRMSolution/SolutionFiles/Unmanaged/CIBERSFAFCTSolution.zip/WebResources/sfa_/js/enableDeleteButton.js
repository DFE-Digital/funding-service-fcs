function EnableDeleteButton(executionContext)
{
	var formContext = executionContext;
	var formType = formContext.ui.getFormType();	
	
   //check update form
   if (formType != 2) {
        return false;
   } else {
        if (formContext.getAttribute('sfa_substatus').getValue() != null) {
			var subStatus= formContext.getAttribute('sfa_substatus').getValue()[0].name;
			if ((subStatus== 'In Review') ||(subStatus== 'Awaiting Documentation') ||(subStatus== 'Unassigned'))
			{
				 return true;
			}
			if  (subStatus== 'Delete In Progress') {

				var userRoleName = "System Administrator";
				return CheckUserRole(userRoleName);
			}
        }  
   }
   return false;
}


function EnableInitiateClosureButton(executionContext)
{
		var formContext = executionContext;
        if (formContext.getAttribute('sfa_substatus').getValue() != null) {
			var contractStatus = formContext.getAttribute("sfa_contractstatus").getValue();
			var subStatus= formContext.getAttribute('sfa_substatus').getValue()[0].name;

            //ContractStatus -- Approved 229660001
			if ((contractStatus == "229660001") && ((subStatus == 'Approved') || (subStatus == 'Modified')))
			{
				 return true;
			}               
        }  

          return false;
}

function EnableInitiateAmendmentButton(executionContext)
{
		var formContext = executionContext;
        if (formContext.getAttribute('sfa_substatus').getValue() != null) {
            var contractStatus = formContext.getAttribute("sfa_contractstatus").getValue();
			var subStatus= formContext.getAttribute('sfa_substatus').getValue()[0].name;               

            //ContractStatus -- Approved 229660001
			if ((contractStatus == "229660001") && ((subStatus== 'Approved')||(subStatus== 'Under Termination')||(subStatus== 'Modified')))
			{
				 var amendmentInProgress = formContext.getAttribute("sfa_nfainprogress").getValue();
				 if (amendmentInProgress == true) 
				 {
				  
					var userRoleName = "System Administrator";
					return CheckUserRole(userRoleName);

				 }  
				 return true;
			}               
        }  
        return false;
}

function EnableInitiateTerminateButton(executionContext)
{
	var formContext = executionContext;
    if (formContext.getAttribute('sfa_substatus').getValue() != null) {
        var contractStatus = formContext.getAttribute("sfa_contractstatus").getValue();
		var subStatus= formContext.getAttribute('sfa_substatus').getValue()[0].name;
        var latestVersion = formContext.getAttribute("sfa_latestversion").getValue();

        if (latestVersion == 1)	{
            //ContractStatus -- Approved 229660001
		    if ((contractStatus == "229660001") &&(subStatus== 'Approved'))
		    {
		        return true;
		    } 
        }              
    }  
    return false;
}

function EnableInitiateModifyButton(executionContext)
{   
	var formContext = executionContext;
	if (formContext.getAttribute('sfa_substatus').getValue() != null) {
		var contractStatus = formContext.getAttribute("sfa_contractstatus").getValue();
		var subStatus= formContext.getAttribute('sfa_substatus').getValue()[0].name;
		var latestVersion = formContext.getAttribute("sfa_latestversion").getValue();

		if (latestVersion == 1)	{
			//ContractStatus -- Approved 229660001
			if ((contractStatus == "229660001") &&(subStatus== 'Approved'))
			{
				return true;
			} 
		}              
	}  
	return false;
}

function CheckUserRole(userRoleName) {
    var currentUserRoles = Xrm.Utility.getGlobalContext().userSettings.roles.getAll();
	var enable = false;
	var requiredRoleId = null;
	for (var i = 0; i < currentUserRoles.length; i++) {
		var roleName = currentUserRoles[i].name;
		if (userRoleName == roleName) {
			enable = true;
			break;
		}
	}
	return (enable);
}

// determine Team Visibility for Amend
// needs UserHasTeam() from Contract Main Form Script
function checkAmendTeamVisibility() {
    return UserHasTeam('Contract Managers Team').then(
			(result) => {
							if (result) return true;
							else return UserHasTeam('Document Management Team');
						});

}

// determine Team Visibility for Closure
function checkClosureTeamVisibility() {
    return UserHasTeam('Contract Advisers Team');
}

// determine Team Visibility for the Delete
// needs UserHasTeam() from Contract Main Form Script
function checkDeleteTeamVisibility() {
	return UserHasTeam('Lead Manager Team').then(
			(result) => {
							if (result) return true;
							else return UserHasTeam('Document Management Team');
						});

}

// determine Team Visibility for the Bulk Revise
function checkBulkReviseTeamVisibility() {

	return UserHasTeam('Contract Managers Team').then(
			(result) => {
							if (result) return true;
							else return UserHasTeam('Lead Manager Team').then(
								(result) => {
												if (result) return true;
												else return UserHasTeam('Document Management Team');
											});
						});

}

// determine Team Visibility for Termination Initiation
function checkTerminationAdviserTeamVisibility() {
    return UserHasTeam('Contract Advisers Team');
}

// determine Team Visibility for Termination Updates
function checkTerminationUpdateTeamVisibility() {
    return UserHasTeam('Contract Managers Team');
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
