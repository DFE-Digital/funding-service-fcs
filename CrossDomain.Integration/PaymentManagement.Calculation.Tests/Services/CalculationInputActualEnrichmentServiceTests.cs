namespace PaymentManagement.Calculation.Tests.Services
{
    using System.Collections.Generic;
    using Calculation.Dtos;
    using Calculation.Repositories;
    using Calculation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class CalculationInputActualEnrichmentServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetPreviousVersionActualsAndPaymentValuesIfPresent_ReturnsPreviousVersionValues()
        {
            const string allocationNumber = "allocation";
            const int currentVersion = 3;
            const int previousVersion = 2;
            var connectionInfo = ConnectionInfo.CreateDefault();
            IReadOnlyCollection<DeliverablePeriodActualAndPaymentInfo> actuals =
                new List<DeliverablePeriodActualAndPaymentInfo>();
            var allocationRepository = new Mock<IAllocationQueryRepository>();
            var deliverablePaymentRepository = new Mock<IDeliverablePaymentRepository>();
            allocationRepository
                .Setup(repository => repository.GetPreviousVersion(allocationNumber, currentVersion, connectionInfo))
                .Returns(previousVersion.Some());
            deliverablePaymentRepository
                .Setup(repository => repository.GetDeliverablePeriodActualsAndPaymentValues(
                    allocationNumber, previousVersion, connectionInfo))
                .Returns(actuals);
            var service = new CalculationInputActualEnrichmentService(
                deliverablePaymentRepository.Object, allocationRepository.Object);

            var result = service.GetPreviousVersionActualsAndPaymentValuesIfPresent(
                allocationNumber, currentVersion, connectionInfo);

            Assert.IsTrue(result.HasValue);
            result.Match(
                some: values => Assert.AreSame(actuals, values),
                none: () => Assert.Fail("Expected actuals for the previous version."));
            deliverablePaymentRepository.Verify(repository => repository.GetDeliverablePeriodActualsAndPaymentValues(
                allocationNumber, previousVersion, connectionInfo), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetPreviousVersionActualsAndPaymentValuesIfPresent_ReturnsNoneWhenNoPreviousVersionExists()
        {
            const string allocationNumber = "allocation";
            const int currentVersion = 1;
            var connectionInfo = ConnectionInfo.CreateDefault();
            var allocationRepository = new Mock<IAllocationQueryRepository>();
            var deliverablePaymentRepository = new Mock<IDeliverablePaymentRepository>();
            allocationRepository
                .Setup(repository => repository.GetPreviousVersion(allocationNumber, currentVersion, connectionInfo))
                .Returns(new Option<int>());
            var service = new CalculationInputActualEnrichmentService(
                deliverablePaymentRepository.Object, allocationRepository.Object);

            var result = service.GetPreviousVersionActualsAndPaymentValuesIfPresent(
                allocationNumber, currentVersion, connectionInfo);

            Assert.IsFalse(result.HasValue);
            deliverablePaymentRepository.Verify(repository => repository.GetDeliverablePeriodActualsAndPaymentValues(
                It.IsAny<string>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()), Times.Never);
        }
    }
}
