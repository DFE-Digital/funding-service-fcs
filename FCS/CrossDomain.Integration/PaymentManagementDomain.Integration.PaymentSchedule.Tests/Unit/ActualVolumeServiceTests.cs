namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Unit
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;

    [TestClass]
    public class ActualVolumeServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ActualVolumeService_ShouldUpdateDeliverablePaymentAndSchedule_WhenPreviousVersionPresent()
        {
            // arrange
            const string allocationNumber = "Test Alloc";
            const int curentVersion = 2;
            const int actualVolForPeriodJan = 10;
            const int actualVolForPeriodFeb = 20;

            Mock<IDeliverablePaymentRepository> deliverablePaymentRepositoryMock = new Mock<IDeliverablePaymentRepository>();

            Mock<IAllocationRepository> allocationRepositoryMock = new Mock<IAllocationRepository>();
            allocationRepositoryMock.Setup(r => r.HasPreviousAllocationVersion(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(true);

            allocationRepositoryMock.Setup(r => r.GetPreviousApprovedContractVersionNumberFromPaymentSchedule(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(curentVersion - 1);

            deliverablePaymentRepositoryMock
                .Setup(r => r.GetDeliverablePeriodActualVolumesForAllocation(It.IsAny<string>(), curentVersion - 1)).Returns(
                    new List<DeliverablePeriodActualVolume>
                    {
                        new DeliverablePeriodActualVolume
                        (period:"201801", deliverableCode:1, volume:actualVolForPeriodJan),
                        new DeliverablePeriodActualVolume
                        (period:"201802", deliverableCode:1, volume:actualVolForPeriodFeb)
                    });

            ActualVolumeService service = new ActualVolumeService(deliverablePaymentRepositoryMock.Object, allocationRepositoryMock.Object);
            IReadOnlyCollection<DeliverablePayment> deliverablePayments = new List<DeliverablePayment>
            {
                new DeliverablePayment
                {
                    AllocationNumber = allocationNumber,
                    VersionNumber = curentVersion,
                    Period = "201801",
                    DeliverableCode = 1
                },
                new DeliverablePayment
                {
                    AllocationNumber = allocationNumber,
                    VersionNumber = curentVersion,
                    Period = "201802",
                    DeliverableCode = 1
                }
            };

            CrossDomain.Integration.Entities.PaymentSchedule.Allocation allocation =
                new CrossDomain.Integration.Entities.PaymentSchedule.Allocation
                {
                    AllocationNumber = allocationNumber,
                    ContractVersionNumber = curentVersion,
                    AllocationDeliverables = new List<AllocationDeliverable>
                    {
                        new AllocationDeliverable
                        {
                            DeliverableCode = 1,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                                new ScheduledPayment
                                {
                                    Period = "201801"
                                }
                            }
                        },
                        new AllocationDeliverable
                        {
                            DeliverableCode = 1,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                                new ScheduledPayment
                                {
                                    Period = "201802"
                                }
                            }
                        }
                    }
                };


            // act
            service.UpdatePaymentScheduleWithPreviousVersionVolume(allocation, deliverablePayments);

            // assert
            var schedulePayments = allocation.AllocationDeliverables.SelectMany(ad => ad.ScheduledPayments).ToList();

            Assert.AreEqual(actualVolForPeriodJan, schedulePayments.Single(sp => sp.Period == "201801").ActualVolume, "The Jan vol has not been set correctly on the payment schedule");
            Assert.AreEqual(actualVolForPeriodFeb, schedulePayments.Single(sp => sp.Period == "201802").ActualVolume, "The Feb vol has not been set correctly on the payment schedule");

            Assert.AreEqual(actualVolForPeriodJan, deliverablePayments.Single(dp => dp.Period == "201801" && dp.DeliverableCode == 1).ActualVolume, "The Jan vol has not been set correctly on the deliverable payments");
            Assert.AreEqual(actualVolForPeriodFeb, deliverablePayments.Single(dp => dp.Period == "201802" && dp.DeliverableCode == 1 ).ActualVolume, "The Feb vol has not been set correctly on the deliverable payments");
        }
    }
}
