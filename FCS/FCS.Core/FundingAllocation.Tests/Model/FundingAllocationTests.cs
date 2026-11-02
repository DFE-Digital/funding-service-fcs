namespace FundingAllocation.Tests.Model
{
    using System;
    using FluentAssertions;
    using FundingAllocation.DataStore.Model;
    using FundingAllocation.Dto;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class FundingAllocationTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocation_GetContractItemsMappingInput_ShouldReturnExpectedValues()
        {
            // arrange
            var fundingAllocation = new FundingAllocation(
                "PSG-AY-2021-Payment-AcademyTrust-10000001-1_0",
                "1_0",
                "AY-2021",
                "PSG",
                "10000001",
                100m,
                1,
                1,
                3,
                1);

            fundingAllocation.ProviderFundingAllocations.AddRange(new []
            {
                new ProviderFundingAllocation(
                    "PSG-AY-2021-10000002-1_0",
                    "PSG-AY-2021-Payment-AcademyTrust-10000001-1_0"
                    )
                {
                    ProviderFunding = new ProviderFunding("PSG-AY-2021-10000002-1_0", 10000002,
                        "Schoo",
                        "08SSF")
                },
                new ProviderFundingAllocation(
                    "PSG-AY-2021-10000003-1_0",
                    "PSG-AY-2021-Payment-AcademyTrust-10000001-1_0")
                {
                    ProviderFunding = new ProviderFunding("", 10000003,
                        "Schoo",
                        "08SSF")
                },
            });

            // act
            ContractItemsMappingInput contractMappingsInput = fundingAllocation.GetContractItemsMappingInput();

            // assert
            contractMappingsInput.Should().NotBeNull();
            contractMappingsInput.AllocationFundingStreamCode.Should().Be("PSG");
            contractMappingsInput.AllocationPeriodId.Should().Be("AY-2021");
            contractMappingsInput.ProviderType.Should().Be("Schoo");
            contractMappingsInput.ProviderSubType.Should().Be("08SSF");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocation_GetContractItemsMappingInput_ShouldThrowInvalidOperationException_WhenNoProviderFundings()
        {
            // arrange
            var fundingAllocation = new FundingAllocation(
                "PSG-AY-2021-Payment-AcademyTrust-10000001-1_0",
                "1_0",
                "AY-2021",
                "PSG",
                "10000001",
                100m,
                1,
                1,
                3, 
                1);

            // act
            Action act = () => fundingAllocation.GetContractItemsMappingInput();

            // assert
            act.Should()
                .Throw<InvalidOperationException>()
                .WithMessage("FundingAllocation must have one or more ProviderFundingAllocations");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocation_GetContractItemsMappingInput_ShouldNotThrowInvalidOperationException_WhenProviderFundingsHaveDifferentProviderTypes()
        {
            // arrange
            var fundingAllocation = new FundingAllocation(
                "PSG-AY-2021-Payment-AcademyTrust-10000001-1_0",
                "1_0",
                "AY-2021",
                "PSG",
                "10000001",
                100m,
                1,
                1,
                3, 
                1);

            fundingAllocation.ProviderFundingAllocations.AddRange(new[]
            {
                new ProviderFundingAllocation(
                    "PSG-AY-2021-10000001-1_0",
                    "PSG-AY-2021-Payment-AcademyTrust-10000001-1_0")
                {
                    ProviderFunding = new ProviderFunding("PSG-AY-2021-10000001-1_0", 10000001,
                        "Local",
                        "08SSF")
                },
                new ProviderFundingAllocation(
                    "PSG-AY-2021-10000002-1_0",
                    "PSG-AY-2021-Payment-AcademyTrust-10000001-1_0"
                    )
                {
                    ProviderFunding = new ProviderFunding("PSG-AY-2021-10000002-1_0", 10000002,
                        "Schoo",
                        "08SSF")
                },
            });

            // act
            Action act = () => fundingAllocation.GetContractItemsMappingInput();

            // assert
            act.Should().NotThrow();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocation_GetContractItemsMappingInput_ShouldNotThrowInvalidOperationException_WhenProviderFundingsHaveDifferentProviderSubTypes()
        {
            // arrange
            var fundingAllocation = new FundingAllocation(
                "PSG-AY-2021-Payment-AcademyTrust-10000001-1_0",
                "1_0",
                "AY-2021",
                "PSG",
                "10000001",
                100m,
                1,
                1,
                3, 
                1);

            fundingAllocation.ProviderFundingAllocations.AddRange(new[]
            {
                new ProviderFundingAllocation(
                    "PSG-AY-2021-10000001-1_0",
                    "PSG-AY-2021-Payment-AcademyTrust-10000001-1_0")
                {
                    ProviderFunding = new ProviderFunding("", 10000001,
                        "Schoo",
                        "08SSF")
                },
                new ProviderFundingAllocation(
                    "PSG-AY-2021-10000002-1_0",
                    "PSG-AY-2021-Payment-AcademyTrust-10000001-1_0")
                {
                    ProviderFunding = new ProviderFunding("PSG-AY-2021-10000002-1_0", 10000002,
                        "Schoo",
                        "21NMS")
                },
            });

            // act
            Action act = () => fundingAllocation.GetContractItemsMappingInput();

            // assert
            act.Should().NotThrow();
        }
    }
}
