namespace FundingAllocation.Tests.Dto
{
    using System.Collections.Generic;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class CrmContractInfoTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractInfo_GetExistingAllocationNumber_ShouldReturnValueIfPresent()
        {
            // arrange
            const string fsCode = "some fs";
            const string deliveryUkprn = "12345678";
            const string allocationNumber = "16ED-4399";

            CrmContractInfo contractInfo = new CrmContractInfo(
                null, 0, 0, 12345678, null, "masterContractNumber", "Variation",
                new List<CrmAllocationInfo>
                {
                    new CrmAllocationInfo(fsCode, deliveryUkprn, allocationNumber),
                    new CrmAllocationInfo("some other", "44444444", "TEST-1223"),
                }, 1);

            // act
            var allocationNumberOption = contractInfo.GetExistingAllocationNumber(fsCode, int.Parse(deliveryUkprn));

            // assert
            allocationNumberOption.Match(Some: n => n.Should().Be(4399),
                None: () => Assert.Fail("Should have returned a number"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractInfo_GetExistingAllocationNumber_ShouldReturnNoneIfNotPresent()
        {
            // arrange
            const string fsCode = "some fs";
            const string deliveryUkprn = "12345678";
            const string allocationNumber = "16ED-4399";

            CrmContractInfo contractInfo = new CrmContractInfo(
                null, 0, 0, 12345678, null, "masterContractNumber", "Variation",
                new List<CrmAllocationInfo>
                {
                    new CrmAllocationInfo(fsCode, deliveryUkprn, allocationNumber)
                }, 1);

            // act
            var allocationNumberOption = contractInfo.GetExistingAllocationNumber(fsCode, 87654321);

            // assert
            allocationNumberOption.IsNone.Should().BeTrue();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractInfo_GetExistingAllocationNumber_ShouldReturnNonehenExistingDoesntHaveDeliveryButFsMatches()
        {
            // arrange
            const string fsCode = "some fs";
            const string deliveryUkprn = null;
            const string allocationNumber = "16ED-4399";

            CrmContractInfo contractInfo = new CrmContractInfo(
                null, 0, 0, 12345678, null, "masterContractNumber", "Variation",
                new List<CrmAllocationInfo>
                {
                    new CrmAllocationInfo(fsCode, deliveryUkprn, allocationNumber)
                }, 1);

            // act
            var allocationNumberOption = contractInfo.GetExistingAllocationNumber(fsCode, 87654321);

            // assert
            allocationNumberOption.Match(Some: i =>Assert.Fail("Should not have returned a number"),
                None: () => { });
        }


        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractInfo_GetExistingAllocationNumber_ShouldReturnResultWhenDeliveryUkprnMatchesContractingUkprnAndFsMatches()
        {
            // arrange
            const string fsCode = "some fs";
            const string deliveryUkprn = null;
            const string allocationNumber = "16ED-4399";
            const int contractUkprn = 12345678;

            CrmContractInfo contractInfo = new CrmContractInfo(
                null, 0, 0, contractUkprn, null, "masterContractNumber", "Variation",
                new List<CrmAllocationInfo>
                {
                    new CrmAllocationInfo(fsCode, deliveryUkprn, allocationNumber)
                }, 0);

            // act
            var allocationNumberOption = contractInfo.GetExistingAllocationNumber(fsCode, contractUkprn);

            // assert
            allocationNumberOption.Match(Some: i => i.Should().Be(4399),
                None: () => Assert.Fail("Should have returned a value"));
        }
    }
}
