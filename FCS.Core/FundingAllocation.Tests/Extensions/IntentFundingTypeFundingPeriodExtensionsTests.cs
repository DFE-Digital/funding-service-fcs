namespace FundingAllocation.Tests.Extensions
{
    using System;
    using System.Collections.Generic;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using FundingAllocation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class IntentFundingTypeFundingPeriodExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void IntentFundingTypeFundingPeriod_IsNewAmendment_ShouldReturnTrue()
        {
            // arrange
            const bool isLatestVersionFalse = false;
            const bool allowNewAmendment = true;
            const string precedingFundingPeriod = "precedingFundingPeriod";
            const string precedingFundingType = "precedingFundingType";
            const string ftpGroupCode = "FTP Group Code";
            const string approvedStatus = "Approved";
            const bool lastApprovedVersionTrue = true;

            var crmContractStatusInfos = new List<CrmContractStatusInfo>()
            {
                new CrmContractStatusInfo("contractNo", "status", "subStatus", isLatestVersionFalse, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber", "", "", false, "Variation"),
                new CrmContractStatusInfo("contractNo", approvedStatus, "subStatus", isLatestVersionFalse, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber",  precedingFundingPeriod, precedingFundingType, lastApprovedVersionTrue, "Variation"),
                new CrmContractStatusInfo("contractNo", "status", "subStatus", isLatestVersionFalse, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber",  "", "", false, "Variation"),
            };
            var intentFundingTypeFundingPeriod = new IntentFundingTypeFundingPeriod(allowNewAmendment, precedingFundingPeriod, precedingFundingType, ftpGroupCode);

            // act
            var result = intentFundingTypeFundingPeriod.IsNewAmendment(crmContractStatusInfos);

            // assert
            result.Should().Be(true);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IntentFundingTypeFundingPeriod_IsNewAmendment_ShouldReturnFalse_WhenAllowNewAmendmentIsFalse()
        {
            // arrange
            const bool isLatestVersionFalse = false;
            const bool isLatestVersionTrue = true;
            const bool allowNewAmendment = false;
            const string precedingFundingPeriod = "precedingFundingPeriod";
            const string precedingFundingType = "precedingFundingType";
            const string ftpGroupCode = "FTP Group Code";
            const string approvedStatus = "Approved";
            const bool lastApprovedVersionTrue = true;

            var crmContractStatusInfos = new List<CrmContractStatusInfo>()
            {
                new CrmContractStatusInfo("contractNo", "status", "subStatus", isLatestVersionFalse, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber", "", "", false, "Variation"),
                new CrmContractStatusInfo("contractNo", approvedStatus, "subStatus", isLatestVersionFalse, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber",  precedingFundingPeriod, precedingFundingType, lastApprovedVersionTrue, "Variation"),
                new CrmContractStatusInfo("contractNo", "status", "subStatus", isLatestVersionTrue, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber",  "", "", false, "Variation"),
            };

            var intentFundingTypeFundingPeriod = new IntentFundingTypeFundingPeriod(allowNewAmendment, precedingFundingPeriod, precedingFundingType, ftpGroupCode);

            // act
            var result = intentFundingTypeFundingPeriod.IsNewAmendment(crmContractStatusInfos);

            // assert
            result.Should().Be(false);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IntentFundingTypeFundingPeriod_IsNewAmendment_ShouldReturnFalse_WhenFpGroupCodeIsNull()
        {
            // arrange
            const bool isLatestVersionFalse = false;
            const bool isLatestVersionTrue = true;
            const bool allowNewAmendment = true;
            const string precedingFundingPeriod = "precedingFundingPeriod";
            const string precedingFundingType = "precedingFundingType";
            const string ftpGroupCode = null;
            const string approvedStatus = "Approved";
            const bool lastApprovedVersionTrue = true;

            var crmContractStatusInfos = new List<CrmContractStatusInfo>()
            {
                new CrmContractStatusInfo("contractNo", "status", "subStatus", isLatestVersionFalse, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber", "", "", false, "Variation"),
                new CrmContractStatusInfo("contractNo", approvedStatus, "subStatus", isLatestVersionFalse, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber",  precedingFundingPeriod, precedingFundingType, lastApprovedVersionTrue, "Variation"),
                new CrmContractStatusInfo("contractNo", "status", "subStatus", isLatestVersionTrue, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber",  "", "", false, "Variation"),
            };

            // act
            var intentFundingTypeFundingPeriod = new IntentFundingTypeFundingPeriod(allowNewAmendment, precedingFundingPeriod, precedingFundingType, ftpGroupCode);

            // act
            var result = intentFundingTypeFundingPeriod.IsNewAmendment(crmContractStatusInfos);

            // assert
            result.Should().Be(false);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IntentFundingTypeFundingPeriod_IsNewAmendment_ShouldReturnFalse_WhenThereIsAContractWithLastApprovedVersionAndApprovedStatusButDoesNotHaveThePrecedingFundingTypeAndPrecedingFundingPeriod()
        {
            // arrange
            const bool isLatestVersionFalse = false;
            const bool isLatestVersionTrue = true;
            const bool allowNewAmendment = true;
            const string precedingFundingPeriod = "precedingFundingPeriod";
            const string precedingFundingType = "precedingFundingType";
            const string ftpGroupCode = "FTP Group Code";
            const string approvedStatus = "Approved";
            const bool lastApprovedVersionTrue = true;

            var crmContractStatusInfos = new List<CrmContractStatusInfo>
            {
                new CrmContractStatusInfo("contractNo", "status", "subStatus", isLatestVersionFalse, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber", "", "", false, "Variation"),
                new CrmContractStatusInfo("contractNo", approvedStatus, "subStatus", isLatestVersionFalse, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber",  "", "", lastApprovedVersionTrue, "Variation"),
                new CrmContractStatusInfo("contractNo", "status", "subStatus", isLatestVersionTrue, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber",  "", "", false, "Variation"),
            };

            // act
            var intentFundingTypeFundingPeriod = new IntentFundingTypeFundingPeriod(allowNewAmendment, precedingFundingPeriod, precedingFundingType, ftpGroupCode);

            // act
            var result = intentFundingTypeFundingPeriod.IsNewAmendment(crmContractStatusInfos);

            // assert
            result.Should().Be(false);
        }
    }
}