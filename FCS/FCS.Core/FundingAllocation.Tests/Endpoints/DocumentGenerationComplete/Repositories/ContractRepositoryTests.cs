namespace FundingAllocation.Tests.Endpoints.DocumentGenerationComplete.Repositories
{
    using System;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using FundingAllocation.Endpoints.DocumentGenerationComplete.Repositories;
    using Microsoft.Data.SqlClient;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ContractRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractRepository_SetContractCreatedInCrmFlag_ShouldUpdateIsCreatedInCrm()
        {
            // arrange
            const string contractNumber = "cn - test1";
            const int version = 1;
            const int subVersion = 0;

            ClearFeedReads();
            ClearContracts(contractNumber);
            CreateContract(contractNumber, version, subVersion);

            using var context = new FundingAllocationContext(GetContextOptions());
            ContractRepository contractRepository = new ContractRepository(context);

            // act
            contractRepository.SetContractCreatedInCrmFlag(contractNumber, version, subVersion).Wait();

            // assert
            var contract = GetContract(contractNumber, version, subVersion);
            Assert.AreEqual(true, contract.IsCreatedInCrm);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractRepository_GetFundingAllocationIdsForContract_ShouldReturnIds()
        {
            // arrange
            const string contractNumber = "cn - test1";
            const int version = 1;
            const int subVersion = 0;
            const string fundingAllocationId = "some fa id";
            const int pageNumber = 1;

            ClearFeedReads();
            ClearContracts(contractNumber);
            var contractId = CreateContract(contractNumber, version, subVersion);
            var readId = CreateFeedReadRow();
            CreateFundingAllocationPageControl(readId, pageNumber);
            CreateFundingAllocation(fundingAllocationId, contractId, readId, pageNumber);

            using var context = new LoggingContext(GetContextOptions());
            
            ContractRepository contractRepository = new ContractRepository(context);

            // act
            var fundingAllocationIds = contractRepository.GetFundingAllocationIdsForContract(contractNumber, version, subVersion).Result;

            // assert
            Assert.AreEqual(1, fundingAllocationIds.Count, "The number of funding allocation ids is not correct");
        }

        private static void ClearFeedReads()
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            context.FeedReads.ToList().ForEach(f =>
            {
                context.FeedReads.Remove(f);
            });

            context.SaveChanges();
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

        private static int CreateContract(string contractNumber, int version, int subVersion)
        {
            using var context = new FundingAllocationContext(GetContextOptions());
            var contract = new Contract(contractNumber, version, subVersion);

            context.Contracts.Add(contract);

            context.SaveChanges();

            return contract.Id;
        }

        private static void CreateFundingAllocationPageControl(int readId, int pageNumber)
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            context.FundingAllocationPageControls.Add(new FundingAllocationPageControl(readId, pageNumber));

            context.SaveChanges();
        }

        private static void CreateFundingAllocation(string fundingAllocationId, int contractId, int readId, int pageNumber)
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            context.FundingAllocations.Add(new FundingAllocation(
                    fundingAllocationId, "", "", "",
                    "", -1, pageNumber, -1, -1, readId)
                { ContractId = contractId });

            context.SaveChanges();
        }

        private static Contract GetContract(string contractNumber, int version, int subVersion)
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            return context.Contracts.Single(c => c.ContractNumber == contractNumber);
        }

        private static DbContextOptions<FundingAllocationContext> GetContextOptions()
        {
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            
            return new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;
        }

        private class LoggingContext : FundingAllocationContext
        {
            public LoggingContext(DbContextOptions<FundingAllocationContext> options) : base(options)
            {
            }

            protected override void OnConfiguring(DbContextOptionsBuilder options)
            {
                options.LogTo(Console.WriteLine);
                base.OnConfiguring(options);
            }
        }

        private int CreateFeedReadRow()
        {
            using var context = new FundingAllocationContext(GetContextOptions());
            var feedRead = new FeedRead();
            context.FeedReads.Add(feedRead);
            context.SaveChanges();

            return feedRead.ReadId;
        }
    }
}
