// <summary>Implements the CallAllocationManagementService Workflow Activity.</summary>
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow
{
    using System;
    using System.Activities;
    using System.IO;
    using System.Net;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Workflow;
    using System.Text;
    using System.Runtime.Serialization.Json;
    using System.Threading.Tasks;
    using System.Net.Http;

    public sealed class CallSBAllocationManagementService : CodeActivity
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
        [Input("Intent")]
        public InArgument<string> InputIntent { get; set; }
		
		[RequiredArgument]
        [Input("Funding Type")]
        [ReferenceTarget("sfa_fundingtype")]
        public InArgument<string> InputFundingType { get; set; }
		
		[RequiredArgument]
        [Input("Funding Period")]
        [ReferenceTarget("sfa_period")]
        public InArgument<string> InputFundingPeriod { get; set; }

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

            const string RELEASE = "release";
			const string RELEASE_PATH = "cfs-release/allocations";

            // Create the tracing service
            ITracingService tracingService = executionContext.GetExtension<ITracingService>();

            if (tracingService == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve tracing service.");
            }

            tracingService.Trace("Entered CallSBAllocationManagementService.Execute(), Activity Instance Id: {0}, Workflow Instance Id: {1}", executionContext.ActivityInstanceId, executionContext.WorkflowInstanceId);

            // Create the context
            IWorkflowContext context = executionContext.GetExtension<IWorkflowContext>();

            if (context == null)
            {
                throw new InvalidPluginExecutionException("Failed to retrieve workflow context.");
            }

            tracingService.Trace("CallSBAllocationManagementService.Execute(), Correlation Id: {0}, Initiating User: {1}", context.CorrelationId, context.InitiatingUserId);

            var serviceFactory = executionContext.GetExtension<IOrganizationServiceFactory>();
            var service = serviceFactory.CreateOrganizationService(context.UserId);

            string cmservice = InputWebServiceUri.Get(executionContext);
            string crmintent = InputIntent.Get(executionContext);

            try
            {
                using (var xrmContext = new OrganizationServiceContext(service))
                {
                    

                    if (!string.IsNullOrEmpty(cmservice))
                    {
                        tracingService.Trace("in main body of request");
						string fundingType = InputFundingType.Get(executionContext);
						string fundingPeriod = InputFundingPeriod.Get(executionContext);

                        var url = string.Empty;
                        var postData = string.Empty;
                        string contentType = string.Empty;

						if (crmintent == RELEASE)
                        {
							tracingService.Trace("release of selected allocations");
                            contentType = "application/json";
                            //add the release specific path to the URL
                            cmservice += RELEASE_PATH;
                            postData = string.Format("{{\"FundingType\":\"{0}\",\"FundingPeriod\":\"{1}\"}}", fundingType, fundingPeriod);
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

            tracingService.Trace("Exiting CallSBAllocationManagementService.Execute(), Correlation Id: {0}", context.CorrelationId);
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
                request.Method = "POST";
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

        private void ThrowInvalidPluginExecutionExceptionForRetry(ActivityContext executionContext, ITracingService tracingService, string httpStatusCode, Exception ex,
            string url)
        {
            OutResponse.Set(executionContext,
                httpStatusCode);
            OutErrorArgument.Set(executionContext,
                ex.Message);

            tracingService.Trace(
                "Exiting CallSBAllocationManagementService.Execute(), Correlation Id: {0}, eHttpStatusCode : {1}",
                OutErrorArgument,
                httpStatusCode);

            throw new InvalidPluginExecutionException(
                OperationStatus.Retry,
                "An error occurred trying to call allocation management service: Exception: " + ex + " InnerException:" +
                    ex.InnerException +
                    " , Website return code: " + httpStatusCode +
                    " , Message: " + ex.Message + ". URI Called: " + url);
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