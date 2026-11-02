namespace FundingAllocation.Tests.Endpoints.ReleaseGroup.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Extensions;
    using FundingAllocation.Tests.TestHelpers.Extensions;
    using Microsoft.Data.SqlClient;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Repositories = FundingAllocation.Endpoints.ReleaseGroup.Repositories;

    [TestClass]
    public class FundingAllocationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetFundingAllocationsWithOfInterestLinesForIds_ShouldGetAllChildObjects()
        {
            // arrange
            const string fundingAllocationId = "Some fa id";
            const string providerFundingId = "Some pf id";
            const int pageNumber = 1;
            ClearFundingAllocation(fundingAllocationId);
            ClearProviderFundings();
            var context = new FundingAllocationContext(DbContextOptions);

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            FundingAllocation fundingAllocation = new FundingAllocation(
                fundingAllocationId, "", "", "",
                "", -1, pageNumber, -1, -1, readId)
            {
                ProviderFundingAllocations =
                {
                    new ProviderFundingAllocation(providerFundingId, "")
                    {
                        ProviderFunding = new ProviderFunding(providerFundingId, -1, "FURTH", "01GFE")
                        {
                            FundingAllocationLines =
                            {
                                new FundingAllocationLine(providerFundingId, "1619-001")
                                {
                                    FundingAllocationProfilePeriods = {new FundingAllocationProfilePeriod(providerFundingId, "1619-001", 202101, 11)}
                                },
                                new FundingAllocationLine(providerFundingId, "1619-002")
                                {
                                    FundingAllocationProfilePeriods = {new FundingAllocationProfilePeriod(providerFundingId, "1619-002", 202101, 11)},
                                    IsOfNoInterest = true
                                }
                            }
                        }
                    }
                }
            };
            
            CreateFundingAllocation(fundingAllocation);
            var repository = new Repositories.ReleaseGroupFundingAllocationRepository(new LoggingContext(GetContextOptions()));

            // act
            var returnedFundingAllocations = repository.GetFundingAllocationsWithOfInterestLinesForIds(new List<string>{fundingAllocationId}).Result;

            // assert
            var returnedFundingAllocation = returnedFundingAllocations.SingleOrDefault();
            Assert.IsNotNull(returnedFundingAllocation, "The returnedFundingAllocation is null");
            Assert.AreEqual(1, returnedFundingAllocation.ProviderFundingAllocations.Count, "The returnedFundingAllocation.ProviderFundingAllocations.Count is incorrect");
            var pfAllocation = returnedFundingAllocation.ProviderFundingAllocations.Single();
            Assert.AreEqual(providerFundingId, pfAllocation.ProviderFundingId, "The ProviderFundingId is not populated");
            Assert.AreEqual(1, pfAllocation.ProviderFunding.FundingAllocationLines.Count, "The number of FundingAllocationLines is not correct");
            var fundingAllocationLine = pfAllocation.ProviderFunding.FundingAllocationLines.Single();
            Assert.AreEqual(1, fundingAllocationLine.FundingAllocationProfilePeriods.Count, "The number of FundingAllocationProfilePeriods is not correct");
            var faProfilePeriodPeriod = fundingAllocationLine.FundingAllocationProfilePeriods.Single();
            Assert.AreEqual(202101, faProfilePeriodPeriod.Period, "The faProfilePeriodPeriod.Period is not correct");
            Assert.AreEqual(11, faProfilePeriodPeriod.PlannedValue, "The faProfilePeriodPeriod.PlannedValue is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_UpdateWithContractId_ShouldUpdate()
        {
            // arrange
            const string fundingAllocationId1 = "Some fa2 id1";
            const string fundingAllocationId2 = "Some fa2 id2";

            const string contractNumber = "some cn2";
            const int pageNumber = 1;

            ClearFundingAllocation(fundingAllocationId1);
            ClearFundingAllocation(fundingAllocationId2);
            ClearContracts(contractNumber);
            
            var context = new FundingAllocationContext(DbContextOptions);

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            FundingAllocation fundingAllocation1 = new FundingAllocation(
                fundingAllocationId1, "", "", "",
                "", -1, pageNumber, -1, 1, readId);

            CreateFundingAllocation(fundingAllocation1);
            FundingAllocation fundingAllocation2 = new FundingAllocation(
                fundingAllocationId2, "", "", "",
                "", -1, pageNumber, -1, 1, readId);

            CreateFundingAllocation(fundingAllocation2);
            var contractId = CreateContract(contractNumber, 1, 0);
            var repository = new Repositories.ReleaseGroupFundingAllocationRepository(new FundingAllocationContext(GetContextOptions()));

            // act
            repository.UpdateFundingAllocationsWithContractId(new List<string>{fundingAllocationId1, fundingAllocationId2}, contractId).Wait();
            
            // assert
            var fundingAllocationsInDb = GetFundingAllocationsForContractId(contractId);

            Assert.AreEqual(2, fundingAllocationsInDb.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_RemoveQueuedStatusFromAnyFundingAllocations_ShouldSetStatusAndSubStatusToNull()
        {
            // arrange
            const string fundingAllocationId1 = "Some fa2 id1";
            const string fundingAllocationId2 = "Some fa2 id2";

            const string contractNumber = "some cn2";
            const int pageNumber = 1;

            ClearFundingAllocation(fundingAllocationId1);
            ClearFundingAllocation(fundingAllocationId2);
            ClearProviderFundings();
            ClearContracts(contractNumber);
            var context = new FundingAllocationContext(DbContextOptions);

            var contractId = CreateContract(contractNumber, 1, 0);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));

            FundingAllocation fundingAllocation1 = new FundingAllocation(
                fundingAllocationId1, "", "", "",
                "", -1, pageNumber, -1, 1, readId)
            {
                FundingAllocationStatus = FundingAllocationStatus.InRelease,
                FundingAllocationSubStatus = FundingAllocationSubStatus.Queued,
            };

            CreateFundingAllocation(fundingAllocation1, contractId:contractId);
            FundingAllocation fundingAllocation2 = new FundingAllocation(
                fundingAllocationId2, "", "", "",
                "", -1, pageNumber, -1, 1, readId)
            {
                FundingAllocationStatus = FundingAllocationStatus.Parked,
                FundingAllocationSubStatus = FundingAllocationSubStatus.AwaitingOutcome
            };

            CreateFundingAllocation(fundingAllocation2);
            
            var repository = new Repositories.ReleaseGroupFundingAllocationRepository(new FundingAllocationContext(GetContextOptions()));

            // act
            repository.RemoveQueuedInfoFromQueuedFundingAllocations(new List<string> { fundingAllocationId1, fundingAllocationId2 }, new List<string>{ contractNumber }).Wait();

            // assert
            fundingAllocation1 = GetFundingAllocation(fundingAllocationId1);
            fundingAllocation1.Status.Should().BeNull();
            fundingAllocation1.SubStatus.Should().BeNull();
            fundingAllocation1.ContractId.Should().BeNull();

            fundingAllocation2 = GetFundingAllocation(fundingAllocationId2);
            fundingAllocation2.Status.Should().Be(FundingAllocationStatus.Parked.ToString());
            fundingAllocation2.SubStatus.Should().Be(FundingAllocationSubStatus.AwaitingOutcome.ToString());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_RemoveQueuedStatusFromAnyFundingAllocations_ShouldSetStatusAndSubStatusToNullForContractOnly()
        {
            // arrange
            const string fundingAllocationId1 = "Some fa2 id1";
            const string fundingAllocationId2 = "Some fa2 id2";

            const string contractNumber = "some cn2";
            const int pageNumber = 1;

            ClearFundingAllocation(fundingAllocationId1);
            ClearFundingAllocation(fundingAllocationId2);
            ClearProviderFundings();
            ClearContracts(contractNumber);
            var context = new FundingAllocationContext(DbContextOptions);

            var contractId = CreateContract(contractNumber, 1, 0);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));

            FundingAllocation fundingAllocation1 = new FundingAllocation(
                fundingAllocationId1, "", "", "",
                "", -1, pageNumber, -1, 1, readId)
            {
                FundingAllocationStatus = FundingAllocationStatus.InRelease,
                FundingAllocationSubStatus = FundingAllocationSubStatus.Queued,
            };

            CreateFundingAllocation(fundingAllocation1, contractId: contractId);
            FundingAllocation fundingAllocation2 = new FundingAllocation(
                fundingAllocationId2, "", "", "",
                "", -1, pageNumber, -1, 1, readId)
            {
                FundingAllocationStatus = FundingAllocationStatus.InRelease,
                FundingAllocationSubStatus = FundingAllocationSubStatus.Queued,
            };

            CreateFundingAllocation(fundingAllocation2);

            var repository = new Repositories.ReleaseGroupFundingAllocationRepository(new FundingAllocationContext(GetContextOptions()));

            // act
            repository.RemoveQueuedInfoFromQueuedFundingAllocations(new List<string> { fundingAllocationId1, fundingAllocationId2 }, new List<string> { contractNumber }).Wait();

            // assert
            fundingAllocation1 = GetFundingAllocation(fundingAllocationId1);
            fundingAllocation1.Status.Should().BeNull();
            fundingAllocation1.SubStatus.Should().BeNull();
            fundingAllocation1.ContractId.Should().BeNull();

            fundingAllocation2 = GetFundingAllocation(fundingAllocationId2);
            fundingAllocation2.Status.Should().Be(FundingAllocationStatus.InRelease.ToString());
            fundingAllocation2.SubStatus.Should().Be(FundingAllocationSubStatus.Queued.ToString());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetFundingAllocationGroupingInfos_ShouldReturnGroupingInfo()
        {
            // arrange
            const int pageNumber = 1;
            var context = new FundingAllocationContext(DbContextOptions);

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));

            var fundingAllocationWithFundingForLa = new FundingAllocation("PSG-AY-2021-Payment-AcademyTrust-10000001-1_0",
                "1_0",
                "AY-2021",
                "PSG",
                "10000001",
                100, pageNumber, 1, 1, readId);
            fundingAllocationWithFundingForLa.ProviderFundingAllocations.Add(new ProviderFundingAllocation(
                "PSG-AY-2021-10000001-1_0",
                "PSG-AY-2021-Payment-AcademyTrust-10000001-1_0"
                )
            {
                ProviderFunding = new ProviderFunding("PSG-AY-2021-10000001-1_0", 10000001,
                "Local",
                "10LAU")
            });

            var fundingAllocationWithFundingForSsfs = new FundingAllocation("NLG-AY-2021-Payment-AcademyTrust-10000002-1_0",
                "1_0",
                "AY-2021",
                "NMSS",
                "10000002",
                100, pageNumber, 1, 1, readId);
            fundingAllocationWithFundingForSsfs.ProviderFundingAllocations.Add(new ProviderFundingAllocation(
                "NLG-AY-2021-10000003-1_0",
                "NLG-AY-2021-Payment-AcademyTrust-10000002-1_0"
                )
            {
                ProviderFunding = new ProviderFunding("NLG-AY-2021-10000003-1_0", 10000003,
                    "Schoo",
                    "08SSF")
            });
            fundingAllocationWithFundingForSsfs.ProviderFundingAllocations.Add(new ProviderFundingAllocation(
                "NLG-AY-2021-10000004-1_0",
                "NLG-AY-2021-Payment-AcademyTrust-10000002-1_0"
                )
            {
                ProviderFunding = new ProviderFunding("NLG-AY-2021-10000004-1_0", 10000004,
                    "Schoo",
                    "08SSF")
            });

            var fundingAllocations = new List<FundingAllocation> { fundingAllocationWithFundingForLa, fundingAllocationWithFundingForSsfs};
            var fundingIds = fundingAllocations.Select(fa => fa.FundingId).ToList();
            ClearProviderFundings();
            fundingIds.ForEach(ClearFundingAllocation);
            fundingAllocations.ForEach(fa => CreateFundingAllocation(fa));

            var repository = new Repositories.ReleaseGroupFundingAllocationRepository(new FundingAllocationContext(GetContextOptions()));

            // act
            var groupingResults = repository.GetFundingAllocationGroupingInfos(fundingIds).Result;

            // assert
            groupingResults.Should().NotBeNull();
            groupingResults.Should().HaveCount(2);

            fundingAllocations.ForEach(fa =>
            {
                var matchingGroupingResult = groupingResults.SingleOrDefault(groupingInfo =>
                    groupingInfo.FundingId == fa.FundingId &&
                    groupingInfo.AllocationFundingStreamCode == fa.AllocationFundingStream &&
                    groupingInfo.AllocationPeriodId == fa.Period &&
                    groupingInfo.ContractingUkprn == fa.UKPRN &&
                    groupingInfo.ProviderType == fa.ProviderFundingAllocations.First().ProviderFunding.ProviderType &&
                    groupingInfo.ProviderSubType == fa.ProviderFundingAllocations.First().ProviderFunding.ProviderSubType);

                matchingGroupingResult.Should().NotBeNull($"a grouping result should have been returned for {fa.FundingId}");
            });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_GetMatchingLastApprovedFundingIds_ShouldReturnApprovedContractFundingIds()
        {
            // arrange
            const string fundingIdApprovedContract1 = "fundingId_xxx-14_0";
            const string fundingIdApprovedContract2 = "fundingId_yyy-2_0";
            const string fundingIdReleased1 = "fundingId_xxx-2_0";
            const string fundingIdReleased2 = "fundingId_yyy-3_0";
            const string fundingIdReleased3 = "fundingId_zzz-1_0";
            const string fundingIdApprovedContract3 = "fundingId_xxx-1_0";

            const string approvedContractNumber = "approvedContractNumber";
            const int pageNumber = 1;

            ClearFundingAllocation(fundingIdApprovedContract1);
            ClearFundingAllocation(fundingIdApprovedContract2);
            ClearFundingAllocation(fundingIdApprovedContract3);
            ClearFundingAllocation(fundingIdReleased1);
            ClearFundingAllocation(fundingIdReleased2);
            ClearContracts(approvedContractNumber);

            var context = new FundingAllocationContext(DbContextOptions);

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));

            var approvedContractId = CreateContract(approvedContractNumber, 1, 0);

            var fundingAllocationApprovedContract1 = new FundingAllocation(
                fundingIdApprovedContract1, fundingIdApprovedContract1.Split('-')[1], "", "",
                "", -1, pageNumber, -1, 1, readId);
            fundingAllocationApprovedContract1.FundingAllocationStatus = FundingAllocationStatus.ContractApproved;
            fundingAllocationApprovedContract1.FundingAllocationSubStatus = FundingAllocationSubStatus.ContractApproved;
            CreateFundingAllocation(fundingAllocationApprovedContract1, approvedContractId);

            var fundingAllocationApprovedContract2 = new FundingAllocation(
                fundingIdApprovedContract2, fundingIdApprovedContract2.Split('-')[1], "", "",
                "", -1, pageNumber, -1, 1, readId);
            fundingAllocationApprovedContract2.FundingAllocationStatus = FundingAllocationStatus.ContractApproved;
            fundingAllocationApprovedContract2.FundingAllocationSubStatus = FundingAllocationSubStatus.ContractApproved;
            CreateFundingAllocation(fundingAllocationApprovedContract2, approvedContractId);

            var fundingAllocationApprovedContract3 = new FundingAllocation(
                fundingIdApprovedContract3, fundingIdApprovedContract3.Split('-')[1], "", "",
                "", -1, pageNumber, -1, 1, readId);
            fundingAllocationApprovedContract3.FundingAllocationStatus = FundingAllocationStatus.ContractApproved;
            fundingAllocationApprovedContract3.FundingAllocationSubStatus = FundingAllocationSubStatus.ContractApproved;
            CreateFundingAllocation(fundingAllocationApprovedContract3, approvedContractId);

            var fundingAllocationReleased1 = new FundingAllocation(
                fundingIdReleased1, "", "", "",
                "", -1, pageNumber, -1, 1, readId);
            CreateFundingAllocation(fundingAllocationReleased1);

            var fundingAllocationReleased2 = new FundingAllocation(
                fundingIdReleased2, "", "", "",
                "", -1, pageNumber, -1, 1, readId);
            CreateFundingAllocation(fundingAllocationReleased2);

            var fundingAllocationReleased3 = new FundingAllocation(
                fundingIdReleased3, "", "", "",
                "", -1, pageNumber, -1, 1, readId);
            CreateFundingAllocation(fundingAllocationReleased3);

            var repository = new Repositories.ReleaseGroupFundingAllocationRepository(new FundingAllocationContext(GetContextOptions()));

            var releasedFundingAllocationNames = new List<string> { fundingIdReleased1, fundingIdReleased2 };
            // act
            var approvedContractFundingIds = repository.GetMatchingLastApprovedFundingIds(releasedFundingAllocationNames.Select(fId => fId.ToFundingIdInfo().FundingIdName).ToList()).Result;

            // assert
            var expectedApprovedContractFundingIds = new List<string> { fundingIdApprovedContract1, fundingIdApprovedContract2 };

            approvedContractFundingIds.Count.Should().Be(expectedApprovedContractFundingIds.Count);
            expectedApprovedContractFundingIds.All(approvedContractFundingId => approvedContractFundingIds.Contains(approvedContractFundingId))
                .Should().Be(true, "All the expected Approved Contract Funding Ids should be present");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_RemoveAnyOrphanedQueuedContracts_ShouldRemoveContractsThatAreNotReferenced()
        {
            // arrange
            const string fundingAllocationId1 = "Some fa2 id1";
            const string fundingAllocationId2 = "Some fa2 id2";

            const string contractNumber = "some CN1";
            const string contractNumber2 = "some CN2";
            const int pageNumber = 1;

            ClearFundingAllocation(fundingAllocationId1);
            ClearFundingAllocation(fundingAllocationId2);
            ClearProviderFundings();
            ClearContracts(contractNumber);
            ClearContracts(contractNumber2);
            var context = new FundingAllocationContext(DbContextOptions);

            var contractId = CreateContract(contractNumber, 1, 0, RelationshipToFundingAllocationEnum.Queued);
            var contractId2 = CreateContract(contractNumber2, 1, 0, RelationshipToFundingAllocationEnum.Queued);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));

            FundingAllocation fundingAllocation1 = new FundingAllocation(
                fundingAllocationId1, "", "", "",
                "", -1, pageNumber, -1, 1, readId)
            {
                FundingAllocationStatus = FundingAllocationStatus.InRelease,
                FundingAllocationSubStatus = FundingAllocationSubStatus.Queued
            };

            CreateFundingAllocation(fundingAllocation1, contractId: contractId);
            FundingAllocation fundingAllocation2 = new FundingAllocation(
                fundingAllocationId2, "", "", "",
                "", -1, pageNumber, -1, 1, readId)
            {
                FundingAllocationStatus = FundingAllocationStatus.Parked,
                FundingAllocationSubStatus = FundingAllocationSubStatus.AwaitingOutcome
            };

            CreateFundingAllocation(fundingAllocation2);

            var repository = new Repositories.ReleaseGroupFundingAllocationRepository(new FundingAllocationContext(GetContextOptions()));

            // act
            repository.RemoveAnyOrphanedQueuedContracts().Wait();

            // assert
            var queuedContracts = GetQueuedContracts();
            queuedContracts.Count.Should().Be(1);
            queuedContracts.Select(c => c.ContractNumber).Contains(contractNumber).Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationRepository_ShouldGetFundingAllocationCrmIds()
        {
            // arrange
            const string fundingId1 = "1619-AY-2021-Contract-Provider-10017057-2_0";
            const string fundingId2 = "1619-AY-2021-Contract-Provider-10017057-3_0";
            const int pageNumber = 1;
            var fundingIds = new[] { fundingId1, fundingId2 };
            ClearFundingAllocation(fundingId1);
            ClearFundingAllocation(fundingId2);
            using var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            var crmEntityId1 = Guid.NewGuid();
            FundingAllocation fundingAllocation1 = new FundingAllocation(
                fundingId1, "", "", "",
                "", -1, pageNumber, -1, 1, readId)
            {
                FundingAllocationStatus = FundingAllocationStatus.InRelease,
                FundingAllocationSubStatus = FundingAllocationSubStatus.Queued,
                CrmEntityId = crmEntityId1
            };
            CreateFundingAllocation(fundingAllocation1);
            var crmEntityId2 = Guid.NewGuid();
            FundingAllocation fundingAllocation2 = new FundingAllocation(
                fundingId2, "", "", "",
                "", -1, pageNumber, -1, 1, readId)
            {
                FundingAllocationStatus = FundingAllocationStatus.InRelease,
                FundingAllocationSubStatus = FundingAllocationSubStatus.Queued,
                CrmEntityId = crmEntityId2
            };
            CreateFundingAllocation(fundingAllocation2);

            var repository = new Repositories.ReleaseGroupFundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var crmIds = repository.GetFundingAllocationCrmIds(fundingIds).Result;

            // assert
            crmIds.Should().Contain(new[] { crmEntityId1, crmEntityId2 });
        }

        private static DbContextOptions<FundingAllocationContext> GetContextOptions()
        {
            var connectionString = AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"];

            return new DbContextOptionsBuilder<FundingAllocationContext>()
                .UseSqlServer(new SqlConnection(connectionString))
                .Options;
        }

        private static void CreateFundingAllocation(FundingAllocation fundingAllocation, int? contractId = null)
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            fundingAllocation.ContractId = contractId;

            context.FundingAllocations.Add(fundingAllocation);

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

        private static void ClearProviderFundings()
        {
            using var context = new FundingAllocationContext(GetContextOptions());
            context.ProviderFundings.RemoveRange(context.ProviderFundings);

            context.SaveChanges();
        }

        private static void ClearFundingAllocation(string fundingId)
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            var readIds = context.FundingAllocations.Where(f => f.FundingId == fundingId).Select(f => f.ReadId)
                .ToList();
            
            readIds.ForEach(readId =>
            {
                context.FeedReads.Where(fr => fr.ReadId == readId).ToList()
                    .ForEach(fr => context.FeedReads.Remove(fr));
            });

            context.SaveChanges();
        }

        private static IReadOnlyCollection<FundingAllocation> GetFundingAllocationsForContractId(int contractId)
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            return context.FundingAllocations.Where(f => f.ContractId == contractId).ToList();
        }

        private static FundingAllocation GetFundingAllocation(string fundingId)
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            return context.FundingAllocations.Single(f => f.FundingId == fundingId);
        }

        private static IReadOnlyCollection<Contract> GetQueuedContracts()
        {
            using var context = new FundingAllocationContext(GetContextOptions());

            return context.Contracts.Where(c =>
                c.RelationshipToFundingAllocation == RelationshipToFundingAllocationEnum.Queued.ToString()).ToList();
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

        private DbContextOptions<FundingAllocationContext> DbContextOptions => new DbContextOptionsBuilder<FundingAllocationContext>()
            .UseSqlServer(new SqlConnection(AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"]))
            .Options;

    }
}
