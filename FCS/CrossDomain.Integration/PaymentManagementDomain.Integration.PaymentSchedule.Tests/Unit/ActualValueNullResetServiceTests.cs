namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Unit
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.AllocationActuals;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using Services;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;

    [TestClass]
    public class ActualValueNullResetServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ActualValueNullResetService_ConditionallyResetActualValuesToNullOnApproval_ShouldResetToNullIfNoPriorAllocationVersion()
        {
            // arrange
            Mock<IAllocationRepository> allocationRepositoryMock = new Mock<IAllocationRepository>();
            Mock<IDeliverablePaymentRepository> deliverablePaymentRepositoryMock = new Mock<IDeliverablePaymentRepository>();

            allocationRepositoryMock.Setup(m => m.HasPreviousAllocationVersion(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(false);

            IActualValueNullResetService actualValueNullResetService =
                new ActualValueNullResetService(allocationRepositoryMock.Object, deliverablePaymentRepositoryMock.Object);

            PaymentSchedule.Allocation allocation = GetTestAllocation();
            List<DeliverablePayment> deliverablePayments = GetTestDelPayments();

            // act
            var result = actualValueNullResetService.ConditionallyResetActualValuesToNullOnApproval(allocation, deliverablePayments);

            // assert
            Assert.IsTrue(result.PaymentScheduleAllocation.AllocationDeliverables
                .SelectMany(ad => ad.ScheduledPayments.Select(sp => sp.ActualValue))
                .All(actualValue => actualValue == null),
                "There were non-null actual values in the Payment Schedule Allocation");

            Assert.IsTrue(result.DeliverablePayments.All(dp => dp.ActualValue == null),
                "There were non-null actual values in the Deliverable Payments");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualValueNullResetService_ConditionallyResetActualValuesToNullOnApproval_ShouldResetToNullIfPreviousVersionHasAllNullValues()
        {
            // arrange
            Mock<IAllocationRepository> allocationRepositoryMock = new Mock<IAllocationRepository>();
            Mock<IDeliverablePaymentRepository> deliverablePaymentRepositoryMock = new Mock<IDeliverablePaymentRepository>();

            allocationRepositoryMock.Setup(m => m.HasPreviousAllocationVersion(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(true);

            allocationRepositoryMock.Setup(m => m.GetPreviousApprovedContractVersionNumberFromPaymentSchedule(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(1);

            deliverablePaymentRepositoryMock
                .Setup(m => m.GetDeliverablePaymentsForAllocation(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(new List<DeliverablePayment>());

            IActualValueNullResetService actualValueNullResetService =
                new ActualValueNullResetService(allocationRepositoryMock.Object, deliverablePaymentRepositoryMock.Object);

            PaymentSchedule.Allocation allocation = GetTestAllocation();
            List<DeliverablePayment> deliverablePayments = GetTestDelPayments();

            // act
            var result = actualValueNullResetService.ConditionallyResetActualValuesToNullOnApproval(allocation, deliverablePayments);

            // assert
            Assert.IsTrue(result.PaymentScheduleAllocation.AllocationDeliverables
                    .SelectMany(ad => ad.ScheduledPayments.Select(sp => sp.ActualValue))
                    .All(actualValue => actualValue == null),
                "There were non-null actual values in the Payment Schedule Allocation");

            Assert.IsTrue(result.DeliverablePayments.All(dp => dp.ActualValue == null),
                "There were non-null actual values in the Deliverable Payments");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualValueNullResetService_ConditionallyResetActualValuesToNullOnApproval_ShouldRetainOriginalValuesIfPreviousVersionHasNonNullActualValue()
        {
            // arrange
            Mock<IAllocationRepository> allocationRepositoryMock = new Mock<IAllocationRepository>();
            Mock<IDeliverablePaymentRepository> deliverablePaymentRepositoryMock = new Mock<IDeliverablePaymentRepository>();

            allocationRepositoryMock.Setup(m => m.HasPreviousAllocationVersion(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(true);

            allocationRepositoryMock.Setup(m => m.GetPreviousApprovedContractVersionNumberFromPaymentSchedule(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(1);

            deliverablePaymentRepositoryMock
                .Setup(m => m.GetDeliverablePaymentsForAllocation(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(GetTestDelPayments());

            IActualValueNullResetService actualValueNullResetService =
                new ActualValueNullResetService(allocationRepositoryMock.Object, deliverablePaymentRepositoryMock.Object);

            PaymentSchedule.Allocation allocation = GetTestAllocation();
            List<DeliverablePayment> deliverablePayments = GetTestDelPayments();

            // act
            var result = actualValueNullResetService.ConditionallyResetActualValuesToNullOnApproval(allocation, deliverablePayments);

            // assert
            Assert.IsTrue(result.PaymentScheduleAllocation.AllocationDeliverables
                    .SelectMany(ad => ad.ScheduledPayments.Select(sp => sp.ActualValue))
                    .All(actualValue => actualValue != null),
                "The Payment Schedule Allocation actual values were incorrectly set to null");

            Assert.IsTrue(result.DeliverablePayments.All(dp => dp.ActualValue != null),
                "The Deliverable Payment actual values were incorrectly set to null");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualValueNullResetService_ConditionallyResetActualValuesToNullOnActualsReceived_ShouldResetToNullIfNoActualsReceivedForPeriod()
        {
            // arrange
            IActualValueNullResetService actualValueNullResetService =
                new ActualValueNullResetService(Mock.Of<IAllocationRepository>(), Mock.Of<IDeliverablePaymentRepository>());

            IReadOnlyCollection<ActualsSummaryType> actualsReceived = new List<ActualsSummaryType>
            {
                new ActualsSummaryType { DeliverableCode = 1, Period = "201808", ActualValue = 108M },
                new ActualsSummaryType { DeliverableCode = 2, Period = "201808", ActualValue = 208M },
                new ActualsSummaryType { DeliverableCode = 1, Period = "201809", ActualValue = 109M },
                new ActualsSummaryType { DeliverableCode = 2, Period = "201809", ActualValue = 209M },
                new ActualsSummaryType { DeliverableCode = 1, Period = "201810", ActualValue = 110M },
                new ActualsSummaryType { DeliverableCode = 2, Period = "201810", ActualValue = 210M }
            };

            IReadOnlyCollection<DeliverablePayment> deliverablePayments = new List<DeliverablePayment>
            {
                new DeliverablePayment { DeliverableCode = 1, Period = "201808", ActualValue = 108M },
                new DeliverablePayment { DeliverableCode = 2, Period = "201808", ActualValue = 208M },
                new DeliverablePayment { DeliverableCode = 1, Period = "201809", ActualValue = 109M },
                new DeliverablePayment { DeliverableCode = 2, Period = "201809", ActualValue = 209M },
                new DeliverablePayment { DeliverableCode = 1, Period = "201810", ActualValue = 110M },
                new DeliverablePayment { DeliverableCode = 2, Period = "201810", ActualValue = 210M },
                new DeliverablePayment { DeliverableCode = 1, Period = "201811", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 2, Period = "201811", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 1, Period = "201812", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 2, Period = "201812", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 1, Period = "201901", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 2, Period = "201901", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 1, Period = "201902", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 2, Period = "201902", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 1, Period = "201903", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 2, Period = "201903", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 1, Period = "201904", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 2, Period = "201904", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 1, Period = "201905", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 2, Period = "201905", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 1, Period = "201906", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 2, Period = "201906", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 1, Period = "201907", ActualValue = 0M },
                new DeliverablePayment { DeliverableCode = 2, Period = "201907", ActualValue = 0M },
            };

            // act
            actualValueNullResetService.ResetDeliverablePaymentActualValuesToNullForNonReceivedActuals(actualsReceived, deliverablePayments);

            // assert
            Assert.AreEqual(108M, deliverablePayments.Single(dp => dp.DeliverableCode == 1 && dp.Period == "201808").ActualValue, "Unexpected Actual Value returned.");
            Assert.AreEqual(208M, deliverablePayments.Single(dp => dp.DeliverableCode == 2 && dp.Period == "201808").ActualValue, "Unexpected Actual Value returned.");
            Assert.AreEqual(109M, deliverablePayments.Single(dp => dp.DeliverableCode == 1 && dp.Period == "201809").ActualValue, "Unexpected Actual Value returned.");
            Assert.AreEqual(209M, deliverablePayments.Single(dp => dp.DeliverableCode == 2 && dp.Period == "201809").ActualValue, "Unexpected Actual Value returned.");
            Assert.AreEqual(110M, deliverablePayments.Single(dp => dp.DeliverableCode == 1 && dp.Period == "201810").ActualValue, "Unexpected Actual Value returned.");
            Assert.AreEqual(210M, deliverablePayments.Single(dp => dp.DeliverableCode == 2 && dp.Period == "201810").ActualValue, "Unexpected Actual Value returned.");

            string[] periodsForWhichNoActualsWereReceived = { "201811", "201812", "201901", "201902", "201903", "201904", "201905", "201906", "201907" };
            Assert.IsTrue(
                deliverablePayments.Where(dp => periodsForWhichNoActualsWereReceived.Contains(dp.Period)).All(dp => dp.ActualValue == null),
                "Unexpected non-null Actual Value returned.");
        }

        private PaymentSchedule.Allocation GetTestAllocation()
        {
            return new PaymentSchedule.Allocation
            {
                AllocationNumber = "TESTALLOC",
                ContractNumber = "TESTCONTRACT",
                ContractVersionNumber = 2,
                FundingStreamPeriodCode = "FSP",
                VersionNumber = 2,
                schemaVersion = 1,
                ProvisionIdentifiers = new List<PaymentSchedule.ProvisionIdentifier>(),
                Organisation = new PaymentSchedule.Organisation
                {
                    MainOrganisationIdentifier = "ORG",
                    OrganisationIdentifiers = new List<PaymentSchedule.OrganisationIdentifier>()
                },
                AllocationDeliverables = new List<PaymentSchedule.AllocationDeliverable>
                {
                    new PaymentSchedule.AllocationDeliverable
                    {
                        DeliverableCode = 1,
                        ScheduledPayments = new List<PaymentSchedule.ScheduledPayment>
                        {
                            new PaymentSchedule.ScheduledPayment
                            {
                                ActualValue = 0.0m
                            }
                        }
                    },
                    new PaymentSchedule.AllocationDeliverable
                    {
                        DeliverableCode = 2,
                        ScheduledPayments = new List<PaymentSchedule.ScheduledPayment>
                        {
                            new PaymentSchedule.ScheduledPayment
                            {
                                ActualValue = 0.0m
                            }
                        }
                    },
                }
            };
        }

        private List<DeliverablePayment> GetTestDelPayments()
        {
            return new List<DeliverablePayment>
            {
                new DeliverablePayment
                {
                    ActualValue = 0.0m,
                    DeliverableCode = 1
                },
                new DeliverablePayment
                {
                    ActualValue = 0.0m,
                    DeliverableCode = 2
                }
            };
        }
    }
}