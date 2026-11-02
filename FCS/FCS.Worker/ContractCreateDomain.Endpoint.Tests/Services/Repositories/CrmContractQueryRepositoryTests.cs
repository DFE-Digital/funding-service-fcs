namespace ContractCreateDomain.Endpoint.Tests.Services.Repositories
{
    using System;
    using System.Linq;
    using Endpoint.Services.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class CrmContractQueryRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractQueryRepository_GetApprovedContract_ShouldGetContract()
        {
            // arrange
            const string contactNumber = "Test123";
            const string allocationNumber = "A123";
            const string deliverableCode1 = "1";
            const string deliverableCode2 = "2";
            const string periodNameAug = "201908";
            const int periodAug = 8;
            const string periodNameSep = "201909";
            const int year = 2019;
            const int periodSep = 9;

            const decimal plannedValueAug = 101;
            const decimal plannedValueSep = 1001;

            RemoveContract(contactNumber);

            var contractId = CreateApprovedContract(contactNumber, 1, 0);
            var allocationId = CreateAllocation(contractId, allocationNumber);
            var deliverableId = CreateDeliverable(allocationId, deliverableCode1);
            CreateDeliverablePeriod(deliverableId, periodNameAug, periodAug, plannedValueAug, year);
            deliverableId = CreateDeliverable(allocationId, deliverableCode2);
            CreateDeliverablePeriod(deliverableId, periodNameAug, periodAug, plannedValueAug, year);
            CreateDeliverablePeriod(deliverableId, periodNameSep, periodSep, plannedValueSep, year);

            CrmContractQueryRepository repository = new CrmContractQueryRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());
            
            // act
            var optionalContract = repository.GetApprovedContract(contactNumber);

            // assert
            Assert.IsTrue(optionalContract.HasValue, "we have not found a contract");
            optionalContract.MatchSome(c =>
                {
                    Assert.IsNotNull(c.Allocations , "The number of allocations have not been set");
                    Assert.AreEqual(1, c.Allocations.Count, "The number of allocations is incorrect");
                    var deliverables = c.Allocations.First().Deliverables;
                    Assert.AreEqual(2, deliverables.Count, "The number of deliverables is incorrect");
                    var deliverablesForCode1 = deliverables.Where(d => d.Code == deliverableCode1).ToList();
                    Assert.AreEqual(1, deliverablesForCode1.Count, "The number of deliverablesForCode1 is incorrect");
                    Assert.AreEqual(1, deliverablesForCode1.First().Periods.Count, "The number of periods for deliverablesForCode1 is incorrect");
                    var period = deliverablesForCode1.First().Periods.First();
                    Assert.AreEqual(periodNameAug, period.PeriodName, "The PeriodName for deliverablesForCode1 is incorrect");
                    Assert.AreEqual(plannedValueAug, period.PlannedValue, "The PlannedValue for deliverablesForCode1 is incorrect");
                    Assert.AreEqual(periodAug, period.Period, "The Period for deliverablesForCode1 is incorrect");

                    var deliverablesForCode2 = deliverables.Where(d => d.Code == deliverableCode2).ToList();
                    Assert.AreEqual(1, deliverablesForCode2.Count, "The number of deliverablesForCode2 is incorrect");
                    var periodsForDelCode2 = deliverablesForCode2.First().Periods;
                    Assert.AreEqual(2, periodsForDelCode2.Count, "The number of periods for deliverablesForCode2 is incorrect");
                    var periodSepForDelCode2 = periodsForDelCode2.FirstOrDefault(p => p.PeriodName == periodNameSep);
                    Assert.IsNotNull(periodSepForDelCode2, "The period for del code 2 for Sep is not set");
                    Assert.AreEqual(plannedValueSep, periodSepForDelCode2.PlannedValue, "The planned value for Sep deliverablesForCode2 is incorrect");
                });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractQueryRepository_GetApprovedContract_ShouldGetNoneWhenContractNotThere()
        {
            // arrange
            CrmContractQueryRepository repository = new CrmContractQueryRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            var optionalContract = repository.GetApprovedContract("Some unlikely number");

            // assert
            Assert.IsFalse(optionalContract.HasValue, "we have found a contract");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractQueryRepository_HasSiblingContractWithDraftStatus_ShouldReturnFalseWhenThereAreNoSiblingContracts()
        {
            // Arrange
            const string masterContractNumber = "SFA-9899";
            const string contractNumberPrefix = "MAIN-989";
            const string actContract = contractNumberPrefix + "0";
            const string siblingContract1 = contractNumberPrefix + "1";
            const string siblingContract2 = contractNumberPrefix + "2";
            const string siblingContract3 = contractNumberPrefix + "3";

            RemoveContract(siblingContract3);
            RemoveContract(siblingContract2);
            RemoveContract(siblingContract1);
            RemoveContract(actContract);
            RemoveContract(masterContractNumber);

            var masterContractId = CreateMasterContract(masterContractNumber, 1, 0, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(actContract, 1, 0, masterContractId, sfa_contractstatus.Approved);

            CrmContractQueryRepository repository = new CrmContractQueryRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // Act 
            var hasSiblingContractWithDraftStatus = repository.HasSiblingContractWithDraftStatus(masterContractNumber, actContract);

            // Assert
            Assert.IsFalse(hasSiblingContractWithDraftStatus, "Incorrectly detected a sibling contract with Draft status");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractQueryRepository_HasSiblingContractWithDraftStatus_ShouldReturnFalseWhenAllSiblingContractsDoNotHaveDraftStatus()
        {
            // Arrange
            const string masterContractNumber = "SFA-9899";
            const string contractNumberPrefix = "MAIN-989";
            const string actContract = contractNumberPrefix + "0";
            const string siblingContract1 = contractNumberPrefix + "1";
            const string siblingContract2 = contractNumberPrefix + "2";
            const string siblingContract3 = contractNumberPrefix + "3";

            RemoveContract(siblingContract3);
            RemoveContract(siblingContract2);
            RemoveContract(siblingContract1);
            RemoveContract(actContract);
            RemoveContract(masterContractNumber);

            var masterContractId = CreateMasterContract(masterContractNumber, 1, 0, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(actContract, 1, 0, masterContractId, sfa_contractstatus.Approved);

            CreateContractWithMasterContractId(siblingContract1, 1, 0, masterContractId, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(siblingContract2, 1, 0, masterContractId, sfa_contractstatus.Replaced);
            CreateContractWithMasterContractId(siblingContract3, 1, 0, masterContractId, sfa_contractstatus.Withdrawn);

            CrmContractQueryRepository repository = new CrmContractQueryRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // Act 
            var hasSiblingContractWithDraftStatus = repository.HasSiblingContractWithDraftStatus(masterContractNumber, actContract);

            // Assert
            Assert.IsFalse(hasSiblingContractWithDraftStatus, "Incorrectly detected a sibling contract with Draft status");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractQueryRepository_HasSiblingContractWithDraftStatus_ShouldReturnTrueWhenOneSiblingContractsHasDraftStatus()
        {
            // Arrange
            const string masterContractNumber = "SFA-9899";
            const string contractNumberPrefix = "MAIN-989";
            const string actContract = contractNumberPrefix + "0";
            const string siblingContract1 = contractNumberPrefix + "1";
            const string siblingContract2 = contractNumberPrefix + "2";
            const string siblingContract3 = contractNumberPrefix + "3";

            RemoveContract(siblingContract3);
            RemoveContract(siblingContract2);
            RemoveContract(siblingContract1);
            RemoveContract(actContract);
            RemoveContract(masterContractNumber);

            var masterContractId = CreateMasterContract(masterContractNumber, 1, 0, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(actContract, 1, 0, masterContractId, sfa_contractstatus.Approved);

            CreateContractWithMasterContractId(siblingContract1, 1, 0, masterContractId, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(siblingContract2, 1, 0, masterContractId, sfa_contractstatus.Replaced);
            CreateContractWithMasterContractId(siblingContract3, 1, 0, masterContractId, sfa_contractstatus.Draft);

            CrmContractQueryRepository repository = new CrmContractQueryRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // Act 
            var hasSiblingContractWithDraftStatus = repository.HasSiblingContractWithDraftStatus(masterContractNumber, actContract);

            // Assert
            Assert.IsTrue(hasSiblingContractWithDraftStatus, "Did not detect a sibling contract with Draft status");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractQueryRepository_HasSiblingContractWithDraftStatus_ShouldReturnTrueWhenMoreThanOneSiblingContractsHasDraftStatus()
        {
            // Arrange
            const string masterContractNumber = "SFA-9899";
            const string contractNumberPrefix = "MAIN-989";
            const string actContract = contractNumberPrefix + "0";
            const string siblingContract1 = contractNumberPrefix + "1";
            const string siblingContract2 = contractNumberPrefix + "2";
            const string siblingContract3 = contractNumberPrefix + "3";

            RemoveContract(siblingContract3);
            RemoveContract(siblingContract2);
            RemoveContract(siblingContract1);
            RemoveContract(actContract);
            RemoveContract(masterContractNumber);

            var masterContractId = CreateMasterContract(masterContractNumber, 1, 0, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(actContract, 1, 0, masterContractId, sfa_contractstatus.Approved);

            CreateContractWithMasterContractId(siblingContract1, 1, 0, masterContractId, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(siblingContract2, 1, 0, masterContractId, sfa_contractstatus.Draft);
            CreateContractWithMasterContractId(siblingContract3, 1, 0, masterContractId, sfa_contractstatus.Draft);

            CrmContractQueryRepository repository = new CrmContractQueryRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // Act 
            var hasSiblingContractWithDraftStatus = repository.HasSiblingContractWithDraftStatus(masterContractNumber, actContract);

            // Assert
            Assert.IsTrue(hasSiblingContractWithDraftStatus, "Did not detect a sibling contract with Draft status");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractQueryRepository_HasSiblingContractWithDraftStatus_ShouldReturnTrueWhenMoreThanOneSiblingContractsHasDraftStatusAndContractNumberIsNull()
        {
            // Arrange
            const string masterContractNumber = "SFA-9899";
            const string contractNumberPrefix = "MAIN-989";
            const string actContract = contractNumberPrefix + "0";
            const string siblingContract1 = contractNumberPrefix + "1";
            const string siblingContract2 = contractNumberPrefix + "2";
            const string siblingContract3 = contractNumberPrefix + "3";

            RemoveContract(siblingContract3);
            RemoveContract(siblingContract2);
            RemoveContract(siblingContract1);
            RemoveContract(actContract);
            RemoveContract(masterContractNumber);

            var masterContractId = CreateMasterContract(masterContractNumber, 1, 0, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(actContract, 1, 0, masterContractId, sfa_contractstatus.Approved);

            CreateContractWithMasterContractId(siblingContract1, 1, 0, masterContractId, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(siblingContract2, 1, 0, masterContractId, sfa_contractstatus.Replaced);
            CreateContractWithMasterContractId(siblingContract3, 1, 0, masterContractId, sfa_contractstatus.Draft);

            CrmContractQueryRepository repository = new CrmContractQueryRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // Act 
            var hasSiblingContractWithDraftStatus = repository.HasSiblingContractWithDraftStatus(masterContractNumber, null);

            // Assert
            Assert.IsTrue(hasSiblingContractWithDraftStatus, "Did not detect a sibling contract with Draft status");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractQueryRepository_HasSiblingContractWithDraftStatus_ShouldReturnFalseWhenAllSiblingContractsDoNotHaveDraftStatusAndContractNumberIsNull()
        {
            // Arrange
            const string masterContractNumber = "SFA-9899";
            const string contractNumberPrefix = "MAIN-989";
            const string actContract = contractNumberPrefix + "0";
            const string siblingContract1 = contractNumberPrefix + "1";
            const string siblingContract2 = contractNumberPrefix + "2";
            const string siblingContract3 = contractNumberPrefix + "3";

            RemoveContract(siblingContract3);
            RemoveContract(siblingContract2);
            RemoveContract(siblingContract1);
            RemoveContract(actContract);
            RemoveContract(masterContractNumber);

            var masterContractId = CreateMasterContract(masterContractNumber, 1, 0, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(actContract, 1, 0, masterContractId, sfa_contractstatus.Approved);

            CreateContractWithMasterContractId(siblingContract1, 1, 0, masterContractId, sfa_contractstatus.Approved);
            CreateContractWithMasterContractId(siblingContract2, 1, 0, masterContractId, sfa_contractstatus.Replaced);
            CreateContractWithMasterContractId(siblingContract3, 1, 0, masterContractId, sfa_contractstatus.Withdrawn);

            CrmContractQueryRepository repository = new CrmContractQueryRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // Act 
            var hasSiblingContractWithDraftStatus = repository.HasSiblingContractWithDraftStatus(masterContractNumber, null);

            // Assert
            Assert.IsFalse(hasSiblingContractWithDraftStatus, "Incorrectly detected a sibling contract with Draft status");
        }

        private void RemoveContract(string contractNumber)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                context.sfa_contractSet.Where(c => c.sfa_number == contractNumber)
                    .ForEach(ca => CrmConnectionFactory.GetRetryOnErrorOrganizationService().Delete(sfa_contract.EntityLogicalName, ca.Id));
            }
        }

        private Guid CreateAllocation(Guid contractId, string allocationNumber)
        {
            sfa_contractallocation contractallocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = allocationNumber,
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(contractallocation);
        }

        private Guid CreateDeliverable(Guid allocationId, string deliverableCode)
        {
            sfa_contractdeliverable deliverable = new sfa_contractdeliverable
            {
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId),
                sfa_DeliverableCode = deliverableCode
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(deliverable);
        }

        private Guid CreateDeliverablePeriod(Guid deliverableId, string periodName, int period, decimal plannedValue, int year)
        {
            sfa_contractdeliverableperiod deliverablePeriod = new sfa_contractdeliverableperiod
            {
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId),
                sfa_PeriodName = periodName,
                sfa_Period = period,
                sfa_PlannedValue = plannedValue,
                sfa_Year = year
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(deliverablePeriod);
        }

        private EntityReference GetProvider()
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return xrmContext.AccountSet.First(o => o.sfa_OrganisationID != null).ToEntityReference();
            }
        }

        private Guid CreateApprovedContract(string contractNumber, int version, int subVersion)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_SubVersion = subVersion,
                sfa_ProviderName = GetProvider(),
                sfa_UKPRN = "1"
            };

            Guid contractId = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(contract);

            sfa_contract c = new sfa_contract
            {
                sfa_contractId = contractId,
                sfa_LastApprovedVersion = true
            };

            CrmConnectionFactory.GetRetryOnErrorOrganizationService().Update(c);

            return contractId;
        }

        private static Guid CreateContractWithMasterContractId(string contractNumber, int version, int subVersion, Guid masterContractId, sfa_contractstatus contractStatus)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                Account contractProvider = xrmContext.AccountSet.First();

                sfa_contract contract = new sfa_contract
                {
                    sfa_UKPRN = contractProvider.sfa_UKPRN,
                    sfa_number = contractNumber,
                    sfa_HierarchyType = new OptionSetValue((int) sfa_contracthierarchytype.Contract),
                    sfa_Version = version,
                    sfa_SubVersion = subVersion,
                    sfa_ParentContractId = new EntityReference(sfa_contract.EntityLogicalName, masterContractId),
                    sfa_ProviderName = contractProvider.ToEntityReference()
                };

                Guid contractId = organizationService.Create(contract);

                sfa_contract c = new sfa_contract
                {
                    sfa_contractId = contractId,
                    sfa_LastApprovedVersion = true,
                    sfa_ContractStatusEnum = contractStatus
                };

                CrmConnectionFactory.GetRetryOnErrorOrganizationService().Update(c);

                return contractId;
            }
        }

        private static Guid CreateMasterContract(string masterContractNumber, int version, int subVersion, sfa_contractstatus contractStatus)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                Account contractProvider = xrmContext.AccountSet.First();

                sfa_contract masterContract = new sfa_contract
                {
                    sfa_UKPRN = contractProvider.sfa_UKPRN,
                    sfa_number = masterContractNumber,
                    sfa_HierarchyType = new OptionSetValue((int) sfa_contracthierarchytype.Master),
                    sfa_Version = version,
                    sfa_SubVersion = subVersion,
                    sfa_ProviderName = contractProvider.ToEntityReference(),
                    sfa_ContractStatusEnum = contractStatus
                };

                return organizationService.Create(masterContract);
            }
        }
    }
}
