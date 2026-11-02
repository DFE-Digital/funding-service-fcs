namespace FundingAllocation.Tests.Endpoints.CheckForMissingProvidersPostReadComplete
{
    using System;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Endpoints.CheckForMissingProvidersComplete.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestHelpers.Extensions;
    using static TestHelpers.FundingAllocationHelper;
    using static TestHelpers.DbOptionsFactory;

    [TestClass]
    public class PostReadCompleteRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void PostReadCompleteRepository_IsPostReadMissingProviderCheckComplete_ShouldReturnTrueWhenThereArentAnyProviderChecksStillGoingOn()
        {
            // arrange
            const int pageNumber = 1;
            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();

            var fundingAllocation1 = FundingAllocationWithFundingId("1619-AS-2122-Contracting-LocalAuthority-10000896-2_0")
                .WithStatus(FundingAllocationStatus.Parked)
                .WithSubStatus(FundingAllocationSubStatus.AwaitingOutcome);

            var fundingAllocation2 = FundingAllocationWithFundingId("1619-AS-2122-Contracting-LocalAuthority-10000901-2_0")
                .WithStatus(FundingAllocationStatus.InRelease)
                .WithSubStatus(FundingAllocationSubStatus.Queued)
                .WithCrmEntityId(Guid.NewGuid());

            var fundingAllocation3 = FundingAllocationWithFundingId("1619-AS-2122-Contracting-LocalAuthority-10000903-1_1")
                .WithCrmEntityId(Guid.NewGuid());

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            context.AddAllAndSave(
                fundingAllocation1.WithReadId(readId).WithPageNumber(pageNumber),
                fundingAllocation2.WithReadId(readId).WithPageNumber(pageNumber),
                fundingAllocation3.WithReadId(readId).WithPageNumber(pageNumber));

            context.CreateFeedRead(out var latestReadId)
                .AddAllAndSave(new FundingAllocationPageControl(latestReadId, pageNumber));

            // act
            var isProviderCheckComplete = new PostReadCompleteRepository(new FundingAllocationContext(DbContextOptions))
                .IsPostReadMissingProviderCheckComplete().Result;

            // assert
            isProviderCheckComplete.Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PostReadCompleteRepository_IsPostReadMissingProviderCheckComplete_ShouldReturnFalseWhenThereAreProviderChecksStillGoingOn()
        {
            // arrange
            const int pageNumber = 1;
            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();

            var fundingAllocation1 = FundingAllocationWithFundingId("1619-AS-2122-Contracting-LocalAuthority-10000896-2_0")
                .WithStatus(FundingAllocationStatus.ParkedPending)
                .WithSubStatus(FundingAllocationSubStatus.ProviderCheck);

            var fundingAllocation2 = FundingAllocationWithFundingId("1619-AS-2122-Contracting-LocalAuthority-10000901-2_0")
                .WithStatus(FundingAllocationStatus.InRelease)
                .WithSubStatus(FundingAllocationSubStatus.Queued)
                .WithCrmEntityId(Guid.NewGuid());

            var fundingAllocation3 = FundingAllocationWithFundingId("1619-AS-2122-Contracting-LocalAuthority-10000903-1_1")
                .WithCrmEntityId(Guid.NewGuid());

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            context.AddAllAndSave(
                fundingAllocation1.WithReadId(readId).WithPageNumber(pageNumber),
                fundingAllocation2.WithReadId(readId).WithPageNumber(pageNumber),
                fundingAllocation3.WithReadId(readId).WithPageNumber(pageNumber));

            context.CreateFeedRead(out var latestReadId)
                .AddAllAndSave(new FundingAllocationPageControl(latestReadId, pageNumber));

            // act
            var isProviderCheckComplete = new PostReadCompleteRepository(new FundingAllocationContext(DbContextOptions))
                .IsPostReadMissingProviderCheckComplete().Result;

            // assert
            isProviderCheckComplete.Should().BeFalse();
        }
    }
}
