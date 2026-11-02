// <copyright file="CallContractManagementService.cs" company="">
// Copyright (c) 2015 All Rights Reserved
// </copyright>
// <author></author>
// <date>5/19/2015 2:39:50 PM</date>
// <summary>Implements the CallContractManagementService Workflow Activity.</summary>
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow
{
    using System;
    using System.Activities;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Workflow;
    using System.Text;
    using System.Runtime.Serialization.Json;
    using System.Threading.Tasks;
    using System.Net.Http;
    using System.Collections.Generic;

    public sealed class CallSBContractManagementService : CodeActivity
    {
        [RequiredArgument]
        [Input("Web Service URI")]
        public InArgument<string> InputWebServiceUri { get; set; }

        [RequiredArgument]
        [Input("Azure AD Instance")]
        public InArgument<string> InputAzureAdInstance { get; set; }

        [RequiredArgument]
        [Input("Azure App Key")]
        public InArgument<string> InputAzureAppKey { get; set; }

        [RequiredArgument]
        [Input("Azure Resource ID")]
        public InArgument<string> InputAzureResourceId { get; set; }

        [RequiredArgument]
        [Input("Azure Tenant")]
        public InArgument<string> InputAzureTenant { get; set; }

        [RequiredArgument]
        [Input("Azure Client Id")]
        public InArgument<string> InputAzureClientId { get; set; }

        [RequiredArgument]
        [Input("Contract Intent")]
        public InArgument<string> InputIntent { get; set; }

        [RequiredArgument]
        [Input("Request Method")]
        public InArgument<string> RequestMethod { get; set; }

        [Output("Calling Service URL")]
        public OutArgument<string> OutUrlString { get; set; }

        [Output("Response")]
        public OutArgument<string> OutResponse { get; set; }

        [Output("Error Response")]
        public OutArgument<string> OutErrorArgument { get; set; }

        /// <summary>
        /// Executes the workflow activity.
        /// </summary>
        /// <param name="executionContext">The execution context.</param>
        protected override void Execute(CodeActivityContext executionContext)
        {
            const string INITIATECONTRACTCLOSURE = "initiatecontractclosure";
            const string APPROVECONTRACTCLOSURE = "approvecontractclosure";
            const string NONFINANCIALAMENDVARY = "nonfinancialamendvary";
            const string NONFINANCIALAMENDNOTIFY = "nonfinancialamendnotify";
            const string APPROVETERMINITIATION = "approveterminationinitiation";
            const string CANCELTERMINATION = "cancelcontracttermination";
            const string TERMINATECONTRACT = "terminatecontract";
            const string AMENDCONTRACT = "amendcontract";
            const string UPDATETERMINATIONDETAILS = "updatecontractterminationdetails";
            const string APPROVEMODIFICATION = "approvemodification";
            const string UPDATEMODIFICATION = "updatemodification";
            const string CANCELMODIFICATION = "cancelmodification";

            const string REJECTINTERNALAPPROVAL = "rejectinternalapproval";
            const string REVISEINTERNALAPPROVAL = "reviseinternalapproval";
            const string BULKREVISE = "bulkrevise";
            const string REJECTMODIFICATION = "rejectmodification";
            const string REJECTTERMINITIATE = "rejectterminitiate";
            const string REJECTCLOSURE = "rejectclosure";

            // Create the tracing service
            ITracingService tracingService = executionContext.GetExtension<ITracingService>();

            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace("Entered CallContractManagementService.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("CallContractManagementService.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            var serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            var service = serviceFactory.CreateOrganizationService(context.UserId);

            string cmservice = InputWebServiceUri.Get(executionContext);
            string crmintent = InputIntent.Get(executionContext);

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    tracingService.Trace("About to get contract");

                    var inputContract = new EntityReference("Sfa_contract", context.PrimaryEntityId);

                    var contract = xrmContext
                        .CreateQuery("sfa_contract")
                        .FirstOrDefault(e => ((EntityReference)e["sfa_contractid"]).Equals(inputContract));

                    tracingService.Trace("About to get extract parent contract id");

                    var masterContractRef = contract.GetAttributeValue<EntityReference>("sfa_parentcontractid");

                    if (masterContractRef == null)
                    {
                        throw new InvalidPluginExecutionException(
                            "The required Master Contract or Contract is not present in Dynamics CRM");
                    }

                    if (!string.IsNullOrEmpty(cmservice))
                    {
                        tracingService.Trace("About to get master contract");

                        var contractNumber = contract.GetAttributeValue<string>("sfa_number");
                        var mastercontract = xrmContext
                            .CreateQuery("sfa_contract")
                            .FirstOrDefault(e => ((EntityReference)e["sfa_contractid"]).Equals(masterContractRef));

                        var masterContractNumber = mastercontract.GetAttributeValue<string>("sfa_number");
                        var ContractVersionNumber = contract.GetAttributeValue<int>("sfa_version");
                        var ContractSubVersionNumber = contract.GetAttributeValue<int>("sfa_subversion");

                        var url = string.Empty;
                        var postData = string.Empty;
                        string contentType = string.Empty;

                        if ((crmintent == INITIATECONTRACTCLOSURE) || (crmintent == APPROVECONTRACTCLOSURE) || (crmintent == CANCELTERMINATION) || (crmintent == TERMINATECONTRACT) || (crmintent == UPDATETERMINATIONDETAILS))
                        {
                            //case where json is sent
                            contentType = "application/json";
                            //add Intent to the URL
                            cmservice += crmintent;
                            postData = string.Format("{{\"ContractNumber\":\"{0}\",\"VersionNumber\":{1},\"SubVersionNumber\":{2}}}", contractNumber, ContractVersionNumber, ContractSubVersionNumber);
                        }
                        else if (crmintent == APPROVETERMINITIATION)
                        {
                            //case where json is sent
                            contentType = "application/json";
                            //add Intent to the URL
                            cmservice += crmintent;
                            var InitiateAmendmentOnApproval = contract.GetAttributeValue<bool>("sfa_initiateamendment");
                            postData = string.Format("{{\"ContractNumber\":\"{0}\",\"VersionNumber\":{1},\"SubVersionNumber\":{2},\"ShouldInitiateAmendmentOnApproval\":{3}}}", contractNumber, ContractVersionNumber, ContractSubVersionNumber, InitiateAmendmentOnApproval.ToString().ToLower());
                        }
                        else if ((crmintent == APPROVEMODIFICATION) || (crmintent == UPDATEMODIFICATION) || (crmintent == CANCELMODIFICATION))
                        {
                            //case where json is sent
                            contentType = "application/json";
                            //add Intent to the URL
                            cmservice += crmintent;
                            postData = string.Format("{{\"ContractNumber\":\"{0}\",\"VersionNumber\":{1},\"SubVersionNumber\":{2}}}", contractNumber, ContractVersionNumber, ContractSubVersionNumber);
                        }
                        else if ((crmintent == NONFINANCIALAMENDVARY) || (crmintent == NONFINANCIALAMENDNOTIFY))
                        {
                            //case for non financial amendment 
                            var amendmentType = string.Empty;
                            if (crmintent == NONFINANCIALAMENDVARY)
                            {
                                amendmentType = "VARIATION";
                            }
                            else
                            {
                                amendmentType = "NOTIFICATION";
                            }
                            contentType = "application/json";
                            //add normalised Intent to the URL
                            cmservice += AMENDCONTRACT;
                            postData = string.Format("{{\"ContractNumber\":\"{0}\",\"VersionNumber\":{1},\"SubVersionNumber\":{2},\"AmendmentType\":\"{3}\"}}", contractNumber, ContractVersionNumber, ContractSubVersionNumber, amendmentType);
                        }
                        else if ((crmintent == REJECTINTERNALAPPROVAL) || (crmintent == REVISEINTERNALAPPROVAL) || (crmintent == BULKREVISE) || (crmintent == REJECTMODIFICATION) || (crmintent == REJECTTERMINITIATE) || (crmintent == REJECTCLOSURE))
                        {
                            //case where json is sent
                            contentType = "application/json";
                            //add Intent to the URL
                            cmservice = cmservice.Substring(0, cmservice.IndexOf("contractmanagement"));
                            cmservice += "funding-allocation/un-queue-event";

                            var EventSource = new Dictionary<string, string>(){
                                {REJECTINTERNALAPPROVAL, "contract version 'rejected' from 'Awaiting Internal Approval' back to 'In Review'"},
                                {REVISEINTERNALAPPROVAL, "contract version 'revised' at 'Internally Approved', moving back to 'In Review'"},
                                {BULKREVISE, "contract version 'bulk revised' moving back to 'Awaiting Documentation'"},
                                {REJECTMODIFICATION, "contract modification rejected"},
                                {REJECTTERMINITIATE, "contract termination initiation rejected"},
                                {REJECTCLOSURE, "contract closure rejected"}
                            };

                            postData = string.Format("{{\"ContractNumber\":\"{0}\",\"VersionNumber\":{1},\"SubVersionNumber\":{2},\"EventSource\":\"{3}\"}}", contractNumber, ContractVersionNumber, ContractSubVersionNumber, EventSource[crmintent]);

                        }
                        else
                        {
                            contentType = "application/xml";
                            //add Intent to the URL
                            cmservice += crmintent;
                            postData = string.Format("<ContractInformation xmlns:xsi =\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><ContractNumber>{0}</ContractNumber>" +
                                            "<MasterContractNumber>{1}</MasterContractNumber><ContractVersionNumber>{2}</ContractVersionNumber></ContractInformation>", contractNumber,
                                masterContractNumber, ContractVersionNumber);
                        }

                        url = cmservice;
                        tracingService.Trace("About to get call url {0}", url);                        
                        tracingService.Trace("parse postData string {0}", postData);

                        OutUrlString.Set(executionContext, url);
                        PutMessage(url, executionContext, tracingService, contentType, postData);

                    }
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                ThrowInvalidPluginExecutionExceptionForRetry(executionContext,
                    tracingService,
                    "Unknown",
                    e,
                    cmservice);
            }

            tracingService.Trace("Exiting CallContractManagementService.Execute(), Correlation Id: {0}", context.CorrelationId);
        }


        private void ThrowInvalidPluginExecutionExceptionForRetry(ActivityContext executionContext, ITracingService tracingService, string httpStatusCode, Exception ex,
            string url)
        {
            OutResponse.Set(executionContext,
                httpStatusCode);
            OutErrorArgument.Set(executionContext,
                ex.Message);

            tracingService.Trace(
                "Exiting CallContractManagementService.Execute(), Correlation Id: {0}, eHttpStatusCode : {1}",
                OutErrorArgument,
                httpStatusCode);

            throw new InvalidPluginExecutionException(
                OperationStatus.Retry,
                "An error occured trying to call contract management service: Exception: " + ex + " InnerException:" +
                    ex.InnerException +
                    " , Website return code: " + httpStatusCode +
                    " , Message: " + ex.Message + ". URI Called: " + url);
        }


        private void PutMessage(string postUrl, ActivityContext executionContext, ITracingService tracingService, string contentType, string postData)
        {
            try
            {
                string clientId = InputAzureClientId.Get(executionContext);
                string secret = InputAzureAppKey.Get(executionContext);
                string tenantId = InputAzureTenant.Get(executionContext);
                string resourceId = InputAzureResourceId.Get(executionContext);
                byte[] byteArray = Encoding.UTF8.GetBytes(postData);

                var request = (HttpWebRequest)WebRequest.Create(postUrl);
                request.Method = RequestMethod.Get(executionContext);
                request.ContentType = contentType;
                request.ContentLength = byteArray.Length;

                //Manually create the auth token
                Task<AzureAccessToken> token = CreateOAuthAuthorizationToken(
                clientId,
                secret,
                resourceId,
                tenantId);
                //Add token to the header
                request.PreAuthenticate = true;
                request.Headers.Add("Authorization", string.Format("{0} {1}", "Bearer", token.Result.access_token));

                tracingService.Trace("after authentication token");

                using (var webpageStream = request.GetRequestStream())
                {
                    webpageStream.Write(byteArray, 0, byteArray.Length);
                }

                tracingService.Trace("after request");

                using (var webresponse = request.GetResponse())
                {
                    if (webresponse.GetResponseStream() == Stream.Null)
                    {
                        throw new Exception("GetResponseStream is null");
                    }

                    var response = (HttpWebResponse)webresponse;
                    tracingService.Trace("response: " + response);

                    if (response.StatusCode != HttpStatusCode.Accepted)
                    {
                        tracingService.Trace(string.Format("Unexpected status code returned: {0}",
                            response.StatusCode));
                        string returnString = response.StatusCode.ToString();
                        OutErrorArgument.Set(executionContext,
                            returnString);
                        OutResponse.Set(executionContext,
                            returnString);
                    }
                    else
                    {
                        tracingService.Trace(string.Format("Contract updated... Contract URI={0}",
                            postUrl));
                        string returnString = response.StatusCode.ToString();
                        OutErrorArgument.Set(executionContext,
                            returnString);
                        OutResponse.Set(executionContext,
                            returnString);
                    }
                }
            }
            catch (Exception ex)
            {
                ThrowInvalidPluginExecutionExceptionForRetry(executionContext,
                    tracingService,
                    "Unknown",
                    ex,
                    postUrl);
            }
        }

        public async static Task<AzureAccessToken> CreateOAuthAuthorizationToken(string clientId, string clientSecret, string resourceId, string tenantId)
        {
            AzureAccessToken token = null;
            string oauthUrl = string.Format("https://login.microsoftonline.com/{0}/oauth2/token", tenantId);
            string reqBody = string.Format("grant_type=client_credentials&client_id={0}&client_secret={1}&resource={2}", Uri.EscapeDataString(clientId), Uri.EscapeDataString(clientSecret), Uri.EscapeDataString(resourceId));

            HttpClient client = new HttpClient();
            HttpContent content = new StringContent(reqBody);
            content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/x-www-form-urlencoded");

            using (HttpResponseMessage response = await client.PostAsync(oauthUrl, content))
            {
                if (response.IsSuccessStatusCode)
                {
                    DataContractJsonSerializer serializer = new DataContractJsonSerializer(typeof(AzureAccessToken));
                    Stream json = await response.Content.ReadAsStreamAsync();
                    token = (AzureAccessToken)serializer.ReadObject(json);
                }
            }
            return token;
        }

        public class AzureAccessToken
        {

            public string access_token { get; set; }
            public string token_type { get; set; }
            public string expires_in { get; set; }
            public string expires_on { get; set; }
            public string resource { get; set; }
        }

    }
}