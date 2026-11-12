namespace ContractCreateDomain.Tests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class MasherMissingCrmRecordTests
    {
        private static contractType Child(string number, Intent crmIntent, params contractAllocation[] allocations)
        {
            return new contractType
            {
                contractNumber = number,
                CRMIntent = crmIntent,
                contractAllocations = allocations.ToList()
            };
        }

        private static contractAllocation Allocation(string number, Intent crmIntent, params contractDeliverable[] deliverables)
        {
            return new contractAllocation
            {
                contractAllocationNumber = number,
                CRMIntent = crmIntent,
                contractDeliverables = deliverables.ToList()
            };
        }

        private static contractDeliverable Deliverable(int code, Intent crmIntent, params int[] periods)
        {
            return new contractDeliverable
            {
                deliverable = new deliverableType { deliverableCode = code },
                CRMIntent = crmIntent,
                contractDeliverablePeriods = periods
                    .Select(p => new contractDeliverablePeriodType { period = p, year = 2016 })
                    .ToList()
            };
        }

        private static contractType Master(params contractType[] children)
        {
            return new contractType { contractNumber = "M1", contracts = children.ToList() };
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Mash_NewChildContract_IsAddedToCrmContract()
        {
            var crm = Master(Child("C1", Intent.UpdateDraft));
            var import = Master(Child("C2", Intent.New));

            var result = new Masher().Mash(crm, import);

            Assert.AreEqual(2, result.contracts.Count);
            Assert.IsTrue(result.contracts.Any(c => c.contractNumber == "C2"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Mash_DeleteDraftChildContractNotInCrm_AddsImportWithCrmNotPresent()
        {
            var crm = Master(Child("C1", Intent.UpdateDraft));
            var import = Master(Child("C9", Intent.DeleteDraft));

            var result = new Masher().Mash(crm, import);

            var added = result.contracts.Single(c => c.contractNumber == "C9");
            Assert.IsTrue(added.crmNotPresent);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Mash_DeleteDraftChildContractInCrm_RemovesIt()
        {
            var crm = Master(Child("C1", Intent.UpdateDraft), Child("C2", Intent.UpdateDraft));
            var import = Master(Child("C1", Intent.DeleteDraft));

            var result = new Masher().Mash(crm, import);

            Assert.AreEqual(1, result.contracts.Count);
            Assert.AreEqual("C2", result.contracts[0].contractNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Mash_DeleteDraftAllocationNotInCrm_AddsImportWithCrmNotPresent()
        {
            var crm = Master(Child("C1", Intent.UpdateDraft, Allocation("A1", Intent.UpdateDraft)));
            var import = Master(Child("C1", Intent.UpdateDraft, Allocation("A9", Intent.DeleteDraft)));

            var result = new Masher().Mash(crm, import);

            var allocation = result.contracts[0].contractAllocations.Single(a => a.contractAllocationNumber == "A9");
            Assert.IsTrue(allocation.crmNotPresent);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Mash_DeleteDraftDeliverableNotInCrm_AddsImportWithCrmNotPresent()
        {
            var crm = Master(Child("C1", Intent.UpdateDraft, Allocation("A1", Intent.UpdateDraft, Deliverable(1, Intent.UpdateDraft))));
            var import = Master(Child("C1", Intent.UpdateDraft, Allocation("A1", Intent.UpdateDraft, Deliverable(9, Intent.DeleteDraft))));

            var result = new Masher().Mash(crm, import);

            var deliverable = result.contracts[0].contractAllocations[0].contractDeliverables
                .Single(d => d.deliverable.deliverableCode == 9);
            Assert.IsTrue(deliverable.crmNotPresent);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Mash_UpdatedDeliverableWithNewPeriod_AddsPeriodToCrmDeliverable()
        {
            var crm = Master(Child("C1", Intent.UpdateDraft, Allocation("A1", Intent.UpdateDraft, Deliverable(1, Intent.UpdateDraft, 1))));
            var import = Master(Child("C1", Intent.UpdateDraft, Allocation("A1", Intent.UpdateDraft, Deliverable(1, Intent.UpdateDraft, 1, 2))));

            var result = new Masher().Mash(crm, import);

            var periods = result.contracts[0].contractAllocations[0].contractDeliverables[0].contractDeliverablePeriods;
            Assert.AreEqual(2, periods.Count);
            Assert.IsTrue(periods.Any(p => p.period == 2));
        }
    }
}
