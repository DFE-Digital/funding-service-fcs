namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Services
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services;
    using System.Collections.Generic;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    [TestClass]
    public class ParentDeliverableResolverTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ParentDeliverableResolver_GetParentDeliverableWithinClaimGroup_ShouldIdentifyCorrectParentDeliverableWhenTwoDeliverableGroupsArePresentInSameAllocationWithSharedAggregatedParent()
        {
            // arrange
            ParentDeliverableResolver parentDeliverableResolver = new ParentDeliverableResolver();

            IReadOnlyCollection<PolicyDeliverable> policyDeliverables = new[]
            {
                new PolicyDeliverable { FundingStreamPeriod = "AEBC1819", DeliverableCode = 1, ParentDeliverableCode = null },
                new PolicyDeliverable { FundingStreamPeriod = "AEBC1819", DeliverableCode = 2, ParentDeliverableCode = 14 },
                new PolicyDeliverable { FundingStreamPeriod = "AEBC1819", DeliverableCode = 3, ParentDeliverableCode = 14 },
                new PolicyDeliverable { FundingStreamPeriod = "AEBC1819", DeliverableCode = 4, ParentDeliverableCode = 14 },
                new PolicyDeliverable { FundingStreamPeriod = "AEBC1819", DeliverableCode = 5, ParentDeliverableCode = 14 },
                new PolicyDeliverable { FundingStreamPeriod = "AEBC1819", DeliverableCode = 6, ParentDeliverableCode = 14 },
                new PolicyDeliverable { FundingStreamPeriod = "AEBC1819", DeliverableCode = 7, ParentDeliverableCode = 14 },
                new PolicyDeliverable { FundingStreamPeriod = "AEBC1819", DeliverableCode = 8, ParentDeliverableCode = 14 },
                new PolicyDeliverable { FundingStreamPeriod = "AEBC1819", DeliverableCode = 9, ParentDeliverableCode = 14 },
                new PolicyDeliverable { FundingStreamPeriod = "AEBC1819", DeliverableCode = 10, ParentDeliverableCode = 14 },
                new PolicyDeliverable { FundingStreamPeriod = "AEBC1819", DeliverableCode = 13, ParentDeliverableCode = 1 },
                new PolicyDeliverable { FundingStreamPeriod = "AEBC1819", DeliverableCode = 14, ParentDeliverableCode = 1 }
            };

            IReadOnlyCollection<FspDeliverableClaim> allClaimGroupDeliverablesForFsp = new[]
            {
                new FspDeliverableClaim("AEBC1819", 1, null, false, null),
                new FspDeliverableClaim("AEBC1819", 2, null, false, "AEBC1819_AS_LS"),
                new FspDeliverableClaim("AEBC1819", 3, null, false, "AEBC1819_AS_LS"),
                new FspDeliverableClaim("AEBC1819", 4, null, false, "AEBC1819_AS_LS"),
                new FspDeliverableClaim("AEBC1819", 5, null, false, "AEBC1819_AS_LS"),
                new FspDeliverableClaim("AEBC1819", 6, null, false, "AEBC1819_AS_LS"),
                new FspDeliverableClaim("AEBC1819", 7, null, false, "AEBC1819_AS_LS"),
                new FspDeliverableClaim("AEBC1819", 8, null, false, "AEBC1819_AS_LS"),
                new FspDeliverableClaim("AEBC1819", 9, null, false, "AEBC1819_AS_LS"),
                new FspDeliverableClaim("AEBC1819", 10, null, false, "AEBC1819_AS_LS"),
                new FspDeliverableClaim("AEBC1819", 13, null, false, "AEBC1819_CL"),
                new FspDeliverableClaim("AEBC1819", 14, null, false, "AEBC1819_AS_LS")
            };

            // act, assert
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(2, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(3, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(4, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(5, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(6, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(7, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(8, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(9, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(10, policyDeliverables, allClaimGroupDeliverablesForFsp));

            Assert.AreEqual(13, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(13, policyDeliverables, allClaimGroupDeliverablesForFsp));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ParentDeliverableResolver_GetParentDeliverableWithinClaimGroup_ShouldIdentifyCorrectParentDeliverableWhenOneDeliverableGroupsIsPresentInAllocationWithOneAggregatedParent()
        {
            // arrange
            ParentDeliverableResolver parentDeliverableResolver = new ParentDeliverableResolver();

            IReadOnlyCollection<PolicyDeliverable> policyDeliverables = new[]
            {
                new PolicyDeliverable { FundingStreamPeriod = "AEB-LS1819", DeliverableCode = 1, ParentDeliverableCode = null },
                new PolicyDeliverable { FundingStreamPeriod = "AEB-LS1819", DeliverableCode = 2, ParentDeliverableCode = 1 },
                new PolicyDeliverable { FundingStreamPeriod = "AEB-LS1819", DeliverableCode = 3, ParentDeliverableCode = 1 },
                new PolicyDeliverable { FundingStreamPeriod = "AEB-LS1819", DeliverableCode = 4, ParentDeliverableCode = 1 },
                new PolicyDeliverable { FundingStreamPeriod = "AEB-LS1819", DeliverableCode = 5, ParentDeliverableCode = 1 }
            };

            IReadOnlyCollection<FspDeliverableClaim> allClaimGroupDeliverablesForFsp = new[]
            {
                new FspDeliverableClaim("AEB-LS1819", 1, null, false, "AEB-LS1819"),
                new FspDeliverableClaim("AEB-LS1819", 2, null, false, "AEB-LS1819"),
                new FspDeliverableClaim("AEB-LS1819", 3, null, false, "AEB-LS1819"),
                new FspDeliverableClaim("AEB-LS1819", 4, null, false, "AEB-LS1819"),
                new FspDeliverableClaim("AEB-LS1819", 5, null, false, "AEB-LS1819")
            };

            // act, assert
            Assert.AreEqual(1, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(2, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(1, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(3, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(1, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(4, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(1, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(5, policyDeliverables, allClaimGroupDeliverablesForFsp));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ParentDeliverableResolver_GetParentDeliverableWithinClaimGroup_ShouldIdentifyCorrectParentDeliverableWhenTwoDeliverableGroupsArePresentInSameAllocationWithSharedAggregatedParentAndMultipleParentChildLevelsInSameDeliverableGroup()
        {
            // arrange
            ParentDeliverableResolver parentDeliverableResolver = new ParentDeliverableResolver();

            IReadOnlyCollection<PolicyDeliverable> policyDeliverables = new[]
            {
                new PolicyDeliverable { FundingStreamPeriod = "FSP1819", DeliverableCode = 1, ParentDeliverableCode = null },
                new PolicyDeliverable { FundingStreamPeriod = "FSP1819", DeliverableCode = 2, ParentDeliverableCode = 14 },
                new PolicyDeliverable { FundingStreamPeriod = "FSP1819", DeliverableCode = 3, ParentDeliverableCode = 14 },
                new PolicyDeliverable { FundingStreamPeriod = "FSP1819", DeliverableCode = 4, ParentDeliverableCode = 14 },
                new PolicyDeliverable { FundingStreamPeriod = "FSP1819", DeliverableCode = 5, ParentDeliverableCode = 14 },
                new PolicyDeliverable { FundingStreamPeriod = "FSP1819", DeliverableCode = 6, ParentDeliverableCode = 14 },
                new PolicyDeliverable { FundingStreamPeriod = "FSP1819", DeliverableCode = 7, ParentDeliverableCode = 14 },
                new PolicyDeliverable { FundingStreamPeriod = "FSP1819", DeliverableCode = 8, ParentDeliverableCode = 14 },
                new PolicyDeliverable { FundingStreamPeriod = "FSP1819", DeliverableCode = 9, ParentDeliverableCode = 2 },
                new PolicyDeliverable { FundingStreamPeriod = "FSP1819", DeliverableCode = 10, ParentDeliverableCode = 2 },
                new PolicyDeliverable { FundingStreamPeriod = "FSP1819", DeliverableCode = 13, ParentDeliverableCode = 1 },
                new PolicyDeliverable { FundingStreamPeriod = "FSP1819", DeliverableCode = 14, ParentDeliverableCode = 1 }
            };

            IReadOnlyCollection<FspDeliverableClaim> allClaimGroupDeliverablesForFsp = new[]
            {
                new FspDeliverableClaim("FSP1819", 1, null, false, null),
                new FspDeliverableClaim("FSP1819", 2, null, false, "FSP1819_AS_LS"),
                new FspDeliverableClaim("FSP1819", 3, null, false, "FSP1819_AS_LS"),
                new FspDeliverableClaim("FSP1819", 4, null, false, "FSP1819_AS_LS"),
                new FspDeliverableClaim("FSP1819", 5, null, false, "FSP1819_AS_LS"),
                new FspDeliverableClaim("FSP1819", 6, null, false, "FSP1819_AS_LS"),
                new FspDeliverableClaim("FSP1819", 7, null, false, "FSP1819_AS_LS"),
                new FspDeliverableClaim("FSP1819", 8, null, false, "FSP1819_AS_LS"),
                new FspDeliverableClaim("FSP1819", 9, null, false, "FSP1819_AS_LS"),
                new FspDeliverableClaim("FSP1819", 10, null, false, "FSP1819_AS_LS"),
                new FspDeliverableClaim("FSP1819", 13, null, false, "FSP1819_CL"),
                new FspDeliverableClaim("FSP1819", 14, null, false, "FSP1819_AS_LS")
            };

            // act, assert
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(2, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(3, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(4, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(5, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(6, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(7, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(8, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(9, policyDeliverables, allClaimGroupDeliverablesForFsp));
            Assert.AreEqual(14, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(10, policyDeliverables, allClaimGroupDeliverablesForFsp));

            Assert.AreEqual(13, parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(13, policyDeliverables, allClaimGroupDeliverablesForFsp));
        }
    }
}
