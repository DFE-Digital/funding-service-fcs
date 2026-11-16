

namespace CrossDomain.Integration.Entities.Tests.Unit
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class contractAllocationsContractAllocationTests
    {
        [TestMethod,TestCategory("UnitTest")]
        public void AssembleChildDeliverables_ShouldConvertAFlatListToHierarchy()
        {
            contractAllocationsContractAllocation alloc = new contractAllocationsContractAllocation();
            var rootDel1 = GetDeliverable(1, null);
            var childDel1 = GetDeliverable(2, 1);
            var childDel2 = GetDeliverable(3, 1);
            var childChildDel1 = GetDeliverable(4, 2);
            var childChildDel2 = GetDeliverable(5, 2);
            var childChildDel3 = GetDeliverable(6, 3);
            var childChildDel4 = GetDeliverable(7, 3);
            var rootDel2 = GetDeliverable(8, null);
            var childDel3 = GetDeliverable(9, 8);
            var childDel4 = GetDeliverable(10, 8);
            var childChildDel5 = GetDeliverable(11, 9);
            var childChildDel6 = GetDeliverable(12, 9);
            var childChildDel7 = GetDeliverable(13, 10);
            var childChildDel8 = GetDeliverable(14, 10);
            var originalDeliverables = 
             new List<contractDeliverablesTypeContractDeliverable>()
            {
                rootDel1 ,
                childDel1 ,
                childDel2 ,
                childChildDel1 ,
                childChildDel2 ,
                childChildDel3 ,
                childChildDel4 ,
                rootDel2 ,
                childDel3 ,
                childDel4 ,
                childChildDel5 ,
                childChildDel6 ,
                childChildDel7 ,
                childChildDel8
            };
            alloc.contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>(originalDeliverables);
            var tree = alloc.AssembleChildDeliverables(alloc.contractDeliverables, null);
            Assert.IsTrue(tree.Contains(rootDel1)
                          && tree.Contains(rootDel2)
                          && tree.Count == 2, "AssembleChildDeliverables returned tree which doesn't contain the correct hierarchy");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AssembleChildDeliverables_ShouldReturnAFlatListIfNoParentDelivarbleIds()
        {
            contractAllocationsContractAllocation alloc = new contractAllocationsContractAllocation();
            var rootDel1 = GetDeliverable(1, null);
            var childDel1 = GetDeliverable(2, null);
            var childDel2 = GetDeliverable(3, null);
            var childChildDel1 = GetDeliverable(4, null);
            var childChildDel2 = GetDeliverable(5, null);
            var childChildDel3 = GetDeliverable(6, null);
            var childChildDel4 = GetDeliverable(7, null);
            var rootDel2 = GetDeliverable(8, null);
            var childDel3 = GetDeliverable(9, null);
            var childDel4 = GetDeliverable(10, null);
            var childChildDel5 = GetDeliverable(11, null);
            var childChildDel6 = GetDeliverable(12, null);
            var childChildDel7 = GetDeliverable(13, null);
            var childChildDel8 = GetDeliverable(14, null);
            var originalDeliverables =
             new List<contractDeliverablesTypeContractDeliverable>()
            {
                rootDel1 ,
                childDel1 ,
                childDel2 ,
                childChildDel1 ,
                childChildDel2 ,
                childChildDel3 ,
                childChildDel4 ,
                rootDel2 ,
                childDel3 ,
                childDel4 ,
                childChildDel5 ,
                childChildDel6 ,
                childChildDel7 ,
                childChildDel8
            };
            alloc.contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>(originalDeliverables);
            var tree = alloc.AssembleChildDeliverables(alloc.contractDeliverables, null);
            originalDeliverables.ForEach(
                d =>
                {
                    Assert.IsTrue(tree.Contains(d), "AssembleChildDeliverables didn't contain deliverable with id: " + d.deliverable.deliverableCode);
                });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FlattenDeliverables_ShouldFlattenDeliverableHierArchicalStructure()
        {
            contractAllocationsContractAllocation alloc = new contractAllocationsContractAllocation();
            var rootDel1 = GetDeliverable(1, null);
            var childDel1 = GetDeliverable(2, 1);
            var childDel2 = GetDeliverable(3, 1);
            var childChildDel1 = GetDeliverable(4, 2);
            var childChildDel2 = GetDeliverable(5, 2);
            var childChildDel3 = GetDeliverable(6, 3);
            var childChildDel4 = GetDeliverable(7, 3);
            var rootDel2 = GetDeliverable(8, null);
            var childDel3 = GetDeliverable(9, 8);
            var childDel4 = GetDeliverable(10, 8);
            var childChildDel5 = GetDeliverable(11, 9);
            var childChildDel6 = GetDeliverable(12, 9);
            var childChildDel7 = GetDeliverable(13, 10);
            var childChildDel8 = GetDeliverable(14, 10);
            var originalDeliverables = 
             new List<contractDeliverablesTypeContractDeliverable>()
            {
                rootDel1 ,
                childDel1 ,
                childDel2 ,
                childChildDel1 ,
                childChildDel2 ,
                childChildDel3 ,
                childChildDel4 ,
                rootDel2 ,
                childDel3 ,
                childDel4 ,
                childChildDel5 ,
                childChildDel6 ,
                childChildDel7 ,
                childChildDel8
            };
            alloc.contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>(originalDeliverables);
            var tree = alloc.AssembleChildDeliverables(alloc.contractDeliverables, null);
            var flattenedList = alloc.FlattenDeliverables(tree);
            originalDeliverables.ForEach(
                d =>
                {
                    Assert.IsTrue(flattenedList.Contains(d), "FlattenDeliverables didn't contain deliverable with id: "+d.deliverable.deliverableCode);
                });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetAllDeliverables_ShouldGetDistinctSet()
        {
            contractAllocationsContractAllocation alloc = new contractAllocationsContractAllocation();
            var rootDel1 = GetDeliverable(1, null);
            var childDel1 = GetDeliverable(2, 1);
            var childDel2 = GetDeliverable(3, 1);
            var childChildDel1 = GetDeliverable(4, 2);
            var childChildDel2 = GetDeliverable(5, 2);
            var childChildDel3 = GetDeliverable(6, 3);
            var childChildDel4 = GetDeliverable(7, 3);
            var rootDel2 = GetDeliverable(8, null);
            var childDel3 = GetDeliverable(9, 8);
            var childDel4 = GetDeliverable(10, 8);
            var childChildDel5 = GetDeliverable(11, 9);
            var childChildDel6 = GetDeliverable(12, 9);
            var childChildDel7 = GetDeliverable(13, 10);
            var childChildDel8 = GetDeliverable(14, 10);
            var originalDeliverables =
             new List<contractDeliverablesTypeContractDeliverable>()
            {
                rootDel1 ,
                childDel1 ,
                childDel2 ,
                childChildDel1 ,
                childChildDel2 ,
                childChildDel3 ,
                childChildDel4 ,
                rootDel2 ,
                childDel3 ,
                childDel4 ,
                childChildDel5 ,
                childChildDel6 ,
                childChildDel7 ,
                childChildDel8
            };
            alloc.contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>(originalDeliverables);
            List<contractDeliverablesTypeContractDeliverable> tree = alloc.AssembleChildDeliverables(alloc.contractDeliverables, null);
            alloc.contractDeliverables.Add(childDel1);
            Assert.AreEqual(15, alloc.contractDeliverables.Count, "We do not have the right amount of deliverables before the act");
            var flattenedList = alloc.GetAllDeliverables();
            Assert.AreEqual(14, flattenedList.Count, "We have not removed the duplicate");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void contractAllocationsContractAllocation_TotalAggregatedPlannedValueShouldGetCorrectValue()
        {
            contractAllocationsContractAllocation alloc = new contractAllocationsContractAllocation();
            contractDeliverablesTypeContractDeliverable parentDeliverable = GetDeliverable(deliverableCode: 1, parentDeliverableCode: null);
            alloc.contractDeliverables.Add(parentDeliverable);
            
            AddDeliverablePeriod(deliverable: parentDeliverable, periodName: "201708", plannedValue: 10M);
            AddDeliverablePeriod(deliverable: parentDeliverable, periodName: "201709", plannedValue: 10M);
            AddDeliverablePeriod(deliverable: parentDeliverable, periodName: "201710", plannedValue: 10M);
            AddDeliverablePeriod(deliverable: parentDeliverable, periodName: "201711", plannedValue: 10M);
            AddDeliverablePeriod(deliverable: parentDeliverable, periodName: "201712", plannedValue: 10M);
            AddDeliverablePeriod(deliverable: parentDeliverable, periodName: "201801", plannedValue: 10M);

            contractDeliverablesTypeContractDeliverable childDeliverable = GetDeliverable(deliverableCode: 2, parentDeliverableCode: 1);
            parentDeliverable.contractDeliverables.Add(childDeliverable);

            AddDeliverablePeriod(deliverable: childDeliverable, periodName: "201708", plannedValue: 10M);
            AddDeliverablePeriod(deliverable: childDeliverable, periodName: "201709", plannedValue: 10M);
            AddDeliverablePeriod(deliverable: childDeliverable, periodName: "201710", plannedValue: 10M);
            AddDeliverablePeriod(deliverable: childDeliverable, periodName: "201711", plannedValue: 10M);
            AddDeliverablePeriod(deliverable: childDeliverable, periodName: "201712", plannedValue: 10M);
            AddDeliverablePeriod(deliverable: childDeliverable, periodName: "201801", plannedValue: 10M);

            var aggregatedPlannedValue = alloc.TotalAggregatedPlannedValue();

            // assert
            Assert.AreEqual(120, aggregatedPlannedValue, "Incorrrect aggregated planned value");
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void contractAllocationsContractAllocation_ShouldGetFundingStreamPeriod()
        {
            // arrange
            contractAllocationsContractAllocation allocation = new contractAllocationsContractAllocation()
            {
                period = new Period()
                {
                    periodType = new periodTypeType()
                    {
                        periodTypeCode = periodTypeCodeType.AY
                    },
                    period1 = "1718"
                },
                fundingStream = new fundingStream()
                {
                    fundingStreamCode = "AGE"
                },
                fundingStreamPeriodCode = null
            };

            // act
            string fspCode = allocation.GetFundingStreamPeriodCode();

            // assert
            Assert.AreEqual("AGE1718", fspCode);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void contractAllocationsContractAllocation_HasDeliveryOrg_ShouldReturnFalseWhenTheDeliveryOrgUkprnAndDeliverOrgDetailNameIsNotSet()
        {
            // arrange
            contractAllocationsContractAllocation allocation = new contractAllocationsContractAllocation
            {
                DeliveryOrganisation = "12345678",
                DeliveryOrganisationDetail = {legalName = null}
            };

            // act
            bool hasDeliveryOrg = allocation.HasDeliveryOrganisation();

            // assert
            Assert.IsFalse(hasDeliveryOrg);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void contractAllocationsContractAllocation_HasDeliveryOrg_ShouldReturnTrueWhenTheDeliveryOrgUkprnAndDeliverOrgDetailNameIsSet()
        {
            // arrange
            contractAllocationsContractAllocation allocation = new contractAllocationsContractAllocation
            {
                DeliveryOrganisation = "12345678",
                DeliveryOrganisationDetail = { legalName = "Some Name" }
            };

            // act
            bool hasDeliveryOrg = allocation.HasDeliveryOrganisation();

            // assert
            Assert.IsTrue(hasDeliveryOrg);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void contractAllocationsContractAllocation_HasDeliveryOrg_ShouldReturnFalseWhenTheDeliveryOrgUkprnIsSetAndDeliverOrgDetailIsNull()
        {
            // arrange
            contractAllocationsContractAllocation allocation = new contractAllocationsContractAllocation
            {
                DeliveryOrganisation = "12345678",
                DeliveryOrganisationDetail = null
            };

            // act
            bool hasDeliveryOrg = allocation.HasDeliveryOrganisation();

            // assert
            Assert.IsFalse(hasDeliveryOrg);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void contractAllocationsContractAllocation_GetDeliverOrgOrDefault_ShouldReturnDeliveryOrgUkprn()
        {
            const int deliveryOrganisationUkprn = 12345678;
            const int defaultUkprn = 999;

            var allocation = new contractAllocationsContractAllocation
            {
                DeliveryOrganisation = deliveryOrganisationUkprn.ToString(),
                DeliveryOrganisationDetail = {legalName = "Some Name", ukprn = deliveryOrganisationUkprn}
            };

            // act
            var assertOrgUkprn = allocation.GetDeliverOrgOrDefault(defaultUkprn);

            // assert
            Assert.AreEqual(deliveryOrganisationUkprn, assertOrgUkprn, "Delivery Organisation Ukprn was not returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void contractAllocationsContractAllocation_GetDeliverOrgOrDefault_ShouldReturnDefaultUkprn()
        {
            const int defaultUkprn = 999;

            var allocation = new contractAllocationsContractAllocation
            {
                DeliveryOrganisation = null,
                DeliveryOrganisationDetail = null
            };

            // act
            var assertOrgUkprn = allocation.GetDeliverOrgOrDefault(defaultUkprn);

            // assert
            Assert.AreEqual(defaultUkprn, assertOrgUkprn, "Default Ukprn was not returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void contractAllocationsContractAllocation_ShouldGetAllocationPrefix()
        {
            // arrange
            contractAllocationsContractAllocation allocation = new contractAllocationsContractAllocation
            {
                contractAllocationNumber = "ABC-123"
            };

            // act
            string prefix = allocation.GetAllocationPrefix();

            Assert.AreEqual("ABC", prefix, "Prefix returned was incorrect");
        }

        private static contractDeliverablesTypeContractDeliverable GetDeliverable(int deliverableCode, int? parentDeliverableCode)
        {
            contractDeliverablesTypeContractDeliverable del = new contractDeliverablesTypeContractDeliverable
            {
                deliverable = new deliverableType()
                {
                    deliverableCode = deliverableCode
                },
                ParentDeliverableCode = parentDeliverableCode,
            };
            return del;
        }

        private static void AddDeliverablePeriod(contractDeliverablesTypeContractDeliverable deliverable, string periodName, decimal plannedValue)
        {
            deliverable.contractDeliverablePeriods.Add(new contractDeliverablePeriodsTypeContractDeliverablePeriod
            {
                periodName = periodName,
                plannedValue = plannedValue
            });
        }
    }
}