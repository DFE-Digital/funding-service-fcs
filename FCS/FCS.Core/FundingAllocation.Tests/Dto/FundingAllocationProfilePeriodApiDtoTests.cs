namespace FundingAllocation.Tests.Dto
{
    using System.Collections.Generic;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FundingAllocationProfilePeriodApiDtoTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationProfilePeriodApiDto_ShouldReturnFcsStylePeriod()
        {
            // arrange
            var testCases = new List<(int Year, string Month, int ExpectedPeriod)>
            {
                (2021, "August", 202108),
                (2021, "September", 202109),
                (2021, "October", 202110),
                (2021, "November", 202111),
                (2021, "December", 202112),
                (2022, "January", 202201),
                (2022, "February", 202202),
                (2022, "March", 202203),
                (2022, "April", 202204),
                (2022, "May", 202205),
                (2022, "June", 202206),
                (2022, "July", 202207),
            };
            
            // act
            testCases.ForEach(tc =>
            {
                var dto = new FundingAllocationProfilePeriodApiDto 
                {
                    Year = tc.Year,
                    Month = tc.Month
                };

                // assert
                dto.GetPeriod().Should().Be(tc.ExpectedPeriod);
            });
        }
    }
}
