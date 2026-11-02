namespace FundingAllocation.Tests.Endpoints.PullFundingAllocation
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using FundingAllocation.Endpoints.PullFundingAllocation;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;
    using SFA.FCT.Framework.Logging.Interfaces;
    using TestHelpers.Extensions;
    using static TestHelpers.DbOptionsFactory;
    using static TestHelpers.FundingAllocationHelper;
    
    [TestClass]
    public class PullFundingAllocationsHandlerTests
    {
        [TestInitialize]
        public void TestInitialise()
        {
            using var context = new FundingAllocationContext(DbContextOptions);

            context.FundingAllocationPageControls.RemoveAll();
            context.RemoveAllContractsAndReferences();
            context.FeedReads.RemoveAll();
            context.SaveChanges();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PullFundingAllocationsHandler_ShouldNotAddAnotherFeedReadWhenPreviousJobNotComplete()
        {
            // Arrange
            var fundingNotificationApi = new Mock<IFundingNotificationApi>();

            var context = new FundingAllocationContext(DbContextOptions);
            context.CreateFeedRead(out var incompleteFeedReadId);

            var handler = new PullFundingAllocationsHandler(
                Mock.Of<ILogger>(),
                new FundingAllocationPageControlRepository(context),
                fundingNotificationApi.Object,
                new FeedReadRepository(context),
                new JobCompleteRepository(context));

            var messageHandlerContext = new TestableMessageHandlerContext();
            var command = new PullFundingAllocationsCommand();

            // Act
            handler.Handle(command, messageHandlerContext).Wait();

            // Assert
            var resultContext = new FundingAllocationContext(DbContextOptions);
            resultContext.FeedReads.Should().OnlyContain(fr => fr.ReadId == incompleteFeedReadId);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PullFundingAllocationsHandler_ShouldCompleteJobWhenNoNewData()
        {
            // Arrange
            var numberOfFundingAllocations = 11;
            var pageNumber = 55;

            var fundingNotificationApi = new Mock<IFundingNotificationApi>();

            var context = new FundingAllocationContext(DbContextOptions);

            context.CreateFeedRead(out var feedReadId, jobCompletedDate: DateTime.UtcNow);

            var fundingAllocations = Enumerable.Range(0, numberOfFundingAllocations)
                .Select(i => FundingAllocationWithFundingId($"fundingId{i}")
                    .WithReadId(feedReadId)
                    .WithPageNumber(pageNumber)).ToArray();

            context
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageNumber))
                .AddAllAndSave(fundingAllocations);

            var atomItems = Enumerable.Range(0, numberOfFundingAllocations)
                .Select(i => new AtomItem { PageNumber = pageNumber, FundingId = $"fundingId{i}" }).ToArray();

            fundingNotificationApi.Setup(api => api.GetLatestPageData())
                .Returns(Task.FromResult(new CfsLatestPageData(atomItems, pageNumber)));

            var handler = new PullFundingAllocationsHandler(
                Mock.Of<ILogger>(),
                new FundingAllocationPageControlRepository(context),
                fundingNotificationApi.Object,
                new FeedReadRepository(context),
                new JobCompleteRepository(context));

            var messageHandlerContext = new TestableMessageHandlerContext();
            var command = new PullFundingAllocationsCommand();

            var preJobComplete = DateTime.UtcNow;

            // Act
            handler.Handle(command, messageHandlerContext).Wait();

            // Assert
            var actualFeedRead = new FundingAllocationContext(DbContextOptions)
                .FeedReads.First(fr => fr.ReadId == feedReadId + 1);

            actualFeedRead.CfsReadCompletedDate.Should().BeAfter(preJobComplete);
            actualFeedRead.JobCompletedDate.Should().BeNull();

            var sentCommands = messageHandlerContext.SentMessages
                .Select(m => m.Message)
                .OfType<JobCompletedCommand>()
                .ToList();

            sentCommands.Count.Should().Be(1, "JobCompletedCommand should have been sent");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PullFundingAllocationsHandler_ShouldNotCompleteJobWhenNewDataToProcess()
        {
            // Arrange
            var numberOfExistingFundingAllocations = 7;
            var numberOfNewFundingAllocations = 9;
            var pageNumber = 55;

            var fundingNotificationApi = new Mock<IFundingNotificationApi>();

            var context = new FundingAllocationContext(DbContextOptions);

            context.CreateFeedRead(out var feedReadId, jobCompletedDate: DateTime.UtcNow);

            var fundingAllocations = Enumerable.Range(0, numberOfExistingFundingAllocations)
                .Select(i => FundingAllocationWithFundingId($"fundingId{i}")
                    .WithReadId(feedReadId)
                    .WithPageNumber(pageNumber)).ToArray();

            context
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageNumber))
                .AddAllAndSave(fundingAllocations);

            var atomItems = Enumerable.Range(0, numberOfExistingFundingAllocations + numberOfNewFundingAllocations)
                .Select(i => new AtomItem { PageNumber = pageNumber, FundingId = $"fundingId{i}" }).ToArray();

            fundingNotificationApi.Setup(api => api.GetLatestPageData())
                .Returns(Task.FromResult(new CfsLatestPageData(atomItems, pageNumber)));

            var handler = new PullFundingAllocationsHandler(
                Mock.Of<ILogger>(),
                new FundingAllocationPageControlRepository(context),
                fundingNotificationApi.Object,
                new FeedReadRepository(context),
                new JobCompleteRepository(context));

            var messageHandlerContext = new TestableMessageHandlerContext();
            var command = new PullFundingAllocationsCommand();

            // Act
            handler.Handle(command, messageHandlerContext).Wait();

            // Assert
            var resultContext = new FundingAllocationContext(DbContextOptions);
            var jobCompleteDate = resultContext.FeedReads.First(fr => fr.ReadId == feedReadId + 1).JobCompletedDate;
            jobCompleteDate.Should().BeNull();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PullFundingAllocationsHandler_ShouldSendGetFundingAllocationsPageCommandForEachNewPage()
        {
            // Arrange
            var numberOfLatestPageAllocations = 9;
            var numberOfNewPages = 3;
            var initialPageNumber = 55;
            var mostRecentPageNumber = initialPageNumber + numberOfNewPages;

            var fundingNotificationApi = new Mock<IFundingNotificationApi>();

            var context = new FundingAllocationContext(DbContextOptions);

            context
                .CreateFeedRead(out var feedReadId, jobCompletedDate: DateTime.UtcNow)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, initialPageNumber));

            var atomItems = Enumerable.Range(0, numberOfLatestPageAllocations)
                .Select(i => new AtomItem { PageNumber = mostRecentPageNumber, FundingId = $"fundingId{i}" }).ToArray();

            fundingNotificationApi.Setup(api => api.GetLatestPageData())
                .Returns(Task.FromResult(new CfsLatestPageData(atomItems, mostRecentPageNumber)));

            var handler = new PullFundingAllocationsHandler(
                Mock.Of<ILogger>(),
                new FundingAllocationPageControlRepository(context),
                fundingNotificationApi.Object,
                new FeedReadRepository(context),
                new JobCompleteRepository(context));

            var messageHandlerContext = new TestableMessageHandlerContext();
            var command = new PullFundingAllocationsCommand();

            // Act
            handler.Handle(command, messageHandlerContext).Wait();

            // Assert
            var messages = messageHandlerContext.SentMessages
                .Select(m => m.Message)
                .OfType<GetFundingAllocationsPageCommand>()
                .ToList();

            messages.Count.Should().Be(numberOfNewPages +1); // +1 is for current page

            Enumerable.Range(initialPageNumber, numberOfNewPages +1).ToList()
                .ForEach(i => messages.Should().Contain(m => m.PageNumber == i && m.ReadId == feedReadId +1));
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void PullFundingAllocationsHandler_ShouldAddPageControlForEachNewPage()
        {
            // Arrange
            var numberOfLatestPageAllocations = 9;
            var numberOfNewPages = 3;
            var initialPageNumber = 55;
            var mostRecentPageNumber = initialPageNumber + numberOfNewPages;

            var fundingNotificationApi = new Mock<IFundingNotificationApi>();

            var context = new FundingAllocationContext(DbContextOptions);

            context.CreateFeedRead(out var feedReadId, jobCompletedDate: DateTime.UtcNow)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, initialPageNumber));

            var atomItems = Enumerable.Range(0, numberOfLatestPageAllocations)
                .Select(i => new AtomItem { PageNumber = mostRecentPageNumber, FundingId = $"fundingId{i}" }).ToArray();

            fundingNotificationApi.Setup(api => api.GetLatestPageData())
                .Returns(Task.FromResult(new CfsLatestPageData(atomItems, mostRecentPageNumber)));

            var handler = new PullFundingAllocationsHandler(
                Mock.Of<ILogger>(),
                new FundingAllocationPageControlRepository(context),
                fundingNotificationApi.Object,
                new FeedReadRepository(context),
                new JobCompleteRepository(context));

            var messageHandlerContext = new TestableMessageHandlerContext();
            var command = new PullFundingAllocationsCommand();

            // Act
            handler.Handle(command, messageHandlerContext).Wait();

            // Assert
            var resultContext = new FundingAllocationContext(DbContextOptions);

            Enumerable.Range(initialPageNumber, numberOfNewPages + 1).ToList()
                .ForEach(i =>
                    resultContext.FundingAllocationPageControls.Should()
                        .Contain(p => p.PageNumber == i && p.ReadId == feedReadId + 1));
        }
    }
}
