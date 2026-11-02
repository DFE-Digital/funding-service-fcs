namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Unit
{
    using System;
    using BusinessLogic.FundingClaimReconciliation.Repositories;
    using BusinessLogic.FundingClaimReconciliation.Services;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.Infos;
    using CrossDomain.Integration.Events;
    using Framework.Logging.Interfaces;
    using Handlers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;

    [TestClass]
    public class FundingClaimReconciliationPublishedHandlerTests
    {
        // PublishPaymentScheduleEvent tests
        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationPublishedHandler_ShouldPublishPaymentScheduleEventForPayableFundingClaimReconciliationAndNotManualPublication()
        {
            const string testAllocationNumber = "ALLOC-01";

            var busMock = new Mock<IBus>();

            var fcrPaymentCalculationServiceMock = new Mock<IFcrPaymentCalculationService>();
            fcrPaymentCalculationServiceMock
                .Setup(m => m.CalculateAllocationSchedules(It.IsAny<ContractInfo>()))
                .Returns(new[]
                {
                    new Allocation {AllocationNumber = testAllocationNumber}
                });

            var handler = new FundingClaimReconciliationPublishedHandler(
                Mock.Of<ILogger>(),
                busMock.Object,
                fcrPaymentCalculationServiceMock.Object,
                Mock.Of<IPaymentScheduleAllocationCommandRepository>(),
                Mock.Of<IPublishedPayableFcrAllocationRepository>());

            handler.Handle(new FundingClaimReconciliationPublishedEvent
            {
                FundingClaimReconciliationId = Guid.NewGuid(),
                FundingClaimReconciliationName = "FCRName",
                IsClaimCollectionPayable = true,
                IsForManualPublication = false,
                PublishedDate = DateTime.Now,
                ContractInfo = new ContractInfo(new[]
                {
                    new AllocationInfo(testAllocationNumber, 10M, DateTime.Now, DateTime.Now, "FSP")
                }, "CONTRACT-01", 1)
            });

            busMock.Verify(m => m.Publish(It.Is<PaymentScheduleEvent>(e => e.PaymentScheduleAllocation.AllocationNumber == testAllocationNumber)), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationPublishedHandler_ShouldNotPublishPaymentScheduleEventForPayableFundingClaimReconciliationAndManualPublication()
        {
            const string testAllocationNumber = "ALLOC-01";

            var busMock = new Mock<IBus>();

            var fcrPaymentCalculationServiceMock = new Mock<IFcrPaymentCalculationService>();
            fcrPaymentCalculationServiceMock
                .Setup(m => m.CalculateAllocationSchedules(It.IsAny<ContractInfo>()))
                .Returns(new[]
                {
                    new Allocation {AllocationNumber = testAllocationNumber}
                });

            var handler = new FundingClaimReconciliationPublishedHandler(
                Mock.Of<ILogger>(),
                busMock.Object,
                fcrPaymentCalculationServiceMock.Object,
                Mock.Of<IPaymentScheduleAllocationCommandRepository>(),
                Mock.Of<IPublishedPayableFcrAllocationRepository>());

            handler.Handle(new FundingClaimReconciliationPublishedEvent
            {
                FundingClaimReconciliationId = Guid.NewGuid(),
                FundingClaimReconciliationName = "FCRName",
                IsClaimCollectionPayable = true,
                IsForManualPublication = true,
                PublishedDate = DateTime.Now,
                ContractInfo = new ContractInfo(new[]
                {
                    new AllocationInfo(testAllocationNumber, 10M, DateTime.Now, DateTime.Now, "FSP")
                }, "CONTRACT-01", 1)
            });

            busMock.Verify(m => m.Publish(It.IsAny<PaymentScheduleEvent>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationPublishedHandler_ShouldNotPublishPaymentScheduleEventForNonPayableFundingClaimReconciliationNotManualPublication()
        {
            const string testAllocationNumber = "ALLOC-01";

            var busMock = new Mock<IBus>();

            var fcrPaymentCalculationServiceMock = new Mock<IFcrPaymentCalculationService>();
            fcrPaymentCalculationServiceMock
                .Setup(m => m.CalculateAllocationSchedules(It.IsAny<ContractInfo>()))
                .Returns(new[]
                {
                    new Allocation {AllocationNumber = testAllocationNumber}
                });

            var handler = new FundingClaimReconciliationPublishedHandler(
                Mock.Of<ILogger>(),
                busMock.Object,
                fcrPaymentCalculationServiceMock.Object,
                Mock.Of<IPaymentScheduleAllocationCommandRepository>(),
                Mock.Of<IPublishedPayableFcrAllocationRepository>());

            handler.Handle(new FundingClaimReconciliationPublishedEvent
            {
                FundingClaimReconciliationId = Guid.NewGuid(),
                FundingClaimReconciliationName = "FCRName",
                IsClaimCollectionPayable = false,
                IsForManualPublication = false,
                PublishedDate = DateTime.Now,
                ContractInfo = new ContractInfo(new[]
                {
                    new AllocationInfo(testAllocationNumber, 10M, DateTime.Now, DateTime.Now, "FSP")
                }, "CONTRACT-01", 1)
            });

            busMock.Verify(m => m.Publish(It.IsAny<PaymentScheduleEvent>()), Times.Never);
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationPublishedHandler_ShouldNotPublishPaymentScheduleEventForNonPayableFundingClaimReconciliationAndManualPublication()
        {
            const string testAllocationNumber = "ALLOC-01";

            var busMock = new Mock<IBus>();

            var fcrPaymentCalculationServiceMock = new Mock<IFcrPaymentCalculationService>();
            fcrPaymentCalculationServiceMock
                .Setup(m => m.CalculateAllocationSchedules(It.IsAny<ContractInfo>()))
                .Returns(new[]
                {
                    new Allocation {AllocationNumber = testAllocationNumber}
                });

            var handler = new FundingClaimReconciliationPublishedHandler(
                Mock.Of<ILogger>(),
                busMock.Object,
                fcrPaymentCalculationServiceMock.Object,
                Mock.Of<IPaymentScheduleAllocationCommandRepository>(),
                Mock.Of<IPublishedPayableFcrAllocationRepository>());

            handler.Handle(new FundingClaimReconciliationPublishedEvent
            {
                FundingClaimReconciliationId = Guid.NewGuid(),
                FundingClaimReconciliationName = "FCRName",
                IsClaimCollectionPayable = false,
                IsForManualPublication = true,
                PublishedDate = DateTime.Now,
                ContractInfo = new ContractInfo(new[]
                {
                    new AllocationInfo(testAllocationNumber, 10M, DateTime.Now, DateTime.Now, "FSP")
                }, "CONTRACT-01", 1)
            });

            busMock.Verify(m => m.Publish(It.IsAny<PaymentScheduleEvent>()), Times.Never);
        }

        // StoreAllocationNumber tests
        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationPublishedHandler_ShouldStoreAllocationNumberForPayableFundingClaimReconciliationAndNotManualPublication()
        {
            const string testAllocationNumber = "ALLOC-01";

            var fcrPaymentCalculationServiceMock = new Mock<IFcrPaymentCalculationService>();
            fcrPaymentCalculationServiceMock
                .Setup(m => m.CalculateAllocationSchedules(It.IsAny<ContractInfo>()))
                .Returns(new[]
                {
                    new Allocation {AllocationNumber = testAllocationNumber}
                });

            var publishedPayableFcrAllocationRepositoryMock = new Mock<IPublishedPayableFcrAllocationRepository>();

            var handler = new FundingClaimReconciliationPublishedHandler(
                Mock.Of<ILogger>(),
                Mock.Of<IBus>(),
                fcrPaymentCalculationServiceMock.Object,
                Mock.Of<IPaymentScheduleAllocationCommandRepository>(),
                publishedPayableFcrAllocationRepositoryMock.Object);

            handler.Handle(new FundingClaimReconciliationPublishedEvent
            {
                FundingClaimReconciliationId = Guid.NewGuid(),
                FundingClaimReconciliationName = "FCRName",
                IsClaimCollectionPayable = true,
                IsForManualPublication = false,
                PublishedDate = DateTime.Now,
                ContractInfo = new ContractInfo(new[]
                {
                    new AllocationInfo(testAllocationNumber, 10M, DateTime.Now, DateTime.Now, "FSP")
                }, "CONTRACT-01", 1)
            });

            publishedPayableFcrAllocationRepositoryMock.Verify(m => m.Add(testAllocationNumber), Times.Once);
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationPublishedHandler_ShouldStoreAllocationNumberForPayableFundingClaimReconciliationAndManualPublication()
        {
            const string testAllocationNumber = "ALLOC-01";

            var fcrPaymentCalculationServiceMock = new Mock<IFcrPaymentCalculationService>();
            fcrPaymentCalculationServiceMock
                .Setup(m => m.CalculateAllocationSchedules(It.IsAny<ContractInfo>()))
                .Returns(new[]
                {
                    new Allocation {AllocationNumber = testAllocationNumber}
                });

            var publishedPayableFcrAllocationRepositoryMock = new Mock<IPublishedPayableFcrAllocationRepository>();

            var handler = new FundingClaimReconciliationPublishedHandler(
                Mock.Of<ILogger>(),
                Mock.Of<IBus>(),
                fcrPaymentCalculationServiceMock.Object,
                Mock.Of<IPaymentScheduleAllocationCommandRepository>(),
                publishedPayableFcrAllocationRepositoryMock.Object);

            handler.Handle(new FundingClaimReconciliationPublishedEvent
            {
                FundingClaimReconciliationId = Guid.NewGuid(),
                FundingClaimReconciliationName = "FCRName",
                IsClaimCollectionPayable = true,
                IsForManualPublication = true,
                PublishedDate = DateTime.Now,
                ContractInfo = new ContractInfo(new[]
                {
                    new AllocationInfo(testAllocationNumber, 10M, DateTime.Now, DateTime.Now, "FSP")
                }, "CONTRACT-01", 1)
            });

            publishedPayableFcrAllocationRepositoryMock.Verify(m => m.Add(testAllocationNumber), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationPublishedHandler_ShouldNotStoreAllocationNumberForNonPayableFundingClaimReconciliationAndNotManualPublication()
        {
            const string testAllocationNumber = "ALLOC-01";

            var fcrPaymentCalculationServiceMock = new Mock<IFcrPaymentCalculationService>();
            fcrPaymentCalculationServiceMock
                .Setup(m => m.CalculateAllocationSchedules(It.IsAny<ContractInfo>()))
                .Returns(new[]
                {
                    new Allocation {AllocationNumber = testAllocationNumber}
                });

            var publishedPayableFcrAllocationRepositoryMock = new Mock<IPublishedPayableFcrAllocationRepository>();

            var handler = new FundingClaimReconciliationPublishedHandler(
                Mock.Of<ILogger>(),
                Mock.Of<IBus>(),
                fcrPaymentCalculationServiceMock.Object,
                Mock.Of<IPaymentScheduleAllocationCommandRepository>(),
                publishedPayableFcrAllocationRepositoryMock.Object);

            handler.Handle(new FundingClaimReconciliationPublishedEvent
            {
                FundingClaimReconciliationId = Guid.NewGuid(),
                FundingClaimReconciliationName = "FCRName",
                IsClaimCollectionPayable = false,
                IsForManualPublication = false,
                PublishedDate = DateTime.Now,
                ContractInfo = new ContractInfo(new[]
                {
                    new AllocationInfo(testAllocationNumber, 10M, DateTime.Now, DateTime.Now, "FSP")
                }, "CONTRACT-01", 1)
            });

            publishedPayableFcrAllocationRepositoryMock.Verify(m => m.Add(testAllocationNumber), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimReconciliationPublishedHandler_ShouldNotStoreAllocationNumberForNonPayableFundingClaimReconciliationAndManualPublication()
        {
            const string testAllocationNumber = "ALLOC-01";

            var fcrPaymentCalculationServiceMock = new Mock<IFcrPaymentCalculationService>();
            fcrPaymentCalculationServiceMock
                .Setup(m => m.CalculateAllocationSchedules(It.IsAny<ContractInfo>()))
                .Returns(new[]
                {
                    new Allocation {AllocationNumber = testAllocationNumber}
                });

            var publishedPayableFcrAllocationRepositoryMock = new Mock<IPublishedPayableFcrAllocationRepository>();

            var handler = new FundingClaimReconciliationPublishedHandler(
                Mock.Of<ILogger>(),
                Mock.Of<IBus>(),
                fcrPaymentCalculationServiceMock.Object,
                Mock.Of<IPaymentScheduleAllocationCommandRepository>(),
                publishedPayableFcrAllocationRepositoryMock.Object);

            handler.Handle(new FundingClaimReconciliationPublishedEvent
            {
                FundingClaimReconciliationId = Guid.NewGuid(),
                FundingClaimReconciliationName = "FCRName",
                IsClaimCollectionPayable = false,
                IsForManualPublication = true,
                PublishedDate = DateTime.Now,
                ContractInfo = new ContractInfo(new[]
                {
                    new AllocationInfo(testAllocationNumber, 10M, DateTime.Now, DateTime.Now, "FSP")
                }, "CONTRACT-01", 1)
            });

            publishedPayableFcrAllocationRepositoryMock.Verify(m => m.Add(testAllocationNumber), Times.Never);
        }
    }
}
