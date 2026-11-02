// JavaScript source code.
///<reference path="../../vsdoc/XrmPage-vsdoc.js" />

function NextActionValidation() {
    //debugger;
    //story 14443 - if user selects "Initiate Publish To Provider" for contract approval type = electrnoic
    var nextAction = Xrm.Page.getAttribute("sfa_nextaction").getValue();
    var fundingtype = Xrm.Page.getAttribute("sfa_fundingtype").getValue();
    var fundingperiod = Xrm.Page.getAttribute("sfa_periodid").getValue();

    if (nextAction != null) {

        if (fundingtype != null && fundingperiod != null && nextAction[0].name == "Initiate Manual Publish To Provider") {
            var req = new XMLHttpRequest();
            req.open("GET", Xrm.Page.context.getClientUrl() + "/XRMServices/2011/OrganizationData.svc/sfa_fundingtypefundingperiodSet?$select=sfa_ApprovalType&$filter=sfa_FundingPeriodId/Id eq (guid'"
                + fundingperiod[0].id + "') and sfa_FundingTypeId/Id eq (guid'"
                + fundingtype[0].id + "') and statecode/Value eq 0", true);

            req.setRequestHeader("Accept", "application/json");
            req.setRequestHeader("Content-Type", "application/json; charset=utf-8");
            req.onreadystatechange = function () {
                if (this.readyState === 4) {
                    this.onreadystatechange = null;
                    if (this.status === 200) {
                        var returned = JSON.parse(this.responseText).d;
                        var results = returned.results;

                        if (results[0] != null) {
                            var sfa_ApprovalType = results[0].sfa_ApprovalType;

                            //alert(sfa_ApprovalType.Value);

                            if (sfa_ApprovalType.Value == 229660000) {
                                Xrm.Utility.confirmDialog("‘Initiate Manual Publication to Provider’ is is not permitted for this type of contract",
                                    function () {
                                        // Xrm.Page.data.entity.save();
                                    },
                                      function () {
                                          Xrm.Page.getControl("sfa_nextaction").setFocus();
                                      });
                            }
                            else if (sfa_ApprovalType.Value == 229660001) {
                                Xrm.Utility.confirmDialog("Initiate 'Confirm Manual Publication to Provider' will stop automated publication of document to provider.",
                                    function () {
                                        // Xrm.Page.data.entity.save();
                                    },
                                      function () {
                                          Xrm.Page.getControl("sfa_nextaction").setFocus();
                                      });
                            }
                        }
                        else {
                            alert("FundingTypeFundingPeriod entity is not found");
                        }
                    }

                }
                else {

                    // alert(this.statusText);
                }
            }
            req.send();
        };

    }

}

function formLoad() {

    var hierarchyType = Xrm.Page.getAttribute("sfa_hierarchytype").getValue();
    var serviceResponse = Xrm.Page.getAttribute("sfa_serviceresponse").getValue();

    var contractStatus = Xrm.Page.getAttribute("sfa_contractstatus").getValue();
    var substatus = Xrm.Page.getAttribute("sfa_substatus").getValue();
    if (hierarchyType == 229660000) { // Contract Type

        var tab = Xrm.Page.ui.tabs.get("tabGeneral");
        //tab.sections.get("tabGeneral_section1").setVisible(true);
        setVisible("sfa_description", true);
        setVisible("sfa_parentcontractid", true);
        setVisible("sfa_contractvalue", true);
        setVisible("sfa_startdate", true);
        setVisible("sfa_enddate", true);
        setVisible("sfa_latestversion", true);
        setVisible("sfa_version", true);
        setVisible("sfa_contractstatus", true);
        setVisible("sfa_substatus", true);
        setVisible("sfa_lastapprovedversion", true);
        setVisible("ownerid", true);
        setVisible("sfa_nextaction", true);
        setVisible("sfa_previousversion", true);
        setVisible("sfa_nfainprogress", true);

        tab.sections.get("tabGeneral_section2").setVisible(true);
        tab.sections.get("tabGeneral_ContractAllocations").setVisible(true);
        Xrm.Page.ui.tabs.get("tabWorkflowHistory").setVisible(true);
        var allocationsHaveDeliveryOrg= AllocationsHaveDeliveryOrg();
        var contractTerminationInfo= GetContractTerminationInfo();
        var contractTerminationInitiated= contractTerminationInfo.terminationinprogress;
        tab.sections.get("tabGeneral_TerminationDetails").setVisible(false);
        tab.sections.get("tabGeneral_ContractAllocationsDO").setVisible(false);
        tab.sections.get("tabGeneral_ContractAllocationsTM").setVisible(false); 
        tab.sections.get("tabGeneral_ContractAllocationsAll").setVisible(false); 

        if ((allocationsHaveDeliveryOrg) &&(contractTerminationInitiated)){
            tab.sections.get("tabGeneral_ContractAllocations").setVisible(false);
            tab.sections.get("tabGeneral_ContractAllocationsDO").setVisible(false);
            tab.sections.get("tabGeneral_ContractAllocationsAll").setVisible(true);
             tab.sections.get("tabGeneral_TerminationDetails").setVisible(true); 
             if (contractTerminationInfo.substatus != "Awaiting Termination Initiation Approval")  {
                  setVisible("sfa_initiateamendment", false);
             }  else {  setVisible("sfa_initiateamendment", true);  }
        }  else if (allocationsHaveDeliveryOrg) {
            tab.sections.get("tabGeneral_ContractAllocations").setVisible(false);
            tab.sections.get("tabGeneral_ContractAllocationsDO").setVisible(true);        
        } else if (contractTerminationInitiated) {
            tab.sections.get("tabGeneral_ContractAllocations").setVisible(false);
            tab.sections.get("tabGeneral_ContractAllocationsTM").setVisible(true);
            tab.sections.get("tabGeneral_TerminationDetails").setVisible(true);
            if (contractTerminationInfo.substatus != "Awaiting Termination Initiation Approval")  {
                  setVisible("sfa_initiateamendment", false);
             }  else {  setVisible("sfa_initiateamendment", true);  }
        } 
    }
    if (hierarchyType != 229660000) { // Contract Type

        var tab = Xrm.Page.ui.tabs.get("tabGeneral");
        //tab.sections.get("tabGeneral_section1").setVisible(true);
        setVisible("sfa_description", false);
        setVisible("sfa_parentcontractid", false);
        setVisible("sfa_contractvalue", false);
        setVisible("sfa_startdate", false);
        setVisible("sfa_enddate", false);
        setVisible("sfa_latestversion", false);
        setVisible("sfa_version", false);
        setVisible("sfa_contractstatus", false);
        setVisible("sfa_substatus", false);
        setVisible("sfa_lastapprovedversion", false);
        setVisible("ownerid", false);
        setVisible("sfa_nextaction", false);
        setVisible("sfa_previousversion", false);
        setVisible("sfa_nfainprogress", false);

        Xrm.Page.ui.tabs.get("tabWorkflowHistory").setVisible(false);
        tab.sections.get("tabGeneral_ContractAllocations").setVisible(false);
        tab.sections.get("tabGeneral_section2").setVisible(false);
    }

    if (substatus != null) {

        //ContractStatus -- Draft = 229660000
        //ContractStatus -- Approved 229660001

        if ((contractStatus == "229660001" && hierarchyType == 229660000 && substatus[0].name != "Awaiting Closure Approval" 
&& substatus[0].name != "Awaiting Termination Initiation Approval") || substatus[0].name == "Document Merge In Progress") {
            if (UserHasTeam("FCS Support Team")) {

                //  alert("I am a memeber of FCS Support team");

            }
            else {
                setVisible("ownerid", false);
                setVisible("sfa_nextaction", false);

            }
        }
        else if ((contractStatus != "229660001" && hierarchyType == 229660000) || substatus[0].name != "Document Merge In Progress") 
        {
            setVisible("ownerid", true);
            setVisible("sfa_nextaction", true);
        }

        //story 11785 for  DOCUMENT_PUBLISHED_FOR_ELECTRONIC_SIGNOFF = 229660005;
        //   DOCUMENT_PUBLISHED_FOR_AUTO_APPROVAL = 229660008;
        // and substatus = PUBLISHED_TO_PROVIDER = "Published to Provider";
        //hide next action field


        //story 11791 for Contract Managers Team they should be able to see these options

        if (substatus[0].name == "Published to Provider" && (serviceResponse == 229660005 || serviceResponse == 229660008)) {
            if (UserHasTeam("Contract Managers Team")) {

                //  alert("I am a memeber of Contract Managers Team");

            } else {

                setVisible("ownerid", false);
                setVisible("sfa_nextaction", false);
            }
        }
    }

}

function NextActionOnChange() {
    var nextAction = Xrm.Page.getAttribute("sfa_nextaction").getValue();
    var tab = Xrm.Page.ui.tabs.get("tabGeneral");
    var ServiceResponse = Xrm.Page.getAttribute("sfa_serviceresponse").getValue();

    if (nextAction != null && (nextAction[0].name == "Reject"
        || nextAction[0].name == "Revise"
        || nextAction[0].name == "Reject Published Contract"
        || nextAction[0].name == "Withdraw Contract"
        || nextAction[0].name == "Reject Closure"
        || nextAction[0].name == "Reject Termination Initiation"
        || nextAction[0].name == "Withdraw On Behalf Of Provider")) {
        tab.sections.get("tabGeneral_ReasonForRejection").setVisible(true);
        Xrm.Page.ui.controls.get("sfa_reasonforrejection").setVisible(true);
        Xrm.Page.getAttribute("sfa_reasonforrejection").setRequiredLevel("required");
    }
    else {
        tab.sections.get("tabGeneral_ReasonForRejection").setVisible(false);
        Xrm.Page.ui.controls.get("sfa_reasonforrejection").setVisible(false);
        Xrm.Page.getAttribute("sfa_reasonforrejection").setRequiredLevel("none");

    }

    //CRM Bug Fix - Needed to avoid the reason field from displaying when visibility is set to false and control has focus
    if (Xrm.Page.getControl("sfa_nextaction").getVisible()) {
      Xrm.Page.getControl("sfa_nextaction").setFocus();
    } else {
      Xrm.Page.getControl("sfa_contractstatus").setFocus();
    }

}

function setVisible(controlName, visible) {
    Xrm.Page.ui.controls.get(controlName).setVisible(visible);
}



function UserHasTeam(teamName) {
    ///<summary>
    /// Checks to see if the current user is a member of a team with the passed in name.
    ///</summary>
    ///<param name="teamName" type="String">
    /// A String representing the name of the team to check if the user is a member of.
    ///</param>
    if (teamName != null && teamName != "") {
        // build endpoint URL
        var serverUrl = Xrm.Page.context.getClientUrl();
        var oDataEndpointUrl = serverUrl + "/XRMServices/2011/OrganizationData.svc/";
        // query to get the teams that match the name
        oDataEndpointUrl += "TeamSet?$select=Name,TeamId&$filter=Name eq '" + teamName + "'";
        var service = GetRequestObject();
        if (service != null) {
            // execute the request
            service.open("GET", oDataEndpointUrl, false);
            service.setRequestHeader("X-Requested-Width", "XMLHttpRequest");
            service.setRequestHeader("Accept", "application/json,text/javascript, */*");
            service.send(null);
            // parse the results
            var requestResults = eval('(' + service.responseText + ')').d;
            if (requestResults != null && requestResults.results.length > 0) {
                var teamCounter;
                // iterate through all of the matching teams, checking to see if the current user has a membership
                for (teamCounter = 0; teamCounter < requestResults.results.length; teamCounter++) {
                    var team = requestResults.results[teamCounter];
                    var teamId = team.TeamId;
                    // get current user teams
                    var currentUserTeams = getUserTeams(teamId);
                    // Check whether current user teams matches the target team
                    if (currentUserTeams != null) {
                        for (var i = 0; i < currentUserTeams.length; i++) {
                            var userTeam = currentUserTeams[i];
                            // check to see if the team guid matches the user team membership id
                            if (GuidsAreEqual(userTeam.TeamId, teamId)) {
                                return true;
                            }
                        }
                    } else {
                        return false;
                    }
                }
            } else {
                alert("Team with name '" + teamName + "' not found");
                return false;
            }
            return false;
        }
    } else {
        alert("No team name passed");
        return false;
    }
}

function getUserTeams(teamToCheckId) {
    // gets the current users team membership
    var userId = Xrm.Page.context.getUserId().substr(1, 36);
    var serverUrl = Xrm.Page.context.getClientUrl();
    var oDataEndpointUrl = serverUrl + "/XRMServices/2011/OrganizationData.svc/";
    oDataEndpointUrl += "TeamMembershipSet?$filter=SystemUserId eq guid' " + userId + " ' and TeamId eq guid' " + teamToCheckId + " '";
    var service = GetRequestObject();
    if (service != null) {
        service.open("GET", oDataEndpointUrl, false);
        service.setRequestHeader("X-Requested-Width", "XMLHttpRequest");
        service.setRequestHeader("Accept", "application/json,text/javascript, */*");
        service.send(null);
        var requestResults = eval('(' + service.responseText + ')').d;
        if (requestResults != null && requestResults.results.length > 0) {
            return requestResults.results;
        }
    }
}
function GetRequestObject() {
    if (window.XMLHttpRequest) {
        return new window.XMLHttpRequest;
    } else {
        try {
            return new ActiveXObject("MSXML2.XMLHTTP.3.0");
        } catch (ex) {
            return null;
        }
    }
}

function GuidsAreEqual(guid1, guid2) {
    // compares two guids
    var isEqual = false;
    if (guid1 == null || guid2 == null) {
        isEqual = false;
    } else {
        isEqual = (guid1.replace(/[{}]/g, "").toLowerCase() == guid2.replace(/[{}]/g, "").toLowerCase());
    }
    return isEqual;
}

function AllocationsHaveDeliveryOrg() {
	var contractid = Xrm.Page.data.entity.getId();
	// build endpoint URL
	if (contractid != null && contractid != "") {
		var serverUrl = Xrm.Page.context.getClientUrl();
		var oDataEndpointUrl = serverUrl + "/XRMServices/2011/OrganizationData.svc/";
		// query oData
		oDataEndpointUrl += "sfa_contractallocationSet?$select=sfa_contractallocationnumber&$filter=(sfa_ContractId/Id eq guid'"+contractid +"')  and (sfa_deliveryorganisationprovider ne null)";
		var service = GetRequestObject();
		if (service != null) {
			// execute the request
			service.open("GET", oDataEndpointUrl, false);
			service.setRequestHeader("X-Requested-Width", "XMLHttpRequest");
			service.setRequestHeader("Accept", "application/json,text/javascript, */*");
			service.send(null);
			// parse the results
			var requestResults = eval('(' + service.responseText + ')').d;
			if (requestResults != null && requestResults.results.length > 0) {
				return true;
			} 
		}
	}
	return false;
}

function GetContractTerminationInfo() {
	var contractid = Xrm.Page.data.entity.getId(); 
	// build endpoint URL
	if (contractid != null && contractid != "") {
		var serverUrl = Xrm.Page.context.getClientUrl();
		var oDataEndpointUrl = serverUrl + "/XRMServices/2011/OrganizationData.svc/";
		// query oData
		oDataEndpointUrl += "sfa_contractSet?$select=sfa_number,sfa_SubStatus&$filter=(sfa_contractId eq guid'"+contractid +"')  and (sfa_terminationreason ne null)";  
		var service = GetRequestObject();
		if (service != null) {
			// execute the request
			service.open("GET", oDataEndpointUrl, false);
			service.setRequestHeader("X-Requested-Width", "XMLHttpRequest");
			service.setRequestHeader("Accept", "application/json,text/javascript, */*");
			service.send(null);
			// parse the results
			var requestResults = eval('(' + service.responseText + ')').d;
			if (requestResults != null && requestResults.results.length > 0) {
                                var subStatus = requestResults.results[0].sfa_SubStatus.Name;
				return {terminationinprogress: true, substatus: subStatus};
			} 
		}
	}
	return {terminationinprogress: false, substatus: null};
}
