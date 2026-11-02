namespace FundingAllocation.Tests.Dto
{
    using System.Collections.Generic;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class ContractItemsMappingResultTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractItemsMappingResult_GetPeriodTypeCode_ShouldReturnPeriodIfItCan()
        {
            // arrange
            List<(string fundingPeriodCode, periodTypeCodeType periodTypeCode)> inputsWithResult =
                new List<(string fundingPeriodCode, periodTypeCodeType periodTypeCode)>
                {
                    ("AY2122", periodTypeCodeType.AY),
                    ("FY2122", periodTypeCodeType.FY)
                };

            inputsWithResult.ForEach(i =>
            {
                ContractItemsMappingResult result = new ContractItemsMappingResult(string.Empty, i.fundingPeriodCode, string.Empty, string.Empty);

                // act and assert
                result.GetPeriodTypeCode().Should().BeEquivalentTo(i.periodTypeCode);
            });
        }
    }
}
