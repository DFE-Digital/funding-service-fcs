namespace SFA.FCT.PMD.Integration.EvidenceEndpoint.Tests.UnitTests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Entities.AllocationActuals;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Events;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using PaymentManagement.Calculation;
    using PaymentManagementDomain.BusinessLogic.Services;
    using PaymentManagementDomain.Integration.PaymentSchedule.Handlers;
    using PaymentManagementDomain.Integration.PaymentSchedule.Infrastructure;
    using PaymentManagementDomain.Integration.PaymentSchedule.IoC;
    using PaymentManagementDomain.Integration.PaymentSchedule.Services;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using PaymentManagementDomain.PolicyCache.DataStore.Model;
    using PaymentManagementDomain.PolicyCache.DataStore.Repositories;
    using paymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;

    [TestClass]
    public class AllocationActualsVerifiedHandlerTests
    {
        private AllocationActualsVerifiedHandler _handler;
        private readonly Mock<IPayCalcPolicyQueryRepository> _payCalcPolicyQueryRepositoryMock = new Mock<IPayCalcPolicyQueryRepository>();
        private Mock<IDate> _dateProviderMock;
        private readonly Mock<IDeliverablePaymentRepository> _deliverablePaymentRepository = new Mock<IDeliverablePaymentRepository>();

        [TestInitialize]
        public void TestInitialize()
        {
            _payCalcPolicyQueryRepositoryMock
                .Setup(r => r.GetFundingStreamPeriod(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new PolicyFundingStreamPeriod());

            Mock<IPaymentScheduleCreator> paymentScheduleCreatorMock = new Mock<IPaymentScheduleCreator>();
            paymentScheduleCreatorMock
                .Setup(m => m.CreatePaymentScheduleFromActuals(It.IsAny<ContractAllocationActualsType>(), It.IsAny<ConnectionInfo>()))
                .Returns(new PaymentScheduleWithPayments(null, null));

            Mock<IPaymentValuesCalculationService> paymentValuesCalcServiceMock = new Mock<IPaymentValuesCalculationService>();
            paymentValuesCalcServiceMock
                .Setup(s => s.ProducePaymentScheduleOnActualsReceived(It.IsAny<ContractAllocationActualsType>(), It.IsAny<ConnectionInfo>()))
                .Returns(new paymentSchedule.Allocation());

            _dateProviderMock = new Mock<IDate>();

            _handler = new AllocationActualsVerifiedHandler
            (
                Mock.Of<ILogger>(),
                Mock.Of<IPaymentScheduleService>(),
                _payCalcPolicyQueryRepositoryMock.Object,
                paymentScheduleCreatorMock.Object,
                _dateProviderMock.Object,
                Mock.Of<IActualVolumeApplicator>(),
                Mock.Of<IActualValueNullResetService>(),
                _deliverablePaymentRepository.Object,
                paymentValuesCalcServiceMock.Object,
                Mock.Of<ISessionConnectionFactory>());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationActualsVerifiedHandler_ShouldPublishPaymentScheduleEventForPayOnActualsAllocation()
        {
            // Arrange
            _deliverablePaymentRepository
                .Setup(r => r.GetDeliverablePaymentsForAllocation(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<DeliverablePayment>());

            AllocationActualsVerified allocationActualsVerified = new AllocationActualsVerified
            {
                AllocationActuals = new ContractAllocationActualsType
                {
                    ContractAllocationNumber = "1234",
                    ContractReference = new ContractReferenceType(),
                    ContractorReference = new OrganisationReferenceType(),
                    ActualsSummary = new List<ActualsSummaryType>
                    {
                        new ActualsSummaryType()
                    }
                }
            };

            var context = new TestableMessageHandlerContext();

            // Act
            _handler.Handle(allocationActualsVerified, context).Wait();

            // Assert
            Assert.AreEqual(1, context.PublishedMessages
                .Select(m => m.Message)
                .OfType<PaymentScheduleEvent>()
                .Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationActualsVerifiedHandler_ShouldNotPublishPaymentScheduleEventForPayOnProfileAllocation()
        {
            // Arrange
            _payCalcPolicyQueryRepositoryMock
                .Setup(r => r.GetFundingStreamPeriod(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new PolicyFundingStreamPeriod
                {
                    PaymentMethod = PaymentMethod.PayOnProfile
                });

            AllocationActualsVerified allocationActualsVerified = new AllocationActualsVerified
            {
                AllocationActuals = new ContractAllocationActualsType
                {
                    ContractAllocationNumber = "1234",
                    ContractReference = new ContractReferenceType(),
                    ContractorReference = new OrganisationReferenceType(),
                    ActualsSummary = new List<ActualsSummaryType>
                    {
                        new ActualsSummaryType()
                    }
                }
            };

            var context = new TestableMessageHandlerContext();

            // Act
            _handler.Handle(allocationActualsVerified, context).Wait();

            // Assert
            Assert.AreEqual(0, context.PublishedMessages
                .Select(m => m.Message)
                .OfType<PaymentScheduleEvent>()
                .Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationActualsVerifiedHandler_ShouldSetPayOnProfilePaymentValuesToNullOnCalculatedPaymentSchedule()
        {
            // Arrange
            _deliverablePaymentRepository
                .Setup(r => r.GetDeliverablePaymentsForAllocation(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<DeliverablePayment>());

             AllocationActualsVerified allocationActualsVerified = new AllocationActualsVerified
            {
                AllocationActuals = new ContractAllocationActualsType
                {
                    ContractAllocationNumber = "1234",
                    ContractReference = new ContractReferenceType(),
                    ContractorReference = new OrganisationReferenceType(),
                    ActualsSummary = new List<ActualsSummaryType>
                    {
                        new ActualsSummaryType()
                    }
                }
            };

            var context = new TestableMessageHandlerContext();

            // Act
            _handler.Handle(allocationActualsVerified, context).Wait();

            // Assert
            Assert.AreEqual(1, 
                context.PublishedMessages
                    .Select(m => m.Message)
                    .OfType<PaymentScheduleEvent>()
                    .Count(e => e.PaymentScheduleAllocation.AllocationDeliverables.All(d => d.ScheduledPayments.All(sp => sp.ProfilePaymentAmount == null && sp.BalancingPaymentAmount == null))),
                "Pay on Profile payment values were not set to null.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationActualsVerifiedHandler_ShouldThrowArgumentExceptionWhenActivityHasClosedForGivenFundingStreamPeriod()
        {
            // Arrange
            DateTime now = DateTime.UtcNow;

            _payCalcPolicyQueryRepositoryMock
                .Setup(r => r.GetFundingStreamPeriod(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(new PolicyFundingStreamPeriod
                {
                    ActivityCloseDate = now.AddDays(-1).Date
                });

            _dateProviderMock
                .Setup(m => m.GetCalculationDate())
                .Returns(now);

            AllocationActualsVerified allocationActualsVerified = new AllocationActualsVerified
            {
                AllocationActuals = new ContractAllocationActualsType
                {
                    ContractAllocationNumber = "1234",
                }
            };

            // Act
            bool argumentExceptionThrown = false;

            try
            {
                _handler.Handle(allocationActualsVerified, new TestableMessageHandlerContext()).Wait();
            }
            catch (AggregateException ex) when (ex.InnerException is ArgumentException)
            {
                argumentExceptionThrown = true;
            }

            Assert.IsTrue(argumentExceptionThrown);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationActualsVerifiedHandler_WhenHandlingAllocationActualsVerified_ShouldSetPaymentOriginToAllocationActualsVerified()
        {
            // Arrange
            _deliverablePaymentRepository
                .Setup(r => r.GetDeliverablePaymentsForAllocation(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<DeliverablePayment>());

            AllocationActualsVerified allocationActualsVerified = new AllocationActualsVerified
            {
                AllocationActuals = new ContractAllocationActualsType
                {
                    ContractAllocationNumber = "1234",
                    ContractReference = new ContractReferenceType(),
                    ContractorReference = new OrganisationReferenceType(),
                    ActualsSummary = new List<ActualsSummaryType>
                    {
                        new ActualsSummaryType()
                    }
                }
            };

            var context = new TestableMessageHandlerContext();

            // Act
            _handler.Handle(allocationActualsVerified, context).Wait();

            // Assert
            Assert.AreEqual(1,
                context.PublishedMessages
                    .Select(m => m.Message)
                    .OfType<PaymentScheduleEvent>()
                    .Count(e => e.PaymentEventOrigin == PaymentEventOrigin.AllocationActualsVerified));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationActualsVerifiedHandler_WhenHandlingAllocationActualsUpdated_ShouldSetPaymentOriginToAllocationActualsUpdated()
        {
            // Arrange
            _deliverablePaymentRepository
                .Setup(r => r.GetDeliverablePaymentsForAllocation(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(new List<DeliverablePayment>());

            AllocationActualsUpdated allocationActualsVerified = new AllocationActualsUpdated
            {
                AllocationActuals = new ContractAllocationActualsType
                {
                    ContractAllocationNumber = "1234",
                    ContractReference = new ContractReferenceType(),
                    ContractorReference = new OrganisationReferenceType(),
                    ActualsSummary = new List<ActualsSummaryType>
                    {
                        new ActualsSummaryType()
                    }
                }
            };

            var context = new TestableMessageHandlerContext();

            // Act
            _handler.Handle(allocationActualsVerified, context).Wait();

            // Assert
            Assert.AreEqual(1,
                context.PublishedMessages
                    .Select(m => m.Message)
                    .OfType<PaymentScheduleEvent>()
                    .Count(e => e.PaymentEventOrigin == PaymentEventOrigin.AllocationActualsUpdated));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationActualsVerifiedHandler_ShouldResolveAllDependenciesFromEndpointContainer()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new Microsoft.Extensions.Logging.LoggerFactory()))
                .Register(Component.For<AllocationActualsVerifiedHandler>().ImplementedBy<AllocationActualsVerifiedHandler>());
            container.BeginScope();

            // act, assert
            container.Resolve<AllocationActualsVerifiedHandler>();
        }
    }
}
