namespace FundingAllocation.Tests.Extensions
{
    using System.Collections.Generic;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestHelpers.Extensions;

    [TestClass]
    public class FundingAllocationLineExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationLineExtensions_IsMateriallyEquivalentTo_ShouldReturnTrueWhenPeriodsAreTheSame()
        {
            // arrange
            FundingAllocationLine fundingAllocationLine = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine.AddPeriods(new List<(int period, decimal plannedVale)>{(202101, 10), (202102, 11), (202103, 0)});

            FundingAllocationLine fundingAllocationLine2 = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine2.AddPeriods(new List<(int period, decimal plannedVale)> { (202101, 10), (202102, 11), (202104, 0) });

            // act
            bool isMateriallyEquivalentTo = fundingAllocationLine.IsMateriallyEquivalentTo(fundingAllocationLine2);

            // assert
            isMateriallyEquivalentTo.Should().BeTrue();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationLineExtensions_IsMateriallyEquivalentTo_ShouldReturnFalseWhenPeriodsDiffer()
        {
            // arrange
            FundingAllocationLine fundingAllocationLine = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine.AddPeriods(new List<(int period, decimal plannedVale)> { (202101, 10), (202102, 11), (202103, 0) });

            FundingAllocationLine fundingAllocationLine2 = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine2.AddPeriods(new List<(int period, decimal plannedVale)> { (202101, 10), (202102, 11), (202104, 1) });

            // act
            bool isMateriallyEquivalentTo = fundingAllocationLine.IsMateriallyEquivalentTo(fundingAllocationLine2);

            // assert
            isMateriallyEquivalentTo.Should().BeFalse();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationLineExtensions_GetFirstEnvelope_ShouldReturnExpectedSummedValue()
        {
            // arrange
            FundingAllocationLine fundingAllocationLine = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine.AddPeriods(new List<(int period, decimal plannedVale)>
            {
                (202108, 10), (202109, 10), (202110, 10), (202111, 10), (202112, 10), (202201, 10), (202202, 10), (202203, 10),
                (202204, 10), (202205, 10), (202206, 10), (202207, 10)
            });

            // act
            var result = fundingAllocationLine.GetFirstEnvelope();

            // assert
            Assert.AreEqual(80, result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationLineExtensions_GetFirstEnvelope_ShouldReturnExpectedSummedValueWhenJustOnePeriodInFirstEnvelope()
        {
            // arrange
            FundingAllocationLine fundingAllocationLine = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine.AddPeriods(new List<(int period, decimal plannedVale)>
            {
                (202108, 10)
            });

            // act
            var result = fundingAllocationLine.GetFirstEnvelope();

            // assert
            Assert.AreEqual(10, result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationLineExtensions_GetFirstEnvelope_ShouldReturnExpectedSummedValueWhenJustOnePeriodInFirstEnvelopeOnSecondYear()
        {
            // arrange
            FundingAllocationLine fundingAllocationLine = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine.AddPeriods(new List<(int period, decimal plannedVale)>
            {
                (202202, 10)
            });

            // act
            var result = fundingAllocationLine.GetFirstEnvelope();

            // assert
            Assert.AreEqual(10, result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationLineExtensions_GetSecondEnvelope_ShouldReturnExpectedSummedValue()
        {
            // arrange
            FundingAllocationLine fundingAllocationLine = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine.AddPeriods(new List<(int period, decimal plannedVale)>
            {
                (202108, 10), (202109, 10), (202110, 10), (202111, 10), (202112, 10), (202201, 10), (202202, 10), (202203, 10),
                (202204, 10), (202205, 10), (202206, 10), (202207, 10)
            });

            // act
            var result = fundingAllocationLine.GetSecondEnvelope();

            // assert
            Assert.AreEqual(40, result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationLineExtensions_HasNonZeroPlannedValue_ShouldReturnTrueWhenSummedPlannedValuesIsNotZero()
        {
            // arrange
            var fundingAllocationLine = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine.AddPeriods(new List<(int period, decimal plannedValue)>
            {
                (202108, 10), (202109, 10), (202110, 10), (202111, 10), (202112, 10), (202201, 10), (202202, 10), (202203, 10),
                (202204, 10), (202205, 10), (202206, 10), (202207, 10)
            });

            // act
            var result = fundingAllocationLine.HasNonZeroPlannedValue();

            // assert
            Assert.IsTrue(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationLineExtensions_HasNonZeroPlannedValue_ShouldReturnFalseWhenAllPlannedValuesAreZero()
        {
            // arrange
            var fundingAllocationLine = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine.AddPeriods(new List<(int period, decimal plannedValue)>
            {
                (202108, 0), (202109, 0), (202110, 0), (202111, 0), (202112, 0), (202201, 0), (202202, 0), (202203, 0),
                (202204, 0), (202205, 0), (202206, 0), (202207, 0)
            });

            // act
            var result = fundingAllocationLine.HasNonZeroPlannedValue();

            // assert
            Assert.IsFalse(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationLineExtensions_HasNonZeroPlannedValue_ShouldReturnFalseWhenThereAreAMixOfValuesButSumsT1oZero()
        {
            // arrange
            var fundingAllocationLine = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine.AddPeriods(new List<(int period, decimal plannedValue)>
            {
                (202108, -10), (202109, -10), (202110, -10), (202111, -10), (202112, -10), (202201, -10), (202202, 10), (202203, 10),
                (202204, 10), (202205, 10), (202206, 10), (202207, 10)
            });

            // act
            var result = fundingAllocationLine.HasNonZeroPlannedValue();

            // assert
            Assert.IsFalse(result);
        }
    }
}
