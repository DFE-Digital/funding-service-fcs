namespace CrossDomain.Integration.Entities.Tests.Unit
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities;

    [TestClass]
    public class AllocationDeliveryPerformancePartialTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ShouldSerializeActualsPeriods_OnlyWhenAny()
        {
            var p = new AllocationDeliveryPerformance { ActualsPeriods = null };
            Assert.IsFalse(p.ShouldSerializeActualsPeriods());

            p.ActualsPeriods = new AllocationDeliveryPerformanceActualsPeriods { ActualsPeriod = new List<ActualsPeriodTYPE>() };
            Assert.IsFalse(p.ShouldSerializeActualsPeriods());

            p.ActualsPeriods.ActualsPeriod.Add(new ActualsPeriodTYPE());
            Assert.IsTrue(p.ShouldSerializeActualsPeriods());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldSerializeAggregatedAndScheduled_OnlyWhenAny()
        {
            var p = new AllocationDeliveryPerformance
            {
                AggregatedPaymentPeriods = new List<AggregatedPaymentPeriodTYPE>(),
                ScheduledPaymentPeriods = new List<ScheduledPaymentsPeriodTYPE>()
            };
            Assert.IsFalse(p.ShouldSerializeAggregatedPaymentPeriods());
            Assert.IsFalse(p.ShouldSerializeScheduledPaymentPeriods());

            p.AggregatedPaymentPeriods.Add(new AggregatedPaymentPeriodTYPE());
            p.ScheduledPaymentPeriods.Add(new ScheduledPaymentsPeriodTYPE());
            Assert.IsTrue(p.ShouldSerializeAggregatedPaymentPeriods());
            Assert.IsTrue(p.ShouldSerializeScheduledPaymentPeriods());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldSerializeContractDeliverables_PrunesEmptyChildren()
        {
            var child = new DeliverableTYPE { ContractDeliverables = new List<DeliverableTYPE>() };
            var p = new AllocationDeliveryPerformance { ContractDeliverables = new List<DeliverableTYPE> { child } };

            Assert.IsTrue(p.ShouldSerializeContractDeliverables());
            Assert.IsNull(child.ContractDeliverables);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldSerializeContractDeliverables_NoneOrEmpty_False()
        {
            var p = new AllocationDeliveryPerformance { ContractDeliverables = null };
            Assert.IsFalse(p.ShouldSerializeContractDeliverables());

            p.ContractDeliverables = new List<DeliverableTYPE>();
            Assert.IsFalse(p.ShouldSerializeContractDeliverables());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldSerializeAllocationOrganisationRelationships_RequiresNumberAndOrganisation()
        {
            var p = new AllocationDeliveryPerformance();
            Assert.IsFalse(p.ShouldSerializeallocationOrganisationRelationships());

            p.allocationOrganisationRelationships = new allocationOrganisationRelationshipsTYPE { contractAllocationNumber = "A1" };
            Assert.IsFalse(p.ShouldSerializeallocationOrganisationRelationships());

            p.allocationOrganisationRelationships.Organisation = new organisationReferenceTYPE { organisationIdentifier = "ORG" };
            Assert.IsTrue(p.ShouldSerializeallocationOrganisationRelationships());
        }
    }
}
