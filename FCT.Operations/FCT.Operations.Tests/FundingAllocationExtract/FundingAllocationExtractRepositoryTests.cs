namespace FCT.Operations.Tests.FundingAllocationExtract
{
    using System.Data.SqlClient;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.FundingAllocationExtract.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class FundingAllocationExtractRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingAllocationExtractRepository_ShouldExtractRows()
        {
            // arrange
            FundingAllocationExtractRepository repository = new FundingAllocationExtractRepository();

            // act
            var rows = repository.GetExtract(FundingAllocationExtractType.Parked,
                GetConnectionInfo()).Result;

            // rows
            Assert.IsTrue(rows.Any());
        }

        private static ConnectionInfo GetConnectionInfo()
        {
            var configuration = AppConfiguration.Configuration();

            return ConnectionInfo.CreateFrom(new SqlConnection(configuration["ConnectionStrings:NServiceBus/Persistence"]));
        }
    }
}
