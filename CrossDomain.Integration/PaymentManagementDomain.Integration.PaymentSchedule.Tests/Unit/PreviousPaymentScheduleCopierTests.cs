namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Unit
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using Services;

    [TestClass]
    public class PreviousPaymentScheduleCopierTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PreviousPaymentScheduleCopier_Should_CopyPreviousValueWhenReplacedValuesExist()
        {
            // arrange
            const string allocationNumber = "TESTA-123";
            DeliverablePayment deliverablePaymentDeliverableCode1 = new DeliverablePayment
            {
                AllocationNumber = allocationNumber,
                VersionNumber = 1,
                Period = "201705",
                ReconciliationPaymentAmount = 120m,
                NetPaymentAmount = 120m,
                DeliverableCode = 1,
                PeriodTypeCode = PeriodTypeCode.CM
            };
            DeliverablePayment deliverablePaymentDeliverableCode2 = new DeliverablePayment
            {
                AllocationNumber = allocationNumber,
                VersionNumber = 1,
                Period = "201706",
                ReconciliationPaymentAmount = 140m,
                NetPaymentAmount = 1140m,
                DeliverableCode = 2,
                PeriodTypeCode = PeriodTypeCode.CM
            };
            Mock<IDeliverablePaymentRepository> mockRepository = new Mock<IDeliverablePaymentRepository>();
            mockRepository.Setup(m => m.GetLatestVersion(It.IsAny<string>())).Returns(1);
            mockRepository.Setup(m => m.GetDeliverablePaymentsForAllocation(It.IsAny<string>(), 1))
                          .Returns(new List<DeliverablePayment> {deliverablePaymentDeliverableCode1, deliverablePaymentDeliverableCode2});
            
            PreviousPaymentScheduleCopier copier = new PreviousPaymentScheduleCopier(mockRepository.Object);

            SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentScheduleAllocation = new CrossDomain.Integration
                .Entities.PaymentSchedule.Allocation
            {
                AllocationDeliverables = new List<AllocationDeliverable>
                {
                    new AllocationDeliverable
                    {
                        DeliverableCode = 1,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment
                            {
                                Period = "201705"
                            }
                        }
                    },
                    new AllocationDeliverable
                    {
                        DeliverableCode = 42,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment
                            {
                                Period = "201705"
                            }
                        }
                    }
                }
            };
            // act
            copier.CopyPreviousReplacedValuesOntoPaySchedule(allocationNumber, paymentScheduleAllocation);

            // assert
            Assert.AreEqual(3, paymentScheduleAllocation.AllocationDeliverables.Count, "The are the wrong number of deliverables");

            AllocationDeliverable deliverableCode1 = paymentScheduleAllocation.AllocationDeliverables.Single(ad => ad.DeliverableCode == 1);
            AllocationDeliverable deliverableCode2 = paymentScheduleAllocation.AllocationDeliverables.Single(ad => ad.DeliverableCode == 2);

            Assert.AreEqual(1, deliverableCode1.ScheduledPayments.Count, "There are the wrong number of scheduled payment for deliverableCode1");
            Assert.AreEqual(deliverablePaymentDeliverableCode1.ReconciliationPaymentAmount, deliverableCode1.ScheduledPayments[0].ReconciliationPaymentAmount, "ReconciliationPaymentAmount did not match expected value for deliverableCode1");
            Assert.AreEqual(deliverablePaymentDeliverableCode1.NetPaymentAmount, deliverableCode1.ScheduledPayments[0].NetPaymentAmount, "NetPaymentAmount did not match expected value for deliverableCode1");
            Assert.AreEqual(deliverablePaymentDeliverableCode1.PeriodTypeCode.ToString(), deliverableCode1.ScheduledPayments[0].PeriodTypeCode, "PeriodTypeCode did not match expected value for deliverableCode1");

            Assert.AreEqual(deliverablePaymentDeliverableCode2.ReconciliationPaymentAmount, deliverableCode2.ScheduledPayments[0].ReconciliationPaymentAmount, "ReconciliationPaymentAmount did not match expected value for deliverableCode2");
            Assert.AreEqual(deliverablePaymentDeliverableCode2.NetPaymentAmount, deliverableCode2.ScheduledPayments[0].NetPaymentAmount, "NetPaymentAmount did not match expected value for deliverableCode2");
            Assert.AreEqual(deliverablePaymentDeliverableCode2.PeriodTypeCode.ToString(), deliverableCode2.ScheduledPayments[0].PeriodTypeCode, "PeriodTypeCode did not match expected value for deliverableCode2");
            Assert.IsTrue(paymentScheduleAllocation.AllocationDeliverables.Count(ad => ad.DeliverableCode == 42) == 1, "Deliverable Code 42 is missing");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousPaymentScheduleCopier_Should_CopyPreviousValuesNotIncludingPlannedValueVolumeWhenReplacedValuesExist()
        {
            // arrange
            const string allocationNumber = "TESTA-123";
            DeliverablePayment deliverablePaymentDeliverableCode1 = new DeliverablePayment
            {
                AllocationNumber = allocationNumber,
                VersionNumber = 1,
                Period = "201705",
                ReconciliationPaymentAmount = 120m,
                NetPaymentAmount = 120m,
                DeliverableCode = 1,
                PeriodTypeCode = PeriodTypeCode.CM
            };
            DeliverablePayment deliverablePaymentDeliverableCode2 = new DeliverablePayment
            {
                AllocationNumber = allocationNumber,
                VersionNumber = 1,
                Period = "201705",
                ReconciliationPaymentAmount = 140m,
                NetPaymentAmount = 1140m,
                DeliverableCode = 2,
                PeriodTypeCode = PeriodTypeCode.CM
            };
            Mock<IDeliverablePaymentRepository> mockRepository = new Mock<IDeliverablePaymentRepository>();
            mockRepository.Setup(m => m.GetLatestVersion(It.IsAny<string>())).Returns(1);
            mockRepository.Setup(m => m.GetDeliverablePaymentsForAllocation(It.IsAny<string>(), 1))
                          .Returns(new List<DeliverablePayment> { deliverablePaymentDeliverableCode1, deliverablePaymentDeliverableCode2 });

            PreviousPaymentScheduleCopier copier = new PreviousPaymentScheduleCopier(mockRepository.Object);

            const decimal contractPlannedValueForDeliverable1 = 111M;
            const int contractPlannedVolumeForDeliverable1 = 333;
            const decimal contractPlannedValueForDeliverable2 = 222M;
            const int contractPlannedVolumeForDeliverable2 = 444;

            SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentScheduleAllocation = new CrossDomain.Integration
                .Entities.PaymentSchedule.Allocation
            {
                AllocationDeliverables = new List<AllocationDeliverable>
                {
                    new AllocationDeliverable
                    {
                        DeliverableCode = 1,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment
                            {
                                Period = "201705",
                                PlannedValue = contractPlannedValueForDeliverable1,
                                PlannedVolume = contractPlannedVolumeForDeliverable1
                            }
                        }
                    },
                     new AllocationDeliverable
                    {
                        DeliverableCode = 2,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment
                            {
                                Period = "201705",
                                PlannedValue = contractPlannedValueForDeliverable2,
                                PlannedVolume = contractPlannedVolumeForDeliverable2
                            }
                        }
                    },

                    new AllocationDeliverable
                    {
                        DeliverableCode = 42,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment
                            {
                                Period = "201705",
                            }
                        }
                    }
                }
            };

            // act
            copier.CopyPreviousReplacedValuesOntoPaySchedule(allocationNumber, paymentScheduleAllocation);

            // assert
            Assert.AreEqual(3, paymentScheduleAllocation.AllocationDeliverables.Count, "The are the wrong number of deliverables");

            AllocationDeliverable deliverableCode1 = paymentScheduleAllocation.AllocationDeliverables.Single(ad => ad.DeliverableCode == 1);
            AllocationDeliverable deliverableCode2 = paymentScheduleAllocation.AllocationDeliverables.Single(ad => ad.DeliverableCode == 2);

            Assert.AreEqual(1, deliverableCode1.ScheduledPayments.Count, "There are the wrong number of scheduled payment for deliverableCode1");
            Assert.AreEqual(deliverablePaymentDeliverableCode1.ReconciliationPaymentAmount, deliverableCode1.ScheduledPayments[0].ReconciliationPaymentAmount, "ReconciliationPaymentAmount did not match expected value for deliverableCode1");
            Assert.AreEqual(deliverablePaymentDeliverableCode1.NetPaymentAmount, deliverableCode1.ScheduledPayments[0].NetPaymentAmount, "NetPaymentAmount did not match expected value for deliverableCode1");
            Assert.AreEqual(deliverablePaymentDeliverableCode1.PeriodTypeCode.ToString(), deliverableCode1.ScheduledPayments[0].PeriodTypeCode, "PeriodTypeCode did not match expected value for deliverableCode1");
            Assert.AreEqual(contractPlannedValueForDeliverable1, deliverableCode1.ScheduledPayments[0].PlannedValue, "PlannedValue did not match expected value for deliverableCode1");
            Assert.AreEqual(contractPlannedVolumeForDeliverable1, deliverableCode1.ScheduledPayments[0].PlannedVolume, "PlannedVolume did not match expected value for deliverableCode1");

            Assert.AreEqual(deliverablePaymentDeliverableCode2.ReconciliationPaymentAmount, deliverableCode2.ScheduledPayments[0].ReconciliationPaymentAmount, "ReconciliationPaymentAmount did not match expected value for deliverableCode2");
            Assert.AreEqual(deliverablePaymentDeliverableCode2.NetPaymentAmount, deliverableCode2.ScheduledPayments[0].NetPaymentAmount, "NetPaymentAmount did not match expected value for deliverableCode2");
            Assert.AreEqual(deliverablePaymentDeliverableCode2.PeriodTypeCode.ToString(), deliverableCode2.ScheduledPayments[0].PeriodTypeCode, "PeriodTypeCode did not match expected value for deliverableCode2");
            Assert.IsTrue(paymentScheduleAllocation.AllocationDeliverables.Count(ad => ad.DeliverableCode == 42) == 1, "Deliverable Code 42 is missing");
            Assert.AreEqual(contractPlannedValueForDeliverable2, deliverableCode2.ScheduledPayments[0].PlannedValue, "PlannedValue did not match expected value for deliverableCode2");
            Assert.AreEqual(contractPlannedVolumeForDeliverable2, deliverableCode2.ScheduledPayments[0].PlannedVolume, "PlannedVolume did not match expected value for deliverableCode2");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousPaymentScheduleCopier_Should_CopyPreviousActualsOntoPayScheduleAllocation()
        {
            // arrange
            const string allocationNumber = "TESTA-123";
            DeliverablePayment deliverablePaymentDeliverableCode1 = new DeliverablePayment
            {
                AllocationNumber = allocationNumber,
                VersionNumber = 1,
                Period = "201705",
                ReconciliationPaymentAmount = 120m,
                NetPaymentAmount = 120m,
                DeliverableCode = 1,
                PeriodTypeCode = PeriodTypeCode.CM,
                ActualValue = 11,
                ActualVolume = 12
            };
            DeliverablePayment deliverablePaymentDeliverableCode2 = new DeliverablePayment
            {
                AllocationNumber = allocationNumber,
                VersionNumber = 1,
                Period = "201705",
                ReconciliationPaymentAmount = 140m,
                NetPaymentAmount = 1140m,
                DeliverableCode = 2,
                PeriodTypeCode = PeriodTypeCode.CM,
                ActualValue = 14,
                ActualVolume = 15
            };
            Mock<IDeliverablePaymentRepository> mockRepository = new Mock<IDeliverablePaymentRepository>();
            mockRepository.Setup(m => m.GetLatestVersion(It.IsAny<string>())).Returns(1);
            mockRepository.Setup(m => m.GetDeliverablePaymentsForAllocation(It.IsAny<string>(), 1))
                          .Returns(new List<DeliverablePayment> { deliverablePaymentDeliverableCode1, deliverablePaymentDeliverableCode2 });

            PreviousPaymentScheduleCopier copier = new PreviousPaymentScheduleCopier(mockRepository.Object);

            SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentScheduleAllocation = new CrossDomain.Integration
                .Entities.PaymentSchedule.Allocation
            {
                AllocationDeliverables = new List<AllocationDeliverable>
                {
                    new AllocationDeliverable
                    {
                        DeliverableCode = 1,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment
                            {
                                Period = "201705"
                            }
                        }
                    },
                    new AllocationDeliverable
                    {
                        DeliverableCode = 2,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment
                            {
                                Period = "201705"
                            }
                        }
                    }
                }
            };
            // act
            copier.CopyPreviousReplacedValuesOntoPaySchedule(allocationNumber, paymentScheduleAllocation);

            // assert
            Assert.AreEqual(2, paymentScheduleAllocation.AllocationDeliverables.Count, "The are the wrong number of deliverables");

            AllocationDeliverable deliverableCode1 = paymentScheduleAllocation.AllocationDeliverables.Single(ad => ad.DeliverableCode == 1);
            AllocationDeliverable deliverableCode2 = paymentScheduleAllocation.AllocationDeliverables.Single(ad => ad.DeliverableCode == 2);

            Assert.AreEqual(1, deliverableCode1.ScheduledPayments.Count, "There are the wrong number of scheduled payment for deliverableCode1");
            Assert.AreEqual(deliverablePaymentDeliverableCode1.ActualValue, deliverableCode1.ScheduledPayments[0].ActualValue, "ActualValue did not match expected value for deliverableCode1");
            Assert.AreEqual(deliverablePaymentDeliverableCode1.ActualVolume, deliverableCode1.ScheduledPayments[0].ActualVolume, "ActualVolume did not match expected value for deliverableCode1");
            
            Assert.AreEqual(deliverablePaymentDeliverableCode2.ActualValue, deliverableCode2.ScheduledPayments[0].ActualValue, "ActualValue did not match expected value for deliverableCode2");
            Assert.AreEqual(deliverablePaymentDeliverableCode2.ActualVolume, deliverableCode2.ScheduledPayments[0].ActualVolume, "ActualVolume did not match expected value for deliverableCode2");
        }
    }
}