function formLoad(executionContext) {
	var formContext = executionContext.getFormContext();
	var currentUserRoles = Xrm.Utility.getGlobalContext().userSettings.securityRoles;
	var roleName = "System Administrator";

	GetRoleId(roleName).then(
		function success(requiredRoleId) { 
		//check against user roles
			for (var i = 0; i < currentUserRoles.length; i++) {
				var currRoleId = currentUserRoles[i];
				if (currRoleId == requiredRoleId) {					
					return;
				}
			}
			formContext.getControl("name").setDisabled(true);
			formContext.getControl("description").setDisabled(true);
			formContext.getControl("administratorid").setDisabled(true);
		},
		function (e) {
			Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
		}
	);
}

function GetRoleId(userRoleName) {
	var roleId = null;
	if (userRoleName != null && userRoleName != "") {
		return new Promise(function (resolve, reject) {
			var url = "?$select=roleid&$filter=name eq '" + userRoleName + "'"; 
			Xrm.WebApi.retrieveMultipleRecords("role", url).then(
				function success(result) { 
					if (result != null) {
						roleId = result.entities[0].roleid;					
					} 
					resolve(roleId);
				},
				function (error) {
					reject(error);
				}
			);
		});
	
	}
 }
