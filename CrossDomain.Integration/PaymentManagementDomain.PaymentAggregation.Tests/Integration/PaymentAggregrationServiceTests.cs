namespace SFA.FCT.PaymentManagementDomain.PaymentAggregation.Tests.Integration
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using AllocationDeliveryDomain.Common.DataStore;
    using AllocationDeliveryDomain.Common.DataStore.Model;
    using BusinessLogic;
    using BusinessLogic.Services;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PaymentManagementDomain.Integration.PaymentAggregation.Services;
    using PolicyCache.DataStore;
    using PolicyCache.DataStore.Model;
    using PolicyCache.DataStore.Repositories;
    using UnitTests.Common;

    [TestClass]
    public class PaymentAggregrationServiceTests
    {
        private Mock<IPaymentManagementPolicyContext> _paymentManagementPolicyContextMock;
        private Mock<IMonitoringDeliverablesDbContext> _monitoringDeliverablesDbMock;
        private PaymentAggregationService _paymentAggregationService;
        private Mock<IDeliverableToSubnominalService> _deliverableToSubnominalService;
        private Mock<IPayCalcPolicyQueryRepository> _payCalcPolicyQueryRepositoryMock;
        private const RegionType RegionTypeTest = RegionType.LessDeveloped;
        private const int SubnominalCodeTest = 12345678;
        private const string EsfContractNumberTest = "CN";
        private const string EsfContractAllocationNumberTest = "AN";

        [TestInitialize]
        public void TestInitialize()
        {
            _paymentManagementPolicyContextMock = new Mock<IPaymentManagementPolicyContext>();
            _paymentManagementPolicyContextMock
                .Setup(m => m.ESFRegionInvestmentPriorities)
                .Returns(CreatePolicyFundingStreamPeriodSubnominals);
            _paymentManagementPolicyContextMock
                .Setup(m => m.PolicyDeliverableToSubnominals)
                .Returns(CreatePolicyDeliverableToSubnominals());

            _deliverableToSubnominalService = new Mock<IDeliverableToSubnominalService>();
            _deliverableToSubnominalService
                .Setup(m => m.GetSubnominalValue(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(SubnominalValue.CreateNonEsf(1111, 2222, 123));

            _monitoringDeliverablesDbMock = new Mock<IMonitoringDeliverablesDbContext>();
            _monitoringDeliverablesDbMock
                .Setup(m => m.ESFAllocationData)
                .Returns(CreateEsfAllocationData());

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
                .Setup(m => m.GetSubnominal(456, PaymentType.Profile, It.IsAny<ConnectionInfo>()))
                .Returns(new PolicySubnominal
                {
                    SubnominalCode = 456,
                    PaymentSubnominalDesc = "456",
                    PaymentType = PaymentType.Profile
                });
            _payCalcPolicyQueryRepositoryMock
                .Setup(m => m.GetSubnominal(12345678, PaymentType.Reconciliation, It.IsAny<ConnectionInfo>()))
                .Returns(new PolicySubnominal
                {
                    SubnominalCode = 12345678,
                    PaymentSubnominalDesc = "12345678",
                    PaymentType = PaymentType.Reconciliation
                });

            _paymentAggregationService = new PaymentAggregationService(
                Mock.Of<ILogger>(),
                new DeliverableToSubnominalService(_paymentManagementPolicyContextMock.Object, _monitoringDeliverablesDbMock.Object),
                _payCalcPolicyQueryRepositoryMock.Object);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentAggregationService_ShouldReturnPaymentAggregration()
        {
            //Arrange
            Allocation allocation = PopulateAllocation();

            //Act 
            var result = _paymentAggregationService.CalculateAggregatedPayments(allocation, ConnectionInfo.CreateDefault());

            //Assert
            Assert.IsNotNull(result);
            Assert.IsTrue(result.AllocationNumber == "SFA-XXX");
            Assert.IsTrue(result.AllocationPeriods.Count == 1);
            Assert.IsTrue(result.AllocationPeriods[0].Aggregations.Count == 1);
            Assert.IsTrue(result.AllocationPeriods[0].Aggregations[0].AggregatedValue == 42);
            Assert.IsTrue(result.AllocationPeriods[0].Aggregations[0].DeliverableDetails.Count == 2);
            Assert.IsTrue(result.AllocationPeriods[0].Aggregations[0].DeliverableDetails[0].DeliverableCode == 1);
            Assert.IsTrue(result.AllocationPeriods[0].Aggregations[0].DeliverableDetails[1].DeliverableCode == 2);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentAggregationService_ShouldAggregatePaymentsUsingDeliverableToSubnominalServiceForNonEsfAllocation()
        {
            //Arrange
            Allocation allocation = PopulateAllocation();
            
            //Act 
            var result = _paymentAggregationService.CalculateAggregatedPayments(allocation, ConnectionInfo.CreateDefault());

            //Assert
            Assert.IsNotNull(result);
            Assert.IsTrue(result.AllocationNumber == "SFA-XXX");
            Assert.IsTrue(result.AllocationPeriods.Count == 1);
            Assert.IsTrue(result.AllocationPeriods[0].Aggregations.Count == 1);
            Assert.IsTrue(result.AllocationPeriods[0].Aggregations[0].AggregatedValue == 42);
            Assert.IsTrue(result.AllocationPeriods[0].Aggregations[0].DeliverableDetails.Count == 2);
            Assert.IsTrue(result.AllocationPeriods[0].Aggregations[0].DeliverableDetails[0].DeliverableCode == 1);
            Assert.IsTrue(result.AllocationPeriods[0].Aggregations[0].DeliverableDetails[1].DeliverableCode == 2);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentAggregationService_ShouldAggregatePaymentsUsingDeliverableToSubnominalServiceForEsfAllocation()
        {
            //Arrange
            Allocation allocation = PopulateEsfAllocation();
            
            //Act 
            var result = _paymentAggregationService.CalculateAggregatedPayments(allocation, ConnectionInfo.CreateDefault());

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(EsfContractAllocationNumberTest, result.AllocationNumber, "Allocation number set incorrectly");
            Assert.AreEqual(1, result.AllocationPeriods.Count, "Incorrect number of allocation periods");
            Assert.AreEqual(1, result.AllocationPeriods[0].Aggregations.Count, "Incorrect number of aggregations");
            Assert.AreEqual(21, result.AllocationPeriods[0].Aggregations[0].AggregatedValue, "Aggregated value is incorrect");
            Assert.AreEqual(2, result.AllocationPeriods[0].Aggregations[0].DeliverableDetails.Count, "DeliverableDetails count is incorrect");
            Assert.AreEqual(1, result.AllocationPeriods[0].Aggregations[0].DeliverableDetails[0].DeliverableCode, "Deliverable one deliverable code is incorrect");
            Assert.AreEqual(2, result.AllocationPeriods[0].Aggregations[0].DeliverableDetails[1].DeliverableCode, "Deliverable two deliverable code is incorrect");
        }

        private static DbSet<EsfAllocationData> CreateEsfAllocationData()
        {
            return new[]
            {
                new EsfAllocationData
                {
                    ContractNumber = EsfContractNumberTest,
                    ContractAllocationNumber = EsfContractAllocationNumberTest,
                    InvestmentPriority = "1.1 some stuff",
                    RegionType = RegionTypeTest.ToString()
                }

            }.ToMockDbSet().Object;
        }

        private static IDbSet<ESFRegionInvestmentPriority> CreatePolicyFundingStreamPeriodSubnominals()
        {
            return new[]
            {
                new ESFRegionInvestmentPriority(RegionType.MoreDeveloped, 1.1m, 98765.ToString()),
                new ESFRegionInvestmentPriority(RegionTypeTest, 1.1m, SubnominalCodeTest.ToString()),
                new ESFRegionInvestmentPriority(RegionType.Transition, 1.1m, 987654321.ToString()),

            }.ToMockDbSet().Object;
        }

        private static Allocation PopulateAllocation()
        {
            return new Allocation
            {
                AllocationNumber = "SFA-XXX",
                VersionNumber = 1,
                FundingStreamPeriodCode = "ASC1516",
                Organisation = new Organisation()
                {
                    MainOrganisationIdentifier = "Main",
                    OrganisationIdentifiers = new List<OrganisationIdentifier>()
                  {
                      new OrganisationIdentifier()
                      {
                          OrganisationId = "Main-902",
                          OrganisationIdentifierName = OrganisationIdentifierOrganisationIdentifierName.UKPRN
                      }
                  }
                },
                AllocationDeliverables = new List<AllocationDeliverable>()
                {
                  new AllocationDeliverable()
                  {
                      DeliverableCode = 1,
                      ScheduledPayments = new List<ScheduledPayment>()
                      {
                          new ScheduledPayment()
                          {
                              ActualValue = (decimal) 10.00,
                              ActualVolume = 200,
                              BalancingPaymentAmount = (decimal) 10.00,
                              ProfilePaymentAmount = (decimal) 10.00,
                              PeriodTypeCode = "AY",
                              Period = "AUG-15",
                              NetPaymentAmount = (decimal) 20.00
                          }
                      }
                  },
                  new AllocationDeliverable()
                  {
                      DeliverableCode = 2,
                      ScheduledPayments = new List<ScheduledPayment>()
                      {
                          new ScheduledPayment()
                          {
                              ActualValue = (decimal) 11.00,
                              ActualVolume = 200,
                              BalancingPaymentAmount = (decimal) 11.00,
                              ProfilePaymentAmount = (decimal) 11.00,
                              PeriodTypeCode = "AY",
                              Period = "AUG-15",
                              NetPaymentAmount = (decimal) 22.00
                          }
                      }
                  }
              }
            };
        }

        private static Allocation PopulateEsfAllocation()
        {
            return new Allocation
            {
                AllocationNumber = EsfContractAllocationNumberTest,
                ContractNumber = EsfContractNumberTest,
                VersionNumber = 1,
                FundingStreamPeriodCode = "ESF1420",
                Organisation = new Organisation
                {
                    MainOrganisationIdentifier = "ESF",
                    OrganisationIdentifiers = new List<OrganisationIdentifier>
                  {
                      new OrganisationIdentifier
                      {
                          OrganisationId = "ESF-902",
                          OrganisationIdentifierName = OrganisationIdentifierOrganisationIdentifierName.UKPRN
                      }
                  }
                },
                AllocationDeliverables = new List<AllocationDeliverable>
                {
                  new AllocationDeliverable
                  {
                      DeliverableCode = 1,
                      ScheduledPayments = new List<ScheduledPayment>
                      {
                          new ScheduledPayment
                          {
                              ActualValue = (decimal) 10.00,
                              ActualVolume = 200,
                              BalancingPaymentAmount = (decimal) 10.00,
                              ReconciliationPaymentAmount = (decimal) 10.00,
                              PeriodTypeCode = "AY",
                              Period = "AUG-15",
                              NetPaymentAmount = (decimal) 10.00
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
                              ActualValue = (decimal) 11.00,
                              ActualVolume = 200,
                              BalancingPaymentAmount = (decimal) 11.00,
                              ReconciliationPaymentAmount = (decimal) 11.00,
                              PeriodTypeCode = "AY",
                              Period = "AUG-15",
                              NetPaymentAmount = (decimal) 11.00
                          }
                      }
                  }
              }
            };
        }

        private static DbSet<PolicyDeliverableToSubnominals> CreatePolicyDeliverableToSubnominals()
        {
            return new[]
            {
                new PolicyDeliverableToSubnominals
                {
                    DeliverableCode = 1,
                    FundingStreamPeriod = "ASC1516",
                    PaymentType = PaymentType.Profile,
                    SubnominalCode = 123
                },
                new PolicyDeliverableToSubnominals
                {
                    DeliverableCode = 2,
                    FundingStreamPeriod = "ASC1516",
                    PaymentType = PaymentType.Profile,
                    SubnominalCode = 123
                },
                new PolicyDeliverableToSubnominals
                {
                    DeliverableCode = 3,
                    FundingStreamPeriod = "ASC1516",
                    PaymentType = PaymentType.Profile,
                    SubnominalCode = 456
                },
                new PolicyDeliverableToSubnominals
                {
                    DeliverableCode = 4,
                    FundingStreamPeriod = "ASC1516",
                    PaymentType = PaymentType.Profile,
                    SubnominalCode = 789
                }
            }.ToMockDbSet().Object;
        }
    }
}
