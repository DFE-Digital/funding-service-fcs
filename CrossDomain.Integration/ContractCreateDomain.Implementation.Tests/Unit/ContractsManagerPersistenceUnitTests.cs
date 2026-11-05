namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using Moq;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Exceptions;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using UnitTests.Common;

    [TestClass]
    public class ContractsManagerPersistenceUnitTests
    {
        private Mock<IOrganizationService> _service;
        private Mock<ILookupManager> _lookupManager;
        private Mock<IXrmOrganisationManager> _organisationManager;
        private Mock<IXrmWorkflowManager> _workflowManager;
        private List<Entity> _created;
        private ContractsManager _manager;

        [TestInitialize]
        public void Setup()
        {
            _created = new List<Entity>();
            _service = new Mock<IOrganizationService>();
            _service.Setup(s => s.Retrieve(It.IsAny<string>(), It.IsAny<Guid>(), It.IsAny<ColumnSet>()))
                .Returns(() => new Entity("sfa_fundingtype") { ["sfa_documentationnotrequired"] = false });
            _service.Setup(s => s.Create(It.IsAny<Entity>()))
                .Returns<Entity>(e =>
                {
                    _created.Add(e);
                    return Guid.NewGuid();
                });

            _lookupManager = new Mock<ILookupManager>();
            _lookupManager.Setup(l => l.GetMatchingEntity(It.IsAny<CrmLookupType>(), It.IsAny<string>())).Returns(Guid.NewGuid());
            _lookupManager.Setup(l => l.GetMatchingEntity(It.IsAny<CrmLookupType>(), It.IsAny<CrmCompositeKey>())).Returns(Guid.NewGuid());

            _organisationManager = new Mock<IXrmOrganisationManager>();
            _workflowManager = new Mock<IXrmWorkflowManager>();
            _workflowManager.Setup(w => w.GetWorkflowHistory(It.IsAny<Guid>())).Returns(new List<sfa_contracttransitionhistory>());
            _workflowManager.Setup(w => w.TranslateWorkflowHistory(It.IsAny<List<sfa_contracttransitionhistory>>()))
                .Returns<List<sfa_contracttransitionhistory>>(l => l);

            _manager = new ContractsManager
            {
                BatchId = "BATCH",
                LookupManager = _lookupManager.Object,
                OrganizationService = _service.Object,
                XrmOrganisationManager = _organisationManager.Object,
                XrmWorkflowManager = _workflowManager.Object
            };
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CheckContractExists_ShouldDelegateToLookupManager()
        {
            _lookupManager.Setup(l => l.CheckContractExists("CORR")).Returns(true);

            Assert.IsTrue(_manager.CheckContractExists("CORR"));
            Assert.IsFalse(_manager.CheckContractExists("OTHER"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PersistContractToCrm_ShouldCreateContractAndSeparatelyCreateAllocationsAndHistory()
        {
            var contract = BuildXrmContractWithRelatedEntities(out var allocation, out var history);

            var id = _manager.PersistContractToCrm(contract);

            Assert.AreNotEqual(Guid.Empty, id);
            Assert.IsTrue(contract.sfa_DocumentationRequired.GetValueOrDefault());
            Assert.AreEqual(3, _created.Count);
            Assert.AreSame(contract, _created[0]);
            Assert.AreEqual(id, allocation.GetAttributeValue<EntityReference>("sfa_contractid").Id);
            Assert.AreEqual(id, history.GetAttributeValue<EntityReference>("sfa_contract").Id);
            Assert.AreEqual(0, contract.RelatedEntities.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PersistContractToCrm_ShouldSetDocumentationNotRequired_WhenFundingTypeSaysSo()
        {
            _service.Setup(s => s.Retrieve(It.IsAny<string>(), It.IsAny<Guid>(), It.IsAny<ColumnSet>()))
                .Returns(new Entity("sfa_fundingtype") { ["sfa_documentationnotrequired"] = true });
            var contract = BuildXrmContractWithRelatedEntities(out _, out _);

            _manager.PersistContractToCrm(contract);

            Assert.IsFalse(contract.sfa_DocumentationRequired.GetValueOrDefault(true));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PersistContractToCrm_ShouldReuseExistingContract_WhenOneIsFound()
        {
            var existingId = Guid.NewGuid();
            var contract = BuildXrmContractWithRelatedEntities(out var allocation, out _);

            var id = _manager.PersistContractToCrm(contract, null, identity => existingId);

            Assert.AreEqual(existingId, id);
            Assert.IsFalse(_created.Any(e => e.LogicalName == sfa_contract.EntityLogicalName));
            Assert.AreEqual(existingId, allocation.GetAttributeValue<EntityReference>("sfa_contractid").Id);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PersistContractToCrm_ShouldCreateContract_WhenExistingContractLookupReturnsEmpty()
        {
            var contract = BuildXrmContractWithRelatedEntities(out _, out _);

            var id = _manager.PersistContractToCrm(contract, null, identity => Guid.Empty);

            Assert.AreNotEqual(Guid.Empty, id);
            Assert.IsTrue(_created.Any(e => e.LogicalName == sfa_contract.EntityLogicalName));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PersistContractToCrm_ShouldLetCallerDecideWhetherToInsertAllocation()
        {
            var contract = BuildXrmContractWithRelatedEntities(out _, out _);
            var numbers = new List<string>();

            _manager.PersistContractToCrm(contract, (identity, number, insert) => numbers.Add(number));

            CollectionAssert.AreEqual(new[] { "A-1" }, numbers);
            Assert.IsFalse(_created.Any(e => e.LogicalName == sfa_contractallocation.EntityLogicalName));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PersistContractToCrm_ShouldInsertAllocation_WhenCallerInvokesTheInsertAction()
        {
            var contract = BuildXrmContractWithRelatedEntities(out _, out _);

            _manager.PersistContractToCrm(contract, (identity, number, insert) => insert());

            Assert.IsTrue(_created.Any(e => e.LogicalName == sfa_contractallocation.EntityLogicalName));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendContract_ShouldPersistTheAmendedContract()
        {
            var contract = LoadContract();

            var id = _manager.AmendContract(contract, "CORR");

            Assert.AreNotEqual(Guid.Empty, id);
            _lookupManager.VerifySet(l => l.BatchId = "BATCH");
            _lookupManager.Verify(l => l.Lookup(It.IsAny<LookupCriteria>()), Times.Once);
            _organisationManager.Verify(o => o.CreateOrganisationIfNotExists(It.IsAny<ContractOrganisation>()), Times.AtLeastOnce);
            Assert.IsTrue(_created.Any(e => e.LogicalName == sfa_contract.EntityLogicalName));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateContract_ShouldReuseExistingContractAndAllocationHooks()
        {
            var contract = LoadContract();
            var existingId = Guid.NewGuid();
            var allocationNumbers = new List<string>();

            var id = _manager.CreateContract(
                contract,
                "CORR",
                (identity, number, insert) => allocationNumbers.Add(number),
                identity => existingId);

            Assert.AreEqual(Guid.Empty, id);
            Assert.IsFalse(_created.Any(e => e.LogicalName == sfa_contract.EntityLogicalName));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProcessContractOverriddenCreatedOn_ShouldCopyCreatedOn()
        {
            var created = new DateTime(2020, 1, 2, 3, 4, 5, DateTimeKind.Utc);
            var contract = new sfa_contract { ["createdon"] = created };

            _manager.ProcessContractOverriddenCreatedOn(contract);

            Assert.AreEqual(created, contract.OverriddenCreatedOn);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProcessContractCopyWorkflowHistory_ShouldAttachCopiedHistoryToContract()
        {
            var contract = new sfa_contract
            {
                Id = Guid.NewGuid(),
                sfa_PreviousVersion = new EntityReference(sfa_contract.EntityLogicalName, Guid.NewGuid())
            };
            var history = new sfa_contracttransitionhistory
            {
                Id = Guid.NewGuid(),
                sfa_Contract = new EntityReference(sfa_contract.EntityLogicalName, Guid.NewGuid())
            };
            _workflowManager.Setup(w => w.GetWorkflowHistory(contract.sfa_PreviousVersion.Id))
                .Returns(new List<sfa_contracttransitionhistory> { history });

            _manager.ProcessContractCopyWorkflowHistory(contract);

            Assert.AreEqual(contract.Id, history.sfa_Contract.Id);
            Assert.AreEqual(1, contract.RelatedEntities.Count);
            Assert.AreEqual(1, contract.RelatedEntities.Values.Single().Entities.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DoesContractVersionExist_ShouldReflectMatchingContracts()
        {
            var fake = new FakeXrmService(query => new[] { new sfa_contract { Id = Guid.NewGuid() } });
            var manager = new ContractsManager { OrganizationService = fake.Service };

            Assert.IsTrue(manager.DoesContractVersionExist("C-1", 1));

            var empty = new ContractsManager { OrganizationService = new FakeXrmService(q => new Entity[0]).Service };
            Assert.IsFalse(empty.DoesContractVersionExist("C-1", 1));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetLastApprovedContractIdentityInfo_ShouldReturnAllocationsOfApprovedVersion()
        {
            var fake = new FakeXrmService(query => new[]
            {
                FakeXrmService.Row(
                    query,
                    (entity, column) =>
                    {
                        switch (column)
                        {
                            case "sfa_contractallocationnumber": return "A-1";
                            case "sfa_deliveryorganisationukprn": return "10001234";
                            default: return null;
                        }
                    },
                    "sfa_contractallocationnumber",
                    "sfa_deliveryorganisationukprn")
            });
            var manager = new ContractsManager { OrganizationService = fake.Service };

            var info = manager.GetLastApprovedContractIdentityInfo("C-1");

            Assert.IsNotNull(info);
            Assert.AreEqual("C-1", info.ContractNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetLastApprovedContractIdentityInfo_ShouldReturnNull_WhenThereAreNoApprovedAllocations()
        {
            var manager = new ContractsManager { OrganizationService = new FakeXrmService(q => new Entity[0]).Service };

            Assert.IsNull(manager.GetLastApprovedContractIdentityInfo("C-1"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetMaximumContractVersionNumber_ShouldReturnHighestVersion()
        {
            var manager = ManagerWithContracts(
                new sfa_contract { sfa_Version = 1 },
                new sfa_contract { sfa_Version = 3 },
                new sfa_contract { sfa_Version = null });

            Assert.AreEqual(3, manager.GetMaximumContractVersionNumber("C-1"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetMaximumContractVersionNumber_ShouldThrow_WhenNoContractExists()
        {
            var manager = ManagerWithContracts();

            ThrowsHelper.Throws<ContractDoesntExistException>(() => manager.GetMaximumContractVersionNumber("C-1"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetMaxWithdrawnContractVersion_ShouldReturnVersionOfLatestWithdrawnContract()
        {
            var manager = ManagerWithContracts(
                new sfa_contract { sfa_Version = 1, sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Withdrawn) },
                new sfa_contract { sfa_Version = 2, sfa_SubVersion = 1, sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Withdrawn) },
                new sfa_contract { sfa_Version = 5, sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Approved) });

            Assert.AreEqual(2, manager.GetMaxWithdrawnContractVersion("C-1"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetMaxVersionWithdrawnXrmContract_ShouldThrow_WhenNoContractExists()
        {
            var manager = ManagerWithContracts();

            ThrowsHelper.Throws<ContractDoesntExistException>(() => manager.GetMaxVersionWithdrawnXrmContract("C-1"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetMostRecentContractId_ShouldReturnNewestMatchingContract()
        {
            var older = new sfa_contract { Id = Guid.NewGuid(), ["createdon"] = new DateTime(2019, 1, 1) };
            var newer = new sfa_contract { Id = Guid.NewGuid(), ["createdon"] = new DateTime(2020, 1, 1) };
            var manager = new ContractsManager { OrganizationService = new FakeXrmService(q => new[] { older, newer }).Service };

            Assert.AreEqual(newer.Id, manager.GetMostRecentContractId("C-1", 1));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetApprovedContractId_ShouldReturnTheApprovedContractId()
        {
            var approved = new sfa_contract { Id = Guid.NewGuid(), sfa_contractId = Guid.NewGuid() };
            var manager = new ContractsManager { OrganizationService = new FakeXrmService(q => new[] { approved }).Service };

            Assert.AreEqual(approved.sfa_contractId, manager.GetApprovedContractId("C-1"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetLatestVersionContractId_ShouldReturnNull_WhenNoContractIsFlaggedAsLatest()
        {
            var manager = new ContractsManager { OrganizationService = new FakeXrmService(q => new Entity[0]).Service };

            Assert.IsNull(manager.GetLatestVersionContractId("C-1"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetLatestVersionContractId_ShouldReturnLatestContractId()
        {
            var latest = new sfa_contract { Id = Guid.NewGuid(), sfa_contractId = Guid.NewGuid() };
            var manager = new ContractsManager { OrganizationService = new FakeXrmService(q => new[] { latest }).Service };

            Assert.AreEqual(latest.sfa_contractId, manager.GetLatestVersionContractId("C-1"));
        }

        private static ContractsManager ManagerWithContracts(params sfa_contract[] contracts)
        {
            var mock = new Mock<ContractsManager> { CallBase = true };
            mock.Setup(c => c.GetMatchingXrmContracts(It.IsAny<string>())).Returns(contracts.ToList());
            return mock.Object;
        }

        private static ExtendedContractType LoadContract()
        {
            var command = TestResource.FromJson<CreateContractCommand>(
                "ContractCreateDomain.Implementation.Tests",
                "Resources.CreateContractCommand.json");
            return command.CorporateContract;
        }

        private static sfa_contract BuildXrmContractWithRelatedEntities(out Entity allocation, out Entity history)
        {
            var contract = new sfa_contract
            {
                Id = Guid.NewGuid(),
                sfa_number = "C-1",
                sfa_Version = 1,
                sfa_SubVersion = 0,
                sfa_FundingType = new EntityReference("sfa_fundingtype", Guid.NewGuid())
            };

            allocation = new Entity(sfa_contractallocation.EntityLogicalName) { Id = Guid.NewGuid() };
            allocation["sfa_contractallocationnumber"] = "A-1";
            history = new Entity(sfa_contracttransitionhistory.EntityLogicalName) { Id = Guid.NewGuid() };

            var related = new EntityCollection(new List<Entity> { allocation, history });
            contract.RelatedEntities.Add(new Relationship("rel") { PrimaryEntityRole = EntityRole.Referenced }, related);
            return contract;
        }
    }
}
