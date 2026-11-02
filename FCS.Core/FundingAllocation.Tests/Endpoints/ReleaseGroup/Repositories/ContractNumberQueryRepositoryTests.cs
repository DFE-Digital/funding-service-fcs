namespace FundingAllocation.Tests.Endpoints.ReleaseGroup.Repositories
{
    using DataStore;
    using FundingAllocation.Endpoints.ReleaseGroup.Repositories;
    using Microsoft.Data.SqlClient;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ContractNumberQueryRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractNumberQueryRepository_GetNextContractNumberForFundingType_ShouldGetNextNumber()
        {
            // arrange
            const string fundingType = "EDSK";
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var context = new FundingAllocationContext(options);
            SqlParameter result = new SqlParameter("@ReadId", System.Data.SqlDbType.Int)
            {
                Direction = System.Data.ParameterDirection.Output
            };
            context.Database.ExecuteSqlRawAsync($"SELECT @ReadId = (NEXT VALUE FOR [ContractManagement].[Contract_{fundingType}_seq]);", parameters: result).Wait();

            var initialReadId = (int)result.Value;
            ContractNumberQueryRepository repository = new ContractNumberQueryRepository(context);

            // act
            var readId = repository.GetNextContractNumberForFundingType(fundingType).Result;

            // assert
            Assert.AreEqual(initialReadId + 1, readId);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractNumberQueryRepository_GetNextMasterContractNumber_ShouldGetNextNumber()
        {
            // arrange
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var context = new FundingAllocationContext(options);
            SqlParameter result = new SqlParameter("@ReadId", System.Data.SqlDbType.Int)
            {
                Direction = System.Data.ParameterDirection.Output
            };
            context.Database.ExecuteSqlRawAsync($"SELECT @ReadId = (NEXT VALUE FOR [ContractManagement].[Master_ESFA_seq]);", parameters: result).Wait();

            var initialReadId = (int)result.Value;
            ContractNumberQueryRepository repository = new ContractNumberQueryRepository(context);

            // act
            var readId = repository.GetNextMasterContractNumber().Result;

            // assert
            Assert.AreEqual(initialReadId + 1, readId);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractNumberQueryRepository_GetNextAllocationNumber_ShouldGetNextNumber()
        {
            // arrange
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var context = new FundingAllocationContext(options);
            SqlParameter result = new SqlParameter("@ReadId", System.Data.SqlDbType.Int)
            {
                Direction = System.Data.ParameterDirection.Output
            };
            context.Database.ExecuteSqlRawAsync($"SELECT @ReadId = (NEXT VALUE FOR [ContractManagement].[Allocation_1619ED_seq]);", parameters: result).Wait();

            var currentSequneceValue = (int)result.Value;
            ContractNumberQueryRepository repository = new ContractNumberQueryRepository(context);

            // act
            var nextSequence = repository.GetNextAllocationNumber("1619ED");

            // assert
            Assert.AreEqual(currentSequneceValue + 1, nextSequence);
        }
    }
}
