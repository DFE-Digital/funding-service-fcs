
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

    public sealed class CallPerformanceManagementService : CodeActivity
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

        protected override void Execute(CodeActivityContext executionContext)
        {
            // Create the tracing service
            ITracingService tracingService = executionContext.GetExtension<ITracingService>();

            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace("Entered CallPerformancetManagementService.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("CallPerformanceManagementService.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            var serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            var service = serviceFactory.CreateOrganizationService(context.UserId);

            string cmservice = InputWebServiceUri.Get(executionContext);

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    tracingService.Trace("About to get funding claim reconciliation");

                    var inputFCR = new EntityReference("sfa_fundingclaimreconciliation", context.PrimaryEntityId);

                    var contract = xrmContext
                        .CreateQuery("sfa_fundingclaimreconciliation")
                        .FirstOrDefault(e => ((EntityReference)e["sfa_fundingclaimreconciliationid"]).Equals(inputFCR));

                    tracingService.Trace("About to get extract fcr name");

                    var fcrName = contract.GetAttributeValue<string>("sfa_name");

                    if (!string.IsNullOrEmpty(cmservice))
                    {
                       
                        var url = string.Empty;

                        tracingService.Trace("C: About to get call url {0}", url);
                        var postData = string.Format("<ClaimInformation xmlns:xsi =\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><FCRId>{0}</FCRId>" +
                                       "<FCRName>{1}</FCRName></ClaimInformation>", inputFCR.Id,
                           fcrName);

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
                "Exiting CallPerformanceManagementService.Execute(), Correlation Id: {0}, eHttpStatusCode : {1}",
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
