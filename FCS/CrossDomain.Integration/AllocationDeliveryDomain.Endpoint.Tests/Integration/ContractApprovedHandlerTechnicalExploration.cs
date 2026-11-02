namespace AllocationDeliveryDomain.Endpoint.Tests.Integration
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using NServiceBus.Testing;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.Endpoint;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;

    [TestClass]
    public class ContractApprovedHandlerTechnicalExploration
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ContractApprovedHandler_ShouldSaveMD()
        {
            // Arrange
            var command = TestResource.FromJson<ContractApprovedEvent>("AllocationDeliveryDomain.Endpoint.Tests",
                "Resources.ContractApprovedEvent.json");

            Assert.IsNotNull(command.CorporateContract.contractNumber);

            ContractApprovedHandler handler = new ContractApprovedHandler
            {
                Logger = Mock.Of<ILogger>(),
                Enrichment = new MonitoringDeliverableEnrichment(new MonitoringDeliverablesDbContext()),
                Store = new MonitoringDeliverableStore(new MonitoringDeliverablesDbContext(), Mock.Of<ILogger>()),
                Transformer = new ContractAllocationTransformer
                {
                    Logger = Mock.Of<ILogger>()
                }
            };

            var context = new TestableMessageHandlerContext();
            context.MessageHeaders.Add(Headers.CorrelationId, "header1");

            // Act Assert
            handler.Handle(command, context).Wait();
        }
    }
}
