namespace PaymentManagement.Calculation.Tests.Extensions
{
    using System.Collections.Generic;
    using Calculation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentManagement.Calculation.Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;

    [TestClass]
    public class ActualsSummaryTypeExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ActualsSummaryTypeExtensions_CappingApportionmentPriorityOrder_ShouldReturnNull()
        {
            IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos = new List<FspDeliverableInfo>
            {
                new FspDeliverableInfo(1,  true, null, -1),
                new FspDeliverableInfo(2,  false, 1, -1),
                new FspDeliverableInfo(3,  false, 1, -1),
                new FspDeliverableInfo(4,  false, 2, -1),
                new FspDeliverableInfo(5,  false, 3, -1)
            };

            var actualsSummaryType = new ActualsSummaryType() {DeliverableCode = 1};

            // act
            var result = actualsSummaryType.CappingApportionmentPriorityOrder(fspDeliverableInfos);

            // assert
            Assert.IsNull(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualsSummaryTypeExtensions_CappingApportionmentPriorityOrder_ShouldReturnCorrectValue()
        {
            IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos = new List<FspDeliverableInfo>
            {
                new FspDeliverableInfo(1,  true, null, -1),
                new FspDeliverableInfo(2,  false, 1, -1),
                new FspDeliverableInfo(3,  false, 1, -1),
                new FspDeliverableInfo(4,  false, 2, -1),
                new FspDeliverableInfo(5,  false, 3, -1)
            };

            var actualsSummaryType = new ActualsSummaryType() { DeliverableCode = 5 };

            // act
            var result = actualsSummaryType.CappingApportionmentPriorityOrder(fspDeliverableInfos);

            // assert
            Assert.AreEqual(3, result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualsSummaryTypeExtensions_AllowProfile_ShouldReturnFalse()
        {
            IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos = new List<FspDeliverableInfo>
            {
                new FspDeliverableInfo(1,  true, null, -1),
                new FspDeliverableInfo(2,  false, 1, -1),
                new FspDeliverableInfo(3,  false, 1, -1),
                new FspDeliverableInfo(4,  false, 2, -1),
                new FspDeliverableInfo(5,  false, 3, -1)
            };

            var actualsSummaryType = new ActualsSummaryType() { DeliverableCode = 2};

            // act
            var result = actualsSummaryType.IsAllowProfile(fspDeliverableInfos);

            // assert
            Assert.IsFalse(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActualsSummaryTypeExtensions_AllowProfile_ShouldReturnTrue()
        {
            IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos = new List<FspDeliverableInfo>
            {
                new FspDeliverableInfo(1,  true, null, -1),
                new FspDeliverableInfo(2,  false, 1, -1),
                new FspDeliverableInfo(3,  false, 1, -1),
                new FspDeliverableInfo(4,  false, 2, -1),
                new FspDeliverableInfo(5,  false, 3, -1)
            };

            var actualsSummaryType = new ActualsSummaryType() { DeliverableCode = 1 };

            // act
            var result = actualsSummaryType.IsAllowProfile(fspDeliverableInfos);

            // assert
            Assert.IsTrue(result);
        }
    }
}