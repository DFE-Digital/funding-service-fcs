namespace AllocationsEventsLoader.Helpers
{
    using System;
    using System.Configuration;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;

    public static class CrmManager
    {
        public const string ContractDeliverablePeriodEntityName = "sfa_contractdeliverableperiod";
        public static void DeleteEntity(string entityName, Guid primaryKey)
        {
            CrmOrganizationService.Delete(entityName, primaryKey);
        }

        private static OrganizationService CrmOrganizationService => new OrganizationService(CrmConnection);

        private static CrmConnection CrmConnection
        {
            get { return CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString); }
        }
    }
}
