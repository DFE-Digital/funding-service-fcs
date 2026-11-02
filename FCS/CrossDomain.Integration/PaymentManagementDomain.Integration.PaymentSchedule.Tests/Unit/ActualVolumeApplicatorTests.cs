namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.AllocationActuals;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using UnitTests.Common;

    [TestClass]
    public class ActualVolumeApplicatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ActualVolumeApplicator_ShouldAddActualVolumeIfPresent()
        {
            // arrange
            const string allocationNumber = "ESF-184";
            const int contractVersionNumber = 2;
            const int actualVol = -29;
            var message = GetMessage();
            message.AllocationActuals.ActualsSummary.Single(s => s.Period == "201804" && s.DeliverableCode == 1)
                .ActualVolume = actualVol;

            List<DeliverablePayment> deliverablePayments = new List<DeliverablePayment>
            {
                new DeliverablePayment
                {
                    AllocationNumber = allocationNumber,
                    DeliverableCode = 1,
                    Period = "201804",
                    VersionNumber = contractVersionNumber
                },
                new DeliverablePayment
                {
                    AllocationNumber = allocationNumber,
                    DeliverableCode = 2,
                    Period = "201804",
                    VersionNumber = contractVersionNumber
                },
                new DeliverablePayment
                {
                    AllocationNumber = allocationNumber,
                    DeliverableCode = 3,
                    Period = "201804",
                    VersionNumber = contractVersionNumber
                },
                new DeliverablePayment
                {
                    AllocationNumber = allocationNumber,
                    DeliverableCode = 4,
                    Period = "201804",
                    VersionNumber = contractVersionNumber
                }
            };

            CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentSchedule =
                new CrossDomain.Integration.Entities.PaymentSchedule.Allocation
                {
                    AllocationNumber = allocationNumber,
                    ContractVersionNumber = contractVersionNumber,
                    AllocationDeliverables = new List<AllocationDeliverable>
                    {
                        new AllocationDeliverable
                        {
                            DeliverableCode = 1,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                                new ScheduledPayment
                                {
                                    Period = "201804"
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
                                    Period = "201804"
                                }
                            }
                        },
                        new AllocationDeliverable
                        {
                            DeliverableCode = 3,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                                new ScheduledPayment
                                {
                                    Period = "201804"
                                }
                            }
                        },
                        new AllocationDeliverable
                        {
                            DeliverableCode = 4,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                                new ScheduledPayment
                                {
                                    Period = "201804"
                                }
                            }
                        },
                    }
                };

            Assert.IsNotNull(message);

            // act
            new ActualVolumeApplicator().MutatePaymentScheduleWithActualVolume(paymentSchedule, deliverablePayments, message.AllocationActuals);

            // assert
            Assert.AreEqual(actualVol, paymentSchedule.AllocationDeliverables.Single(ad => ad.DeliverableCode == 1).ScheduledPayments.Single(p => p.Period == "201804").ActualVolume, "The payment schedule has not been updated");
            Assert.AreEqual(actualVol, deliverablePayments.Single(deliverablePayment => deliverablePayment.DeliverableCode == 1 &&  deliverablePayment.Period == "201804").ActualVolume, "The deliverable payment has not been updated");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualVolumeApplicator_ShouldNotChangePaymentScheduleIfActualVolumeIsNotPresent()
        {
            // arrange
            const string allocationNumber = "ESF-184";
            const int contractVersionNumber = 2;
            const int actualVol = 0;
            var message = GetMessage();
            message.AllocationActuals.ActualsSummary.ForEach(a => a.ActualVolume = actualVol);
                
            List<DeliverablePayment> deliverablePayments = new List<DeliverablePayment>
            {
                new DeliverablePayment
                {
                    AllocationNumber = allocationNumber,
                    DeliverableCode = 1,
                    Period = "201804",
                    VersionNumber = contractVersionNumber
                },
                new DeliverablePayment
                {
                    AllocationNumber = allocationNumber,
                    DeliverableCode = 2,
                    Period = "201804",
                    VersionNumber = contractVersionNumber
                },
                new DeliverablePayment
                {
                    AllocationNumber = allocationNumber,
                    DeliverableCode = 3,
                    Period = "201804",
                    VersionNumber = contractVersionNumber
                },
                new DeliverablePayment
                {
                    AllocationNumber = allocationNumber,
                    DeliverableCode = 4,
                    Period = "201804",
                    VersionNumber = contractVersionNumber
                }
            };

            CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentSchedule =
                new CrossDomain.Integration.Entities.PaymentSchedule.Allocation
                {
                    AllocationNumber = allocationNumber,
                    ContractVersionNumber = contractVersionNumber,
                    AllocationDeliverables = new List<AllocationDeliverable>
                    {
                        new AllocationDeliverable
                        {
                            DeliverableCode = 1,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                                new ScheduledPayment
                                {
                                    Period = "201804"
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
                                    Period = "201804"
                                }
                            }
                        },
                        new AllocationDeliverable
                        {
                            DeliverableCode = 3,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                                new ScheduledPayment
                                {
                                    Period = "201804"
                                }
                            }
                        },
                        new AllocationDeliverable
                        {
                            DeliverableCode = 4,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                                new ScheduledPayment
                                {
                                    Period = "201804"
                                }
                            }
                        },
                    }
                };

            Assert.IsNotNull(message);

            // act
            new ActualVolumeApplicator().MutatePaymentScheduleWithActualVolume(paymentSchedule, deliverablePayments, message.AllocationActuals);

            // assert
            Assert.IsTrue(paymentSchedule.AllocationDeliverables.All(ad => ad.ScheduledPayments.All(sp => sp.ActualVolume == actualVol)), "The payment schedule has not been updated");
            Assert.IsTrue(deliverablePayments.All(deliverablePayment => deliverablePayment.ActualVolume == actualVol), "The deliverable payments have not been updated");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualVolumeApplicator_ShouldApplyVolumesWhenFutureActualsPresent()
        {
            // arrange
            CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentSchedule = new CrossDomain.Integration.Entities.PaymentSchedule.Allocation
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
                                Period = "201808"
                            }
                        }
                    }
                }
            };

            List<DeliverablePayment> deliverablePayments = new List<DeliverablePayment>
            {
                new DeliverablePayment
                {
                    AllocationNumber = "ALLF-1000",
                    VersionNumber = 1,
                    DeliverableCode = 1,
                    Period = "201808"
                },
                new DeliverablePayment
                {
                    AllocationNumber = "ALLF-1000",
                    VersionNumber = 1,
                    DeliverableCode = 1,
                    Period = "201809"
                }
            };

            ContractAllocationActualsType allocationActuals = new ContractAllocationActualsType
            {
                ContractAllocationNumber = "ALLF-1000",
                ContractReference = new ContractReferenceType
                {
                    ContractVersionNumber = 1
                },
                ActualsSummary = new List<ActualsSummaryType>
                {
                    new ActualsSummaryType
                    {
                        DeliverableCode = 1,
                        Period = "201808",
                        ActualVolume = 5
                    },
                    new ActualsSummaryType
                    {
                        DeliverableCode = 1,
                        Period = "201809",
                        ActualVolume = 10
                    }
                }
            };

            // act
            new ActualVolumeApplicator().MutatePaymentScheduleWithActualVolume(paymentSchedule, deliverablePayments, allocationActuals);

            // assert
            Assert.AreEqual(
                5,
                paymentSchedule.AllocationDeliverables.Single(ad => ad.DeliverableCode == 1).ScheduledPayments.Single(p => p.Period == "201808").ActualVolume,
                "The payment schedule has not been updated with volume");
            Assert.AreEqual(
                5,
                deliverablePayments.Single(deliverablePayment => deliverablePayment.DeliverableCode == 1 && deliverablePayment.Period == "201808").ActualVolume,
                "The deliverable payment has not been updated with volume");
            Assert.AreEqual(
                10,
                deliverablePayments.Single(deliverablePayment => deliverablePayment.DeliverableCode == 1 && deliverablePayment.Period == "201809").ActualVolume,
                "The deliverable payment has not been updated with volume for the future actual");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualVolumeApplicator_ShouldNotThrowExceptionWhenWhenActualsNotOnPaymentSchedule()
        {
            // arrange
            CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentSchedule = new CrossDomain.Integration.Entities.PaymentSchedule.Allocation
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
                                Period = "201808"
                            }
                        }
                    }
                }
            };

            List<DeliverablePayment> deliverablePayments = new List<DeliverablePayment>
            {
                new DeliverablePayment
                {
                    AllocationNumber = "ALLF-1000",
                    VersionNumber = 1,
                    DeliverableCode = 1,
                    Period = "201808"
                },
                new DeliverablePayment
                {
                    AllocationNumber = "ALLF-1000",
                    VersionNumber = 1,
                    DeliverableCode = 1,
                    Period = "201809"
                }
            };

            ContractAllocationActualsType allocationActuals = new ContractAllocationActualsType
            {
                ContractAllocationNumber = "ALLF-1000",
                ContractReference = new ContractReferenceType
                {
                    ContractVersionNumber = 1
                },
                ActualsSummary = new List<ActualsSummaryType>
                {
                    new ActualsSummaryType
                    {
                        DeliverableCode = 1,
                        Period = "201808",
                        ActualVolume = 5
                    },
                    new ActualsSummaryType
                    {
                        DeliverableCode = 1,
                        Period = "201809",
                        ActualVolume = 10
                    },
                    new ActualsSummaryType
                    {
                        DeliverableCode = 2,
                        Period = "201809",
                        ActualVolume = 10
                    }
                }
            };
            
            // act
            try
            {
                new ActualVolumeApplicator().MutatePaymentScheduleWithActualVolume(paymentSchedule, deliverablePayments,
                    allocationActuals);
            }
            catch (Exception)
            {
                // assert
                Assert.Fail("Exception thrown");
            }
        }

        private AllocationActualsVerified GetMessage()
        {
            return TestResource.FromJson<AllocationActualsVerified>(
                "SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests",
                "Resources.AllocationActualVerified_WithActualVolume.json");
        }
    }
}
