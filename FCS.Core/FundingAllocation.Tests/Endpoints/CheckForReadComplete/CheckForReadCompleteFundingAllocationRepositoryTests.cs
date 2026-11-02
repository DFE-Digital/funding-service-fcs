namespace FundingAllocation.Tests.Endpoints.CheckForReadComplete
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using Extensions;
    using FluentAssertions;
    using FluentAssertions.Extensions;
    using FundingAllocation.Endpoints.CheckForReadComplete;
    using FundingAllocation.Extensions;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestHelpers;
    using TestHelpers.Extensions;

    [TestClass]
    public class CheckForReadCompleteFundingAllocationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CheckForReadCompleteFundingAllocationRepository_GetNumParkedNotAwaitingOutcome_ShouldReturnCount()
        {
            // arrange
            var parkedFundingId1 = "1619-AY-2021-Contract-Provider-10014002-2_0";
            var parkedFundingId2 = "1619-AY-2021-Contract-Provider-10014003-2_0";
            var parkedAwaitingOutcomeFundingId = "1619-AY-2021-Contract-Provider-10014004-2_0";
            var pageNumber = 1;
            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var feedReadId)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageNumber))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(parkedFundingId1).WithReadId(feedReadId)
                        .WithPageNumber(pageNumber)
                        .WithStatusAndSubstatus(FundingAllocationStatus.Parked,
                            FundingAllocationSubStatus.AwaitingContractTypeConfig),
                    FundingAllocationHelper.FundingAllocationWithFundingId(parkedFundingId2).WithReadId(feedReadId)
                        .WithPageNumber(pageNumber)
                        .WithStatusAndSubstatus(FundingAllocationStatus.Parked,
                            FundingAllocationSubStatus.AwaitingFundingLineConfig),
                    FundingAllocationHelper.FundingAllocationWithFundingId(parkedAwaitingOutcomeFundingId).WithReadId(feedReadId)
                        .WithPageNumber(pageNumber)
                        .WithStatusAndSubstatus(FundingAllocationStatus.Parked,
                            FundingAllocationSubStatus.AwaitingOutcome));

            CheckForReadCompleteFundingAllocationRepository repository = new CheckForReadCompleteFundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            // act
            var numParkedNotAwaitingOutcome = repository.GetNumParkedNotAwaitingOutcome(feedReadId).Result;

            // assert
            numParkedNotAwaitingOutcome.Should().Be(2);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CheckForReadCompleteFundingAllocationRepository_SetToDiscardedSupersededWhereParked_ShouldSetFAsOnOtherReadIds()
        {
            // arrange
            var parkedFundingId1 = "1619-AY-2021-Contract-Provider-10014002-2_0";
            var parkedFundingId2InContractControl = "1619-AY-2021-Contract-Provider-10014003-2_0";
            var parkedFundingId5Approved = "1619-AY-2021-Contract-Provider-10014003-1_9";
            var parkedFundingId3 = "1619-AY-2021-Contract-Provider-10014002-2_1";
            var parkedFundingId4 = "1619-AY-2021-Contract-Provider-10014003-2_1";
            var pageNumber = 1;
            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var feedReadId)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageNumber))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(parkedFundingId1).WithReadId(feedReadId)
                        .WithPageNumber(pageNumber)
                        .WithStatusAndSubstatus(FundingAllocationStatus.Parked,
                            FundingAllocationSubStatus.AwaitingContractTypeConfig),
                    FundingAllocationHelper.FundingAllocationWithFundingId(parkedFundingId2InContractControl).WithReadId(feedReadId)
                        .WithPageNumber(pageNumber)
                        .WithStatusAndSubstatus(FundingAllocationStatus.NotSet,
                            FundingAllocationSubStatus.NotSet),
                    FundingAllocationHelper.FundingAllocationWithFundingId(parkedFundingId5Approved).WithReadId(feedReadId)
                        .WithPageNumber(pageNumber)
                        .WithStatusAndSubstatus(FundingAllocationStatus.ContractApproved,
                            FundingAllocationSubStatus.ContractApproved));

            context.CreateFeedRead(out var feedReadId2)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId2, pageNumber))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(parkedFundingId3).WithReadId(feedReadId2)
                        .WithPageNumber(pageNumber)
                        .WithStatusAndSubstatus(FundingAllocationStatus.Parked,
                            FundingAllocationSubStatus.AwaitingContractTypeConfig),
                    FundingAllocationHelper.FundingAllocationWithFundingId(parkedFundingId4).WithReadId(feedReadId2)
                        .WithPageNumber(pageNumber)
                        .WithStatusAndSubstatus(FundingAllocationStatus.Parked,
                            FundingAllocationSubStatus.AwaitingFundingLineConfig));

            CheckForReadCompleteFundingAllocationRepository repository = new CheckForReadCompleteFundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            var latestRead = new List<string> {parkedFundingId3, parkedFundingId4};
            var fundingNames = latestRead.Select(fId => fId.RemoveVersionFromId()).ToList();

            // act
            repository.SetToDiscardedSupersededWhereParked(fundingNames, feedReadId2).Wait();

            // assert
            var fundingAllocations = GetFundingAllocations();

            fundingAllocations.Count.Should().Be(5);
            var fundingAllocation1 = fundingAllocations.Single(fa => fa.FundingId == parkedFundingId1);
            fundingAllocation1.Status.Should().Be(FundingAllocationStatus.Discarded.ToString());
            fundingAllocation1.SubStatus.Should().Be(FundingAllocationSubStatus.Superseded.ToString());
            var fundingAllocation2InContractControl = fundingAllocations.Single(fa => fa.FundingId == parkedFundingId2InContractControl);
            fundingAllocation2InContractControl.Status.Should().Be(null);
            fundingAllocation2InContractControl.SubStatus.Should().Be(null);
            var fundingAllocation3 = fundingAllocations.Single(fa => fa.FundingId == parkedFundingId3);
            fundingAllocation3.Status.Should().Be(FundingAllocationStatus.Parked.ToString());
            fundingAllocation3.SubStatus.Should().Be(FundingAllocationSubStatus.AwaitingContractTypeConfig.ToString());
            var fundingAllocation4 = fundingAllocations.Single(fa => fa.FundingId == parkedFundingId4);
            fundingAllocation4.Status.Should().Be(FundingAllocationStatus.Parked.ToString());
            fundingAllocation4.SubStatus.Should().Be(FundingAllocationSubStatus.AwaitingFundingLineConfig.ToString());
            var fundingAllocation5Approved = fundingAllocations.Single(fa => fa.FundingId == parkedFundingId5Approved);
            fundingAllocation5Approved.Status.Should().Be(FundingAllocationStatus.ContractApproved.ToString());
            fundingAllocation5Approved.SubStatus.Should().Be(FundingAllocationSubStatus.ContractApproved.ToString());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CheckForReadCompleteFundingAllocationRepository_UpdateParkingInfoForDiscarded_ShouldSetFAsOnOtherReadIds()
        {
            // arrange
            var FundingId1 = "1619-AY-2021-Contract-Provider-10014002-2_0";
            var discardedFundingId = "1619-AY-2021-Contract-Provider-10014003-2_0";
            var latestFundingId = "1619-AY-2021-Contract-Provider-10014003-2_1";

            var pageNumber = 1;
            var context = new FundingAllocationContext(DbContextOptions);
            DateTime now = DateTime.Now.AsUtc();

            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var feedReadId)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageNumber))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(discardedFundingId).WithReadId(feedReadId)
                        .WithPageNumber(pageNumber)
                        .WithStatusAndSubstatus(FundingAllocationStatus.Discarded,
                            FundingAllocationSubStatus.NonMaterialUpdate),
                    FundingAllocationHelper.FundingAllocationWithFundingId(FundingId1).WithReadId(feedReadId)
                        .WithPageNumber(pageNumber)
                        .WithStatusAndSubstatus(FundingAllocationStatus.NotSet,
                            FundingAllocationSubStatus.NotSet));

            context.CreateFeedRead(out var feedReadId2)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId2, pageNumber))
                .AddAllAndSave(
                    FundingAllocationHelper.FundingAllocationWithFundingId(latestFundingId).WithReadId(feedReadId2)
                        .WithPageNumber(pageNumber)
                        .WithStatusAndSubstatus(FundingAllocationStatus.NotSet,
                            FundingAllocationSubStatus.NotSet));
            context.ParkingAndDiscardedInfos.Add(new ParkingAndDiscardedInfo
            {
                FundingAllocationId = discardedFundingId,
                LastParked = now.AddDays(-1)
            });
            context.SaveChanges();

            CheckForReadCompleteFundingAllocationRepository repository = new CheckForReadCompleteFundingAllocationRepository(new FundingAllocationContext(DbContextOptions));

            var latestRead = new List<string> { discardedFundingId };
            var fundingNames = latestRead.Select(fId => fId.RemoveVersionFromId()).ToList();

            // act
            repository.UpdateParkingInfoForDiscarded(fundingNames, feedReadId2, now).Wait();

            // assert
            var parkingInfos = GetParkingInfos();

            parkingInfos.Count.Should().Be(1);
            parkingInfos.Single().LastDiscarded.AreEqualIgnoreMilliseconds(now).Should().BeTrue();
        }

        private IReadOnlyCollection<FundingAllocation> GetFundingAllocations()
        {
            using var context = new FundingAllocationContext(DbContextOptions);

            return context.FundingAllocations.ToList();
        }

        private IReadOnlyCollection<ParkingAndDiscardedInfo> GetParkingInfos()
        {
            using var context = new FundingAllocationContext(DbContextOptions);

            return context.ParkingAndDiscardedInfos.ToList();
        }

        private DbContextOptions<FundingAllocationContext> DbContextOptions => new DbContextOptionsBuilder<FundingAllocationContext>()
            .UseSqlServer(new SqlConnection(AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"]))
            .Options;
    }
}
