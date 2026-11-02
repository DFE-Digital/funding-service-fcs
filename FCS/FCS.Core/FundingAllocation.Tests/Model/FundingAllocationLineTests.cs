namespace FundingAllocation.Tests.Model
{
    using System.Collections.Generic;
    using DataStore.Model;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestHelpers.Extensions;

    [TestClass]
    public class FundingAllocationLineTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationLine_HaveAnyPeriodsWithPlannedValue_ShouldReturnTrueWhenThereIsNonZeroPlannedValue()
        {
            FundingAllocationLine line = new FundingAllocationLine(string.Empty, string.Empty);
            line.AddPeriods(new List<(int period, decimal plannedVale)>{(202101, 10)});

            // act and assert
            line.HaveAnyPeriodsWithPlannedValue().Should().BeTrue();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationLine_HaveAnyPeriodsWithPlannedValue_ShouldReturnFalseWhenThereIsZeroPlannedValue()
        {
            FundingAllocationLine line = new FundingAllocationLine(string.Empty, string.Empty);
            line.AddPeriods(new List<(int period, decimal plannedVale)> { (202101, 0) });

            // act and assert
            line.HaveAnyPeriodsWithPlannedValue().Should().BeFalse();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationLine_HaveAnyPeriodsWithPlannedValue_ShouldReturnFalseWhenThereArentAnyPeriods()
        {
            FundingAllocationLine line = new FundingAllocationLine(string.Empty, string.Empty);

            // act and assert
            line.HaveAnyPeriodsWithPlannedValue().Should().BeFalse();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationLine_HaveAnyPeriodsWithPlannedValue_ShouldReturnTrueWhenValueIsNegative()
        {
            FundingAllocationLine line = new FundingAllocationLine(string.Empty, string.Empty);
            line.AddPeriods(new List<(int period, decimal plannedVale)> { (202101, -10) });

            // act and assert
            line.HaveAnyPeriodsWithPlannedValue().Should().BeTrue();
        }
    }
}
