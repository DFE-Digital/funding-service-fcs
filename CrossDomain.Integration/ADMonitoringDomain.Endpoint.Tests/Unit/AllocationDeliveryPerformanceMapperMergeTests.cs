extern alias Entities;

namespace ADMonitoringDomain.Endpoint.Tests.Unit
{

    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml.Schema;
    using BusinessLogic;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Common.SchemaValidator;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Allocation = Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation;
    using AggregatedAllocation = Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation;

    [TestClass]
    public class AllocationDeliveryPerformanceMapperMergeTests
    {
        private const string AllocationNumber = "ALL-1";

        private Mock<ISchemaValidator> _validator;
        private Mock<ILogger> _logger;
        private Mock<IApprovedContractRepository> _repository;
        private AllocationDeliveryPerformanceMapper _mapper;

        [TestInitialize]
        public void Setup()
        {
            _validator = new Mock<ISchemaValidator>();
            _validator.Setup(v => v.ValidateAgainstSchema(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new SchemaValidatorResultset(true, new List<string>()));
            _logger = new Mock<ILogger>();

            var approvedContract = new ApprovedContract("", 0, 0, "", "", 1234, "ORG1", string.Empty, DateTime.Now.Date, DateTime.Now.AddYears(1).Date)
            {
                ApprovedContractAllocations = new List<ApprovedContractAllocation>
                {
                    new ApprovedContractAllocation { ContractAllocationNumber = AllocationNumber }
                }
            };
            _repository = new Mock<IApprovedContractRepository>();
            _repository.Setup(r => r.GetContractForAllocationNumber(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(approvedContract);

            _mapper = new AllocationDeliveryPerformanceMapper(_repository.Object)
            {
                SchemaValidator = _validator.Object,
                Logger = _logger.Object
            };
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Map_WithPaymentSchedule_GroupsPaymentsByPeriodAndDefaultsNullAmounts()
        {
            var scheduleEvent = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Allocation
                {
                    AllocationNumber = AllocationNumber,
                    AllocationDeliverables = new List<AllocationDeliverable>
                    {
                        new AllocationDeliverable
                        {
                            DeliverableCode = 1,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                                new ScheduledPayment { Period = "201608", NetPaymentAmount = 10m, ProfilePaymentAmount = 8m, CappedPaymentAmount = 1m, BalancingPaymentAmount = 2m, ReconciliationPaymentAmount = 3m },
                                new ScheduledPayment { Period = "201609", NetPaymentAmount = 20m }
                            }
                        },
                        new AllocationDeliverable
                        {
                            DeliverableCode = 2,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                                new ScheduledPayment { Period = "201608", NetPaymentAmount = 5m }
                            }
                        }
                    }
                }
            };

            var result = _mapper.Map(CreateCommencedEvent(), scheduleEvent, null, ConnectionInfo.CreateDefault());

            Assert.AreEqual(2, result.ScheduledPaymentPeriods.Count);
            var aug = result.ScheduledPaymentPeriods.Single(p => p.Period == "201608");
            Assert.AreEqual(2, aug.ScheduledPayment.Count);
            var first = aug.ScheduledPayment.Single(p => p.DeliverableCode == 1);
            Assert.AreEqual(10m, first.NetPayment);
            Assert.AreEqual(8m, first.ProfilePayment);
            Assert.AreEqual(1m, first.CappingPayment);
            Assert.AreEqual(2m, first.BalancingPayment);
            Assert.AreEqual(3m, first.ReconciliationPayment);
            var sep = result.ScheduledPaymentPeriods.Single(p => p.Period == "201609").ScheduledPayment.Single();
            Assert.AreEqual(0m, sep.ProfilePayment);
            Assert.AreEqual(0m, sep.CappingPayment);
            Assert.AreEqual(0m, sep.BalancingPayment);
            Assert.AreEqual(0m, sep.ReconciliationPayment);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Map_WithMalformedPaymentSchedule_LogsAndRethrows()
        {
            var scheduleEvent = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Allocation { AllocationNumber = AllocationNumber, AllocationDeliverables = null }
            };

            try
            {
                _mapper.Map(CreateCommencedEvent(), scheduleEvent, null, ConnectionInfo.CreateDefault());
                Assert.Fail("Expected exception");
            }
            catch (ArgumentNullException)
            {
            }

            _logger.Verify(l => l.LogError(It.IsAny<int>(), It.IsAny<Exception>(), It.Is<string>(m => m.Contains("PaymentScheduleEvent")), It.IsAny<object[]>()), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Map_WithAggregatedPayments_MapsPeriodsPaymentsAndPostedFlag()
        {
            var aggregatedEvent = new PaymentAggregatedEvent
            {
                Allocation = new AggregatedAllocation
                {
                    AllocationNumber = AllocationNumber,
                    AllocationPeriods = new List<AllocationPeriod>
                    {
                        new AllocationPeriod
                        {
                            Period = "201608",
                            PeriodTypeCode = AllocationPeriodPeriodTypeCode.AY,
                            Aggregations = new List<Aggregation>
                            {
                                CreateAggregation(AggregationPaymentType.PROFILE, "SN1", 100m, true, 7, 8),
                                CreateAggregation(AggregationPaymentType.CAPPING, "SN2", -5m, true, 7)
                            }
                        },
                        new AllocationPeriod
                        {
                            Period = "201609",
                            PeriodTypeCode = AllocationPeriodPeriodTypeCode.AY,
                            Aggregations = new List<Aggregation>
                            {
                                CreateAggregation(AggregationPaymentType.PROFILE, "SN1", 50m, true, 7),
                                CreateAggregation(AggregationPaymentType.RECONCILIATION, "SN3", 1m, false, 9)
                            }
                        }
                    }
                }
            };

            var result = _mapper.Map(CreateCommencedEvent(), null, aggregatedEvent, ConnectionInfo.CreateDefault());

            Assert.AreEqual(periodTypeCodeLIST.AY, result.PaymentPeriodTypeCode);
            Assert.AreEqual(2, result.AggregatedPaymentPeriods.Count);
            var first = result.AggregatedPaymentPeriods[0];
            Assert.IsTrue(first.PaymentPosted);
            Assert.AreEqual(2, first.AggregatedPayment.Count);
            Assert.AreEqual(PaymentTypeTYPE.PROFILE, first.AggregatedPayment[0].PaymentTYPE);
            Assert.AreEqual(100m, first.AggregatedPayment[0].AggregatedValue);
            Assert.AreEqual("SN1", first.AggregatedPayment[0].SubnominalCode);
            CollectionAssert.AreEqual(new[] { 7, 8 }, first.AggregatedPayment[0].Deliverables.ToArray());
            Assert.IsFalse(result.AggregatedPaymentPeriods[1].PaymentPosted);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Map_WithAggregatedPaymentsOfMixedPeriodTypes_ThrowsAndLogs()
        {
            var aggregatedEvent = new PaymentAggregatedEvent
            {
                Allocation = new AggregatedAllocation
                {
                    AllocationNumber = AllocationNumber,
                    AllocationPeriods = new List<AllocationPeriod>
                    {
                        new AllocationPeriod { Period = "201608", PeriodTypeCode = AllocationPeriodPeriodTypeCode.AY, Aggregations = new List<Aggregation>() },
                        new AllocationPeriod { Period = "201609", PeriodTypeCode = AllocationPeriodPeriodTypeCode.FY, Aggregations = new List<Aggregation>() }
                    }
                }
            };

            try
            {
                _mapper.Map(CreateCommencedEvent(), null, aggregatedEvent, ConnectionInfo.CreateDefault());
                Assert.Fail("Expected exception");
            }
            catch (PaymentPeriodTypeCodeMixedException ex)
            {
                StringAssert.Contains(ex.Message, "201609");
            }

            _logger.Verify(l => l.LogError(It.IsAny<int>(), It.IsAny<Exception>(), It.Is<string>(m => m.Contains("PaymentAggregatedEvent")), It.IsAny<object[]>()), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Map_WithAggregatedPaymentsAndNoPeriods_ReturnsEmptyPeriodList()
        {
            var aggregatedEvent = new PaymentAggregatedEvent
            {
                Allocation = new AggregatedAllocation { AllocationNumber = AllocationNumber, AllocationPeriods = new List<AllocationPeriod>() }
            };

            var result = _mapper.Map(CreateCommencedEvent(), null, aggregatedEvent, ConnectionInfo.CreateDefault());

            Assert.AreEqual(0, result.AggregatedPaymentPeriods.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Map_WhenSchemaValidationFails_ThrowsXmlSchemaValidationExceptionWithErrors()
        {
            _validator.Setup(v => v.ValidateAgainstSchema(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new SchemaValidatorResultset(false, new List<string> { "bad-one", "bad-two" }));

            try
            {
                _mapper.Map(CreateCommencedEvent(), ConnectionInfo.CreateDefault());
                Assert.Fail("Expected exception");
            }
            catch (XmlSchemaValidationException ex)
            {
                Assert.AreEqual("bad-one,bad-two", ex.InnerException.Message);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Map_WhenContractLookupFails_LogsAndRethrows()
        {
            _repository.Setup(r => r.GetContractForAllocationNumber(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Throws(new InvalidOperationException("db down"));

            try
            {
                _mapper.Map(CreateCommencedEvent(), ConnectionInfo.CreateDefault());
                Assert.Fail("Expected exception");
            }
            catch (InvalidOperationException ex)
            {
                Assert.AreEqual("db down", ex.Message);
            }

            _logger.Verify(l => l.LogError(It.IsAny<int>(), It.IsAny<Exception>(), It.Is<string>(m => m.Contains("AllocationDeliveryCommencedEvent")), It.IsAny<object[]>()), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Map_WithNestedDeliverables_MapsChildDeliverablesRecursively()
        {
            var commenced = CreateCommencedEvent();
            commenced.Allocation.contractDeliverables[0].contractDeliverables = new List<contractDeliverableType>
            {
                new contractDeliverableType
                {
                    deliverable = new deliverableType { deliverableCode = 99, isLegal = false, isMonitoring = true },
                    contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                    {
                        new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = new periodType { periodValue = "201609" }, plannedValue = 4m, plannedVolume = 2 }
                    }
                }
            };

            var result = _mapper.Map(commenced, ConnectionInfo.CreateDefault());

            var child = result.ContractDeliverables.Single().ContractDeliverables.Single();
            Assert.AreEqual(99, child.DeliverableCode);
            Assert.IsFalse(child.isLegal);
            Assert.AreEqual("201609", child.ContractDeliverablePeriods.Single().Period);
            Assert.AreEqual(2, child.ContractDeliverablePeriods.Single().PlannedVolume);
        }

        private static Aggregation CreateAggregation(AggregationPaymentType type, string subnominal, decimal value, bool posted, params int[] deliverables)
        {
            return new Aggregation
            {
                PaymentType = type,
                SubnominalCode = subnominal,
                AggregatedValue = value,
                PostedFlag = posted,
                DeliverableDetails = deliverables.Select(d => new DeliverableDetail { DeliverableCode = d }).ToList()
            };
        }

        private static AllocationDeliveryCommencedEvent CreateCommencedEvent()
        {
            return new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractAllocationNumber = AllocationNumber,
                    contractReference = new contractReferenceType { contractNumber = "CON-1", contractVersionNumber = 1 },
                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = "FSP1",
                        period = new periodType { periodType1 = new periodTypeType { periodTypeCode = periodTypeCodeType.AY } }
                    },
                    uopCode = "4",
                    contractDeliverables = new List<contractDeliverableType>
                    {
                        new contractDeliverableType
                        {
                            deliverable = new deliverableType { deliverableCode = 1, isLegal = true, isMonitoring = true },
                            contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>()
                        }
                    }
                }
            };
        }
    }
}
