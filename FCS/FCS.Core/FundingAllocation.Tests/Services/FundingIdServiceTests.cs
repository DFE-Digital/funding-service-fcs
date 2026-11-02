namespace FundingAllocation.Tests.Services
{
    using FundingAllocation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;
    using FundingAllocation.Repositories;
    using Moq;
    using FluentAssertions;
    using FundingAllocation.Extensions;

    [TestClass]
    public class FundingIdServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingIdService_GetFundingIdsForLatestVersions_ShouldReturnLatestVersionOfFundingIds()
        {
            // arrange
            var fundingIds = new List<string>
            {
                "DADA-AY-2021-Contract-Provider-10017535-2_3",
                "1619-AS-2021-Contract-Provider-10014005-4_2",
                "NLG-AY-2021-Contract-LocalAuthoritySsf-10017535-6_2",
                "1619-AS-2021-Contract-Provider-10014005-4_3",
                "1619-AS-2021-Contract-Provider-10014005-4_4",
                "1619-AS-2021-Contract-Provider-10014005-4_5",
                "1619-AS-2021-Contract-Provider-10014005-4_6",
                "DifferentFundingName___________________-1_0",
                "DADA-AY-2021-Contract-Provider-10017535-1_3",
                "DADA-AY-2021-Contract-Provider-10017535-3_3",
                "NLG-AY-2021-Contract-LocalAuthoritySsf-10017535-3_2",
                "NLG-AY-2021-Contract-LocalAuthoritySsf-10017535-6_1",
                "NLG-AY-2021-Contract-LocalAuthoritySsf-10017535-5_2",
            };

            var expectedLatestFundingIds = new List<string>
            {
                "1619-AS-2021-Contract-Provider-10014005-4_6",
                "DifferentFundingName___________________-1_0",
                "DADA-AY-2021-Contract-Provider-10017535-3_3",
                "NLG-AY-2021-Contract-LocalAuthoritySsf-10017535-6_2",
            };

            var fundingAllocationRepositoryMock = new Mock<IFundingAllocationRepository>();
            fundingAllocationRepositoryMock
                .Setup(m => m.GetFundingIdsForReadId(It.IsAny<int>()))
                .ReturnsAsync(fundingIds);

            var service = new FundingIdService(fundingAllocationRepositoryMock.Object);

            // act
            var fundingIdsReturned = service.GetFundingIdsForLatestVersions(1).Result;

            // assert
            fundingIdsReturned.lastestFundingIds.Should().BeEquivalentTo(expectedLatestFundingIds);
            var expectedSuperseded = fundingIds.Where(f => expectedLatestFundingIds.DoesNotContain(f)).ToList();
            fundingIdsReturned.supersededFundingIds.Should().BeEquivalentTo(expectedSuperseded);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingIdService_GetProviderNotFoundToBeSuperseded_ShouldReturnVersionsToBeSuperseded()
        {
            // arrange
            var fundingIds = new List<string>
            {
                "DADA-AY-2021-Contract-Provider-10017535-2_3",
                "1619-AS-2021-Contract-Provider-10014005-4_2",
                "NLG-AY-2021-Contract-LocalAuthoritySsf-10017535-6_2",
                "1619-AS-2021-Contract-Provider-10014005-4_3",
                "1619-AS-2021-Contract-Provider-10014005-4_4",
                "1619-AS-2021-Contract-Provider-10014005-4_5",
                "1619-AS-2021-Contract-Provider-10014005-4_6",
                "DifferentFundingName___________________-1_0",
                "DADA-AY-2021-Contract-Provider-10017535-1_3",
                "DADA-AY-2021-Contract-Provider-10017535-3_3",
                "NLG-AY-2021-Contract-LocalAuthoritySsf-10017535-3_2",
                "NLG-AY-2021-Contract-LocalAuthoritySsf-10017535-6_1",
                "NLG-AY-2021-Contract-LocalAuthoritySsf-10017535-5_2",
            };

            var expectedLatestFundingIds = new List<string>
            {
                "DADA-AY-2021-Contract-Provider-10017535-2_3",
                "DADA-AY-2021-Contract-Provider-10017535-1_3",
                "1619-AS-2021-Contract-Provider-10014005-4_2",
                "1619-AS-2021-Contract-Provider-10014005-4_3",
                "1619-AS-2021-Contract-Provider-10014005-4_4",
                "1619-AS-2021-Contract-Provider-10014005-4_5",
                "NLG-AY-2021-Contract-LocalAuthoritySsf-10017535-3_2",
                "NLG-AY-2021-Contract-LocalAuthoritySsf-10017535-5_2",
                "NLG-AY-2021-Contract-LocalAuthoritySsf-10017535-6_1"
            };

            var fundingAllocationRepositoryMock = new Mock<IFundingAllocationRepository>();
            fundingAllocationRepositoryMock
                .Setup(m => m.GetFundingIdsWithStatusAndSubStatus(FundingAllocationStatus.Parked, FundingAllocationSubStatus.AwaitingProvider))
                .ReturnsAsync(fundingIds);

            var service = new FundingIdService(fundingAllocationRepositoryMock.Object);

            // act
            var fundingIdsReturned = service.GetProviderNotFoundToBeSuperseded().Result;

            // assert
            fundingIdsReturned.Should().BeEquivalentTo(expectedLatestFundingIds);
        }
    }
}