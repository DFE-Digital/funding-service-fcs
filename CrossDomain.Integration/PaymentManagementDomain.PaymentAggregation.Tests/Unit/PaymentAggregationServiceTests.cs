namespace SFA.FCT.PaymentManagementDomain.PaymentAggregation.Tests.Unit
{
    extern alias Entities;
    using System;
    using System.Collections.Generic;
    using BusinessLogic;
    using BusinessLogic.Services;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PaymentManagementDomain.Integration.PaymentAggregation.Services;
    using PolicyCache.DataStore.Model;
    using PolicyCache.DataStore.Repositories;
    using paymentSchedule = Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using paymentAggregation = Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;

    [TestClass]
    public class PaymentAggregationServiceTests
    {
        private Mock<IDeliverableToSubnominalService> _deliverableToSubnominalServiceMock;
        private Mock<IPayCalcPolicyQueryRepository> _payCalcPolicyQueryRepositoryMock;
        private PaymentAggregationService _paymentAggregationService;

        [TestInitialize]
        public void TestInitialize()
        {
            _deliverableToSubnominalServiceMock = new Mock<IDeliverableToSubnominalService>();
            _deliverableToSubnominalServiceMock
                .Setup(m => m.GetSubnominalValue(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(SubnominalValue.CreateNonEsf(0, 111, 123));
            
            _payCalcPolicyQueryRepositoryMock = new Mock<IPayCalcPolicyQueryRepository>();
            _payCalcPolicyQueryRepositoryMock
                .Setup(m => m.GetSubnominal(123, PaymentType.Profile, It.IsAny<ConnectionInfo>()))
                .Returns(new PolicySubnominal
                {
                    SubnominalCode = 123,
                    PaymentSubnominalDesc = "123",
                    PaymentType = PaymentType.Profile
                });
            _payCalcPolicyQueryRepositoryMock
                .Setup(m => m.GetSubnominal(123, PaymentType.Profile, It.IsAny<ConnectionInfo>()))
                .Returns(new PolicySubnominal
                {
                    SubnominalCode = 456,
                    PaymentSubnominalDesc = "456",
                    PaymentType = PaymentType.Reconciliation
                });

            _paymentAggregationService = new PaymentAggregationService(
                Mock.Of<ILogger>(),
                _deliverableToSubnominalServiceMock.Object,
                _payCalcPolicyQueryRepositoryMock.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentAggregationService_ShouldAggregatePaymentsWithValidOrganisationData()
        {
            // arrange
            paymentSchedule.Allocation allocation = new paymentSchedule.Allocation
            {
                Organisation = new paymentSchedule.Organisation
                {
                    OrganisationIdentifiers = new List<paymentSchedule.OrganisationIdentifier>
                    {
                        new paymentSchedule.OrganisationIdentifier
                        {
                            OrganisationIdentifierName = paymentSchedule.OrganisationIdentifierOrganisationIdentifierName.UKPRN
                        }
                    }
                },
                AllocationDeliverables = new List<paymentSchedule.AllocationDeliverable>
                {
                    new paymentSchedule.AllocationDeliverable
                    {
                        DeliverableCode = 1,
                        ScheduledPayments = new List<paymentSchedule.ScheduledPayment>
                        {
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "08", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "09", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "10", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "11", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "12", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "01", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "02", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "03", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "04", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "05", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "06", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "07", PeriodTypeCode = "AY"},
                        }
                    },
                    new paymentSchedule.AllocationDeliverable
                    {
                        DeliverableCode = 2,
                        ScheduledPayments = new List<paymentSchedule.ScheduledPayment>
                        {
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "08", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "09", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "10", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "11", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "12", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "01", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "02", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "03", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "04", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "05", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "06", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "07", PeriodTypeCode = "AY"},
                        }
                    }
                }
            };

            // act 
            paymentAggregation.Allocation result = _paymentAggregationService.CalculateAggregatedPayments(allocation, ConnectionInfo.CreateDefault());

            // assert
            Assert.IsNotNull(result);
            Assert.AreEqual(12, result.AllocationPeriods.Count);
            Assert.AreEqual(1, result.AllocationPeriods[0].Aggregations.Count);
            Assert.AreEqual(20, result.AllocationPeriods[0].Aggregations[0].AggregatedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentAggregationService_ShouldAggregatePaymentsWithDifferingPeriodTypeCodes()
        {
            // arrange
            paymentSchedule.Allocation allocation = new paymentSchedule.Allocation
            {
                Organisation = new paymentSchedule.Organisation
                {
                    OrganisationIdentifiers = new List<paymentSchedule.OrganisationIdentifier>
                    {
                        new paymentSchedule.OrganisationIdentifier
                        {
                            OrganisationIdentifierName = paymentSchedule.OrganisationIdentifierOrganisationIdentifierName.UKPRN
                        }
                    }
                },
                AllocationDeliverables = new List<paymentSchedule.AllocationDeliverable>
                {
                    new paymentSchedule.AllocationDeliverable
                    {
                        DeliverableCode = 2,
                        ScheduledPayments = new List<paymentSchedule.ScheduledPayment>
                        {
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "08", PeriodTypeCode = "AP"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "09", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "10", PeriodTypeCode = "CM"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "11", PeriodTypeCode = "CQ"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "12", PeriodTypeCode = "CY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "01", PeriodTypeCode = "EOF"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "02", PeriodTypeCode = "EOP"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "03", PeriodTypeCode = "ESF"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "04", PeriodTypeCode = "FP"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "05", PeriodTypeCode = "FY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "06", PeriodTypeCode = "AY"},
                            new paymentSchedule.ScheduledPayment {ProfilePaymentAmount = 10m, BalancingPaymentAmount = 0m, NetPaymentAmount = 10, Period = "07", PeriodTypeCode = "AY"},
                        }
                    }
                }
            };


            // act 
            paymentAggregation.Allocation result = _paymentAggregationService.CalculateAggregatedPayments(allocation, ConnectionInfo.CreateDefault());

            // assert
            Assert.IsNotNull(result);
            Assert.AreEqual(12, result.AllocationPeriods.Count);
            Assert.AreEqual(1, result.AllocationPeriods[0].Aggregations.Count);
            Assert.AreEqual(10, result.AllocationPeriods[0].Aggregations[0].AggregatedValue);
        }


        [TestMethod, TestCategory("UnitTest")]
        public void PaymentAggregationService_ShouldThrowExceptionWhenGivenInvalidOrganisationData()
        {
            // arrange
            var allocation = new paymentSchedule.Allocation
            {
                Organisation = new paymentSchedule.Organisation
                {
                    OrganisationIdentifiers = new List<paymentSchedule.OrganisationIdentifier>
            {
                new paymentSchedule.OrganisationIdentifier
                {
                    OrganisationIdentifierName = paymentSchedule
                        .OrganisationIdentifierOrganisationIdentifierName
                        .SECTORLEADBODY
                }
            }
                },
                AllocationDeliverables = new List<paymentSchedule.AllocationDeliverable>
        {
            new paymentSchedule.AllocationDeliverable
            {
                DeliverableCode = 2,
                ScheduledPayments = new List<paymentSchedule.ScheduledPayment>
                {
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "08", PeriodTypeCode = "AY" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "09", PeriodTypeCode = "AY" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "10", PeriodTypeCode = "AY" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "11", PeriodTypeCode = "AY" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "12", PeriodTypeCode = "AY" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "01", PeriodTypeCode = "AY" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "02", PeriodTypeCode = "AY" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "03", PeriodTypeCode = "AY" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "04", PeriodTypeCode = "AY" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "05", PeriodTypeCode = "AY" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "06", PeriodTypeCode = "AY" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "07", PeriodTypeCode = "AY" },
                }
            },
        }
            };

            // act & assert
            var ex = Assert.ThrowsExactly<System.Exception>(() =>
                _paymentAggregationService.CalculateAggregatedPayments(allocation, ConnectionInfo.CreateDefault())
            );

            // optional: assert message content for extra confidence
            Assert.Contains("Unable to translate OrgIdentifierName", ex.Message);
        }



        [TestMethod, TestCategory("UnitTest")]
        public void PaymentAggregationService_ShouldThrowExceptionWhenGivenInvalidPeriodTypeCodeInPaymentSchedule()
        {
            // arrange
            var allocation = new paymentSchedule.Allocation
            {
                Organisation = new paymentSchedule.Organisation
                {
                    OrganisationIdentifiers = new List<paymentSchedule.OrganisationIdentifier>
            {
                new paymentSchedule.OrganisationIdentifier
                {
                    OrganisationIdentifierName = paymentSchedule
                        .OrganisationIdentifierOrganisationIdentifierName
                        .UKPRN
                }
            }
                },
                AllocationDeliverables = new List<paymentSchedule.AllocationDeliverable>
        {
            new paymentSchedule.AllocationDeliverable
            {
                DeliverableCode = 2,
                ScheduledPayments = new List<paymentSchedule.ScheduledPayment>
                {
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "08", PeriodTypeCode = "AP" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "09", PeriodTypeCode = "AY" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "10", PeriodTypeCode = "CM" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "11", PeriodTypeCode = "CQ" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "12", PeriodTypeCode = "CY" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "01", PeriodTypeCode = "EOF" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "02", PeriodTypeCode = "EOP" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "03", PeriodTypeCode = "ESF" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "04", PeriodTypeCode = "FP" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "05", PeriodTypeCode = "FY" },
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "06", PeriodTypeCode = "Broken" }, // invalid
                    new paymentSchedule.ScheduledPayment { ProfilePaymentAmount = 10, Period = "07", PeriodTypeCode = "AY" },
                }
            }
        }
            };

            // act & assert
            var ex = Assert.ThrowsExactly<System.Exception>(() =>
                _paymentAggregationService.CalculateAggregatedPayments(allocation, ConnectionInfo.CreateDefault())
            );

            // optional: assert message
            Assert.Contains("Invalid periodTypeCode supplied", ex.Message);
        }

    }
}
