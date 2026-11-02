function RunDeleteWorkflow() { 
    var workflowId = '109E053D-680F-4782-94D8-A0F5904C4EA8';
    var action = "Delete";
    RunWorkflow(action, workflowId) ;
}

function RunInitiateClosureWorkflow() { 
    var workflowId = '8DE1347A-1C5B-4873-9578-1EB991B16262';
    var action = "Initiate Closure process";
    RunWorkflow(action, workflowId) ;
}

function RunInitiateVaryAmendmentWorkflow() { 
    var workflowId = '312BE856-FF3E-47C6-967E-C7773DD7B6F7';
    var action = "Initiate Amendment(Vary) process";
    RunWorkflow(action, workflowId) ;
}

function RunNotifyAmendmentWorkflow() { 
    var workflowId = '1A95F4F0-4A6D-4EC8-9AD4-602A012630CF';
    var action = "Initiate Amendment(Notify) process";
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
            Xrm.Page.data.refresh();
        } else {
            alert('There was an issue with the attempted action. Please check status of contract or try later');
        }
    }
}

function runTerminationDialog(objectId)
{
     var dialogId= "3208CC95-F980-4C14-9531-E02D420E9910";
     openDialogProcess(objectId, dialogId);
}

var popup ;
function openDialogProcess(objectId, dialogId )
{
  
  var entityName="sfa_contract";

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

       //window.location.reload(true);
       Xrm.Page.data.refresh(true);
   }
}