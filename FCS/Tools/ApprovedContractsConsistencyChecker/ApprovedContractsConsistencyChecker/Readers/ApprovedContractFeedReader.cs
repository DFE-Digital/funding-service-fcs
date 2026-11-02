
namespace ApprovedContractsConsistencyChecker.Readers
{
    using System.Configuration;

    public class ApprovedContractFeedReader : FeedReader
    {
        public override AzureAuthentication AuthenticationCredentials
        {
            get
            {
                return new AzureAuthentication(
                    ConfigurationManager.AppSettings["ContractManagementService:AADInstance"],
                    ConfigurationManager.AppSettings["ContractManagementService:Tenant"],
                    ConfigurationManager.AppSettings["ContractManagementService:ClientId"],
                    ConfigurationManager.AppSettings["ContractManagementService:AppKey"],
                    ConfigurationManager.AppSettings["ContractManagementService:ResourceId"]);
            }
        }

        public override string BaseAddress
        {
            get { return ConfigurationManager.AppSettings["ContractManagementServiceUrl"]; }
        }

        public override string PageSpecificUrl
        {
            get { return "/api/contracts/notifications/approvals/{0}"; }
        }

        public override string MostRecentPageUrl
        {
            get { return "/api/contracts/notifications/approvals"; }
        }

        public override string VendorAtomMediaType
        {
            get { return "application/vnd.sfa.contract.v1+atom+xml"; }
        }

        public override string FeedContentDescription
        {
            get { return "Approved Contracts"; }
        }
    }
}
