namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.PaymentAggregated.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentSchedule.PaymentAggregated.Repositories;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    [TestClass]
    public class CrmSubnominalAggregationTechExploration
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void SubnominalAggregationRepository_ShouldHaveEquivalentValuesInPaasAndCrm()
        {
            const string allocationNumber = "ALLB-7047";
            const int version = 2;
            SubnominalAggregationRepository repository = new SubnominalAggregationRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());
            Guid allocationId = GetAllocationId(allocationNumber, version);
            // 
            IReadOnlyCollection<sfa_subnominalaggregation> subnominalsRelatedToAllocationId = repository.GetSubnominalsRelatedToAllocationId(allocationId);
            var crmValues = subnominalsRelatedToAllocationId.Select(crmSa => ToSimpleSubnominalInfo(crmSa, allocationNumber)).ToList();

            var paasSubnominals = GetSubnominalsFromPaaS(allocationNumber);

            var valuesInCrmNotInPaas = crmValues.Where(crmV => !paasSubnominals.Contains(crmV)).ToList();
            Assert.IsFalse(valuesInCrmNotInPaas.Any());
        }

        private SimpleSubnominalInfo ToSimpleSubnominalInfo(sfa_subnominalaggregation crmSubnominalaggregation, string allocationNumber)
        {
            DateTime dt = DateTime.ParseExact(crmSubnominalaggregation.sfa_Period, "MMM-yy", null);
            var period = (dt.Year * 100) + dt.Month;

            return new SimpleSubnominalInfo(
                allocationNumber,
                period.ToString(),
                crmSubnominalaggregation.sfa_SubnominalCode,
                crmSubnominalaggregation.sfa_PaymentTypeEnum.ToString(),
                crmSubnominalaggregation.sfa_AggregatedValue);
        }

        private Guid GetAllocationId(string allocationNumber, int version)
        {
            using(var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return (from c in xrmContext.sfa_contractSet
                    join a in xrmContext.sfa_contractallocationSet on c.Id equals a.sfa_ContractId.Id
                    where a.sfa_contractallocationnumber == allocationNumber &&
                          c.sfa_Version == version &&
                          c.sfa_LatestVersion == true
                    select a.sfa_contractallocationId.Value).ToList().Single();
            }
        }

        private IReadOnlyCollection<SimpleSubnominalInfo> GetSubnominalsFromPaaS(string allocationNumber)
        {
            const string sql = @"SELECT [AllocationNumber]
                                      ,[Period]
                                      ,[SubnominalCode]
                                      ,[PaymentType]
                                      ,[AggregatedValue]
                                  FROM [PaymentGeneration].[SubnominalAggregation]
                                  where AllocationNumber = @allocationNumber";

            var identifier = Guid.NewGuid().ToString();
            string connectionString = ConfigurationManager.ConnectionStrings["PaymentManagementPolicyContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query<SimpleSubnominalInfo>(sql, param: new { allocationNumber }).ToList();
            }
        }

        private class SimpleSubnominalInfo
        {
            public SimpleSubnominalInfo(string allocationNumber, string period, string subnominalCode, string paymentType, decimal? aggregatedValue)
            {
                AllocationNumber = allocationNumber;
                Period = int.Parse(period);
                SubnominalCode = int.Parse(subnominalCode);
                PaymentType = paymentType.ToUpper();
                AggregatedValue = aggregatedValue ?? 0;
            }

            public string AllocationNumber { get; }
            public int Period { get; }
            public int SubnominalCode { get; }
            public string PaymentType { get; }
            public decimal AggregatedValue { get; }

            public override bool Equals(object obj)
            {
                if (obj is SimpleSubnominalInfo other)
                {
                    return AllocationNumber == other.AllocationNumber &&
                           Period == other.Period &&
                           SubnominalCode == other.SubnominalCode &&
                           PaymentType == other.PaymentType &&
                           AggregatedValue == other.AggregatedValue;
                }

                return false;
            }

            public override int GetHashCode()
            {
                return AllocationNumber.GetHashCode() ^
                       Period.GetHashCode() ^
                       SubnominalCode.GetHashCode() ^
                       PaymentType.GetHashCode() ^
                       AggregatedValue.GetHashCode();
            }
        }
    }
}
