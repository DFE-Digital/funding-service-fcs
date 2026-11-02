namespace FCT.Operations.Integrity.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.IO;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Operations.Integrity.DTOs;
    using SFA.FCT.Operations.Integrity.Repositories;

    [TestClass]
    public class PaasSubnominalAggregationRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void PaasSubnominalAggregationRepository_GetSubnominalAggregationsForActiveFsps_ShouldReturnAllSubnominalAggregationsForActiveFsps()
        {
            // arrange
            string connectionString = ConfigurationManager.ConnectionStrings["PaymentGenerationDbContext"].ConnectionString;
            PaasSubnominalAggregationRepository repository = new PaasSubnominalAggregationRepository(new SqlConnection(connectionString));
            IReadOnlyCollection<string> activeFsps = new PaasFundingStreamPeriodRepository(new SqlConnection(connectionString)).GetFundingStreamPeriodCodesThatAreActive(DateTime.UtcNow);

            // act
            IReadOnlyCollection<SubnominalAggregationInfo> subnominalAggregations = repository.GetSubnominalAggregations(activeFsps);

            WriteToCsv(subnominalAggregations);

            // assert
            bool areTheyAllInactiveForInactiveAllocation = subnominalAggregations.Where(sa => sa.AllocationNumber == "16TR-2359")
                .All(sa => sa.IsInactiveContract);

            Assert.AreEqual(true, areTheyAllInactiveForInactiveAllocation, "This allocation is inactive - 16TR-2359");
            bool areTheyAllActiveForActiveAllocation = subnominalAggregations.Where(sa => sa.AllocationNumber == "16TR-2360")
                .All(sa => !sa.IsInactiveContract);

            Assert.AreEqual(true, areTheyAllInactiveForInactiveAllocation, "This allocation is inactive");
            Assert.AreEqual(true, areTheyAllActiveForActiveAllocation, "This allocation is active - 16TR-2360");
        }

        private static void WriteToCsv(IEnumerable<SubnominalAggregationInfo> items)
        {
            List<string> lines = new List<string>
            {
                "AllocationNumber,Period,SubnominalCode,PaymentType,AggregatedValue"
            };

            lines.AddRange(items
                .OrderBy(i => i.AllocationNumber)
                .ThenBy(i => i.Period)
                .ThenBy(i => i.SubnominalCode)
                .ThenBy(i => i.PaymentType)
                .Select(i => $"{i.AllocationNumber},{i.Period},{i.SubnominalCode},{i.PaymentType},{i.AggregatedValue}"));

            File.WriteAllText($"{Guid.NewGuid()}.csv", string.Join(Environment.NewLine, lines));
        }
    }
}
