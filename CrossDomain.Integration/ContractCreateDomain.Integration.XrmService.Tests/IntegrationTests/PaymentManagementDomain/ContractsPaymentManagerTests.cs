namespace ContractCreateDomain.Integration.XrmService.Tests.IntegrationTests.PaymentManagementDomain
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using IntegrationTests;
    using IoC;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;
    using UnitTests.Common;
    using XrmTestModel;
    using XrmTestModel.XrmObjects;

    [TestClass]
    public class ContractsPaymentManagerTests : IntegrationTestBase
    {
        private const string AllocationNumber = "16AP-8999";
        private const string Ukprn = "888999";
        private const string MasterContractNumber = "SFA-888999";
        private const string ContractNumber = "MAIN-888999";
        private const string PersistAllocationActualsInCrmOrg = "PersistActuals In Crm Org";
        private readonly List<XrmOrganisation> _orgs = new List<XrmOrganisation>();
        private readonly List<XrmContract> _contracts = new List<XrmContract>();
        private static readonly DateTime AllocationStartDateTest = new DateTime(2015,1,1);
        private static readonly DateTime AllocationEndDateTest = new DateTime(2015, 12, 31);
        private const string PeriodOutsideBounds = "201602";
        private IWindsorContainer _container;

        [TestInitialize]
        public void SetupIoC()
        {
            RemoveMasterAndChildContracts(MasterContractNumber);
            _container = Bootstrapper.CreateContainer();
        }

        [TestCleanup]
        public void TestCleanup()
        {
            _contracts.ForEach(c => ActionRetrier.RetryWhenExceptionThrown(c.Delete));
            _orgs.ForEach(o => o.Delete());
        }

        [TestMethod, TestCategory("IntegrationTestNightlyBuild")]
        public void ContractsPaymentManager_CreateMissingDeliverablePeriodsOutsideOfTheBoundsOfTheAllocation_ShouldAddMissingDeliverablesThatAreOutsideTheBoundsOfTheAllocation()
        {
            // Arrange
            var org = _container.Resolve<XrmOrganisation>();
            org.Ukprn = Ukprn;

            org.OrganisationName = PersistAllocationActualsInCrmOrg + " " + Ukprn;
            org.Save();
            _orgs.Add(org);

            var caseload = _container.Resolve<XrmCaseload>();
            caseload.Organisation = org;
            caseload.Save();
            const int numPeriodsOnContract = 4; 

            var contract = CreateXrmContract(MasterContractNumber, ContractNumber, Ukprn, AllocationNumber, 1, numPeriodsOnContract);

            contract.Item1.Save();

            _contracts.Add(contract.Item2);
            _contracts.Add(contract.Item1);

            // Act
            IContractsPaymentManager contractPaymentManager = new ContractsPaymentManager(Mock.Of<ILogger>(), CrmOrganizationService)
            {
                AllocationNumber = AllocationNumber,
                ContractNumber = ContractNumber,
                ContractVersionNumber = 1
            };

            Allocation allocation = CreatePaymentScheduleAllocation();
            CrmAllocationRepository repository = new CrmAllocationRepository(CrmOrganizationService);
            var allocationInfo = repository.GetAllocationInfoFromCrm(AllocationNumber, 1);
            IReadOnlyCollection<DeliverableInfo> deliverableInfos = repository.GetContractDeliverablesForAllocation(allocationInfo.AllocationId);
            CrmDeliverablePeriodRepository deliverablePeriodRepository = new CrmDeliverablePeriodRepository(CrmOrganizationService);
            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYears = deliverablePeriodRepository.GetDeliverablePeriodYears(allocationInfo.AllocationId);

            contractPaymentManager.CreateMissingDeliverablePeriodsOutsideOfTheBoundsOfTheAllocation(allocation, allocationInfo, deliverableInfos, deliverablePeriodYears);

            // Assert period added an populated correctly to each deliverable
            var allocationGuid = GetAllocationIdFromCrm(AllocationNumber, 1);
            AssertDeliverablePeriodsForDelivarable(allocationGuid, 1, numPeriodsOnContract);
            AssertDeliverablePeriodsForDelivarable(allocationGuid, 2, numPeriodsOnContract);
            AssertDeliverablePeriodsForDelivarable(allocationGuid, 3, numPeriodsOnContract);
        }

        [TestMethod, TestCategory("IntegrationTestNightlyBuild")]
        public void ContractsPaymentManager_CreateMissingDeliverablePeriodsOutsideOfTheBoundsOfTheAllocation_ShouldNotAddDeliverablesWhenPayScheduleIsWithinTheBoundsOfTheContract()
        {
            // Arrange
            var org = _container.Resolve<XrmOrganisation>();
            org.Ukprn = Ukprn;

            org.OrganisationName = PersistAllocationActualsInCrmOrg + " " + Ukprn;
            org.Save();
            _orgs.Add(org);

            var caseload = _container.Resolve<XrmCaseload>();
            caseload.Organisation = org;
            caseload.Save();
            const int numPeriodsOnContract = 4;

            var contract = CreateXrmContract(MasterContractNumber, ContractNumber, Ukprn, AllocationNumber, 1, numPeriodsOnContract);

            var masterContract = contract.Item1;
            contract.Item1.Save();

            _contracts.Add(contract.Item2);
            _contracts.Add(contract.Item1);

            IContractsPaymentManager contractPaymentManager = new ContractsPaymentManager(Mock.Of<ILogger>(), CrmOrganizationService)
            {
                AllocationNumber = AllocationNumber,
                ContractNumber = ContractNumber,
                ContractVersionNumber = 1
            };

            Allocation allocation = CreatePaymentScheduleAllocation();

            allocation.AllocationDeliverables.ForEach(ad => ad.ScheduledPayments.RemoveAll(sp => sp.Period == PeriodOutsideBounds));
            CrmAllocationRepository repository = new CrmAllocationRepository(CrmOrganizationService);
            var allocationInfo = repository.GetAllocationInfoFromCrm(AllocationNumber, 1);
            IReadOnlyCollection<DeliverableInfo> deliverableInfos = repository.GetContractDeliverablesForAllocation(allocationInfo.AllocationId);
            CrmDeliverablePeriodRepository deliverablePeriodRepository = new CrmDeliverablePeriodRepository(CrmOrganizationService);
            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYears = deliverablePeriodRepository.GetDeliverablePeriodYears(allocationInfo.AllocationId);

            // act
            contractPaymentManager.CreateMissingDeliverablePeriodsOutsideOfTheBoundsOfTheAllocation(allocation, allocationInfo, deliverableInfos, deliverablePeriodYears);

            // assert
            var allocationGuid = GetAllocationIdFromCrm(AllocationNumber, 1);

            IReadOnlyCollection<sfa_contractdeliverableperiod> contractdeliverableperiods = GetDeliverablePeriodsForAllocationAndCode(allocationGuid, 1);

            Assert.AreEqual(numPeriodsOnContract, contractdeliverableperiods.Count);
        }

        private static IReadOnlyCollection<sfa_contractdeliverableperiod> GetDeliverablePeriodsForAllocationAndCode(Guid allocationId, int deliverableCode)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                // Get deliverable periods
                return (from d in xrmContext.sfa_contractdeliverableSet
                    join cdp in xrmContext.sfa_contractdeliverableperiodSet on
                        d.sfa_contractdeliverableId
                        equals
                        cdp.sfa_ContractDeliverableId.Id
                    where
                        d.sfa_ContractAllocationId.Id == allocationId &&
                        d.sfa_DeliverableCode == deliverableCode.ToString()
                    select cdp).ToList();
            }
        }

        private static void AssertDeliverablePeriodsForDelivarable(Guid allocationId, int deliverableCode, int numPeriodsOnContract)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                // Get deliverable periods
                var periodData = (from d in xrmContext.sfa_contractdeliverableSet
                    join cdp in xrmContext.sfa_contractdeliverableperiodSet on
                        d.sfa_contractdeliverableId
                        equals
                        cdp.sfa_ContractDeliverableId.Id
                    where
                        d.sfa_ContractAllocationId.Id == allocationId &&
                        d.sfa_DeliverableCode == deliverableCode.ToString()
                    select cdp).ToList();

                var deliverable = (from d in xrmContext.sfa_contractdeliverableSet
                                where
                                    d.sfa_ContractAllocationId.Id == allocationId &&
                                    d.sfa_DeliverableCode == deliverableCode.ToString()
                                select d).FirstOrDefault();

                Assert.AreEqual(numPeriodsOnContract + 1, periodData.Count, $"There number of deliverable periods on the contract is wrong");

                // Order by diplay order and get the last deliverable period to ensure ordered correctly
                var orderedPeriodData = periodData.OrderBy(p => p.sfa_DisplayOrder);
                var newPeriod = orderedPeriodData.Last();

                // Check properties populated correctly for the new deliverable period
                Assert.AreEqual(201602, newPeriod.sfa_DisplayOrder);
                Assert.AreEqual("Feb-16", newPeriod.sfa_name);
                Assert.AreEqual("Feb-16", newPeriod.sfa_PeriodName);
                Assert.AreEqual(02, newPeriod.sfa_Period);
                Assert.AreEqual(2016, newPeriod.sfa_Year);
                Assert.AreEqual("CM", newPeriod.sfa_PeriodTypeId.Name);
                Assert.AreEqual(deliverable.OwnerId.Id, newPeriod.OwnerId.Id);

                // Check subnominal code copied over depending on the deliverable
                switch (deliverableCode)
                {
                    case 1:
                        Assert.AreEqual("2201000", newPeriod.sfa_profilesubnominal.Name);
                        Assert.IsNull(newPeriod.sfa_reconciliationsubnominal);
                        Assert.IsNull(newPeriod.sfa_CappingSubnominal);
                        break;
                    case 2:
                        Assert.IsNull(newPeriod.sfa_profilesubnominal);
                        Assert.AreEqual("2201000", newPeriod.sfa_reconciliationsubnominal.Name);
                        Assert.IsNull(newPeriod.sfa_CappingSubnominal);
                        break;
                    default:
                        Assert.IsNull(newPeriod.sfa_profilesubnominal);
                        Assert.IsNull(newPeriod.sfa_reconciliationsubnominal);
                        Assert.AreEqual("2201000", newPeriod.sfa_CappingSubnominal.Name);
                        break;
                }
            }
        }

        private static Guid GetAllocationIdFromCrm(string allocationNumber, int contractVersionNumber)
        {
            using (var xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                var data = from a in xrmContext.sfa_contractallocationSet
                    join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                    orderby a.CreatedOn descending
                    where
                        c.sfa_LastApprovedVersion == true &&
                        c.sfa_Version == contractVersionNumber &&
                        a.sfa_contractallocationnumber == allocationNumber
                    select a;

                sfa_contractallocation sfaContractallocation = data.FirstOrDefault();
                return sfaContractallocation.Id;
            }
        }

        private Allocation CreatePaymentScheduleAllocation()
        {
            var allocation = new Allocation()
            {
                AllocationNumber = AllocationNumber
            };
            allocation.AllocationDeliverables.Add(CreatePaymentScheduleDeliverableType(1));
            allocation.AllocationDeliverables.Add(CreatePaymentScheduleDeliverableType(2));
            allocation.AllocationDeliverables.Add(CreatePaymentScheduleDeliverableType(3));

            return allocation;
        }
        
        private AllocationDeliverable CreatePaymentScheduleDeliverableType(int deliverableCode)
        {
            return new AllocationDeliverable
            {
                DeliverableCode = deliverableCode,
                ScheduledPayments = new List<ScheduledPayment>
                {
                    #region 'Create scheduled payments'
                    new ScheduledPayment
                    {
                        ActualValue = 2323423.00m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201501",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 5000m,
                        ReconciliationPaymentAmount = 5000m,
                        CappedPaymentAmount = -10m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 2323423.00m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201502",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 10000m,
                        ReconciliationPaymentAmount = 10000m,
                        CappedPaymentAmount = -150m
                    }
                    ,
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201503",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201504",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201505",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201506",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201507",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201508",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201509",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201510",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201511",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = "201512",
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    },
                    new ScheduledPayment
                    {
                        ActualValue = 0m,
                        ProfilePaymentAmount = 2323.00m,
                        Period = PeriodOutsideBounds,
                        BalancingPaymentAmount = 0m,
                        NetPaymentAmount = 0m,
                        ReconciliationPaymentAmount = 0m,
                        CappedPaymentAmount = 0m
                    }

                    #endregion
                }
            };
        }

        private Tuple<XrmContract, XrmContract> CreateXrmContract(
            string masterContractNumber,
            string contractNumber, string ukprn,
            string allocationRef,
            int version,
            int numPeriods)
        {
            var mastercontract = _container.Resolve<XrmContract>();

            mastercontract.Ukprn = ukprn;
            mastercontract.ContractNumber = masterContractNumber;
            mastercontract.Description = "Test Description";
            mastercontract.ContractType = "Contract for Services";
            mastercontract.FundingType = "Mainstream";
            mastercontract.ParentContractNumber = null;
            mastercontract.SubVersion = 0;
            mastercontract.Version = version;

            var contract = _container.Resolve<XrmContract>();

            contract.Ukprn = ukprn;
            contract.ContractNumber = contractNumber;
            contract.Description = "Test Description";
            contract.ContractType = "Contract for Services";
            contract.FundingType = "Mainstream";
            contract.ParentContractNumber = masterContractNumber;
            contract.SubVersion = 0;
            contract.Version = version;
            contract.LastApprovedVersion = true;
            contract.Entity.sfa_ContractStatus = new OptionSetValue(229660001); // Approved
            contract.Entity.sfa_SubStatus = new EntityReference("sfa_status", ReturnSubStatusEntity("Approved").Id); // Approved
                
            // ASC1516
            var allocation1 = _container.Resolve<XrmContractAllocation>();
            allocation1.ContractAllocationRef = allocationRef;
            allocation1.FundingStreamPeriod = _container.Resolve<XrmFundingStreamPeriod>().Get("ASC1516") as XrmFundingStreamPeriod;
            allocation1.Contract = contract;
            allocation1.ContractAllocationRef = allocationRef;
            allocation1.AllocationValue = 100;
            allocation1.FundingStream = "ASC";
            allocation1.StartDate = AllocationStartDateTest;
            allocation1.EndDate = AllocationEndDateTest;

            // ASC1516
            var deliverable1 = _container.Resolve<XrmContractDeliverable>();
            deliverable1.Contract = contract;
            deliverable1.Allocation = allocation1;
            deliverable1.DeliverableCode = "1";
            deliverable1.DeliverableName = "Total Adult Skills Funding";
            deliverable1.PlannedValue = 100;
            deliverable1.PlannedVolume = 100;
            deliverable1.ProfileDeliverable = "Aggregate";

            var deliverable2 = _container.Resolve<XrmContractDeliverable>();
            deliverable2.Contract = contract;
            deliverable2.Allocation = allocation1;
            deliverable2.DeliverableCode = "2";
            deliverable2.DeliverableName = "Apprenticeships Total Funding";
            deliverable2.PlannedValue = 100;
            deliverable2.PlannedVolume = 100;
            deliverable2.ProfileDeliverable = "Aggregate";

            var deliverable3 = _container.Resolve<XrmContractDeliverable>();
            deliverable3.Contract = contract;
            deliverable3.Allocation = allocation1;
            deliverable3.DeliverableCode = "3";
            deliverable3.DeliverableName = "Other ASB Total Funding";
            deliverable3.PlannedValue = 100;
            deliverable3.PlannedVolume = 100;
            deliverable3.ProfileDeliverable = "Aggregate";
            
            deliverable1.Periods = AddPeriods(deliverable1, "profile", numPeriods);
            deliverable2.Periods = AddPeriods(deliverable2, "recon", numPeriods);
            deliverable3.Periods = AddPeriods(deliverable3, "capping", numPeriods);

            mastercontract.ChildContracts = new List<Contract> { contract };
            contract.Allocations = new List<ContractAllocation> { allocation1 };
            allocation1.Deliverables = new List<ContractDeliverable> { deliverable1, deliverable2, deliverable3 };

            return new Tuple<XrmContract, XrmContract>(mastercontract, contract);
        }
        
        private List<ContractDeliverablePeriod> AddPeriods(XrmContractDeliverable deliverable, string codeType, int numPeriods)
        {
            List<ContractDeliverablePeriod> dps = new List<ContractDeliverablePeriod>(12);

            var periodTypeEntity = ReturnPeriodTypeEntity("CM")
            ;

            for (int i = 1; i <= numPeriods; i++)
            {
                var deliverableperiod = _container.Resolve<XrmContractDeliverablePeriod>();

                deliverableperiod.Deliverable = deliverable;

                DateTime dt = new DateTime(2015, i, 1);
                deliverableperiod.Entity.sfa_name = dt.ToString("MMM-yy");
                deliverableperiod.Entity.sfa_PeriodName = dt.ToString("MMM-yy");
                deliverableperiod.PeriodNumber = i;
                deliverableperiod.Year = 2015;
                deliverableperiod.PaymentPosted = false;
                deliverableperiod.Entity.sfa_DisplayOrder = int.Parse(dt.ToString("yyyyMM"));

                deliverableperiod.Entity.sfa_PeriodTypeId = new EntityReference("sfa_periodtype", periodTypeEntity.Id);

                switch (codeType)
                {
                    case "profile":
                            deliverableperiod.Entity.sfa_profilesubnominal = new EntityReference("sfa_subnominalaggregation", ReturnSubnominalAggregationEntity("2201000").Id);
                        break;
                    case "recon":
                        deliverableperiod.Entity.sfa_reconciliationsubnominal = new EntityReference("sfa_subnominalaggregation", ReturnSubnominalAggregationEntity("2201000").Id);
                        break;
                    default:
                        deliverableperiod.Entity.sfa_CappingSubnominal = new EntityReference("sfa_subnominalaggregation", ReturnSubnominalAggregationEntity("2201000").Id);
                        break;
                }
                
                dps.Add(deliverableperiod);
            }

            return dps;
        }

        private static sfa_periodtype ReturnPeriodTypeEntity(string type)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                var data = (from p in xrmContext.sfa_periodtypeSet
                           where
                              p.sfa_periodtypecode == type
                           select p).FirstOrDefault();

                return data;
            }
        }

        private static sfa_status ReturnSubStatusEntity(string name)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                var data = (from s in xrmContext.sfa_statusSet
                            where
                               s.sfa_name == name
                            select s).FirstOrDefault();

                return data;
            }
        }

        private static sfa_subnominalaggregation ReturnSubnominalAggregationEntity(string name)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmOrganizationService))
            {
                var data = (from s in xrmContext.sfa_subnominalaggregationSet
                            where
                               s.sfa_name == name
                            select s).FirstOrDefault();

                return data;
            }
        }
    }
}