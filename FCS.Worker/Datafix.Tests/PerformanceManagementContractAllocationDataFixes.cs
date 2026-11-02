namespace Datafix.Tests
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;

    [TestClass]
    public class PerformanceManagementContractAllocationDataFixes
    {
        [TestMethod, TestCategory("Datafix_R65")]
        public void PerformanceManagementContractAllocation_UpdateDeliveryOrgLegalName()
        {
            var orgs = GetOrgsFromOrgTable();

            var contractAllocations = GetContractAllocations();

            contractAllocations.ForEach(ca =>
            {
                var matchingOrg = orgs.Single(o => o.Ukprn == ca.DeliveryOrgUkprn);
                ca.DeliveryOrgLegalName = matchingOrg.TradingName;
            });

            contractAllocations.ForEach(UpdateContractAllocationInDb);
        }

        private static void UpdateContractAllocationInDb(SimpleAllocation contractAllocation)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["PerformanceManagementDbContext"]
                .ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql =
                    @"update [PerformanceManagement].[ContractAllocation] set [Contractor_LegalName] = @legalName
                             where [AllocationNumber] = @allocationNumber";

                connection.Execute(sql, new
                {
                    legalName = contractAllocation.DeliveryOrgLegalName,
                    allocationNumber = contractAllocation.AllocationNumber
                });
            }
        }

        private IReadOnlyCollection<SimpleOrg> GetOrgsFromOrgTable()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["organisationDomainDatabase"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql = @"select Ukprn, TradingName from [dbo].[Organisations]";

                return connection.Query<SimpleOrg>(sql).ToList();
            }
        }

        private IReadOnlyCollection<SimpleAllocation> GetContractAllocations()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["PerformanceManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql = @"select AllocationNumber, Contractor_Ukprn as DeliveryOrgUkprn, Contractor_LegalName as DeliveryOrgLegalName from [PerformanceManagement].[ContractAllocation]";

                return connection.Query<SimpleAllocation>(sql).ToList();
            }
        }

        private class SimpleOrg
        {
            public SimpleOrg(int ukprn, string tradingName)
            {
                Ukprn = ukprn;
                TradingName = tradingName;
            }

            public int Ukprn { get; }

            public string TradingName { get; }
        }

        private class SimpleAllocation
        {
            public SimpleAllocation(string allocationNumber, int deliveryOrgUkprn, string deliveryOrgLegalName)
            {
                DeliveryOrgUkprn = deliveryOrgUkprn;
                DeliveryOrgLegalName = deliveryOrgLegalName;
                AllocationNumber = allocationNumber;
            }

            public string AllocationNumber { get;}

            public int DeliveryOrgUkprn { get; }

            public string DeliveryOrgLegalName { get; set; }
        }
    }
}
