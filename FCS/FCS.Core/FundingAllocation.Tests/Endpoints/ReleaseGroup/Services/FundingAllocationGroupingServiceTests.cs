namespace FundingAllocation.Tests.Endpoints.ReleaseGroup.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using FundingAllocation.Endpoints.ReleaseGroup.Repositories;
    using FundingAllocation.Endpoints.ReleaseGroup.Services;
    using FundingAllocation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class FundingAllocationGroupingServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationGroupingService_ShouldGroupFundingAllocationsByFundingTypeFundingPeriodContractingUkprn()
        {
            // arrange
            FundingAllocationGroupingInfo[] fundingAllocationGroupingInfos =
            {
                new FundingAllocationGroupingInfo( // EDSK-AY2021-10000001
                    "PSG-AY-2021-Payment-AcademyTrust-10000001-1_0",
                    "PSG",
                    "AY-2021",
                    "10000001",
                    "Furth",
                    "01GFE"),
                new FundingAllocationGroupingInfo( // EDSK-AY2021-10000001
                    "NMSS-AY-2021-Payment-AcademyTrust-10000001-1_0",
                    "NMSS",
                    "AY-2021",
                    "10000001",
                    "Furth",
                    "01GFE"),
                new FundingAllocationGroupingInfo( // NLG-AY2021-10000001
                    "NLG-AY-2021-Payment-AcademyTrust-10000001-1_0",
                    "NLG",
                    "AY-2021",
                    "10000001",
                    "Furth",
                    "01GFE"),
                new FundingAllocationGroupingInfo( // EDSK-AY2021-10000002
                    "PSG-AY-2021-Payment-AcademyTrust-10000002-1_0",
                    "PSG",
                    "AY-2021",
                    "10000002",
                    "Furth",
                    "01GFE"),
                new FundingAllocationGroupingInfo( // EDSK-AY2022-10000002
                    "PSG-AY-2022-Payment-AcademyTrust-10000002-1_0",
                    "PSG",
                    "AY-2022",
                    "10000002",
                    "Furth",
                    "01GFE"),
                new FundingAllocationGroupingInfo( // EDSK-AY2022-10000002
                    "NMSS-AY-2022-Payment-AcademyTrust-10000002-1_0",
                    "NMSS",
                    "AY-2022",
                    "10000002",
                    "Furth",
                    "01GFE")
            };

            ContractItemsMappingResult[] contractItemMappings =
            {
                new ContractItemsMappingResult(
                    "EDSK",
                    "AY2021",
                    "16-19ED2021",
                    "Conditions of Funding (Grant) (College)"),
                new ContractItemsMappingResult(
                    "EDSK",
                    "AY2021",
                    "16-19ED2021",
                    "Conditions of Funding (Grant) (College)"),
                new ContractItemsMappingResult(
                    "NLG",
                    "AY2021",
                    "1NLG2021",
                    "Conditions of Funding (Grant) (College)"),
                new ContractItemsMappingResult(
                    "EDSK",
                    "AY2021",
                    "16-19ED2021",
                    "Conditions of Funding (Grant) (College)"),
                new ContractItemsMappingResult(
                    "EDSK",
                    "AY2022",
                    "16-19ED2022",
                    "Conditions of Funding (Grant) (College)"),
                new ContractItemsMappingResult(
                    "EDSK",
                    "AY2022",
                    "16-19ED2022",
                    "Conditions of Funding (Grant) (College)")
            };

            var fundingAllocationRepositoryMock = new Mock<IReleaseGroupFundingAllocationRepository>();
            fundingAllocationRepositoryMock
                .Setup(m => m.GetFundingAllocationGroupingInfos(It.IsAny<IEnumerable<string>>()))
                .ReturnsAsync(fundingAllocationGroupingInfos);
            var cfsToFcsCodeMappingServiceMock = new Mock<ICfsToFcsCodeMappingService>();
            cfsToFcsCodeMappingServiceMock
                .SetupSequence(m => m.GetContractItemsMappingResult(It.IsAny<ContractItemsMappingInput>()))
                .ReturnsAsync(contractItemMappings.First())
                .ReturnsAsync(contractItemMappings.Skip(1).First())
                .ReturnsAsync(contractItemMappings.Skip(2).First())
                .ReturnsAsync(contractItemMappings.Skip(3).First())
                .ReturnsAsync(contractItemMappings.Skip(4).First())
                .ReturnsAsync(contractItemMappings.Skip(5).First());

            var service = new FundingAllocationGroupingService(
                fundingAllocationRepositoryMock.Object,
                cfsToFcsCodeMappingServiceMock.Object);

            string[] fundingIds = fundingAllocationGroupingInfos.Select(fa => fa.FundingId).ToArray();

            // act
            FundingAllocationContractGroup[] results = service.GetFundingAllocationContractGroups(fundingIds).Result;

            // assert
            results.Should().NotBeNull();
            results.Should().HaveCount(4);

            var contractGroupResult1HasAllExpectedProperties = results.Any(contractGroup =>
                contractGroup.FundingAllocationIds.Count == 2 &&
                contractGroup.ContractingUkprn == 10000001 &&
                contractGroup.FundingAllocationIds.Contains("PSG-AY-2021-Payment-AcademyTrust-10000001-1_0") &&
                contractGroup.FundingAllocationIds.Contains("NMSS-AY-2021-Payment-AcademyTrust-10000001-1_0"));

            var contractGroupResult2HasAllExpectedProperties = results.Any(contractGroup =>
                contractGroup.FundingAllocationIds.Count == 1 &&
                contractGroup.ContractingUkprn == 10000001 &&
                contractGroup.FundingAllocationIds.Contains("NLG-AY-2021-Payment-AcademyTrust-10000001-1_0"));

            var contractGroupResult3HasAllExpectedProperties = results.Any(contractGroup =>
                contractGroup.FundingAllocationIds.Count == 1 &&
                contractGroup.ContractingUkprn == 10000002 &&
                contractGroup.FundingAllocationIds.Contains("PSG-AY-2021-Payment-AcademyTrust-10000002-1_0"));

            var contractGroupResult4HasAllExpectedProperties = results.Any(contractGroup =>
                contractGroup.FundingAllocationIds.Count == 2 &&
                contractGroup.ContractingUkprn == 10000002 &&
                contractGroup.FundingAllocationIds.Contains("PSG-AY-2022-Payment-AcademyTrust-10000002-1_0") &&
                contractGroup.FundingAllocationIds.Contains("NMSS-AY-2022-Payment-AcademyTrust-10000002-1_0"));

            contractGroupResult1HasAllExpectedProperties.Should().BeTrue();
            contractGroupResult2HasAllExpectedProperties.Should().BeTrue();
            contractGroupResult3HasAllExpectedProperties.Should().BeTrue();
            contractGroupResult4HasAllExpectedProperties.Should().BeTrue();
        }
    }
}
