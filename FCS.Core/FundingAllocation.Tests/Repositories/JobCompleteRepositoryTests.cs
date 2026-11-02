namespace FundingAllocation.Tests.Repositories
{
    using System;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestHelpers;
    using TestHelpers.Extensions;
    using static TestHelpers.FundingAllocationHelper;
    using static TestHelpers.DbOptionsFactory;

    [TestClass]
    public class JobCompleteRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void JobCompleteRepository_IsJobComplete_ShouldBeTrueWhenAllCrmEntityIdsAreSetAndStatusSubStatusesAreAllInContractControl()
        {
            // Arrange
            const int pageNumber = 1;
            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();

            var fundingAllocation1 = FundingAllocationWithFundingId("fundingId1")
                .WithStatus(FundingAllocationStatus.ContractApproved)
                .WithSubStatus(FundingAllocationSubStatus.ContractApproved)
                .WithCrmEntityId(Guid.NewGuid());

            var fundingAllocation2 = FundingAllocationWithFundingId("fundingId2")
                .WithStatus(FundingAllocationStatus.InRelease)
                .WithSubStatus(FundingAllocationSubStatus.Queued)
                .WithCrmEntityId(Guid.NewGuid());

            var fundingAllocation3 = FundingAllocationWithFundingId("fundingId3")
                .WithCrmEntityId(Guid.NewGuid()); // status is not set (null)

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));
            context.AddAllAndSave(
                fundingAllocation1.WithReadId(readId).WithPageNumber(pageNumber),
                fundingAllocation2.WithReadId(readId).WithPageNumber(pageNumber),
                fundingAllocation3.WithReadId(readId).WithPageNumber(pageNumber));

            var repository = new JobCompleteRepository(context);

            // Act
            var actualIsComplete = repository.IsJobComplete(readId).Result;

            // Assert
            actualIsComplete.Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void JobCompleteRepository_IsJobComplete_ShouldBeTrueWhenAllAllocationsNotYetInContractControl()
        {
            // Arrange
            const int pageNumber = 1;
            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();

            var fundingAllocation1 = FundingAllocationWithFundingId("fundingId1")
                .WithStatus(FundingAllocationStatus.Parked)
                .WithSubStatus(FundingAllocationSubStatus.AwaitingOutcome);

            var fundingAllocation2 = FundingAllocationWithFundingId("fundingId2")
                .WithStatus(FundingAllocationStatus.Discarded)
                .WithSubStatus(FundingAllocationSubStatus.Superseded);

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));

            context.AddAllAndSave(
                fundingAllocation1.WithReadId(readId).WithPageNumber(pageNumber),
                fundingAllocation2.WithReadId(readId).WithPageNumber(pageNumber));

            var repository = new JobCompleteRepository(context);

            // Act
            var actualIsComplete = repository.IsJobComplete(readId).Result;

            // Assert
            actualIsComplete.Should().BeTrue();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void JobCompleteRepository_IsJobComplete_ShouldBeFalseWhenCrmEntityNotSetAndAllocationsStateNotSet()
        {
            // Arrange
            const int pageNumber = 1;
            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();

            var fundingAllocation1 = FundingAllocationWithFundingId("fundingId1")
                .WithStatus(FundingAllocationStatus.NotSet)
                .WithPageNumber(pageNumber);

            var fundingAllocation2 = FundingAllocationWithFundingId("fundingId2")
                .WithStatus(FundingAllocationStatus.NotSet)
                .WithPageNumber(pageNumber);

            context.CreateFeedRead(out var readId)
                .AddAllAndSave(new FundingAllocationPageControl(readId, pageNumber));

            context.AddAllAndSave(
                fundingAllocation1.WithReadId(readId),
                fundingAllocation2.WithReadId(readId));

            var repository = new JobCompleteRepository(context);

            // Act
            var actualIsComplete = repository.IsJobComplete(readId).Result;

            // Assert
            actualIsComplete.Should().BeFalse();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void JobCompleteRepository_SetJobComplete_ShouldSetJobCompletedDate()
        {
            // Arrange
            var startDate = DateTime.UtcNow;
            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var feedReadId);

            var repository = new JobCompleteRepository(context);

            // Act
            repository.SetJobComplete(feedReadId).Wait();

            // Assert
            var actualFeedRead = new FundingAllocationContext(DbContextOptions)
                .FeedReads.First(fr => fr.ReadId == feedReadId);

            actualFeedRead.JobCompletedDate.Should().BeAfter(startDate);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void JobCompleteRepository_SetCfsReadComplete_ShouldSetCfsCompletedDate()
        {
            // Arrange
            var startDate = DateTime.UtcNow;
            var context = new FundingAllocationContext(DbContextOptions);

            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var feedReadId);

            var repository = new JobCompleteRepository(context);

            // Act
            repository.SetCfsReadComplete(feedReadId).Wait();

            // Assert
            var actualFeedRead = new FundingAllocationContext(DbContextOptions)
                .FeedReads.First(fr => fr.ReadId == feedReadId);

            actualFeedRead.CfsReadCompletedDate.Should().BeAfter(startDate);
            actualFeedRead.JobCompletedDate.Should().BeNull();
        }
    }
}