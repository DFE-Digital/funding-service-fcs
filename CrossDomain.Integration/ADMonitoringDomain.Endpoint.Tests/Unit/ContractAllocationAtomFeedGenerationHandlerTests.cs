namespace ADMonitoringDomain.Endpoint.Tests.Unit
{
    extern alias Entities;
    using BusinessLogic;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using AllocationActuals = Entities::SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using CorporatePaymentAggregation = Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using EntityData = Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ContractAllocationAtomFeedGenerationHandlerTests
    {
        #region Handle_IPaymentAggregatedEvent

        [TestMethod,TestCategory("UnitTest")]
        public void Handle_IPaymentAggregatedEvent_ShouldGenerateFeed_WhenContractAllocationActualsReceived()
        {
            var loggerMock = new Mock<ILogger>();

            var engineMock = new Mock<IRulesEngine>();
            engineMock.Setup(x => x.EvaluateRule(
                RulesEngine.RuleName.ContractAllocationActualsReceived,
                RulesEngine.EventName.PaymentAggregated,
                "A101",
                1)
                ).Returns(true);

            var generatorMock = new Mock<IAtomGenerator>();
            
            var message = new PaymentAggregatedEvent();
            var allocation = new CorporatePaymentAggregation.Allocation
            {
                AllocationNumber = "A101",
                VersionNumber = 1
            };
            message.Allocation = allocation;
            message.PaymentEventOrigin = PaymentEventOrigin.AllocationActualsVerified;
            var storeMock = new Mock<IADMonitoringDeliveryEventStore>();

            var handler = new ContractAllocationsAtomFeedGenerationHandler(
                engineMock.Object,
                generatorMock.Object,
                storeMock.Object,
                Mock.Of<ISessionConnectionFactory>())
            {
                Logger = loggerMock.Object
            };
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            generatorMock.Verify(x => x.GenerateAtomFeed("A101", 1, AllocationDeliveryEntryCategory.ContractAllocationActualsReceived, It.IsAny<EntityData.ConnectionInfo>()), Times.Once(),
                "Handle_IPaymentAggregatedEvent did not generate the feed when ContractAllocationActuals Received");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_IPaymentAggregatedEvent_ShouldGenerateFeed_WhenContractAllocationActualsUpdated()
        {
            var loggerMock = new Mock<ILogger>();

            var engineMock = new Mock<IRulesEngine>();
            engineMock.Setup(x => x.EvaluateRule(
                RulesEngine.RuleName.ContractAllocationActualsReceived,
                RulesEngine.EventName.PaymentAggregated,
                "A101",
                1)
            ).Returns(true);

            var generatorMock = new Mock<IAtomGenerator>();

            var message = new PaymentAggregatedEvent();
            var allocation = new CorporatePaymentAggregation.Allocation
            {
                AllocationNumber = "A101",
                VersionNumber = 1
            };
            message.Allocation = allocation;
            message.PaymentEventOrigin = PaymentEventOrigin.AllocationActualsUpdated;
            var storeMock = new Mock<IADMonitoringDeliveryEventStore>();

            var handler = new ContractAllocationsAtomFeedGenerationHandler(
                engineMock.Object,
                generatorMock.Object,
                storeMock.Object,
                Mock.Of<ISessionConnectionFactory>())
            {
                Logger = loggerMock.Object
            };
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            generatorMock.Verify(x => x.GenerateAtomFeed("A101", 1, AllocationDeliveryEntryCategory.ContractAllocationActualsUpdated, It.IsAny<EntityData.ConnectionInfo>()), Times.Once(),
                "Handle_IPaymentAggregatedEvent did not generate the feed when ContractAllocationActuals Updated");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_IPaymentAggregatedEvent_ShouldNotGenerateFeed_WhenContractAllocationActualsNotReceived()
        {
            var loggerMock = new Mock<ILogger>();

            var engineMock = new Mock<IRulesEngine>();
            engineMock.Setup(x => x.EvaluateRule(
                RulesEngine.RuleName.ContractAllocationActualsReceived,
                RulesEngine.EventName.PaymentAggregated,
                "A101",
                1)
                ).Returns(false);

            var generatorMock = new Mock<IAtomGenerator>();

            var message = new PaymentAggregatedEvent();
            var allocation = new CorporatePaymentAggregation.Allocation
            {
                AllocationNumber = "A101",
                VersionNumber = 1
            };
            message.Allocation = allocation;
            message.PaymentEventOrigin = PaymentEventOrigin.AllocationDeliveryCommenced;
            var storeMock = new Mock<IADMonitoringDeliveryEventStore>();

            var handler = new ContractAllocationsAtomFeedGenerationHandler(
                engineMock.Object,
                generatorMock.Object,
                storeMock.Object,
                Mock.Of<ISessionConnectionFactory>())
            {
                Logger = loggerMock.Object
            };
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            generatorMock.Verify(x => x.GenerateAtomFeed("A101", 1, AllocationDeliveryEntryCategory.ContractAllocationActualsReceived, It.IsAny<EntityData.ConnectionInfo>()), Times.Never(),
                "Handle_IPaymentAggregatedEvent generated the feed when ContractAllocationActuals Not Received");

        }

        #endregion

        #region Handle_IPaymentPostedEvent tests

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_IPaymentPostedEvent_ShouldGenerateFeed_WhenContractAllocationPaymentPostedReceived()
        {
            var loggerMock = new Mock<ILogger>();

            var engineMock = new Mock<IRulesEngine>();
            engineMock.Setup(x => x.EvaluateRule(
                RulesEngine.RuleName.ContractAllocationPaymentPosted,
                RulesEngine.EventName.PaymentPosted,
                "A101",
                1)
                ).Returns(true);

            var generatorMock = new Mock<IAtomGenerator>();

            var messageMock = new Mock<IPaymentPostedEvent>();
            var allocation = new CorporatePaymentAggregation.Allocation()
            {
                AllocationNumber = "A101",
                VersionNumber = 1
            };
            messageMock.SetupGet(x => x.Allocation).Returns(allocation);
            var storeMock = new Mock<IADMonitoringDeliveryEventStore>();

            var handler = new ContractAllocationsAtomFeedGenerationHandler(
                engineMock.Object,
                generatorMock.Object,
                storeMock.Object,
                Mock.Of<ISessionConnectionFactory>())
            {
                Logger = loggerMock.Object
            };
            handler.Handle(messageMock.Object, new TestableMessageHandlerContext()).Wait();

            generatorMock.Verify(x => x.GenerateAtomFeed("A101", 1, AllocationDeliveryEntryCategory.ContractAllocationPaymentReceived, It.IsAny<EntityData.ConnectionInfo>()), Times.Once(),
                "Handle_IPaymentPostedEvent did not generate the feed when ContractAllocationPaymentPosted Received");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_IPaymentPostedEvent_ShouldNotGenerateFeed_WhenContractAllocationPaymentPostedNotReceived()
        {
            var loggerMock = new Mock<ILogger>();

            var engineMock = new Mock<IRulesEngine>();
            engineMock.Setup(x => x.EvaluateRule(
                RulesEngine.RuleName.ContractAllocationPaymentPosted,
                RulesEngine.EventName.PaymentPosted,
                "A101",
                1)
                ).Returns(false);

            var generatorMock = new Mock<IAtomGenerator>();

            var messageMock = new Mock<IPaymentPostedEvent>();
            var allocation = new CorporatePaymentAggregation.Allocation()
            {
                AllocationNumber = "A101",
                VersionNumber = 1
            };
            messageMock.SetupGet(x => x.Allocation).Returns(allocation);
            var storeMock = new Mock<IADMonitoringDeliveryEventStore>();

            var handler = new ContractAllocationsAtomFeedGenerationHandler(
                engineMock.Object,
                generatorMock.Object,
                storeMock.Object,
                Mock.Of<ISessionConnectionFactory>())
            {
                Logger = loggerMock.Object
            };
            handler.Handle(messageMock.Object, new TestableMessageHandlerContext()).Wait();

            generatorMock.Verify(x => x.GenerateAtomFeed("A101", 1, AllocationDeliveryEntryCategory.ContractAllocationPaymentReceived, It.IsAny<EntityData.ConnectionInfo>()), Times.Never(),
                "Handle_IPaymentPostedEvent generated the feed when ContractAllocationPaymentPosted Not Received");
       }

        #endregion

        #region Handle_IAllocationActualsVerified

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_IAllocationActualsVerified_ShouldGenerateFeed_WhenContractAllocationActualsReceived()
        {
            var loggerMock = new Mock<ILogger>();
            var engineMock = new Mock<IRulesEngine>();
            engineMock.Setup(x => x.EvaluateRule(
                RulesEngine.RuleName.ContractAllocationActualsReceived,
                RulesEngine.EventName.AllocationActualsVerified,
                "A101",
                1)
                ).Returns(true);

            var generatorMock = new Mock<IAtomGenerator>();

            var message = new AllocationActualsVerified();
            var allocation = new AllocationActuals.ContractAllocationActualsType()
            {
                ContractAllocationNumber = "A101",
                ContractReference = new AllocationActuals.ContractReferenceType()
                {
                    ContractVersionNumber = 1
                }
            };
            message.AllocationActuals = allocation;
            var storeMock = new Mock<IADMonitoringDeliveryEventStore>();

            var handler = new ContractAllocationsAtomFeedGenerationHandler(
                engineMock.Object,
                generatorMock.Object,
                storeMock.Object,
                Mock.Of<ISessionConnectionFactory>())
            {
                Logger = loggerMock.Object
            };
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            generatorMock.Verify(x => x.GenerateAtomFeed("A101", 1, AllocationDeliveryEntryCategory.ContractAllocationActualsReceived, It.IsAny<EntityData.ConnectionInfo>()), Times.Once(),
                "Handle_IAllocationActualsVerified did not generate the feed when ContractAllocationActuals Received");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_AllocationActualsUpdated_ShouldGenerateFeed()
        {
            var loggerMock = new Mock<ILogger>();
            var engineMock = new Mock<IRulesEngine>();
            engineMock.Setup(x => x.EvaluateRule(
                RulesEngine.RuleName.ContractAllocationActualsReceived,
                RulesEngine.EventName.AllocationActualsVerified,
                "A101",
                1)
            ).Returns(true);

            var generatorMock = new Mock<IAtomGenerator>();

            var message = new AllocationActualsUpdated
            {
                AllocationActuals = new AllocationActuals.ContractAllocationActualsType()
                {
                    ContractAllocationNumber = "A101",
                    ContractReference = new AllocationActuals.ContractReferenceType()
                    {
                        ContractVersionNumber = 1
                    }
                }
            };

            var storeMock = new Mock<IADMonitoringDeliveryEventStore>();

            var handler = new ContractAllocationsAtomFeedGenerationHandler(
                engineMock.Object,
                generatorMock.Object,
                storeMock.Object,
                Mock.Of<ISessionConnectionFactory>())
            {
                Logger = loggerMock.Object
            };
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            generatorMock.Verify(x => x.GenerateAtomFeed("A101", 1, AllocationDeliveryEntryCategory.ContractAllocationActualsUpdated, It.IsAny<EntityData.ConnectionInfo>()), Times.Once(),
                "Handle_IAllocationActualsVerified did not generate the feed when ContractAllocationActuals Updated");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_IAllocationActualsVerified_ShouldNotGenerateFeed_WhenContractAllocationActualsNotReceived()
        {
            var loggerMock = new Mock<ILogger>();

            var engineMock = new Mock<IRulesEngine>();
            engineMock.Setup(x => x.EvaluateRule(
                RulesEngine.RuleName.ContractAllocationActualsReceived,
                RulesEngine.EventName.AllocationActualsVerified,
                "A101",
                1)
                ).Returns(false);

            var generatorMock = new Mock<IAtomGenerator>();

            var message = new AllocationActualsVerified
            {
                AllocationActuals = new AllocationActuals.ContractAllocationActualsType()
                {
                    ContractAllocationNumber = "A101",
                    ContractReference = new AllocationActuals.ContractReferenceType()
                    {
                        ContractVersionNumber = 1
                    }
                }
            };
            
            var storeMock = new Mock<IADMonitoringDeliveryEventStore>();

            var handler = new ContractAllocationsAtomFeedGenerationHandler(
                engineMock.Object,
                generatorMock.Object,
                storeMock.Object,
                Mock.Of<ISessionConnectionFactory>())
            {
                Logger = loggerMock.Object
            };
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            generatorMock.Verify(x => x.GenerateAtomFeed("A101", 1, AllocationDeliveryEntryCategory.ContractAllocationActualsReceived, It.IsAny<EntityData.ConnectionInfo>()), Times.Never(),
                "Handle_IAllocationActualsVerified generated the feed when ContractAllocationActuals Not Received");

        }

        #endregion

        #region Handle_PaymentScheduledEvent

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_PaymentScheduledEvent_ShouldGenerateFeed_WhenContractAllocationActualsReceived()
        {
            var loggerMock = new Mock<ILogger>();

            var engineMock = new Mock<IRulesEngine>();
            engineMock.Setup(x => x.EvaluateRule(
                RulesEngine.RuleName.ContractAllocationActualsReceived,
                RulesEngine.EventName.PaymentCalculated,
                "A101",
                1)
                ).Returns(true);

            var generatorMock = new Mock<IAtomGenerator>();

            var message = new PaymentScheduleEvent();
            var allocation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation()
            {
                AllocationNumber = "A101",
                ContractVersionNumber = 1
            };
            message.PaymentScheduleAllocation = allocation;
            message.PaymentEventOrigin = PaymentEventOrigin.AllocationActualsVerified;
            var storeMock = new Mock<IADMonitoringDeliveryEventStore>();

            var handler = new ContractAllocationsAtomFeedGenerationHandler(
                engineMock.Object,
                generatorMock.Object,
                storeMock.Object,
                Mock.Of<ISessionConnectionFactory>())
            {
                Logger = loggerMock.Object
            };
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            generatorMock.Verify(x => x.GenerateAtomFeed("A101", 1, AllocationDeliveryEntryCategory.ContractAllocationActualsReceived, It.IsAny<EntityData.ConnectionInfo>()), Times.Once(),
                "Handle_PaymentScheduledEvent did not generate the feed when ContractAllocationActuals Received");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_PaymentScheduledEvent_ShouldGenerateFeed_WhenContractAllocationActualsUpdated()
        {
            var loggerMock = new Mock<ILogger>();

            var engineMock = new Mock<IRulesEngine>();
            engineMock.Setup(x => x.EvaluateRule(
                RulesEngine.RuleName.ContractAllocationActualsReceived,
                RulesEngine.EventName.PaymentCalculated,
                "A101",
                1)
            ).Returns(true);

            var generatorMock = new Mock<IAtomGenerator>();

            var message = new PaymentScheduleEvent();
            var allocation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation
            {
                AllocationNumber = "A101",
                ContractVersionNumber = 1
            };
            message.PaymentScheduleAllocation = allocation;
            message.PaymentEventOrigin = PaymentEventOrigin.AllocationActualsUpdated;
            var storeMock = new Mock<IADMonitoringDeliveryEventStore>();

            var handler = new ContractAllocationsAtomFeedGenerationHandler(
                engineMock.Object,
                generatorMock.Object,
                storeMock.Object,
                Mock.Of<ISessionConnectionFactory>())
            {
                Logger = loggerMock.Object
            };
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            generatorMock.Verify(x => x.GenerateAtomFeed("A101", 1, AllocationDeliveryEntryCategory.ContractAllocationActualsUpdated, It.IsAny<EntityData.ConnectionInfo>()), Times.Once(),
                "Handle_PaymentScheduledEvent did not generate the feed when ContractAllocationActuals Updated");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_PaymentScheduledEvent_ShouldNotGenerateFeed_WhenContractAllocationActualsNotReceived()
        {
            var loggerMock = new Mock<ILogger>();

            var engineMock = new Mock<IRulesEngine>();
            engineMock.Setup(x => x.EvaluateRule(
                RulesEngine.RuleName.ContractAllocationActualsReceived,
                RulesEngine.EventName.PaymentCalculated,
                "A101",
                1)
                ).Returns(false);

            var generatorMock = new Mock<IAtomGenerator>();

            var message = new PaymentScheduleEvent();
            var allocation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation()
            {
                AllocationNumber = "A101",
                ContractVersionNumber = 1
            };
            message.PaymentScheduleAllocation = allocation;
            var storeMock = new Mock<IADMonitoringDeliveryEventStore>();

            var handler = new ContractAllocationsAtomFeedGenerationHandler(
                engineMock.Object,
                generatorMock.Object,
                storeMock.Object,
                Mock.Of<ISessionConnectionFactory>())
            {
                Logger = loggerMock.Object
            };
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            generatorMock.Verify(x => x.GenerateAtomFeed("A101", 1, AllocationDeliveryEntryCategory.ContractAllocationPaymentReceived, It.IsAny<EntityData.ConnectionInfo>()), Times.Never(),
                "Handle_PaymentScheduledEvent generated the feed when ContractAllocationActuals Not Received");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_PaymentScheduledEvent_ShouldNotGenerateFeed_WhenPaymentEventOriginNotAllocationActualsVerified()
        {
            var loggerMock = new Mock<ILogger>();

            var engineMock = new Mock<IRulesEngine>();
            engineMock.Setup(x => x.EvaluateRule(
                RulesEngine.RuleName.ContractAllocationActualsReceived,
                RulesEngine.EventName.PaymentCalculated,
                "A101",
                1)
                ).Returns(true);

            var generatorMock = new Mock<IAtomGenerator>();

            var message = new PaymentScheduleEvent();
            var allocation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation()
            {
                AllocationNumber = "A101",
                ContractVersionNumber = 1
            };
            message.PaymentScheduleAllocation = allocation;
            message.PaymentEventOrigin = PaymentEventOrigin.AllocationDeliveryCommenced;
            var storeMock = new Mock<IADMonitoringDeliveryEventStore>();

            var handler = new ContractAllocationsAtomFeedGenerationHandler(
                engineMock.Object,
                generatorMock.Object,
                storeMock.Object,
                Mock.Of<ISessionConnectionFactory>())
            {
                Logger = loggerMock.Object
            };
            handler.Handle(message, new TestableMessageHandlerContext()).Wait();

            generatorMock.Verify(x => x.GenerateAtomFeed("A101", 1, AllocationDeliveryEntryCategory.ContractAllocationActualsReceived, It.IsAny<EntityData.ConnectionInfo>()), Times.Never(),
                "Handle_PaymentScheduledEvent generated a ContractAllocationActualsReceived feed item when payment event origin was not AllocationActualsVerified");
        }

        #endregion
    }
}
