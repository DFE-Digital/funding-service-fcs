namespace FundingAllocation.Tests.Extensions
{
    using FluentAssertions;
    using FundingAllocation.Dto;
    using FundingAllocation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.Dtos;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class CrmContractStatusInfosExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_GetIntent_ShouldReturnContractIntentNew_WhenThereAreNoExistingContracts()
        {
            // arrange
            var crmContractStatusInfos = new List<CrmContractStatusInfo>();

            // act
            var assertIntent = crmContractStatusInfos.GetIntent(new IntentFundingTypeFundingPeriod(false, null, null, null), "", null);

            // assert
            assertIntent.Should().Be(ContractIntent.New);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_GetIntent_ShouldReturnContractIntentUpdateDraftAmendment_WhenTheLatestContractStatusIsDraftAndThereWasAPreviousContractWithApprovedStatus()
        {
            // arrange
            const string randomContractNo = "contractNo";
            const bool randomLastVersion = false;
            const int randomVersion = -999;
            const int randomSubVersion = -999;
            const string randomCrmEntityId = "crmEntityId";

            var contractStatusFirstVersion = new CrmContractStatusInfo(randomContractNo, "Approved", "subStatus", randomLastVersion, randomVersion, randomSubVersion,
                DateTime.Now.AddDays(-14), randomCrmEntityId, "masterContractNumber", "", "", false, "Variation");
            var contractStatusSecondVersion = new CrmContractStatusInfo(randomContractNo, "Withdrawn", "subStatus", randomLastVersion, randomVersion, randomSubVersion,
                DateTime.Now.AddDays(-7), randomCrmEntityId, "masterContractNumber", "", "", false, "Variation");
            var contractStatusThirdVersion = new CrmContractStatusInfo(randomContractNo, "Draft", "In Review", true, randomVersion, randomSubVersion,
                DateTime.Now, randomCrmEntityId, "masterContractNumber", "", "", false, "Variation");

            var crmContractStatusInfos = new List<CrmContractStatusInfo>();
            crmContractStatusInfos.Add(contractStatusThirdVersion);
            crmContractStatusInfos.Add(contractStatusFirstVersion);
            crmContractStatusInfos.Add(contractStatusSecondVersion);

            // act
            var assertIntent = crmContractStatusInfos.GetIntent(new IntentFundingTypeFundingPeriod(false, "", "", ""), "", null);

            // assert
            assertIntent.Should().Be(ContractIntent.UpdateDraftAmendment);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_GetIntent_ShouldReturnContractIntentUpdateDraft_WhenTheLatestContractStatusIsDraftAndThereWasNotAPreviousContractWithApprovedStatus()
        {
            // arrange
            const string randomContractNo = "contractNo";
            const bool randomLastVersion = false;
            const int randomVersion = -999;
            const int randomSubVersion = -999;
            const string randomCrmEntityId = "crmEntityId";

            var contractStatusFirstVersion = new CrmContractStatusInfo(randomContractNo, "NotApproved", "subStatus", randomLastVersion, randomVersion,
                randomSubVersion, DateTime.Now.AddDays(-7), randomCrmEntityId, "masterContractNumber", "", "", false, "Variation");
            var contractStatusSecondVersion = new CrmContractStatusInfo(randomContractNo, "Draft", "Unassigned", true, randomVersion,
                randomSubVersion, DateTime.Now, randomCrmEntityId, "masterContractNumber", "", "", false, "Variation");

            var crmContractStatusInfos = new List<CrmContractStatusInfo>();
            crmContractStatusInfos.Add(contractStatusSecondVersion);
            crmContractStatusInfos.Add(contractStatusFirstVersion);

            // act
            var assertIntent = crmContractStatusInfos.GetIntent(new IntentFundingTypeFundingPeriod(false, "", "", ""), "", null);

            // assert
            assertIntent.Should().Be(ContractIntent.UpdateDraft);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_GetIntent_ShouldReturnQueueIntent_WhenWeDoNotSupportAnContractOutcomeForExistingData()
        {
            // arrange
            const string randomContractNo = "contractNo";
            const bool randomLastVersion = false;
            const int randomVersion = -999;
            const int randomSubVersion = -999;
            const string randomCrmEntityId = "crmEntityId";

            var contractStatusFirstVersion = new CrmContractStatusInfo(randomContractNo, "NotApproved", "subStatus", randomLastVersion, randomVersion, randomSubVersion,
                DateTime.Now.AddDays(-7), randomCrmEntityId, "masterContractNumber", "", "", false, "Variation");
            var contractStatusSecondVersion = new CrmContractStatusInfo(randomContractNo, "NotApproved", "subStatus", true, randomVersion, randomSubVersion,
                DateTime.Now, randomCrmEntityId, "masterContractNumber", "", "", false, "Variation");

            var crmContractStatusInfos = new List<CrmContractStatusInfo>();
            crmContractStatusInfos.Add(contractStatusSecondVersion);
            crmContractStatusInfos.Add(contractStatusFirstVersion);

            // act
            var assertIntent = crmContractStatusInfos.GetIntent(new IntentFundingTypeFundingPeriod(false, "", "", ""), "", null);
            assertIntent.Should().Be(ContractIntent.Queue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_GetIntent_ShouldReturnQueueIntent_WhenStatusDraftAndSubStatusPublishdtoProvider()
        {
            // arrange
            const string randomContractNo = "contractNo";
            const bool randomLastVersion = false;
            const int randomVersion = -999;
            const int randomSubVersion = -999;
            const string randomCrmEntityId = "crmEntityId";

            var contractStatusFirstVersion = new CrmContractStatusInfo(randomContractNo, "Approved", "Approved", randomLastVersion, randomVersion, randomSubVersion,
                DateTime.Now.AddDays(-7), randomCrmEntityId, "masterContractNumber", "", "", false, "Variation");
            var contractStatusSecondVersion = new CrmContractStatusInfo(randomContractNo, "Draft", "Publishd to Provider", true, randomVersion, randomSubVersion,
                DateTime.Now, randomCrmEntityId, "masterContractNumber", "", "", false, "Variation");

            var crmContractStatusInfos = new List<CrmContractStatusInfo>();
            crmContractStatusInfos.Add(contractStatusSecondVersion);
            crmContractStatusInfos.Add(contractStatusFirstVersion);

            // act
            var assertIntent = crmContractStatusInfos.GetIntent(new IntentFundingTypeFundingPeriod(false, "", "", ""), "", null);

            // assert
            assertIntent.Should().Be(ContractIntent.Queue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_GetIntent_ShouldReturnRevisedBew_WhenNoContractHasLatestVersion()
        {
            // arrange
            const bool isLatestVersion = false;

            var crmContractStatusInfos = new List<CrmContractStatusInfo>
            {
                new CrmContractStatusInfo("contractNo", "status", "subStatus", isLatestVersion, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber", "", "", false, "Variation"),
                new CrmContractStatusInfo("contractNo", "status", "subStatus", isLatestVersion, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber", "", "", false, "Variation"),
                new CrmContractStatusInfo("contractNo", "status", "subStatus", isLatestVersion, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber", "", "", false, "Variation")
            };

            // act
            var assertIntent = crmContractStatusInfos.GetIntent(new IntentFundingTypeFundingPeriod(false, "", "", ""), "", null);

            // assert
            assertIntent.Should().Be(ContractIntent.RevisedNew);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_GetIntent_ShouldReturnNewAmendment()
        {
            // arrange
            const bool isLatestVersionFalse = false;
            const bool allowNewAmendment = true;
            const string precedingFundingPeriod = "precedingFundingPeriod";
            const string precedingFundingType = "precedingFundingType";
            const string ftpGroupCode = "FTP Group Code";
            const string approvedStatus = "Approved";
            const bool lastApprovedVersionTrue = true;
            const string previousFundingPeriod = "AY2021";

            var crmContractStatusInfos = new List<CrmContractStatusInfo>()
            {
                new CrmContractStatusInfo("contractNo", "status", "subStatus", isLatestVersionFalse, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber", previousFundingPeriod, "", false, "Variation"),
                new CrmContractStatusInfo("contractNo", approvedStatus, "subStatus", isLatestVersionFalse, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber",  precedingFundingPeriod, precedingFundingType, lastApprovedVersionTrue, "Variation"),
                new CrmContractStatusInfo("contractNo", "status", "subStatus", isLatestVersionFalse, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber",  previousFundingPeriod, "", false, "Variation"),
            };

            // act
            var assertIntent = crmContractStatusInfos.GetIntent(
                new IntentFundingTypeFundingPeriod(allowNewAmendment, precedingFundingPeriod, precedingFundingType, ftpGroupCode),
                "AY2122", new List<ContractIdentity>());

            // assert
            assertIntent.Should().Be(ContractIntent.NewAmendment);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_GetIntent_ShouldReturnQueue_WhenWeCannotEstablishTheIntent()
        {
            // arrange
            const bool allowNewAmendment = false;
            const string precedingFundingPeriod = "precedingFundingPeriod";
            const string precedingFundingType = "precedingFundingType";
            const string ftpGroupCode = "FTP Group Code";
            const bool isLatestVersion = true;

            var crmContractStatusInfos = new List<CrmContractStatusInfo>()
            {
                new CrmContractStatusInfo("contractNo", "status", "subStatus", isLatestVersion, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber", "", "", false, "Variation"),
                new CrmContractStatusInfo("contractNo", "status", "subStatus", false, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber", "", "", false, "Variation"),
                new CrmContractStatusInfo("contractNo", "status", "subStatus", false, 33, 55, DateTime.UtcNow,
                    "crmEntity", "masterContractNumber", "", "", false, "Variation")
            };

            // act
            var assertIntent = crmContractStatusInfos.GetIntent(new IntentFundingTypeFundingPeriod(allowNewAmendment, precedingFundingPeriod, precedingFundingType, ftpGroupCode), "", null);

            // assert
            assertIntent.Should().Be(ContractIntent.Queue);
        }


        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_GetIntent_ShouldReturnAmendment_WithSpecifiedSubstatus()
        {
            // arrange
            var substatusesAndExpected =  new List<(string subStatus, ContractIntent intent)>
            {
                ("Approved", ContractIntent.Amendment),
                ("Under Termination",  ContractIntent.Amendment),
                ("Modified",  ContractIntent.Amendment),
                ("NoneOfAbove", ContractIntent.Queue)
            };

            substatusesAndExpected.ForEach(substatusAndIntent =>
            {
                const string randomContractNo = "contractNo";
                const bool randomLastVersion = false;
                const int randomVersion = -999;
                const int randomSubVersion = -999;
                const string randomCrmEntityId = "crmEntityId";

                var crmContractStatusInfos = new List<CrmContractStatusInfo>()
                {
                    new CrmContractStatusInfo(randomContractNo, "NotApproved", "subStatus", randomLastVersion,
                        randomVersion,
                        randomSubVersion, DateTime.Now.AddDays(-7), randomCrmEntityId, "masterContractNumber", "", "",
                        false, "Variation"),
                    new CrmContractStatusInfo(randomContractNo, "Approved", substatusAndIntent.subStatus, true, randomVersion,
                        randomSubVersion, DateTime.Now, randomCrmEntityId, "masterContractNumber", "", "", false, "Variation")
                };

                // act
                var assertIntent = crmContractStatusInfos.GetIntent(
                    new IntentFundingTypeFundingPeriod(false, "", "", ""), "", null);

                // assert
                assertIntent.Should().Be(substatusAndIntent.intent);
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_GetIntent_ShouldReturnAmendment_WithSpecifiedSubstatus_WhenIsInvokedViaDequeueEvent()
        {
            // arrange
            var substatusesAndExpected = new List<(string subStatus, ContractIntent intent)>
            {
                ("Approved", ContractIntent.Amendment),
                ("Under Termination",  ContractIntent.Amendment),
                ("Modified",  ContractIntent.Amendment),
                ("Awaiting Modification Approval",  ContractIntent.Amendment),
                ("Modification Approval in Progress",  ContractIntent.Amendment),
                ("Termination Initiation Approval in Progress",  ContractIntent.Amendment),
                ("NoneOfAbove", ContractIntent.Queue)
            };

            substatusesAndExpected.ForEach(substatusAndIntent =>
            {
                const string randomContractNo = "contractNo";
                const bool randomLastVersion = false;
                const int randomVersion = -999;
                const int randomSubVersion = -999;
                const string randomCrmEntityId = "crmEntityId";

                var crmContractStatusInfos = new List<CrmContractStatusInfo>()
                {
                    new CrmContractStatusInfo(randomContractNo, "NotApproved", "subStatus", randomLastVersion,
                        randomVersion,
                        randomSubVersion, DateTime.Now.AddDays(-7), randomCrmEntityId, "masterContractNumber", "", "",
                        false, "Variation"),
                    new CrmContractStatusInfo(randomContractNo, "Approved", substatusAndIntent.subStatus, true, randomVersion,
                        randomSubVersion, DateTime.Now, randomCrmEntityId, "masterContractNumber", "", "", false, "Variation")
                };

                // act
                var assertIntent = crmContractStatusInfos.GetIntent(
                    new IntentFundingTypeFundingPeriod(false, "", "", ""), "", null, true);

                // assert
                assertIntent.Should().Be(substatusAndIntent.intent, substatusAndIntent.subStatus);
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_GetBlockedOnContractForMultiYear_ShouldReturnEarliestBlocked_v1()
        {
            // arrange
            DateTime dateTime = new DateTime(2022, 10, 1);
            const string previousFundingPeriod = "AY2021";
            const string currentFundingPeriod = "AY2122";
            const string fundingType = "DADA";
            List<CrmContractStatusInfo> crmContractStatusInfos = new List<CrmContractStatusInfo>
            {
                CreateCrmContractStatusInfo(previousFundingPeriod, fundingType, dateTime, latest: false, status:"Approved", "Approved", version: 1),
                CreateCrmContractStatusInfo(currentFundingPeriod, fundingType, dateTime, latest: true, "Approved", subStatus:"Approved", 1),
                CreateCrmContractStatusInfo(previousFundingPeriod, fundingType, dateTime, latest: true, status:"Draft", "Awaiting Documentation", version: 2),
            };

            // act
            var info = crmContractStatusInfos.GetBlockedOnContractForMultiYear(currentFundingPeriod);

            // assert
            info.FundingPeriod.Should().Be(previousFundingPeriod);
            info.Version.Should().Be(2);
            info.LatestVersion.Should().BeTrue();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_GetBlockedOnContractForMultiYear_ShouldReturnEarliestBlocked_v2()
        {
            // arrange
            DateTime dateTime = new DateTime(2022, 10, 1);
            const string previousFundingPeriod = "AY2021";
            const string currentFundingPeriod = "AY2122";
            const string fundingType = "DADA";
            List<CrmContractStatusInfo> crmContractStatusInfos = new List<CrmContractStatusInfo>
            {
                CreateCrmContractStatusInfo(previousFundingPeriod, fundingType, dateTime, latest: true, status:"Approved", subStatus:"Approved", version: 2),
                CreateCrmContractStatusInfo(currentFundingPeriod, fundingType, dateTime, latest: true, "Approved", subStatus:"Awaiting Termination Initiation Approval", 1),
                CreateCrmContractStatusInfo(previousFundingPeriod, fundingType, dateTime, latest: false, status:"Replaced", subStatus:"Approved", version: 1),
            };

            // act
            var info = crmContractStatusInfos.GetBlockedOnContractForMultiYear(currentFundingPeriod);

            // assert
            info.FundingPeriod.Should().Be(currentFundingPeriod);
            info.LatestVersion.Should().BeTrue();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_GetBlockedOnContractForMultiYear_ShouldReturnEarliestBlocked_v3()
        {
            // arrange
            DateTime dateTime = new DateTime(2022, 10, 1);
            const string previousFundingPeriod = "AY2021";
            const string currentFundingPeriod = "AY2122";
            const string fundingType = "DADA";
            List<CrmContractStatusInfo> crmContractStatusInfos = new List<CrmContractStatusInfo>
            {
                CreateCrmContractStatusInfo(previousFundingPeriod, fundingType, dateTime, latest: true, status:"Approved", subStatus:"Awaiting Termination Initiation Approval", version: 2),
                CreateCrmContractStatusInfo(currentFundingPeriod, fundingType, dateTime, latest: true, "Approved", subStatus:"Awaiting Termination Initiation Approval", 1),
            };

            // act
            var info = crmContractStatusInfos.GetBlockedOnContractForMultiYear(currentFundingPeriod);

            // assert
            info.FundingPeriod.Should().Be(currentFundingPeriod);
            info.LatestVersion.Should().BeTrue();
        }

        private CrmContractStatusInfo CreateCrmContractStatusInfo(string fundingPeriod, string fundingType,
            DateTime createdDate, bool latest, string status, string subStatus, int version)
        {
            return new CrmContractStatusInfo(string.Empty, status, subStatus, latestVersion: latest, version, 0,
                createdDate, string.Empty, string.Empty, fundingPeriod, fundingType, false, string.Empty);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_AreThereAnyDraftContractsInTheSystem_ShouldReturnFalse_WhenThereAreNone()
        {
            // arrange
            const bool isLatestVersionFalse = false;
            const string precedingFundingPeriod = "precedingFundingPeriod";
            const string precedingFundingType = "precedingFundingType";
            const string approvedStatus = "Approved";
            const bool lastApprovedVersionTrue = true;
            const string masterContractNumber = "MN1";

            var crmContractStatusInfos = new List<CrmContractStatusInfo>()
            {
                new CrmContractStatusInfo("contractNo2", approvedStatus, "subStatus", isLatestVersionFalse, 33, 55, DateTime.UtcNow,
                    "crmEntity", masterContractNumber,  precedingFundingPeriod, precedingFundingType, lastApprovedVersionTrue, "Variation"),
            };

            // act
            var result =
                crmContractStatusInfos.AreThereAnyOtherDraftContractsInTheSystem(new List<ContractIdentity>());

            // assert
            result.Should().Be(false);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_AreThereAnyDraftContractsInTheSystem_ShouldReturnTrue_WhenThereIsADraft()
        {
            // arrange
            const bool isLatestVersionFalse = false;
            const string precedingFundingPeriod = "precedingFundingPeriod";
            const string precedingFundingType = "precedingFundingType";
            const string approvedStatus = "Approved";

            const bool lastApprovedVersionTrue = true;
            const string masterContractNumber = "MN1";

            var crmContractStatusInfos = new List<CrmContractStatusInfo>()
            {
                new CrmContractStatusInfo("contractNo1", "Draft", "subStatus", true, 34, 55, DateTime.UtcNow,
                    "crmEntity", masterContractNumber, "", "", false, "Variation"),
                new CrmContractStatusInfo("contractNo2", approvedStatus, "subStatus", isLatestVersionFalse, 33, 55, DateTime.UtcNow,
                    "crmEntity", masterContractNumber,  precedingFundingPeriod, precedingFundingType, lastApprovedVersionTrue, "Variation"),
            };

            // act
            var result =
                crmContractStatusInfos.AreThereAnyOtherDraftContractsInTheSystem(new List<ContractIdentity>());

            // assert
            result.Should().Be(true);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_AreThereAnyDraftContractsInTheSystem_ShouldReturnFalse_WhenThereIsADraftContractThatIsTheContractIdentityToIgnoreWhenDerivingIntent()
        {
            // arrange
            const bool isLatestVersionFalse = false;
            const string precedingFundingPeriod = "precedingFundingPeriod";
            const string precedingFundingType = "precedingFundingType";
            const string approvedStatus = "Approved";

            const bool lastApprovedVersionTrue = true;
            const string masterContractNumber = "MN1";

            var crmContractStatusInfoToIgnoreWhenDerivingIntent = new CrmContractStatusInfo("contractToIgnore", "Draft", "subStatus", true, 34, 55, DateTime.UtcNow,
                "crmEntity", masterContractNumber, "", "", false, "Variation");

            var crmContractStatusInfos = new List<CrmContractStatusInfo>()
            {
                crmContractStatusInfoToIgnoreWhenDerivingIntent,
                new CrmContractStatusInfo("contractNo2", approvedStatus, "subStatus", isLatestVersionFalse, 33, 55, DateTime.UtcNow,
                    "crmEntity", masterContractNumber,  precedingFundingPeriod, precedingFundingType, lastApprovedVersionTrue, "Variation"),
            };

            // act
            var result = crmContractStatusInfos.AreThereAnyOtherDraftContractsInTheSystem(new List<ContractIdentity>{
                new ContractIdentity(
                    crmContractStatusInfoToIgnoreWhenDerivingIntent.Number,
                    crmContractStatusInfoToIgnoreWhenDerivingIntent.Version,
                    crmContractStatusInfoToIgnoreWhenDerivingIntent.SubVersion)});

            // assert
            result.Should().Be(false);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_AreThereAnyDraftContractsInTheSystem_ShouldReturnTrue_WhenThereIsADraftContractThatIsNotTheContractIdentityToIgnoreWhenDerivingIntent()
        {
            // arrange
            const bool isLatestVersionFalse = false;
            const string precedingFundingPeriod = "precedingFundingPeriod";
            const string precedingFundingType = "precedingFundingType";
            const string approvedStatus = "Approved";

            const bool lastApprovedVersionTrue = true;
            const string masterContractNumber = "MN1";

            var crmContractStatusInfoToIgnoreWhenDerivingIntent = new CrmContractStatusInfo("contractToIgnore", "Draft", "subStatus", true, 34, 55, DateTime.UtcNow,
                "crmEntity", masterContractNumber, "", "", false, "Variation");

            var crmContractStatusInfos = new List<CrmContractStatusInfo>()
            {
                crmContractStatusInfoToIgnoreWhenDerivingIntent,
                new CrmContractStatusInfo("contractNo1", "Draft", "subStatus", true, 34, 55, DateTime.UtcNow,
                    "crmEntity", masterContractNumber, "", "", false, "Variation"),
                new CrmContractStatusInfo("contractNo2", approvedStatus, "subStatus", isLatestVersionFalse, 33, 55, DateTime.UtcNow,
                    "crmEntity", masterContractNumber,  precedingFundingPeriod, precedingFundingType, lastApprovedVersionTrue, "Variation"),
            };

            // act
            var result = crmContractStatusInfos.AreThereAnyOtherDraftContractsInTheSystem(new List<ContractIdentity>{new ContractIdentity(
                    crmContractStatusInfoToIgnoreWhenDerivingIntent.Number,
                    crmContractStatusInfoToIgnoreWhenDerivingIntent.Version,
                    crmContractStatusInfoToIgnoreWhenDerivingIntent.SubVersion)});

            // assert
            result.Should().Be(true);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_UpdateStatusSubStatusWhereFound_ShouldReturnUpdatedCrmContractStatusInfosWhenOverrideStatusesExistWithinCrmContractStatusInfos()
        {
            // arrange
            const string contractNumber = "ContractNumber";
            const int version = 1;
            const int subVersion = 0;
            const string beforeStatus = "Draft";
            const string beforeSubStatus = "Awaiting Documentation";

            const string afterStatus = "Approved";
            const string afterSubStatus = "Approved";

            var crmContractStatusInfos = new List<CrmContractStatusInfo>()
            {
                new CrmContractStatusInfo(contractNumber, beforeStatus, beforeSubStatus, true, version, subVersion, DateTime.UtcNow,
                    "", "", "", "", false, ""), 
                new CrmContractStatusInfo("", "", "", true, -1, -1, DateTime.UtcNow,
                    "", "", "", "", false, "")
            };

            var overrideStatuses = new List<ContractAndStatus>()
                { new ContractAndStatus(new ContractIdentity(contractNumber, version, subVersion), afterStatus, afterSubStatus )};

            // act
            crmContractStatusInfos.UpdateStatusSubStatusWhereFound(overrideStatuses);

            // assert
            var crmContractStatusInfo = crmContractStatusInfos.First(ccsi =>
                ccsi.Number == contractNumber && ccsi.Version == version && ccsi.SubVersion == subVersion);

            crmContractStatusInfo.Status.Should().Be(afterStatus);
            crmContractStatusInfo.SubStatus.Should().Be(afterSubStatus);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_UpdateStatusSubStatusWhereFound_ShouldReturnUnchangedCrmContractStatusInfosWhenOverrideStatusesIsAnEmptyList()
        {
            // arrange
            const string contractNumber = "ContractNumber";
            const int version = 1;
            const int subVersion = 0;
            const string beforeStatus = "Draft";
            const string beforeSubStatus = "Awaiting Documentation";

            var crmContractStatusInfos = new List<CrmContractStatusInfo>()
            {
                new CrmContractStatusInfo(contractNumber, beforeStatus, beforeSubStatus, true, version, subVersion, DateTime.UtcNow,
                    "", "", "", "", false, ""),
                new CrmContractStatusInfo("", "", "", true, -1, -1, DateTime.UtcNow,
                    "", "", "", "", false, "")
            };

            var overrideStatuses = new List<ContractAndStatus>();

            // act
            crmContractStatusInfos.UpdateStatusSubStatusWhereFound(overrideStatuses);

            // assert
            var crmContractStatusInfo = crmContractStatusInfos.First(ccsi =>
                ccsi.Number == contractNumber && ccsi.Version == version && ccsi.SubVersion == subVersion);

            crmContractStatusInfo.Status.Should().Be(beforeStatus);
            crmContractStatusInfo.SubStatus.Should().Be(beforeSubStatus);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_UpdateStatusSubStatusWhereFound_ShouldReturnUnchangedCrmContractStatusInfosWhenOverrideStatusesDoesNotExistWithinCrmContractStatusInfos()
        {
            // arrange
            const string contractNumber = "ContractNumber";
            const int version = 1;
            const int subVersion = 0;
            const string beforeStatus = "Draft";
            const string beforeSubStatus = "Awaiting Documentation";

            const string afterStatus = "Approved";
            const string afterSubStatus = "Approved";

            var crmContractStatusInfos = new List<CrmContractStatusInfo>()
            {
                new CrmContractStatusInfo(contractNumber, beforeStatus, beforeSubStatus, true, version, subVersion, DateTime.UtcNow,
                    "", "", "", "", false, ""),
                new CrmContractStatusInfo("", "", "", true, -1, -1, DateTime.UtcNow,
                    "", "", "", "", false, "")
            };

            var overrideStatuses = new List<ContractAndStatus>()
                { new ContractAndStatus(new ContractIdentity("Random contractNumber", -1, -1), afterStatus, afterSubStatus )};

            // act
            crmContractStatusInfos.UpdateStatusSubStatusWhereFound(overrideStatuses);

            // assert
            var crmContractStatusInfo = crmContractStatusInfos.First(ccsi =>
                ccsi.Number == contractNumber && ccsi.Version == version && ccsi.SubVersion == subVersion);

            crmContractStatusInfo.Status.Should().Be(beforeStatus);
            crmContractStatusInfo.SubStatus.Should().Be(beforeSubStatus);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmContractStatusInfos_GetExistingCrmContractInfo_ShouldReturnTheLatestForTheMatchingPeriod_WhenNotDadaAndQueued()
        {
            // arrange
            const string contractNumber = "ContractNumber";
            const int version = 1;
            const int subVersion = 0;
            const string fundingPeriod = "AY2122";
            const string otherFundingPeriod = "AY2223";

            var crmContractStatusInfos = new List<CrmContractStatusInfo>
            {
                new CrmContractStatusInfo("", "", "", true, -1, -1, DateTime.UtcNow,
                    "", "", otherFundingPeriod, "", false, ""),
                new CrmContractStatusInfo(contractNumber, string.Empty, string.Empty, true, version, subVersion, DateTime.UtcNow,
                    "", "", fundingPeriod, "", false, ""),
            };

            // act
            var crmContractInfo = crmContractStatusInfos.GetExistingCrmContractInfo(
                1,
                ContractIntent.Queue,
                fundingPeriod,
                id => System.Threading.Tasks.Task.FromResult((IReadOnlyCollection< CrmAllocationInfo>)new List<CrmAllocationInfo>())).Result;

            // assert
            crmContractInfo.Number.Should().Be(contractNumber);
        }
    }
}