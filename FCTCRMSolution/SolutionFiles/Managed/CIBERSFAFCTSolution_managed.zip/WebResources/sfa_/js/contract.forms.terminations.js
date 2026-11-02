//termination validation scripts
var TermTabGlobalContext;

function term_initTermTab(executionContext) {
   TermTabGlobalContext = executionContext.getFormContext();
   var tabstate = TermTabGlobalContext.ui.tabs.get("tab_termdetails").getDisplayState();
   var substatus = TermTabGlobalContext.getAttribute("sfa_substatus").getValue();

   if ( tabstate == "expanded")  {  
		var latestVersion = TermTabGlobalContext.getAttribute("sfa_latestversion").getValue();
                var termTab = TermTabGlobalContext.ui.tabs.get("tab_termdetails");
		if (latestVersion != 1)	{					
			termTab.sections.get("termDetailsSection").setVisible(false);
			termTab.sections.get("termTypeSection").setVisible(false);
			termTab.sections.get("termLatestInfoSection").setVisible(true);
		} else {
			termTab.sections.get("termDetailsSection").setVisible(true);
			termTab.sections.get("termTypeSection").setVisible(true);
			termTab.sections.get("termLatestInfoSection").setVisible(false);
		}

		if (substatus[0].name == "Approved") { //Approved
				
		}  else if (substatus[0].name == "Under Termination") { //Under Termination

		}       
       
   } 

}

function term_initModfnTab(executionContext) {
   TermTabGlobalContext = executionContext.getFormContext();
   var tabstate = TermTabGlobalContext.ui.tabs.get("tab_modifydetails").getDisplayState();

   if ( tabstate == "expanded")  {  
		var latestVersion = TermTabGlobalContext.getAttribute("sfa_latestversion").getValue();
        var  modTab = TermTabGlobalContext.ui.tabs.get("tab_modifydetails");
		if (latestVersion != 1)	{					
			modTab.sections.get("modDetailsSection").setVisible(false);
			modTab.sections.get("modTypeSection").setVisible(false);
			modTab.sections.get("modLatestInfoSection").setVisible(true);
		} else {
			modTab.sections.get("modDetailsSection").setVisible(true);
			modTab.sections.get("modTypeSection").setVisible(true);
			modTab.sections.get("modLatestInfoSection").setVisible(false);
		}       
   }  
}

function setFieldsDisabled(context) {

	var contractalloc = context.getFormContext().data.entity;
	contractalloc.attributes.getByName("sfa_contractallocationnumber").controls.getByIndex(0).setDisabled(true);
	//contractalloc.attributes.getByName("sfa_startdate").controls.getByIndex(0).setDisabled(true);
	contractalloc.attributes.getByName("sfa_enddate").controls.getByIndex(0).setDisabled(true);
	contractalloc.attributes.getByName("sfa_fundingstreamid").controls.getByIndex(0).setDisabled(true);
	contractalloc.attributes.getByName("sfa_stopnewstartsdate").controls.getByIndex(0).setDisabled(true);
	contractalloc.attributes.getByName("sfa_terminationdate").controls.getByIndex(0).setDisabled(true);

	//part to disable after validate
   /* var finaliseTerm = TermTabGlobalContext.getAttribute("sfa_terminationvalidcheck").getValue();

	if (finaliseTerm)  {
		 //contractalloc.attributes.getByName("sfa_inflightterminationdate").controls.getByIndex(0).setDisabled(true);
		 contractalloc.attributes.getByName("sfa_stopnewstartsdate").controls.getByIndex(0).setDisabled(true);
		 //contractalloc.attributes.getByName("sfa_inflightterminationreason").controls.getByIndex(0).setDisabled(true);
		 contractalloc.attributes.getByName("sfa_newstartssuspendedreason").controls.getByIndex(0).setDisabled(true);
		 contractalloc.attributes.getByName("sfa_inflightterminationcomments").controls.getByIndex(0).setDisabled(true);

	} else {
		 contractalloc.attributes.getByName("sfa_inflightterminationdate").controls.getByIndex(0).setDisabled(false);
		 contractalloc.attributes.getByName("sfa_stopnewstartsdate").controls.getByIndex(0).setDisabled(false);
	}*/
}

function term_terminationDate(executionContext)
{

   var formContext = executionContext.getFormContext();
   if (TermTabGlobalContext == null) TermTabGlobalContext = formContext ;
   var termDate = formContext.getAttribute("sfa_inflightterminationdate").getValue();
   var stopStartsDate = formContext.getAttribute("sfa_inflightstopnewstartsdate").getValue();
   
   if (termDate != null)   { termDate = termDate.format("yyyy-MM-ddT"+"00:00:00"); }
   if (stopStartsDate != null)   { stopStartsDate = stopStartsDate.format("yyyy-MM-ddT"+"00:00:00"); }
	CascadeTerminationValues(formContext,"Termination","Termination Date",stopStartsDate,termDate, 0);

   
}

function term_StopStartsDate(executionContext)
{

   var formContext = executionContext.getFormContext();
   if (TermTabGlobalContext == null) TermTabGlobalContext = formContext ;
   var termstage = formContext.getAttribute("sfa_terminationinprogress").getValue();
   var substatus = formContext.getAttribute("sfa_substatus").getValue();
   var termDate;
   var stopStartsDate;
   if ((termstage  == "TERM_INITIATED")||(substatus[0].name == "Under Termination")) {
		stopStartsDate = formContext.getAttribute("sfa_inflightstopnewstartsdate").getValue();
		termDate = formContext.getAttribute("sfa_inflightterminationdate").getValue();
		if (termDate != null)   { termDate = termDate.format("yyyy-MM-ddT"+"00:00:00"); }
		if (stopStartsDate != null)   { stopStartsDate = stopStartsDate.format("yyyy-MM-ddT"+"00:00:00"); }
		CascadeTerminationValues(formContext,"Termination","Stop Starts Date",stopStartsDate, termDate, 0);

   } else if ((termstage  == "MODFN_INITIATED")||(substatus[0].name == "Modified")) {
		stopStartsDate = formContext.getAttribute("sfa_inflightstopnewstartsdate").getValue();
		if (stopStartsDate != null)   { stopStartsDate = stopStartsDate.format("yyyy-MM-ddT"+"00:00:00"); }
		var stopNewStartsSuspendedReason = formContext.getAttribute("sfa_inflightnewstartssuspendedreason");
		var stopNewStartsSuspendedReasonVal = 0;
		if (stopNewStartsSuspendedReason != null) { stopNewStartsSuspendedReasonVal = stopNewStartsSuspendedReason.getValue(); }
		CascadeTerminationValues(formContext,"Modification","Stop Starts Date",stopStartsDate, null, stopNewStartsSuspendedReasonVal);	
		
   }

}

function term_NewStartsSuspendedReason(executionContext)
{      
        var formContext = executionContext.getFormContext();
		stopStartsDate = formContext.getAttribute("sfa_inflightstopnewstartsdate").getValue();
		if (stopStartsDate != null)   { stopStartsDate = stopStartsDate.format("yyyy-MM-ddT"+"00:00:00"); }
        var stopNewStartsSuspendedReason = formContext.getAttribute("sfa_inflightnewstartssuspendedreason");
		var stopNewStartsSuspendedReasonVal = 0;
		if (stopNewStartsSuspendedReason != null) { stopNewStartsSuspendedReasonVal = stopNewStartsSuspendedReason.getValue(); }
		CascadeTerminationValues(formContext,"Modification","New Starts Suspended Reason",stopStartsDate, null, stopNewStartsSuspendedReasonVal);	
}

function term_TerminationReason(executionContext)
{      
        var formContext = executionContext.getFormContext();
        //formContext.data.refresh(true);
}

function term_AllocTerminationDate(executionContext)
{
	
	if (TermTabGlobalContext != null)
		TermTabGlobalContext.getControl("termContractAllocations").refresh(); 

}

function term_AllocStopStartsDate(executionContext)
{
	
    if (TermTabGlobalContext != null) 
		TermTabGlobalContext.getControl("termContractAllocations").refresh(true); 

}

function RunTerminationValidation(formContext, validationType, stopNewStartsDate, terminationDate, terminationReason) {
    var currentRecordIdString = formContext.data.entity.getId();
    var currentRecordId = currentRecordIdString.replace("{", '').replace("}", '');

    //target
    var target = {};
    target.entityType = "sfa_contract";
    target.id = currentRecordId;
	
    ////using action
    var req = {};
    req.entity = target;
	req.ValidationType = validationType;
	if (stopNewStartsDate != null) { req.StopNewStartsDate = JSON.stringify(new Date(stopNewStartsDate+".000Z")); }
	if (terminationDate != null) { req.TerminationDate = JSON.stringify(new Date(terminationDate+".000Z")); } 

	req.TerminationReason = terminationReason;

	req.getMetadata = function () {
        return {
            boundParameter: "entity",
            parameterTypes: {
                "entity": { 
                    typeName: "mscrm.sfa_contract", 
                    structuralProperty: 5 
                },
				"ValidationType": { typeName: "Edm.String", structuralProperty: 1 },
				"StopNewStartsDate": { typeName: "Edm.DateTime", structuralProperty: 1 },
				"TerminationDate": { typeName: "Edm.DateTime", structuralProperty: 1 },
				"TerminationReason": { typeName: "Edm.String", structuralProperty: 1 },
            },
            operationType: 0,
            operationName: "sfa_TerminationActionValidation"
        };
    };

    var confirmOptions = { height: 150, width: 600 };
    Xrm.WebApi.online.execute(req).then( 
        function (result) { 
            if (result.ok) {
				result.json().then(function(results) {
				   if (results.ValidData == "Error")  { 
						formContext.getAttribute("sfa_terminationvalidcheck").setValue(false);
                        formContext.getAttribute("sfa_terminationselection").setValue(null);
                        var confirmErrOptions = { height: 150, width: 650 };
						Xrm.Navigation.openAlertDialog({text: results.ErrorMessage},confirmErrOptions );   
						//formContext.data.refresh(false);											   

					} else if (results.ValidData == "Warning")  { 
                        var confirmtxt = results.ErrorMessage;
						var confirmWnOptions = { height: 150, width: 600 };
						Xrm.Navigation.openConfirmDialog({text: confirmtxt},confirmWnOptions ).then(
							function (success) {    
								if (success.confirmed) {
									formContext.getAttribute("sfa_terminationvalidcheck").setValue(true);
									formContext.ui.tabs.get("tab_termdetails").setVisible(false);
									formContext.data.refresh(true);
								} else
									formContext.getAttribute("sfa_terminationselection").setValue(null);
						});
					
					} else {
						if (validationType == "Cancel Termination") {
							var confirmOptions = { height: 50, width: 700 };
							var confirmtxt = "Do you want to cancel the termination?";
							Xrm.Navigation.openConfirmDialog({text: confirmtxt},confirmOptions ).then(
								function (success) {    
								if (success.confirmed) {
									formContext.getAttribute("sfa_terminationvalidcheck").setValue(true);				
									formContext.ui.tabs.get("tab_termdetails").setVisible(false);
									formContext.data.refresh(true);
								} else
									formContext.getAttribute("sfa_terminationselection").setValue(null);
							});
						} else if (validationType == "Complete Termination") {
							var confirmOptions = { height: 50, width: 700 };
							var confirmtxt = "Are you sure you wish to continue as Termination Completion cannot be undone? Select OK to complete or Cancel to return to the Termination Details.";
							Xrm.Navigation.openConfirmDialog({text: confirmtxt},confirmOptions ).then(
								function (success) {    
									if (success.confirmed) {									
										formContext.getAttribute("sfa_terminationvalidcheck").setValue(true);				
										formContext.ui.tabs.get("tab_termdetails").setVisible(false);
										formContext.data.refresh(true);
									} else
										formContext.getAttribute("sfa_terminationselection").setValue(null);
								});
						} else if (validationType == "Cancel Modification") {
							var confirmOptions = { height: 50, width: 700 };
							var confirmtxt = "Do you want to cancel the modification?";
							Xrm.Navigation.openConfirmDialog({text: confirmtxt},confirmOptions ).then(
								function (success) {    
								if (success.confirmed) {
									formContext.getAttribute("sfa_terminationvalidcheck").setValue(true);				
									formContext.ui.tabs.get("tab_modifydetails").setVisible(false);
									formContext.data.refresh(true);
								} else
									formContext.getAttribute("sfa_terminationselection").setValue(null);
							});
						}						
						else {
							//no error -set fields to readonly
							formContext.getAttribute("sfa_terminationvalidcheck").setValue(true);
							//DisableTerminationSection(formContext, true) ;						
							formContext.ui.tabs.get("tab_termdetails").setVisible(false);
							formContext.data.refresh(true);
						}
					}
					
				});
            }               

        },
        function (error) { 
            var errMsg = error.message; 
	        Xrm.Navigation.openAlertDialog({text: "error:"+errMsg});
        }
    );
}

function DisableTerminationSection(formContext, status) {
	formContext.getControl("sfa_inflightterminationdate").setDisabled(status);
	formContext.getControl("sfa_inflightterminationreason").setDisabled(status);
	formContext.getControl("sfa_inflightstopnewstartsdate").setDisabled(status);
	formContext.getControl("sfa_inflightterminationcomments").setDisabled(status);

}

function term_TerminationActionSelect(executionContext) {
	var formContext = executionContext.getFormContext();
	var substatus = formContext.getAttribute("sfa_substatus").getValue();
	var actionType = formContext.getAttribute("sfa_terminationselection").getValue();
	var termDate = formContext.getAttribute("sfa_inflightterminationdate").getValue();
	if (termDate != null) termDate = termDate.format("yyyy-MM-ddT"+"00:00:00");
	var stopStartsDate = formContext.getAttribute("sfa_inflightstopnewstartsdate").getValue();
	if (stopStartsDate != null) stopStartsDate = stopStartsDate.format("yyyy-MM-ddT"+"00:00:00");
	
	var termReasonTxt = "";
	var termReason = formContext.getAttribute("sfa_inflightterminationreason");

	if (termReason != null) { termReasonTxt = termReason.getText(); }

	if (actionType != null)   {
		
			if (substatus[0].name == "Approved") { //Approved
			
				if (actionType[0].name == "Initiate Termination") {

					RunTerminationValidation(formContext, "Initiate Termination", stopStartsDate, termDate, termReasonTxt);                   

				} else if (actionType[0].name == "Initiate Modification") {
					termReasonTxt = "";
					termReason = formContext.getAttribute("sfa_inflightnewstartssuspendedreason");
					if (termReason != null) { termReasonTxt = termReason.getText(); }
					
					RunTerminationValidation(formContext, "Initiate Modification", stopStartsDate, null, termReasonTxt);                   

				} else if (actionType[0].name == "Cancel Termination Initiation")  {
				
					var confirmOptions = { height: 50, width: 700 };
						var confirmtxt = "Are you sure you wish to abandon Termination Initiation?\n Click OK to abandon or Cancel to continue to initiate termination";
						Xrm.Navigation.openConfirmDialog({text: confirmtxt},confirmOptions ).then(
							function (success) {    
								if (success.confirmed) {
									//set action									
									formContext.ui.tabs.get("tab_termdetails").setVisible(false);
									formContext.data.refresh(true);
								} else
									formContext.getAttribute("sfa_terminationselection").setValue(null);
						});
					
				} else if (actionType[0].name == "Cancel Modification Initiation")  {
						var confirmOptions = { height: 50, width: 700 };
						var confirmtxt = "Are you sure you wish to abandon Modification Initiation?\n Click OK to abandon or Cancel to continue to initiate modification";
						Xrm.Navigation.openConfirmDialog({text: confirmtxt},confirmOptions ).then(
							function (success) {    
								if (success.confirmed) {
									//set action									
									formContext.ui.tabs.get("tab_modifydetails").setVisible(false);
									formContext.data.refresh(true);
								} else
									formContext.getAttribute("sfa_terminationselection").setValue(null);
						});

				}

				
			}  else if (substatus[0].name == "Under Termination") { //Under Termination

				if (actionType[0].name == "Update Termination Details") { //Update Termination Details				

					RunTerminationValidation(formContext, "Update Termination Details", stopStartsDate, termDate, termReasonTxt); 

				} else if (actionType[0].name == "Cancel Termination") { //Cancel Termination
						RunTerminationValidation(formContext, "Cancel Termination", null, null, null);

				} else if (actionType[0].name == "Complete Termination") { //Complete Termination
						RunTerminationValidation(formContext, "Complete Termination", stopStartsDate, termDate, termReasonTxt); 						
						
				} 
	

			} else if (substatus[0].name == "Modified") { //Modified

				if (actionType[0].name == "Update Modification Details") { //Update Termination Details				
					termReasonTxt = "";
					termReason = formContext.getAttribute("sfa_inflightnewstartssuspendedreason");
					if (termReason != null) { termReasonTxt = termReason.getText(); }
					
					RunTerminationValidation(formContext, "Update Modification Details", stopStartsDate, termDate, termReasonTxt); 

				} else if (actionType[0].name == "Cancel Modification") { //Cancel Termination
						RunTerminationValidation(formContext, "Cancel Modification", null, null, null);

				} 
			}
		
    }
}

function CascadeTerminationValues(formContext,termType, cascadeType, stopNewStartsDate,terminationDate, termReasonVal) {
    var currentRecordIdString = formContext.data.entity.getId();
    var currentRecordId = currentRecordIdString.replace("{", '').replace("}", '');

    //target
    var target = {};
    target.entityType = "sfa_contract";
    target.id = currentRecordId;
	
    ////using action
    var req = {};
    req.entity = target;
	req.CascadeType = cascadeType;
	if (stopNewStartsDate != null) { req.StopNewStartsDate = JSON.stringify(new Date(stopNewStartsDate+".000Z")); }
	if (terminationDate != null) { req.TerminationDate = JSON.stringify(new Date(terminationDate+".000Z")); }
	if (termReasonVal > 0) { req.Reason = termReasonVal; }
    //JSON.stringify(new Date("03/10/2020 01:30:00").toISOString());
	
	req.getMetadata = function () {
        return {
            boundParameter: "entity",
            parameterTypes: {
                "entity": { typeName: "mscrm.sfa_contract", structuralProperty: 5 },
				"CascadeType": { typeName: "Edm.String", structuralProperty: 1 },
				"TerminationDate": { typeName: "Edm.DateTime", structuralProperty: 1 },
				"StopNewStartsDate": { typeName: "Edm.DateTime", structuralProperty: 1 },
				"Reason": { typeName: "Edm.Int16", structuralProperty: 1 }
            },
            operationType: 0,
            operationName: "sfa_CascadeTerminationdata"
        };
    };

    var confirmOptions = { height: 100, width: 700 }; 

    Xrm.WebApi.online.execute(req).then( 
        function (result) { 
            if (result.ok) { 
				result.json().then(function(results) {
				    if (termType == "Termination") { 
					  formContext.getControl("termContractAllocations").refresh(); 
					} else {  formContext.getControl("modContractAllocations").refresh();    }
					
				});
            }               

        },
        function (error) { 
            var errMsg = error.message; 
	        Xrm.Navigation.openAlertDialog({text: "error:"+errMsg});
        }
    );

}