namespace FundingAllocation.Tests.Extensions
{
    using System.Collections.Generic;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using FundingAllocation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class FundingAllocationContractGroupsExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationContractGroupsExtensions_GetDistinctFundingTypeFundingPeriods_ShouldReturnADistinctListOfFundingTypeFundingPeriods()
        {
            // Arrange
            const int notRelevantInt = -1;
            const string notRelevantString = "";
            var notRelevantListString = new List<string>();
            var notRelevantContractItemsMappingResult = new ContractItemsMappingResult(notRelevantString,
                notRelevantString, notRelevantString, notRelevantString);

            var fundingAllocationContractGroups = new List<FundingAllocationContractGroup>
            {
                new FundingAllocationContractGroup(notRelevantInt, "ft1", "fp1", notRelevantListString, notRelevantContractItemsMappingResult),
                new FundingAllocationContractGroup(notRelevantInt, "ft1", "fp1", notRelevantListString, notRelevantContractItemsMappingResult),
                new FundingAllocationContractGroup(notRelevantInt, "ft2", "fp2", notRelevantListString, notRelevantContractItemsMappingResult),
                new FundingAllocationContractGroup(notRelevantInt, "ft2", "fp2", notRelevantListString, notRelevantContractItemsMappingResult),
                new FundingAllocationContractGroup(notRelevantInt, "ft3", "fp3", notRelevantListString, notRelevantContractItemsMappingResult),
                new FundingAllocationContractGroup(notRelevantInt, "ft3", "fp3", notRelevantListString, notRelevantContractItemsMappingResult),
            }.ToArray();

            // Act
            var result = fundingAllocationContractGroups.GetDistinctFundingTypeFundingPeriods();

            // Assert
            Assert.AreEqual(3, result.Count, "Incorrect number returned");

            var expectedFundingTypeFundingPeriods = new List<FundingTypeFundingPeriod>
            {
                new FundingTypeFundingPeriod("ft1", "fp1"),
                new FundingTypeFundingPeriod("ft2", "fp2"),
                new FundingTypeFundingPeriod("ft3", "fp3"),
            };

            result.Should().BeEquivalentTo(expectedFundingTypeFundingPeriods);
        }
    }
}