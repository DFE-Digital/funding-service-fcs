using System;
using Microsoft.Rest;
using Microsoft.Azure.Management.DataFactory;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using System.Configuration;

namespace SFA.FCT.Contracts.AcceptanceTests.Utilities
{
    public class CallADFPipeline
    {
        public IDataFactoryManagementClient client;

        public string ApplicationId
        {
            get { return TestConfiguration.Configuration["Azure:ApplicationId"]; }
        }
        public string ClientSecret
        {
            get { return TestConfiguration.Configuration["Azure:ClientSecret"]; }
        }
        public string SubscriptionId
        {
            get { return TestConfiguration.Configuration["Azure:SubscriptionId"]; }
        }
        public string TenantID
        {
            get { return TestConfiguration.Configuration["Azure:TenantId"]; }
        }
        public string ResourceGroupName
        {
            get { return TestConfiguration.Configuration["Azure:ResourceGroupName"]; }
        }
        public string FactoryName
        {
            get { return TestConfiguration.Configuration["Azure:FactoryName"]; }
        }
        public string PipeLineName
        {
            get { return TestConfiguration.Configuration["Azure:PipelineName"]; }
        }

        public void create_adf_client()
        {
            // Authenticate and create a data factory management client
            var context = new AuthenticationContext("https://login.windows.net/" + TenantID);
            var ClientCredential = new ClientCredential(ApplicationId, ClientSecret);

            var result = context.AcquireTokenAsync(
                "https://management.azure.com/", ClientCredential).Result;

            var cred = new TokenCredentials(result.AccessToken);
            client = new DataFactoryManagementClient(cred)
            {
                SubscriptionId = SubscriptionId
            };
        }

        public CallADFPipeline()
        {
            create_adf_client();
        }

        public void RunPipeline()
        {
            var runResponse = client.Pipelines.CreateRunWithHttpMessagesAsync(ResourceGroupName, FactoryName, PipeLineName).Result.Body;

        }
    }

}
