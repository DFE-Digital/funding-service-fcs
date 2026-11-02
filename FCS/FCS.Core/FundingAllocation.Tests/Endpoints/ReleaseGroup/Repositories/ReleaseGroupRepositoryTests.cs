namespace FundingAllocation.Tests.Endpoints.ReleaseGroup.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Endpoints.ReleaseGroup.Repositories;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using FundingAllocation.Tests.TestHelpers.Extensions;
    using TestHelpers;

    [TestClass]
    public class ReleaseGroupRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_ShouldReturnFundingIdsInReleaseGroups()
        {
            // arrange
            var expectedFundingIds = SetupReleaseGroupsAndFundingAllocationsAndReturnExpectedFundingIds();

            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            var repository = new ReleaseGroupRepository(new FundingAllocationContext(options));

            var releaseGroupNames = new List<string> { "ReleaseGroupName1", "ReleaseGroupName2" };

            // act
            var assertFundingIds = repository.GetFundingIds(releaseGroupNames).Result;

            // assert
            bool allFundingIdsFound = expectedFundingIds.All(expectedFundingId => 
                assertFundingIds.Any(r => r == expectedFundingId));

            Assert.IsTrue(allFundingIdsFound, "Not all expected Funding Ids were returned");

            assertFundingIds.Should().BeEquivalentTo(expectedFundingIds, "Incorrect Funding Ids returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_ShouldSetStatusToAwaitingRelease()
        {
            // arrange
            var repository = new ReleaseGroupRepository(new FundingAllocationContext(GetContextOptions()));
            const string releaseGroupNamePrefix = "rg_test";

            var releaseGroupNames = SetupReleaseGroupsAndReturnNames(releaseGroupNamePrefix, ReleaseGroupStatus.ReleaseInProgress);

            // act
            repository.UpdateStatus(releaseGroupNames, ReleaseGroupStatus.AwaitingRelease).Wait();

            // assert
            var releaseGroups = GetReleaseGroups(releaseGroupNames);

            releaseGroups.Should().HaveCount(releaseGroupNames.Count);
            releaseGroups.ToList().ForEach(rg =>
            {
                rg.Status.Should().Be("AwaitingRelease");
            });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_GetReleaseInProgressReleaseGroup()
        {
            // arrange
            using var context = new FundingAllocationContext(GetContextOptions());
            const string fundingType = "ft";
            const string fundingPeriod = "fp";
            const string fspGroupCode = "fspGrpCode";
            const string contractType = "ct";
            const string releaseGroupName1 = "RG100888";
            const string releaseGroupName2 = "RG100999";
            RemoveReleaseGroups(fundingType, fundingPeriod, fspGroupCode, contractType);
            int releaseInProgressRgId = InsertReleaseGroup(fundingType, fundingPeriod, fspGroupCode, contractType, releaseGroupName1, status: ReleaseGroupStatus.ReleaseInProgress);
            InsertReleaseGroup(fundingType, fundingPeriod, fspGroupCode, contractType, releaseGroupName2);
            ReleaseGroupRepository repository = new ReleaseGroupRepository(context);

            // act
            var codeOption = repository.GetReleaseInProgressReleaseGroup(fundingType, fundingPeriod, fspGroupCode, contractType)
                .Result;

            // assert
            Assert.IsTrue(codeOption.IsSome, "We should have returned a value");
            codeOption.Match(Some: id => Assert.AreEqual(releaseInProgressRgId, id),
                None: () => Assert.Fail("We have not returned an id"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_GetNextReleaseGroupGroupId()
        {
            // arrange
            using var context = new FundingAllocationContext(GetContextOptions());
            ReleaseGroupRepository repository = new ReleaseGroupRepository(context);

            // act
            var id = repository.GetNextReleaseGroupGroupId()
                .Result;

            // assert
            id.Should().NotBe(0);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_GetCrmEntityIds_ShouldReturnAListOfCrmEntityIds()
        {
            // arrange
            var repository = new ReleaseGroupRepository(new FundingAllocationContext(GetContextOptions()));
            const string releaseGroupName1 = "rg_1";
            const string releaseGroupName2 = "rg_2";
            var crmEntityId1 = Guid.NewGuid();
            var crmEntityId2 = Guid.NewGuid();

            ClearDownReleaseGroups();

            var releaseGroupNames = new List<string> { releaseGroupName1, releaseGroupName2 };

            AddReleaseGroup("ftc1", releaseGroupName1, crmEntityId1);
            AddReleaseGroup("ftc2", releaseGroupName2, crmEntityId2);

            // act
            var crmEntityIds = repository.GetCrmEntityIds(releaseGroupNames).Result;

            // assert
            crmEntityIds.Should().HaveCount(releaseGroupNames.Count);
            crmEntityIds.Should().Contain(crmEntityId1.ToString().ToUpper());
            crmEntityIds.Should().Contain(crmEntityId2.ToString().ToUpper());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_GetReleaseGroupNameValidationResult_ShouldResultWithPassedAndFailed()
        {
            // arrange
            var repository = new ReleaseGroupRepository(new FundingAllocationContext(GetContextOptions()));
            const string releaseGroupName1 = "rg_1";
            const string releaseGroupName2 = "rg_2";
            var crmEntityId1 = Guid.NewGuid();
            var crmEntityId2 = Guid.NewGuid();
            const string fundingTypeInProgress = "EDSK";
            const string fundingTypeLoaded = "NLG";
            const string fundingPeriodName = "AY2122";

            ClearDownReleaseGroups();
            ClearDownBulkUploadStatus();

            var releaseGroupNames = new List<string> { releaseGroupName1, releaseGroupName2 };
            CreateBulkUploadStatus(fundingTypeInProgress, fundingPeriodName, BulkUploadStatus.UploadStatus.InProgress);
            CreateBulkUploadStatus(fundingTypeLoaded, fundingPeriodName, BulkUploadStatus.UploadStatus.Loaded);

            AddReleaseGroup(fundingTypeInProgress, releaseGroupName1, crmEntityId1, fundingPeriodName);
            AddReleaseGroup(fundingTypeLoaded, releaseGroupName2, crmEntityId2, fundingPeriodName);

            // act
            var result = repository.GetReleaseGroupNameValidationResult(releaseGroupNames).Result;

            // assert
            result.ValidReleaseGroupNames.Should().HaveCount(1);
            result.ValidReleaseGroupNames.Single().Should().Be(releaseGroupName2);
            result.ReleaseGroupNamesWithFundingInfoBulkUploadedInProgress.Should().HaveCount(1);
            result.ReleaseGroupNamesWithFundingInfoBulkUploadedInProgress.Single().Should().Be(releaseGroupName1);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseGroupRepository_GetQueuedFundingIds_ShouldReturnQueuedFundingIdsInReleaseGroupsRelatedToContractOnly()
        {
            // arrange
            const string fundingId1 = "1619-AS-2122-Contracting-LocalAuthority-10000795-1_0";
            const string fundingId2 = "1619-AS-2122-Contracting-LocalAuthority-10000755-2_0";
            const string fundingId3 = "1619-AS-2122-Contracting-LocalAuthority-10000757-2_0";
            const string releaseGroupName = "RG - Simple";
            const string contractNumber = "TT CN123";
            const int pageNumber = 1;
            
            using var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();
            RemovedReleaseGroup(releaseGroupName);
            var releaseGroupId = CreateSimpleReleaseGroup(releaseGroupName);
            var contractId = CreateContract(contractNumber, 1, 0);

            var fundingAllocation1 = FundingAllocationHelper.FundingAllocationWithFundingId(fundingId1)
                .WithStatus(FundingAllocationStatus.InRelease)
                .WithSubStatus(FundingAllocationSubStatus.Queued)
                .ForContract(contractId)
                .ForReleaseGroup(releaseGroupId)
                .WithPageNumber(pageNumber);

            var fundingAllocation2 = FundingAllocationHelper.FundingAllocationWithFundingId(fundingId2)
                .WithStatus(FundingAllocationStatus.InRelease)
                .WithSubStatus(FundingAllocationSubStatus.Queued)
                .ForReleaseGroup(releaseGroupId)
                .WithPageNumber(pageNumber);

            var fundingAllocation3 = FundingAllocationHelper.FundingAllocationWithFundingId(fundingId3)
                .ForReleaseGroup(releaseGroupId)
                .WithPageNumber(pageNumber);

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber))
                .AddFundingAllocations(
                    fundingAllocation1.WithReadId(readId),
                    fundingAllocation2.WithReadId(readId),
                    fundingAllocation3.WithReadId(readId))
                .SaveChanges();

            var releaseGroupNames = new List<string> { releaseGroupName};

            var repository = new ReleaseGroupRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var returnedFundingIds = repository.GetQueuedFundingIds(releaseGroupNames, new List<string>{contractNumber}).Result;

            // assert
            returnedFundingIds.Count.Should().Be(1);
            returnedFundingIds.Contains(fundingId1).Should().BeTrue();
            returnedFundingIds.Contains(fundingId2).Should().BeFalse();
            returnedFundingIds.Contains(fundingId3).Should().BeFalse();
        }

        private void RemoveReleaseGroups(string fundingType, string fundingPeriod, string fspGroupCode, string contractType)
        {
            using var context = new FundingAllocationContext(GetContextOptions());
            context.ReleaseGroups.Where(rg => rg.FundingTypeCode == fundingType && rg.FundingPeriodCode == fundingPeriod && rg.FSPGroupCode == fspGroupCode
                                              && rg.ContractType == contractType).ToList()
                .ForEach(rg => context.ReleaseGroups.Remove(rg));

            context.SaveChanges();
        }

        private int CreateSimpleReleaseGroup(string releaseGrpName)
        {
            using var context = new FundingAllocationContext(DbContextOptions);
            var releaseGroup = new ReleaseGroup("ft", "fp", "fspGc", "ct", Guid.NewGuid(), releaseGrpName);

            context.ReleaseGroups.Add(releaseGroup);
            context.SaveChanges();

            return releaseGroup.Id;
        }

        private void RemovedReleaseGroup(string releaseGroupName)
        {
            using var context = new FundingAllocationContext(DbContextOptions);
            context.ReleaseGroups.Where(rg => rg.ReleaseGroupName == releaseGroupName).ToList()
                .ForEach(rg => context.ReleaseGroups.Remove(rg));

            context.SaveChanges();
        }

        private int InsertReleaseGroup(string fundingType, string fundingPeriod, string fspGroupCode,
            string contractType, string releaseGroupName, ReleaseGroupStatus status = ReleaseGroupStatus.AwaitingRelease)
        {
            using var context = new FundingAllocationContext(GetContextOptions());
            ReleaseGroup releaseGroup = new ReleaseGroup(fundingType, fundingPeriod, fspGroupCode,
                contractType, Guid.NewGuid(), releaseGroupName);
            releaseGroup.ReleaseGroupStatus = status;
            if (status == ReleaseGroupStatus.Released)
            {
                releaseGroup.ReleasedDate = DateTime.Now;
            }
            context.ReleaseGroups.Add(releaseGroup);
            context.SaveChanges();

            return releaseGroup.Id;
        }

        private IReadOnlyCollection<string> SetupReleaseGroupsAndFundingAllocationsAndReturnExpectedFundingIds()
        {
            const string fundingTypeCode = "ftc";
            const string fundingTypePeriod = "ftp";
            const string fspGroupCode = "fgc";
            const string contractType = "ct";
            const string releaseGroupName = "ReleaseGroupName";
            const int pageNumber = 1;

            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var context = new FundingAllocationContext(options);
            context.Database.ExecuteSqlRaw("DELETE FROM FundingAllocation.ReleaseGroup");
            context.Database.ExecuteSqlRaw("DELETE FROM FundingAllocation.FeedRead");

            List<ReleaseGroup> releaseGroups =
                Enumerable.Range(1, 3)
                    .Select(i => new ReleaseGroup(fundingTypeCode + i,
                        fundingTypePeriod + i,
                        fspGroupCode + i,
                        contractType + i,
                        Guid.NewGuid(),
                        releaseGroupName + i))
                    .ToList();
            context.ReleaseGroups.AddRange(releaseGroups);
            context.SaveChanges();

            const string sql = "SELECT [Id] FROM [FundingAllocation].[ReleaseGroup] ORDER BY ID";
            var releaseGroupIds = context.Database.GetDbConnection().Query<int>(sql).ToList();
            var releaseGroupIdsToBeReleased = releaseGroupIds.Take(2).ToList();
            var releaseGroupIdsNotToBeReleased = releaseGroupIds.TakeLast(1).ToList();
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            var fundingAllocationsToBeReleased = CreateFundingAllocations(releaseGroupIdsToBeReleased, readId, pageNumber);
            var fundingAllocationsNotToBeReleased = CreateFundingAllocations(releaseGroupIdsNotToBeReleased, readId, pageNumber);

            context.FundingAllocations.AddRange(fundingAllocationsToBeReleased);
            context.FundingAllocations.AddRange(fundingAllocationsNotToBeReleased);
            context.SaveChanges();

            return fundingAllocationsToBeReleased.Select(fa => fa.FundingId).ToList();
        }

        private IReadOnlyCollection<string> SetupReleaseGroupsAndReturnNames(string releaseGroupNamePrefix, ReleaseGroupStatus status = ReleaseGroupStatus.AwaitingRelease)
        {
            const string fundingTypeCode = "ftc";
            const string fundingTypePeriod = "ftp";
            const string fspGroupCode = "fgc";
            const string contractType = "ct";

            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var context = new FundingAllocationContext(options);
            context.Database.ExecuteSqlRaw($"DELETE FROM FundingAllocation.ReleaseGroup");
            var releaseGroupNames = Enumerable.Range(1, 3).Select(i => $"{releaseGroupNamePrefix}_{i}").ToList();
            List<ReleaseGroup> releaseGroups =
                    releaseGroupNames
                    .Select((name, i) =>
                    {
                        var rg = new ReleaseGroup(fundingTypeCode + i,
                            fundingTypePeriod + i,
                            fspGroupCode + i,
                            contractType + i,
                            Guid.NewGuid(),
                            name);

                        rg.ReleaseGroupStatus = status;

                        return rg;
                    })
                    .ToList();


            context.ReleaseGroups.AddRange(releaseGroups);
            context.SaveChanges();

            return releaseGroupNames;
        }

        private void AddReleaseGroup(
            string fundingTypeCode,
            string releaseGroupName,
            Guid crmEntityId,
            string fundingPeriodName = "AY2122")
        {
            const string fspGroupCode = "fgc";
            const string contractType = "ct";

            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];
            var options = new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;

            using var context = new FundingAllocationContext(options);

            var releaseGroup = new ReleaseGroup(fundingTypeCode,
                fundingPeriodName,
                fspGroupCode,
                contractType,
                crmEntityId,
                releaseGroupName);

            context.ReleaseGroups.Add(releaseGroup);
            context.SaveChanges();
        }

        private void CreateBulkUploadStatus(string fundingType, string fundingPeriodName, BulkUploadStatus.UploadStatus status)
        {
            using var context = new FundingAllocationContext(GetContextOptions());
            context.BulkUploadStatuses.Add(new BulkUploadStatus(Guid.NewGuid(), fundingType, fundingPeriodName,
                status.ToString()));

            context.SaveChanges();
        }

        private void ClearDownReleaseGroups()
        {
            using var context = new FundingAllocationContext(GetContextOptions());
            context.Database.ExecuteSqlRaw($"DELETE FROM FundingAllocation.ReleaseGroup");
        }
        private void ClearDownBulkUploadStatus()
        {
            using var context = new FundingAllocationContext(GetContextOptions());
            context.Database.ExecuteSqlRaw($"DELETE FROM FundingAllocation.BulkUploadStatus");
        }

        private IReadOnlyCollection<FundingAllocation> CreateFundingAllocations(List<int> releaseIds, int readId, int pageNumber)
        {
            var fundingAllocations = new List<FundingAllocation>();

            releaseIds.ForEach(releaseGroupId =>
            {
                fundingAllocations.AddRange(
                    Enumerable.Range(1, 5)
                        .Select(i => new FundingAllocation(
                                $"PSG-AY-1920-Information-LocalAuthority-{releaseGroupId}-{i}-1_0",
                                "1_0",
                                "1920",
                                "PSG",
                                "100",
                                100m,
                                pageNumber,
                                1,
                                0,
                                readId)
                            { ReleaseGroupId = releaseGroupId })
                        .ToList());
            });

            return fundingAllocations;
        }

        private static DbContextOptions<FundingAllocationContext> GetContextOptions()
        {
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];

            return new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new Microsoft.Data.SqlClient.SqlConnection(connectionString))
                .Options;
        }

        private static IReadOnlyCollection<ReleaseGroup> GetReleaseGroups(IEnumerable<string> releaseGroupNames)
        {
            return new FundingAllocationContext(GetContextOptions()).ReleaseGroups
                .Where(rg => releaseGroupNames.Contains(rg.ReleaseGroupName))
                .ToList();
        }

        private DbContextOptions<FundingAllocationContext> DbContextOptions => new DbContextOptionsBuilder<FundingAllocationContext>()
            .UseSqlServer(new SqlConnection(AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"]))
            .Options;

        private static int CreateContract(string contractNumber, int version, int subVersion, RelationshipToFundingAllocationEnum relationship = RelationshipToFundingAllocationEnum.Created)
        {
            using var context = new FundingAllocationContext(GetContextOptions());
            var contract = new Contract(contractNumber, version, subVersion)
            {
                RelationshipToFundingAllocationEnum = relationship
            };

            context.Contracts.Add(contract);

            context.SaveChanges();

            return contract.Id;
        }
    }
}