namespace ADMonitoringDomain.Endpoint.Tests.Integration
{
    extern alias Entities;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BusinessLogic;
    using AllocationActuals=Entities::SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using CorporatePaymentAggregation = Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;
    using DataStore;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using PaymentGenerationDomain.BusinessLogic;
    using PaymentGenerationDomain.Integration.DataStore.Repositories;
    using PaymentGenerationDomain.Integration.DataStore;
    using SFA.FCT.Framework.Logging.NullObjects;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.Common.SchemaValidator;
    using ADMonitoringDomain.Endpoint.Repositories;
    using Infrastructure;
    using Moq;
    using NServiceBus;
    using NServiceBus.Testing;
    using EntityData = Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class ContractAllocationsAtomFeedGenerationHandlerTests
    {
        private  IPaymentSchedulePolicyContext _paymentSchedulePolicyContext;
        private  IPaymentManagementPolicyContext _paymentManagementPolicyContext;
        private  IAllocationDeliveryDbContext _allocationDeliveryDbContext;
        private  IADMonitoringDeliveryEventStore _adMonitoringDeliveryEventStore;
        private IContractManagementDbContext _contractManagementDbContext;
        private  ContractAllocationsAtomFeedGenerationHandler _handler;
        private readonly string _allocationNumber = "TEST-134";
        private const int VersionNumber = 1;

        [TestInitialize]
        public void Setup()
        {
            ILogger logger = new LoggerNullObject();
            _paymentSchedulePolicyContext = new PaymentSchedulePolicyContext();
            _paymentManagementPolicyContext = new PaymentManagementPolicyContext();
            _allocationDeliveryDbContext = new AllocationDeliveryDbContext();
            _adMonitoringDeliveryEventStore = new ADMonitoringDeliveryEventStore(new AllocationDeliveryMonitoringDbContext());
            _contractManagementDbContext = new ContractManagementDbContext();
            MonitoringDeliverablesDbContext monitoringDeliverablesDbContext = new MonitoringDeliverablesDbContext();
            IRulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContext, _paymentManagementPolicyContext);
            PaymentGenerationDbContext paymentGenerationDbContext = new PaymentGenerationDbContext();
            IDataAccessManager dataAccessManager = new DataAccessManager(new SubnominalAggregationRepository(), logger);
            IAtomGenerator atomGenerator = new AtomGenerator(
                new AtomItemCreator(
                    dataAccessManager,
                    new ApprovedContractRepository(),
                    new AllocationDeliverablePeriodActualAuditRepository()))
            {
                SchemaValidator = new SchemaValidator()
            };

            var sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(EntityData.ConnectionInfo.CreateFrom(new ContractManagementDbContext().Database.Connection));

            _handler = new ContractAllocationsAtomFeedGenerationHandler(rulesEngine, atomGenerator, _adMonitoringDeliveryEventStore, sessionConnectionFactoryMock.Object)
            {
                Logger = logger
            };
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationsAtomFeedGenerationHandler_ShouldCreateAtomEntryForIPaymentPostedEvent_WhenPaymentMethodIsPayOnProfile()
        {
            SetUpData(PaymentMethod.PayOnProfile);
            var paymentPostedEvent = new PaymentPostedEvent()
            {
                Allocation = new CorporatePaymentAggregation.Allocation
                {
                    AllocationNumber = _allocationNumber,
                    VersionNumber = VersionNumber
                }
            };
           
            _handler.Handle(paymentPostedEvent, new TestableMessageHandlerContext()).Wait();

            var allocationDeliveryEntries = 
                _allocationDeliveryDbContext.AllocationDeliveryEntries.Where(a => a.AllocationNumber == _allocationNumber).ToList();

            Assert.IsTrue(allocationDeliveryEntries.Any(
                    entry => entry.GetAllocationDeliveryPerformanceXml().Contains(_allocationNumber)));
            ClearDownPolicyFundingStreamPeriod("TEST16-18APPS1516");
        }
                
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationsAtomFeedGenerationHandler_ShouldCreateAtomEntryForIPaymentPostedEvent_WhenPaymentMethodIsPayOnActuals()
        {
            SetUpData(PaymentMethod.PayOnActuals);
            var paymentPostedEvent = new PaymentPostedEvent()
            {
                Allocation = new CorporatePaymentAggregation.Allocation
                {
                    AllocationNumber = _allocationNumber,
                    VersionNumber = VersionNumber
                }
            };
            _handler.Handle(paymentPostedEvent, new TestableMessageHandlerContext()).Wait();

            var allocationDeliveryEntries =
                _allocationDeliveryDbContext.AllocationDeliveryEntries.Where(a => a.AllocationNumber == _allocationNumber).ToList();

            Assert.IsTrue(allocationDeliveryEntries.Any(
                    entry => entry.GetAllocationDeliveryPerformanceXml().Contains(_allocationNumber)));
            ClearDownPolicyFundingStreamPeriod("TEST16-18APPS1516");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationsAtomFeedGenerationHandler_ShouldCreateAtomEntryForIPaymentAggregatedEvent_WhenPaymentMethodIsPayOnActuals()
        {
            SetUpData(PaymentMethod.PayOnActuals);
            var paymentAggregatedEvent = new PaymentAggregatedEvent()
            {
                Allocation = new CorporatePaymentAggregation.Allocation
                {
                    AllocationNumber = _allocationNumber,
                    VersionNumber = VersionNumber                  
                },
                PaymentEventOrigin = PaymentEventOrigin.AllocationActualsVerified
            };
            _handler.Handle(paymentAggregatedEvent, new TestableMessageHandlerContext()).Wait();

            var allocationDeliveryEntries =
                _allocationDeliveryDbContext.AllocationDeliveryEntries.Where(a => a.AllocationNumber == _allocationNumber).ToList();

            Assert.IsTrue(allocationDeliveryEntries.Any(
                    entry => entry.GetAllocationDeliveryPerformanceXml().Contains(_allocationNumber)));
            ClearDownPolicyFundingStreamPeriod("TEST16-18APPS1516");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationsAtomFeedGenerationHandler_ShouldCreateAtomEntryForPaymentSchedule_WhenPaymentMethodIsNoPay()
        {
            SetUpData(PaymentMethod.NoPay);
            var paymentScheduleEvent = new PaymentScheduleEvent()
            {
                PaymentScheduleAllocation = new Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation
                {
                    AllocationNumber = _allocationNumber,
                    VersionNumber = VersionNumber,
                    ContractVersionNumber = VersionNumber
                },
                PaymentEventOrigin = PaymentEventOrigin.AllocationActualsVerified
            };
            _handler.Handle(paymentScheduleEvent, new TestableMessageHandlerContext()).Wait();

            var allocationDeliveryEntries =
                _allocationDeliveryDbContext.AllocationDeliveryEntries.Where(a => a.AllocationNumber == _allocationNumber).ToList();

            Assert.IsTrue(allocationDeliveryEntries.Any(
                    entry => entry.GetAllocationDeliveryPerformanceXml().Contains(_allocationNumber)));
            ClearDownPolicyFundingStreamPeriod("TEST16-18APPS1516");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAllocationsAtomFeedGenerationHandler_ShouldCreateAtomEntryForActualsVerified_WhenPaymentMethodIsPayOnProfile()
        {
            SetUpData(PaymentMethod.PayOnProfile);
            var allocationActualsVerified = new AllocationActualsVerified
            {
                AllocationActuals = new AllocationActuals.ContractAllocationActualsType
                {
                    ContractAllocationNumber = _allocationNumber,
                    ContractReference = new AllocationActuals.ContractReferenceType
                    {
                        ContractVersionNumber = VersionNumber
                    }
                }
            };
            _handler.Handle(allocationActualsVerified, new TestableMessageHandlerContext()).Wait();

            var allocationDeliveryEntries =
                _allocationDeliveryDbContext.AllocationDeliveryEntries.Where(a => a.AllocationNumber == _allocationNumber).ToList();

            Assert.IsTrue(allocationDeliveryEntries.Any(
                entry => entry.GetAllocationDeliveryPerformanceXml().Contains(_allocationNumber)));
            ClearDownPolicyFundingStreamPeriod("TEST16-18APPS1516");
        }

        private void SetUpData(PaymentMethod paymentMethod)
        {
            const string orgId = "ORG1234567";
            const int ukprn = 12345678;
            const string contractNumber = "MAIN-123";

            try
            {
                ((PaymentSchedulePolicyContext) _paymentSchedulePolicyContext).Database
                    .ExecuteSqlCommand($@"delete from [PaymentSchedule].[OrganisationIdentifer] where[OrganisationId] = '{orgId}' ");

                var allocation = _paymentSchedulePolicyContext.Allocations.SingleOrDefault(
                    alloc => alloc.AllocationNumber == _allocationNumber && alloc.VersionNumber == VersionNumber);

                _paymentSchedulePolicyContext.DeliverablePayments.RemoveWhere(
                        payment => payment.AllocationNumber == _allocationNumber);

                _paymentSchedulePolicyContext.OrganisationIdentifiers.RemoveWhere(
                        org => org.OrganisationId == orgId);

                if (allocation != null)
                {
                    _paymentSchedulePolicyContext.Allocations.Remove(allocation);
                }

                _paymentSchedulePolicyContext.Allocations.Add(
                    new SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model.Allocation
                    {
                        AllocationNumber = _allocationNumber,
                        VersionNumber = 1,
                        FundingStreamPeriodCode = "TEST16-18APPS1516",
                        ContractNumber = contractNumber,
                        ContractVersionNumber = VersionNumber
                    });

                _paymentSchedulePolicyContext.DeliverablePayments.Add(
                    new SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model.DeliverablePayment()
                    {
                        AllocationNumber = _allocationNumber,
                        VersionNumber = 1,
                        DeliverableCode = 1,
                        Period = "201608",
                        PlannedValue = 100
                    }
                    );

                var fundingStreamPeriod = _paymentManagementPolicyContext.PolicyFundingStreamPeriods.SingleOrDefault(
                    fsp => fsp.FundingStreamPeriod == "TEST16-18APPS1516");
                if (fundingStreamPeriod != null)
                {
                    _paymentManagementPolicyContext.PolicyFundingStreamPeriods.Remove(fundingStreamPeriod);
                }
                _paymentManagementPolicyContext.PolicyFundingStreamPeriods.Add(new PolicyFundingStreamPeriod
                {
                    FundingStreamPeriod = "TEST16-18APPS1516",
                    PaymentMethod = paymentMethod
                });

                var fundingTypeFundingPeriod = _contractManagementDbContext.FundingTypeFundingPeriodItems.First();

                ClearDownDataForContractNumbers(new[] { contractNumber });

                ApprovedContract contract = new ApprovedContract(
                    contractNumber, 
                    1, 
                    0, 
                    fundingTypeFundingPeriod.FundingTypeCode, 
                    fundingTypeFundingPeriod.FundingPeriodName,
                    ukprn,
                    orgId,
                    string.Empty,
                    DateTime.Now.AddDays(7).Date, 
                    DateTime.Now.AddYears(1).Date)
                {
                    ApprovedContractAllocations = new List<ApprovedContractAllocation>
                    {
                        new ApprovedContractAllocation
                        {
                            ContractAllocationNumber = _allocationNumber,
                            DeliveryOrganisationUkprn = 87654321,
                            DeliveryOrganisationId = "ORG7654321"
                        }
                    }
                };

                _contractManagementDbContext.ApprovedContracts.Add(contract);

                _paymentSchedulePolicyContext.SaveChanges();
                _paymentManagementPolicyContext.SaveChanges();
                _contractManagementDbContext.SaveChanges();
            }
            catch (Exception e)
            {
                Assert.Fail(e.Message);
            }
            
        }

        private void ClearDownDataForContractNumbers(string[] contractNumbers)
        {
            var contractIdsToDelete = _contractManagementDbContext.ApprovedContracts.Where(c => contractNumbers.Contains(c.ContractNumber)).Select(c => c.ApprovedContractId).ToList();
            _contractManagementDbContext.ApprovedContracts.RemoveWhere(c => contractIdsToDelete.Contains(c.ApprovedContractId));
            _contractManagementDbContext.ApprovedContractAllocations.RemoveWhere(ca => contractIdsToDelete.Contains(ca.ApprovedContractId));
            _contractManagementDbContext.SaveChanges();
        }

        private void ClearDownPolicyFundingStreamPeriod(string FundingStreamPeriodCode)
        {
            var fundingStreamPeriod = _paymentManagementPolicyContext.PolicyFundingStreamPeriods.SingleOrDefault(
                fsp => fsp.FundingStreamPeriod == FundingStreamPeriodCode);
            if (fundingStreamPeriod != null)
            {
                _paymentManagementPolicyContext.PolicyFundingStreamPeriods.Remove(fundingStreamPeriod);
                _paymentManagementPolicyContext.SaveChanges();
            }
        }
    }
}
