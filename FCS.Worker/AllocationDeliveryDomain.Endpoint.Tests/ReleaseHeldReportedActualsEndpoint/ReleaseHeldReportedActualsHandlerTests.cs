namespace AllocationDeliveryDomain.Endpoint.Tests.ReleaseHeldReportedActualsEndpoint
{
    using AllocationDelivery.Messages.Commands;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.ReleaseHeldReportedActualsEndpoint;
    using Endpoint.ReleaseHeldReportedActualsEndpoint.Handlers;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using NServiceBus.Testing;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Dto;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.Commands;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Collections.Generic;
    using System.Linq;

    [TestClass]
    public class ReleaseHeldReportedActualsHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ReleaseHeldReportedActualsHandler_ShouldResolveAllDependenciesFromEndpointContainer()
        {
            // arrange
            var container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ReleaseHeldReportedActualsHandler>().ImplementedBy<ReleaseHeldReportedActualsHandler>())
                .Register(Component.For<SFA.FCT.CrossDomain.Integration.Common.Storage.IAzureTableStore>().Instance(Mock.Of<SFA.FCT.CrossDomain.Integration.Common.Storage.IAzureTableStore>()).IsDefault());

            container.BeginScope();
      
            // act, assert
            container.Resolve<ReleaseHeldReportedActualsHandler>();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ReleaseHeldReportedActualsHandler_ShouldSendReportedActualsLoadedCommandWithIncludingSummarisedActualOrgFspGroupKeys()
        {
            // arrange
            const string partitionKey1 = "partitionKey1";
            const string partitionKey2 = "partitionKey2";
            const string partitionKey9 = "partitionKey9";
            const string fsp1 = "fsp1";
            const string fsp9 = "fsp9";

            var heldPartitionKeyQueryServiceMock = new Mock<IHeldPartitionKeyQueryService>();
            heldPartitionKeyQueryServiceMock.Setup(m => 
                    m.GetPartitionKeyGroups(It.IsAny<ConnectionInfo>()))
                .Returns(new List<HeldActualsForAllocationGrpIdentifier> 
                    { new HeldActualsForAllocationGrpIdentifier(new List<string> { partitionKey1, partitionKey2 }, fsp1) });

            ClearDownAllHeldReportedActualGroupsItems();

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var heldReportedActualGroupRepository = new HeldReportedActualGroupRepository();

                heldReportedActualGroupRepository.Add(new HeldReportedActualGroup(
                    partitionKey: partitionKey1,
                    fundingStreamPeriodCode: fsp1,
                    organisationIdentifier: "random",
                    uoPCode: "random",
                    collectionType: "random",
                    collectionReturnCode: "random"), ConnectionInfo.CreateFrom(context.Database.Connection));

                heldReportedActualGroupRepository.Add(new HeldReportedActualGroup(
                    partitionKey: partitionKey2,
                    fundingStreamPeriodCode: fsp1,
                    organisationIdentifier: "random",
                    uoPCode: "random",
                    collectionType: "random",
                    collectionReturnCode: "random"), ConnectionInfo.CreateFrom(context.Database.Connection));

                heldReportedActualGroupRepository.Add(new HeldReportedActualGroup(
                    partitionKey: partitionKey9,
                    fundingStreamPeriodCode: fsp9,
                    organisationIdentifier: "random",
                    uoPCode: "random",
                    collectionType: "random",
                    collectionReturnCode: "random"), ConnectionInfo.CreateFrom(context.Database.Connection));

                context.SaveChanges();
            }

            using (var context = new MonitoringDeliverablesDbContext())
            {
                var sessionFactoryMock = new Mock<ISessionConnectionFactory>();
                sessionFactoryMock.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, context.Database.Connection));
                
                var heldReportedActualGroupRepository = new HeldReportedActualGroupRepository();

                var handler = new ReleaseHeldReportedActualsHandler(
                    Mock.Of<ILogger>(),
                    heldPartitionKeyQueryServiceMock.Object,
                    sessionFactoryMock.Object,
                    Mock.Of<IHeldReportedActualGroupCommandRepository>(),
                    heldReportedActualGroupRepository);

                var testableContext = new TestableMessageHandlerContext();
                
                // act
                handler.Handle(message: new ReleaseHeldReportedActualsCommand(), context: testableContext).Wait();

                // assert
                Assert.AreEqual(1, testableContext.SentMessages.Length, "Unexpected number of messages sent");
                Assert.AreEqual(1, testableContext.SentMessages.Count(m => m.Message is ReportedActualsLoadedCommand), 
                    $"Unexpected number of {nameof(ReportedActualsLoadedCommand)} messages sent");

                var assertReportedActualsLoadedCommand = testableContext.SentMessages[0].Message as ReportedActualsLoadedCommand;

                Assert.IsTrue(assertReportedActualsLoadedCommand.FundingStreamPeriodCode == fsp1 ,
                    "FundingStreamPeriodCode held in the sent ReportedActualsLoadedCommand was incorrect");

                var assertGroupKeys = 
                    assertReportedActualsLoadedCommand.SummarisedActualOrgFspGroupKeys
                        .Where(gk => gk.FundingStreamPeriodCode == fsp1);

                Assert.AreEqual(2, assertGroupKeys.Count(), 
                    "Incorrect number of groupKeys in ReportedActualsLoadedCommand message");
            }
        }

        private static void ClearDownAllHeldReportedActualGroupsItems()
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.HeldReportedActualGroups.ToList()
                    .ForEach(h => context.HeldReportedActualGroups.Remove(h));

                context.SaveChanges();
            }
        }
    }
}
