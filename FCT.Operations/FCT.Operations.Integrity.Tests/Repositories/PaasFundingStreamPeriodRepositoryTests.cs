namespace FCT.Operations.Integrity.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.IO;
    using System.Linq;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Operations.Integrity.Repositories;

    [TestClass]
    public class PaasFundingStreamPeriodRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void PaasFundingStreamPeriodRepository_GetFundingStreamPeriodCodesThatAreActive()
        {
            // arrange
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            PaasFundingStreamPeriodRepository paasFundingStreamPeriodRepository = new PaasFundingStreamPeriodRepository(new SqlConnection(connectionString));

            // act
            IReadOnlyCollection<string> activeFsps = paasFundingStreamPeriodRepository.GetFundingStreamPeriodCodesThatAreActive(DateTime.UtcNow);

            WriteToCsv(activeFsps);

            // assert
            Assert.AreEqual(62, activeFsps.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaasSubnominalAggregationRepository_IsFundingStreamPeriodPayOnInstruction()
        {
            // arrange
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            PaasFundingStreamPeriodRepository paasFundingStreamPeriodRepository = new PaasFundingStreamPeriodRepository(new SqlConnection(connectionString));

            // act
            bool isPayOnInstruction = paasFundingStreamPeriodRepository.IsFundingStreamPeriodPayOnInstruction("LEVY1799");

            // assert
            isPayOnInstruction.Should().BeTrue();
        }

        private static void WriteToCsv(IEnumerable<string> items)
        {
            List<string> lines = items
                .OrderBy(s => s)
                .ToList();

            File.WriteAllText($"PaasFundingStreamPeriodRepository_{Guid.NewGuid()}.csv", string.Join(Environment.NewLine, lines));
        }
    }
}
