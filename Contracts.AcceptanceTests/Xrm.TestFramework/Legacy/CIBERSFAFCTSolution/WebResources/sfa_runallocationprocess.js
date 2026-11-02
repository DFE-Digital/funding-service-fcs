function EnableReadyForReleaseButton()
{
           var allocationStatus = Xrm.Page.getAttribute("sfa_status").getValue();
	   var allocationSubStatus = Xrm.Page.getAttribute("sfa_substatus").getValue();
           if ((allocationStatus  != null) && (allocationSubStatus != null) ){
                //allocationStatus -- Pre-Release 229660000 , allocationStatus -- In Review 229660000
		if ((allocationStatus == "229660000") &&(allocationSubStatus == '229660000'))
		{
		     return true;
		}               
           }  
          return false;
}

// determine Team Visibility for Ready to Release
function CheckReadyForReleaseTeamVisibility() {
    if (UserHasTeam('Contract Control Management Team')) {
        return true;
    } else {
        return false;
    }
}

function RunReadyForReleaseWorkflow() { 
    var workflowId = '6907BE09-B3D1-4968-B331-32FD643A32A6';
    var action = "Ready for Release process";
    RunWorkflow(action, workflowId) ;
}


function RunWorkflow(action, workflowId) { 
    var _return = window.confirm('Are you sure you want to execute the '+action);
    if (_return) {
        var url = Xrm.Page.context.getClientUrl();
        var entityId = Xrm.Page.data.entity.getId();
        var OrgServicePath = "/XRMServices/2011/Organization.svc/web";
        url = url + OrgServicePath;
        var request;
        request = "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">" +
                      "<s:Body>" +
                        "<Execute xmlns=\"http://schemas.microsoft.com/xrm/2011/Contracts/Services\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\">" +
                          "<request i:type=\"b:ExecuteWorkflowRequest\" xmlns:a=\"http://schemas.microsoft.com/xrm/2011/Contracts\" xmlns:b=\"http://schemas.microsoft.com/crm/2011/Contracts\">" +
                            "<a:Parameters xmlns:c=\"http://schemas.datacontract.org/2004/07/System.Collections.Generic\">" +
                              "<a:KeyValuePairOfstringanyType>" +
                                "<c:key>EntityId</c:key>" +
                                "<c:value i:type=\"d:guid\" xmlns:d=\"http://schemas.microsoft.com/2003/10/Serialization/\">" + entityId + "</c:value>" +
                              "</a:KeyValuePairOfstringanyType>" +
                              "<a:KeyValuePairOfstringanyType>" +
                                "<c:key>WorkflowId</c:key>" +
                                "<c:value i:type=\"d:guid\" xmlns:d=\"http://schemas.microsoft.com/2003/10/Serialization/\">" + workflowId + "</c:value>" +
                              "</a:KeyValuePairOfstringanyType>" +
                            "</a:Parameters>" +
                            "<a:RequestId i:nil=\"true\" />" +
                            "<a:RequestName>ExecuteWorkflow</a:RequestName>" +
                          "</request>" +
                        "</Execute>" +
                      "</s:Body>" +
                    "</s:Envelope>";

        var req = new XMLHttpRequest();
        req.open("POST", url, true)
        // Responses will return XML. It isn't possible to return JSON.
        req.setRequestHeader("Accept", "application/xml, text/xml, */*");
        req.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
        req.setRequestHeader("SOAPAction", "http://schemas.microsoft.com/xrm/2011/Contracts/Services/IOrganizationService/Execute");
        req.onreadystatechange = function () { assignResponse(req); };
        req.send(request);
    }
}

function assignResponse(req) {
    if (req.readyState == 4) {
        if (req.status == 200) {
            Xrm.Page.data.entity.save();
            Xrm.Page.data.refresh();
        } else {
            alert('There was an issue with the attempted action. Please check status of allocation or try later');
        }
    }
}

var popup ;

function RunReleaseAllocationDialog()
{
     var dialogId= "84980EB8-EF98-4CEB-A272-B274F8C69B4C";
     var objectId = "00000000-0000-0000-0000-000000000000";
     openDialogProcess(objectId, dialogId);
}

function openDialogProcess(objectId, dialogId )
{
  
  var entityName="sfa_allocation";

 var url = Xrm.Page.context.getClientUrl() +
  "/cs/dialog/rundialog.aspx?DialogId=" +
  dialogId + "&EntityName=" +
  entityName + "&ObjectId=" +
  objectId;
  if(typeof(popup) == 'undefined' || popup.closed){
     popup = window.open(url, "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,width=950,height=600");
     detailsWindowTimer = setInterval("WatchDetailsWindowForClose()", 600); //Poll
  } else { 
     alert("Please close any dialog that's already open. If none, refresh the page to continue."); 
  }
}

function WatchDetailsWindowForClose() {

   if (!popup || popup.closed) {

       /// Do your stuff here....
       clearInterval(detailsWindowTimer); //stop the timer

   }
}