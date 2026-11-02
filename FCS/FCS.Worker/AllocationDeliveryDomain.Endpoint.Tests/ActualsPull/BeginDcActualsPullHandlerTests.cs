namespace AllocationDeliveryDomain.Endpoint.Tests.ActualsPull
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using AllocationDelivery.Messages.Commands;
    using AllocationDelivery.Messages.DTOs;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.ActualsPull;
    using Endpoint.ActualsPull.Adapters;
    using Endpoint.ActualsPull.Handlers;
    using Endpoint.Infrastructure;
    using Endpoint.Repositories;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class BeginDcActualsPullHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void BeginDcActualsPullHandler_ShouldResolve()
        {
            ConfigurationManager.AppSettings["DCT:UseStub"] = "false";
            
            Mock<ILoggerFactory> loggerFactoryMock = new Mock<ILoggerFactory>();
            loggerFactoryMock.Setup(l => l.CreateLogger(It.IsAny<string>())).Returns(Mock.Of<ILogger>());

            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(loggerFactoryMock.Object))
                .Register(Component.For<BeginDcActualsPullHandler>().ImplementedBy<BeginDcActualsPullHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<BeginDcActualsPullHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void BeginDcActualsPullHandler_ShouldSendCorrectNumberOfMessages()
        {
            // arrange
            Mock<IDcAdapter> mockAdapter = new Mock<IDcAdapter>();
            const int allfRowCount = 152;
            const int appsRowCount = 5032;
            var closedCollections = new List<ClosedCollection>
            {
                new ClosedCollection
                {
                    CollectionType = "ALLF",
                    CollectionReturnCode = "A53",
                    TotalRowCount = allfRowCount
                },
                new ClosedCollection
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS32",
                    TotalRowCount = appsRowCount
                }
            };
            mockAdapter.Setup(a => a.GetClosedCollectionsSince(It.IsAny<DateTime>())).ReturnsAsync(closedCollections);

            Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();
            mockSessionConnectionFactory.Setup(cf => cf.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateDefault);

            BeginDcActualsPullHandler handler = new BeginDcActualsPullHandler(
                Mock.Of<ILogger>(),
                mockAdapter.Object,
                mockSessionConnectionFactory.Object,
                Mock.Of<IClosedCollectionRepository>(),
                Mock.Of<IMonthEndStartRepository>());
            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new BeginDcActualsPullCommand(), context).Wait();

            // assert
            var pullClosedCollectionPageCommands = context.SentMessages.Select(sm => sm.Message).OfType<PullClosedCollectionPageCommand>().ToList();
            var monthEndCompletionCommands = context.SentMessages.Select(sm => sm.Message).OfType<CheckForMonthEndCompletionCommand>().ToList();

            var totalSummedPages = closedCollections.Sum(cc => mockAdapter.Object.GetNumPages(cc.TotalRowCount, BeginDcActualsPullHandler.PageSize));

            Assert.AreEqual(totalSummedPages, pullClosedCollectionPageCommands.Count, "The number of messages ");
            var numAllf = pullClosedCollectionPageCommands.Count(c => c.CollectionType == "ALLF");
            var expectedAllfPages = mockAdapter.Object.GetNumPages(allfRowCount, BeginDcActualsPullHandler.PageSize);
            Assert.AreEqual(expectedAllfPages, numAllf, "The number of ALLF pages is not correct");
            var numApps = pullClosedCollectionPageCommands.Count(c => c.CollectionType == "APPS");
            var expectedAppsPages = mockAdapter.Object.GetNumPages(appsRowCount, BeginDcActualsPullHandler.PageSize);
            Assert.AreEqual(expectedAppsPages, numApps, "The number of APPS pages is not correct");
            Assert.AreEqual(1, monthEndCompletionCommands.Count, "We should send out a CheckForMonthEndCompletionCommand");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void BeginDcActualsPullHandler_ShouldUseConfigDefinedPageSize()
        {
            const int expectedPageSize = 101;

            // arrange
            ConfigurationManager.AppSettings["DCT:PageSize"] = expectedPageSize.ToString();

            // act
            int actualPageSize = BeginDcActualsPullHandler.PageSize;

            // assert
            Assert.AreEqual(expectedPageSize, actualPageSize);
        }
    }
}
