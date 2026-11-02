namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System.Linq;
    using System.Collections.Generic;
    using AllocationDelivery.Messages.Commands;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using Castle.MicroKernel.Registration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.CrossDomain.Integration.Events;
    using UnitTests.Common;

    [TestClass]
    public class ActualsVerificationInvalidPeriod : ActualsVerificationTestBase
    {
        protected override List<ReportedActual> CreateReportedActuals()
        {
            var reportedActuals = new List<ReportedActual>();

            reportedActuals.Add(new ReportedActual()
            {
                CollectionType = "aa",

                OrganisationId = "ORG1231231",

                ActualValue = 10.01,
                ActualVolume = 11,

                ContractAllocationNumber = "ALLOC-001",
                Period = "202001",
                DeliverableCode = "2",
                UoPCode = string.Empty,
                CollectionReturnCode = "X",
                FundingStreamPeriodCode = "16-18APPS1516",
            });

            return reportedActuals;
        }

        //[TestMethod, TestCategory("IntegrationTest")]
        //public void InvalidActuals_ShouldNotBeIncludedInPublishedResults()
        //{
        //    var messageId = "ActualsVerificationInvalidPeriod";

        //    CleanupProcessedMessage(messageId);

        //    var primaryReportedActualItem = _reportedActuals.FirstOrDefault();

        //    var busMock = new Mock<IBus>();
        //    busMock.Setup(b => b.Publish(It.IsAny<IAllocationActualsVerified>())).Verifiable();

        //    var messageContextMock = new Mock<IMessageContext>();
        //    messageContextMock.SetupGet(x => x.Id).Returns(messageId);
        //    busMock.SetupGet(x => x.CurrentMessageContext).Returns(messageContextMock.Object);

        //    var container = CreateContainer();
        //    container.Register(Component.For<IBus>().Instance(busMock.Object));

        //    var handler = container.Resolve<IHandleMessages<ReportedActualsLoadedCommand>>();
        //    var msg = new ReportedActualsLoadedCommand
        //    {
        //        PartitionKeys = new[] { primaryReportedActualItem.EntityPartitionKey },
        //        FundingStreamPeriodCode = primaryReportedActualItem.FundingStreamPeriodCode
        //    };
        //    handler.Handle(msg);

        //    busMock.Verify(b => b.Publish(It.IsAny<IAllocationActualsVerified>()), Times.Never());
        //}

        //private static void CleanupProcessedMessage(string messageId)
        //{
        //    using (var allocationDeliveryDbContext = new AllocationDeliveryDbContext())
        //    {
        //        allocationDeliveryDbContext.ProcessedMessages.RemoveWhere(m => m.MessageId == messageId);
        //        allocationDeliveryDbContext.SaveChanges();
        //    }
        //}
    }
}
