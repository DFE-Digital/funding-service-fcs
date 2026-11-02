using ContractManagement.DataStore;
//using Operations.DataStore;
using PaymentGenerationDomain.Integration.DataStore;
using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
using SFA.FCT.ContractRequestDomain.DataStore;
using SFA.FCT.DocumentsDomain.DataStore;
using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
using SFA.FCT.PerformanceManagementDomain.DataStore;

namespace CommonKeyVaultUtility
{
    public static class TestDbContextFactory
    {
        public static void InitializeForTests()
        {
            var config = new KeyVaultTestConfiguration();
            var sqlconn = config["ConnectionStrings:CommonDBContext"];

            ContractManagementDbContext.KeyVaultValue = sqlconn;
            PaymentGenerationDbContext.KeyVaultValue = sqlconn;
            PaymentManagementPolicyContext.KeyVaultValue = sqlconn;
            PerformanceManagementDbContext.KeyVaultValue = sqlconn;
            ContractRequestDbContext.KeyVaultValue = sqlconn;
            DocumentsDomainDbContext.KeyVaultValue = sqlconn;
            //OperationsDbContext.KeyVaultValue = sqlconn;
            MonitoringDeliverablesDbContext.KeyVaultValue = sqlconn;

        }

    }
}
