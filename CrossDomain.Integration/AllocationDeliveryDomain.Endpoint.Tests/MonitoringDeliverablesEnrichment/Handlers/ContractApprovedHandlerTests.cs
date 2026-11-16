namespace AllocationDeliveryDomain.Endpoint.Tests.MonitoringDeliverablesEnrichment.Handlers
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.Endpoint;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using NServiceBus.Testing;
    using System.Linq;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class ContractApprovedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ContractApprovedEvent_ShouldRemoveAndStoreTheAllocationsIncludedInTheEvent()
        {
            // Arrange
            var message = CreateTestContract();

            var mockMonitoringDeliverableStore = new Mock<IMonitoringDeliverableStore>();
            var removeAllocationCallCount = 0;
            mockMonitoringDeliverableStore.Setup(x => x.RemoveAllocation(It.IsAny<allocationType>(), It.IsAny<ConnectionInfo>())).Callback(
                () => removeAllocationCallCount++);

            var storeAllocationCallCount = 0;
            mockMonitoringDeliverableStore.Setup(x => x.StoreAllocation(It.IsAny<allocationType>(), It.IsAny<ConnectionInfo>())).Callback(
                () => storeAllocationCallCount++);

            var handler = new ContractApprovedHandler()
            {
                Logger = Mock.Of<ILogger>(),
                Transformer = Mock.Of<IContractAllocationTransformer>(),
                Enrichment = Mock.Of<IMonitoringDeliverableEnrichment>(),
                Store = mockMonitoringDeliverableStore.Object,
                SessionConnectionFactory = Mock.Of<ISessionConnectionFactory>()
            };

            var context = new TestableMessageHandlerContext();
            context.MessageHeaders.Add(Headers.CorrelationId, "header1");

            // Act
            handler.Handle(message, context).Wait();

            // Assert
            Assert.AreEqual(1, removeAllocationCallCount, "Handle_ContractApprovedEvent didn't remove the allocation");
            Assert.AreEqual(1, storeAllocationCallCount, "Handle_ContractApprovedEvent didn't store the allocation");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ContractApprovedEvent_ShouldStoreDataForEsfAllocationsIncludedInTheEvent()
        {
            // Arrange
            var message = CreateTestEsfContract();

            var mockMonitoringDeliverableStore = new Mock<IMonitoringDeliverableStore>();
            var storeEsfAllocationCallCount = 0;
            mockMonitoringDeliverableStore.Setup(x => 
                x.StoreESFAllocation(It.IsAny<contractAllocationsContractAllocation>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Callback(() => storeEsfAllocationCallCount++);

            var handler = new ContractApprovedHandler()
            {
                Logger = Mock.Of<ILogger>(),
                Transformer = Mock.Of<IContractAllocationTransformer>(),
                Enrichment = Mock.Of<IMonitoringDeliverableEnrichment>(),
                Store = mockMonitoringDeliverableStore.Object,
                SessionConnectionFactory = Mock.Of<ISessionConnectionFactory>()
            };

            var context = new TestableMessageHandlerContext();
            context.MessageHeaders.Add(Headers.CorrelationId, "header1");

            // Act
            handler.Handle(message, context).Wait();

            // Assert
            Assert.AreEqual(1, storeEsfAllocationCallCount, "Handle_ContractApprovedEvent didn't store the ESF allocation");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ContractApprovedEvent_ShouldPublishTheAllocationsIncludedInTheEvent()
        {
            // Arrange
            var message = CreateTestContract();

            var mockMonitoringDeliverableStore = new Mock<IMonitoringDeliverableStore>();

            var handler = new ContractApprovedHandler()
            {
                Logger = Mock.Of<ILogger>(),
                Transformer = Mock.Of<IContractAllocationTransformer>(),
                Enrichment = Mock.Of<IMonitoringDeliverableEnrichment>(),
                Store = mockMonitoringDeliverableStore.Object,
                SessionConnectionFactory = Mock.Of<ISessionConnectionFactory>()
            };

            var context = new TestableMessageHandlerContext();
            context.MessageHeaders.Add(Headers.CorrelationId, "header1");

            // Act
            handler.Handle(message, context).Wait();

            // Assert
            Assert.AreEqual(1, context.PublishedMessages.Count(m => m.Message is AllocationDeliveryCommencedEvent), $"Incorrect number of AllocationDeliveryCommencedEvent messages published");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ContractApprovedEvent_ShouldNotProcessMessage_MultipleChildContracts()
        {
            // Arrange               
            var message = CreateTestContract();

            // Add extra child contract
            message.CorporateContract.contracts.Add(new contractType
            {
                contractNumber = "ADDITION_CHILD_CONTRACT",
                hierarchyType = hierarchyType.CONTRACT,
                contractAllocations = new List<contractAllocationsContractAllocation>()
                    {
                        new contractAllocationsContractAllocation
                        {
                                contractAllocationNumber = "CONTRACT_ALLOCATION_NUMBER_2"
                        }
                    }
            });

            var mockMonitoringDeliverableStore = new Mock<IMonitoringDeliverableStore>();
            var removeAllocationCallCount = 0;
            mockMonitoringDeliverableStore.Setup(x => x.RemoveAllocation(It.IsAny<allocationType>(), It.IsAny<ConnectionInfo>())).Callback(
                () => removeAllocationCallCount++);

            var storeAllocationCallCount = 0;
            mockMonitoringDeliverableStore.Setup(x => x.StoreAllocation(It.IsAny<allocationType>(), It.IsAny<ConnectionInfo>())).Callback(
                () => storeAllocationCallCount++);

            var handler = new ContractApprovedHandler()
            {
                Logger = Mock.Of<ILogger>(),
                Transformer = Mock.Of<IContractAllocationTransformer>(),
                Enrichment = Mock.Of<IMonitoringDeliverableEnrichment>(),
                Store = mockMonitoringDeliverableStore.Object,
                SessionConnectionFactory = Mock.Of<ISessionConnectionFactory>()
            };

            var context = new TestableMessageHandlerContext();
            context.MessageHeaders.Add(Headers.CorrelationId, "header1");

            // Act
            handler.Handle(message, context).Wait();

            // Assert 
            Assert.AreEqual(0, removeAllocationCallCount, "RemoveAllocation was incorrectly called");
            Assert.AreEqual(0, storeAllocationCallCount, "StoreAllocation was incorrectly called");
            Assert.AreEqual(0, context.PublishedMessages.Count(m => m.Message is AllocationDeliveryCommencedEvent), $"AllocationDeliveryCommencedEvent message was incorrectly published");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ContractApprovedEvent_ShouldNotProcessMessage_NoChildContracts()
        {
           // Arrange                
            var message = CreateTestContract();

            // Remove all child contracts
            message.CorporateContract.contracts.RemoveAll(c => true);

            var mockMonitoringDeliverableStore = new Mock<IMonitoringDeliverableStore>();
            var removeAllocationCallCount = 0;
            mockMonitoringDeliverableStore.Setup(x => x.RemoveAllocation(It.IsAny<allocationType>(), It.IsAny<ConnectionInfo>())).Callback(
                () => removeAllocationCallCount++);

            var storeAllocationCallCount = 0;
            mockMonitoringDeliverableStore.Setup(x => x.StoreAllocation(It.IsAny<allocationType>(), It.IsAny<ConnectionInfo>())).Callback(
                () => storeAllocationCallCount++);

            var handler = new ContractApprovedHandler()
            {
                Logger = Mock.Of<ILogger>(),
                Transformer = Mock.Of<IContractAllocationTransformer>(),
                Enrichment = Mock.Of<IMonitoringDeliverableEnrichment>(),
                Store = mockMonitoringDeliverableStore.Object,
                SessionConnectionFactory = Mock.Of<ISessionConnectionFactory>()
            };

            var context = new TestableMessageHandlerContext();
            context.MessageHeaders.Add(Headers.CorrelationId, "header1");

            // Act
            handler.Handle(message, context).Wait();

            // Assert 
            Assert.AreEqual(0, removeAllocationCallCount, "RemoveAllocation was incorrectly called");
            Assert.AreEqual(0, storeAllocationCallCount, "StoreAllocation was incorrectly called");
            Assert.AreEqual(0, context.PublishedMessages.Count(m => m.Message is AllocationDeliveryCommencedEvent), $"AllocationDeliveryCommencedEvent message was incorrectly published");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_ContractApprovedEvent_ShouldNotProcessMessage_NotMasterContract()
        {
            // Arrange
            var message = CreateTestContract();

            // Ensure parent contract is not a MASTER
            message.CorporateContract.hierarchyType = hierarchyType.CONTRACT;

            var mockMonitoringDeliverableStore = new Mock<IMonitoringDeliverableStore>();
            var removeAllocationCallCount = 0;
            mockMonitoringDeliverableStore.Setup(x => x.RemoveAllocation(It.IsAny<allocationType>(), It.IsAny<ConnectionInfo>())).Callback(
                () => removeAllocationCallCount++);

            var storeAllocationCallCount = 0;
            mockMonitoringDeliverableStore.Setup(x => x.StoreAllocation(It.IsAny<allocationType>(), It.IsAny<ConnectionInfo>())).Callback(
                () => storeAllocationCallCount++);

            var handler = new ContractApprovedHandler()
            {
                Logger = Mock.Of<ILogger>(),
                Transformer = Mock.Of<IContractAllocationTransformer>(),
                Enrichment = Mock.Of<IMonitoringDeliverableEnrichment>(),
                Store = mockMonitoringDeliverableStore.Object,
                SessionConnectionFactory = Mock.Of<ISessionConnectionFactory>()
            };

            var context = new TestableMessageHandlerContext();
            context.MessageHeaders.Add(Headers.CorrelationId, "header1");

            // Act
            handler.Handle(message, context).Wait();

            // Assert 
            Assert.AreEqual(0, removeAllocationCallCount, "RemoveAllocation was incorrectly called");
            Assert.AreEqual(0, storeAllocationCallCount, "StoreAllocation was incorrectly called");
            Assert.AreEqual(0, context.PublishedMessages.Count(m => m.Message is AllocationDeliveryCommencedEvent), $"AllocationDeliveryCommencedEvent message was incorrectly published");
        }

        private static ContractApprovedEvent CreateTestContract()
        {
            var testAllocation = new contractAllocationsContractAllocation
            {
                contractAllocationNumber = "CONTRACT_ALLOCATION_NUMBER_1"
            };

            var testContract = new contractType()
            {
                contractNumber = "CHILD_CONTRACT_1",
                hierarchyType = hierarchyType.CONTRACT,
                contractAllocations = new List<contractAllocationsContractAllocation>()
                    { testAllocation }
            };

            var message = new ContractApprovedEvent()
            {
                CorporateContract = new Contract()
                {
                    contractNumber = "MASTER_CONTRACT_NUMBER",
                    hierarchyType = hierarchyType.MASTERCONTRACT,
                    contracts = new List<contractType>()
                        {
                            testContract
                        }
                }
            };
            return message;
        }

        private static ContractApprovedEvent CreateTestEsfContract()
        {
            var testAllocation = new contractAllocationsContractAllocation
            {
                contractAllocationNumber = "CONTRACT_ALLOCATION_NUMBER_1"
            };

            var testContract = new contractType()
            {
                contractNumber = "CHILD_CONTRACT_1",
                hierarchyType = hierarchyType.CONTRACT,
                contractAllocations = new List<contractAllocationsContractAllocation>()
                    { testAllocation }
            };

            var message = new ContractApprovedEvent()
            {
                CorporateContract = new Contract()
                {
                    contractNumber = "MASTER_CONTRACT_NUMBER",
                    hierarchyType = hierarchyType.MASTERCONTRACT,

                    fundingType = new fundingType
                    {
                        fundingTypeCode = "ESF"
                    },
                    //contractAllocations = new List<contractAllocationsContractAllocation>
                    //{
                    //    new contractAllocationsContractAllocation
                    //    {
                    //        contractAllocationNumber = "ALLOC-01"
                    //    }
                    //},

                    contracts = new List<contractType>()
                    {
                        testContract
                    }
                }
            };
            return message;
        }
    }
}