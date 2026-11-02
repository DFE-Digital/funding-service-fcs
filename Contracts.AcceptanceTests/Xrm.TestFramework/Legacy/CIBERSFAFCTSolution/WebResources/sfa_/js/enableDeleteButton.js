function EnableDeleteButton()
{
   var formType = Xrm.Page.ui.getFormType();
   
   //check update form
   if (formType != 2) {
        return false;
   } else {
           if (Xrm.Page.getAttribute('sfa_substatus').getValue() != null) {
		var subStatus= Xrm.Page.getAttribute('sfa_substatus').getValue()[0].name;
		if ((subStatus== 'In Review') ||(subStatus== 'Awaiting Documentation') ||(subStatus== 'Unassigned'))
		{
		     return true;
		}
                if  (subStatus== 'Delete In Progress') {
                    var adminCheck=CheckUserRole("System Administrator");
                    if  (adminCheck == true) {
                        return true;
                    }
                }
           }  
   }
   return false;
}

function EnableInitiateClosureButton()
{
           if (Xrm.Page.getAttribute('sfa_substatus').getValue() != null) {
                var contractStatus = Xrm.Page.getAttribute("sfa_contractstatus").getValue();
		var subStatus= Xrm.Page.getAttribute('sfa_substatus').getValue()[0].name;
                var terminationDate= Xrm.Page.getAttribute('sfa_terminationdate').getValue();
                //ContractStatus -- Approved 229660001
		if ((contractStatus == "229660001") && ((subStatus== 'Approved') || ((subStatus== 'Under Termination') && (terminationDate == null))))
		{
		     return true;
		}               
           }  

          return false;
}

function EnableInitiateAmendmentButton()
{
           if (Xrm.Page.getAttribute('sfa_substatus').getValue() != null) {
                var contractStatus = Xrm.Page.getAttribute("sfa_contractstatus").getValue();
		var subStatus= Xrm.Page.getAttribute('sfa_substatus').getValue()[0].name;               

                //ContractStatus -- Approved 229660001
		if ((contractStatus == "229660001") && ((subStatus== 'Approved')||(subStatus== 'Under Termination')))
		{
                     var amendmentInProgress = Xrm.Page.getAttribute("sfa_nfainprogress").getValue();
                     if (amendmentInProgress == true) 
                     {
                         var adminCheck=CheckUserRole("System Administrator");
                         if  (adminCheck == true) {
                               return true;
                         }
                         return false;
                     }  
                     return true;
		}               
           }  
          return false;
}

function EnableInitiateTerminationButton()
{
           if (Xrm.Page.getAttribute('sfa_substatus').getValue() != null) {
                var contractStatus = Xrm.Page.getAttribute("sfa_contractstatus").getValue();
		var subStatus= Xrm.Page.getAttribute('sfa_substatus').getValue()[0].name;
                //ContractStatus -- Approved 229660001
		if ((contractStatus == "229660001") &&(subStatus== 'Approved'))
		{
		     return true;
		}               
           }  
          return false;
}

function EnableUpdateTerminationButton()
{
           if (Xrm.Page.getAttribute('sfa_substatus').getValue() != null) {
                var contractStatus = Xrm.Page.getAttribute("sfa_contractstatus").getValue();
		var subStatus= Xrm.Page.getAttribute('sfa_substatus').getValue()[0].name;
                //ContractStatus -- Approved 229660001
		if ((contractStatus == "229660001") &&(subStatus== 'Under Termination'))
		{
		     return true;
		}               
           }  
          return false;
}

function CheckUserRole(roleName) {
    var currentUserRoles = Xrm.Page.context.getUserRoles();
    for (var i = 0; i < currentUserRoles.length; i++) {
        var userRoleId = currentUserRoles[i];
         var userRoleName = GetRoleName(userRoleId);
         if (userRoleName == roleName) {
            return true;
         }
    }
    return false;
}

function GetRoleName(userRoleId) {
     var selectQuery = "RoleSet?$top=1&$filter=RoleId eq guid'" + userRoleId + "'&$select=Name";
     var odataSelect = Xrm.Page.context.getClientUrl() + "/XRMServices/2011/OrganizationData.svc/"+selectQuery;
     var roleName = null;
     var service = new XMLHttpRequest();
     if (service != null) {
        service.open("GET", odataSelect, false);
        service.setRequestHeader("X-Requested-Width", "XMLHttpRequest");
        service.setRequestHeader("Accept", "application/json,text/javascript, */*");
        service.send(null);
        var requestResults = eval('(' + service.responseText + ')').d;
        if (requestResults != null && requestResults.results.length > 0) {
            roleName = requestResults.results[0].Name;
        }
    }
     return roleName;
 }

// determine Team Visibility for Amend
// needs UserHasTeam() from Contract Main Form Script
function checkAmendTeamVisibility() {
    if (UserHasTeam('Contract Managers Team')||UserHasTeam('Document Management Team')) {
        return true;
    } else {
        return false;
    }
}

// determine Team Visibility for Closure
// needs UserHasTeam() from Contract Main Form Script
function checkClosureTeamVisibility() {
    if (UserHasTeam('Contract Advisers Team')) {
        return true;
    } else {
        return false;
    }
}

// determine Team Visibility for Delete
// needs UserHasTeam() from Contract Main Form Script
function checkDeleteTeamVisibility() {
    if (UserHasTeam('Lead Manager Team')||UserHasTeam('Document Management Team')) {
        return true;
    } else {
        return false;
    }
}

// determine Team Visibility for Termination Initiation
function checkTerminationAdviserTeamVisibility() {
    if (UserHasTeam('Contract Advisers Team')) {
        return true;
    } else {
        return false;
    }
}

// determine Team Visibility for Termination Updates
function checkTerminationUpdateTeamVisibility() {
    if (UserHasTeam('Contract Managers Team')) {
        return true;
    } else {
        return false;
    }
}
