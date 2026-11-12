namespace CrossDomain.Integration.Entities.Tests.CorporateContract
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ContractTypePartialTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetFundingPeriod_PeriodSet_ReturnsTypeCodeAndPeriod()
        {
            var contract = new contractType { period = CreatePeriod(periodTypeCodeType.AY, "1819") };

            Assert.AreEqual("AY1819", contract.GetFundingPeriod());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetFundingPeriod_PeriodNull_Throws()
        {
            try
            {
                new contractType { period = null }.GetFundingPeriod();
                Assert.Fail("Expected exception");
            }
            catch (InvalidOperationException)
            {
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IsPeriod_MatchesPeriodNumber()
        {
            var contract = new contractType { period = CreatePeriod(periodTypeCodeType.FY, "1920") };

            Assert.IsTrue(contract.IsPeriod("1920"));
            Assert.IsFalse(contract.IsPeriod("1819"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IsNotification_IsInverseOfIsVariation()
        {
            var contract = new contractType { IsVariation = false };
            Assert.IsTrue(contract.IsNotification);

            contract.IsVariation = true;
            Assert.IsFalse(contract.IsNotification);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SharedMasterApprovedContracts_DefaultsToEmptyAndCanBeSet()
        {
            var contract = new contractType();
            Assert.AreEqual(0, contract.SharedMasterApprovedContracts.Count);

            var list = new List<ApprovedContractInfo>();
            contract.SharedMasterApprovedContracts = list;

            Assert.AreSame(list, contract.SharedMasterApprovedContracts);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IsModified_ReflectsAllocations()
        {
            var contract = new contractType { contractAllocations = null };
            Assert.IsFalse(contract.IsModified);

            contract.contractAllocations = new List<contractAllocationsContractAllocation> { new contractAllocationsContractAllocation() };
            Assert.IsFalse(contract.IsModified);

            contract.contractAllocations.Add(new contractAllocationsContractAllocation { NewStartsSuspendedReason = "reason" });
            Assert.IsTrue(contract.IsModified);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetFspCodes_ReturnsDistinctCodes()
        {
            var contract = ContractWithAllocations(
                Allocation("ALLOC-1", fspCode: "FSP1"),
                Allocation("ALLOC-2", fspCode: "FSP1"),
                Allocation("ALLOC-3", fspCode: "FSP2"));

            CollectionAssert.AreEqual(new[] { "FSP1", "FSP2" }, contract.GetFspCodes().ToList());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetFspCodesForAllocationsThatHaveChanged_ReturnsOnlyChanged()
        {
            var contract = ContractWithAllocations(
                Allocation("ALLOC-1", fspCode: "FSP1", changed: true),
                Allocation("ALLOC-2", fspCode: "FSP2"),
                Allocation("ALLOC-3", fspCode: "FSP1", changed: true));

            CollectionAssert.AreEqual(new[] { "FSP1" }, contract.GetFspCodesForAllocationsThatHaveChanged().ToList());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetFspCodesForAllAllocations_ExcludesSbps()
        {
            var contract = ContractWithAllocations(
                Allocation("ALLOC-1", fspCode: "FSP1", fundingStreamCode: "ABC"),
                Allocation("ALLOC-2", fspCode: "FSP2", fundingStreamCode: "SBPS"),
                Allocation("ALLOC-3", fspCode: "FSP1", fundingStreamCode: "DEF"));

            CollectionAssert.AreEqual(new[] { "FSP1" }, contract.GetFspCodesForAllAllocations().ToList());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetOrganisation_AllocationWithoutDeliveryOrg_ReturnsContractor()
        {
            var contractorOrg = new Contractor { ukprn = 111, legalName = "Contractor" };
            var contract = ContractWithAllocations(Allocation("ALLOC-1"));
            contract.contractor = contractorOrg;

            Assert.AreSame(contractorOrg, contract.GetOrganisation("ALLOC-1"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetOrganisation_AllocationWithDeliveryOrg_ReturnsDeliveryOrg()
        {
            var deliveryOrg = new Contractor { ukprn = 222, legalName = "Delivery" };
            var allocation = Allocation("ALLOC-1");
            allocation.DeliveryOrganisation = "222";
            allocation.DeliveryOrganisationDetail = deliveryOrg;
            var contract = ContractWithAllocations(allocation);
            contract.contractor = new Contractor { ukprn = 111, legalName = "Contractor" };

            Assert.AreSame(deliveryOrg, contract.GetOrganisation("ALLOC-1"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetNumberPartOfNumber_ParsesSecondSegment()
        {
            var contract = new contractType { contractNumber = "ABC-1234" };

            Assert.AreEqual(1234, contract.GetNumberPartOfNumber());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IsRoundOneEsf_DependsOnFundingTypeAndNumber()
        {
            Assert.IsTrue(EsfContract("ESF", "ESF-4999").IsRoundOneEsf());
            Assert.IsFalse(EsfContract("ESF", "ESF-5000").IsRoundOneEsf());
            Assert.IsFalse(EsfContract("ILR", "ILR-1").IsRoundOneEsf());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RemoveTimeComponentsFromDate_StripsTimeFromContractAndAllocations()
        {
            var withTime = new DateTime(2019, 8, 1, 13, 45, 10);
            var allocation = Allocation("ALLOC-1");
            allocation.startDate = withTime;
            allocation.endDate = withTime.AddDays(10);
            var noEndAllocation = Allocation("ALLOC-2");
            noEndAllocation.startDate = withTime;
            noEndAllocation.endDate = null;
            var contract = ContractWithAllocations(allocation, noEndAllocation);
            contract.startDate = withTime;
            contract.endDate = withTime.AddMonths(1);

            contract.RemoveTimeComponentsFromDate();

            Assert.AreEqual(withTime.Date, contract.startDate);
            Assert.AreEqual(withTime.AddMonths(1).Date, contract.endDate);
            Assert.AreEqual(withTime.Date, allocation.startDate);
            Assert.AreEqual(withTime.AddDays(10).Date, allocation.endDate);
            Assert.AreEqual(withTime.Date, noEndAllocation.startDate);
            Assert.IsNull(noEndAllocation.endDate);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RemoveTimeComponentsFromDate_NullEndDate_StaysNull()
        {
            var contract = ContractWithAllocations();
            contract.startDate = null;
            contract.endDate = null;

            contract.RemoveTimeComponentsFromDate();

            Assert.AreEqual(default(DateTime), contract.startDate);
            Assert.IsNull(contract.endDate);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FlattenDeliverablesOnAllocations_MovesNestedDeliverablesToAllocation()
        {
            var child = Deliverable(2);
            var parent = Deliverable(1);
            parent.contractDeliverables.Add(child);
            var allocation = Allocation("ALLOC-1");
            allocation.contractDeliverables = new List<contractDeliverablesTypeContractDeliverable> { parent };
            var contract = ContractWithAllocations(allocation);

            contract.FlattenDeliverablesOnAllocations();

            Assert.AreEqual(2, allocation.contractDeliverables.Count);
            Assert.IsTrue(allocation.contractDeliverables.All(d => d.contractDeliverables.Count == 0));
            Assert.AreEqual(1, allocation.contractDeliverables.Single(d => d.deliverable.deliverableCode == 2).ParentDeliverableCode);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AlignDeliveryOrgs_SomeAllocationsForOtherOrg_AssignsContractorToTheRest()
        {
            var other = Allocation("ALLOC-1");
            other.DeliveryOrganisation = "999";
            var own = Allocation("ALLOC-2");
            var contract = ContractWithAllocations(other, own);
            contract.contractor = new Contractor { ukprn = 111 };

            contract.AlignDeliveryOrgs();

            Assert.AreEqual("999", other.DeliveryOrganisation);
            Assert.AreEqual("111", own.DeliveryOrganisation);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AlignDeliveryOrgs_AllAllocationsForContractor_ClearsDeliveryOrgs()
        {
            var a1 = Allocation("ALLOC-1");
            a1.DeliveryOrganisation = "111";
            var a2 = Allocation("ALLOC-2");
            var contract = ContractWithAllocations(a1, a2);
            contract.contractor = new Contractor { ukprn = 111 };

            contract.AlignDeliveryOrgs();

            Assert.IsNull(a1.DeliveryOrganisation);
            Assert.IsNull(a2.DeliveryOrganisation);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeAllocationsOnToContract_NewAllocation_IsAdded()
        {
            var contract = ContractWithAllocations(Allocation("ALLOC-1"));
            var toMerge = ExtendedAllocation("ALLOC-2");

            contract.MergeAllocationsOnToContract(new[] { toMerge }, ContractIntent.New);

            Assert.AreEqual(2, contract.contractAllocations.Count);
            Assert.AreSame(toMerge, contract.contractAllocations[1]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeAllocationsOnToContract_UpdateDraft_AddsNewDeliverablesToExistingAllocation()
        {
            var existing = Allocation("ALLOC-1");
            existing.contractDeliverables.Add(Deliverable(1));
            var contract = ContractWithAllocations(existing);
            var toMerge = ExtendedAllocation("ALLOC-1");
            toMerge.contractDeliverables.Add(Deliverable(2));

            contract.MergeAllocationsOnToContract(new[] { toMerge }, ContractIntent.UpdateDraft);

            CollectionAssert.AreEqual(new[] { 1, 2 }, existing.contractDeliverables.Select(d => d.deliverable.deliverableCode).ToList());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeAllocationsOnToContract_UpdateDraft_DuplicateDeliverable_Throws()
        {
            var existing = Allocation("ALLOC-1");
            existing.contractDeliverables.Add(Deliverable(1));
            var contract = ContractWithAllocations(existing);
            var toMerge = ExtendedAllocation("ALLOC-1");
            toMerge.contractDeliverables.Add(Deliverable(1));

            try
            {
                contract.MergeAllocationsOnToContract(new[] { toMerge }, ContractIntent.UpdateDraft);
                Assert.Fail("Expected exception");
            }
            catch (InvalidOperationException)
            {
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MergeAllocationsOnToContract_OtherIntent_UpdatesPlannedValuesAndAddsNewDeliverables()
        {
            var existingDeliverable = Deliverable(1);
            existingDeliverable.contractDeliverablePeriods.Add(Period(2019, 1, 10m));
            existingDeliverable.contractDeliverablePeriods.Add(Period(2019, 2, 20m));
            var existing = Allocation("ALLOC-1");
            existing.contractDeliverables.Add(existingDeliverable);
            var contract = ContractWithAllocations(existing);

            var updatedDeliverable = Deliverable(1);
            updatedDeliverable.contractDeliverablePeriods.Add(Period(2019, 1, 99m));
            updatedDeliverable.contractDeliverablePeriods.Add(Period(2019, 3, 77m));
            var newDeliverable = Deliverable(2);
            var toMerge = ExtendedAllocation("ALLOC-1");
            toMerge.contractDeliverables.Add(updatedDeliverable);
            toMerge.contractDeliverables.Add(newDeliverable);

            contract.MergeAllocationsOnToContract(new[] { toMerge }, ContractIntent.New);

            Assert.AreEqual(99m, existingDeliverable.contractDeliverablePeriods.Single(p => p.period == 1).plannedValue);
            Assert.AreEqual(20m, existingDeliverable.contractDeliverablePeriods.Single(p => p.period == 2).plannedValue);
            Assert.AreEqual(2, existingDeliverable.contractDeliverablePeriods.Count);
            Assert.AreEqual(2, existing.contractDeliverables.Count);
            Assert.AreSame(newDeliverable, existing.contractDeliverables[1]);
        }

        private static Period CreatePeriod(periodTypeCodeType typeCode, string periodNumber)
        {
            return new Period
            {
                period1 = periodNumber,
                periodType = new periodTypeType { periodTypeCode = typeCode }
            };
        }

        private static contractType EsfContract(string fundingTypeCode, string number)
        {
            return new contractType
            {
                contractNumber = number,
                fundingType = new fundingType { fundingTypeCode = fundingTypeCode }
            };
        }

        private static contractType ContractWithAllocations(params contractAllocationsContractAllocation[] allocations)
        {
            return new contractType { contractAllocations = allocations.ToList() };
        }

        private static contractAllocationsContractAllocation Allocation(
            string number,
            string fspCode = null,
            bool changed = false,
            string fundingStreamCode = "FS")
        {
            return new contractAllocationsContractAllocation
            {
                contractAllocationNumber = number,
                fundingStreamPeriodCode = fspCode,
                HasBeenAddedOrUpdated = changed,
                fundingStream = new fundingStream { fundingStreamCode = fundingStreamCode },
                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>()
            };
        }

        private static ExtendedContractAllocation ExtendedAllocation(string number)
        {
            return new ExtendedContractAllocation
            {
                contractAllocationNumber = number,
                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>()
            };
        }

        private static contractDeliverablesTypeContractDeliverable Deliverable(int code)
        {
            return new contractDeliverablesTypeContractDeliverable
            {
                deliverable = new deliverableType { deliverableCode = code },
                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>(),
                contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>()
            };
        }

        private static contractDeliverablePeriodsTypeContractDeliverablePeriod Period(int year, int period, decimal value)
        {
            return new contractDeliverablePeriodsTypeContractDeliverablePeriod { year = year, period = period, plannedValue = value };
        }
    }
}
