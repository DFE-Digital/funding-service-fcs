namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System.Collections.Generic;
    using System.Linq;
    using NUnit.Framework;
    using Pages;
    using TechTalk.SpecFlow;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using System;
    using System.Diagnostics;
    using System.Globalization;
    using ContractManagementService.Common.Commands;
    using CrossDomain.Integration.Entities;
    using DAS.Events.Api.Types;
    using MoreLinq;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Messages.Commands;
    using Extensions;
    using Infrastructure.DTO;
    using Infrastructure.Repositories;
    using Infrastructure.Repositories.CrmReplicaRepo;
    using Infrastructure.Services;
    using Pages.DTO.Levy;
    using Utilities;
    using ContractRequest = CrossDomain.Integration.Entities.ContractRequest;
    using NUnit.Framework.Legacy;

    [Binding]
    public class CreateLevyContractSteps
    {
        private const string OrganisationNotFoundStatus = "NOTFOUND";

        private readonly PaymentManagementPageObject _paymentManagementPageObject;
        private readonly CreateLevyContractPageObject _createLevyContractPageObject;

        public CreateLevyContractSteps(CreateLevyContractPageObject createLevyContractPageObject, PaymentManagementPageObject paymentManagementPageObject, 
            PaymentGenerationPageObject paymentGenerationPageObject)
        {
            _createLevyContractPageObject = createLevyContractPageObject;
            _paymentManagementPageObject = paymentManagementPageObject;
        }

        [Given(@"the draft contract header details for the new Levy contract are as follows")]
        public void GivenTheDraftContractHeaderDetailsForTheNewLevyContractAreAsFollows(Table table)
        {
            TableRow row = table.Rows.Single();

            _createLevyContractPageObject.SetStepBuiltContractRequestType(new ContractRequest.contractRequestType
            {
                contract = new ContractRequest.contractType
                {
                    contractor = new ContractRequest.Contractor
                    {
                        ukprn = int.Parse(row["UKPRN"]),
                        legalName = row["LegalName"],
                        organisationIdentifier = row["OrgId"]
                    },
                    contracts = new List<ContractRequest.contractType>
                    {
                        new ContractRequest.contractType
                        {
                            contractor = new ContractRequest.Contractor
                            {
                                ukprn = int.Parse(row["UKPRN"]),
                                legalName = row["LegalName"],
                                organisationIdentifier = row["OrgId"]
                            },
                            contractType1 = row["ContractType"],
                            contractVersionNumber = 1,
                            correlationId = Guid.NewGuid().ToString("D"),
                            CRMIntent = (ContractRequest.Intent)Enum.Parse(typeof(ContractRequest.Intent), row["CRMIntent"]),
                            endDate = ParseDate(row["ContractEndDate"]),
                            fundingTypeCode = row["FundingType"],
                            hierarchyType = ContractRequest.hierarchyType.CONTRACT,
                            period = new ContractRequest.periodType
                            {
                                periodType1 = new ContractRequest.periodTypeType
                                {
                                    periodTypeCode = row["PeriodTypeCode"]
                                },
                                period = row["Period"]
                            },
                            startDate = ParseDate(row["ContractStartDate"])
                        }
                    },
                    correlationId = Guid.NewGuid().ToString("D"),
                    endDate = ParseDate(row["ContractEndDate"]),
                    fundingTypeCode = row["FundingType"],
                    hierarchyType = ContractRequest.hierarchyType.MASTERCONTRACT,
                    period = new ContractRequest.periodType
                    {
                        period = row["Period"],
                        periodType1 = new ContractRequest.periodTypeType
                        {
                            periodTypeCode = row["PeriodTypeCode"]
                        }
                    },
                    startDate = ParseDate(row["ContractStartDate"]),
                },
                correlationInfo = new ContractRequest.correlationInfoType
                {
                    batchId = Guid.NewGuid().ToString("D"),
                    correlationId = Guid.NewGuid().ToString("D")
                }
            });
        }

        [Given(@"the draft Levy contract allocations details for the new Levy contract are as follows")]
        public void GivenTheDraftLevyContractAllocationsDetailsForTheNewLevyContractAreAsFollows(Table table)
        {
            _createLevyContractPageObject.SetStepBuiltContractRequestTypeAllocations(table.Rows.Select(row => new ContractRequest.contractAllocation
            {
                correlationId = Guid.NewGuid().ToString("D"),
                CRMIntent = (ContractRequest.Intent)Enum.Parse(typeof(ContractRequest.Intent), row["CRMIntent"]),
                endDate = ParseDate(row["AllocationEndDate"]),
                fundingStreamCode = row["FundingStreamCode"],
                fundingStreamPeriodCode = row["FundingStreamPeriodCode"],
                period = new ContractRequest.periodType
                {
                    period = row["Period"],
                    periodType1 = new ContractRequest.periodTypeType
                    {
                        periodTypeCode = row["PeriodTypeCode"]
                    }
                },
                startDate = ParseDate(row["AllocationStartDate"]),
                ukprn = int.Parse(row["UKPRN"])
            }));
        }

        [Given(@"the draft Levy contract deliverables details for the new Levy contract are as follows")]
        public void GivenTheDraftLevyContractDeliverablesDetailsForTheNewLevyContractAreAsFollows(Table table)
        {
            _createLevyContractPageObject.SetStepBuiltContractRequestTypeDeliverables(table.Rows.Select(row => new ContractRequest.contractDeliverable
            {
                contractDeliverablePeriods = ExtractDeliverablePeriodsFromTableRow(row),
                correlationId = Guid.NewGuid().ToString("D"),
                CRMIntent = (ContractRequest.Intent)Enum.Parse(typeof(ContractRequest.Intent), row["CRMIntent"]),
                deliverable = new ContractRequest.deliverableType
                {
                    deliverableCode = int.Parse(row["DeliverableCode"]),
                    fundingStreamCode = row["FundingStreamCode"]
                },
                deliverableDescription = row["DeliverableDescription"]
            }));
        }

        [When(@"a valid DAS request is received to create a Levy contract based on the following")]
        public void WhenAValidDasRequestIsReceivedToCreateALevyContractBasedOnTheFollowing(Table table)
        {
            AddDasRequestToCreateALevyContractBasedOnTheFollowing(
                table, 
                ukprn => _createLevyContractPageObject.AddInFlightEngagementEventToPaasWithZeroId(ukprn));
        }

        [When(@"the Levy contract is created in CRM for UKPRN '(.*)'")]
        public void WhenTheLevyContractIsCreatedInCRMForUKPRN(string ukprn)
        {
            // we now poll until the contract is in CRM and store on the pageObject for future steps
            bool hasContractBeenCreated = _createLevyContractPageObject.PopulateCreatedContract(ukprn);

            ClassicAssert.IsTrue(hasContractBeenCreated, "The contract has not been created");
        }

        [When(@"a request is issued to amend the following Levy contract via Bulk")]
        [When(@"a request is issued to amend the following Levy contract")]
        [When(@"a request is issued to amend the following approved Levy contract")]
        public void WhenARequestIsIssuedToAmendTheFollowingApprovedLevyContract(TransformedTable table)
        {
            foreach (var tableRow in table.Rows)
            {
                AmendLevyContractCommand command = new AmendLevyContractCommand
                {
                    ContractInformation = tableRow.CreateInstance<ContractInformation>(),
                    AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Bulk,
                    AmendmentType = tableRow.ParseEnum<ContractManagementService.Common.AmendmentType>("AmendmentType"),
                    ShouldAddPayableNonLevyAllocation = tableRow.ParseBoolean("AddNonLevy2019Allocation"),
                    AllowUnderTermination = tableRow.ParseBoolean("AllowUnderTermination"),
                    ShouldMergeAmendmentTemplate = tableRow.ParseBoolean("ShouldMergeAmendmentTemplate"),
                    OverrideAmendmentTemplate = tableRow.ParseNullableStringOrDefaultIfNotPresent("LetterTemplateName", null),
                    OverrideTemplateName = tableRow.ParseNullableStringOrDefaultIfNotPresent("AgreementTemplateName", null)
                };

                command.ContractInformation.ContractStatus =
                    (ContractStatus)tableRow.ParseNullableEnum<ContractStatus>("Status");

                command.ContractInformation.ContractSubStatus =
                    (ContractSubStatus)tableRow.ParseNullableEnum<ContractSubStatus>("SubStatus");
                command.ContractInformation.ContractVersionNumber = int.Parse(tableRow["Version"]);

                MessageSendingBus.Send("ContractManagementDomain.LevyAmendmentEndpoint", command);
            }
        }

        [When(@"a request is issued to amend the following Levy contract via Single")]
        public void WhenARequestIsIssuedToAmendTheFollowingApprovedLevyContractSingle(TransformedTable table)
        {
            foreach (var tableRow in table.Rows)
            {
                AmendLevyContractCommand command = new AmendLevyContractCommand
                {
                    ContractInformation = tableRow.CreateInstance<ContractInformation>(),
                    AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                    AmendmentType = tableRow.ParseEnum<ContractManagementService.Common.AmendmentType>("AmendmentType"),
                    ShouldAddPayableNonLevyAllocation = tableRow.ParseBoolean("AddNonLevy2019Allocation"),
                    ShouldMergeAmendmentTemplate = tableRow.ParseBoolean("ShouldMergeAmendmentTemplate"),
                    OverrideAmendmentTemplate = tableRow.ParseNullableStringOrDefaultIfNotPresent("LetterTemplateName", null),
                    OverrideTemplateName = tableRow.ParseNullableStringOrDefaultIfNotPresent("AgreementTemplateName", null)
                };

                command.ContractInformation.ContractStatus =
                    (ContractStatus)tableRow.ParseNullableEnum<ContractStatus>("Status");

                command.ContractInformation.ContractSubStatus =
                    (ContractSubStatus)tableRow.ParseNullableEnum<ContractSubStatus>("SubStatus");
                command.ContractInformation.ContractVersionNumber = int.Parse(tableRow["Version"]);

                MessageSendingBus.Send("ContractManagementDomain.LevyAmendmentEndpoint", command);
            }
        }

        [When(@"a request is issued to withdraw and reissue the following draft Levy contract")]
        public void WhenARequestIsIssuedToWithdrawAndReissueTheFollowingDraftLevyContract(TransformedTable table)
        {
            TableRow tableRow = table.Rows.Single();

            PreIncrementWithdrawalCommand command = new PreIncrementWithdrawalCommand
            {
                Ukprn = tableRow["UKPRN"],
                MasterContractNumber = tableRow["MasterContractNumber"],
                ContractNumber = tableRow["ContractNumber"],
                VersionNumber = int.Parse(tableRow["Version"])
            };

            MessageSendingBus.Send("ContractManagementDomain.InitiateContractWithdrawal", command);
        }

        [Then(@"there should be (.*) DAS Levy contracts in CRM within (.*) seconds for UKPRNs prefixed '(.*)' with a sub-status of '(.*)'")]
        public void ThenThereShouldBeDASLevyContractsInCRMForUKPRNsPrefixedWithASub_StatusOf(int contractCount, int maxSecondsToWait, int ukprnPrefix, string subStatus)
        {
            var contractsForUkprn = _paymentManagementPageObject.GetContractsByUkprnPrefixAndSubStatus(ukprnPrefix, subStatus);
            var stopwatch = new Stopwatch();
            stopwatch.Start();

            while (contractsForUkprn.Count != contractCount && stopwatch.Elapsed.Seconds < maxSecondsToWait)
            {
                System.Threading.Tasks.Task.Delay(TimeSpan.FromSeconds(2)).Wait();
                contractsForUkprn = _paymentManagementPageObject.GetContractsByUkprnPrefixAndSubStatus(ukprnPrefix, subStatus);
                Debug.WriteLine($"Found {contractsForUkprn.Count} - Expected {contractCount}");
                Debug.WriteLine($"Wait time remaining: {maxSecondsToWait - stopwatch.Elapsed.Seconds}s");
            }

            stopwatch.Stop();
            ClassicAssert.AreEqual(contractCount, contractsForUkprn.Count);
        }

        [Then(@"there are no open tasks for the contract")]
        public void ThenThereAreNoOpenTasksForContract()
        {
            ClassicAssert.IsFalse(_createLevyContractPageObject.DoesTaskExistForContract(_createLevyContractPageObject.CreatedContractGuid));
        }

        [Then(@"the following workflow history entries are present on the latest version of the contract")]
        public void ThenTheFollowingWorkflowHistoryEntriesForContractArePresent(Table table)
        {
            IReadOnlyCollection<ContractWorkflow> workflowItems = _createLevyContractPageObject.GetWorkflowHistoryActionNamesForContract();

            foreach (TableRow row in table.Rows)
            {
                string actionName = row["Action"];
                ContractWorkflow matchingWorkflowItem = workflowItems.SingleOrDefault(wfi => wfi.Action == actionName);

                if (matchingWorkflowItem != null)
                {
                    ClassicAssert.IsTrue(string.IsNullOrEmpty(matchingWorkflowItem.PreviousContractOwner),
                        $"There is a PreviousContractOwner for {actionName}");
                    ClassicAssert.IsTrue(string.IsNullOrEmpty(matchingWorkflowItem.NewContractOwner),
                        $"There is a NewContractOwner for {actionName}");
                }
                else
                {
                    ClassicAssert.Fail($"This Action: {row["Action"]} is not present in CRM");
                }
            }
        }

        [Then(@"the following workflow history entries are not present on the latest version of the contract")]
        public void ThenTheFollowingWorkflowHistoryEntriesForContractAreNotPresent(Table table)
        {
            IReadOnlyCollection<ContractWorkflow> workflowItems = _createLevyContractPageObject.GetWorkflowHistoryActionNamesForContract();

            foreach (TableRow row in table.Rows)
            {
                if (workflowItems.Any(wfi => wfi.Action == row["Action"]))
                {
                    ClassicAssert.Fail($"This Action: {row["Action"]} is present in CRM and it shouldn't be");
                }
            }
        }

        [Then(@"the latest version of the contract has the following settings")]
        public void ThenTheLatestVersionOfContractHasTheFollowingSettings(Table table)
        {
            var firstRow = table.Rows.First();

            string subStatusToLookFor = firstRow["SubStatus"];
            string versionToLookFor = firstRow.ContainsKey("ContractVersionNumber")
                ? firstRow["ContractVersionNumber"]
                : null;

            ContractInfo contractInfo = null;

            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                contractInfo = _createLevyContractPageObject.GetMostRecentContractInfo();

                return contractInfo.SubStatus == subStatusToLookFor && (versionToLookFor == null || versionToLookFor == contractInfo.Contract.sfa_Version.Value.ToString());
            },
               maxNumChecks: 50,
               waitIntervalSeconds: 2);

            checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTimeWithGenericSqlErrorTolerance();

            foreach (TableRow row in table.Rows)
            {
               
                ClassicAssert.AreEqual(row["SubStatus"], contractInfo.SubStatus, "CRM record Substatus value mismatch");
                ClassicAssert.AreEqual(row["Status"], ((sfa_contractstatus)contractInfo.Contract.sfa_ContractStatus.Value).ToString(), "CRM record Status value mismatch");
                ClassicAssert.AreEqual(row["LatestVersion"] == "Yes", contractInfo.Contract.sfa_LatestVersion, "CRM record Version mismatch");
                ClassicAssert.AreEqual(row["LastApprovedVersion"] == "Yes", contractInfo.Contract.sfa_LastApprovedVersion, "CRM record Last Approved Version mismatch");
                if (row.ContainsKey("ContractVersionNumber"))
                {
                    ClassicAssert.IsNotNull(contractInfo.Contract.sfa_Version);
                    ClassicAssert.AreEqual(row["ContractVersionNumber"], contractInfo.Contract.sfa_Version.Value.ToString(), "The contract version number is not correct");
                }
            }
        }

        [Then(@"the draft contract header details for the new Levy contract are as follows")]
        public void ThenTheDraftContractHeaderDetailsForTheCreatedLevyContractAreAsFollows(Table table)
        {
            TableRow row = table.Rows.Single();

            ContractHeaderInfo contractHeaderInfo = _createLevyContractPageObject.GetLatestContractHeaderInfo();

            ClassicAssert.AreEqual(
                ParseDate(row["ContractStartDate"]),
                new DateTime(
                    contractHeaderInfo.ContractStartDate.GetValueOrDefault().Year, 
                    contractHeaderInfo.ContractStartDate.GetValueOrDefault().Month,
                    contractHeaderInfo.ContractStartDate.GetValueOrDefault().Day),
                "Unexpected ContractStartDate retrieved from CRM");
            ClassicAssert.IsNull(contractHeaderInfo.ContractEndDate, "ContractEndDate retrieved from CRM is not null");
            ClassicAssert.AreEqual(decimal.Parse(row["ContractValue"]), contractHeaderInfo.ContractValue, "Unexpected ContractValue retrieved from CRM.");
            ClassicAssert.AreEqual(row["FundingType"], contractHeaderInfo.FundingTypeCode, "Unexpected FundingTypeCode retrieved from CRM");
            ClassicAssert.AreEqual(int.Parse(row["Period"]), contractHeaderInfo.Period, "Unexpected Period retrieved from CRM");
            ClassicAssert.AreEqual(row["PeriodTypeCode"], contractHeaderInfo.PeriodTypeCode, "Unexpected PeriodType retrieved from CRM");
            ClassicAssert.AreEqual(row["ContractType"], contractHeaderInfo.ContractType, "Unexpected ContractType retrieved from CRM");
            ClassicAssert.AreEqual(int.Parse(row["UKPRN"]), contractHeaderInfo.Ukprn, "Unexpected UKPRN retrieved from CRM");
            ClassicAssert.AreEqual(row["LegalName"], contractHeaderInfo.LegalName, "Unexpected LegalName retrieved from CRM");
        }

        [Then(@"the draft Levy contract allocations details for the new Levy contract are as follows")]
        public void ThenTheDraftLevyContractAllocationsDetailsForTheNewLevyContractAreAsFollows(Table table)
        {
            IList<ContractAllocationInfo> contractAllocationInfos = null;
            CheckResultPoller poller = new CheckResultPoller(
                checkResult:() =>
                {
                    contractAllocationInfos = _createLevyContractPageObject.GetLatestContractAllocationInfos();
                    return contractAllocationInfos.Count == table.Rows.Count;
                },
                maxNumChecks: 20, waitIntervalSeconds: 3);

            poller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.AreEqual(table.Rows.Count, contractAllocationInfos.Count, "Unexpected number of allocations retrieved from CRM.");

            table.Rows.ForEach(row =>
            {
                ClassicAssert.IsTrue(contractAllocationInfos.Any(a =>
                    a.AllocationStartDate == ParseDate(row["AllocationStartDate"]) &&
                    a.AllocationEndDate == null &&
                    a.FundingStreamCode == row["FundingStreamCode"] &&
                    a.FundingStreamPeriodCode == row["FundingStreamPeriodCode"] &&
                    a.Period == int.Parse(row["Period"]) &&
                    a.PeriodTypeCode == row["PeriodTypeCode"]), "Matching allocation not retrieved from CRM.");
            });
        }

        [Then(@"the draft Levy contract deliverables details for the new Levy contract are as follows")]
        public void ThenTheDraftLevyContractDeliverablesDetailsForTheNewLevyContractAreAsFollows(Table table)
        {
            IList<ContractDeliverablePeriodInfo> rowContractDeliverablePeriodInfos = TransformDeliverablesTableToContractDeliverablePeriodInfos(table);

            IList<ContractDeliverablePeriodInfo> crmContractDeliverablePeriodInfos = new List<ContractDeliverablePeriodInfo>();
            CheckResultPoller deliverablePeriodsCheckResultPoller = new CheckResultPoller(checkResult: () =>
            {
                crmContractDeliverablePeriodInfos = _createLevyContractPageObject.GetContractDeliverablePeriodInfos(_createLevyContractPageObject.CreatedContractNumber);

                return rowContractDeliverablePeriodInfos.All(crmContractDeliverablePeriodInfos.Contains);
            },
            maxNumChecks: 12,
            waitIntervalSeconds: 3);

            bool areDeliverablePeriodsPresent = deliverablePeriodsCheckResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();
            var missing = rowContractDeliverablePeriodInfos.FirstOrDefault(r => crmContractDeliverablePeriodInfos.Contains(r));
            ClassicAssert.IsTrue(areDeliverablePeriodsPresent, $"Not all the deliverable periods are present - {missing?.ToString()}");

            foreach (var row in rowContractDeliverablePeriodInfos)
            {
                var crmRow = crmContractDeliverablePeriodInfos.SingleOrDefault(crm => crm.DeliverableCode == row.DeliverableCode
                && crm.Month == row.Month
                && crm.Year == row.Year
                && crm.FundingStreamCode == row.FundingStreamCode);
                if (crmRow == null)
                    ClassicAssert.Fail($"No Matching CRM deliverable/period for FundingStreamCode:{row.FundingStreamCode} DeliverableCode:{row.DeliverableCode} Month:{row.Month} Year:{row.Year}");

                ClassicAssert.AreEqual(row.DeliverableDescription, crmRow.DeliverableDescription, $"Deliverable Description does not match for FundingStreamCode:{row.FundingStreamCode} DeliverableCode:{row.DeliverableCode} Month:{row.Month} Year:{row.Year}");
                ClassicAssert.AreEqual(row.DeliverablePlannedValue, crmRow.DeliverablePlannedValue, $"Deliverable Planned Value does not match for FundingStreamCode:{row.FundingStreamCode} DeliverableCode:{row.DeliverableCode} Month:{row.Month} Year:{row.Year}");
                ClassicAssert.AreEqual(row.PlannedValue, crmRow.PlannedValue, $"Planned Value does not match for for FundingStreamCode:{row.FundingStreamCode} DeliverableCode:{row.DeliverableCode} Month:{row.Month} Year:{row.Year}");
            }
        }

        [Then(@"there is no contract owner assigned to the latest version of the contract")]
        public void ThereIsNoContractOwner()
        {
            ClassicAssert.IsFalse(_createLevyContractPageObject.HasContractOwner, "There is a contract owner");
        }

        [Given(@"there is no caseload for provider with UKPRN '(.*)'")]
        [Given(@"there is no caseload advisor for UKPRN '(.*)'")]
        public void GivenThereIsNoCaseloadForProviderWithUkprn(int ukprn)
        {
            _createLevyContractPageObject.DeleteCaseloadForUkrpn(ukprn);
            CrmReplicatedRepository.DeleteCaseloadForUkrpn(ukprn.ToString());
        }

        [Given(@"there are no Levy contract documents in sharepoint location '(.*)' for UKPRN '(.*)'")]
        public void GivenThereAreNoLevyContractDocumentsInSharepointLocationForUKPRN(string office365Location, string ukPrn)
        {
            _createLevyContractPageObject.RemoveDocumentsForUkPrnFromOffice365Folder(office365Location, ukPrn);
        }

        [Then(@"'(.*)' is the ContractNumber of the latest Levy contract held by UKPRN '(.*)'")]
        public void ThenIsTheContractNumberOfTheLatestLevyContractHeldByUKPRN(string featureVariableName, string ukPrn)
        {
            FeatureVariables.Set(featureVariableName, _createLevyContractPageObject.GetLatestContractNumberForUkprn(ukPrn));
        }

        [Then(@"a file named '(.*)' & '(.*)' & '(.*)' exists in sharepoint location '(.*)'")]
        public void ThenAFileNamedExistsInSharepointLocation(string ukPrn, TransformedString contractNumber, string fileVersion, string location)
        {
            ClassicAssert.IsTrue(_createLevyContractPageObject.IsContractDocumentWithSpecifiedNamePresentInOffice365(ukPrn, contractNumber.Value, fileVersion, location), "File does not exist");
        }

        [Then(@"a file named '(.*)' & '(.*)' & '(.*)' does not exist in sharepoint location '(.*)'")]
        public void ThenAFileNamedDoesNotExistInSharepointLocation(string ukPrn, TransformedString contractNumber, string fileVersion, string location)
        {
            ClassicAssert.IsTrue(_createLevyContractPageObject.IsContractDocumentWithSpecifiedNameNotPresentInOffice365(ukPrn, contractNumber.Value, fileVersion, location), "File exists in location");
        }

        [Then(@"the generated ts&cs document in sharepoint location '(.*)' contains the following lines in order")]
        public void ThenTheGeneratedTsCsDocumentInSharepointLocationContainsTheFollowingLinesInOrder(string location, TransformedString multilineText)
        {
            _createLevyContractPageObject.VerifyLinesInOrderAndAssertIfNotFound(location, multilineText);
        }
        
        [Then(@"the ContractManagement\.AtomFeedItem table contains one ItemType '(.*)' event for contract number '(.*)'")]
        public void ThenTheContractManagement_AtomFeedItemTableContainsOneItemTypeEventForContractNumber(int itemType, TransformedString contractNumber)
        {
            ClassicAssert.IsTrue(_createLevyContractPageObject.IsOneItemTypePresentInContractManagementAtomFeedForContractNumber(itemType, contractNumber.Value),
                "The expected entry for this contract was not found in the Contract Management Atom Feed");
        }

        [Then(@"the ContractManagement\.AtomFeedItem table contains one ItemType '(.*)' event for version '(.*)' of contract number '(.*)'")]
        public void ThenTheContractManagement_AtomFeedItemTableContainsOneItemTypeEventForVersionOfContractNumber(int itemType, int version, TransformedString contractNumber)
        {
            ClassicAssert.IsTrue(_createLevyContractPageObject.IsOneItemTypePresentInContractManagementAtomFeedForContractNumberAndVersionNumber(itemType, version, contractNumber.Value),
                $"There is not a single item present in the Contract Management Atom Feed for this Contract - {contractNumber}");
        }

        [Then(@"the ContractManagement\.AtomFeedItem table does not contain an ItemType '(.*)' event for version '(.*)' of contract number '(.*)'")]
        public void ThenTheContractManagement_AtomFeedItemTableDoesNotContainAnItemTypeEventForVersionOfContractNumber(int itemType, int version, TransformedString contractNumber)
        {
            ClassicAssert.IsFalse(_createLevyContractPageObject.IsItemPresentInContractManagementAtomFeedForContractNumberAndVersion(itemType, version, contractNumber.Value));
        }

        [Then(@"the ContractManagement\.AtomFeedItem table does not contain an ItemType '(.*)' event for version '(.*)' of actual contract number '(.*)'")]
        public void ThenTheContractManagement_AtomFeedItemTableDoesNotContainAnItemTypeEventForVersionOfActualContractNumber(int itemType, int version, TransformedString contractNumber)
        {
            ClassicAssert.IsFalse(_createLevyContractPageObject.IsItemPresentInContractManagementAtomFeedForContractNumberAndVersion(itemType, version, contractNumber));
        }

        [Then(@"the ContractManagement\.AtomFeedItem table contains one ItemType '(.*)' event for version '(.*)' of actual contract number '(.*)'")]
        public void ThenTheContractManagement_AtomFeedItemTableContainsOneItemTypeEventForVersionOfActualContractNumber(int itemType, int version, TransformedString contractNumber)
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: () => _createLevyContractPageObject.IsItemPresentInContractManagementAtomFeedForContractNumberAndVersion(itemType, version, contractNumber.Value),
                maxNumChecks: 30,
                waitIntervalSeconds: 3);

            ClassicAssert.IsTrue(checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime(), $"There are no items of type {itemType} in the Contract Management Atom Feed for Contract: {contractNumber}, Version: {version}");
        }

        [Then(@"the ItemType '(.*)' event for contract number '(.*)' in the ContractManagement\.AtomFeedItem table conforms to the Corporate Contract Schema")]
        public void ThenTheItemTypeEventForContractNumberInTheContractManagement_AtomFeedItemTableConformsToTheCorporateContractSchema(int itemType, TransformedString contractNumber)
        {
            ClassicAssert.IsTrue(_createLevyContractPageObject.IsContractManagementAtomFeedItemValidXml(itemType, contractNumber.Value), "Atom Feed Item XML does not conform to the corporate schema");
        }

        [Then(@"the ItemType '(.*)' event for version '(.*)' of contract number '(.*)' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema")]
        public void ThenTheItemTypeEventForVersionOfContractNumberInTheContractManagement_AtomFeedItemTableConformsToTheCorporateContractSchema(int itemType, int version, TransformedString contractNumber)
        {
            ClassicAssert.IsTrue(_createLevyContractPageObject.IsContractManagementAtomFeedItemValidXml(itemType, version, contractNumber.Value), "Atom Feed Item XML does not conform to the corporate schema");
        }

        [Then(@"the ItemType '(.*)' event for version '(.*)' of actual contract number '(.*)' in the ContractManagement\.AtomFeedItem table conforms to the Corporate Contract Schema")]
        public void ThenTheItemTypeEventForVersionOfActualContractNumberInTheContractManagement_AtomFeedItemTableConformsToTheCorporateContractSchema(int itemType, int version, TransformedString contractNumber)
        {
            ClassicAssert.IsTrue(_createLevyContractPageObject.IsContractManagementAtomFeedItemValidXml(itemType, version, contractNumber.Value), "Atom Feed Item XML does not conform to the corporate schema");
        }

        [Then(@"'(.*)' is the ContractAllocationNumber of the latest Levy contract held by UKPRN '(.*)'")]
        public void ThenIsTheContractAllocationNumberOfTheLatestLevyContractHeldByUKPRN(string featureVariableName, string ukPrn)
        {
            string allocationNumber = _createLevyContractPageObject.GetLatestAllocationNumberForUkprn(ukPrn);

            FeatureVariables.Set(featureVariableName, allocationNumber);

            _paymentManagementPageObject.ContractToTest.contracts.Add(new ExtendedContract
            {
                contractAllocations = new List<ExtendedContractAllocation>
                {
                    new ExtendedContractAllocation
                    {
                        contractAllocationNumber = allocationNumber
                    }
                }
            });
        }

        [Then(@"'(.*)' is the MasterContractNumber of the latest Levy contract held by UKPRN '(.*)'")]
        public void ThenIsTheMasterContractNumberOfTheLatestLevyContractHeldByUKPRN(string propertyName, string ukPrn)
        {
            _createLevyContractPageObject.SetMasterContractNumberOnPageObject(propertyName.Replace("[", "").Replace("]", ""), ukPrn);
        }

        [Then(@"the PaymentSchedule\.DeliverablePayment table contains the following values")]
        [Then(@"PAAS table PaymentSchedule\.DeliverablePayment contains the following values")]
        public void ThenPaasTablePaymentSchedule_DeliverablePaymentContainsTheFollowingValues(TransformedTable table)
        {
            var expecteDeliverablePayments = table.Rows.Select(TransformTableRowToDeliverablePayment).ToList();

            expecteDeliverablePayments.GroupBy(dp => new{dp.AllocationNumber, dp.VersionNumber}).ForEach(allocationGrp =>
            {
                DeliverablePayment deliverablePaymentThatMayNotMatched = null;
                DeliverablePayment actualDeliverablePayment = null;
                CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
                {
                    var actualDeliverablePayments =
                        PaymentSchedulePolicyRepository.GetDeliverablePayments(allocationGrp.Key.AllocationNumber,
                            allocationGrp.Key.VersionNumber);

                    return allocationGrp.All(expectedDp =>
                    {
                        actualDeliverablePayment = actualDeliverablePayments.FirstOrDefault(actualDp =>
                            actualDp.DeliverableCode == expectedDp.DeliverableCode &&
                            actualDp.Period == expectedDp.Period);
                        var areEquivalent = PaymentSchedulePolicyRepository.HaveDeliverablePaymentsGotEquivalentCalcValues(
                            expectedDp, actualDeliverablePayment);

                        deliverablePaymentThatMayNotMatched = expectedDp;
                        
                        return areEquivalent;
                    });
                },
                    maxNumChecks:20,
                    waitIntervalSeconds:4);
                checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsNotNull(actualDeliverablePayment, $"There is no deliverable payment row for: {deliverablePaymentThatMayNotMatched}");
                ClassicAssert.AreEqual(actualDeliverablePayment.PeriodTypeCode, actualDeliverablePayment.PeriodTypeCode, $"PeriodTypeCode was not equal to expected value for: {deliverablePaymentThatMayNotMatched}");

                AssertAreEqualIfPresent(actualDeliverablePayment.PlannedValue.HasValue, deliverablePaymentThatMayNotMatched.PlannedValue, actualDeliverablePayment.PlannedValue, $"PlannedValue was not equal to expected value for: {deliverablePaymentThatMayNotMatched}");
                AssertAreEqualIfPresent(actualDeliverablePayment.ProfilePaymentAmount.HasValue, deliverablePaymentThatMayNotMatched.ProfilePaymentAmount, actualDeliverablePayment.ProfilePaymentAmount, $"ProfilePaymentAmount was not equal to expected value for: {deliverablePaymentThatMayNotMatched}");
                AssertAreEqualIfPresent(actualDeliverablePayment.CappedPaymentAmount.HasValue, deliverablePaymentThatMayNotMatched.CappedPaymentAmount, actualDeliverablePayment.CappedPaymentAmount, $"CappedPaymentAmount was not equal to expected value for: {deliverablePaymentThatMayNotMatched}");
                AssertAreEqualIfPresent(actualDeliverablePayment.BalancingPaymentAmount.HasValue, deliverablePaymentThatMayNotMatched.BalancingPaymentAmount, actualDeliverablePayment.BalancingPaymentAmount, $"BalancingPaymentAmount was not equal to expected value for: {deliverablePaymentThatMayNotMatched}");
                AssertAreEqualIfPresent(actualDeliverablePayment.ReconciliationPaymentAmount.HasValue, deliverablePaymentThatMayNotMatched.ReconciliationPaymentAmount, actualDeliverablePayment.ReconciliationPaymentAmount, $"ReconciliationPaymentAmount was not equal to expected value for: {deliverablePaymentThatMayNotMatched}");
                ClassicAssert.AreEqual(actualDeliverablePayment.NetPaymentAmount, deliverablePaymentThatMayNotMatched.NetPaymentAmount, $"NetPaymentAmount was not equal to expected value for: {deliverablePaymentThatMayNotMatched}");
                AssertAreEqualIfPresent(actualDeliverablePayment.ActualValue.HasValue, deliverablePaymentThatMayNotMatched.ActualValue.GetValueOrDefault(), actualDeliverablePayment.ActualValue.GetValueOrDefault(), $"ActualValue was not equal to expected value for: {deliverablePaymentThatMayNotMatched}");
                AssertAreEqualIfPresent(actualDeliverablePayment.ActualVolume.HasValue, deliverablePaymentThatMayNotMatched.ActualVolume.GetValueOrDefault(), actualDeliverablePayment.ActualVolume.GetValueOrDefault(), $"ActualVolume was not equal to expected value for: {deliverablePaymentThatMayNotMatched}");
            });
            

            //foreach (var row in table.Rows)
            //{
            //    DeliverablePayment stepDeliverablePayment = TransformTableRowToDeliverablePayment(row);
            //    DeliverablePayment paasDeliverablePayment = null;
            //    var checkResultPoller = new CheckResultPoller(checkResult:() =>
            //    {
            //        paasDeliverablePayment =
            //            PaymentSchedulePolicyRepository.GetDeliverablePaymentByKey(
            //                stepDeliverablePayment.AllocationNumber,
            //                stepDeliverablePayment.VersionNumber,
            //                stepDeliverablePayment.DeliverableCode,
            //                stepDeliverablePayment.Period);

            //        return
            //            PaymentSchedulePolicyRepository.HaveDeliverablePaymentsGotEquivalentCalcValues(
            //                stepDeliverablePayment, paasDeliverablePayment);
            //    },
            //    maxNumChecks: 20, 
            //    waitIntervalSeconds: 4);

            //    checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            //    ClassicAssert.IsNotNull(paasDeliverablePayment, $"There is no deliverable payment row for: {stepDeliverablePayment}");
            //    ClassicAssert.AreEqual(stepDeliverablePayment.PeriodTypeCode, paasDeliverablePayment.PeriodTypeCode, $"PeriodTypeCode was not equal to expected value for: {stepDeliverablePayment}");

            //    AssertAreEqualIfPresent(stepDeliverablePayment.PlannedValue.HasValue, stepDeliverablePayment.PlannedValue, paasDeliverablePayment.PlannedValue, $"PlannedValue was not equal to expected value for: {stepDeliverablePayment}");
            //    AssertAreEqualIfPresent(stepDeliverablePayment.ProfilePaymentAmount.HasValue, stepDeliverablePayment.ProfilePaymentAmount, paasDeliverablePayment.ProfilePaymentAmount, $"ProfilePaymentAmount was not equal to expected value for: {stepDeliverablePayment}");
            //    AssertAreEqualIfPresent(stepDeliverablePayment.CappedPaymentAmount.HasValue, stepDeliverablePayment.CappedPaymentAmount, paasDeliverablePayment.CappedPaymentAmount, $"CappedPaymentAmount was not equal to expected value for: {stepDeliverablePayment}");
            //    AssertAreEqualIfPresent(stepDeliverablePayment.BalancingPaymentAmount.HasValue, stepDeliverablePayment.BalancingPaymentAmount, paasDeliverablePayment.BalancingPaymentAmount, $"BalancingPaymentAmount was not equal to expected value for: {stepDeliverablePayment}");
            //    AssertAreEqualIfPresent(stepDeliverablePayment.ReconciliationPaymentAmount.HasValue, stepDeliverablePayment.ReconciliationPaymentAmount, paasDeliverablePayment.ReconciliationPaymentAmount, $"ReconciliationPaymentAmount was not equal to expected value for: {stepDeliverablePayment}");
            //    ClassicAssert.AreEqual(stepDeliverablePayment.NetPaymentAmount, paasDeliverablePayment.NetPaymentAmount, $"NetPaymentAmount was not equal to expected value for: {stepDeliverablePayment}");
            //    AssertAreEqualIfPresent(stepDeliverablePayment.ActualValue.HasValue, stepDeliverablePayment.ActualValue.GetValueOrDefault(), paasDeliverablePayment.ActualValue.GetValueOrDefault(), $"ActualValue was not equal to expected value for: {stepDeliverablePayment}");
            //    AssertAreEqualIfPresent(stepDeliverablePayment.ActualVolume.HasValue, stepDeliverablePayment.ActualVolume.GetValueOrDefault(), paasDeliverablePayment.ActualVolume.GetValueOrDefault(), $"ActualVolume was not equal to expected value for: {stepDeliverablePayment}");
            //}

            DeliverablePayment TransformTableRowToDeliverablePayment(TableRow row)
            {
                return new DeliverablePayment
                {
                    AllocationNumber = row["AllocationNumber"],
                    VersionNumber = int.Parse(row["VersionNumber"]),
                    DeliverableCode = int.Parse(row["DeliverableCode"]),
                    Period = row["Period"],
                    PeriodTypeCode = (PeriodTypeCode)int.Parse(row["PeriodTypeCode"]),
                    PlannedVolume = row.ParseNullableInt("PlannedVolume"),
                    PlannedValue = row.ParseNullableDecimal("PlannedValue"),
                    ProfilePaymentAmount = row.ParseNullableDecimal("ProfilePaymentAmount"),
                    CappedPaymentAmount = row.ParseNullableDecimal("CappedPaymentAmount"),
                    BalancingPaymentAmount = row.ParseNullableDecimal("BalancingPaymentAmount"),
                    ReconciliationPaymentAmount = row.ParseNullableDecimal("ReconciliationPaymentAmount"),
                    NetPaymentAmount = decimal.Parse(row["NetPaymentAmount"]),
                    ActualValue = row.ParseNullableDecimal("ActualValue"),
                    ActualVolume = row.ParseNullableInt("ActualVolume")
                };
            }
        }

        [When(@"a contract approval message is received from SFS for MasterContractNumber '(.*)' and ContractNumber '(.*)' and Version '(.*)'")]
        public void WhenAContractApprovalMessageIsReceivedFromSFSForMasterContractNumberAndContractNumber(TransformedString masterContractNumber, TransformedString contractNumber, int version)
        {
            _createLevyContractPageObject.RemoveMonthEndHistories();

            _createLevyContractPageObject.SimulateSFSAndSendContractApprovalMessageForGivenContract(masterContractNumber.Value, contractNumber.Value, version);
        }

        [Then(@"there are '(.*)' deliverable period rows in CRM linked to the latest version of contract number '(.*)'")]
        public void ThenThereAreDeliverablePeriodRowsInCRMLinkedToTheLatestVersionOfContractNumber(int numberOfDeliverableRecords, TransformedString contractNumber)
        {
            int actualDeliverablePeriodsCount = 0;
            CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: () =>
                {
                    actualDeliverablePeriodsCount = _paymentManagementPageObject.GetCountOfDeliverablesPeriodsInCrmForGivenContract(contractNumber.Value);
                    return actualDeliverablePeriodsCount == numberOfDeliverableRecords;
                },
                maxNumChecks: 40,
                waitIntervalSeconds: 3
                );

            checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsTrue(
                actualDeliverablePeriodsCount == numberOfDeliverableRecords,
                $"The test expected to find {numberOfDeliverableRecords} records in CRM for contract {contractNumber} but instead found {actualDeliverablePeriodsCount}");
        }

        [When(@"a contract approval message is received from SFS for version '(.*)' actual MasterContractNumber '(.*)' and actual ContractNumber '(.*)'")]
        public void WhenAContractApprovalMessageIsReceivedFromSFSForVersionActualMasterContractNumberAndActualContractNumber(int contractVersionNumber, string masterContractNumber, string contractNumber)
        {
            if (Debugger.IsAttached)
            {
                _createLevyContractPageObject.SimulateSFSAndSendContractApprovalMessageForGivenContractViaBus(masterContractNumber, contractNumber, contractVersionNumber);
            }
            else
            {
                _createLevyContractPageObject.SimulateSFSAndSendContractApprovalMessageForGivenContract(masterContractNumber, contractNumber, contractVersionNumber);
            }
        }

        [When(@"contract approval messages arrive for the following contracts")]
        public void WhenContractApprovalMessagesArriveForTheFollowingContracts(Table table)
        {
            foreach (var row in table.Rows)
            {
                string masterContractNumber = row["MasterContractNumber"];
                string contractNumber = row["ContractNumber"];
                int version = int.Parse(row["Version"]);

                _createLevyContractPageObject.SimulateSFSAndSendContractApprovalMessageForGivenContractViaBus(
                    masterContractNumber, contractNumber, version);
            }
        }

        [Given(@"the Reconciliation Data in CRM is calculated as follows for Levy")]
        [Then(@"the Reconciliation Data in CRM is calculated as follows for Levy")]
        public void ThenTheReconciliationPaymentsAreCalculatedAsFollows(Table reconciliationPaymentsTable)
        {
            CheckCrmPaymentValues(reconciliationPaymentsTable, paymentRow => paymentRow.ReconciliationAmount);
        }

        [Then(@"the Net Payments in CRM are calculated as follows")]
        public void ThenTheNetPaymentsAreCalculatedAsFollows(Table netPaymentsTable)
        {
            CheckCrmPaymentValues(netPaymentsTable, paymentRow => paymentRow.NetPaymentAmount.GetValueOrDefault(0));
        }

        [Given(@"the Reconciliation Subnominal Amounts are calculated as follows for Levy")]
        [Then(@"the Reconciliation Subnominal Amounts are calculated as follows for Levy")]
        public void ThenTheReconciliationSubnominalAmountsAreCalculatedAsFollowsForLevy(TransformedTable subnominalsTable)
        {
            foreach (TableRow row in subnominalsTable.Rows)
            {
                int periodsWithValues = row.GetPeriodValues().Count(pv => pv.Value.HasValue);
                var subnominalAggregations = new List<SubnominalAggregation>();
               
                CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
                {
                    subnominalAggregations = _paymentManagementPageObject.GetSubnominalAggregationsForSubnominalCodeAndAllocationNumber(row["AllocationRef"], row["ReconciliationSubnominal"], "RECONCILIATION");
                    
                    return subnominalAggregations.Count == periodsWithValues;
                },
                maxNumChecks: 20,
                waitIntervalSeconds: 3);

                checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.AreEqual(periodsWithValues, subnominalAggregations.Count, $"Could not get {periodsWithValues} subnominal aggregations from CRM, Allocation:{row["AllocationRef"]}, ReconciliationSubnominal: {row["ReconciliationSubnominal"]}");
                CheckValuesResult checkValuesResult = CheckValuesReturnedFromCrm(row, subnominalAggregations, "RECONCILIATION");
                ClassicAssert.IsTrue(checkValuesResult.AreAllValuesPresent, checkValuesResult.ErrorMsg);
            }
        }

        [Then(@"there are '(.*)' rows in the MonitoringDeliverables\.PaymentInstructionAudit table for UKPRN '(.*)'")]
        public void ThenThereAreRowsInTheMonitoringDeliverables_PaymentInstructionAuditTableForUKPRN(int expectedNumberOfRows, string ukprn)
        {
            int actualRecordCount = _createLevyContractPageObject.GetCountOfPaymentInstructionAuditRecordsForUkprn(ukprn, expectedNumberOfRows);

            ClassicAssert.AreEqual(expectedNumberOfRows, actualRecordCount,
                $"Number of records {actualRecordCount} in payment instruction audit table do not match the expected result {expectedNumberOfRows} for provider {ukprn} ");
        }

        [Then(@"the Reconciliation Data in CRM is calculated as follows")]
        public void ThenTheReconciliationDataIsCalculatedAsFollows(Table reconciliationTable)
        {
            CheckCrmPaymentValues(reconciliationTable, paymentRow => paymentRow.ReconciliationAmount);
        }

        [Given(@"the PaaS MonthEndIsRunning indicator is set to '(.*)'")]
        [When(@"the PaaS MonthEndIsRunning indicator is set to '(.*)'")]
        [Then(@"the PaaS MonthEndIsRunning indicator is set to '(.*)'")]
        public void GivenThePaaSMonthEndIsRunningIndicatorIsSetTo(bool isMonthEndRunning)
        {
            if (isMonthEndRunning)
            {
                MonthEndHistoryRepository.StartMonthEnd();
            }
            else
            {
                MonthEndHistoryRepository.StopMonthEnd();
            }
        }

        [Given(@"there is no Levy event data in the DAS agreement stub")]
        public void GivenThereIsNoLevyEventDataInTheDASAgreementStub()
        {
            _createLevyContractPageObject.ClearDasCommitmentsStubRepository();
        }

        [Given(@"there are no entries in the ContractManagement.EngagementEvent table")]
        [Given(@"there are no DAS engagement events stored in FCS")]
        public void GivenThereAreNoDASEngagementEventsStoredInFCS()
        {
            _createLevyContractPageObject.ClearDasEngagementEvents();
        }

        [Given(@"the following Levy event data is available in the DAS agreement stub")]
        public void GivenTheFollowingLevyEventDataIsAvailableInTheDASAgreementStub(Table table)
        {
            IEnumerable<AgreementEventView> agreementEvents = table.Rows
               .Select(
                   row => new AgreementEventView
                   {
                       Id = long.Parse(row["Id"]),
                       CreatedOn = DateTime.Parse(row["CreatedOn"]),
                       EmployerAccountId = row.ContainsKey("EmployerAccountId") ? row["EmployerAccountId"] : null,
                       Event = row["Event"],
                       ProviderId = row["ProviderId"]
                   });

            _createLevyContractPageObject.AddDasLevyEventDataToRepository(agreementEvents);
        }

        [When(@"the DAS Levy INITIATED events in '(.*)' are processed into CRM")]
        public void WhenTheDASLevyINITIATEDEventsInAreProcessedIntoCRM(string path)
        {
            _createLevyContractPageObject.AddDasLevyEventDataToRepositoryFromPath(path);
            WhenTheLevyEventDataIsPulledFromTheDASAgreementStub();
        }

        [Given(@"Levy event data from '(.*)' is added to the DAS agreement stub")]
        public void GivenLevyEventDataFromIsAddedToTheDASAgreementStub(string path)
        {
            _createLevyContractPageObject.AddDasLevyEventDataToRepositoryFromPath(path);
        }

        [When(@"the Levy event data is pulled from the DAS agreement stub")]
        public void WhenTheLevyEventDataIsPulledFromTheDASAgreementStub()
        {
            _createLevyContractPageObject.SendInitiateDasPullAndRetryNotFoundCommands();
        }

        [When(@"there is only one Levy contract in CRM for UKPRN '(.*)' with a status of '(.*)'")]
        [Then(@"there is only one Levy contract in CRM for UKPRN '(.*)' with a status of '(.*)'")]
        public void WhenThereIsOnlyOneLevyContractInCRMForUKPRNWithAStatusOf(string ukprn, string status)
        {
            // we now poll until the contract is in CRM and store on the pageObject for future steps
            bool hasContractBeenCreated = _createLevyContractPageObject.PopulateCreatedLevyContract(ukprn, status);

            ClassicAssert.IsTrue(hasContractBeenCreated, "The contract has not been created");
        }

        [Then(@"there is unprocessed PIMS-related event data in the Engagement Events table for '(.*)' UKPRNs prefixed '(.*)' and wait a maximum of '(.*)' minutes")]
        public void ThenThereIsUnprocessedPIMS_RelatedEventDataInPaaSForUKPRNsPrefixed(int expectedNumberOfRecords, int ukprnPrefix, int maxMinsToWait)
        {
            int providerNotFoundEventsCount =
                _createLevyContractPageObject.GetProviderNotFoundEventsWithUkprnPrefix(ukprnPrefix, expectedNumberOfRecords, maxMinsToWait);

            ClassicAssert.AreEqual(expectedNumberOfRecords, providerNotFoundEventsCount,
                $"The wrong number of 'provider not found' events were found. Expected {expectedNumberOfRecords} Found {providerNotFoundEventsCount}");
        }

        [When(@"the next action performed by manager '(.*)' on the latest version of contract '(.*)' is to '(.*)' specifying the reason as '(.*)'")]
        public void WhenTheNextActionPerformedByManagerOnTheLatestVersionOfContractIsToSpecifyingTheReasonAs(string userDisplayName, TransformedString contractNumber, string action, string reason)
        {
            _paymentManagementPageObject.CaseloadAdvisor = "FCS2 Test";
            _paymentManagementPageObject.ChangeContractState(contractNumber.Value, action, reason, userDisplayName);
        }

        [Then(@"the INITIATED event for UKPRN '(.*)' shows the contract has been processed into CRM")]
        public void ThenTheEventForUKPRNHasItsProcessedStateSetToInCRM(int ukprn)
        {
            bool isEventNowInCrm =
                _createLevyContractPageObject.TryToConfirmEngagementEventForProviderInCrm(ukprn.ToString());
            ClassicAssert.IsTrue(isEventNowInCrm, $"The engagement event for provider {ukprn} is not in CRM");
        }

        [Given(@"there is no DAS Levy contract data in PaaS or CRM for any UKPRNs prefixed '(.*)'")]
        public void GivenThereIsNoDASLevyContractDataInPaaSOrCRMForAnyUKPRNsPrefixed(int ukprnPrefix)
        {
            _paymentManagementPageObject.DeleteContractsByUkprnPrefix(ukprnPrefix);
        }

        [Then(@"there is unprocessed PIMS-related event data in the Engagement Events table for UKPRN '(.*)'")]
        public void ThenThereIsUnprocessedPIMS_RelatedEventDataInPaaSForUKPRN(int ukprn)
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult:
                () => _createLevyContractPageObject.IsProviderNotFoundEventPresentForUkprn(ukprn),
            maxNumChecks: 20,
            waitIntervalSeconds: 3);

            bool isProviderNotFoundEventPresent = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.AreEqual(true, isProviderNotFoundEventPresent, $"There should be an Engagement Event with a state of Provider Not Found for UKPRN: {ukprn}");
            
        }        

        [Then(@"there are no contracts in CRM for UKPRN '(.*)'")]
        public void ThenThereAreNoContractsInCRMForUKPRN(int ukprn)
        {
            int numContractsForUkrpn = _createLevyContractPageObject.GetCountOfChildContractsForUkprnInCrm(ukprn.ToString());
            ClassicAssert.AreEqual(0, numContractsForUkrpn,  $"There are contracts in CRM for provider: {ukprn}");
        }

        [Then(@"there is one contract in CRM for UKPRN '(.*)'")]
        public void ThenThereIsOneContractInCRMForUKPRN(int ukprn)
        {
            int numContractsForUkrpn = 0;
            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                numContractsForUkrpn = _createLevyContractPageObject.GetCountOfChildContractsForUkprnInCrm(ukprn.ToString());

                return numContractsForUkrpn == 1;
            },
            maxNumChecks: 20,
            waitIntervalSeconds: 3);

            checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();
            
            ClassicAssert.AreEqual(1, numContractsForUkrpn, $"There should only be one contract in CRM for UKPRN: {ukprn}");
        }

        [Then(@"there is no unprocessed PIMS-related event data in the Engagement Events table for UKPRN '(.*)'")]
        public void ThenThereIsNoUnprocessedPIMS_RelatedEventDataInPaaSForUKPRN(int ukprn)
        {
            int numProviderNotFoundEngagementEventsForUkrpn = 0;
            
            CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
            {
                numProviderNotFoundEngagementEventsForUkrpn = _createLevyContractPageObject.GetCountOfProviderNotFoundEngagementEventsInPaaS(ukprn.ToString());

                return numProviderNotFoundEngagementEventsForUkrpn == 0;
            },
            maxNumChecks: 20,
            waitIntervalSeconds: 3);

            checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.AreEqual(0, numProviderNotFoundEngagementEventsForUkrpn, $"There should not be be any ProviderNotFound Engagement Events for UKPRN: {ukprn}");
        }

        [Given(@"the Organisation stub contains a NOTFOUND entry for UKPRN '(.*)'")]
        [Given(@"there is no data in the Organisation stub for UKPRN '(.*)'")]
        public void GivenThereIsNoDataInTheOrganisationStubForUKPRN(int ukprn)
        {
            // we need to remove this ukprn from the Organisations table
            _createLevyContractPageObject.RemoveOrgForUkprnFromOrgCache(ukprn);

            // we need to add a new row to the gateway stub with this ukprn and a status of NOTFOUND
            GatewayServiceStubRepository.RemoveByUkprn(ukprn);
            GatewayServiceStubRepository.Add(ukprn, OrganisationNotFoundStatus);
        }

        [Given(@"the following data is in the Organisation stub")]
        public void GivenTheFollowingDataIsInTheOrganisationStub(Table table)
        {
            IList<string> cpdsCachedStatuses = new List<string>
            {
                "Inactive",
                "Dissolved",
                "Deleted",
                "InLiquidation"
            };

            // by removing the data from the stub we will allow an active 'NACRO' org to be returned
            foreach (var row in table.Rows)
            {
                int ukprn = int.Parse(row["UKPRN"]);
                string status = row["OrganisationStatus"].Trim().Replace(" ", string.Empty);

                if (cpdsCachedStatuses.Contains(status))
                {
                    _createLevyContractPageObject.AddOrgToOrgCacheTable(ukprn, status);
                }
                else
                {
                    GatewayServiceStubRepository.RemoveByUkprn(ukprn);
                    GatewayServiceStubRepository.Add(ukprn, status);
                }
            }
        }

        [Given(@"Remove and Recreate Sharepoint Document Library '(.*)'")]
        public void GivenRemoveAndRecreateSharepointFolder(string documentLibrary)
        {
            _createLevyContractPageObject.DeleteAndReCreateOffice365Folder(documentLibrary);
        }

        [Given(@"there are no ItemType '(.*)' events in the ContractManagement\.AtomFeedItem table with a BusinessKey prefixed '(.*)'")]
        public void GivenThereAreNoItemTypeEventsInTheContractManagement_AtomFeedItemTableWithAPrefixedBusinessKey(int itemType, string businessKeyPrefix)
        {
            _createLevyContractPageObject.RemoveEventsFrom_ContractManagement_AtomFeedItem_ByItemTypeAndPrefixedBusinessKey(itemType, businessKeyPrefix);
        }

        [Then(@"the ContractManagement\.AtomFeedItem table contains '(.*)' ItemType '(.*)' events with a BusinessKey prefixed '(.*)'")]
        public void ThenTheContractManagement_AtomFeedItemTableContainsItemTypeEventsWithAPrefixedBusinessKey(int expectedRowCount, int itemType, string businessKey)
        {
            int rowCount = _createLevyContractPageObject.GetNumberOfRowsFromAtomFeedItemForGivenItemTypeAndPrefixedBusinessKey(expectedRowCount, itemType, businessKey);
            ClassicAssert.AreEqual(expectedRowCount, rowCount , $"The number of AtomFeedItems returned {rowCount} doesn't match the expected rowcount of {expectedRowCount}");
        }

        [Then(@"there are '(.*)' draft Levy contracts in CRM for UKPRNs prefixed '(.*)' and wait a maximum of '(.*)' minutes")]
        public void ThenThereAreDraftLevyContractsInCRMForUKPRNsPrefixed(int expectedContractCount, string ukprnPrefix, int maximumNumberOfMinutesToWait)
        {
            int actualContractCount = _createLevyContractPageObject.GetNumberOfContractsWithGivenUkprnPrefix(expectedContractCount, ukprnPrefix, maximumNumberOfMinutesToWait);
            ClassicAssert.AreEqual(expectedContractCount, actualContractCount, $"The number of Contracts with the given UKPRN prefix of {ukprnPrefix} is {actualContractCount}. This does not match the expected number of {expectedContractCount}");
        }

        [Given(@"there is no Levy event data in the Engagement Events table for providers prefixed '(.*)'")]
        public void GivenThereIsNoLevyEventDataInTheEngagementEventsTableForProvidersPrefixed(int ukprnPrefix)
        {
            _createLevyContractPageObject.RemoveEventsFromEngagementEventsTableForAGivenAUkPrnPrefix(ukprnPrefix.ToString());
        }

        [Given(@"there is active Organisation data for '(.*)' consecutive UKPRNs commencing at '(.*)'")]
        public void GivenThereIsActiveOrganisationDataForConsecutiveUKPRNsCommencingAt(int numUkprns, int initialUkprn)
        {
            for (int i = 0; i < numUkprns; i++)
            {
                int thisUkprn = initialUkprn + i;

                GatewayServiceStubRepository.RemoveByUkprn(thisUkprn);
                _createLevyContractPageObject.AddOrgToOrgCacheTable(thisUkprn, "Active");
            }
        }

        [Given(@"there is no Organisation data in the Organisation Service for '(.*)' consecutive UKPRNs commencing at '(.*)'")]
        public void GivenThereIsNoOrganisationDataInTheOrganisationServiceForConsecutiveUKPRNsCommencingAt(int numUkprns, int initialUkprn)
        {
            for (int i = 0; i < numUkprns; i++)
            {
                int ukprn = initialUkprn + i;
                _createLevyContractPageObject.RemoveOrgForUkprnFromOrgCache(ukprn);
                GatewayServiceStubRepository.RemoveByUkprn(ukprn);
                GatewayServiceStubRepository.Add(ukprn, OrganisationNotFoundStatus);
            }
        }

        [Given(@"there is no contract data in CRM for any UKPRNs prefixed '(.*)'")]
        public void GivenThereIsNoContractDataInCRMForAnyUKPRNsPrefixed(int ukprnPrefix)
        {
            _createLevyContractPageObject.DeleteContractWithPartialUkrn(ukprnPrefix.ToString(), sfa_contracthierarchytype.Contract);
            _createLevyContractPageObject.DeleteContractWithPartialUkrn(ukprnPrefix.ToString(), sfa_contracthierarchytype.Master);
        }

        [Then(@"the following data is present in the MonitoringDeliverables\.PaymentInstructionAudit table for UKPRN '(.*)'")]
        public void ThenTheFollowingDataIsPresentInTheMonitoringDeliverables_PaymentInstructionAuditTableForUKPRN(string ukPrn, TransformedTable table)
        {
            var specFlowPaymentInstructionAudits = TransformTableToPaymentInstructionAuditRows(table.Value).ToList();

            var paasPaymentInstructionAudits = _createLevyContractPageObject.GetPaymentInstructionAuditRecordsFromPaas(
                ukPrn, table.RowCount);

            ClassicAssert.AreEqual(table.RowCount, paasPaymentInstructionAudits.Count, $"Incorrect number of PAAS PaymentInstructionAudit records returned. Expected {table.RowCount} Found {paasPaymentInstructionAudits.Count}");

            foreach (var specFlowTableRow in specFlowPaymentInstructionAudits)
            {
                var paasRecord =
                    paasPaymentInstructionAudits.SingleOrDefault(
                        row => row.ContractAllocationNumber == specFlowTableRow.ContractAllocationNumber
                               && row.Period == specFlowTableRow.Period
                               && row.CollectionReturnPeriod == specFlowTableRow.CollectionReturnPeriod
                               && row.DeliverableCode == specFlowTableRow.DeliverableCode
                               && row.FundingStreamPeriodCode == specFlowTableRow.FundingStreamPeriodCode
                               && row.OrganisationId == specFlowTableRow.OrganisationId);
                ClassicAssert.IsNotNull(paasRecord, $"Unable to find record in paas PaymentInstructionAudit with ContractAllocationNumber {specFlowTableRow.ContractAllocationNumber} Period {specFlowTableRow.Period} CollectionReturnPeriod {specFlowTableRow.CollectionReturnPeriod} DeliverableCode {specFlowTableRow.DeliverableCode} FundingStreamPeriodCode {specFlowTableRow.FundingStreamPeriodCode} OrganisationId {specFlowTableRow.OrganisationId}");
                ClassicAssert.AreEqual(specFlowTableRow.Ukprn, paasRecord.Ukprn, $"Ukprn {specFlowTableRow.Ukprn} not found");
                ClassicAssert.AreEqual(specFlowTableRow.ContractNumber, paasRecord.ContractNumber,  $"Contract Number {specFlowTableRow.ContractNumber} not found");
                ClassicAssert.AreEqual(specFlowTableRow.ContractVersion, paasRecord.ContractVersion,  $"Contract SubVersion {specFlowTableRow.ContractSubVersion} not found");
                ClassicAssert.AreEqual(specFlowTableRow.AllocationStartDate.Date, paasRecord.AllocationStartDate.Date,  $"Allocation Start Date {specFlowTableRow.AllocationStartDate} not found");
                ClassicAssert.AreEqual(specFlowTableRow.CollectionReturnCode, paasRecord.CollectionReturnCode,  $"Collection Return Code {specFlowTableRow.CollectionReturnCode} not found");
                ClassicAssert.AreEqual(specFlowTableRow.CollectionType, paasRecord.CollectionType,  $"Collection Type {specFlowTableRow.CollectionType} not found");
                ClassicAssert.AreEqual(specFlowTableRow.PaymentValue, paasRecord.PaymentValue,  $"PaymentValue {specFlowTableRow.PaymentValue} not found");
            }

        }

        [Then(@"the following allocation values are present in CRM")]
        public void ThenTheFollowingAllocationValuesArePresentInCRM(TransformedTable table)
        {
            table.Rows
                .ForEach(r =>
                {
                    string contractNumber = r["ContractNumber"];
                    int versionNumber = int.Parse(r["ContractVersionNumber"]);
                    string allocationRef = r["AllocationRef"];
                    DateTime startDate = ParseDate(r["AllocationStartDate"]);
                    DateTime? endDate = r["AllocationEndDate"] == "?" ? (DateTime?)null : ParseDate(r["AllocationEndDate"]);
                    StringParseResult deliveryOrgUkprn = r.GetStringParseResult("DeliveryOrganisationUKPRN");
                    StringParseResult deliveryOrgProviderUkprn = r.GetStringParseResult("DeliveryOrganisationProvider");

                    CheckResultPoller poller = new CheckResultPoller(
                        checkResult: () =>
                        {
                            AllocationDto alloc = CrmContractAllocationRepository.GetAllocationByAllocationNumberContractNumberAndContractVersion(allocationRef, contractNumber, versionNumber);
                            return alloc != null
                                && alloc.StartDate == startDate
                                && alloc.EndDate == endDate
                                && alloc.DeliveryOrgUkprn == deliveryOrgUkprn.ValueToCheck(defaultValue: alloc.DeliveryOrgUkprn) 
                                && alloc.DeliveryOrgProviderUkprn == deliveryOrgProviderUkprn.ValueToCheck(defaultValue: alloc.DeliveryOrgProviderUkprn);
                        },
                        maxNumChecks: 20,
                        waitIntervalSeconds: 3);

                    ClassicAssert.IsTrue(poller.CheckResultAndWaitTillCompleteOrOutOfTime(), $"Allocation {allocationRef} with start date {startDate.ToShortDateString()} was not found in CRM");
                });
        }
        
        [Given(@"there is no data in the MonitoringDeliverables\.PaymentInstructionAudit table for UKPRN '(.*)'")]
        public void GivenThereIsNoDataInTheMonitoringDeliverables_PaymentInstructionAuditTableForUKPRN(int ukprn)
        {
            _createLevyContractPageObject.RemovePaymentInstructionAuditRowsForUkprn(ukprn);
        }

        [Then(@"the RoATP Anomalies report includes the following")]
        public void ThenTheAnomaliesReportWillContainAnEntryAsFollows(TransformedTable table)
        {
            IReadOnlyCollection<LevyReportRow> report = OperationsApiClientService.GetLevyContractsThatCannotBeAmended().Result;

            var missingRows = table.Rows.Select(r => new LevyReportRow(
                    r["Contract"],
                    r["MasterContract"],
                    int.Parse(r["Version"]),
                    int.Parse(r["SubVersion"]),
                    r["Ukprn"],
                    r["Status"],
                    r["Substatus"]))
                .Where(r => !report.Contains(r))
                .Select(r => r.ToString())
                .ToList();

            ClassicAssert.AreEqual(0, missingRows.Count, $"Report did not contain the following rows: {Environment.NewLine}{string.Join(Environment.NewLine, missingRows)}");
        }

        [Then(@"the RoATP Anomalies report does not contain a record for provider '(.*)'")]
        public void ThenTheAnomaliesReportDoesNotContainARecordForProvider(string ukprn)
        {
            bool reportContainsRowForUkprn =
                OperationsApiClientService.GetLevyContractsThatCannotBeAmended().Result
                    .Any(r => r.Ukprn == ukprn);

            ClassicAssert.IsFalse(reportContainsRowForUkprn, $"Report contained unexpected data for provider with UKPRN {ukprn}");
        }

        [Given(@"the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY(.*) contract allocation")]
        public void GivenTheFollowingEventDataInTheDASAgreementStubIsUsedToCreateALevyContractWithJustALEVYContractAllocation(int period, Table table)
        {
            var ukrpns = table.Rows
                .Where(r => r["Event"] == "INITIATED")
                .Select(r => r.ParseInt("ProviderId"))
                .ToList();

            string testNumber = GetTestNumber();

            ukrpns.ForEach(ukrpn =>
            {
                var extendedContract = ExtendedContractFactory.GetLevyExtendedContract(
                    $"ESFA-{testNumber}",
                    $"APPLEVY-{testNumber}",
                    $"LEVY-{testNumber}",
                    ukrpn);


                _paymentManagementPageObject.CreateContractInCrm(extendedContract);
            });
        }

        private string GetTestNumber()
        {
            var name = TestContext.CurrentContext.Test.Name;

            var nameChars = name.ToCharArray();
            string testNumber = string.Empty;
            foreach (var c in nameChars.Skip(1))
            {
                int number = 0;
                if (int.TryParse(c.ToString(), out number))
                {
                    testNumber += number.ToString();
                }
                else
                {
                    break;
                }
            }

            return testNumber;
        }

        private static void AssertAreEqualIfPresent(bool isExpectedValuePresent, object expected, object actual, string message)
        {
            if (isExpectedValuePresent)
            {
                ClassicAssert.AreEqual(expected, actual, message);
            }
        }

        private IEnumerable<PaymentInstructionAudit> TransformTableToPaymentInstructionAuditRows(Table table)
        {
            var paymentInstructionAuditRows = new List<PaymentInstructionAudit>();

            table.Rows.ForEach(row => paymentInstructionAuditRows.Add(new PaymentInstructionAudit(
                int.Parse(row["CollectionReturnPeriod"]),
                row["OrganisationId"],
                row["FundingStreamPeriodCode"],
                int.Parse(row["DeliverableCode"]),
                row["Period"],
                row["UKPRN"],
                row["ContractNumber"],
                int.Parse(row["ContractVersion"]),
                int.Parse(row["ContractSubVersion"]),
                DateTime.ParseExact(row["AllocationStartDate"], "dd/MM/yyyy", CultureInfo.CurrentCulture),
                row["CollectionReturnCode"],
                row["CollectionType"],
                decimal.Parse(row["PaymentValue"]),
                row["ContractAllocation Number"])
                ));

            return paymentInstructionAuditRows;
        }

        private static IList<ContractDeliverablePeriodInfo> TransformDeliverablesTableToContractDeliverablePeriodInfos(Table table)
        {
            List<ContractDeliverablePeriodInfo> deliverablePeriods = new List<ContractDeliverablePeriodInfo>();
            int[] years = { 2017, 2018, 2019, 2020 };
            int[] months = Enumerable.Range(1, 12).ToArray();

            foreach (TableRow row in table.Rows)
            {
                foreach (int year in years)
                {
                    foreach (int month in months)
                    {
                        DateTime period = new DateTime(year, month, 1);
                        string columnHeading = $"{period.ToString("MMM")}-{period.ToString("yy")}";
                        if (row.ContainsKey(columnHeading))
                        {
                            deliverablePeriods.Add(new ContractDeliverablePeriodInfo
                            {
                                DeliverableCode = int.Parse(row["DeliverableCode"]),
                                DeliverableDescription = row["DeliverableDescription"],
                                ParentDeliverableCode = int.Parse(row["ParentDeliverableCode"]) != 0 ? int.Parse(row["ParentDeliverableCode"]) : (int?)null,
                                DeliverablePlannedValue = row["Total"] != "?" ? decimal.Parse(row["Total"]) : (decimal?)null,
                                Month = month,
                                Year = year,
                                PlannedValue = row[columnHeading] != "?" ? decimal.Parse(row[columnHeading]) : (decimal?)null,
                                FundingStreamCode = row["FundingStreamCode"]
                            });
                        }
                    }
                }
            }

            return deliverablePeriods;
        }

        private static List<ContractRequest.contractDeliverablePeriodType> ExtractDeliverablePeriodsFromTableRow(TableRow row)
        {
            int[] years = { 2017, 2018 };
            int[] months = Enumerable.Range(1, 12).ToArray();

            List<ContractRequest.contractDeliverablePeriodType> deliverablePeriods = new List<ContractRequest.contractDeliverablePeriodType>();

            foreach (int year in years)
            {
                foreach (int month in months)
                {
                    DateTime period = new DateTime(year, month, 1);
                    string columnHeading = $"{period.ToString("MMM")}-{period.ToString("yy")}";
                    if (row.ContainsKey(columnHeading))
                    {
                        deliverablePeriods.Add(new ContractRequest.contractDeliverablePeriodType
                        {
                            correlationId = Guid.NewGuid().ToString("D"),
                            year = year,
                            period = month,
                            plannedValue = decimal.Parse(row[columnHeading])
                        });
                    }
                }
            }

            return deliverablePeriods;
        }

        private void AddDasRequestToCreateALevyContractBasedOnTheFollowing(Table table, Func<int, long> addEngagementEventToPaasForUkprn)
        {
            TableRow row = table.Rows.Single();
            const string contractEndDateColumnName = "ContractEndDate";
            if (row.ContainsKey(contractEndDateColumnName))
            {
                ClassicAssert.AreEqual("?", row[contractEndDateColumnName], "The Contract End Date must not be set for DAS");
            }

            ContractRequest.DasRequest dasRequest = new ContractRequest.DasRequest
            {
                Ukprn = int.Parse(row["UKPRN"]),
                FundingType = row["FundingType"],
                StartDate = ParseDate(row["ContractStartDate"])
            };

            dasRequest.DasEngagementEventId = addEngagementEventToPaasForUkprn(dasRequest.Ukprn);

            MessageSendingBus.Send("ContractRequestDomain.BulkUpload", new NewDasContractRequestCommand
            {
                DasRequest = dasRequest,
                DasEngagementEventId = dasRequest.DasEngagementEventId
            });

            bool hasContractBeenCreated = _createLevyContractPageObject.PopulateCreatedContract(dasRequest.Ukprn.ToString());

            ClassicAssert.IsTrue(hasContractBeenCreated, "The contract has not been created");
        }

        private static DateTime ParseDate(string date)
        {
            return DateTime.SpecifyKind(DateTime.ParseExact(date, "dd/MM/yyyy", CultureInfo.InvariantCulture), DateTimeKind.Utc);
        }

        private static CheckValuesResult CheckValuesReturnedFromCrm(TableRow row, List<SubnominalAggregation> subnominalAggregations, string subnominalType)
        {
            string error = string.Empty;

            foreach (PeriodValue periodValue in row.GetPeriodValues().Where(pv => pv.Value.HasValue))
            {
                SubnominalAggregation matchingSubnominalAggregation = subnominalAggregations.SingleOrDefault(sa => sa.Period == periodValue.Period);
                if (matchingSubnominalAggregation == null)
                {
                    error = $"No matching subnominal aggregation found for subnominal code  {row[$"{subnominalType}Subnominal"]}, period: {periodValue.Period}";
                }
                else if (periodValue.Value != matchingSubnominalAggregation.AggregatedValue)
                {
                    error = $"The value in crm {matchingSubnominalAggregation.AggregatedValue} is not what we expected {periodValue.Period} - {row[$"{subnominalType}Subnominal"]}, period: {periodValue.Period}";
                }

                if (error != string.Empty)
                {
                    break;
                }
            }

            return new CheckValuesResult(error == string.Empty, error);
        }

        private static CheckValuesResult CheckValuesReturnedFromCrm(TableRow row, IEnumerable<ContractDeliverablePeriodInfo> contractDeliverablePeriodInfos, Func<ContractDeliverablePeriodInfo, decimal?> getValueToCheck)
        {
            string error = string.Empty;
            const string deliverableCodeColumnName = "DeliverableCode";
            foreach (var header in row.Keys)
            {
                DateTime dt;
                if (DateTime.TryParse("01-" + header, out dt))
                {
                    var matchingContractDeliverablePeriod = contractDeliverablePeriodInfos.SingleOrDefault(cdp => cdp.Month == dt.Month && cdp.Year == dt.Year && cdp.DeliverableCode == int.Parse(row[deliverableCodeColumnName]));
                    if (matchingContractDeliverablePeriod == null)
                    {
                        error = $"No matching contract deliverable period found for period: {header} deliverable code: {row[deliverableCodeColumnName]}";
                    }
                    else if (GetDecimalValueFromTableRow(row[header]).GetValueOrDefault(0) != getValueToCheck(matchingContractDeliverablePeriod).GetValueOrDefault(0))
                    {
                        error = $"The value in crm {getValueToCheck(matchingContractDeliverablePeriod)} is not what we expected {row[header]} - period: {header} deliverable code: {row[deliverableCodeColumnName]}";
                    }

                    if (error != String.Empty)
                    {
                        break;
                    }
                }
            }

            return new CheckValuesResult(error == string.Empty, error);
        }

        private void CheckCrmPaymentValues(Table cdpStepTable, Func<ContractDeliverablePeriodInfo, decimal?> getPaymentValue)
        {
            var balancingPaymentsFirstTableRow = cdpStepTable.Rows.First();
            IEnumerable<DateInfo> dateInfos = GetDateInfosFromTableRow(balancingPaymentsFirstTableRow);

            int expectedNumberOfCdpItems = cdpStepTable.Rows.Count * dateInfos.Count();

            List<int> deliverableCodesToTest = cdpStepTable.Rows.Select(r => int.Parse(r["DeliverableCode"])).ToList();

            IList<ContractDeliverablePeriodInfo> contractDeliverablePeriodInfos = new List<ContractDeliverablePeriodInfo>();

            CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: () =>
                {
                    contractDeliverablePeriodInfos = _createLevyContractPageObject.GetContractDeliverablePeriodInfos(_createLevyContractPageObject.CreatedContractNumber);

                    // exclude CDPs we are not interested in
                    contractDeliverablePeriodInfos =
                        contractDeliverablePeriodInfos.Where(cdp => deliverableCodesToTest.Contains(cdp.DeliverableCode)
                        && dateInfos.Any(d => d.Month == cdp.Month && d.Year == cdp.Year))
                            .ToList();

                    return (contractDeliverablePeriodInfos.Count == expectedNumberOfCdpItems) && 
                           cdpStepTable.Rows.Select(r => CheckValuesReturnedFromCrm(r, contractDeliverablePeriodInfos, getPaymentValue)).All(res => res.AreAllValuesPresent);
                },
                maxNumChecks: 20,
                waitIntervalSeconds: 3
                );


            checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.AreEqual(expectedNumberOfCdpItems, contractDeliverablePeriodInfos.Count, $"We have not found the correct number of row in contract deliverable periods contract: {_createLevyContractPageObject.CreatedContractNumber}");

            foreach (TableRow balancingPaymentRow in cdpStepTable.Rows)
            {
                CheckValuesResult checkValuesResult = CheckValuesReturnedFromCrm(balancingPaymentRow, contractDeliverablePeriodInfos,
                    getPaymentValue);

                if (!checkValuesResult.AreAllValuesPresent)
                {
                    ClassicAssert.Fail($"we have not got the right values from CRM for contract {_createLevyContractPageObject.CreatedContractNumber} - {checkValuesResult.ErrorMsg}");
                }
            }
        }

        private IReadOnlyCollection<DateInfo> GetDateInfosFromTableRow(TableRow row)
        {
            List<DateInfo> dateInfos = new List<DateInfo>();
            foreach (var key in row.Keys)
            {
                DateTime dt;
                if (DateTime.TryParse("01-" + key, out dt))
                {
                    dateInfos.Add(new DateInfo(dt));
                }
            }

            return dateInfos;
        }

        private static decimal? GetDecimalValueFromTableRow(string rowValue)
        {
            const string nullCharacter = "?";
            if (rowValue != nullCharacter)
            {
                return decimal.Parse(rowValue);
            }

            return null;
        }

        private class CheckValuesResult
        {
            public CheckValuesResult(bool areAllValuesPresent, string errorMsg)
            {
                AreAllValuesPresent = areAllValuesPresent;
                ErrorMsg = errorMsg;
            }

            public bool AreAllValuesPresent { get; }

            public string ErrorMsg { get; }
        }

        private class DateInfo
        {
            public DateInfo(DateTime date)
            {
                Month = date.Month;
                Year = date.Year;
            }

            public int Month { get; }

            public int Year { get; }
        }
    }
}
