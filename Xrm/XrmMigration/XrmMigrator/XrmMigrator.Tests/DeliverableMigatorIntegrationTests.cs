namespace XrmMigrator.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reactive.Linq;
    using System.Reactive.Subjects;
    using Castle.Windsor;
    using Dto;
    using Events;
    using IoC;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Xrm;
    using XrmTestModel;
    using XrmTestModel.Extensions;
    using XrmTestModel.XrmObjects;

    [TestClass]
    public class DeliverableMigratorTests
    {
        private const int Ukprn = 199900;
        private const int MasterContractNumber = 999900;
        private const int ContractNumber = 999900;
        private const string OrganisationName = "Migration Org";
        public readonly Relationship AllocationSubnominalRelationshipName = new Relationship("sfa_sfa_subnominalaggregation_sfa_contractall");
        private IWindsorContainer _container;

        private readonly List<XrmContract> _contracts = new List<XrmContract>();
        private readonly List<XrmOrganisation> _orgs = new List<XrmOrganisation>();
        private readonly List<XrmSubnominalAggregation> _subnominals = new List<XrmSubnominalAggregation>();

        [TestInitialize]
        public void SetupIoC()
        {
            _container = Bootstrapper.CreateContainer();
        }

        [TestMethod, TestCategory("MigrationIntegrationTest")]
        public void TestDeliverableMigration()
        {
            foreach (var i in Enumerable.Range(1, 10))
            {
                var ukprn = (Ukprn + i).ToString();
                var masterContractNo = (MasterContractNumber + i).ToString("'MASTER-'#");
                var contractNumber = (ContractNumber + i).ToString("'MAIN'-#");
                var allocationNumber = i.ToString("'16-18APPS-'#");

                var org = _container.Resolve<XrmOrganisation>();

                org.Ukprn = ukprn;
                org.OrganisationName = OrganisationName + " " + ukprn;
                org.Save();
                
                _orgs.Add(org);

                // Resolve Contract from Container
                var mastercontract = CreateXrmContract(masterContractNo, contractNumber, ukprn, allocationNumber);

                mastercontract.Save();

                _contracts.Add(mastercontract);

            }

            var heirarchicalmasterContract = CreateHierarcicalXrmContract("MASTER-10000", "MAIN-10000", "199901",
                "16-18APPS-100");
            heirarchicalmasterContract.Save();

            _contracts.Add(heirarchicalmasterContract);

            var deliverableMigrator = new DeliverableMigrator()
            {
                OrgSvc = _container.Resolve<IXrmServiceFactory>().Create()
            };
            
            var eventStream = new Subject<DeliverableMigrationEvent>();

            eventStream.Where(e => e.Type == EventType.UpdatingRecord && e.Result == EventResult.Updated).Subscribe(e =>
                Console.WriteLine("[{0}] Record Updated: Allocation: {1}, Deliverable Code: {2}, Records Processed: {3}",
                DateTime.Now,
                    e.AllocationNumber,
                    e.DeliverableCode,
                    e.Processed));

            eventStream.Where(e => e.Result == EventResult.Error || e.Result == EventResult.Warning).Subscribe(e =>
                Console.WriteLine("[{0}] Error or Warning Occurred: Allocation: {1}", DateTime.Now, e.Message));

            eventStream.Subscribe(_ => {}, () => Console.WriteLine("[{0}] Migration Completed", DateTime.Now));

            deliverableMigrator.MigrateDeliverables(eventStream);

            TestTearDown();
        }

       

        private XrmContract CreateXrmContract(string masterContractNumber, string contractNumber, string ukprn, string allocationRef, SubnominalAggregation reconcilationSubnominal = null)
        {
            var mastercontract = _container.Resolve<XrmContract>();

            mastercontract.Ukprn = ukprn;
            mastercontract.ContractNumber = masterContractNumber;
            mastercontract.Description = "Test Description";
            mastercontract.ContractType = "Contract for Services";
            mastercontract.FundingType = "Apprenticeship Grant for Employers";
            mastercontract.ParentContractNumber = null;
            mastercontract.SubVersion = 0;
            mastercontract.Version = 1;

            var contract = _container.Resolve<XrmContract>();

            contract.Ukprn = ukprn;
            contract.ContractNumber = contractNumber;
            contract.Description = "Test Description";
            contract.ContractType = "Contract for Services";
            contract.FundingType = "Apprenticeship Grant for Employers";
            contract.ParentContractNumber = null;
            contract.SubVersion = 0;
            contract.Version = 1;
            contract.LastApprovedVersion = true;

            var allocation1 = _container.Resolve<XrmContractAllocation>();

            allocation1.ContractAllocationRef = allocationRef;
            allocation1.FundingStreamPeriod =
                _container.Resolve<XrmFundingStreamPeriod>().Get("AGE1516") as XrmFundingStreamPeriod;
            allocation1.Contract = contract;
            allocation1.AllocationValue = 100;
            allocation1.FundingStream = "AGE";

            var deliverable1 = _container.Resolve<XrmContractDeliverable>();

            deliverable1.Contract = contract;
            deliverable1.Allocation = allocation1;
            deliverable1.DeliverableCode = "1";
            deliverable1.DeliverableName = "16-18 Apprenticeship Grant for Employers";
            deliverable1.PlannedValue = 100;
            deliverable1.PlannedVolume = 100;
            deliverable1.ProfileDeliverable = "Aggregate";

            var deliverable2 = _container.Resolve<XrmContractDeliverable>();

            deliverable2.Contract = contract;
            deliverable2.Allocation = allocation1;
            deliverable2.DeliverableCode = "2";
            deliverable2.DeliverableName = "19-23 Apprenticeship Grant for Employers";
            deliverable2.PlannedValue = 100;
            deliverable2.PlannedVolume = 100;
            deliverable2.ProfileDeliverable = "Aggregate";

            var deliverablePeriod1 = _container.Resolve<XrmContractDeliverablePeriod>();

            deliverablePeriod1.Deliverable = deliverable1;
            deliverablePeriod1.Year = 2015;
            deliverablePeriod1.PeriodNumber = 8;
            deliverablePeriod1.ReconcilationSubnominal = reconcilationSubnominal;

            var deliverablePeriod2 = _container.Resolve<XrmContractDeliverablePeriod>();

            deliverablePeriod2.Deliverable = deliverable1;
            deliverablePeriod2.Year = 2015;
            deliverablePeriod2.PeriodNumber = 9;

            var deliverablePeriod3 = _container.Resolve<XrmContractDeliverablePeriod>();

            deliverablePeriod3.Deliverable = deliverable2;
            deliverablePeriod3.Year = 2015;
            deliverablePeriod3.PeriodNumber = 8;

            var deliverablePeriod4 = _container.Resolve<XrmContractDeliverablePeriod>();

            deliverablePeriod4.Deliverable = deliverable2;
            deliverablePeriod4.Year = 2015;
            deliverablePeriod4.PeriodNumber = 9;

            
            mastercontract.ChildContracts = new List<Contract> { contract };
            contract.Allocations = new List<ContractAllocation> { allocation1 };
            allocation1.Deliverables = new List<ContractDeliverable> { deliverable1, deliverable2 };
            deliverable1.Periods = new List<ContractDeliverablePeriod> { deliverablePeriod1, deliverablePeriod2 };
            deliverable2.Periods = new List<ContractDeliverablePeriod> { deliverablePeriod3, deliverablePeriod4 };
            return mastercontract;
        }

        private XrmContract CreateHierarcicalXrmContract(string masterContractNumber, string contractNumber, string ukprn, string allocationRef)
        {
            var mastercontract = _container.Resolve<XrmContract>();

            mastercontract.Ukprn = ukprn;
            mastercontract.ContractNumber = masterContractNumber;
            mastercontract.Description = "Test Description";
            mastercontract.ContractType = "Contract for Services";
            mastercontract.FundingType = "Apprenticeship Grant for Employers";
            mastercontract.ParentContractNumber = null;
            mastercontract.SubVersion = 0;
            mastercontract.Version = 1;

            var contract = _container.Resolve<XrmContract>();

            contract.Ukprn = ukprn;
            contract.ContractNumber = contractNumber;
            contract.Description = "Test Description";
            contract.ContractType = "Contract for Services";
            contract.FundingType = "Apprenticeship Grant for Employers";
            contract.ParentContractNumber = null;
            contract.SubVersion = 0;
            contract.Version = 1;

            var allocation1 = _container.Resolve<XrmContractAllocation>();

            allocation1.ContractAllocationRef = allocationRef;
            allocation1.FundingStreamPeriod =
                _container.Resolve<XrmFundingStreamPeriod>().Get("16-18APPS1516") as XrmFundingStreamPeriod;
            allocation1.Contract = contract;
            allocation1.ContractAllocationRef = contractNumber;
            allocation1.AllocationValue = 100;
            allocation1.FundingStream = "16-18 APPS";

            var deliverable1 = _container.Resolve<XrmContractDeliverable>();

            deliverable1.Contract = contract;
            deliverable1.Allocation = allocation1;
            deliverable1.DeliverableCode = "1";
            deliverable1.DeliverableName = "Total 16-18 Funding";
            deliverable1.PlannedValue = 100;
            deliverable1.PlannedVolume = 100;
            deliverable1.ProfileDeliverable = "Aggregate";

            var deliverable2 = _container.Resolve<XrmContractDeliverable>();

            deliverable2.Contract = contract;
            deliverable2.Allocation = allocation1;
            deliverable2.ParentDeliverable = deliverable1;
            deliverable2.DeliverableCode = "3";
            deliverable2.DeliverableName = "16-18 Traineeships Total Funding";
            deliverable2.PlannedValue = 100;
            deliverable2.PlannedVolume = 100;
            deliverable2.ProfileDeliverable = "Aggregate";

            var deliverable3 = _container.Resolve<XrmContractDeliverable>();

            deliverable3.Contract = contract;
            deliverable3.Allocation = allocation1;
            deliverable3.ParentDeliverable = deliverable2;
            deliverable3.DeliverableCode = "4";
            deliverable3.DeliverableName = "16-18 Traineeships Programme Funding";
            deliverable3.PlannedValue = 100;
            deliverable3.PlannedVolume = 100;
            deliverable3.ProfileDeliverable = "Profile";

            mastercontract.ChildContracts = new List<Contract> { contract };
            contract.Allocations = new List<ContractAllocation> { allocation1 };
            allocation1.Deliverables = new List<ContractDeliverable> { deliverable1, deliverable2, deliverable3 };
            return mastercontract;
        }

        [TestMethod, TestCategory("MigrationIntegrationTest")]
        public void TestSubnominalUpdate()
        {
            // Arrange
            foreach (var i in Enumerable.Range(1, 10))
            {
                var ukprn = (Ukprn + i).ToString();
                var masterContractNo = (MasterContractNumber + i).ToString("'MASTER-'#");
                var contractNumber = (ContractNumber + i).ToString("'MAIN'-#");
                var allocationNumber = i.ToString("'AGE-'#");

                var org = _container.Resolve<XrmOrganisation>();

                org.Ukprn = ukprn;
                org.OrganisationName = OrganisationName + " " + ukprn;
                org.Save();

                _orgs.Add(org);

                var reconcilationSubnominal = _container.Resolve<XrmSubnominalAggregation>();

                reconcilationSubnominal.SubnominalCode = "2260010";
                reconcilationSubnominal.SubnominalAggregateKey = string.Concat("2260010",
                     "_",
                     allocationNumber,
                     "_",
                     "201508");

                var reconcilationSubnominal2 = _container.Resolve<XrmSubnominalAggregation>();

                reconcilationSubnominal2.SubnominalCode = "2360010";
                reconcilationSubnominal2.SubnominalAggregateKey = string.Concat("2360010",
                     "_",
                     allocationNumber,
                     "_",
                     "201508");

                reconcilationSubnominal.Save();
                reconcilationSubnominal2.Save();

                _subnominals.AddRange(new[] { reconcilationSubnominal, reconcilationSubnominal2 });

                // Resolve Contract from Container
                var mastercontract = CreateXrmContract(masterContractNo, contractNumber, ukprn, allocationNumber, reconcilationSubnominal);

                mastercontract.Save();

                var allocation = mastercontract.ChildContracts.First().Allocations.First() as XrmContractAllocation;
                
                reconcilationSubnominal.OrgService.Associate(allocation.EntityLogicalName,
                allocation.GetId(),
                AllocationSubnominalRelationshipName,
                new EntityReferenceCollection(new List<EntityReference> { reconcilationSubnominal.GetEntityReference(), reconcilationSubnominal2.GetEntityReference() }));

                _contracts.Add(mastercontract);

            }

            var deliverableMigrator = new DeliverableMigrator()
            {
                OrgSvc = _container.Resolve<IXrmServiceFactory>().Create()
            };

            var deliverablePeriodSubnominals = GetPeriodSubnominals();
            
            var eventStream = new Subject<DeliverablePeriodMigrationEvent>();

            eventStream.Where(e => e.Type == EventType.UpdatingRecord && e.Result == EventResult.Updated).Subscribe(e =>
                Console.WriteLine("[{0}] Record Updated: Allocation: {1}, Subnominal Code: {2}, Subnominal Type: {3}, Period: {4}, Records Processed: {5}",
                DateTime.Now,
                    e.AllocationNumber,
                    e.SubnominalCode,
                    e.SubnominalType,
                    e.Period,
                    e.Processed));

            eventStream.Where(e => e.Result == EventResult.Error || e.Result == EventResult.Warning).Subscribe(e =>
                Console.WriteLine("[{0}] Error or Warning Occurred: Allocation: {1}, Error: {2}", DateTime.Now, e.AllocationNumber, e.Message));

            eventStream.Subscribe(_ => { }, () => Console.WriteLine("[{0}] Migration Completed", DateTime.Now));

            // Act
            //deliverableMigrator.PopulateSubnominalCodes(eventStream,
            //    deliverablePeriodSubnominals);

        }

        private static List<DeliverablePeriodSubnominal> GetPeriodSubnominals()
        {
            return new List<DeliverablePeriodSubnominal>
            {
                new DeliverablePeriodSubnominal
                {
                    AllocationNumber = "16-18APPS-1",
                    DeliverableCode = "3",
                    Period = "201508",
                    SubnominalType = SubnominalType.Profile,
                    SubnominalCode = "PROFILE"
                },
                new DeliverablePeriodSubnominal
                {
                    AllocationNumber = "16-18APPS-2",
                    DeliverableCode = "3",
                    Period = "201508",
                    SubnominalType = SubnominalType.Profile,
                    SubnominalCode = "PROFILE"
                },
                new DeliverablePeriodSubnominal
                {
                    AllocationNumber = "16-18APPS-2",
                    DeliverableCode = "3",
                    Period = "201508",
                    SubnominalType = SubnominalType.Profile,
                    SubnominalCode = "UNKNOWN"
                },
                new DeliverablePeriodSubnominal
                {
                    AllocationNumber = "16-18APPS-3",
                    DeliverableCode = "4",
                    Period = "201508",
                    SubnominalType = SubnominalType.Reconcilation,
                    SubnominalCode = "RECONCILIATION"
                },
                new DeliverablePeriodSubnominal
                {
                    AllocationNumber = "16-18APPS-4",
                    DeliverableCode = "3",
                    Period = "201508",
                    SubnominalType = SubnominalType.Profile,
                    SubnominalCode = "PROFILE"
                },
                new DeliverablePeriodSubnominal
                {
                    AllocationNumber = "16-18APPS-4",
                    DeliverableCode = "1",
                    Period = "201508",
                    SubnominalType = SubnominalType.Reconcilation,
                    SubnominalCode = "RECONCILIATION"
                },
                new DeliverablePeriodSubnominal
                {
                    AllocationNumber = "16-18APPS-5",
                    DeliverableCode = "3",
                    Period = "201508",
                    SubnominalType = SubnominalType.Profile,
                    SubnominalCode = "UNKNOWN"
                },
                new DeliverablePeriodSubnominal
                {
                    AllocationNumber = "16-18APPS-6",
                    DeliverableCode = "4",
                    Period = "201508",
                    SubnominalType = SubnominalType.Reconcilation,
                    SubnominalCode = "RECONCILIATION"
                },
                new DeliverablePeriodSubnominal
                {
                    AllocationNumber = "16-18APPS-7",
                    DeliverableCode = "3",
                    Period = "201508",
                    SubnominalType = SubnominalType.Profile,
                    SubnominalCode = "UNKNOWN"
                },
                new DeliverablePeriodSubnominal
                {
                    AllocationNumber = "16-18APPS-8",
                    DeliverableCode = "4",
                    Period = "201508",
                    SubnominalType = SubnominalType.Reconcilation,
                    SubnominalCode = "RECONCILIATION"
                }
            };
        }

        [TestCleanup]
        public void TestTearDown()
        {
            _subnominals.ForEach(s => s.Delete());
            _contracts.ForEach(c => c.Delete());
            _orgs.ForEach(o => o.Delete());
        }
    }
}
