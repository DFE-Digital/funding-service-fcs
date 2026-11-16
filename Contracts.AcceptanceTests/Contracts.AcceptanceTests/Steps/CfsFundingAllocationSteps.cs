namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Common.Extensions;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using CrossDomain.Integration.Messages.Commands;
    using Extensions;
    using Infrastructure;
    using Infrastructure.DTO.Cfs;
    using Infrastructure.Repositories;
    using Infrastructure.Repositories.FundingAllocationConfig;
    using Infrastructure.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using Pages;
    using Infrastructure.Repositories.CrmReplicaRepo;
    using TechTalk.SpecFlow;
    using Utilities;
    using NUnit.Framework.Legacy;

    [Binding]
    public class CfsFundingAllocationSteps
    {
        const string SharepointFolderName = "Funding Allocation Extracts";
        const string SharepointFilename = "Parked_and_Discarded_Extract.xlsx";

        private List<FundingAllocation> _fundingAllocations = new List<FundingAllocation>();

        [Given(@"there is no Funding Allocation Workflow History data in CRM for UKPRN '(.*)'")]
        public void GivenThereIsNoFundingAllocationWorkflowHistoryDataInCRMForUKPRN(int ukprn)
        {
            CrmFundingAllocationRepository.DeleteFundingAllocationHistories(ukprn);
            CrmReplicatedRepository.DeleteFundingAllocationHistories(ukprn);
        }

        [Given(@"there is no Funding Allocation data in CRM for UKPRN '(.*)'")]
        public void GivenThereIsNoFundingAllocationDataInCRMForUKPRN(int ukprn)
        {
            CrmFundingAllocationRepository.DeleteFundingAllocationsForUkprn(ukprn);
            CrmReplicatedRepository.DeleteFundingAllocationsForUkprn(ukprn);
        }

        [Given(@"the following Funding Allocation data is in the CFS stub")]
        public void GivenTheFollowingFundingAllocationDataIsInTheCFSStub(Table table)
        {
            var fundingAllocations = table.Rows.Select(r => new FundingAllocation
            {
                FundingId = r["FundingId"],
                FundingVersion = r["FundingVersion"],
                Ukprn = r["UKPRN"],
                Value = r.ParseDecimal("TotalFundingValue"),
                AllocationFundingStream = r["AllocationFundingStreamCode"],
                PageNumber = 1,
                Period = r["AllocationPeriodId"]
            }).ToList();

            _fundingAllocations.AddRange(fundingAllocations);
        }

        [Given(@"the following Provider Funding Agreement data is present in the CFS stub")]
        public void GivenTheFollowingProviderFundingAgreementDataIsPresentInTheCfsStub(Table table)
        {
            ClassicAssert.IsNotNull(_fundingAllocations, $"{nameof(_fundingAllocations)} variable not set");
           
            _fundingAllocations
                .Where(fa => table.Rows.ContainsColumnValue("FundingId", fa.FundingId))
                .ForEach(fa =>
                {
                    fa.ProviderFundingAllocations = table.Rows
                        .Where(row => row["FundingId"] == fa.FundingId)
                        .Select(row => new ProviderFundingAllocation
                        {
                            ProviderFundingId = row["ProviderFundingId"],
                            ProviderType = row["ProviderType"],
                            ProviderSubType = row["ProviderSubType"],
                            DeliveryUkprn = row.ParseInt("DeliveryUKPRN")
                        })
                        .ToArray();
                });
        }

        [Given(@"the following Funding Allocation Line data is present in the CFS stub")]
        public void GivenTheFollowingFundingAllocationLineDataIsPresentInTheCfsStub(Table table)
        {
            ClassicAssert.IsNotNull(_fundingAllocations, $"{nameof(_fundingAllocations)} variable not set");

            _fundingAllocations
                .SelectMany(fa => fa.ProviderFundingAllocations)
                .Where(pf => table.Rows.ContainsColumnValue("ProviderFundingId", pf.ProviderFundingId))
                .ForEach(pf =>
                {
                    pf.FundingAllocationLines = table.Rows
                        .Where(row => row["ProviderFundingId"] == pf.ProviderFundingId)
                        .Select(row => new FundingAllocationLine
                        {
                            FundingLineCode = row["FundingLineCode"],
                            Value = row.ParseNullableString("FundingLineValue"),
                            Type = row["FundingLineType"],
                        })
                        .ToArray();
            });
        }

        [Given(@"the following Funding Allocation Profile Period data is present in the CFS stub")]
        public void GivenTheFollowingFundingAllocationProfilePeriodDataIsPresentInTheCfsStub(Table table)
        {
            ClassicAssert.IsNotNull(_fundingAllocations, $"{nameof(_fundingAllocations)} variable not set");


            _fundingAllocations
                .SelectMany(fa => fa.ProviderFundingAllocations)
                .SelectMany(pf => pf.FundingAllocationLines.Select(fal => new { pf.ProviderFundingId, FundingAllocationLine = fal}))
                .Where(fal => table.Rows.ContainsColumnValue("ProviderFundingId", fal.ProviderFundingId))
                .ForEach(fal => 
                {
                    fal.FundingAllocationLine.FundingAllocationProfilePeriods = table.Rows
                        .Where(row => row["ProviderFundingId"] == fal.ProviderFundingId && fal.FundingAllocationLine.FundingLineCode == row["FundingLineCode"])
                        .Select(row => new FundingAllocationProfilePeriod
                        {
                            Month = row["ProfilePeriodTypeValue"],
                            Year = row.ParseInt("ProfilePeriodYear"),
                            PlannedValue = row.ParseDecimal("ProfilePeriodProfileValue")
                        })
                        .ToArray();
            });
        }

        [When(@"the feed-reading process is started and the CFS stub data is processed into CRM")]
        public void WhenTheFeed_ReadingProcessIsStartedAndTheCFSStubDataIsProcessedIntoCRM()
        {
            ClassicAssert.IsNotNull(_fundingAllocations, $"{nameof(_fundingAllocations)} variable not set");

            CfsStubRepository.AddRange(_fundingAllocations);

            MessageSendingBus.Send("FundingAllocation.PullFundingAllocation", new PullFundingAllocationsCommand());
        }

        [Then(@"the following Funding Allocations data is present in PaaS")]
        public void ThenTheFollowingFundingAllocationsDataIsPresentInPaaS(TransformedTable table)
        {
            bool IsMatchingRow(FundingAllocationDto fa, TableRow row)
            {
                string expectedReleaseGroup = fa.ReleaseGroupName;
                if (row.ContainsKey("ReleaseGroup"))
                {
                    expectedReleaseGroup = row.ParseNullableString("ReleaseGroup");
                }

                return
                    fa.Ukprn == row["UKPRN"] &&
                    fa.FundingId == row["FundingId"] &&
                    fa.FundingVersion == row["FundingVersion"] &&
                    fa.Period == row["Period"] &&
                    fa.AllocationFundingStream == row["AllocationFundingStreamCode"] &&
                    fa.Value == row.ParseDecimal("Value") &&
                    fa.ReleaseGroupName == expectedReleaseGroup &&
                    row.ParseNullableStringOrDefaultIfNotPresent("Status", null).RemoveSpacing() == fa.Status &&
                    row.ParseNullableStringOrDefaultIfNotPresent("SubStatus", null).RemoveSpacing() == fa.SubStatus;
            }

            IReadOnlyCollection<TableRow> unmatchedRows = table.Rows.PollForUnmatchedRows(
                FundingAllocationRepository.GetByFundingId,
                row => row["FundingId"],
                IsMatchingRow);

            ClassicAssert.IsFalse(unmatchedRows.Any(), $"Failed to find the following rows: {unmatchedRows.ToHeaderAndValueString()}");
        }

        [Then(@"the following Funding Allocations and Contracts are linked in PaaS")]
        public void ThenTheFollowingFundingAllocationsAndContractsAreLinkedInPaaS(TransformedTable table)
        {
            bool IsMatchingRow(FundingAllocationContract c, TableRow row)
            {
                return
                    c.FundingId == row["FundingId"] &&
                    c.ContractNumber == row["ContractNo"] &&
                    c.ContractVersionNumber == row.ParseInt("ContractVersion") &&
                    c.ContractSubVersionNumber == row.ParseInt("ContractSubVersion") &&
                    c.IsCreatedInCrm == row.ParseBoolean("IsCreatedInCrm");
            }

            IReadOnlyCollection<TableRow> unmatchedRows = table.Rows.PollForUnmatchedRows(
                FundingAllocationContractRepository.GetByFundingId,
                row => row["FundingId"],
                IsMatchingRow);

            ClassicAssert.IsFalse(unmatchedRows.Any(), $"Failed to find the following rows: {unmatchedRows.ToHeaderAndValueString()}");
        }

        [Then(@"the following Funding Allocations data is present in CRM")]
        public void ThenTheFollowingFundingAllocationsDataIsPresentInCRM(TransformedTable table)
        {
            var expectedRows = table.Rows.Select(r => new
            {
                Ukprn = r["UKPRN"],
                Provider = r["Provider"],
                FundingId = r["FundingId"],
                FundingVersion = r["FundingVersion"],
                FundingType = r["FundingType"],
                Period = r["Period"],
                ContractType = r["ContractType"],
                AllocationFundingStream = r["AllocationFundingStreamCode"],
                FSPGroup = r["FSPGroup"],
                Status = r["Status"],
                SubStatus = r["SubStatus"],
                Value = r["Value"],
                ContractNo = r["ContractNo"],
                ContractVersionNo = r["ContractVersionNo"],
                CreatedBy = r["CreatedBy"],
                ModifiedBy = r["ModifiedBy"],
                HoldReason = r.ParseNullableString("HoldReason").RemoveSpacing(),
                ReleaseGroup = r.ParseNullableString("ReleaseGroup"),
                QueuedOn = r.ParseNullableDate("QueuedOn"),
                QueuedDueToContract = r.ParseNullableString("QueuedDueToContract")
            }).ToList();

            expectedRows.ForEach(expectedRow =>
            {
                CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
                {
                    var crmRows = CrmFundingAllocationRepository.GetFundingAllocationsForUkprn(expectedRow.Ukprn, expectedRow.FundingId);

                    ClassicAssert.IsTrue(crmRows.Count <=1,
                        $"There should only be one funding allocation in CRM for this ukprn:{expectedRow.Ukprn} and fundingId{expectedRow.FundingId}");

                    var crmRow = crmRows.FirstOrDefault();
                    return (crmRow != null &&
                            crmRow.SfaFundingAllocation.sfa_fundingversion == expectedRow.FundingVersion &&
                            crmRow.SfaFundingAllocation.sfa_name == expectedRow.FundingId &&
                            crmRow.SfaFundingAllocation.sfa_allocationfundingstream == expectedRow.AllocationFundingStream &&
                            crmRow.ProviderName == expectedRow.Provider &&
                            crmRow.FundingType == expectedRow.FundingType &&
                            crmRow.PeriodName == expectedRow.Period &&
                            crmRow.ContractType == expectedRow.ContractType &&
                            crmRow.FspGroupName == expectedRow.FSPGroup &&
                            crmRow.SfaFundingAllocation.sfa_statusEnum.Value.ToString() == expectedRow.Status.Replace(" ", "") &&
                            crmRow.SfaFundingAllocation.sfa_substatusEnum.Value.ToString() == expectedRow.SubStatus.Replace(" ", "") &&
                            crmRow.SfaFundingAllocation.sfa_value.Value == decimal.Parse(expectedRow.Value) &&
                            crmRow.HoldReason == expectedRow.HoldReason  &&
                            (expectedRow.ReleaseGroup == null || crmRow.ReleaseGroupName == expectedRow.ReleaseGroup) &&
                            (expectedRow.QueuedOn == null || crmRow.QueuedOn.GetValueOrDefault().Date == expectedRow.QueuedOn) &&
                            (expectedRow.QueuedDueToContract == null || crmRow.QueuedDueToContract == expectedRow.QueuedDueToContract)
                        // The contract number stuff is not there yet
                        );
                }, maxNumChecks:12, waitIntervalSeconds:5);

                var isDataPresent = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsTrue(isDataPresent, $"The funding allocation in CRM does not contain the expected items, expected: {expectedRow}");
            });
        }

        [Then(@"the following Funding Allocation Workflow History data is present in CRM")]
        [Given(@"the following Funding Allocation Workflow History data is present in CRM")]
        [When(@"the following Funding Allocation Workflow History data is present in CRM")]
        public void ThenTheFollowingFundingAllocationWorkflowHistoryDataIsPresentInCRM(Table table)
        {
            var expectedRows = table.Rows.Select(r => new
            {
                FundingId = r["FundingId"],
                Action = r["Action"],
                CompletedBy = r["CompletedBy"],
                NewStatus = r["NewStatus"],
                NewSubStatus = r["NewSubStatus"],
                PreviousStatus = r["PreviousStatus"],
                PreviousSubStatus = r["PreviousSubStatus"],
                Comments = r.ParseNullableString("Comment")
            }).ToList();

            expectedRows.ForEach(expectedRow =>
            {
                CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
                {
                    var crmRows = CrmFundingAllocationRepository.GetFundingAllocationHistoriesForFundingId(expectedRow.FundingId);
                    
                    return crmRows.Any(crmRow =>
                    {
                        return crmRow != null &&
                             crmRow.Action == expectedRow.Action &&
                             crmRow.CompletedBy == expectedRow.CompletedBy &&
                             ((sfa_FundingAllocationStatus) crmRow.NewStatus).ToString() ==
                             expectedRow.NewStatus.Replace(" ", "") &&
                             ((sfa_FundingAllocationSubStatus) crmRow.NewSubStatus).ToString() ==
                             expectedRow.NewSubStatus.Replace(" ", "") &&
                             crmRow.PreviousStatus
                                 .GetEnumValueAsStringOrDefault<sfa_FundingAllocationStatus>("?") ==
                             expectedRow.PreviousStatus.Replace(" ", "") &&
                             crmRow.PreviousSubStatus
                                 .GetEnumValueAsStringOrDefault<sfa_FundingAllocationSubStatus>(
                                     "?") == expectedRow.PreviousSubStatus.Replace(" ", "") &&
                             crmRow.Comments == (expectedRow.Comments ?? string.Empty);
                    });

                }, maxNumChecks: 12, waitIntervalSeconds: 5);

                var isDataPresent = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsTrue(isDataPresent, $"The funding allocation history in CRM does not contain the expected items, expected: {expectedRow}");
            });
        }

        [Given(@"there is no data in the CFS stub")]
        public void GivenThereIsNoDataInTheCfsStub()
        {
            CfsStubRepository.RemoveAll();
        }

        [Given(@"there is no data in the Funding Allocation PaaS tables")]
        public void GivenThereIsNoDataInTheFundingAllocationPaaSTables()
        {
            FundingAllocationFeedReadRepository.ClearAll();
            FundingAllocationRepository.ClearFundingAllocationPageControlTable();
            FundingAllocationContractRepository.ClearAll();
            FundingAllocationContractRepository.ClearProcessedMessageTable();
            FundingAllocationProviderFunding.ClearProviderFundings();
        }

        [Given(@"there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles")]
        public void GivenThereAreNoFundingAllocationsAndNoReleaseGroupsForTheFollowingContractingProfiles(Table table)
        {
            table.Rows.ForEach(row =>
            {
                var fundingTypeCode = row["FundingTypeCode"];
                var fundingPeriod = row["FundingPeriod"];
                var fspGroupCode = row["FSPGroupCode"];
                var contractType = row["ContractType"];

                CrmReleaseGroupRepository.DeleteReleaseGroupAndFundingAllocationsByBusinessKey(fundingTypeCode, fundingPeriod, fspGroupCode, contractType);
                CrmReplicatedRepository.DeleteReleaseGroupAndFundingAllocationsByBusinessKey(fundingTypeCode, fundingPeriod, fspGroupCode, contractType);
                ReleaseGroupRepository.DeleteByBusinessKey(fundingTypeCode, fundingPeriod, fspGroupCode, contractType);
            });
        }

        [Given(@"the Release Group for the following Contracting Profile has been saved")]
        [Given(@"the Release Groups for the following Contracting Profiles have been saved")]
        public void GivenTheReleaseGroupsForTheFollowingContractingProfilesHasBeenSaved(Table table)
        {
            table.Rows.ForEach(row =>
            {
                var fundingTypeCode = row["FundingTypeCode"];
                var fundingPeriod = row["FundingPeriod"];
                var fspGroupCode = row["FSPGroupCode"];
                var contractType = row["ContractType"];

                var poller = new CheckResultPoller(() =>
                {
                    var releaseGroupName = CrmReleaseGroupRepository.GetNameOfAwaitingReleaseGroupByBusinessKeyOrDefault(
                        fundingTypeCode, fundingPeriod, fspGroupCode, contractType);

                    if (releaseGroupName != null)
                    {
                        FeatureVariables.Set(row["ReleaseGroupParameterName"], releaseGroupName);
                    }

                    return releaseGroupName != null;
                }, 40, 3);

                bool successfullySetVariable = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsTrue(successfullySetVariable, $"Unable to set variable {row["ReleaseGroupParameterName"]} based on {row.ToHeaderAndValueString()}");
            });
        }

        [When(@"a request is triggered to release the following Release Group")]
        [When(@"a request is triggered to release the following Release Groups together")]

        public void WhenARequestIsTriggeredToReleaseTheFollowingReleaseGroupsTogether(TransformedTable table)
        {
            var releaseGroupNames = table.Rows.Select(row => row["ReleaseGroup"]).ToArray();
            var alreadyReleased = releaseGroupNames.Where(ReleaseGroupRepository.IsReleaseGroupReleaseReleased);
            var entityIds = releaseGroupNames.Select(CrmReleaseGroupRepository.GetIdByName).ToList();
            Console.WriteLine($"ReleaseGroupIds: {string.Join(", ", entityIds)}");

            if (alreadyReleased.Any())
            {
                CrmReleaseGroupRepository.ReleaseCollectionOfReleaseGroups(entityIds);
            }
            else
            {
                bool ReleaseCollectionOfReleaseGrps() => CrmReleaseGroupRepository.ReleaseCollectionOfReleaseGroups(entityIds);

                CheckResultPoller poller = new CheckResultPoller(ReleaseCollectionOfReleaseGrps, maxNumChecks: 10, waitIntervalSeconds: 2);
                bool hasReleaseOccurredInCrm = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsTrue(hasReleaseOccurredInCrm, $"The release in CRM has failed: {string.Join(", ", releaseGroupNames)}");
            }
        }

        [Then(@"Release Group '(.*)' has the following characteristics")]
        public void ThenReleaseGroupHasTheFollowingCharacteristics(TransformedString releaseGroupName, Table table)
        {
            var expectedValues = table.Rows.Single();

            var errors = new List<string>();

            bool CheckForMatchingReleaseGroup()
            {
                errors.Clear();

                var releaseGroupInfo = CrmReleaseGroupRepository.GetInfoByName(releaseGroupName);

                if (expectedValues["ReleaseStatus"].Replace(" ", "") != releaseGroupInfo.Status.ToString())
                {
                    errors.Add("Release Group Status incorrect");
                }

                if (expectedValues.ParseInt("AllocationCount") != releaseGroupInfo.FundingAllocationCount)
                {
                    errors.Add("Release Group Funding Allocation Count incorrect");
                }

                if (expectedValues.ParseDecimal("AllocationValue") != releaseGroupInfo.FundingAllocationValue)
                {
                    errors.Add("Release Group Funding Allocation Value incorrect");
                }

                return errors.None();
            }

            var poller = new CheckResultPoller(CheckForMatchingReleaseGroup, 30, 3);

            bool foundReleaseGroup = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsTrue(foundReleaseGroup, $"Release Group Name: {releaseGroupName} - {string.Join(", ", errors)}");
        }

        [When(@"User '(.*)' opts to put the following Funding Allocations on hold")]
        public void WhenUserOptsToPutTheFollowingFundingAllocationsOnHold(string username, Table table)
        {
            table.Rows.ForEach(row =>
            {
                CrmFundingAllocationRepository.HoldFundingAllocation(
                    username,
                    row["FundingId"],
                    row["HoldReason"].ParseEnum<sfa_FundingAllocationHoldReason>(),
                    row.ParseNullableString("Comments"));
            });
        }


        [When(@"User '(.*)' opts to release the following held Funding Allocations using Workflow WF47")]
        public void WhenUserOptsToReleaseTheFollowingHeldFundingAllocationsUsingWorkflowWF(string username, Table table)
        {
            Guid workflowId = CrmWorkflowRepository.GetWorkFlowIdFromBeginsWith("WF47");

            table.Rows.ForEach(row =>
            {
                CrmFundingAllocationRepository.ReleaseHoldFundingAllocation(
                    username,
                    row["FundingId"],
                    workflowId);
            });
        }


        [Then(@"Release Group '(.*)' in FundingAllocation\.ReleaseGroup has a status of '(.*)'")]
        public void ThenReleaseGroupInFundingAllocation_ReleaseGroupHasAStatusOf(TransformedString releaseGroupName, string expectedStatus)
        {
            string actualStatus = null;
            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                actualStatus = ReleaseGroupRepository.GetReleaseGroupStatus(releaseGroupName);

                return actualStatus == expectedStatus;
            },
                maxNumChecks:20,
                waitIntervalSeconds:3);

            bool isStatusFound = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsTrue(isStatusFound, $"ReleaseGroup {releaseGroupName} has a status of {actualStatus}. Test expected {expectedStatus}");
        }

        [When(@"User '(.*)' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '(.*)'")]
        public void WhenUserOptsToWithdrawTheFollowingFundingAllocationsFromContractControlWithWithdrawalReason(string username, string reason, Table table)
        {
            table.Rows.ForEach(row =>
            {
                CrmFundingAllocationRepository.WithdrawFundingAllocation(
                    username,
                    row["FundingId"],
                    reason);
            });
        }

        [When(@"User '(.*)' opts to re-instate the following Funding Allocation")]
        [When(@"User '(.*)' opts to re-instate the following Funding Allocations")]
        [When(@"User '(.*)' opts to re-instate the following Funding Allocations together")]
        public void WhenUserOptsToRe_InstateTheFollowingFundingAllocationsTogether(string username, Table table)
        {
            var workflowId = CrmWorkflowRepository.GetWorkFlowIdFromBeginsWith("WF48");

            table.Rows.ForEach(row =>
            {
                CrmFundingAllocationRepository.ReinstateFundingAllocation(
                    username,
                    row["FundingId"],
                    workflowId);
            });
        }

        [When(@"the job to review parked Funding Allocations against the latest version of config is run")]
        public void WhenTheJobToReviewParkedFundingAllocationsAgainstTheLatestVersionOfConfigIsRun()
        {
            MessageSendingBus.Send(
                "FundingAllocation.UnParkFundingAllocation",
                new StartUnParkFundingAllocationsCommand());
        }

        [Given(@"the current base CFS config has been loaded")]
        public void GivenTheCurrentBaseCFSConfigHasBeenLoaded()
        {
            CfsConfig.ResetCfsConfigTables();
        }

        [Given(@"the following data replaces that currently in FundingAllocation\.AllocationFundingStreamConfig")]
        public void GivenTheFollowingDataReplacesThatCurrentlyInFundingAllocation_AllocationFundingStreamConfig(Table table)
        {
            AllocationFundingStreamConfigRepository.ClearAll();
            table.Rows.ForEach(r =>
            {
                AllocationFundingStreamConfigRepository.Insert(
                    allocationFundingStreamCode:r["AllocationFundingStreamCode"],
                    allocationPeriodId:r["AllocationPeriodId"],
                    fundingTypeCode:r["FundingTypeCode"],
                    fundingPeriodCode:r["FundingPeriodCode"],
                    fspGroupCode:r["FSPGroupCode"]);
            });
        }

        [Given(@"the following data replaces that currently in FundingAllocation\.CfsCodesToContractTypeConfig")]
        public void GivenTheFollowingDataReplacesThatCurrentlyInFundingAllocation_CfsCodesToContractTypeConfig(Table table)
        {
            CfsCodesToContractTypeConfigRepository.ClearAll();
            table.Rows.ForEach(r =>
            {
                CfsCodesToContractTypeConfigRepository.Insert(
                    fundingTypeCode: r["FundingTypeCode"],
                    fundingPeriodCode: r["FundingPeriodCode"],
                    providerCategory: r["ProviderCategory"],
                    contractType: r["ContractType"]);
            });
        }

        [Given(@"the following data replaces that currently in FundingAllocation\.ProviderTypeConfig")]
        public void GivenTheFollowingDataReplacesThatCurrentlyInFundingAllocation_ProviderTypeConfig(Table table)
        {
            ProviderTypeConfigRepository.ClearAll();
            table.Rows.ForEach(r =>
            {
                ProviderTypeConfigRepository.Insert(
                    type: r["ProviderType"],
                    subType: r["ProviderSubType"],
                    category: r["ProviderCategory"]);
            });
        }

        [Given(@"the following data replaces that currently in FundingAllocation\.AllocationLineConfig")]
        public void GivenTheFollowingDataReplacesThatCurrentlyInFundingAllocation_AllocationLineConfig(Table table)
        {
            AllocationLineConfigRepository.ClearAll();
            table.Rows.ForEach(r =>
            {
                AllocationLineConfigRepository.Insert(
                    fundingStreamCode: r["FundingStreamCode"],
                    periodId: r["PeriodId"],
                    fundingLineCode: r["FundingLineCode"],
                    providerCategory: r["ProviderCategory"],
                    fspCode:r["FSPCode"],
                    deliverableCode:r.ParseInt("DeliverableCode"));
            });
        }

        [Given(@"there is no data in the FundingAllocation\.BulkUploadStatus table")]
        public void GivenThereIsNoDataInTheFundingAllocation_BulkUploadStatusTable()
        {
            FundingAllocationBulkUploadStatusRepository.ClearDown();
        }

        [Given(@"the following data exists in the FundingAllocation\.BulkUploadStatus table")]
        public void GivenTheFollowingDataExistsInTheFundingAllocation_BulkUploadStatusTable(Table table)
        {
            table.Rows.ForEach(row =>
                FundingAllocationBulkUploadStatusRepository.AddOrUpdateBulkUploadStatus(
                    row.ParseNullableString("FundingTypeCode"),
                    row.ParseNullableString("FundingPeriodName"),
                    row.ParseNullableString("Status")));
        }

        [When(@"the Parked and Discarded spreadsheet is recreated")]
        public void WhenTheParkedAndDiscardedSpreadsheetIsRecreated()
        {
            new ContractLoadPage().DeleteFilesWithPrefixInFolder(SharepointFilename, SharepointFolderName);

            MessageSendingBus.Send("Operations.FundingAllocationExtract", new CreateFundingAllocationExtractCommand());
        }

        [Then(@"the Parked and Discarded spreadsheet includes the following")]
        public void ThenTheParkedAndDiscardedSpreadsheetIncludesTheFollowing(Table table)
        {
            var expectedRows = table.Rows.Select(r => new
            {
                TabName = r["TabName"],
                FundingId = r["CFSFundingId"],
                Value = r.ParseDouble("CFSValue"),
                Status = r["FCSStatus"],
                SubStatus = r["FCSSubStatus"],
                ProviderType = r["CFSProviderType"],
                ProviderSubType = r["CFSProviderSubType"]

            }).ToList();
            var contractLoadPage = new ContractLoadPage();
            contractLoadPage.WaitTillFileGeneratedInSharepoint(SharepointFolderName, SharepointFilename);
            var workBook = contractLoadPage.GetSpreadsheetFileFromSharepoint(SharepointFolderName, SharepointFilename);
            const int statusColIndex = 14;
            const int subStatusColIndex = 15;
            const int valueColIndex = 8;
            const int providerTypeIndex = 3;
            const int providerSubTypeIndex = 4;

            expectedRows.ForEach(expectedRow =>
            {
                var sheet = workBook.Worksheets[expectedRow.TabName];
                var row = sheet.GetRow(1, expectedRow.FundingId);
                ClassicAssert.IsNotNull(row, $"The funding allocation is not found: {expectedRow.FundingId}");
                string failureMessage = $"The funding allocation: {expectedRow.FundingId} does not have the right: ";
                ClassicAssert.AreEqual(expectedRow.Status.RemoveSpacing(), row[statusColIndex].DisplayStringValue.RemoveSpacing(), failureMessage + "Status");
                ClassicAssert.AreEqual(expectedRow.SubStatus.RemoveSpacing(), row[subStatusColIndex].DisplayStringValue.RemoveSpacing(), failureMessage + "SubStatus");
                ClassicAssert.AreEqual(expectedRow.Value, row[valueColIndex].DoubleValue, failureMessage + "Value");
                ClassicAssert.AreEqual(expectedRow.ProviderType, row[providerTypeIndex].DisplayStringValue, failureMessage + "Provider Type");
                ClassicAssert.AreEqual(expectedRow.ProviderSubType, row[providerSubTypeIndex].DisplayStringValue, failureMessage + "Provider Sub Type");
                
                if (expectedRow.TabName.ToLower() == "discarded")
                {
                    ClassicAssert.IsTrue(FundingAllocationRepository.ParkingAndDiscardedInfoExists(expectedRow.FundingId), "FundingId not in ParkingAndDiscardedInfo table");
                }
            });
        }

        [Then(@"the Parked and Discarded spreadsheet includes these entries")]
        public void ThenTheParkedAndDiscardedSpreadsheetIncludesTheseEntries(Table table)
        {
            var expectedRows = table.Rows.Select(r => new
            {
                TabName = r["TabName"],
                FundingId = r["CFSFundingId"],
                Value = r.ParseDouble("CFSValue"),
                Status = r["FCSStatus"],
                SubStatus = r["FCSSubStatus"]
            }).ToList();
            var contractLoadPage = new ContractLoadPage();
            contractLoadPage.WaitTillFileGeneratedInSharepoint(SharepointFolderName, SharepointFilename);
            var workBook = contractLoadPage.GetSpreadsheetFileFromSharepoint(SharepointFolderName, SharepointFilename);
            const int statusColIndex = 14;
            const int subStatusColIndex = 15;
            const int valueColIndex = 8;

            expectedRows.ForEach(expectedRow =>
            {
                var sheet = workBook.Worksheets[expectedRow.TabName];
                var row = sheet.GetRow(1, expectedRow.FundingId);
                ClassicAssert.IsNotNull(row, $"The funding allocation is not found: {expectedRow.FundingId}");
                string failureMessage = $"The funding allocation: {expectedRow.FundingId} does not have the right: ";
                ClassicAssert.AreEqual(expectedRow.Status.RemoveSpacing(), row[statusColIndex].DisplayStringValue.RemoveSpacing(), failureMessage + "Status");
                ClassicAssert.AreEqual(expectedRow.SubStatus.RemoveSpacing(), row[subStatusColIndex].DisplayStringValue.RemoveSpacing(), failureMessage + "SubStatus");
                ClassicAssert.AreEqual(expectedRow.Value, row[valueColIndex].DoubleValue, failureMessage + "Value");

                if (expectedRow.TabName.ToLower() == "discarded")
                {
                    ClassicAssert.IsTrue(FundingAllocationRepository.ParkingAndDiscardedInfoExists(expectedRow.FundingId), "FundingId not in ParkingAndDiscardedInfo table");
                }
            });
        }

    }
}
