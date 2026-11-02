namespace FundingAllocation.Tests.Endpoints.CreateProvidersIfNecessaryReply.Services
{
    using System.Collections.Generic;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Endpoints.CreateProvidersIfNecessaryReply.Services;
    using FundingAllocation.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using TestHelpers;

    [TestClass]
    public class FundingLineFilterServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingLineFilterService_FilterOutZeroValuedOfNoInterestLines_ShouldRemoveOnlyLinesThatAreNotPresent()
        {
            // arrange
            const string providerFundingId = "1619-AS-2122-10000001-2_0";
            const string previousProviderFundingId = "1619-AS-2122-10000001-1_1";
            
            var previousLines = new List<FundingAllocationLine>
            {
                new FundingAllocationLine(previousProviderFundingId, "1619-001")
            };
            
            var currentLines = new List<FundingAllocationLine>
            {
                new FundingAllocationLine(providerFundingId, "1619-001"),
                new FundingAllocationLine(providerFundingId, "1619-002")
            };

            FundingAllocation fundingAllocation =
                FundingAllocationHelper.FundingAllocationWithFundingId(
                    "1619-AS-2122-Contracting-LocalAuthority-10000001-2_0").WithProviderAndFundingAllocationLines(currentLines);

            Mock<IFundingAllocationRepository> fundingAllocationRepositoryMock = new Mock<IFundingAllocationRepository>();
            fundingAllocationRepositoryMock
                .Setup(r => r.GetLatestPublishedFundingLines(It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync(previousLines);

            FundingLineFilterService service = new FundingLineFilterService(fundingAllocationRepositoryMock.Object);
            // act
            service.FilterOutZeroValuedOfNoInterestLines(fundingAllocation).Wait();

            // assert
            fundingAllocation.GetFundingAllocationLines().Count.Should().Be(1);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingLineFilterService_FilterOutZeroValuedOfNoInterestLines_ShouldNotRemoveAnyLinesIfTheyArePresentInPreviousPublished()
        {
            // arrange
            const string providerFundingId = "1619-AS-2122-10000001-2_0";
            const string previousProviderFundingId = "1619-AS-2122-10000001-1_1";

            var previousLines = new List<FundingAllocationLine>
            {
                new FundingAllocationLine(previousProviderFundingId, "1619-001"),
                new FundingAllocationLine(previousProviderFundingId, "1619-002")
            };

            var currentLines = new List<FundingAllocationLine>
            {
                new FundingAllocationLine(providerFundingId, "1619-001"),
                new FundingAllocationLine(providerFundingId, "1619-002")
            };

            FundingAllocation fundingAllocation =
                FundingAllocationHelper.FundingAllocationWithFundingId(
                    "1619-AS-2122-Contracting-LocalAuthority-10000001-2_0").WithProviderAndFundingAllocationLines(currentLines);

            var fundingAllocationRepositoryMock = new Mock<IFundingAllocationRepository>();
            fundingAllocationRepositoryMock
                .Setup(r => r.GetLatestPublishedFundingLines(It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync(previousLines);

            FundingLineFilterService service = new FundingLineFilterService(fundingAllocationRepositoryMock.Object);
            // act
            service.FilterOutZeroValuedOfNoInterestLines(fundingAllocation).Wait();

            // assert
            fundingAllocation.GetFundingAllocationLines().Count.Should().Be(2);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingLineFilterService_FilterOutZeroValuedOfNoInterestLines_ShouldRemoveAllLinesIfTheyAreNotPresentInPreviousPublished()
        {
            // arrange
            const string providerFundingId = "1619-AS-2122-10000001-2_0";
            const string previousProviderFundingId = "1619-AS-2122-10000001-1_1";

            var previousLines = new List<FundingAllocationLine>
            {
                new FundingAllocationLine(previousProviderFundingId, "1619-003"),
                new FundingAllocationLine(previousProviderFundingId, "1619-004")
            };

            var currentLines = new List<FundingAllocationLine>
            {
                new FundingAllocationLine(providerFundingId, "1619-001"),
                new FundingAllocationLine(providerFundingId, "1619-002")
            };

            FundingAllocation fundingAllocation =
                FundingAllocationHelper.FundingAllocationWithFundingId(
                    "1619-AS-2122-Contracting-LocalAuthority-10000001-2_0").WithProviderAndFundingAllocationLines(currentLines);

            var fundingAllocationRepositoryMock = new Mock<IFundingAllocationRepository>();
            fundingAllocationRepositoryMock
                .Setup(r => r.GetLatestPublishedFundingLines(It.IsAny<string>(), It.IsAny<string>()))
                .ReturnsAsync(previousLines);

            FundingLineFilterService service = new FundingLineFilterService(fundingAllocationRepositoryMock.Object);
            // act
            service.FilterOutZeroValuedOfNoInterestLines(fundingAllocation).Wait();

            // assert
            fundingAllocation.GetFundingAllocationLines().Count.Should().Be(0);
        }
    }
}
