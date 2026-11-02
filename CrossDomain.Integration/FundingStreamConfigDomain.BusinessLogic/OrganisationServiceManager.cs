namespace SFA.FCT.FundingStreamConfigDomain.BusinessLogic
{
    using System.Configuration;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    
    public class OrganisationServiceManager
    {
        public static OrganizationService GetOrgService()
        {
            return new OrganizationService(GetConnection());
        }

        private static CrmConnection GetConnection()
        {
            return CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);
        }
    }
}
