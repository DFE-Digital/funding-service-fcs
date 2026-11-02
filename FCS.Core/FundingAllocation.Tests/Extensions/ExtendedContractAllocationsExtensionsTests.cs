namespace FundingAllocation.Tests.Extensions
{
    using System;
    using System.Collections.Generic;
    using FluentAssertions;
    using FundingAllocation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ExtendedContractAllocationsExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ExtendedContractAllocationsExtensions_ShouldGetEarliestStartDateAndLatestEndDate()
        {
            // arrange
            DateTime earliestStartDate = DateTime.Now;
            DateTime latestEndDate = earliestStartDate.AddYears(1);
            List<ExtendedContractAllocation> allocations = new List<ExtendedContractAllocation>
            {
                new ExtendedContractAllocation
                {
                    startDate = earliestStartDate,
                    endDate = latestEndDate.AddMonths(-1)
                },
                new ExtendedContractAllocation
                {
                    startDate = earliestStartDate.AddMonths(1),
                    endDate = latestEndDate.AddMonths(-2)
                },
                new ExtendedContractAllocation
                {
                    startDate = earliestStartDate.AddMonths(2),
                    endDate = latestEndDate
                }
            };

            // act
            var dateInfo = allocations.GetEarliestStartDateAndLatestEndDate();
            
            // assert
            dateInfo.startDate.Should().Be(earliestStartDate);
            dateInfo.endDate.Should().Be(latestEndDate);
        }
    }
}
