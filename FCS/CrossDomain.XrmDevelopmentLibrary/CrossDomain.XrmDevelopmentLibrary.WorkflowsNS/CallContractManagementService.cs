// <copyright file="CallContractManagementService.cs" company="">
// Copyright (c) 2015 All Rights Reserved
// </copyright>
// <author></author>
// <date>5/19/2015 2:39:50 PM</date>
// <summary>Implements the CallContractManagementService Workflow Activity.</summary>

using System.Net.Http;
using System.Web.UI.WebControls;

namespace CrossDomain.XrmDevelopmentLibrary.WorkflowsNS
{
    using System;
    using System.Activities;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http.Headers;
    using System.ServiceModel;
    using System.Web;
    using Utilities;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Workflow;
    using System.Text;

    public sealed class CallContractManagementService : CodeActivity
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

                        var url = string.Empty;

                        tracingService.Trace("C: About to get call url {0}", url);
                        var postData = string.Format("<ContractInformation xmlns:xsi =\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><ContractNumber>{0}</ContractNumber>" +
                                        "<MasterContractNumber>{1}</MasterContractNumber><ContractVersionNumber>{2}</ContractVersionNumber></ContractInformation>", contractNumber,
                            masterContractNumber,ContractVersionNumber);
                        url = cmservice;
                        tracingService.Trace("parse postData string {0}", postData);

                        OutUrlString.Set(executionContext, url);
                        PostObjectwithpostData(url, executionContext, tracingService, postData);

                       
                       
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

        #region "Obselete Method"

        //private void PutObject(string postUrl, ActivityContext executionContext, ITracingService tracingService)
        //{
        //    try
        //    {
        //        var request = (HttpWebRequest) WebRequest.Create(postUrl);
        //        request.Method = "PUT";
        //        request.ContentType = "application/xml";
        //        request.ContentLength = 0;

        //        tracingService.Trace("About to add header");

        //        AddAuthorizationHeader(request, executionContext);

        //        tracingService.Trace("About to get call GetResponse");

        //        using (var webresponse = request.GetResponse())
        //        {
        //            if (webresponse.GetResponseStream() == Stream.Null)
        //            {
        //                throw new Exception("GetResponseStream is null");
        //            }

        //            var response = (HttpWebResponse) webresponse;

        //            if (response.StatusCode != HttpStatusCode.OK)
        //            {
        //                tracingService.Trace(string.Format("Unexpected status code returned: {0}",
        //                    response.StatusCode));
        //                string returnString = response.StatusCode.ToString();
        //                OutErrorArgument.Set(executionContext,
        //                    returnString);
        //                OutResponse.Set(executionContext,
        //                    returnString);
        //            }
        //            else
        //            {
        //                tracingService.Trace(string.Format("Contract updated... Contract URI={0}",
        //                    postUrl));
        //                string returnString = response.StatusCode.ToString();
        //                OutErrorArgument.Set(executionContext,
        //                    returnString);
        //                OutResponse.Set(executionContext,
        //                    returnString);
        //            }
        //        }
        //    }
        //    catch (HttpException httpException)
        //    {
        //        ThrowInvalidPluginExecutionExceptionForRetry(executionContext,
        //            tracingService,
        //            httpException.GetHttpCode().ToString(),
        //            httpException,
        //            postUrl);
        //    }
        //    catch (Exception ex)
        //    {
        //        ThrowInvalidPluginExecutionExceptionForRetry(executionContext,
        //            tracingService,
        //            "Unknown",
        //            ex,
        //            postUrl);
        //    }
        //}

        //private void PostObject(string postUrl,  ActivityContext executionContext, ITracingService tracingService,string postData = null)
        //{
        //    try
        //    {
        //        //byte[] byteArray = Encoding.UTF8.GetBytes(postData);

        //        var request = (HttpWebRequest)WebRequest.Create(postUrl);
        //        request.Method = "POST";
        //        request.ContentType = "application/x-www-form-urlencoded"; 
        //        //request.ContentLength = byteArray.Length;
        //        request.ContentLength = 0;

        //        tracingService.Trace("About to add header");

        //        AddAuthorizationHeader(request, executionContext);

        //        tracingService.Trace("About to get call GetResponse");


        //        //using (var webpageStream = request.GetRequestStream())
        //        //{
        //        //    webpageStream.Write(byteArray,0, byteArray.Length);
        //        //}

        //        using (var webresponse = request.GetResponse())
        //        {
        //            if (webresponse.GetResponseStream() == Stream.Null)
        //            {
        //                throw new Exception("GetResponseStream is null");
        //            }

        //            var response = (HttpWebResponse)webresponse;

        //            if (response.StatusCode != HttpStatusCode.OK)
        //            {
        //                tracingService.Trace(string.Format("Unexpected status code returned: {0}",
        //                    response.StatusCode));
        //                string returnString = response.StatusCode.ToString();
        //                OutErrorArgument.Set(executionContext,
        //                    returnString);
        //                OutResponse.Set(executionContext,
        //                    returnString);
        //            }
        //            else
        //            {
        //                tracingService.Trace(string.Format("Contract updated... Contract URI={0}",
        //                    postUrl));
        //                string returnString = response.StatusCode.ToString();
        //                OutErrorArgument.Set(executionContext,
        //                    returnString);
        //                OutResponse.Set(executionContext,
        //                    returnString);
        //            }
        //        }
        //    }
        //    catch (HttpException httpException)
        //    {
        //        ThrowInvalidPluginExecutionExceptionForRetry(executionContext,
        //            tracingService,
        //            httpException.GetHttpCode().ToString(),
        //            httpException,
        //            postUrl);
        //    }
        //    catch (Exception ex)
        //    {
        //        ThrowInvalidPluginExecutionExceptionForRetry(executionContext,
        //            tracingService,
        //            "Unknown",
        //            ex,
        //            postUrl);
        //    }
        //}

        #endregion

        private void PostObjectwithpostData(string postUrl, ActivityContext executionContext, ITracingService tracingService, string postData)
        {
            try
            {
                byte[] byteArray = Encoding.UTF8.GetBytes(postData);
                var request = (HttpWebRequest)WebRequest.Create(postUrl);
                request.Method = "POST";
                request.ContentType = "application/xml";
                request.ContentLength = byteArray.Length;
               

                tracingService.Trace("About to add header");

                AddAuthorizationHeader(request, executionContext);

                tracingService.Trace("About to get call GetResponse");


                using (var webpageStream = request.GetRequestStream())
                {
                    webpageStream.Write(byteArray, 0, byteArray.Length);
                }

                using (var webresponse = request.GetResponse())
                {
                    if (webresponse.GetResponseStream() == Stream.Null)
                    {
                        throw new Exception("GetResponseStream is null");
                    }

                    var response = (HttpWebResponse)webresponse;

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
            catch (HttpException httpException)
            {
                ThrowInvalidPluginExecutionExceptionForRetry(executionContext,
                    tracingService,
                    httpException.GetHttpCode().ToString(),
                    httpException,
                    postUrl);
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

        private void AddAuthorizationHeader(WebRequest client, ActivityContext executionContext)
        {
            client.PreAuthenticate = true;
            client.Headers.Add("Authorization",
                new AuthenticationHeaderValue("Bearer",
                    AzureAuthentication.GetAuthenticationResult(
                        InputAzureAdInstance.Get(executionContext),
                        InputAzureTenant.Get(executionContext),
                        InputAzureClientId.Get(executionContext),
                        InputAzureAppKey.Get(executionContext),
                        InputAzureResourceId.Get(executionContext)).AccessToken).ToString());
        }
    }
}