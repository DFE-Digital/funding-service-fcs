namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagementService.Common.Commands;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Extensions;
    using Infrastructure.DTO;
    using Infrastructure.Repositories;
    using Infrastructure.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TechTalk.SpecFlow;
    using Utilities;
    using NUnit.Framework.Legacy;

    [Binding]
    public class DeleteDraftContractSteps
    {
        private List<ContractDto> _contractsToDelete;

        [When(@"a request is initiated in CRM to delete the following contracts")]
        public void WhenARequestIsInitiatedInCrmToDeleteTheFollowingContracts(TransformedTable table)
        {
            var contractsToDelete = 
                table.Rows.Select(r =>
                {
                    string contractNum = r["ContractNumber"];
                    int versionNum = int.Parse(r["ContractVersionNumber"]);
                    string ukprn = r["UKPRN"];

                    return new ContractDto
                    {
                        ContractId = CrmContractRepository.GetMostRecentByContractId(contractNum, versionNum),
                        ContractNumber = contractNum,
                        ContractVersion = versionNum,
                        Ukprn = ukprn
                    };
                }).ToList();

            // Hold these DTOs in memory - required for several later steps to do with contract delete when contract will no longer be present to query
            _contractsToDelete = contractsToDelete;

            contractsToDelete
                .ForEach(c => MessageSendingBus.Send("ContractManagement.DeleteContract", new DeleteDraftContractItemsCommand
                {
                    ContractNumber = c.ContractNumber,
                    VersionNumber = c.ContractVersion
                }));
        }

        [Then(@"there are no longer any Task records in CRM for the following contracts")]
        public void ThenThereAreNoLongerAnyTaskRecordsInCrmForTheFollowingContracts(Table table)
        {
            foreach (TableRow row in table.Rows)
            {
                var contractNumber = row["ContractNumber"];
                var version = int.Parse(row["ContractVersionNumber"]);
                
                Guid contractId = CrmContractRepository.GetContractIdIfPresent(contractNumber, version, 0);

                if (contractId != Guid.Empty)
                {
                    int countOfCrmTasksForContractId = 1;

                    CheckResultPoller checkResultPoller = new CheckResultPoller(
                        checkResult: () =>
                        {
                            countOfCrmTasksForContractId = CrmContractRepository.GetCountOfCrmTasksForContractId(contractId);
                            return countOfCrmTasksForContractId == 0;
                        },
                        maxNumChecks: 15,
                        waitIntervalSeconds: 4);

                    checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();


                    ClassicAssert.AreEqual(0, countOfCrmTasksForContractId,
                        $"Tasks were found for contract {contractNumber} v{version}");
                }
            } 
        }

        [Then(@"there are no longer any Workflow History records in CRM for the following contracts")]
        public void ThenThereAreNoLongerAnyWorkflowHistoryRecordsInCrmForTheFollowingContracts(Table table)
        {
            foreach (TableRow row in table.Rows)
            {
                ContractDto relatedContractToDelete =
                    _contractsToDelete.SingleOrDefault(c =>
                        c.ContractNumber == row["ContractNumber"] &&
                        c.ContractVersion == int.Parse(row["ContractVersionNumber"]));

                if (relatedContractToDelete != null)
                {
                    int countOfWorkflowHistoryForContractId = 1;

                    CheckResultPoller checkResultPoller = new CheckResultPoller(
                        checkResult: () =>
                        {
                            countOfWorkflowHistoryForContractId = CrmContractRepository.GetCountOfWorkflowHistoryForContractId(relatedContractToDelete.ContractId);
                            return countOfWorkflowHistoryForContractId == 0;
                        },
                        maxNumChecks: 15,
                        waitIntervalSeconds: 4);

                    checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

                    ClassicAssert.AreEqual(0, countOfWorkflowHistoryForContractId,
                        $"Workflow history was found for contract {relatedContractToDelete.ContractNumber} v{relatedContractToDelete.ContractVersion}");
                }
            }
        }

        [Then(@"there are no longer any Allocations, Deliverables or Deliverable Periods in CRM for the following contracts")]
        public void ThenThereAreNoLongerAnyAllocationsDeliverablesOrDeliverablePeriodsInCrmForTheFollowingContracts(Table table)
        {
            foreach (TableRow row in table.Rows)
            {
                ContractDto relatedContractToDelete =
                    _contractsToDelete.SingleOrDefault(c =>
                        c.ContractNumber == row["ContractNumber"] &&
                        c.ContractVersion == int.Parse(row["ContractVersionNumber"]));

                if (relatedContractToDelete != null)
                {
                    AssertCountOfItemsIsCorrect(
                        isCountExpectedNumber: () => CrmContractRepository.GetDeliverablePeriodCountForContract(relatedContractToDelete.ContractId) == 0,
                        errorMessage: $"Contract deliverable periods were not deleted for {relatedContractToDelete.ContractNumber} v{relatedContractToDelete.ContractVersion}");

                    AssertCountOfItemsIsCorrect(
                        isCountExpectedNumber: () => CrmContractRepository.GetDeliverableCountForContract(relatedContractToDelete.ContractId) == 0,
                        errorMessage: $"Contract deliverables were not deleted for {relatedContractToDelete.ContractNumber} v{relatedContractToDelete.ContractVersion}");

                    AssertCountOfItemsIsCorrect(
                        isCountExpectedNumber: () => CrmContractRepository.GetAllocationCountForContract(relatedContractToDelete.ContractId) == 0,
                        errorMessage: $"Contract allocations were not deleted for {relatedContractToDelete.ContractNumber} v{relatedContractToDelete.ContractVersion}");
                }
            }
        }

        [Then(@"the following contracts are no longer present in CRM")]
        public void ThenTheFollowingContractsAreNoLongerPresentInCrm(Table table)
        {
            foreach (TableRow row in table.Rows)
            {
                bool isExistingContract = true;

                CheckResultPoller checkResultPoller = new CheckResultPoller(
                    checkResult: () => FunctionRetrier.RetryWhenExceptionContainsText(
                        function: () =>
                        {
                            isExistingContract = CrmContractRepository.IsExistingContract(row["ContractNumber"], int.Parse(row["ContractVersionNumber"]));
                            return isExistingContract == false;
                        },
                        text: "Generic SQL error"),
                    maxNumChecks: 15,
                    waitIntervalSeconds: 4);

                checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsFalse(isExistingContract, $"Contract still exists for contract {row["ContractNumber"]} v{row["ContractVersionNumber"]}");
            }
        }

        [Then(@"there are no longer any files prefixed '(.*)' in the Sharepoint '(.*)' folder")]
        public void ThenThereAreNoLongerAnyFilesPrefixedInTheSharepointFolder(string filePrefix, string folderName)
        {
            ClassicAssert.IsFalse(SharepointDocumentRepository.DoesFileWithPrefixExistInFolder(filePrefix, folderName),
                $"One or more files starting with '{filePrefix}' were found in folder '{folderName}'");
        }

        [Then(@"there are files prefixed '(.*)' in the Sharepoint '(.*)' folder")]
        public void ThenThereAreFilesPrefixedInTheSharepointFolder(string filePrefix, string folderName)
        {
            ClassicAssert.IsTrue(SharepointDocumentRepository.DoesFileWithPrefixExistInFolder(filePrefix, folderName),
                $"No files starting with '{filePrefix}' were found in folder '{folderName}'");
        }

        [Given(@"the following contract values are present in CRM")]
        [Then(@"the following contract values are present in CRM")]
        public void ThenTheFollowingContractValuesArePresentInCrm(TransformedTable table)
        {
            var expectedContracts = table.Rows.Select(r => new SimpleContract
            {
                ContractNumber = r["ContractNumber"],
                Version = int.Parse(r["ContractVersionNumber"]),
                SubVersion = int.Parse(r["ContractSubVersionNumber"]),
                Ukprn = r["UKPRN"],
                Status = RemoveWhitespaceAndHyphens(r["ContractStatus"]),
                SubStatus = r.ParseNullableString("ContractSubStatus"),
                LatestVersion = r.ParseNullableBoolean("LatestVersion"),
                LastApproved = r.ParseNullableBoolean("LastApprovedVersion"),
                StartDate = r.ParseNullableDate("ContractStartDate"),
                EndDate = r.ParseNullableDate("ContractEndDate"),
                AmendmentType = r.ParseNullableString("AmendmentType")
            }).ToList();

            expectedContracts.ForEach(expectedContract =>
            {
                sfa_contract contract = null;
                SimpleContract crmSimpleContract = null;

                CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
                {
                    contract = FunctionRetrier.RetryWhenExceptionThrown(() => CrmContractRepository.GetContract(expectedContract.ContractNumber, expectedContract.Version, expectedContract.SubVersion));
                    crmSimpleContract = contract?.ToSimpleContract();
                   
                    return crmSimpleContract != null &&
                           expectedContract.Ukprn == crmSimpleContract.Ukprn &&
                           expectedContract.Status == crmSimpleContract.Status &&
                           expectedContract.SubStatus == crmSimpleContract.SubStatus &&
                           expectedContract.LatestVersion == crmSimpleContract.LatestVersion &&
                           expectedContract.LastApproved == crmSimpleContract.LastApproved &&
                           expectedContract.StartDate == crmSimpleContract.StartDate &&
                           expectedContract.EndDate == crmSimpleContract.EndDate &&
                           expectedContract.AmendmentType == crmSimpleContract.AmendmentType;
                }, maxNumChecks: 30, waitIntervalSeconds: 3);

                bool foundContractWithValues = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsNotNull(contract, $"Could not find contract for {expectedContract.GetKey()}");

                ClassicAssert.IsTrue(foundContractWithValues, $"Unable to match data for EXPECTED: { expectedContract.GetValues()}. ACTUAL: { crmSimpleContract?.GetValues()}");
            });
        }

        private static void AssertCountOfItemsIsCorrect(Func<bool> isCountExpectedNumber, string errorMessage)
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: isCountExpectedNumber,
                maxNumChecks: 15,
                waitIntervalSeconds: 4);

            bool isCountCorrect = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsTrue(isCountCorrect, errorMessage);
        }

        private static string RemoveWhitespaceAndHyphens(string original)
        {
            return original.Replace(" ", string.Empty).Replace("-", string.Empty);
        }
    }

    public static class CrmContractExtensions
    {
        public static SimpleContract ToSimpleContract(this sfa_contract contract)
        {
            return new SimpleContract
            {
                ContractNumber = contract.sfa_number,
                Version = contract.sfa_Version.Value,
                SubVersion = contract.sfa_SubVersion.Value,
                Ukprn = contract.sfa_UKPRN,
                Status = ((sfa_contractstatus)contract.sfa_ContractStatus.Value).ToString(),
                SubStatus = contract.sfa_SubStatus?.Name,
                LatestVersion = contract.sfa_LatestVersion,
                LastApproved = contract.sfa_LastApprovedVersion,
                StartDate = contract.sfa_StartDate,
                EndDate = contract.sfa_EndDate,
                AmendmentType = contract.sfa_AmendmentType == null 
                    ? null
                    : ((sfa_amendmenttype)contract.sfa_AmendmentType.Value).ToString()
            };
        }
    }

    public class SimpleContract
    {
        public string ContractNumber { get; set; }
        public int Version { get; set; }
        public int SubVersion { get; set; }
        public string Ukprn { get; set; }
        public string Status { get; set; }
        public string SubStatus { get; set; }
        public bool? LatestVersion { get; set; }
        public bool? LastApproved { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string AmendmentType { get; set; }

        public string GetKey()
        {
            return $"ContractNumber: {ContractNumber}, Version: {Version}, SubVersion: {SubVersion}";
        }

        public string GetValues()
        {
            return $" Ukprn: {Ukprn}, Status: {Status}, SubStatus: {SubStatus}, LatestVersion: {LatestVersion}, LastApproved: {LastApproved}, StartDate: {StartDate}, EndDate: {EndDate}, AmendmentType: {AmendmentType}";
        }

        public override string ToString()
        {
            return GetKey() + GetValues();
        }

        public override bool Equals(object obj)
        {
            SimpleContract other = obj as SimpleContract;
            if (other == null)
            {
                return false;
            }

            return ContractNumber == other.ContractNumber &&
                   Version == other.Version &&
                   SubVersion == other.SubVersion &&
                   Ukprn == other.Ukprn &&
                   Status == other.Status &&
                   string.Equals(SubStatus, other.SubStatus) &&
                   (LastApproved ?? other.LastApproved) == other.LastApproved &&
                   (LatestVersion ?? other.LatestVersion) == other.LatestVersion &&
                   (StartDate ?? other.StartDate) == other.StartDate &&
                   EndDate == other.EndDate &&
                   string.Equals((AmendmentType ?? other.AmendmentType), other.AmendmentType);
        }
    }
}