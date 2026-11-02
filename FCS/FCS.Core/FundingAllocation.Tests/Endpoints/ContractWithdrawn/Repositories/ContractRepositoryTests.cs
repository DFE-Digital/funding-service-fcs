namespace FundingAllocation.Tests.Endpoints.ContractWithdrawn.Repositories
{
    using System;
    using System.Data.SqlClient;
    using System.Linq;
    using DataStore;
    using FluentAssertions;
    using FundingAllocation.DataStore.Model;
    using FundingAllocation.Repositories;
    using FundingAllocation.Tests.TestHelpers.Extensions;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestHelpers;

    [TestClass]
    public class ContractRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractRepository_GetFundingAllocationInfos_ShouldGetAllocations()
        {
            // Arrange
            var expectedFundingId1 = "expectedFundingId1";
            var expectedCrmEntityId1 = Guid.NewGuid();
            var expectedFundingId2 = "expectedFundingId2";
            var expectedCrmEntityId2 = Guid.NewGuid();
            
            var actualContractNumber = "contractNumber";
            var actualContractVersionNumber = 33;
            var actualContractSubVersionNumber = 55;
            var pageNumber = 1;

            var contract = new Contract(actualContractNumber, actualContractVersionNumber, actualContractSubVersionNumber);
            var contractV2 = new Contract(actualContractNumber, actualContractVersionNumber, actualContractSubVersionNumber + 1);

            var fundingAllocation1 = FundingAllocationHelper.FundingAllocationWithFundingId(expectedFundingId1)
                .WithCrmEntityId(expectedCrmEntityId1);

            var fundingAllocation2 = FundingAllocationHelper.FundingAllocationWithFundingId(expectedFundingId2)
                .WithCrmEntityId(expectedCrmEntityId2);

            var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences(); 

            context.CreateFeedRead(out var feedReadId)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageNumber))
                .AddContracts(contract, contractV2)
                .AddFundingAllocations(
                    fundingAllocation1.WithPageNumber(pageNumber).WithReadId(feedReadId).ForContract(contract.Id), 
                    fundingAllocation2.WithPageNumber(pageNumber).WithReadId(feedReadId).ForContract(contractV2.Id))
                .SaveChanges();

            var target = new ContractRepository(context);
            
            // Act
            var actual = target.GetFundingAllocationInfosInContractControl(
                actualContractNumber, actualContractVersionNumber).Result.ToList();

            // Assert
            actual.Count.Should().Be(2);

            actual.Should().Contain(a =>
                a.FundingId == expectedFundingId1 && 
                a.CrmEntityId == expectedCrmEntityId1.ToString());

            actual.Should().Contain(a =>
                a.FundingId == expectedFundingId2 && 
                a.CrmEntityId == expectedCrmEntityId2.ToString());
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractRepository_GetFundingAllocationInfos_ShouldGetEmptyAllocationsWhenContractMissing()
        {
            // Arrange
            var actualFundingId1 = "actualFundingId1";
            var actualCrmEntityId1 = Guid.NewGuid();
            var actualFundingId2 = "actualFundingId2";
            var actualCrmEntityId2 = Guid.NewGuid();

            var actualContractNumber = "actualContractNumber";
            var actualContractVersionNumber = 33;
            var actualContractSubVersionNumber = 55;

            var expectedContractNumber = "expectedContractNumber";
            var expectedContractVersionNumber = 44;
            var expectedContractSubVersionNumber = 66;
            var pageNumber = 1;

            var contract = new Contract(actualContractNumber, actualContractVersionNumber, actualContractSubVersionNumber);
            var expectedContract = new Contract(expectedContractNumber, expectedContractVersionNumber, expectedContractSubVersionNumber);

            var fundingAllocation1 = FundingAllocationHelper.FundingAllocationWithFundingId(actualFundingId1)
                .WithCrmEntityId(actualCrmEntityId1);

            var fundingAllocation2 = FundingAllocationHelper.FundingAllocationWithFundingId(actualFundingId2)
                .WithCrmEntityId(actualCrmEntityId2);

            var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();
            
            context.CreateFeedRead(out var feedReadId)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageNumber))
                .AddContracts(expectedContract, contract)
                .AddFundingAllocations(
                    fundingAllocation1.WithPageNumber(pageNumber).WithReadId(feedReadId).ForContract(contract.Id),
                    fundingAllocation2.WithPageNumber(pageNumber).WithReadId(feedReadId).ForContract(contract.Id))
                .SaveChanges();

            var target = new ContractRepository(context);

            // Act
            var actual = target.GetFundingAllocationInfosInContractControl(
                expectedContractNumber, actualContractVersionNumber).Result.ToList();

            // Assert
            actual.Should().BeEmpty();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractRepository_DeleteContractIfOrphaned_ShouldDeleteContract()
        {
            // arrange
            var actualContractNumber = "actualContractNumber";
            var actualContractVersionNumber = 33;
            var actualContractSubVersionNumber = 55;

            var contract = new Contract(actualContractNumber, actualContractVersionNumber, actualContractSubVersionNumber);

            var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var feedReadId)
                .AddContracts(contract)
                .SaveChanges();

            var contractRepository = new ContractRepository(context);

            // act
            contractRepository.DeleteContractIfOrphaned(
                actualContractNumber, actualContractVersionNumber, actualContractSubVersionNumber).Wait();

            // assert
            var assertContext = new FundingAllocationContext(DbContextOptions);
            assertContext.Contracts.SingleOrDefault(c => c.ContractNumber == actualContractNumber &&
                                                                c.ContractVersionNumber == actualContractVersionNumber &&
                                                                c.ContractSubVersionNumber == actualContractSubVersionNumber).Should().BeNull();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractRepository_DeleteContractIfOrphaned_ShouldNotDeleteDeleteIfContractStillReferenced()
        {
            // arrange
            var actualContractNumber = "actualContractNumber";
            var actualContractVersionNumber = 33;
            var actualContractSubVersionNumber = 55;

            var contract = new Contract(actualContractNumber, actualContractVersionNumber, actualContractSubVersionNumber);

            var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var feedReadId)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, 1));
            
            context.AddContracts(contract).AddAllAndSave(FundingAllocationHelper
                .FundingAllocationWithFundingId("1619-AS-2122-Contracting-LocalAuthority-10000755-2_0")
                .WithReadId(feedReadId)
                .WithPageNumber(1).ForContract(contract.Id));

            var contractRepository = new ContractRepository(context);

            // act
            contractRepository.DeleteContractIfOrphaned(
                actualContractNumber, actualContractVersionNumber, actualContractSubVersionNumber).Wait();

            // assert
            var assertContext = new FundingAllocationContext(DbContextOptions);
            assertContext.Contracts.SingleOrDefault(c => c.ContractNumber == actualContractNumber &&
                                                         c.ContractVersionNumber == actualContractVersionNumber &&
                                                         c.ContractSubVersionNumber == actualContractSubVersionNumber).Should().NotBeNull();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractRepository_CreateContractWithQueuedRelationshipOrReturnExistingId_ShouldAddDependentContractForQueuedFundingAllocation()
        {
            // arrange
            const string actualContractNumber = "actualContractNumber";
            const int actualContractVersionNumber = 33;
            const int actualContractSubVersionNumber = 55;

            var contract = new Contract(actualContractNumber, actualContractVersionNumber, actualContractSubVersionNumber);

            var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            var contractRepository = new ContractRepository(context);

            // act
            var createdContractId = contractRepository.CreateContractWithQueuedRelationshipOrReturnExistingId(
                actualContractNumber, actualContractVersionNumber, actualContractSubVersionNumber).Result;

            // assert
            var assertContext = new FundingAllocationContext(DbContextOptions);
            var queued = RelationshipToFundingAllocationEnum.Queued.ToString();

            assertContext.Contracts.SingleOrDefault(c => c.Id == createdContractId && 
                                                         c.ContractNumber == actualContractNumber &&
                                                         c.ContractVersionNumber == actualContractVersionNumber &&
                                                         c.ContractSubVersionNumber == actualContractSubVersionNumber &&
                                                         c.IsCreatedInCrm == true &&
                                                         c.RelationshipToFundingAllocation == queued).Should().NotBeNull();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractRepository_CreateContractWithQueuedRelationshipOrReturnExistingId_ShouldReturnExistingContractIdWhenContractPresent()
        {
            // arrange
            const string actualContractNumber = "actualContractNumber";
            const int actualContractVersionNumber = 33;
            const int actualContractSubVersionNumber = 55;

            var contract = new Contract(actualContractNumber, actualContractVersionNumber, actualContractSubVersionNumber);

            var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            var contractRepository = new ContractRepository(context);
            var createdContractId = contractRepository.CreateContractWithQueuedRelationshipOrReturnExistingId(
                actualContractNumber, actualContractVersionNumber, actualContractSubVersionNumber).Result;

            // act
            var contractId = contractRepository.CreateContractWithQueuedRelationshipOrReturnExistingId(
                actualContractNumber, actualContractVersionNumber, actualContractSubVersionNumber).Result;

            // assert
            contractId.Should().Be(createdContractId);
        }

        private DbContextOptions<FundingAllocationContext> DbContextOptions => new DbContextOptionsBuilder<FundingAllocationContext>()
            .UseSqlServer(new SqlConnection(AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"]))
            .Options;
    }
}
