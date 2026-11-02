namespace FundingAllocation.Tests.Endpoints.ReleaseGroup.Services
{
    using FundingAllocation.Dto;
    using FluentAssertions;
    using FundingAllocation.Endpoints.ReleaseGroup.Repositories;
    using FundingAllocation.Endpoints.ReleaseGroup.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using System.Collections.Generic;
    using DataStore.Model;
    using FundingAllocation.Services;
    using TestHelpers;

    [TestClass]
    public class AmendmentTypeServiceChecksTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_DoAllAmendmentsRequireSigning_ShouldReturnTrue()
        {
            // arrange
            var mockFundingTypeFundingPeriodRepository = new Mock<IFundingTypeFundingPeriodRepository>();
            mockFundingTypeFundingPeriodRepository.Setup(r => r.DoAllAmendmentsRequireSigning(
                It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync(true);

            var amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(mockFundingTypeFundingPeriodRepository.Object, 
                 Mock.Of<ICfsToFcsCodeMappingService>());

            // act
            var result = amendmentTypeServiceChecks.DoAllAmendmentsRequireSigning(string.Empty, string.Empty).Result;

            // assert
            result.Should().Be(true);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_DoAllAmendmentsRequireSigning_ShouldReturnFalse()
        {
            // arrange
            var mockFundingTypeFundingPeriodRepository = new Mock<IFundingTypeFundingPeriodRepository>();
            mockFundingTypeFundingPeriodRepository.Setup(r => r.DoAllAmendmentsRequireSigning(
                It.IsAny<string>(), It.IsAny<string>())).ReturnsAsync(false);

            var amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(mockFundingTypeFundingPeriodRepository.Object, 
                Mock.Of<ICfsToFcsCodeMappingService>());

            // act
            var result = amendmentTypeServiceChecks.DoAllAmendmentsRequireSigning(string.Empty, string.Empty).Result;

            // assert
            result.Should().Be(false);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_IsUpdateDraftAmendmentAndLatestVersionIsVariation_ShouldReturnTrue()
        {
            // arrange
            var amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),  Mock.Of<ICfsToFcsCodeMappingService>());

            // act
            var result = amendmentTypeServiceChecks.IsUpdateDraftAmendmentAndLatestVersionIsVariation("Variation",ContractIntent.UpdateDraftAmendment).Result;

            // assert
            result.Should().Be(true);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_IsUpdateDraftAmendmentAndLatestVersionIsVariation_ShouldReturnFalse()
        {
            // arrange
            var amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),  Mock.Of<ICfsToFcsCodeMappingService>());

            // act
            var result = amendmentTypeServiceChecks.IsUpdateDraftAmendmentAndLatestVersionIsVariation("", ContractIntent.Amendment).Result;

            // assert
            result.Should().Be(false);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_FundingAllocationLinesSumValuesAreDifferent_ShouldReturnTrueWhenThereIsNoLastApprovedFundingAllocationsAndUpdateFundingAllocationsDeliverablePeriodsEnvelopeOneValueIsGreaterThanZero()
        {
            // arrange
            var fundingAllocationLine = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202108, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 0),
            });

            var updateFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId(string.Empty)
                .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { fundingAllocationLine })
            };

            var amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),
                Mock.Of<ICfsToFcsCodeMappingService>());

           // act
           var result = amendmentTypeServiceChecks
               .IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(
                   updateFundingAllocations, new List<FundingAllocation>()).Result;

            // assert
            result.Should().Be(true);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_FundingAllocationLinesSumValuesAreDifferent_ShouldReturnFalseWhenThereIsNoLastApprovedFundingAllocationsAndUpdateFundingAllocationsDeliverablePeriodsEnvelopeOneValueIsZero()
        {
            // arrange
            var fundingAllocationLine = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202108, 0),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, 0),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 0),
            });

            var updateFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId(string.Empty)
                    .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { fundingAllocationLine })
            };

            var amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),
                Mock.Of<ICfsToFcsCodeMappingService>());

            // act
            var result = amendmentTypeServiceChecks
                .IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(
                    updateFundingAllocations, new List<FundingAllocation>()).Result;

            // assert
            result.Should().Be(false);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_FundingAllocationLinesSumValuesAreDifferent_ShouldReturnTrueWhenThereIsNoLastApprovedFundingAllocationsAndUpdateFundingAllocationsDeliverablePeriodsEnvelopeTwoValueIsGreaterThanZero()
        {
            // arrange
            var fundingAllocationLine = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202206, 10),
            });

            var updateFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId(string.Empty)
                    .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { fundingAllocationLine })
            };

            var amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),
                Mock.Of<ICfsToFcsCodeMappingService>());

            // act
            var result = amendmentTypeServiceChecks
                .IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(
                    updateFundingAllocations, new List<FundingAllocation>()).Result;

            // assert
            result.Should().Be(true);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_FundingAllocationLinesSumValuesAreDifferent_ShouldReturnFalseWhenThereIsNoLastApprovedFundingAllocationsAndUpdateFundingAllocationsDeliverablePeriodsEnvelopeTwoValueIsZero()
        {
            // arrange
            var fundingAllocationLine = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 0),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202206, 0),
            });

            var updateFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId(string.Empty)
                    .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { fundingAllocationLine })
            };

            var amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),
                Mock.Of<ICfsToFcsCodeMappingService>());

            // act
            var result = amendmentTypeServiceChecks
                .IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(
                    updateFundingAllocations, new List<FundingAllocation>()).Result;

            // assert
            result.Should().Be(false);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_FundingAllocationLinesSumValuesAreDifferent_ShouldReturnTrueWhenUpdateFundingAllocationsDeliverablePeriodsEnvelopeOneValueIsGreaterThanLastApprovedAllocationsEnvelopeOneValue()
        {
            // arrange
            const string lineCode = "LineCode1";

            var lastApprovedFundingAllocationLine = new FundingAllocationLine(string.Empty, lineCode);
            lastApprovedFundingAllocationLine.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202108, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202110, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202111, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202112, 10),
            });

            var lastApprovedFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId(string.Empty)
                .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { lastApprovedFundingAllocationLine })
            };

            var updateFundingAllocationLine = new FundingAllocationLine(string.Empty, lineCode);
            updateFundingAllocationLine.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202108, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202110, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202111, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202112, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202201, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202202, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202203, 10),
            });

            var updateFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId(string.Empty)
                    .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { updateFundingAllocationLine })
            };


            var amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),
                Mock.Of<ICfsToFcsCodeMappingService>());

            // act
            var result = amendmentTypeServiceChecks
                .IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(
                    updateFundingAllocations, lastApprovedFundingAllocations).Result;

            // assert
            result.Should().Be(true);
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_FundingAllocationLinesSumValuesAreDifferent_ShouldReturnTrueWhenUpdateFundingAllocationsDeliverablePeriodsEnvelopeTwoValueIsGreaterThanLastApprovedAllocationsEnvelopeTwoValue()
        {
            // arrange
            const string lineCode = "LineCode1";

            var lastApprovedFundingAllocationLine = new FundingAllocationLine(string.Empty, lineCode);
            lastApprovedFundingAllocationLine.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202204, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202206, 10),
            });

            var lastApprovedFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId(string.Empty)
                .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { lastApprovedFundingAllocationLine })
            };

            var updateFundingAllocationLine = new FundingAllocationLine(string.Empty, lineCode);
            updateFundingAllocationLine.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202204, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202206, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202207, 10),
            });

            var updateFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId(string.Empty)
                    .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { updateFundingAllocationLine })
            };


            var amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),
                Mock.Of<ICfsToFcsCodeMappingService>());

            // act
            var result = amendmentTypeServiceChecks
                .IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(
                    updateFundingAllocations, lastApprovedFundingAllocations).Result;

            // assert
            result.Should().Be(true);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_FundingAllocationLinesSumValuesAreDifferent_ShouldReturnTrueWhenFundingLineNotPresentOnApprovedFA()
        {
            // arrange
            const string lineCode = "LineCode1";
            const string lineCode2 = "LineCode2";
            var lastApprovedFundingAllocationLine = new FundingAllocationLine(string.Empty, lineCode);
            lastApprovedFundingAllocationLine.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202204, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202206, 10),
            });

            var lastApprovedFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId(string.Empty)
                .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { lastApprovedFundingAllocationLine })
            };

            var updateFundingAllocationLine = new FundingAllocationLine(string.Empty, lineCode2);
            updateFundingAllocationLine.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202204, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202206, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202207, 10),
            });

            var updateFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId(string.Empty)
                    .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { updateFundingAllocationLine })
            };

            var amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),
                Mock.Of<ICfsToFcsCodeMappingService>());

            // act
            var result = amendmentTypeServiceChecks
                .IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(
                    updateFundingAllocations, lastApprovedFundingAllocations).Result;

            // assert
            result.Should().Be(true);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_FundingAllocationLinesSumValuesAreDifferent_ShouldReturnFalseWhenUpdateFundingAllocationsAndLastApprovedAllocationsDeliverablePeriodsValueIsTheSame()
        {
            // arrange
            var lastApprovedFundingAllocationLine = new FundingAllocationLine(string.Empty, string.Empty);
            lastApprovedFundingAllocationLine.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202108, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202110, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202111, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202112, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202201, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202202, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202203, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202204, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202206, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202207, 10),
            });

            var lastApprovedFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId(string.Empty)
                .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { lastApprovedFundingAllocationLine })
            };

            var updateFundingAllocationLine = new FundingAllocationLine(string.Empty, string.Empty);
            updateFundingAllocationLine.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202108, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202110, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202111, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202112, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202201, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202202, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202203, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202204, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202206, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202207, 10),
            });

            var updateFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId(string.Empty)
                    .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { updateFundingAllocationLine })
            };

            var amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),
                Mock.Of<ICfsToFcsCodeMappingService>());

            // act
            var result = amendmentTypeServiceChecks
                .IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(
                    updateFundingAllocations, lastApprovedFundingAllocations).Result;

            // assert
            result.Should().Be(false);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract_ShouldReturnTrueWhenUpdateDraftAmendmentAndNewAllocationOnUpdate()
        {
            // arrange
            const int ukprn = 12345678;
            Mock<ICfsToFcsCodeMappingService> mockCfsToFcsCodeMappingService = new Mock<ICfsToFcsCodeMappingService>();
            List<FundingAllocation> updateFundingAllocations = new List<FundingAllocation>
            {
                FundingAllocationHelper.FundingAllocationWithFundingId("1619-AS-2122-Contracting-LocalAuthority-10000703-2_0")
            };

            List<FundingAllocation> lastApprovedFundingAllocations = new List<FundingAllocation>
            {
                FundingAllocationHelper.FundingAllocationWithFundingId(
                    "1619-AS-2122-Contracting-LocalAuthority-10000703-1_0")
            };

            mockCfsToFcsCodeMappingService.Setup(s => s.GetLogicalAllocations(updateFundingAllocations))
                .ReturnsAsync(new List<LogicalAllocationInfo>
                {
                    new LogicalAllocationInfo("FSP2", ukprn)
                });
            mockCfsToFcsCodeMappingService.Setup(s => s.GetLogicalAllocations(lastApprovedFundingAllocations))
                .ReturnsAsync(new List<LogicalAllocationInfo>
                {
                    new LogicalAllocationInfo("FSP1", ukprn)
                });

            AmendmentTypeServiceChecks amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),
                mockCfsToFcsCodeMappingService.Object);

            // act
            var result = amendmentTypeServiceChecks
                .IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract(
                    ContractIntent.UpdateDraftAmendment, updateFundingAllocations, lastApprovedFundingAllocations)
                .Result;

            // assert
            result.Should().Be(true);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract_ShouldReturnFalseWhenUpdateDraftAmendmentAndAlloctionsAreTheSame()
        {
            // arrange
            const int ukprn = 12345678;
            Mock<ICfsToFcsCodeMappingService> mockCfsToFcsCodeMappingService = new Mock<ICfsToFcsCodeMappingService>();
            List<FundingAllocation> updateFundingAllocations = new List<FundingAllocation>
            {
                FundingAllocationHelper.FundingAllocationWithFundingId("1619-AS-2122-Contracting-LocalAuthority-10000703-2_0")
            };

            List<FundingAllocation> lastApprovedFundingAllocations = new List<FundingAllocation>
            {
                FundingAllocationHelper.FundingAllocationWithFundingId(
                    "1619-AS-2122-Contracting-LocalAuthority-10000703-1_0")
            };

            mockCfsToFcsCodeMappingService.Setup(s => s.GetLogicalAllocations(updateFundingAllocations))
                .ReturnsAsync(new List<LogicalAllocationInfo>
                {
                    new LogicalAllocationInfo("FSP2", ukprn)
                });
            mockCfsToFcsCodeMappingService.Setup(s => s.GetLogicalAllocations(lastApprovedFundingAllocations))
                .ReturnsAsync(new List<LogicalAllocationInfo>
                {
                    new LogicalAllocationInfo("FSP2", ukprn)
                });

            AmendmentTypeServiceChecks amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),
                mockCfsToFcsCodeMappingService.Object);

            // act
            var result = amendmentTypeServiceChecks
                .IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract(
                    ContractIntent.UpdateDraftAmendment, updateFundingAllocations, lastApprovedFundingAllocations)
                .Result;

            // assert
            result.Should().Be(false);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract_ShouldReturnFalseWhenNotUpdateDraftAmendment()
        {
            // arrange
            const int ukprn = 12345678;
            Mock<ICfsToFcsCodeMappingService> mockCfsToFcsCodeMappingService = new Mock<ICfsToFcsCodeMappingService>();
            List<FundingAllocation> updateFundingAllocations = new List<FundingAllocation>
            {
                FundingAllocationHelper.FundingAllocationWithFundingId("1619-AS-2122-Contracting-LocalAuthority-10000703-2_0")
            };

            List<FundingAllocation> lastApprovedFundingAllocations = new List<FundingAllocation>
            {
                FundingAllocationHelper.FundingAllocationWithFundingId(
                    "1619-AS-2122-Contracting-LocalAuthority-10000703-1_0")
            };

            mockCfsToFcsCodeMappingService.Setup(s => s.GetLogicalAllocations(updateFundingAllocations))
                .ReturnsAsync(new List<LogicalAllocationInfo>
                {
                    new LogicalAllocationInfo("FSP2", ukprn)
                });
            mockCfsToFcsCodeMappingService.Setup(s => s.GetLogicalAllocations(lastApprovedFundingAllocations))
                .ReturnsAsync(new List<LogicalAllocationInfo>
                {
                    new LogicalAllocationInfo("FSP1", ukprn)
                });

            AmendmentTypeServiceChecks amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),
                mockCfsToFcsCodeMappingService.Object);

            // act
            var result = amendmentTypeServiceChecks
                .IsUpdateDraftAmendmentAndAtLeastOneContractAllocationNotInLastApprovedContract(
                    ContractIntent.UpdateDraft, updateFundingAllocations, lastApprovedFundingAllocations)
                .Result;

            // assert
            result.Should().Be(false);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_FundingAllocationLinesSumValuesAreDifferent_ShouldReturnFalseWhenUpdateValueIsLessThanZero()
        {
            // arrange
            var fundingAllocationLine1 = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine1.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202108, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 0),
            });

            var fundingAllocationLine2 = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine2.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202108, -100),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 0),
            });

            var fundingAllocationLine1LastApproved = new FundingAllocationLine(string.Empty, string.Empty);
            fundingAllocationLine1LastApproved.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202108, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 0),
            });

            var updateFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId("1619-AS-2122-Contract-LocalAuthority-10017165-3_2")
                    .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { fundingAllocationLine1, fundingAllocationLine2 })
            };

            var lastApprovedFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId("1619-AS-2122-Contract-LocalAuthority-10017165-2_2")
                    .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { fundingAllocationLine1LastApproved })
            };

            var amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),
                Mock.Of<ICfsToFcsCodeMappingService>());

            // act
            var result = amendmentTypeServiceChecks
                .IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(
                    updateFundingAllocations, lastApprovedFundingAllocations).Result;

            // assert
            result.Should().Be(false);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_FundingAllocationLinesSumValuesAreDifferent_ShouldReturnTrueWhenUpdateFundingAllocationHasLineNotOnLastApprovedAndUpdateLineGreaterThanZero()
        {
            // arrange
            var fundingAllocationLine1 = new FundingAllocationLine(string.Empty, "1619-004");
            fundingAllocationLine1.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202108, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 0),
            });

            var fundingAllocationLine2 = new FundingAllocationLine(string.Empty, "1619-005");
            fundingAllocationLine2.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202108, 100),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 0),
            });

            var fundingAllocationLine1LastApproved = new FundingAllocationLine(string.Empty, "1619-005");
            fundingAllocationLine1LastApproved.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202108, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 0),
            });

            var updateFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId("1619-AS-2122-Contract-LocalAuthority-10017165-3_2")
                    .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { fundingAllocationLine1, fundingAllocationLine2 })
            };

            var lastApprovedFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId("1619-AS-2122-Contract-LocalAuthority-10017165-2_2")
                    .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { fundingAllocationLine1LastApproved })
            };

            var amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),
                Mock.Of<ICfsToFcsCodeMappingService>());

            // act
            var result = amendmentTypeServiceChecks
                .IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(
                    updateFundingAllocations, lastApprovedFundingAllocations).Result;

            // assert
            result.Should().Be(true);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AmendmentTypeServiceChecks_FundingAllocationLinesSumValuesAreDifferent_ShouldReturnFalseWhenUpdateFundingAllocationHasLineNotOnLastApprovedAndUpdateLineLessThanZero()
        {
            // arrange
            var fundingAllocationLine1 = new FundingAllocationLine(string.Empty, "1619-004");
            fundingAllocationLine1.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202108, -100),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 0),
            });

            var fundingAllocationLine2 = new FundingAllocationLine(string.Empty, "1619-005");
            fundingAllocationLine2.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202108, 100),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 0),
            });

            var fundingAllocationLine1LastApproved = new FundingAllocationLine(string.Empty, "1619-005");
            fundingAllocationLine1LastApproved.FundingAllocationProfilePeriods.AddRange(new List<FundingAllocationProfilePeriod>
            {
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202108, 100),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, 10),
                new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202205, 0),
            });

            var updateFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId("1619-AS-2122-Contract-LocalAuthority-10017165-3_2")
                    .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { fundingAllocationLine1, fundingAllocationLine2 })
            };

            var lastApprovedFundingAllocations = new List<FundingAllocation>{
                FundingAllocationHelper.FundingAllocationWithFundingId("1619-AS-2122-Contract-LocalAuthority-10017165-2_2")
                    .WithProviderAndFundingAllocationLines(new List<FundingAllocationLine> { fundingAllocationLine1LastApproved })
            };

            var amendmentTypeServiceChecks = new AmendmentTypeServiceChecks(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),
                Mock.Of<ICfsToFcsCodeMappingService>());

            // act
            var result = amendmentTypeServiceChecks
                .IsAnyUpdateLineGreaterIfMatchingOrPositiveIfNot(
                    updateFundingAllocations, lastApprovedFundingAllocations).Result;

            // assert
            result.Should().Be(false);
        }
    }
}