using ContractManagement.DataStore;
using OrganisationDomain.Integration.DataStore;
using PaymentGenerationDomain.Integration.DataStore;
using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
using SFA.FCT.ContractRequestDomain.DataStore;
using SFA.FCT.CrossDomain.Integration.OverrideDate;
using SFA.FCT.DocumentsDomain.DataStore;
using SFA.FCT.Operations.DataStore;
using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
using SFA.FCT.PerformanceManagementDomain.DataStore;

namespace SFA.FCT.Contracts.AcceptanceTests
{
    public static class TestDbContextFactory
    {
        public static void InitializeForTests()
        {
            var config = new KeyVaultTestConfiguration();
            var sqlconn = config["ConnectionStrings:CommonDBContext"];
            var storageConn = config["AzureStorage:ConnectionString"];
            ContractManagementDbContext.KeyVaultValue = sqlconn;
            PaymentGenerationDbContext.KeyVaultValue = sqlconn;
            PaymentManagementPolicyContext.KeyVaultValue = sqlconn;
            PerformanceManagementDbContext.KeyVaultValue = sqlconn;
            ContractRequestDbContext.KeyVaultValue = sqlconn;
            DocumentsDomainDbContext.KeyVaultValue = sqlconn;
            OperationsDbContext.KeyVaultValue = sqlconn;
            MonitoringDeliverablesDbContext.KeyVaultValue = sqlconn;
            PaymentSchedulePolicyContext.KeyVaultValue = sqlconn;
            OrganisationDomainDbContext.KeyVaultValue = sqlconn;
            OverrideDateDBContext.KeyVaultValue = sqlconn;

            StorageConnectionStringProvider.StorageConnectionString = storageConn;

        }

    }
}
