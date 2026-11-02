namespace AllocationDeliveryDomain.Endpoint.Tests.ContractUnderTerminationEndpoint
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint;
    using AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint.Repositories;
    using AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint.Services;
    using Endpoint.Infrastructure;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractTermination;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class ContractPlacedUnderTerminationHandlerTechnicalExploration
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ContractPlacedUnderTerminationHandler_ShouldWork()
        {
            // arrange
            var published = new List<AllocationActualsUpdated>();

            Action<AllocationActualsUpdated> act = message => published.Add(message);

            var contextMock = new Mock<IMessageHandlerContext>();
            //contextMock.Setup(m => m.Publish(It.IsAny<AllocationActualsUpdated>()))
            //    .Callback(act);

            var fspRepoMock = new Mock<IFundingStreamPeriodRepository>();
            fspRepoMock.Setup(m => m.GetFundingStreamPeriod(It.IsAny<ConnectionInfo>(), It.IsAny<string>()))
                .Returns(Task.FromResult(new FundingStreamPeriod()));

            var dateMock = new Mock<IDate>();
            dateMock.Setup(m => m.GetCalculationDate()).Returns(DateTime.Now);

            var actualsMock = new Mock<IAllocationDeliverablePeriodActualAuditRepository>();
            actualsMock.Setup(m => m.GetLatestCollectionReturn(It.IsAny<ConnectionInfo>(), It.IsAny<string>()))
                .Returns(Task.FromResult(GetActuals()));

            using (var context = new MonitoringDeliverablesDbContext())
            {
                Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();
                mockSessionConnectionFactory.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, context.Database.Connection));

                ContractPlacedUnderTerminationHandler handler = new ContractPlacedUnderTerminationHandler(
                    new SimpleConsoleLogger(),
                    new AllocationUnderTerminationRepository(),
                    mockSessionConnectionFactory.Object,
                    new ZeroiseActualsService(
                        fspRepoMock.Object,
                        actualsMock.Object,
                        dateMock.Object));

                handler.Handle(new ContractPlacedUnderTerminationForApproveInitiationEvent()
                {
                    ContractNumber = "MAIN-413",
                    SubVersionNumber = 0,
                    TerminationAllocations = new List<TerminationAllocation>
                    {
                        new TerminationAllocation("16AP-414", "16-18APPS1516", DateTime.Now)
                    },
                    VersionNumber = 2
                }, contextMock.Object).Wait();

                contextMock.Verify(m => m.Publish(It.IsAny<AllocationActualsUpdated>()), Times.AtLeast(3));
                //Assert.AreNotEqual(0, published.Count);
            }
        }

        private IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> GetActuals()
        {
            return Enumerable.Range(1, 12).SelectMany(i =>
                Enumerable.Range(1, 12).Select(j =>
                    new AllocationDeliverablePeriodActualAudit
                    {
                        ActualVolume = 50,
                        ActualValue = 5000,
                        Period = $"2018{j:D2}",
                        CollectionReturnPeriod = int.Parse($"2018{i:D2}")
                    })).ToList();
        }
    }
}
