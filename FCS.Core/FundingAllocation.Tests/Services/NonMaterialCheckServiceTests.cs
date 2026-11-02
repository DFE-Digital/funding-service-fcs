namespace FundingAllocation.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using FundingAllocation.Extensions;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using TestHelpers.Extensions;

    [TestClass]
    public class NonMaterialCheckServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void NonMaterialCheckService_GetFilterCheckResult_ShouldNotFilterWhenThereArentAnyContractApproved()
        {
            // arrange
            Mock<IFundingAllocationRepository> mockFundingAllocationRep = new Mock<IFundingAllocationRepository>();
            mockFundingAllocationRep
                .Setup(r => r.GetLatestContractApprovedFundingAllocationIds(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync(new List<FundingIdAndName>());

            NonMaterialCheckService service = new NonMaterialCheckService(mockFundingAllocationRep.Object);

            List<string> fundingIds = new List<string>
            {
                "1619-AY-2021-Contract-Provider-10014002-2_0", "1619-AY-2021-Contract-Provider-10014003-2_0"
            };
            // act
            var filterCheckResult = service.GetFilterCheckResult(fundingIds).Result;

            // assert
            filterCheckResult.FundingIdsFilteredOut.Should().BeEmpty();
            filterCheckResult.FundingIdsForContractControl.Count.Should().Be(fundingIds.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NonMaterialCheckService_GetFilterCheckResult_ShouldReturnFundingIdsThatAreMateriallyDifferentFromLastApproved()
        {
            // arrange
            const string fundingIdOfApproved = "NMSS-AY-2021-Contract-Provider-10017562-4_4";
            const string fundingIdOfParkedWithMaterialDifference = "NMSS-AY-2021-Contract-Provider-10017562-5_2";
            const string providerFundingOfApproved = "NMSS-AY-2021-10017562-4_4";
            const string providerFundingOfParked = "NMSS-AY-2021-10017562-5_2";
            const string lineCode = "NLG-001";
            Mock<IFundingAllocationRepository> mockFundingAllocationRep = new Mock<IFundingAllocationRepository>();
            mockFundingAllocationRep
                .Setup(r => r.GetLatestContractApprovedFundingAllocationIds(new List<string>{fundingIdOfParkedWithMaterialDifference.RemoveVersionFromId()}))
                .ReturnsAsync(new List<FundingIdAndName>
                {
                    new FundingIdAndName(fundingIdOfApproved, fundingIdOfApproved.RemoveVersionFromId())
                });

            mockFundingAllocationRep
                .Setup(r => r.GetFundingAllocations(new List<string> { fundingIdOfApproved, fundingIdOfParkedWithMaterialDifference  }))
                .ReturnsAsync(new List<FundingAllocation>
                {
                    CreateFundingAllocation(fundingIdOfApproved).WithProviderWithLineCodeAndPlannedValue(providerFundingOfApproved, lineCode, 10M),
                    CreateFundingAllocation(fundingIdOfParkedWithMaterialDifference).WithProviderWithLineCodeAndPlannedValue(providerFundingOfParked, lineCode, 11M),
                });

            NonMaterialCheckService service = new NonMaterialCheckService(mockFundingAllocationRep.Object);

            List<string> fundingIds = new List<string>
            {
                fundingIdOfParkedWithMaterialDifference
            };
            // act
            var filterCheckResult = service.GetFilterCheckResult(fundingIds).Result;

            // assert
            filterCheckResult.FundingIdsForContractControl.Single().Should().Be(fundingIdOfParkedWithMaterialDifference);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NonMaterialCheckService_GetFilterCheckResult_ShouldReturnEmptyFundingIdsWhenParkedAreMateriallyDifferentFromLastApproved()
        {
            // arrange
            const string fundingIdOfApproved = "NMSS-AY-2021-Contract-Provider-10017562-4_4";
            const string fundingIdOfParkedWithMaterialDifference = "NMSS-AY-2021-Contract-Provider-10017562-5_2";
            const string providerFundingOfApproved = "NMSS-AY-2021-10017562-4_4";
            const string providerFundingOfParked = "NMSS-AY-2021-10017562-5_2";
            const string lineCode = "NLG-001";
            const decimal periodPlannedValue = 10M;
            Mock<IFundingAllocationRepository> mockFundingAllocationRep = new Mock<IFundingAllocationRepository>();
            mockFundingAllocationRep
                .Setup(r => r.GetLatestContractApprovedFundingAllocationIds(new List<string> { fundingIdOfParkedWithMaterialDifference.RemoveVersionFromId() }))
                .ReturnsAsync(new List<FundingIdAndName>
                {
                    new FundingIdAndName(fundingIdOfApproved, fundingIdOfApproved.RemoveVersionFromId())
                });

            mockFundingAllocationRep
                .Setup(r => r.GetFundingAllocations(new List<string> { fundingIdOfApproved, fundingIdOfParkedWithMaterialDifference }))
                .ReturnsAsync(new List<FundingAllocation>
                {
                    CreateFundingAllocation(fundingIdOfApproved).WithProviderWithLineCodeAndPlannedValue(providerFundingOfApproved, lineCode, periodPlannedValue),
                    CreateFundingAllocation(fundingIdOfParkedWithMaterialDifference).WithProviderWithLineCodeAndPlannedValue(providerFundingOfParked, lineCode, periodPlannedValue),
                });

            NonMaterialCheckService service = new NonMaterialCheckService(mockFundingAllocationRep.Object);

            List<string> fundingIds = new List<string>
            {
                fundingIdOfParkedWithMaterialDifference
            };
            // act
            var filterCheckResult = service.GetFilterCheckResult(fundingIds).Result;

            // assert
            filterCheckResult.FundingIdsForContractControl.Any().Should().BeFalse();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NonMaterialLoanFilterCheckService_GetFilterCheckResult_ShouldNotFilterWhenThereArentAnyContractApproved()
        {
            // arrange
            Mock<IFundingAllocationRepository> mockFundingAllocationRep = new Mock<IFundingAllocationRepository>();
            mockFundingAllocationRep
                .Setup(r => r.GetFundingLinePlannedValueForFundingAllocationIds(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync(new List<FundingLineValue>()
                  {
                        new FundingLineValue (  100, "LOANS-001", "LOANS-AY-2021-Contract-Provider-10014002-2_0" ),
                        new FundingLineValue (  101, "LOANS-002", "LOANS-AY-2021-Contract-Provider-10014002-2_0" ),
                        new FundingLineValue (  101, "LOANS-003", "LOANS-AY-2021-Contract-Provider-10014002-2_0" ),
                        new FundingLineValue (  100, "LOANS-001", "LOANS-AY-2021-Contract-Provider-10014003-2_0" ),
                        new FundingLineValue (  100, "LOANS-002", "LOANS-AY-2021-Contract-Provider-10014003-2_0" ),
                        new FundingLineValue (  0,  "LOANS-003","LOANS-AY-2021-Contract-Provider-10014003-2_0" ),
                        new FundingLineValue (  10,  "1619-003","1619-AY-2021-Contract-Provider-10014004-2_0" )
                  });

            NonMaterialCheckService service = new NonMaterialCheckService(mockFundingAllocationRep.Object);

            List<string> fundingIds = new List<string>
            {
                "LOANS-AY-2021-Contract-Provider-10014002-2_0",
                "LOANS-AY-2021-Contract-Provider-10014003-2_0",
                "1619-AY-2021-Contract-Provider-10014004-2_0"
            };
            // act
            var filterCheckResult = service.GetLoanFilterCheckResult(fundingIds).Result;

            // assert
            filterCheckResult.FundingIdsFilteredOut.Count().Should().Be(fundingIds.Count - 2); ;
            filterCheckResult.FundingIdsForContractControl.Count.Should().Be(fundingIds.Count - 1);
        }


        private static FundingAllocation CreateFundingAllocation(string fundingId)
        {
            return new FundingAllocation(fundingId, string.Empty, string.Empty, string.Empty, string.Empty, 0, 0, 0, 1, 0);
        }
    }
}
