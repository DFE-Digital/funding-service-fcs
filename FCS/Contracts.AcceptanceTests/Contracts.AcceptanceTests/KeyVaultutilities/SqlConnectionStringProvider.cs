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
using System.Configuration;

namespace SFA.FCT.Contracts.AcceptanceTests
{
    public class SqlConnectionStringProvider
    {
        public static string Get(string connectionStringName)
        {
            // ✅ Key Vault override path (test / CI / acceptance)
            var keyVaultConnection = GetKeyVaultConnection();

            if (!string.IsNullOrWhiteSpace(keyVaultConnection))
            {
                return keyVaultConnection;
            }

            // ✅ Production / legacy fallback
            return ConfigurationManager
                .ConnectionStrings[connectionStringName]
                .ConnectionString;
        }

        private static string GetKeyVaultConnection()
        {
            // Order does not matter – all are set to same value
            if (!string.IsNullOrWhiteSpace(ContractManagementDbContext.KeyVaultValue))
                return ContractManagementDbContext.KeyVaultValue;

            if (!string.IsNullOrWhiteSpace(PaymentGenerationDbContext.KeyVaultValue))
                return PaymentGenerationDbContext.KeyVaultValue;

            if (!string.IsNullOrWhiteSpace(PaymentManagementPolicyContext.KeyVaultValue))
                return PaymentManagementPolicyContext.KeyVaultValue;

            if (!string.IsNullOrWhiteSpace(PerformanceManagementDbContext.KeyVaultValue))
                return PerformanceManagementDbContext.KeyVaultValue;

            if (!string.IsNullOrWhiteSpace(ContractRequestDbContext.KeyVaultValue))
                return ContractRequestDbContext.KeyVaultValue;

            if (!string.IsNullOrWhiteSpace(DocumentsDomainDbContext.KeyVaultValue))
                return DocumentsDomainDbContext.KeyVaultValue;

            if (!string.IsNullOrWhiteSpace(OperationsDbContext.KeyVaultValue))
                return OperationsDbContext.KeyVaultValue;

            if (!string.IsNullOrWhiteSpace(MonitoringDeliverablesDbContext.KeyVaultValue))
                return MonitoringDeliverablesDbContext.KeyVaultValue;

            if (!string.IsNullOrWhiteSpace(PaymentSchedulePolicyContext.KeyVaultValue))
                return PaymentSchedulePolicyContext.KeyVaultValue;
            
            if (!string.IsNullOrWhiteSpace(OrganisationDomainDbContext.KeyVaultValue))
                return OrganisationDomainDbContext.KeyVaultValue;

            if (!string.IsNullOrWhiteSpace(OverrideDateDBContext.KeyVaultValue))
                return OverrideDateDBContext.KeyVaultValue;
            if (!string.IsNullOrWhiteSpace(OverrideDateDBContext.KeyVaultValue))
                return OverrideDateDBContext.KeyVaultValue;

            return null;
        }

    }
}
