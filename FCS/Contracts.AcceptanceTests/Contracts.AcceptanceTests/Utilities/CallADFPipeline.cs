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
            get { return ConfigurationManager.AppSettings["applicationId"]; }
        }
        public string ClientSecret
        {
            get { return ConfigurationManager.AppSettings["clientSecret"]; }
        }
        public string SubscriptionId
        {
            get { return ConfigurationManager.AppSettings["subscriptionId"]; }
        }
        public string TenantID
        {
            get { return ConfigurationManager.AppSettings["tenantID"]; }
        }
        public string ResourceGroupName
        {
            get { return ConfigurationManager.AppSettings["ResourceGroupName"]; }
        }
        public string FactoryName
        {
            get { return ConfigurationManager.AppSettings["FactoryName"]; }
        }
        public string PipeLineName
        {
            get { return ConfigurationManager.AppSettings["PipeLineName"]; }
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
