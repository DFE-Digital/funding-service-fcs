namespace PaymentManagement.Calculation.Tests.Dtos
{
    using System.Collections.Generic;
    using Calculation.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class CappingGroupInfoTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CappingGroupInfo_GetAdjustedCap_ShouldReturnCorrectlyWhenBothOverDelivering()
        {
            // arrange
            List<CappingGroupInfo> otherCappingGroupInfos = new List<CappingGroupInfo>
            {
                new CappingGroupInfo(1, 6000, 6200, allowUnderDeliveryToBeUsed:true, allowOverDeliveryToBeOffset:false),
                new CappingGroupInfo(2, plannedValue:9000, actualValue:12000, allowUnderDeliveryToBeUsed:false, allowOverDeliveryToBeOffset:true)
            };

            // act
            var adjusted = CappingGroupInfo.GetAdjustedCapForGroup(otherCappingGroupInfos, 1);

            // assert
            Assert.AreEqual(-200, adjusted);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CappingGroupInfo_GetAdjustedCap_ShouldReturnCorrectlyWhenPartialOverDeliveringOnCurrent()
        {
            // arrange
            List<CappingGroupInfo> otherCappingGroupInfos = new List<CappingGroupInfo>
            {
                new CappingGroupInfo(1, 6000, 3300, allowUnderDeliveryToBeUsed:true, allowOverDeliveryToBeOffset:false),
                new CappingGroupInfo(2, plannedValue:9000, actualValue:12000, allowUnderDeliveryToBeUsed:false, allowOverDeliveryToBeOffset:true)
            };

            // act
            var adjusted = CappingGroupInfo.GetAdjustedCapForGroup(otherCappingGroupInfos, 2);

            // assert
            Assert.AreEqual(-300, adjusted);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CappingGroupInfo_GetAdjustedCap_ShouldReturnCorrectlyWhenPartialOverDeliveringOnOther()
        {
            // arrange
            List<CappingGroupInfo> otherCappingGroupInfos = new List<CappingGroupInfo>
            {
                new CappingGroupInfo(1, 6000, 3300, allowUnderDeliveryToBeUsed:true, allowOverDeliveryToBeOffset:false),
                new CappingGroupInfo(2, plannedValue:9000, actualValue:12000, allowUnderDeliveryToBeUsed:false, allowOverDeliveryToBeOffset:true)
            };

            // act
            var adjusted = CappingGroupInfo.GetAdjustedCapForGroup(otherCappingGroupInfos, 1);

            // assert
            Assert.AreEqual(-0, adjusted);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CappingGroupInfo_GetAdjustedCap_ShouldReturnCorrectlyWhenPartialOverDeliveringOnCurrentButYouAreNotAllowToUseUnderOnOther()
        {
            // arrange
            List<CappingGroupInfo> otherCappingGroupInfos = new List<CappingGroupInfo>
            {
                new CappingGroupInfo(1, 9000, 12000, allowUnderDeliveryToBeUsed:true, allowOverDeliveryToBeOffset:false),
                new CappingGroupInfo(2, plannedValue:6000, actualValue:3300, allowUnderDeliveryToBeUsed:false, allowOverDeliveryToBeOffset:true)
            };

            // act
            var adjusted = CappingGroupInfo.GetAdjustedCapForGroup(otherCappingGroupInfos, 1);

            // assert
            Assert.AreEqual(-3000, adjusted);
        }
    }
}
