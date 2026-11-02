namespace FundingAllocation.Tests.Endpoints.ReleaseGroup.Repositories
{
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using FundingAllocation.Endpoints.ReleaseGroup.Repositories;
    using Microsoft.Data.SqlClient;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ContractCommandRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractCommandRepository_Add_ShouldAddAndReturnId()
        {
            const string contractNumber = "cn - test2";
            const int version = 1;
            const int subVersion = 0;

            ClearFundingAllocations();
            ClearContracts(contractNumber);

            using var context = new FundingAllocationContext(GetContextOptions());
            ContractCommandRepository contractRepository = new ContractCommandRepository(context);

            // act
            int contractId = contractRepository.AddContract(contractNumber, version, subVersion).Result;

            // assert
            var contract = GetContract(contractNumber, version, subVersion);
            Assert.AreEqual(contractNumber, contract.ContractNumber, "The contract number is not correct");
            Assert.AreEqual(version, contract.ContractVersionNumber, "The contract version number is not correct");
            Assert.AreEqual(subVersion, contract.ContractSubVersionNumber, "The ContractSubVersionNumber is not correct");
            Assert.AreEqual(contract.Id, contractId, "The contractId returned is not correct");
        }

        private static Contract GetContract(string contractNumber, int version, int subVersion)
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            return context.Contracts.Single(c => c.ContractNumber == contractNumber);
        }

        private static void ClearContracts(string contractNumber)
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            context.Contracts.Where(c => c.ContractNumber == contractNumber).ToList().ForEach(c =>
            {
                context.Contracts.Remove(c);
            });

            context.SaveChanges();
        }

        private static void ClearFundingAllocations()
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            context.FundingAllocations.ToList().ForEach(fa =>
            {
                context.FundingAllocations.Remove(fa);
            });

            context.SaveChanges();
        }

        private static DbContextOptions<FundingAllocationContext> GetContextOptions()
        {
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];

            return new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;
        }
    }
}
