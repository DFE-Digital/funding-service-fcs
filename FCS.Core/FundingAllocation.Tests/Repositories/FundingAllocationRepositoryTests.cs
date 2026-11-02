namespace FundingAllocation.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FluentAssertions.Extensions;
    using FundingAllocation.Extensions;
    using FundingAllocation.Repositories;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestHelpers;
    using TestHelpers.Extensions;
    using Extensions;
    using SFA.FCT.CrossDomain.Integration.Entities.Extensions;

    [TestClass]
    public class FundingAllocationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_ShouldReturnExistingIdsForPage()
        {
            // arrange
            const int pageNumber1 = 21;
            const int pageNumber2 = 22;
            using var context = new FundingAllocationContext(DbContextOptions);
            context.Database.ExecuteSqlRaw($"DELETE FROM FundingAllocation.FundingAllocation WHERE PageNumber IN ({pageNumber1}, {pageNumber2})");

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber1))
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber2));

            context.FundingAllocations.AddRange(
                new FundingAllocation(
                    "A", "", "", "",
                    "", -1, pageNumber1, 1, -1, readId),
                new FundingAllocation(
                    "B", "", "", "",
                    "", -1, pageNumber1, 2, -1, readId),
                new FundingAllocation(
                    "C", "", "", "",
                    "", -1, pageNumber2, 1, -1, readId));
            RemoveFundingAllocations(context.FundingAllocations.Select(fa => fa.FundingId).ToList());

            context.SaveChanges();

            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));
            
            // act
            var existingIds = repository.GetExistingIdsForPage(new[] { "A", "B", "C" }).Result;

            // assert
            existingIds.Should().BeEquivalentTo(new[] { "A", "B", "C" }, "the correct IDs should be returned");
        }

        public void FundingAllocationRepository_ShouldReturnExistingIds()
        {
            // arrange
            const int pageNumber0 = 20;
            const int pageNumber1 = 21;
            const int pageNumber2 = 22;
            using var context = new FundingAllocationContext(DbContextOptions);
            context.Database.ExecuteSqlRaw($"DELETE FROM FundingAllocation.FundingAllocation WHERE PageNumber IN ({pageNumber0}, {pageNumber1}, {pageNumber2})");

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber0))
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber1))
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber2));

            context.FundingAllocations.AddRange(
                new FundingAllocation(
                    "D", "", "", "",
                    "", -1, pageNumber0, 1, -1, readId),
                new FundingAllocation(
                    "A", "", "", "",
                    "", -1, pageNumber1, 1, -1, readId),
                new FundingAllocation(
                    "B", "", "", "",
                    "", -1, pageNumber1, 2, -1, readId),
                new FundingAllocation(
                    "C", "", "", "",
                    "", -1, pageNumber2, 1, -1, readId));
            RemoveFundingAllocations(context.FundingAllocations.Select(fa => fa.FundingId).ToList());

            context.SaveChanges();

            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var existingIds = repository.GetExistingIdsForPage(new[] { "D", "A", "B", "C" }).Result;
            var existingIds1 = repository.GetExistingIdsForPage(new[] { "B", "C" }).Result;

            // assert
            existingIds.Should().BeEquivalentTo(new[] { "D", "A", "B", "C" }, "the correct IDs should be returned");
            existingIds1.Should().BeEquivalentTo(new[] { "B", "C" }, "the correct IDs should be returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_ShouldCreateFundingAllocationsInBulk()
        {
            // arrange
            const int numFundingAllocationsToCreate = 100;
            const int pageNumber = 1;

            using var arrangeContext = new FundingAllocationContext(DbContextOptions);

            arrangeContext.Database.ExecuteSqlRaw("DELETE FROM FundingAllocation.FeedRead");

            arrangeContext.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            var fundingAllocations =
                Enumerable.Range(1, numFundingAllocationsToCreate)
                    .Select(i => new FundingAllocation(
                        $"PSG-AY-1920-Information-LocalAuthority-{i}-1_0",
                        "1_0",
                        "1920",
                        "PSG",
                        "100",
                        100m,
                        pageNumber,
                        1,
                        0,
                        readId))
                    .ToList();

            var handlerContext = new FundingAllocationContext(DbContextOptions);
            var repository = new FundingAllocationRepository(handlerContext);
            handlerContext.Database.BeginTransaction();

            // act
            repository.CreateFundingAllocations(fundingAllocations).Wait();
            
            handlerContext.Database.CommitTransaction();

            // assert
            using var assertContext = new FundingAllocationContext(DbContextOptions);
            var storedFundingAllocations = assertContext.FundingAllocations.ToList();

            storedFundingAllocations.Count.Should().Be(numFundingAllocationsToCreate);
            storedFundingAllocations.Count(fa => !string.IsNullOrEmpty(fa.FundingAllocationName)).Should()
                .Be(numFundingAllocationsToCreate, "should all have FundingAllocationNames");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_ShouldGetFundingAllocation()
        {
            // arrange
            const string fundingId = "PSG-AY-2122-Payment-AcademyTrust-10000001-1_0";
            const string providerFundingId = "PSG-AY-2122-10083619-1_0";
            const string fundingLineCode = "TotalAllocation";
            const int pageNumber = 1;

            RemoveFundingAllocations(new List<string>{fundingId});
            using var context = new LoggingContext(DbContextOptions);
            context.CreateFeedRead(out int readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            context.RemoveAllContractsAndReferences();

            context.FundingAllocations.Add(new FundingAllocation(
                fundingId,
                "1_0",
                "AY-2021",
                "PSG",
                "10000001",
                100,
                1,
                pageNumber,
                1, 
                readId));

            context.ProviderFundingAllocations.Add(new ProviderFundingAllocation(
                providerFundingId,
                fundingId)
            {
                ProviderFunding = new ProviderFunding(providerFundingId, 10000001,
                    "Academies",
                    "Academy converter")
            });

            context.FundingAllocationLines.Add(new FundingAllocationLine(
                providerFundingId,
                fundingLineCode
                ));

            context.FundingAllocationProfilePeriods.Add(new FundingAllocationProfilePeriod(
                providerFundingId,
                fundingLineCode,
                202101,
                100));

            context.SaveChanges();

            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var fundingAllocation = repository.GetFundingAllocation(fundingId).Result;

            // assert
            fundingAllocation.Should().NotBeNull();
            fundingAllocation.FundingId.Should().Be(fundingId);
            fundingAllocation.ProviderFundingAllocations.Should().HaveCount(1);

            var providerFundingAllocation = fundingAllocation.ProviderFundingAllocations.Single();
            providerFundingAllocation.ProviderFundingId.Should().Be(providerFundingId);
            providerFundingAllocation.ProviderFunding.FundingAllocationLines.Should().HaveCount(1);

            var fundingAllocationLine = providerFundingAllocation.ProviderFunding.FundingAllocationLines.Single();
            fundingAllocationLine.FundingLineCode.Should().Be(fundingLineCode);
            fundingAllocationLine.FundingAllocationProfilePeriods.Should().HaveCount(1);

            var profilePeriod = fundingAllocationLine.FundingAllocationProfilePeriods.Single();
            profilePeriod.Period.Should().Be(202101);
            profilePeriod.PlannedValue.Should().Be(100);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_ShouldAddCrmEntityIdToFundingAllocation()
        {
            const string fundingId = "1619-AY-2021-Contract-Provider-10017057-2_0";
            Guid crmEntityId = Guid.NewGuid();
            const int pageNumber = 1;

            // arrange
            RemoveFundingAllocations(new List<string> { fundingId });
            using var arrangeContext = new FundingAllocationContext(DbContextOptions);
            arrangeContext.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            arrangeContext.FundingAllocations.Add(
                new FundingAllocation(
                    fundingId,
                    "2_0",
                    "AY2021",
                    "1619",
                    "10017057",
                    16929,
                    pageNumber,
                    1,
                    10, 
                    readId));
            arrangeContext.SaveChanges();

            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            repository.AddCrmEntityIdToFundingAllocation(fundingId, crmEntityId).Wait();

            // assert
            using var assertContext = new FundingAllocationContext(DbContextOptions);
            Guid? storedCrmEntityId = assertContext.FundingAllocations
                .Single(fa => fa.FundingId == fundingId)
                .CrmEntityId;

            storedCrmEntityId.Should().NotBeNull();
            storedCrmEntityId.Should().Be(crmEntityId);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_ShouldUpdateReleaseGroupOnFundingAllocation()
        {
            // arrange
            const string fundingId = "1619-AY-2021-Contract-Provider-10017057-2_0";
            const string releaseGrpName = "RGTest";
            const int pageNumber = 1;
            RemoveFundingAllocations(new []{fundingId});
            using var context = new FundingAllocationContext(DbContextOptions);

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            CreateFundingAllocation(fundingId, readId, pageNumber: pageNumber);
            RemoveReleaseGroups();
            int actualReleaseGrpId = CreateReleaseGroup(releaseGrpName);
            List<int?> listOfReleaseGrpIds = new List<int?>{actualReleaseGrpId, null};
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));
            
            listOfReleaseGrpIds.ForEach(releaseGrpId =>
            {
                // act
                repository.UpdateReleaseGroupOnFundingAllocation(fundingId, releaseGrpId).Wait();

                // assert
                var fundingAllocation = GetFundingAllocation(fundingId);
                fundingAllocation.ReleaseGroupId.Should().Be(releaseGrpId,
                    "We do not have the expected release grp on the funding allocation");
            });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_ShouldGetFundingAllocationCrmId()
        {
            // arrange
            const string fundingId = "1619-AY-2021-Contract-Provider-10017057-2_0";
            const int pageNumber = 1;
            RemoveFundingAllocations(new[] { fundingId });
            using var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            var crmEntityId = Guid.NewGuid();
            CreateFundingAllocation(fundingId, readId, crmEnityId:crmEntityId, pageNumber:pageNumber);
            
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));
            
            // act
            var crmId = repository.GetFundingAllocationCrmId(fundingId).Result;

            // assert
            crmId.Value.Should().Be(crmEntityId);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetReleaseGroupsThatCanNowBeSetToReleased_ShouldReturnEmptyListWhenThereAreNoContractsForTheFundingAllocations()
        {
            // arrange
            const string fundingId = "1619-AY-2021-Contract-Provider-10017057-1_0";
            const string fundingIdTwo = "1619-AY-2021-Contract-Provider-10017057-2_0";
            const string releaseGrpName = "RGTest";
            const int pageNumber = 1;
            RemoveReleaseGroups();
            int releaseGrpId = CreateReleaseGroup(releaseGrpName);
            RemoveFundingAllocations(new []{fundingId, fundingIdTwo});
            using var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            CreateFundingAllocation(fundingId, readId, releaseGrpId, pageNumber: pageNumber);
            CreateFundingAllocation(fundingIdTwo, readId, releaseGrpId, pageNumber: pageNumber);

            // act
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var result = repository.GetReleaseGroupsThatCanNowBeSetToReleased(new List<string> {fundingId, fundingIdTwo}, null).Result;

            // assert
            result.Should().BeEmpty();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetReleaseGroupsThatCanNowBeSetToReleased_ShouldReturnReleaseGrpNameWhenFundingInTheGrpHasAContract()
        {
            // arrange
            const string fundingId = "1619-AY-2021-Contract-Provider-10017057-1_1";
            const string fundingIdTwo = "1619-AY-2021-Contract-Provider-10017057-1_2";
            const string releaseGrpName = "RGTest2";
            const string contractNumber = "CN 123";
            const int pageNumber = 1;
            RemoveReleaseGroups();
            int releaseGrpId = CreateReleaseGroup(releaseGrpName);
            RemoveFundingAllocations(new[] { fundingId });
            RemoveContracts(new []{contractNumber});
            int contractId = CreateContract(contractNumber, isCreatedInCrm:true);
            using var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            CreateFundingAllocation(fundingId, readId, releaseGrpId, contractId, pageNumber: pageNumber);
            CreateFundingAllocation(fundingIdTwo, readId, releaseGrpId, contractId, pageNumber: pageNumber);

            // act
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var result = repository.GetReleaseGroupsThatCanNowBeSetToReleased(new List<string> { fundingId, fundingIdTwo }, null).Result;

            // assert
            result.Should().HaveCount(1);
            result.Single().Should().Be(releaseGrpName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetReleaseGroupsThatCanNowBeSetToReleased_ShouldReturnReleaseGrpNameWhenReleaseGrpIdPassedIn()
        {
            // arrange
            const string fundingId = "1619-AY-2021-Contract-Provider-10017057-1_1";
            const string fundingIdTwo = "1619-AY-2021-Contract-Provider-10017057-1_2";
            const string releaseGrpName = "RGTest2";
            const string contractNumber = "CN 123";
            const int pageNumber = 1;
            RemoveReleaseGroups();
            int releaseGrpId = CreateReleaseGroup(releaseGrpName);
            RemoveFundingAllocations(new[] { fundingId });
            RemoveContracts(new[] { contractNumber });
            int contractId = CreateContract(contractNumber, isCreatedInCrm: true);
            using var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            CreateFundingAllocation(fundingId, readId, releaseGrpId, contractId, pageNumber: pageNumber);
            CreateFundingAllocation(fundingIdTwo, readId, releaseGrpId, contractId, pageNumber: pageNumber);

            // act
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var result = repository.GetReleaseGroupsThatCanNowBeSetToReleased(new List<string>(), releaseGrpId).Result;

            // assert
            result.Should().HaveCount(1);
            result.Single().Should().Be(releaseGrpName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetReleaseGroupsThatCanNowBeSetToReleased_ShouldReturnReleaseGrpNameWhenReleaseGrpIdPassedInDoesNotHaveFundingAllocations()
        {
            // arrange
            const string releaseGrpName = "RGTest2";
            RemoveReleaseGroups();
            int releaseGrpId = CreateReleaseGroup(releaseGrpName);
            
            // act
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var result = repository.GetReleaseGroupsThatCanNowBeSetToReleased(new List<string>(), releaseGrpId).Result;

            // assert
            result.Should().HaveCount(1);
            result.Single().Should().Be(releaseGrpName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetReleaseGroupsThatCanNowBeSetToReleased_ShouldReturnEmptyWhenContractCreatedForOneButNotOther()
        {
            // arrange
            const string fundingId = "1619-AY-2021-Contract-Provider-10017057-1_1";
            const string fundingIdTwo = "1619-AY-2021-Contract-Provider-10017057-1_2";
            const string releaseGrpName = "RGTest2";
            const string contractNumber = "CN 123";
            const int pageNumber = 1;
            RemoveReleaseGroups();
            int releaseGrpId = CreateReleaseGroup(releaseGrpName);
            RemoveFundingAllocations(new[] { fundingId });
            RemoveContracts(new[] { contractNumber });
            int contractId = CreateContract(contractNumber, isCreatedInCrm: true);
            using var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            CreateFundingAllocation(fundingId, readId, releaseGrpId, contractId, pageNumber: pageNumber);
            CreateFundingAllocation(fundingIdTwo, readId, releaseGrpId, pageNumber: pageNumber);

            // act
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var result = repository.GetReleaseGroupsThatCanNowBeSetToReleased(new List<string> { fundingId, fundingIdTwo }, null).Result;

            // assert
            result.Should().BeEmpty();
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetReleaseGroupsThatCanNowBeSetToReleased_ShouldGetRGWhenMixOfContractCreatedAndQueued()
        {
            // arrange
            const string fundingId = "1619-AY-2021-Contract-Provider-10017057-1_1";
            const string fundingIdTwo = "1619-AY-2021-Contract-Provider-10017057-1_2";
            const string releaseGrpName = "RGTest2";
            const string contractNumber = "CN 123";
            const int pageNumber = 1; RemoveReleaseGroups();
            int releaseGrpId = CreateReleaseGroup(releaseGrpName);
            RemoveFundingAllocations(new[] { fundingId });
            RemoveContracts(new[] { contractNumber });
            int contractId = CreateContract(contractNumber, isCreatedInCrm: true);
            using var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber)); 
            CreateFundingAllocation(fundingId, readId, releaseGrpId, contractId, pageNumber: pageNumber);
            CreateFundingAllocation(fundingIdTwo, readId, releaseGrpId, status:FundingAllocationStatus.InRelease, 
                subStatus:FundingAllocationSubStatus.Queued, pageNumber: pageNumber);

            // act
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var result = repository.GetReleaseGroupsThatCanNowBeSetToReleased(new List<string> { fundingId, fundingIdTwo }, null).Result;

            // assert
            result.Should().HaveCount(1);
            result.Single().Should().Be(releaseGrpName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetReleaseGroupsThatCanNowBeSetToReleased_ShouldGetRGWhenAllFundingIdsAreQueued()
        {
            // arrange
            const string fundingId = "1619-AY-2021-Contract-Provider-10017057-1_1";
            const string fundingIdTwo = "1619-AY-2021-Contract-Provider-10017057-1_2";
            const string releaseGrpName = "RGTest2";
            const int pageNumber = 1;
            RemoveReleaseGroups();
            int releaseGrpId = CreateReleaseGroup(releaseGrpName);
            RemoveFundingAllocations(new[] { fundingId });

            using var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            CreateFundingAllocation(fundingId, readId, releaseGrpId, status: FundingAllocationStatus.InRelease, subStatus: FundingAllocationSubStatus.Queued, pageNumber: pageNumber);
            CreateFundingAllocation(fundingIdTwo, readId, releaseGrpId, status: FundingAllocationStatus.InRelease, subStatus: FundingAllocationSubStatus.Queued, pageNumber: pageNumber);

            // act
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var result = repository.GetReleaseGroupsThatCanNowBeSetToReleased(new List<string> { fundingId, fundingIdTwo }, null).Result;

            // assert
            result.Should().HaveCount(1);
            result.Single().Should().Be(releaseGrpName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetReleaseGroupsThatCanNowBeSetToReleased_ShouldReturnEmptyWhenSomeFundingInTheGrpHasAContractAndSomeNot()
        {
            // arrange
            const string fundingId = "1619-AY-2021-Contract-Provider-10017057-1_0";
            const string fundingIdTwo = "1619-AY-2021-Contract-Provider-10017057-2_0";
            const string releaseGrpName = "RGTest";
            const string contractNumber = "CN 123";
            const string contractNumberTwo = "CN 1234";
            const int pageNumber = 1;
            RemoveReleaseGroups();
            int releaseGrpId = CreateReleaseGroup(releaseGrpName);
            RemoveContracts(new List<string>{contractNumber, contractNumberTwo});
            int contractId = CreateContract(contractNumber, isCreatedInCrm: true);
            int contractIdTwo = CreateContract(contractNumberTwo, isCreatedInCrm: false);
            RemoveFundingAllocations(new List<string>{fundingId, fundingIdTwo});
            using var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            CreateFundingAllocation(fundingId, readId:readId, releaseGrpId, contractId, pageNumber: pageNumber);
            CreateFundingAllocation(fundingIdTwo, readId:readId, releaseGrpId, contractIdTwo, pageNumber: pageNumber);

            // act
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var result = repository.GetReleaseGroupsThatCanNowBeSetToReleased(new List<string> { fundingId, fundingIdTwo }, null).Result;

            // assert
            result.Should().BeEmpty();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetReleaseGroupsThatCanNowBeSetToReleased_ShouldReturnRGNameWhenFAsAreAllQueued()
        {
            // arrange
            const string fundingId = "1619-AY-2021-Contract-Provider-10017057-1_0";
            const string fundingIdTwo = "1619-AY-2021-Contract-Provider-10017057-2_0";
            const string releaseGrpName = "RGTest";
            const string contractNumber = "CN 123";
            const int pageNumber = 1;
            RemoveReleaseGroups();
            int releaseGrpId = CreateReleaseGroup(releaseGrpName);
            RemoveContracts(new List<string> {contractNumber});
            int contractId = CreateContract(contractNumber, isCreatedInCrm: true,
                relationship: RelationshipToFundingAllocationEnum.Queued);
            RemoveFundingAllocations(new List<string> {fundingId, fundingIdTwo});
            using var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            CreateFundingAllocation(fundingId, readId: readId, releaseGrpId, contractId, pageNumber: pageNumber,
                status: FundingAllocationStatus.InRelease, subStatus: FundingAllocationSubStatus.Queued);
            CreateFundingAllocation(fundingIdTwo, readId: readId, releaseGrpId, contractId, pageNumber: pageNumber,
                status: FundingAllocationStatus.InRelease, subStatus: FundingAllocationSubStatus.Queued);

            // act
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var result = repository
                .GetReleaseGroupsThatCanNowBeSetToReleased(new List<string> {fundingId, fundingIdTwo}, null).Result;

            // assert
            result.Count.Should().Be(1);
            result.Contains(releaseGrpName).Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetFundingIdsForReadId_ShouldReturnCorrectIds()
        {
            // arrange
            const string fundingId = "1619-AY-2021-Contract-Provider-10017057-1_0";
            const string fundingIdTwo = "1619-AY-2021-Contract-Provider-10017057-2_0";
            const string fundingIdNextRead = "1619-AY-2021-Contract-Provider-10017057-1_1";
            const string fundingIdTwoNextRead = "1619-AY-2021-Contract-Provider-10017057-2_2";
            RemoveFundingAllocations(new List<string>{fundingId, fundingIdTwo, fundingIdNextRead, fundingIdTwoNextRead});
            RemovePageControls();
            int readId = CreateFeedReadRow();
            CreatePageControl(readId, 1, Guid.NewGuid().ToString());
            CreatePageControl(readId, 2, Guid.NewGuid().ToString());
            CreateFundingAllocation(fundingId, readId, pageNumber:1, crmEnityId:Guid.NewGuid());
            CreateFundingAllocation(fundingIdTwo, readId, pageNumber: 2, crmEnityId: Guid.NewGuid());
            int nextReadId = CreateFeedReadRow();
            CreatePageControl(nextReadId, 1, Guid.NewGuid().ToString());
            CreatePageControl(nextReadId, 2, Guid.NewGuid().ToString());
            CreateFundingAllocation(fundingIdNextRead, nextReadId, pageNumber: 1);
            CreateFundingAllocation(fundingIdTwoNextRead, nextReadId, pageNumber: 2);

            // act
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var fundingIds = repository.GetFundingIdsForReadId(nextReadId).Result;

            // assert
            fundingIds.Should().Contain(new List<string>{fundingIdNextRead, fundingIdTwoNextRead});
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetFundingIdsWithStatusAndSubStatus_ShouldReturnCorrectIds()
        {
            // arrange
            const string fundingId = "1619-AY-2021-Contract-Provider-10017057-1_0";
            const string fundingIdTwo = "1619-AY-2021-Contract-Provider-10017057-2_0";
            RemoveFundingAllocations(new List<string> { fundingId, fundingIdTwo });
            RemovePageControls();
            int readId = CreateFeedReadRow();
            CreatePageControl(readId, 1, Guid.NewGuid().ToString());
            CreatePageControl(readId, 2, Guid.NewGuid().ToString());
            CreateFundingAllocation(fundingId, readId, pageNumber: 1, status:FundingAllocationStatus.Parked, subStatus:FundingAllocationSubStatus.AwaitingProvider);
            CreateFundingAllocation(fundingIdTwo, readId, pageNumber: 2, crmEnityId: Guid.NewGuid());

            // act
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var fundingIds = repository.GetFundingIdsWithStatusAndSubStatus(FundingAllocationStatus.Parked, FundingAllocationSubStatus.AwaitingProvider).Result;

            // assert
            fundingIds.Should().HaveCount(1);
            fundingIds.Single().Should().Be(fundingId);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_IsFundingAllocationInReleaseGroup_ShouldReturnTheRightValue()
        {
            // arrange
            const string fundingId = "1619-AY-2021-Contract-Provider-10017057-1_0";
            const string fundingIdTwo = "1619-AY-2021-Contract-Provider-10017057-2_0";
            const string releaseGroupTest = "test rg";
            const int pageNumber = 1;
            RemoveReleaseGroups();
            RemoveFundingAllocations(new List<string> { fundingId, fundingIdTwo});
            RemovePageControls();
            using var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            int rgId = CreateReleaseGroup(releaseGroupTest);
            CreateFundingAllocation(fundingId, readId, pageNumber: pageNumber);
            CreateFundingAllocation(fundingIdTwo, readId, pageNumber: pageNumber, releaseGrpId:rgId);

            List<(string fundingId, bool isInReleaseGroup)> inputsAndTheirResult =
                new List<(string fundingId, bool isInReleaseGroup)>
                {
                    (fundingId, false),
                    (fundingIdTwo, true),
                };
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            inputsAndTheirResult.ForEach(i =>
            {
                // act
                var isInReleaseGroup = repository.IsFundingAllocationInReleaseGroup(i.fundingId).Result;

                // assert
                isInReleaseGroup.Should().Be(i.isInReleaseGroup, i.fundingId);
            });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_SetToReturnedToScheduling_ShouldUpdateReleaseGroupAndContractOnFundingAllocation()
        {
            // arrange
            const string fundingId = "1619-AY-2021-Contract-Provider-10017057-2_0";
            const string releaseGrpName = "RGTest";
            const string contractNumber = "CN 12399";
            const int pageNumber = 1;

            RemoveFundingAllocations(new[] { fundingId });
            using var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            RemoveReleaseGroups();
            int actualReleaseGrpId = CreateReleaseGroup(releaseGrpName);
            RemoveContracts(new[] { contractNumber });
            int contractId = CreateContract(contractNumber);

            CreateFundingAllocation(fundingId, readId, actualReleaseGrpId, contractId, pageNumber: pageNumber);
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            repository.SetToReturnedToScheduling(fundingId).Wait();

            // assert
            var fundingAllocation = GetFundingAllocation(fundingId);
            fundingAllocation.ContractId.Should().Be(null);
            fundingAllocation.ReleaseGroupId.Should().Be(null);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_RemoveContractFromFundingAllocations_ShouldSetContractToNull()
        {
            // arrange
            const string fundingId = "1619-AY-2021-Contract-Provider-10017057-2_0";
            const string contractNumber = "CN 12400";
            const int pageNumber = 1;

            RemoveFundingAllocations(new[] { fundingId });
            using var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            RemoveContracts(new[] { contractNumber });
            int contractId = CreateContract(contractNumber);

            CreateFundingAllocation(fundingId, readId, contractId:contractId, pageNumber: pageNumber);
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            repository.RemoveContractFromFundingAllocations(new List<string>{fundingId}).Wait();

            // assert
            var fundingAllocation = GetFundingAllocation(fundingId);
            fundingAllocation.ContractId.Should().Be(null);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetFundingAllocationNamesInContractControlWithoutOutcome_ShouldReturnNamesThatRequireParking()
        {
            // arrange
            const string fundingIdOne = "1619-AY-2021-Contract-Provider-10014001-2_0";
            const string fundingIdTwo = "1619-AY-2021-Contract-Provider-10014002-2_0";
            const string fundingIdThree = "1619-AY-2021-Contract-Provider-10014002-2_1";
            const string contractNumber = "CN 12399";
            const string releaseGroupName = "Some Rg2";
            const int pageNumber = 1;

            RemoveFundingAllocations(new[] { fundingIdOne, fundingIdTwo });
            RemoveReleaseGroups();
            using var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            context.CreateFeedRead(out var readId2)
                .AddAllAndSave(new FundingAllocationPageControl(readId2, pageNumber));
            RemoveContracts(new[] { contractNumber });
            int contractId = CreateContract(contractNumber);
            int releaseGroupId = CreateReleaseGroup(releaseGroupName);
            CreateFundingAllocation(fundingIdOne, readId, contractId: contractId, status:FundingAllocationStatus.ContractApproved, releaseGrpId:releaseGroupId, pageNumber: pageNumber);
            CreateFundingAllocation(fundingIdTwo, readId, releaseGrpId: releaseGroupId, pageNumber: pageNumber);
            CreateFundingAllocation(fundingIdThree, readId2, releaseGrpId: releaseGroupId, pageNumber: pageNumber);
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));
            List<string> fundingAllocationNames = new List<string>{ fundingIdTwo.RemoveVersionFromId()};

            // act
            var forParking = repository.GetFundingAllocationNamesInContractControlWithoutOutcome(fundingAllocationNames, readId2 + 1).Result;

            // assert
            forParking.Count.Should().Be(1);
            forParking.Single().Should().Be(fundingIdTwo.RemoveVersionFromId());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetFundingAllocationNamesInContractControlWithoutOutcome_ShouldCaterForQueuedFundingAllocation()
        {
            // arrange
            const string fundingIdOneIsQueued = "1619-AY-2021-Contract-Provider-10014001-2_0";
            const string fundingIdTwo = "1619-AY-2021-Contract-Provider-10014001-2_1";
            
            const string contractNumber = "CN 12399";
            const string releaseGroupName = "Some Rg2";
            const int pageNumber = 1;

            RemoveFundingAllocations(new[] { fundingIdOneIsQueued, fundingIdTwo });
            RemoveReleaseGroups();
            using var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            context.CreateFeedRead(out var readId2)
                .AddAllAndSave(new FundingAllocationPageControl(readId2, pageNumber));
            RemoveContracts(new[] { contractNumber });
            int releaseGroupId = CreateReleaseGroup(releaseGroupName);
            CreateFundingAllocation(fundingIdOneIsQueued, readId, status: FundingAllocationStatus.InRelease, subStatus:FundingAllocationSubStatus.Queued, releaseGrpId: releaseGroupId, pageNumber: pageNumber);
            CreateFundingAllocation(fundingIdTwo, readId2, pageNumber: pageNumber);
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));
            List<string> fundingAllocationNames = new List<string> { fundingIdTwo.RemoveVersionFromId() };

            // act
            var forParking = repository.GetFundingAllocationNamesInContractControlWithoutOutcome(fundingAllocationNames, readId2).Result;

            // assert
            forParking.Count.Should().Be(1);
            forParking.Single().Should().Be(fundingIdTwo.RemoveVersionFromId());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetFundingAllocationNamesInContractControlWithoutOutcome_ShouldIncludeAllocationsNotInAReleaseGroup()
        {
            // arrange
            const string fundingIdOne = "1619-AS-2021-Contract-Provider-10017564-1_7";
            const string fundingIdTwo = "1619-AS-2021-Contract-Provider-10017564-2_1";
            const int pageNumber = 1;

            RemoveFundingAllocations(new[] { fundingIdOne, fundingIdTwo });
            using var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            context.CreateFeedRead(out var readId2)
                .AddAllAndSave(new FundingAllocationPageControl(readId2, pageNumber));
            RemoveReleaseGroups();
            
            CreateFundingAllocation(fundingIdOne, readId, pageNumber: pageNumber);
            CreateFundingAllocation(fundingIdTwo, readId2, pageNumber: pageNumber);
            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));
            List<string> fundingAllocationNames = new List<string> { fundingIdTwo.RemoveVersionFromId() };

            // act
            var forParking = repository.GetFundingAllocationNamesInContractControlWithoutOutcome(fundingAllocationNames, readId2 + 1).Result;

            // assert
            forParking.Count.Should().Be(1);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_SetFundingAllocationStatusSubStatus_ShouldChangeFundingIdStatusAndSubStatus()
        {
            // Arrange
            const FundingAllocationStatus expectedStatus = FundingAllocationStatus.Discarded;
            const FundingAllocationSubStatus expectedSubStatus = FundingAllocationSubStatus.NonMaterialUpdate;
            const string contractNumber = "contractNumber";
            const int contractVersionNumber = 22;
            const int contractSubVersionNumber = 44;
            const string fundingId1 = "fundingId1-01_05";
            const string fundingId2 = "fundingId2-01_05";
            const int pageNumber = 1;

            var fundingIds = new[] { fundingId1, fundingId2 };

            var contract = new Contract(contractNumber, contractVersionNumber, contractSubVersionNumber);

            var fundingAllocation1 = FundingAllocationHelper.FundingAllocationWithFundingId(fundingId1)
                .WithStatus(FundingAllocationStatus.NotSet)
                .WithSubStatus(FundingAllocationSubStatus.NotSet)
                .WithPageNumber(pageNumber);

            var fundingAllocation2 = FundingAllocationHelper.FundingAllocationWithFundingId(fundingId2)
                .WithStatus(FundingAllocationStatus.NotSet)
                .WithSubStatus(FundingAllocationSubStatus.NotSet)
                .WithPageNumber(pageNumber);

            using var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber))
                .AddContracts(contract)
                .AddFundingAllocations(
                    fundingAllocation1.WithReadId(readId).ForContract(contract.Id),
                    fundingAllocation2.WithReadId(readId).ForContract(contract.Id))
                .SaveChanges();

            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // Act
            repository.SetFundingAllocationStatusSubStatus(fundingIds, expectedStatus, expectedSubStatus).Wait();

            // Assert
            var fundingAllocation = GetFundingAllocation(fundingId1);
            fundingAllocation.FundingAllocationStatus.Should().Be(expectedStatus);
            fundingAllocation.FundingAllocationSubStatus.Should().Be(expectedSubStatus);
            fundingAllocation = GetFundingAllocation(fundingId2);
            fundingAllocation.FundingAllocationStatus.Should().Be(expectedStatus);
            fundingAllocation.FundingAllocationSubStatus.Should().Be(expectedSubStatus);
        }
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_SetContractId_ShouldSetTheContractIdForACollectionOfFundingIds()
        {
            // Arrange
            const string contractNumber = "contractNumber";
            const int contractVersionNumber = 22;
            const int contractSubVersionNumber = 44;
            const string fundingId1 = "fundingId1-01_05";
            const string fundingId2 = "fundingId2-01_05";
            const int pageNumber = 1;

            var fundingIds = new[] { fundingId1, fundingId2 };

            var contract = new Contract(contractNumber, contractVersionNumber, contractSubVersionNumber);

            var fundingAllocation1 = FundingAllocationHelper.FundingAllocationWithFundingId(fundingId1)
                .WithStatus(FundingAllocationStatus.NotSet)
                .WithSubStatus(FundingAllocationSubStatus.NotSet)
                .WithPageNumber(pageNumber);

            var fundingAllocation2 = FundingAllocationHelper.FundingAllocationWithFundingId(fundingId2)
                .WithStatus(FundingAllocationStatus.NotSet)
                .WithSubStatus(FundingAllocationSubStatus.NotSet)
                .WithPageNumber(pageNumber);

            using var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber))
                .AddContracts(contract)
                .AddFundingAllocations(
                    fundingAllocation1.WithReadId(readId),
                    fundingAllocation2.WithReadId(readId))
                .SaveChanges();

            var contractId = contract.Id;

            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // Act
            repository.SetContractId(fundingIds, contractId).Wait();

            // Assert
            var fundingAllocation = GetFundingAllocation(fundingId1);
            fundingAllocation.ContractId.Should().Be(contractId);
            fundingAllocation = GetFundingAllocation(fundingId2);
            fundingAllocation.ContractId.Should().Be(contractId);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_SetFundingAllocationStatus_ShouldSetStatusToNullWhenNotSet()
        {
            // Arrange
            const FundingAllocationStatus newStatus = FundingAllocationStatus.NotSet;
            const FundingAllocationSubStatus newSubStatus = FundingAllocationSubStatus.NotSet;
            const string fundingIdOne = "1619-AY-2021-Contract-Provider-10014001-2_0";
            const string fundingIdTwo = "1619-AY-2021-Contract-Provider-10014002-2_0";
            const int pageNumber = 1;

            var fundingIds = new List<string>{ fundingIdOne, fundingIdTwo };

            using var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));

            CreateFundingAllocation(fundingIdOne, readId, status: FundingAllocationStatus.Parked, pageNumber: pageNumber);
            CreateFundingAllocation(fundingIdTwo, readId, status: FundingAllocationStatus.Parked, pageNumber: pageNumber);

            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // Act
            repository.SetFundingAllocationStatusSubStatus(fundingIds, newStatus, newSubStatus).Wait();

            // Assert
            fundingIds.ForEach(fId =>
            {
                var fundingAllocation = GetFundingAllocation(fId);
                fundingAllocation.Status.Should().Be(null, $"funding id: {fId} has the incorrect status");
                fundingAllocation.SubStatus.Should().Be(null, $"funding id: {fId} has the incorrect sub-status");
            });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetLatestContractApprovedFundingAllocationIds_ShouldReturnTheLastApprovedIds()
        {
            // arrange
            var fundingId1 = "1619-AY-2021-Contract-Provider-10014002-2_0";
            var fundingId2 = "1619-AY-2021-Contract-Provider-10014002-14_1";
            var fundingId3 = "1619-AY-2021-Contract-Provider-10014003-1_0";
            var fundingId4 = "1619-AY-2021-Contract-Provider-10014003-1_1";
            var fundingId5 = "1619-AY-2021-Contract-Provider-10014003-1_2";
            const int pageNumber = 1;

            List<string> latestApproved = new List<string>{ fundingId2, fundingId4 };

            var fundingIds = new List<string> { fundingId1,  fundingId3,  fundingId5 };
            fundingIds.AddRange(latestApproved);

            using var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));

            CreateFundingAllocation(fundingId1, readId, status: FundingAllocationStatus.ContractApproved, pageNumber: pageNumber);
            CreateFundingAllocation(fundingId2, readId, status: FundingAllocationStatus.ContractApproved, pageNumber: pageNumber);
            CreateFundingAllocation(fundingId3, readId, pageNumber: pageNumber);
            CreateFundingAllocation(fundingId4, readId, status: FundingAllocationStatus.ContractApproved, pageNumber: pageNumber);
            CreateFundingAllocation(fundingId5, readId, pageNumber: pageNumber);

            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var contractApprovedFundingIds = repository.GetLatestContractApprovedFundingAllocationIds(fundingIds.Select(fId => fId.RemoveVersionFromId()).ToList()).Result;

            // assert
            contractApprovedFundingIds.Count.Should().Be(latestApproved.Count);
           latestApproved.All(latestApprovedFundingId => contractApprovedFundingIds.Select(f => f.FundingId).Contains(latestApprovedFundingId)).Should()
               .Be(true, "All the latestApproved Funding Ids should be present");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_ShouldGetAllRequestedFundingAllocations()
        {
            // Arrange
            const string contractNumber = "contractNumber";
            const int contractVersionNumber = 22;
            const int contractSubVersionNumber = 44;
            var fundingId1 = "fundingId_1";
            var fundingId2 = "fundingId_2";
            var providerFundingId1 = "providerFundingId_1";
            var providerFundingId2 = "providerFundingId_2";
            var fundingLineCode1 = "fundingLineCode1";
            var fundingLineCode2 = "fundingLineCode2";
            const int pageNumber = 1;

            var contract = new Contract(contractNumber, contractVersionNumber, contractSubVersionNumber);

            var fundingAllocation1 = FundingAllocationHelper.FundingAllocationWithFundingId(fundingId1).WithPageNumber(pageNumber);

            var providerFundingAllocation1 = ProviderFundingAllocationHelper.EmptyProviderFundingAllocation
                .WithProviderFundingId(providerFundingId1).WithFundingId(fundingId1);

            var allocationLine1 = new FundingAllocationLine(providerFundingId1, fundingLineCode1);

            var period1 = new FundingAllocationProfilePeriod(providerFundingId1, fundingLineCode1, 3, new decimal(33.3));

            var fundingAllocation2 = FundingAllocationHelper.FundingAllocationWithFundingId(fundingId2).WithPageNumber(pageNumber);

            var providerFundingAllocation2 = ProviderFundingAllocationHelper.EmptyProviderFundingAllocation
                .WithProviderFundingId(providerFundingId2).WithFundingId(fundingId2);

            var allocationLine2 = new FundingAllocationLine(providerFundingId2, fundingLineCode2);

            var period2 = new FundingAllocationProfilePeriod(providerFundingId2, fundingLineCode2, 5, new decimal(55.5));

            using var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber))
                .AddContracts(contract)
                .AddAllAndSave(
                    fundingAllocation1.WithReadId(readId).ForContract(contract.Id),
                    fundingAllocation2.WithReadId(readId).ForContract(contract.Id))
                .AddAllAndSave(providerFundingAllocation1, providerFundingAllocation2)
                .AddAllAndSave(allocationLine1, allocationLine2)
                .AddAllAndSave(period1, period2);

            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            var fundingIds = new[] {fundingId1, fundingId2};

            // Act
            var actualAllocations = repository.GetFundingAllocations(fundingIds).Result;

            // Assert
            foreach (var expectedFundingId in fundingIds)
            {
                var actualFundingAllocation = actualAllocations.FirstOrDefault(fa => fa.FundingId == expectedFundingId);
                actualFundingAllocation.Should().NotBeNull();
                
                var actualProviderFundingAllocation =
                    actualFundingAllocation?.ProviderFundingAllocations.FirstOrDefault();
                actualProviderFundingAllocation.Should().NotBeNull();

                var actualFundingAllocationLine = actualProviderFundingAllocation?.ProviderFunding.FundingAllocationLines.FirstOrDefault(fl =>
                    fl.ProviderFundingId == actualProviderFundingAllocation.ProviderFundingId);
                actualFundingAllocationLine.Should().NotBeNull();

                actualFundingAllocationLine?.FundingAllocationProfilePeriods
                    .Should()
                    .Contain(p => p.ProviderFundingId == actualProviderFundingAllocation.ProviderFundingId);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetFundingIdsForFundingNamesAndStatus_ShouldReturnTheCorrectIds()
        {
            // arrange
            var fundingId1 = "1619-AY-2021-Contract-Provider-10014002-2_0";
            var fundingId2 = "1619-AY-2021-Contract-Provider-10014002-2_1";
            var fundingId3 = "1619-AY-2021-Contract-Provider-10014003-1_0";
            const int pageNumber = 1;
            var fundingIds = new[] { fundingId1, fundingId2, fundingId3 };
            var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            CreateFundingAllocation(fundingId1, readId, status: FundingAllocationStatus.NotSet, pageNumber: pageNumber);
            CreateFundingAllocation(fundingId2, readId, status: FundingAllocationStatus.Parked, pageNumber: pageNumber);
            CreateFundingAllocation(fundingId3, readId, status: FundingAllocationStatus.ContractApproved, pageNumber: pageNumber);

            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var fundingIdsReturned = repository.GetFundingIdsForFundingNamesAndStatus(
                fundingIds.Select(fId => fId.RemoveVersionFromId()).ToList(), FundingAllocationStatus.Parked ).Result;

            // assert
            fundingIdsReturned.Single().Should().Be(fundingId2);
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void SetFundingAllocationsParkedSubStatus_ShouldInsertLastParkedAndParkedSubStatus()
        {
            // Arrange
            var fundingId1 = "1619-AY-2021-Contract-Provider-10014002-2_0";
            var fundingId2 = "1619-AY-2021-Contract-Provider-10014002-2_1";
            var fundingId3 = "1619-AY-2021-Contract-Provider-10014003-1_0";
            const int pageNumber = 1;
            var fundingIds = new[] { fundingId1, fundingId2, fundingId3};
            var expectedParkedAfter = DateTime.UtcNow - TimeSpan.FromSeconds(1);


            var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber)); 
            CreateFundingAllocation(fundingId1, readId, pageNumber: pageNumber);
            CreateFundingAllocation(fundingId2, readId, pageNumber: pageNumber);
            CreateFundingAllocation(fundingId3, readId, pageNumber: pageNumber);

            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // Act
            repository.SetFundingAllocationsParkedSubStatus(fundingIds, FundingAllocationSubStatus.AwaitingContractTypeConfig).Wait();

            // Assert
            var actualFundingAllocations = GetFundingAllocationAndParkedInfo(fundingIds);
            
            foreach (var fundingAllocation in actualFundingAllocations)
            {
                fundingAllocation.ParkingAndDiscardedInfo.Should().NotBeNull();
                fundingAllocation.ParkingAndDiscardedInfo.LastParked.Should().BeAfter(expectedParkedAfter);
                fundingAllocation.FundingAllocationSubStatus.Should().Be(FundingAllocationSubStatus.AwaitingContractTypeConfig);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GetAllParkedFundingIdsWithSubStatuses_ShouldGetAllWithExpectedSubStatuses()
        {
            // Arrange
            var unexpectedFundingId1 = "1619-AY-2021-Contract-Provider-10014002-2_0";
            var unexpectedFundingId2 = "1619-AY-2021-Contract-Provider-10014002-2_1";
            var expectedFundingId1 = "fundingId-1-1_0";
            var expectedFundingId2 = "fundingId-2-1_0";
            var expectedFundingId3 = "fundingId-3-1_0";
            const int pageNumber = 1;

            var expectedIds = new[] {expectedFundingId1, expectedFundingId2, expectedFundingId3};

            var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));

            CreateFundingAllocation(unexpectedFundingId1, readId, 
                status: FundingAllocationStatus.NotSet, 
                subStatus: FundingAllocationSubStatus.NotSet, pageNumber: pageNumber);

            CreateFundingAllocation(unexpectedFundingId2, readId, 
                status: FundingAllocationStatus.Parked, 
                subStatus: FundingAllocationSubStatus.AwaitingOutcome, pageNumber: pageNumber);

            CreateFundingAllocation(expectedFundingId1, readId, 
                status: FundingAllocationStatus.Parked,
                subStatus: FundingAllocationSubStatus.AwaitingFundingLineConfig, pageNumber: pageNumber);

            CreateFundingAllocation(expectedFundingId2, readId,
                status: FundingAllocationStatus.Parked,
                subStatus: FundingAllocationSubStatus.AwaitingFundingLineConfig, pageNumber: pageNumber);

            CreateFundingAllocation(expectedFundingId3, readId,
                status: FundingAllocationStatus.Parked,
                subStatus: FundingAllocationSubStatus.AwaitingFundingLineConfig, pageNumber: pageNumber);

            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // Act
            var actualFundingAllocations = 
                repository.GetAllParkedFundingIdsWithSubStatuses(
                    FundingAllocationSubStatus.AwaitingFundingLineConfig,
                    FundingAllocationSubStatus.AwaitingFundingLineConfig,
                    FundingAllocationSubStatus.AwaitingFundingLineConfig).Result.ToList();

            // Assert
            actualFundingAllocations.Should().HaveCount(3);

            actualFundingAllocations.Should().Contain(expectedIds);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GetAllFundingIdsAwaitingProviderNotInCurrentRead_ShouldGetAllWithExpectedSubStatuses()
        {
            // Arrange
            var unexpectedFundingId1 = "NotAwaitingProvider-1_1";
            var unexpectedFundingId2 = "NotAwaitingProvider-2_1";
            var unexpectedFundingId3 = "ParkedInCurrentRead-1_1";
            var expectedFundingId1 = "ParkedInOldRead-1_1";
            var expectedFundingId2 = "ParkedInOldRead-2_1";
            var expectedFundingId3 = "ParkedInOldRead-3_1";
            const int pageNumber = 1;

            var expectedIds = new[] { expectedFundingId1, expectedFundingId2, expectedFundingId3 };

            var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));

            CreateFundingAllocation(unexpectedFundingId1, readId,
                status: FundingAllocationStatus.NotSet,
                subStatus: FundingAllocationSubStatus.NotSet, pageNumber: pageNumber);

            CreateFundingAllocation(unexpectedFundingId2, readId,
                status: FundingAllocationStatus.Parked,
                subStatus: FundingAllocationSubStatus.AwaitingOutcome, pageNumber: pageNumber);

            CreateFundingAllocation(expectedFundingId1, readId,
                status: FundingAllocationStatus.Parked,
                subStatus: FundingAllocationSubStatus.AwaitingProvider, pageNumber: pageNumber);

            CreateFundingAllocation(expectedFundingId2, readId,
                status: FundingAllocationStatus.Parked,
                subStatus: FundingAllocationSubStatus.AwaitingProvider, pageNumber: pageNumber);

            CreateFundingAllocation(expectedFundingId3, readId,
                status: FundingAllocationStatus.Parked,
                subStatus: FundingAllocationSubStatus.AwaitingProvider, pageNumber: pageNumber);

            context.CreateFeedRead(out var newReadId)
                .AddAllAndSave(new FundingAllocationPageControl(newReadId, pageNumber));

            CreateFundingAllocation(unexpectedFundingId3, newReadId,
                status: FundingAllocationStatus.Parked,
                subStatus: FundingAllocationSubStatus.AwaitingProvider, pageNumber: pageNumber);

            var repository = new FundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // Act
            var actualFundingAllocations =
                repository.GetAllFundingIdsAwaitingProviderNotInCurrentRead(newReadId).Result.ToList();

            // Assert
            actualFundingAllocations.Should().HaveCount(3);
            actualFundingAllocations.Should().Contain(expectedIds);
        }

        [TestMethod, TestCategory("EndToEndHelper")]
        public void FundingAllocationRepository_SetFundingAllocationForJ131()
        {
            // Arrange
            const string contractNumber = "contractNumber";
            const int contractVersionNumber = 22;
            const int contractSubVersionNumber = 44;
            var fundingId1 = $"1619-AS-2021-Contract-Provider-10017561-1_6";
            var fundingId2 = $"1619-AS-2021-Contract-Provider-10017561-2_0";
            const int pageNumber = 1;

            var contract = new Contract(contractNumber, contractVersionNumber, contractSubVersionNumber);

            var fundingAllocation1 = FundingAllocationHelper.FundingAllocationWithFundingId(fundingId1);

            var fundingAllocation2 = FundingAllocationHelper.FundingAllocationWithFundingId(fundingId2)
                .WithStatus(FundingAllocationStatus.Parked);

            using var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber))
                .AddContracts(contract)
                .AddFundingAllocations(
                    fundingAllocation1.WithReadId(readId).ForContract(contract.Id).WithPageNumber(pageNumber),
                    fundingAllocation2.WithReadId(readId).ForContract(contract.Id).WithPageNumber(pageNumber))
                .SaveChanges();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_UpdateFundingAllocation_ShouldSetReleaseGroupIdAndStatuses()
        {
            // arrange
            var fundingId1 = "1619-AY-2021-Contract-Provider-10014002-2_0";
            var fundingId2 = "1619-AY-2021-Contract-Provider-10014002-2_1";
            var fundingId3 = "1619-AY-2021-Contract-Provider-10014003-1_0";
            const int pageNumber = 1;
            var fundingIds = new List<string> { fundingId1, fundingId2, fundingId3 };
            var expectedStatus = FundingAllocationStatus.InRelease;
            var expectedSubStatus = FundingAllocationSubStatus.Queued;

            var releaseGroup = ReleaseGroupHelper.ReleaseGroupNamed("releaseGroupName");

            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(fundingId1).WithReadId(readId).WithPageNumber(pageNumber),
                    FundingAllocationHelper.FundingAllocationWithFundingId(fundingId2).WithReadId(readId).WithPageNumber(pageNumber),
                    FundingAllocationHelper.FundingAllocationWithFundingId(fundingId3).WithReadId(readId).WithPageNumber(pageNumber))
                .AddAllAndSave(releaseGroup);

            var repository = new FundingAllocationRepository(context);

            // act
            repository.UpdateFundingAllocations(fundingIds, releaseGroup.Id, expectedStatus, expectedSubStatus).Wait();

            // assert
            var fundingAllocations = GetFundingAllocations(fundingIds);

            fundingAllocations.Count.Should().Be(fundingIds.Count);

            fundingAllocations.ForEach(fundingAllocation =>
            {
                fundingAllocation.ReleaseGroupId.Should().Be(releaseGroup.Id);
                fundingAllocation.Status.Should().Be(expectedStatus.ToString());
                fundingAllocation.SubStatus.Should().Be(expectedSubStatus.ToString());
            });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_InsertOrUpdateParkingInfo_ShouldUpdateWhenValuesExist()
        {
            // arrange
            var fundingId1 = "1619-AY-2021-Contract-Provider-10014002-2_0";
           
            const int pageNumber = 1;
            var fundingIds = new List<string> { fundingId1 };
            var releaseGroup = ReleaseGroupHelper.ReleaseGroupNamed("releaseGroupName");
            var now = DateTime.Now.AsUtc();

            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(fundingId1).WithReadId(readId).WithPageNumber(pageNumber))
                .AddAllAndSave(releaseGroup);

            context.ParkingAndDiscardedInfos.Add(new ParkingAndDiscardedInfo
            {
                FundingAllocationId = fundingId1,
                LastParked = now.AddDays(-1)
            });
            context.SaveChanges();
            var repository = new FundingAllocationRepository(context);

            // act
            repository.InsertOrUpdateParkingInfoLastDiscarded(fundingIds, now).Wait();

            // assert
            var parkingInfos = GetParkingInfos(fundingIds);

            parkingInfos.Count.Should().Be(fundingIds.Count);
            parkingInfos.Single().LastDiscarded.AreEqualIgnoreMilliseconds(now).Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_InsertOrUpdateParkingInfo_ShouldInsertWhenValuesDoNotExist()
        {
            // arrange
            var fundingId1 = "1619-AY-2021-Contract-Provider-10014002-2_0";

            const int pageNumber = 1;
            var fundingIds = new List<string> { fundingId1 };
            var releaseGroup = ReleaseGroupHelper.ReleaseGroupNamed("releaseGroupName");
            var now = DateTime.Now.AsUtc();

            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(fundingId1).WithReadId(readId).WithPageNumber(pageNumber))
                .AddAllAndSave(releaseGroup);

            var repository = new FundingAllocationRepository(context);

            // act
            repository.InsertOrUpdateParkingInfoLastDiscarded(fundingIds, now).Wait();

            // assert
            var parkingInfos = GetParkingInfos(fundingIds);

            parkingInfos.Count.Should().Be(fundingIds.Count);
            parkingInfos.Single().LastDiscarded.AreEqualIgnoreMilliseconds(now).Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetReleaseGroupsWithQueuedFundingAllocationsForContract_ShouldReturnReleaseGroupsWhenFAQueued()
        {
            // arrange
            var fundingId1 = "1619-AY-2021-Contract-Provider-10014002-2_0";
            var contractNumber = "CN - 456";
            var releaseGroupName = "RG - 1234";

            const int pageNumber = 1;
            var fundingIds = new List<string> { fundingId1 };
            var releaseGroup = ReleaseGroupHelper.ReleaseGroupNamed("releaseGroupName");
            var now = DateTime.Now.AsUtc();

            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();
            RemoveReleaseGroups();
            var releaseGroupId = CreateReleaseGroup(releaseGroupName);

            var contractId = CreateContract(contractNumber, relationship: RelationshipToFundingAllocationEnum.Queued);

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(fundingId1).WithReadId(readId).WithPageNumber(pageNumber)
                        .WithStatusAndSubstatus(FundingAllocationStatus.InRelease, FundingAllocationSubStatus.Queued)
                        .ForContract(contractId)
                        .ForReleaseGroup(releaseGroupId))
                .AddAllAndSave(releaseGroup);
            
            var repository = new FundingAllocationRepository(context);

            // act
            var releaseGroupNames  = repository.GetReleaseGroupsWithQueuedFundingAllocationsForContract(contractNumber).Result;

            // assert
            releaseGroupNames.Count.Should().Be(1);
            releaseGroupNames.Should().Contain(releaseGroupName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetReleaseGroupsWithQueuedFundingAllocationsForContract_ShouldReturnEmptyWhenContract_Not_Queued()
        {
            // arrange
            var fundingId1 = "1619-AY-2021-Contract-Provider-10014002-2_0";
            var contractNumber = "CN - 456";
            var releaseGroupName = "RG - 1234";

            const int pageNumber = 1;
            var fundingIds = new List<string> { fundingId1 };
            var releaseGroup = ReleaseGroupHelper.ReleaseGroupNamed("releaseGroupName");
            var now = DateTime.Now.AsUtc();

            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();
            RemoveReleaseGroups();
            var releaseGroupId = CreateReleaseGroup(releaseGroupName);

            var contractId = CreateContract(contractNumber, relationship: RelationshipToFundingAllocationEnum.Created);

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(fundingId1).WithReadId(readId).WithPageNumber(pageNumber)
                        .WithStatusAndSubstatus(FundingAllocationStatus.InRelease, FundingAllocationSubStatus.Queued)
                        .ForContract(contractId)
                        .ForReleaseGroup(releaseGroupId))
                .AddAllAndSave(releaseGroup);

            var repository = new FundingAllocationRepository(context);

            // act
            var releaseGroupNames = repository.GetReleaseGroupsWithQueuedFundingAllocationsForContract(contractNumber).Result;

            // assert
            releaseGroupNames.Any().Should().BeFalse();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_SetFundingAllocationsToPublished_ShouldSetIsPublishedColumnToOne()
        {
            // arrange
            const string fundingId1 = "1619-AY-2021-Contract-Provider-10014003-2_0";

            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();
            
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, 1))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(fundingId1).WithReadId(readId).WithPageNumber(1));

            var repository = new FundingAllocationRepository(context);

            // act
            repository.SetFundingAllocationsToPublished(new List<string> {fundingId1}).Wait();

            // assert
            var fundingAllocation = GetFundingAllocation(fundingId1);
            fundingAllocation.IsPublished.Should().Be(true);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetLatestPublishedFundingLines_ShouldReturnRowsWhenTheRuleIsMet()
        {
            // arrange
            const string fundingId1 = "1619-AY-2021-Contract-Provider-10014003-2_0";
            const string previousFundingId1 = "1619-AY-2021-Contract-Provider-10014003-1_1";
            const string previousProviderFunding = "1619-AS-2122-10000001-1_1";
            const string providerFunding = "1619-AS-2122-10000001-2_0";
            const string firstFundingId1 = "1619-AY-2021-Contract-Provider-10014003-1_0";
            const string firstProviderFunding = "1619-AS-2122-10000001-1_0";

            var context = new FundingAllocationContext(DbContextOptions);
            var fundingAllocationLines = new List<FundingAllocationLine>
            {
                new FundingAllocationLine(providerFunding, "1619-001"),
                new FundingAllocationLine(providerFunding, "1619-002"),
            };
            var fundingAllocationLinesOnPrevious = new List<FundingAllocationLine>
            {
                new FundingAllocationLine(previousProviderFunding, "1619-001")
                {
                    IsOfNoInterest = true
                },
                new FundingAllocationLine(previousProviderFunding, "1619-002"),
            };
            var fundingAllocationLinesOnFirst = new List<FundingAllocationLine>
            {
                new FundingAllocationLine(firstProviderFunding, "1619-001"),
                new FundingAllocationLine(firstProviderFunding, "1619-003"),
            };


            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, 1))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(fundingId1).WithReadId(readId).WithPageNumber(1)
                        .WithProviderAndFundingAllocationLines(fundingAllocationLines));

            context.CreateFeedRead(out var read2Id)
                .AddAllAndSave(new FundingAllocationPageControl(read2Id, 1))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(previousFundingId1).WithReadId(readId).WithPageNumber(1).WithIsPublished(true)
                        .WithProviderAndFundingAllocationLines(fundingAllocationLinesOnPrevious));

            context.CreateFeedRead(out var readIdFirst)
                .AddAllAndSave(new FundingAllocationPageControl(readIdFirst, 1))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(firstFundingId1).WithReadId(readIdFirst).WithPageNumber(1).WithIsPublished(true)
                        .WithProviderAndFundingAllocationLines(fundingAllocationLinesOnFirst));

            var repository = new FundingAllocationRepository(context);

            // act
            var previousLines = repository.GetLatestPublishedFundingLines(fundingId1.ToFundingIdInfo().FundingIdName, fundingId1).Result;

            // assert
            previousLines.Count.Should().Be(1);
            previousLines.All(pl => pl.ProviderFundingId == previousProviderFunding && pl.FundingLineCode == "1619-002").Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetLatestPublishedFundingLines_ShouldReturnEmptyRowsWhenThereAreNoPublished()
        {
            // arrange
            const string fundingId1 = "1619-AY-2021-Contract-Provider-10014003-2_0";
            const string previousFundingId1 = "1619-AY-2021-Contract-Provider-10014003-1_1";
            const string previousProviderFunding = "1619-AS-2122-10000001-1_1";
            const string providerFunding = "1619-AS-2122-10000001-2_0";
            const string firstFundingId1 = "1619-AY-2021-Contract-Provider-10014003-1_0";
            const string firstProviderFunding = "1619-AS-2122-10000001-1_0";

            var context = new FundingAllocationContext(DbContextOptions);
            var fundingAllocationLines = new List<FundingAllocationLine>
            {
                new FundingAllocationLine(providerFunding, "1619-001"),
                new FundingAllocationLine(providerFunding, "1619-002"),
            };
            var fundingAllocationLinesOnPrevious = new List<FundingAllocationLine>
            {
                new FundingAllocationLine(previousProviderFunding, "1619-001"),
                new FundingAllocationLine(previousProviderFunding, "1619-002"),
            };
            var fundingAllocationLinesOnFirst = new List<FundingAllocationLine>
            {
                new FundingAllocationLine(firstProviderFunding, "1619-001"),
                new FundingAllocationLine(firstProviderFunding, "1619-003"),
            };


            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, 1))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(fundingId1).WithReadId(readId).WithPageNumber(1)
                        .WithProviderAndFundingAllocationLines(fundingAllocationLines));

            context.CreateFeedRead(out var read2Id)
                .AddAllAndSave(new FundingAllocationPageControl(read2Id, 1))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(previousFundingId1).WithReadId(readId).WithPageNumber(1)
                        .WithProviderAndFundingAllocationLines(fundingAllocationLinesOnPrevious));

            context.CreateFeedRead(out var readIdFirst)
                .AddAllAndSave(new FundingAllocationPageControl(readIdFirst, 1))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(firstFundingId1).WithReadId(readIdFirst).WithPageNumber(1)
                        .WithProviderAndFundingAllocationLines(fundingAllocationLinesOnFirst));

            var repository = new FundingAllocationRepository(context);

            // act
            var previousLines = repository.GetLatestPublishedFundingLines(fundingId1.ToFundingIdInfo().FundingIdName, fundingId1).Result;

            // assert
            previousLines.Any().Should().BeFalse();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_SetLinesToIsOfNoInterest_ShouldSetLineIsOfNoIntestToTrue()
        {
            // arrange
            const string fundingId1 = "1619-AY-2021-Contract-Provider-10014003-2_0";
            const string providerFunding = "1619-AS-2122-10000001-2_0";

            var context = new FundingAllocationContext(DbContextOptions);
            var fundingAllocationLines = new List<FundingAllocationLine>
            {
                new FundingAllocationLine(providerFunding, "1619-001"),
                new FundingAllocationLine(providerFunding, "1619-002"),
            };
            
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, 1))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(fundingId1).WithReadId(readId).WithPageNumber(1)
                        .WithProviderAndFundingAllocationLines(fundingAllocationLines));

            var repository = new FundingAllocationRepository(context);

            // act
            repository.SetLinesToIsOfNoInterest(
                    fundingAllocationLines.Select(l => (l.ProviderFundingId, l.FundingLineCode))).Wait();

            // assert
            fundingAllocationLines.ForEach(l =>
            {
                var line = GetFundingAllocationLine(l.ProviderFundingId, l.FundingLineCode);
                line.IsOfNoInterest.Should().BeTrue();
            });
        }

        private List<FundingAllocation> GetFundingAllocations(List<string> fundingIds)
        {
            return new FundingAllocationContext(DbContextOptions)
                .FundingAllocations
                .Where(fa => fundingIds.Contains(fa.FundingId))
                .ToList();
        }

        private FundingAllocationLine GetFundingAllocationLine(string providerFundingId, string lineCode)
        {
            return new FundingAllocationContext(DbContextOptions)
                .FundingAllocationLines
                .Single(l => l.ProviderFundingId == providerFundingId && l.FundingLineCode == lineCode);

        }

        private List<ParkingAndDiscardedInfo> GetParkingInfos(List<string> fundingIds)
        {
            return new FundingAllocationContext(DbContextOptions)
                .ParkingAndDiscardedInfos
                .Where(pi => fundingIds.Contains(pi.FundingAllocationId))
                .ToList();
        }

        private int CreateContract(string contractNumber, bool isCreatedInCrm = false, RelationshipToFundingAllocationEnum relationship = RelationshipToFundingAllocationEnum.Created)
        {
            using var context = new FundingAllocationContext(DbContextOptions);
            var contract = new Contract(contractNumber, 1, 0);
            contract.IsCreatedInCrm = isCreatedInCrm;
            contract.RelationshipToFundingAllocationEnum = relationship;
            context.Contracts.Add(contract);
            context.SaveChanges();

            return contract.Id;
        }

        private void CreateFundingAllocation(string fundingId, int readId,
            int? releaseGrpId = null, int? contractId = null, int pageNumber = 1, Guid? crmEnityId = null, FundingAllocationStatus? status = null, FundingAllocationSubStatus? subStatus = null)
        {
            using var context = new FundingAllocationContext(DbContextOptions);
            var fundingAllocation = new FundingAllocation(
                fundingId,
                fundingId.ToFundingIdInfo().FundingIdVersion.ToString(),
                "AY2021",
                "1619",
                "10017057",
                16929,
                1,
                1,
                10, 
                readId)
            {
                ReleaseGroupId = releaseGrpId,
                ContractId = contractId,
                CrmEntityId = crmEnityId
            };
            if (status.HasValue)
            {
                fundingAllocation.FundingAllocationStatus = status.Value;
            }

            if (subStatus.HasValue)
            {
                fundingAllocation.FundingAllocationSubStatus = subStatus.Value;
            }
            
            context.FundingAllocations.Add(fundingAllocation);
            context.SaveChanges();
        }

        private IReadOnlyCollection<FundingAllocation> GetFundingAllocationAndParkedInfo(
            IReadOnlyCollection<string> fundingAllocationIds)
        {
            using var context = new FundingAllocationContext(DbContextOptions);

            return context.FundingAllocations
                .Include(fa => fa.ParkingAndDiscardedInfo)
                .Where(fa => fundingAllocationIds.Contains(fa.FundingId))
                .ToList();
        }
        private FundingAllocation GetFundingAllocation(string fundingId)
        {
            using var context = new FundingAllocationContext(DbContextOptions);

            return context.FundingAllocations.Single(fa => fa.FundingId == fundingId);
        }

        private void RemoveFundingAllocations(IEnumerable<string> fundingIds)
        {
            using var context = new FundingAllocationContext(DbContextOptions);
            var readIds = context.FundingAllocations.Where(fa => fundingIds.Contains(fa.FundingId))
                .Select(fa => fa.ReadId).Distinct().ToList();

            var reads = readIds
                .Select(readId => context.FeedReads.Single(f => f.ReadId == readId)).ToList();
            
            reads.ForEach(read => context.FeedReads.Remove(read));

            context.ProviderFundings.ToList().ForEach(pf => context.ProviderFundings.Remove(pf));

            context.SaveChanges();
        }

        private void RemoveReleaseGroups()
        {
            using var context = new FundingAllocationContext(DbContextOptions);
            context.ReleaseGroups
                .ToList()
                .ForEach(rg => context.ReleaseGroups.Remove(rg));

            context.SaveChanges();
        }

        private void RemovePageControls()
        {
            using var context = new FundingAllocationContext(DbContextOptions);
            context.FundingAllocationPageControls
                .ToList()
                .ForEach(pc => context.FundingAllocationPageControls.Remove(pc));

            context.SaveChanges();
        }

        private void RemoveContracts(IEnumerable<string> contractNumbers)
        {
            using var context = new FundingAllocationContext(DbContextOptions);
            context.Contracts.Where(ca => contractNumbers.Contains(ca.ContractNumber))
                .ToList()
                .ForEach(c => context.Contracts.Remove(c));

            context.SaveChanges();
        }

        private int CreateReleaseGroup(string releaseGrpName)
        {
            using var context = new FundingAllocationContext(DbContextOptions);
            var releaseGroup = new ReleaseGroup("ft", "fp", "fspGc", "ct", Guid.NewGuid(), releaseGrpName);

            context.ReleaseGroups.Add(releaseGroup);
            context.SaveChanges();

            return releaseGroup.Id;
        }

        private void CreatePageControl(int readId, int pageNumber, string latestBookmark)
        {
            using var context = new FundingAllocationContext(DbContextOptions);
            context.FundingAllocationPageControls.Add(new FundingAllocationPageControl(readId, pageNumber)
            {
                LatestBookmarkOnPage = latestBookmark
            });
            context.SaveChanges();
        }

        private int CreateFeedReadRow()
        {
            using var context = new FundingAllocationContext(DbContextOptions);
            var feedRead = new FeedRead();
            context.FeedReads.Add(feedRead);
            context.SaveChanges();

            return feedRead.ReadId;
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

        private DbContextOptions<FundingAllocationContext> DbContextOptions => new DbContextOptionsBuilder<FundingAllocationContext>()
            .UseSqlServer(new SqlConnection(AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"]))
            .Options;
    }
}
