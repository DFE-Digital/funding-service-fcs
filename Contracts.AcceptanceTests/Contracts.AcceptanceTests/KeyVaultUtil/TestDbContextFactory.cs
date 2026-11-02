using ADMonitoringDomain.DataStore;
using ContractManagement.DataStore;
using OrganisationDomain.Integration.DataStore;
using PaymentGenerationDomain.Integration.DataStore;
using SFA.FCT.AllocationDelivery.DataStore;
using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
using SFA.FCT.ContractRequestDomain.DataStore;
using SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.CrmReplicaRepo;
using SFA.FCT.CrossDomain.Integration.OverrideDate;
using SFA.FCT.DocumentsDomain.DataStore;
using SFA.FCT.Operations.DataStore;
using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
using SFA.FCT.PerformanceManagementDomain.DataStore;
using System.Net;

namespace SFA.FCT.Contracts.AcceptanceTests
{
    public class TestDbContextFactory
    {
        public static void InitializeForTests()
        {
            System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            var config = new KeyVaultTestConfiguration();
            var sqlconn = config["ConnectionStrings:CommonDBContext"];
            var storageConn = config["AzureStorage:ConnectionString"];
            var CRMConn = config["CrmReplicaDbContext"];
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
            AllocationDeliveryDbContext.KeyVaultValue = sqlconn;
            AllocationDeliveryMonitoringDbContext.KeyVaultValue = sqlconn;
            CrmReplicaDbContext.KeyVaultValue = CRMConn;
            StorageConnectionStringProvider.StorageConnectionString = storageConn;

        }

    }
}
