namespace AllocationDeliveryDomain.Endpoint.Tests.ActualsPullComplete
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Linq;
    using AllocationDelivery.Messages.Commands;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.ActualsPullComplete;
    using Endpoint.Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using NServiceBus.Testing;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CheckForCollectionReturnCompleteHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CheckForCollectionReturnComplete_ShouldResolve()
        {
            Mock<ILoggerFactory> loggerFactoryMock = new Mock<ILoggerFactory>();
            loggerFactoryMock.Setup(l => l.CreateLogger(It.IsAny<string>())).Returns(Mock.Of<ILogger>());

            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(loggerFactoryMock.Object))
                .Register(Component.For<CheckForCollectionReturnCompleteHandler>().ImplementedBy<CheckForCollectionReturnCompleteHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<CheckForCollectionReturnCompleteHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CheckForCollectionReturnComplete_ShouldSendTheCorrectNumberOfMessages()
        {
            // arrange
            Mock<IClosedCollectionCompleteRepository> mockClosedCollectionCompleteRepo = new Mock<IClosedCollectionCompleteRepository>();
            const string collectionType = "ALLF";
            const string collectionReturnCode = "A53";
            const int totalRowCount = 100;
            string[] orgs = new List<string>
            {
                "org1",
                "org2",
                "org3"
            }.ToArray();

            Mock<ISummarisedActualsQueryRepository> mockSummarisedActualsQueryRepo = new Mock<ISummarisedActualsQueryRepository>();
            mockSummarisedActualsQueryRepo
                .Setup(r => r.GetCountForCollectionReturn(collectionType, collectionReturnCode,
                    It.IsAny<ConnectionInfo>())).ReturnsAsync(totalRowCount);

            mockClosedCollectionCompleteRepo.Setup(a => a.Get(
                It.IsAny<IDbConnection>(),
                It.IsAny<IDbTransaction>(),
                collectionType, collectionReturnCode
            )).ReturnsAsync(
                new SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model.ClosedCollection(collectionType,
                    collectionReturnCode, DateTime.Now, totalRowCount)
                {
                    RetrievedRowCount = 0
                });
            mockClosedCollectionCompleteRepo.Setup(r => r.UpdateRowToCompletedIfNoOneElseHas(It.IsAny<IDbConnection>(),
                It.IsAny<IDbTransaction>(), collectionType, collectionReturnCode, It.IsAny<int>())).ReturnsAsync(1);

            mockSummarisedActualsQueryRepo
                .Setup(r => r.GetOrgFspGroups(collectionType, collectionReturnCode, It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new List<ActualOrgFspGroupKeyResult>
                {
                    new ActualOrgFspGroupKeyResult(orgs[0], "fsp1", null),
                    new ActualOrgFspGroupKeyResult(orgs[1], "fsp2", null),
                    new ActualOrgFspGroupKeyResult(orgs[2], "fsp3", "U")
                });

            Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();
            mockSessionConnectionFactory.Setup(cf => cf.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateDefault);

            CheckForCollectionReturnCompleteHandler handler = new CheckForCollectionReturnCompleteHandler(
                Mock.Of<ILogger>(),
                mockSessionConnectionFactory.Object,
                mockClosedCollectionCompleteRepo.Object,
                mockSummarisedActualsQueryRepo.Object);

            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new CheckForCollectionReturnCompleteCommand
            {
                CollectionType = collectionType,
                CollectionReturnCode = collectionReturnCode
            }, context).Wait();

            // assert
            var routingCommands = context.SentMessages.Select(sm => sm.Message).OfType<ReportedActualsRoutingCommand>().ToList();
            var numRoutingCommandsCount = routingCommands.Count;

            Assert.AreEqual(3, numRoutingCommandsCount, "The number of messages is incorrect");
            orgs.ToList().ForEach(o =>
            {
                var numMessagesForOrg1 =
                    routingCommands.Count(c => c.SummarisedActualOrgFspGroupKey.OrganisationId == o);
                Assert.AreEqual(1, numMessagesForOrg1, $"The number of messages for {o} is incorrect");
            });
        }
    }
}
