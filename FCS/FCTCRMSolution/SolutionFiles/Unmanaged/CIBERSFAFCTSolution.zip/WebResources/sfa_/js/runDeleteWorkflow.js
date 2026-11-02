function RunDeleteWorkflow(formContext) { 
    var workflowId = '109E053D-680F-4782-94D8-A0F5904C4EA8';
    var action = "Delete";
    executeAction(formContext ,action, workflowId);
}

function RunListDeleteWorkflow(selectedItems) { 
    var workflowId = 'FCB1770C-4079-EC11-8D21-000D3AD690E5';
    var action = "Delete";
    executeListAction(selectedItems, "sfa_contract", action, workflowId);
}

function RunInitiateClosureWorkflow(formContext) { 
    var workflowId = '8DE1347A-1C5B-4873-9578-1EB991B16262';
    var action = "Initiate Closure process";
    executeAction(formContext ,action, workflowId);
}

function RunListInitiateClosureWorkflow(selectedItems) { 
    var workflowId = '33565D7A-3979-EC11-8D21-000D3AD690E5';
    var action = "Initiate Closure process";
    executeListAction(selectedItems, "sfa_contract", action, workflowId);
}

function RunInitiateVaryAmendmentWorkflow(formContext) { 
    var workflowId = '312BE856-FF3E-47C6-967E-C7773DD7B6F7';
    var action = "Initiate Amendment(Vary) process";
    executeAction(formContext ,action, workflowId);
}

function RunListInitiateVaryAmendmentWorkflow(selectedItems) { 
    var workflowId = 'E4098F31-3F79-EC11-8D21-000D3AD690E5';
    var action = "Initiate Amendment(Vary) process";
    executeListAction(selectedItems, "sfa_contract", action, workflowId);
}

function RunNotifyAmendmentWorkflow(formContext) { 
    var workflowId = '1A95F4F0-4A6D-4EC8-9AD4-602A012630CF';
    var action = "Initiate Amendment(Notify) process";
    executeAction(formContext ,action, workflowId);
}

function RunListNotifyAmendmentWorkflow(selectedItems) { 
    var workflowId = '5EBCFC97-3F79-EC11-8D21-000D3AD690E5';
    var action = "Initiate Amendment(Notify) process";
    executeListAction(selectedItems, "sfa_contract", action, workflowId);
}

function RunListBulkAmendWorkflow(selectedItems) { 
    var workflowId = '9B74C9D7-A947-446B-A286-AC5804A522EC';
    var action = "Bulk Revise process";
    executeListAction(selectedItems, "sfa_contract", action, workflowId);
}

function RunHoldFCRWorkflow(selectedItems) { 
    var workflowId = '8FBB964F-5CC0-4760-AC01-4FAB52A42787';
    var action = "Hold Funding Claim Reconciliation process";
    executeListAction(selectedItems, "sfa_fundingclaimreconciliation", action, workflowId);
}

function RunReleaseFCRWorkflow(selectedItems) { 
    var workflowId = '0461C313-1510-4A0B-9927-AD1FA7060C6D';
    var action = "Release Funding Claim Reconciliation process";
    executeListAction(selectedItems, "sfa_fundingclaimreconciliation", action, workflowId);
}

function RunPublishFCRWorkflow(selectedItems) { 
    var workflowId = '649C9B76-F848-4E04-B9B8-2271AFB25070';
    var action = "Publish Funding Claim Reconciliation process";
    executeListAction(selectedItems, "sfa_fundingclaimreconciliation", action, workflowId);
}

function RunHoldPermanentlyFCRWorkflow(selectedItems) { 
    var workflowId = '413e239e-76b9-4525-b699-1dbfb7078e69';
    var action = "Hold Permanently Funding Claim Reconciliation process";
    executeListAction(selectedItems, "sfa_fundingclaimreconciliation", action, workflowId);
	
}

function executeAction(formContext ,action, workflowId) {
    var confirmOptions = { height: 200, width: 600 };
    Xrm.Navigation.openConfirmDialog({text: "Are you sure you want to execute the "+action}, confirmOptions).then(
		function (success) {
			if (success.confirmed) {
				try {
					var entityId = formContext.data.entity.getId();
					//execute the action
					executeWorkflow(formContext, entityId, workflowId);

				} catch (e) {
				   Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
				}
			}
		}	
	);
}

function executeWorkflow(formContext, entityId, workflowId) {
    Xrm.WebApi.online.execute(new MakeWorkflowRequest(entityId, workflowId)).then(
        function (result) { 

			if ( formContext != null) {
						formContext.data.save();
						formContext.data.refresh();
					}          

        },
        function (error) {
            //error callback
			var error = JSON.parse(this.response).error;
			Xrm.Utility.closeProgressIndicator();
			Xrm.Navigation.openAlertDialog({text: "There was an issue with the attempted action. Please check status of record or try later"+error.message });
        });
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
				executeListWorkflow(workflowRequests, entityName);

			} catch (e) {
                                 Xrm.Utility.closeProgressIndicator();
				 Xrm.Navigation.openAlertDialog({text: "There was an issue: "+e.message});
			}
		}
	});
}

function executeListWorkflow(requestObject, entityName) {
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


function runTerminationInitialise(formContext)
{
	RunTerminationAction(formContext, "Termination"); 
	formContext.ui.tabs.get("tab_modifydetails").setVisible(false);
	formContext.ui.tabs.get("tab_termdetails").setVisible(true);
}

function runModifyInitialise(formContext)
{
	RunTerminationAction(formContext, "Modification");   
	formContext.ui.tabs.get("tab_termdetails").setVisible(false);
	formContext.ui.tabs.get("tab_modifydetails").setVisible(true);   	
}


function RunTerminationAction(formContext,requestType) {
    var currentRecordIdString = formContext.data.entity.getId();
    var currentRecordId = currentRecordIdString.replace("{", '').replace("}", '');
    var currentUserId = Xrm.Utility.getGlobalContext().userSettings.userId.substr(1, 36);

    //target
    var target = {};
    target.entityType = "sfa_contract";
    target.id = currentRecordId;
	
    //CurrentUser
    var currentUser = {};
    currentUser.entityType = "systemuser";
    currentUser.id = currentUserId;


    ////using action
    var req = {};
    req.CurrentUser = currentUser;
	req.Type = requestType;
    req.entity = target;
	req.getMetadata = function () {
        return {
            boundParameter: "entity",
            parameterTypes: {
                "entity": { 
                    typeName: "mscrm.sfa_contract", 
                    structuralProperty: 5 
                },
                "CurrentUser": {
                    "typeName": "mscrm.systemuser",
                    "structuralProperty": 5
                },
				"Type": { typeName: "Edm.String", structuralProperty: 1 }
            },
            operationType: 0,
            operationName: "sfa_InitialiseTerminations"
        };
    };
 
    Xrm.WebApi.online.execute(req).then( 
        function (data) { 
            var e = data;  
			if (requestType == "Termination")  {
				formContext.ui.refreshRibbon(true);
				formContext.ui.tabs.get("tab_termdetails").setFocus();
                                formContext.getAttribute("sfa_inflightstopnewstartsdate").setValue(null);
				formContext.getAttribute("sfa_inflightterminationdate").setValue(null);
				formContext.getAttribute("sfa_inflightterminationreason").setValue(null);
				
			} else if (requestType == "Modification"){
				formContext.ui.refreshRibbon(true);
				formContext.ui.tabs.get("tab_modifydetails").setFocus();
                                formContext.getAttribute("sfa_inflightstopnewstartsdate").setValue(null);
				formContext.getAttribute("sfa_inflightnewstartssuspendedreason").setValue(null);
			}
            //refresh the form on success to update data
            formContext.data.refresh(true);
        }, 
        function (error) { 
            var errMsg = error.message; 
			Xrm.Navigation.openAlertDialog({text: "error:"+errMsg});
        }
    );
}

function TriggerCollegeFundingConfirmationReport(formContext) { 
    var reportName = "College Funding Confirmation Report";    
	var confirmOptions = { height: 200, width: 600 };
    Xrm.Navigation.openConfirmDialog({text: "Are you sure you want to trigger the generation of the "+reportName+"?"}, confirmOptions).then(
		function (success) {
			if (success.confirmed) {
				try {
					TriggerCustomReport(reportName);
				} catch (e) {
				   Xrm.Navigation.openAlertDialog({text: "There was an issue:"+e.message});
				}
			}
		}	
	);
}

function TriggerCustomReport(reportName) {

    ////using action
    var req = {};
	req.ReportName = reportName;

	req.getMetadata = function () {
        return {
            parameterTypes: {
				"ReportName": { typeName: "Edm.String", structuralProperty: 1 }
            },
            operationType: 0,
            operationName: "sfa_TriggerCustomReport"
        };
    };
    Xrm.Utility.showProgressIndicator("Processing");
	Xrm.WebApi.online.execute(req).then( 
        function (result) { 
            if (result.ok) { 
	           Xrm.Utility.closeProgressIndicator();
            } 
        },
        function (error) { 
           var errMsg = error.message; 
           Xrm.Utility.closeProgressIndicator();
	       Xrm.Navigation.openAlertDialog({text: "There was an error. Please try again later or contact support."});
        }
    );
}

function HideUnhidePublish(selectedControl) {
	"use strict";
	debugger;
	//var currentGridName=selectedControl.getCurrentView;
	var currentGridName=selectedControl.getViewSelector().getCurrentView().name;
	
	var heldPerm = "Held Permanently Funding Claim Reconciliations";
	var roleName="Claim Publisher";
	var isPublisher=hasCurrentUserRole(roleName);

	
	
	console.log("current Grid Name: " + currentGridName);
	console.log("isPublisher: " + isPublisher);
	
	if(currentGridName==heldPerm){
		return false;
		}
	else{
		if(isPublisher){
			return true;
		}
		else{
			return false;
		}
		}	
}


function HideUnhideHeldPerm(selectedControl) {
	"use strict";
	debugger;
	//var currentGridName=selectedControl.getCurrentView;
	var currentGridName=selectedControl.getViewSelector().getCurrentView().name;
	
	var heldPerm = "Held Permanently Funding Claim Reconciliations";
	var roleName="Claim Publisher";
	var isPublisher=hasCurrentUserRole(roleName);

	
	
	console.log("current Grid Name: " + currentGridName);
	console.log("isPublisher: " + isPublisher);
	
	if(currentGridName==heldPerm){
		return false;
		}
	else{
		return true;
		}	
}
function HideUnhideHoldReleaseHoldPerm(selectedControl) {
	"use strict";
	debugger;
	//var currentGridName=selectedControl.getCurrentView;
	var currentGridName=selectedControl.getViewSelector().getCurrentView().name;
	
	var heldPerm = "Held Permanently Funding Claim Reconciliations";
	var roleName="Claim Publisher";
	var isPublisher=hasCurrentUserRole(roleName);
	
	
	
	console.log("current Grid Name: " + currentGridName);
	console.log("isPublisher: " + isPublisher);
	
	if(currentGridName==heldPerm){
		return false;
		}
	else{
		return true;
		}
	
	
	
	
}


function hasCurrentUserRole(roleName){
  let hasRole = false;
  let roles = Xrm.Utility.getGlobalContext().userSettings.roles;
  roles.forEach(x => {
                if (x.name === roleName) {
                    hasRole = true;
                    return;
                }
               });
   return hasRole;
}