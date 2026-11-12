namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Diagnostics;
    using System.Linq;
    using System.ServiceModel.Syndication;
    using ContractManagement.DataStore.Model;
    using ContractManagementService.Common;
    using CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Extensions;
    using Infrastructure.Repositories;
    using Infrastructure.Repositories.CrmReplicaRepo;
    using Infrastructure.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using Pages;
    using TechTalk.SpecFlow;
    using Utilities;
    using sfa_contract = CrossDomain.Integration.Entities.Xrm.sfa_contract;
    using NUnit.Framework.Legacy;

    [Binding]
    public class ContractManagementSteps
    {
        private readonly ContractManagementPageObject _contractManagementPageObject;
        private readonly string _businessKey = string.Empty;

        public ContractManagementSteps(ContractManagementPageObject contractManagementPageObject)
        {
            _contractManagementPageObject = contractManagementPageObject;
        }

        [Given(@"the following providers exist on RoATP")]
        public void GivenTheFollowingProvidersExistOnRoatp(TransformedTable table)
        {
            RoatpProviderRepository.AddRange(table.Rows.Select(r => r["Ukprn"]).ToList());
        }

        [Given(@"there is no data on RoATP for the following providers")]
        public void GivenThereIsNoDataOnRoatpForTheFollowingProviders(Table table)
        {
            RoatpProviderRepository.RemoveRange(table.Rows.Select(r => r["Ukprn"]).ToList());
        }

        [Given(@"the status and substatus of version '(.*)' of contract '(.*)' are set to '(.*)' and '(.*)' respectively")]
        public void GivenTheStatusAndSubstatusOfVersionOfContractAreSetToAndRespectively(int versionNumber, TransformedString contractNumber, string status, string subStatus)
        {
            CrmContractRepository.SetContractStatusAndSubStatus(contractNumber.Value, versionNumber, status, subStatus);
        }

        [Given(@"the contract sub-status is updated to '(.*)' on the latest version of contract '(.*)'")]
        [Given(@"the contract sub-status is updated to '(.*)' for contract '(.*)'")]
        public void GivenTheContractSub_StatusIsUpdatedToForContract(string subStatus, TransformedString contractNumber)
        {
            _contractManagementPageObject.UpdateContractSubStatus(contractNumber, subStatus);
        }

        [Given(@"the latest version of contract '(.*)' and master '(.*)' is published and on the \[ContractManagement]\.\[AtomFeedItem] table")]
        public void GivenTheLatestVersionOfContractAndMasterIsPublishedAndOnTheContractManagement_AtomFeedItemTable(TransformedString contractNumber, TransformedString masterContractNumber)
        {
            ContractPublisher.PublishLatestContractAndWaitForAtomItemToBePresent(contractNumber, masterContractNumber);
        }

        [Then(@"the contract sub-status is updated to '(.*)' for contract '(.*)'")]
        public void ThenTheContractSub_StatusIsUpdatedToForContract(string subStatus, string contractNumber)
        {
            _contractManagementPageObject.UpdateContractSubStatus(contractNumber, subStatus);
        }

        [Given(@"the contract task owner is updated to '(.*)' for contract '(.*)'")]
        public void GivenTheContractTaskOwnerIsUpdatedToForContract(string ownerDisplayName, string contractNumber)
        {
            _contractManagementPageObject.UpdateContractTaskOwner(contractNumber, ownerDisplayName);
        }

        [Given(@"approval is initiated for contract with master contract number '(.*)' and contract number '(.*)' and version number '(.*)'")]
        [When(@"approval is initiated for contract with master contract number '(.*)' and contract number '(.*)' and version number '(.*)'")]
        [Then(@"approval is initiated for contract with master contract number '(.*)' and contract number '(.*)' and version number '(.*)'")]
        public void ThenApprovalIsInitiatedForContractWithMasterContractNumberAndContractNumberAndVersionNumber(string masterContractNumber, string contractNumber, int versionNumber)
        {
            _contractManagementPageObject.ClearMonthEndHistory();
            if (Debugger.IsAttached)
            {
                _contractManagementPageObject.ApproveContractViaBus(masterContractNumber, contractNumber, versionNumber);
            }
            else
            {
                _contractManagementPageObject.ApproveContractViaWebAPI(masterContractNumber, contractNumber, versionNumber);
            }
        }

        [When(@"'(.*)' approval is initiated for contract with master contract number '(.*)' and contract number '(.*)' and version number '(.*)'")]
        public void WhenApprovalIsInitiatedForContractWithMasterContractNumberAndContractNumber(string approvalRequestSource, string masterContractNumber, string contractNumber, int versionNumber)
        {
            _contractManagementPageObject.ClearMonthEndHistory();
            _contractManagementPageObject.ApproveContractViaBus(masterContractNumber, contractNumber, versionNumber, (ApprovalRequestSource)Enum.Parse(typeof(ApprovalRequestSource), approvalRequestSource));
        }

        [Then(@"the following workflow history entries are not present on the latest version of contract '(.*)'")]
        public void ThenTheFollowingWorkflowHistoryEntriesAreNotPresentOnTheLatestVersionOfContract(string contractNumber, Table table)
        {
            IReadOnlyCollection<string> contractActionNames = _contractManagementPageObject.GetWorkflowHistoryActionNamesForContract(contractNumber);

            foreach (TableRow row in table.Rows)
            {
                string expectedActionName = row["Action"];
                string actualActionName = contractActionNames.SingleOrDefault(s => s == expectedActionName);

                ClassicAssert.IsNull(actualActionName, $"Expected action: {expectedActionName} is present in CRM.");
            }
        }

        [When(@"a request is raised by advisor '(.*)' against version '(.*)' subversion '(.*)' of contract '(.*)' for a non-financial VARIATION contract amendment")]
        public void WhenARequestIsRaisedByAdvisorAgainstVersionSubversionOfContractForANonFinancialVariationContractAmendment(string advisorName, int contractVersion, int contractSubversion, TransformedString contractNumber)
        {
            Guid contractId = CrmContractRepository.GetContractId(contractNumber.Value, contractVersion, contractSubversion);
            Guid workflowId = CrmWorkflowRepository.GetWorkFlowId("WF32 Contract: Non Financial Vary Amendment");

            CrmWorkflowRepository.ExecuteWorkFlow(workflowId, contractId, advisorName);
        }

        [When(@"CRM user '(.*)' chooses to revert the state of version '(.*)' subversion '(.*)' of contract '(.*)' to Awaiting Documentation")]
        public void WhenCRMUserChoosesToRevertTheStateOfVersionSubversionOfContractToAwaitingDocumentation(string advisorName, int contractVersion, int contractSubversion, TransformedString contractNumber)
        {
            Guid contractId = CrmContractRepository.GetContractId(contractNumber.Value, contractVersion, contractSubversion);
            Guid workflowId = CrmWorkflowRepository.GetWorkFlowId("WF39: Initiate Bulk Amend for Contracts");

            CrmWorkflowRepository.ExecuteWorkFlow(workflowId, contractId, advisorName);
        }

        [Given(@"there are no Tasks in CRM for version '(.*)' of contract '(.*)' with a State of '(.*)' and a Status of '(.*)'")]
        public void GivenThereAreNoTasksInCRMForVersionOfContractWithAStateOfAndAStatusOf(int contractVersion, TransformedString contractNumber, string taskState, string taskStatus)
        {
            var tasks = CrmContractRepository.GetTasksForContract(contractNumber, contractVersion);
            IList<string> statesToCheck = new List<string>();
            statesToCheck.Add(taskState);
            if (taskState == "Cancelled")
            {
                statesToCheck.Add("Canceled");
            }
            IList<string> statusesToCheck = new List<string>();
            statusesToCheck.Add(taskStatus);
            if (taskStatus == "Cancelled")
            {
                statusesToCheck.Add("Canceled");
            }

            var taskWithRequiredStateAndStatus = tasks.Where(t => statesToCheck.Contains(t.State) && statusesToCheck.Contains(t.Status))
                .ToList();

            taskWithRequiredStateAndStatus.ForEach(t =>
            {
                CrmConnectionFactory.GetConnection().Delete(Task.EntityLogicalName, t.Id);
            });
        }

        [When(@"a request is raised by advisor '(.*)' against version '(.*)' subversion '(.*)' of contract '(.*)' for a non-financial NOTIFICATION contract amendment")]
        public void WhenARequestIsRaisedByAdvisorAgainstVersionSubversionOfContractForANonFinancialNotificationContractAmendment(string advisorName, int contractVersion, int contractSubversion, TransformedString contractNumber)
        {
            Guid contractId = CrmContractRepository.GetContractId(contractNumber.Value, contractVersion, contractSubversion);
            Guid workflowId = CrmWorkflowRepository.GetWorkFlowId("WF33 Contract: Non Financial Notify Amendment");

            CrmWorkflowRepository.ExecuteWorkFlow(workflowId, contractId, advisorName);
        }

        [Given(@"the CRM Amendment Creation in Progress indicator on version '(.*)' subversion '(.*)' of contract '(.*)' is set '(.*)'")]
        public void GivenTheCRMAmendmentCreationInProgressIndicatorOnVersionSubversionOfContractIsSet(int versionNumber, int subVersionNumber, string contractNumber, string amendmentProgressIndicator)
        {
            bool isAmendmentInProgress = bool.Parse(amendmentProgressIndicator.ToLower());

            CrmContractRepository.SetAmendmentInProgressIndicator(
                contractNumber,
                versionNumber,
                subVersionNumber,
                isAmendmentInProgress);
        }

        [Then(@"the value of the CRM Amendment Creation in Progress indicator on version '(.*)' subversion '(.*)' of contract '(.*)' is '(.*)'")]
        public void ThenTheValueOfTheCRMAmendmentCreationInProgressIndicatorOnVersionSubversionOfContractIs(int versionNumber, int subVersionNumber, string contractNumber, string amendmentProgressIndicator)
        {
            bool expectedAmendmentInProgressIndicator = bool.Parse(amendmentProgressIndicator.ToLower());

            bool isAmendmentInProgress = CrmContractRepository.IsAmendmentInProgressForContract(
                contractNumber,
                versionNumber,
                subVersionNumber);

            ClassicAssert.AreEqual(expectedAmendmentInProgressIndicator, isAmendmentInProgress, "Amendment in progress indicator was not as expected");
        }

        [Given(@"the following deliverables have been removed from all versions of the contract in CRM and PaaS")]
        public void GivenTheFollowingDeliverablesHaveBeenRemovedFromAllVersionsOfTheContractInCrmAndPaaS(TransformedTable table)
        {
            table.Rows.ForEach(row =>
            {
                string allocationNumber = row["AllocRef"];
                int deliverableCode = row.ParseInt("DeliverableCode");

                CrmContractDeliverableRepository.DeleteDeliverableForAllVersionsOfAllocation(allocationNumber, deliverableCode);

                CrmReplicatedRepository.DeleteDeliverableForAllVersionsOfAllocation(allocationNumber, deliverableCode);
                DeliverablePaymentRepository.DeleteDeliverablePaymentsForAllVersionsOfAllocation(allocationNumber, deliverableCode);

                AllocationDeliverablePeriodRepository.DeleteAllocationDeliverablePeriods(allocationNumber, deliverableCode);
            });
        }

        [Then(@"the Contract Management '(.*)' feed includes category '(.*)' event details as follows")]
        public void ThenTheContractManagementFeedIncludesCategoryEventDetailsAsFollows(string atomFeedFilter, string atomFeedItemCategory, TransformedTable table)
        {
            string urlSuffix = GetUrlSuffixForFeedType(atomFeedFilter);

            table.Rows.ForEach(row =>
            {
                CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
                {
                    IEnumerable<SyndicationItem> retrievedFeedItems = AtomFeedReader.EnumerateItems(
                        $"{TestConfiguration.Configuration["ContractManagement:ServiceUrl"]}/api/contracts/notifications/{urlSuffix}",
                        AzureAuthenticator.GetAuthenticationConfig(),
                        "application/vnd.sfa.contract.v1+atom+xml");

                    return retrievedFeedItems
                        .Where(feedItem => feedItem.Categories.Single().Name == atomFeedItemCategory)
                        .Any(feedItem =>
                        {
                            contractType contract = feedItem.GetContent<Contract>().contracts.Single();
                            contractAllocationsContractAllocation allocation =
                                contract.contractAllocations.SingleOrDefault(a => a.contractAllocationNumber == row["AllocationRef"]);

                            return
                                contract.contractNumber == row["ContractNumber"] &&
                                contract.contractVersionNumber == row.ParseInt("ContractVersion") &&
                                contract.contractSubVersionNumber == row.ParseInt("ContractSubVersion") &&
                                contract.contractor.ukprn == row.ParseInt("UKPRN") &&
                                contract.TerminationContractAttrs.terminationDate == row.ParseNullableDate("ContractTerminationDate") &&
                                contract.TerminationContractAttrs.ReasonForTermination.IsEquivalentWithFirstValueEqualityToNull(
                                    (ReasonForTerminationType?)row.ParseNullableEnum<ReasonForTerminationType>("ContractTerminationReason")) &&
                                allocation != null &&
                                allocation.allocationTerminationAttrs.stopNewStartsFromDate == row.ParseNullableDate("StopNewStartsFromDate") &&
                                allocation.allocationTerminationAttrs.newStartsSuspendedReason == row.ParseNullableString("NewStartsSuspendedReason");
                        });
                }, maxNumChecks: 10, waitIntervalSeconds: 3);

                bool foundExpectedItem = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsTrue(foundExpectedItem, $"Expected item not found on {atomFeedFilter} Contract Atom Feed item for Category: {atomFeedItemCategory}, Expected Values: {row.ToHeaderAndValueString()}");
            });
        }

        [Then(@"the Contract Management '(.*)' feed includes the following event information")]
        public void ThenTheContractManagementFeedIncludesTheFollowingEventInformation(string atomFeedFilter, TransformedTable table)
        {
            string urlSuffix = GetUrlSuffixForFeedType(atomFeedFilter);

            table.Rows.ForEach(row =>
            {
                CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
                {
                    IEnumerable<SyndicationItem> retrievedFeedItems = AtomFeedReader.EnumerateItems(
                        $"{TestConfiguration.Configuration["ContractManagement:ServiceUrl"]}/api/contracts/notifications/{urlSuffix}",
                        AzureAuthenticator.GetAuthenticationConfig(),
                        "application/vnd.sfa.contract.v1+atom+xml");

                    return retrievedFeedItems.Any(feedItem =>
                    {
                        contractType contentContract = feedItem.GetContent<Contract>().contracts.Single();

                        return
                            feedItem.Categories.Single().Name == row["CategoryTerm"] &&
                            feedItem.Categories.Single().Label == row["CategoryLabel"] &&
                            feedItem.Title.Text == row["Title"] &&
                            contentContract.contractNumber == row["ContractNumber"] &&
                            contentContract.contractVersionNumber == row.ParseInt("ContractVersion") &&
                            contentContract.contractSubVersionNumber == row.ParseInt("ContractSubVersion") &&
                            contentContract.contractor.ukprn == row.ParseInt("UKPRN");

                    });
                }, maxNumChecks: 10, waitIntervalSeconds: 3);

                bool foundExpectedItem = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsTrue(foundExpectedItem, $"Expected item not found on {atomFeedFilter} Contract Atom Feed item for {row.ToHeaderAndValueString()}");
            });
        }

        [Then(@"the ContractManagement\.AtomFeedItem table contains '(.*)' ItemType '(.*)' event for version '(.*)' of actual contract number '(.*)'")]
        [Then(@"the ContractManagement\.AtomFeedItem table contains '(.*)' ItemType '(.*)' events for version '(.*)' of actual contract number '(.*)'")]
        public void ThenTheContractManagement_AtomFeedItemTableContainsItemTypeEventsForVersionOfActualContractNumber(
            int numberOfItems, int atomItemType, int version, string contractNumber)
        {
            IReadOnlyCollection<AtomFeedItem> relevantAtomFeedItems;
            
            CheckResultPoller poller = new CheckResultPoller(
                checkResult: () =>
                {
                    relevantAtomFeedItems = ContractAtomFeedItemRepository.GetAtomFeedItemsByContractNumber(contractNumber)
                        .Where(item => item.GetVersionNumber() == version
                                       && (int)item.ItemType == atomItemType)
                        .ToList();

                    return numberOfItems == relevantAtomFeedItems.Count;
                },
                maxNumChecks: 10,
                waitIntervalSeconds: 3);

            ClassicAssert.IsTrue(poller.CheckResultAndWaitTillCompleteOrOutOfTime(),
                "Did not get the expected number of matching Atom Feed Items in time");
        }

        [Then(@"the latest ItemType '(.*)' event for version '(.*)' of actual contract number '(.*)' in the ContractManagement\.AtomFeedItem table conforms to the Corporate Contract Schema")]
        public void ThenTheLatestItemTypeEventForVersionOfActualContractNumberInTheContractManagement_AtomFeedItemTableConformsToTheCorporateContractSchema(
            int atomItemType, int version, string contractNumber)
        {
            AtomFeedItem latestFeedItem =
                ContractAtomFeedItemRepository.GetLatestFeedItemByContractNumberVersionNumberAndItemType(
                    contractNumber, version, (AtomItemType) atomItemType);

            ClassicAssert.IsTrue(XmlSchemaValidator.IsContractManagementAtomFeedItemValidXml(latestFeedItem.GetAtomFeedItemXml()),
                $"Latest atom item XML for contract {contractNumber} v{version} item type {atomItemType} did not conform to the corporate contract schema");
        }

        [Then(@"the latest '(.*)' event in the Contract Management '(.*)' feed is as follows")]
        public void ThenTheLatestEventInTheContractManagementFeedIsAsFollows(string eventType, string feed, TransformedTable table)
        {
            string urlSuffix = GetUrlSuffixForFeedType(feed);

            table.Rows.ForEach(row =>
            {
                SyndicationItem latestMatchingFeedItem = null;

                CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
                {
                    IEnumerable<SyndicationItem> retrievedFeedItems = AtomFeedReader.EnumerateItems(
                        $"{TestConfiguration.Configuration["ContractManagement:ServiceUrl"]}/api/contracts/notifications/{urlSuffix}",
                        AzureAuthenticator.GetAuthenticationConfig(),
                        "application/vnd.sfa.contract.v1+atom+xml");

                    latestMatchingFeedItem =  retrievedFeedItems
                        .Where(feedItem => feedItem.Categories.Single().Name == eventType)
                        .FirstOrDefault(feedItem =>
                        {
                            contractType contract = feedItem.GetContent<Contract>().contracts.Single();
                            contractAllocationsContractAllocation allocation =
                                contract.contractAllocations.SingleOrDefault(a => a.contractAllocationNumber == row["AllocationRef"]);

                            return
                                contract.contractNumber == row["ContractNumber"] &&
                                contract.contractVersionNumber == row.ParseInt("ContractVersion") &&
                                contract.contractSubVersionNumber == row.ParseInt("ContractSubVersion") &&
                                contract.contractor.ukprn == row.ParseInt("UKPRN") &&
                                contract.TerminationContractAttrs.terminationDate == row.ParseNullableDate("ContractTerminationDate") &&
                                contract.TerminationContractAttrs.ReasonForTermination.IsEquivalentWithFirstValueEqualityToNull(
                                    (ReasonForTerminationType?)row.ParseNullableEnum<ReasonForTerminationType>("ContractTerminationReason")) &&
                                allocation != null &&
                                allocation.allocationTerminationAttrs.stopNewStartsFromDate == row.ParseNullableDate("StopNewStartsFromDate");
                        });
                    return latestMatchingFeedItem != null;
                }, maxNumChecks: 10, waitIntervalSeconds: 3);

                bool foundExpectedItem = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsTrue(foundExpectedItem, $"Expected item not found on {feed} Contract Atom Feed item for Category: {eventType}, Expected Values: {row.ToHeaderAndValueString()}");
            });
        }

        [When(@"User '(.*)' chooses to issue CRM workflow '(.*)' for the following contracts")]
        public void WhenUserChoosesToIssueCRMWorkflowForTheFollowingContracts(string username, string workflowBeginsWith, TransformedTable table)
        {
            table.Rows.ForEach(row =>
            {
                string contractNumber = row["ContractNumber"];
                int contractVersionNumber = row.ParseInt("ContractVersionNumber");
                int contractSubVersion = row.ParseInt("ContractSubVersion");

                Guid contractId = CrmContractRepository.GetContractId(contractNumber, contractVersionNumber, contractSubVersion);
                Guid workflowId = CrmWorkflowRepository.GetWorkFlowIdFromBeginsWith(workflowBeginsWith);

                CrmWorkflowRepository.ExecuteWorkFlow(workflowId, contractId, username);
            });
        }


        [Given(@"there are no document creation details in the ContractManagement\.CreatedContract table for the following contracts")]
        public void GivenThereAreNoDocumentCreationDetailsInTheContractManagement_CreatedContractTableForTheFollowingContracts(TransformedTable table)
        {
            table.Rows.ForEach(row =>
            {
                CreatedContractRepository.RemoveCreatedContract(
                    row["ContractNumber"],
                    row["ContractVersionNumber"],
                    row["ContractSubVersionNumber"]);
            });
        }

        [Given(@"the following document creation details exist in the ContractManagement\.CreatedContract table")]
        public void GivenTheFollowingDocumentCreationDetailsExistInTheContractManagement_CreatedContractTable(TransformedTable table)
        {
            table.Rows.ForEach(row =>
            {
                CreatedContractRepository.AddCreatedContractOrUpdateCreatedDate(
                    row["ContractNumber"],
                    row.ParseInt("ContractVersionNumber"),
                    row.ParseInt("ContractSubVersionNumber"),
                    row.ParseDate("CreatedDate", format: "yyyy-MM-dd HH:mm:ss.fff"));
            });
        }

        [Given(@"the following document creation details are present in the ContractManagement\.CreatedContract table")]
        public void GivenTheFollowingDocumentCreationDetailsArePresentInTheContractManagement_CreatedContractTable(TransformedTable table)
        {
            var contractExpected = table.Rows.Select(r => new CreatedContractDto(
                r["ContractNumber"],
                r.ParseInt("ContractVersionNumber"),
                r.ParseInt("ContractSubVersionNumber"),
                r.ParseDate("CreatedDate", format: "yyyy-MM-dd HH:mm:ss.fff"))).ToList();

            contractExpected.ForEach(c =>
            {
                CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
                {
                    var present =
                        CreatedContractRepository.IsCreatedContractPresent(c.ContractNumber, c.Version, c.SubVersion);

                    return present;
                },
                    maxNumChecks:15,
                    waitIntervalSeconds:3);

                bool isContractPresent = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsTrue(isContractPresent, $"Cannot find contract: {c}");

                CreatedContractRepository.UpdateCreatedContractCreatedDate(c.ContractNumber, c.Version, c.SubVersion, c.DateCreated);
            });
        }

         [Given(@"the following document templates have Upload timestamps as indicated")]
        public void GivenTheFollowingDocumentTemplatesHaveUploadTimestampsAsIndicated(Table table)
        {
            var documentTemplateInfos = table.Rows.Select(r => new DocumentTemplateInfo(
                r["DocumentTemplateName"],
                r.ParseDate("UploadTimestamp", format:"yyyy-MM-dd HH:mm:ss.fff"))).ToList();

            documentTemplateInfos.ForEach(t =>
            {
                UploadedDocumentTemplateRepository.UpSert(t.TemplateName, t.UploadedDateTime);
            });
        }

        [Given(@"there are no created contracts for this number '(.*)'")]
        [Given(@"there are no details on ContractManagement\.CreatedContract for '(.*)'")]
        [Given(@"there are no details in ContractManagement\.CreatedContract for '(.*)'")]
        public void GivenThereAreNoCreatedContractsForThisNumber(string contractNumber)
        {
            CreatedContractRepository.RemoveRange(new []{contractNumber});
        }

        [Given(@"there are no approved contracts for this number '(.*)'")]
        public void GivenThereAreNoApprovedContractsForThisNumber(string contractNumber)
        {
            ApprovedContractRepository.ClearApprovedContractsForContractNumber(contractNumber);
        }

        public string GetUrlSuffixForFeedType(string feedType)
        {
            Dictionary<string, string> urlSuffixByFeedType = new Dictionary<string, string>
            {
                {"ALLCONTRACT", string.Empty},
                {"APPROVEDCONTRACT", "approvals"},
                {"DRAFTCONTRACT", "draft"},
                {"APPROVALONWARDSCONTRACT", "approval-onwards"}
            };

            return urlSuffixByFeedType[feedType];
        }

        [Then(@"the Legal Contract CM feed contains the following '(.*)' deliverable")]
        [Then(@"the Legal Contract CM feed contains the following '(.*)' deliverables")]
        public void ThenTheLegalContractCMFeedContainsTheFollowingDeliverables(int expectedNumberOfDeliverables, TransformedTable table)
        {
            string urlSuffix = GetUrlSuffixForFeedType("APPROVEDCONTRACT");

            var expectedDeliverables = table.Rows.Select(r => new AllocationDeliverableInfo(ukprn: r.ParseInt("UKPRN"),
                contractNumber: r["ContractNumber"],
                version: r.ParseInt("ContractVersion"),
                allocationNumber: r["AllocationRef"],
                deliverableCode: r.ParseInt("DeliverableCode"),
                parentDeliverableCode: r.ParseInt("ParentDeliverableCode"),
                plannedValue: r.ParseDecimal("PlannedValue"),
                plannedVolume: r.ParseDecimal("PlannedVolume"),
                unitCost: r.ParseFloat("UnitCost"),
                deliverableName: r["DeliverableName"],
                deliverableDesc: r.ParseNullableString("DeliverableDescription")
            )).ToList();

            AllocationDeliverableInfo currentDeliverableBeingChecked = null;
            ISet<string> deliverablesFound = new HashSet<string>();
            expectedDeliverables.GroupBy(d => new{ d.ContractNumber, d.Version, d.Ukprn, d.AllocationNumber}).ToList().ForEach(expectedAllocation =>
            {
                SyndicationItem latestMatchingFeedItem = null;

                CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
                {
                    IEnumerable<SyndicationItem> retrievedFeedItems = AtomFeedReader.EnumerateItems(
                        $"{TestConfiguration.Configuration["ContractManagement:ServiceUrl"]}/api/contracts/notifications/{urlSuffix}",
                        AzureAuthenticator.GetAuthenticationConfig(),
                        "application/vnd.sfa.contract.v1+atom+xml");

                    latestMatchingFeedItem = retrievedFeedItems
                        .FirstOrDefault(feedItem =>
                        {
                            contractType contract = feedItem.GetContent<Contract>().contracts.Single();
                            var matchingAllocation = contract.contractAllocations.SingleOrDefault(a =>
                                a.contractAllocationNumber == expectedAllocation.Key.AllocationNumber);

                            if (contract.contractNumber == expectedAllocation.Key.ContractNumber &&
                                contract.contractVersionNumber == expectedAllocation.Key.Version &&
                                contract.contractor.ukprn == expectedAllocation.Key.Ukprn &&
                                matchingAllocation != null)
                            {
                                var deliverablesOnMatchingAllocation = matchingAllocation.contractDeliverables.ToFlattenedList();
                                deliverablesOnMatchingAllocation.Select(d => $"{d.deliverable.deliverableCode}_{matchingAllocation.contractAllocationNumber}")
                                    .ToList()
                                    .ForEach(d => deliverablesFound.Add(d));

                                return expectedAllocation.All(expectedDeliverable =>
                                {
                                    currentDeliverableBeingChecked = expectedDeliverable;

                                    return deliverablesOnMatchingAllocation.Any(d =>
                                    {
                                        return d.deliverable.deliverableCode == expectedDeliverable.DeliverableCode &&
                                               d.deliverable.deliverableName == expectedDeliverable.DeliverableName &&
                                               d.unitCost == (decimal)expectedDeliverable.UnitCost &&
                                               d.plannedValue == expectedDeliverable.PlannedValue &&
                                               d.plannedVolume == expectedDeliverable.PlannedVolume;
                                    });
                                });
                            }

                            return false;
                        });
                    return latestMatchingFeedItem != null;
                }, maxNumChecks: 10, waitIntervalSeconds: 3);

                bool foundExpectedItem = poller.CheckResultAndWaitTillCompleteOrOutOfTime();
                ClassicAssert.IsTrue(foundExpectedItem, $"Item not found on APPROVEDCONTRACT Contract Atom Feed: {currentDeliverableBeingChecked}");
            });
            ClassicAssert.AreEqual(expectedNumberOfDeliverables, deliverablesFound.Count, "Wrong number of deliverables found");
        }

        [Then(@"the following Contracts exist in CRM")]
        [Given(@"the following Contracts exist in CRM")]
        public void ThenTheFollowingContractsExistInCrm(TransformedTable table)
        {
            List<SimpleLocalContract> contracts = table.Rows.Select(TableRowToContract).ToList();
            Dictionary<Guid, string> fundingTypesDictionary = new Dictionary<Guid, string>();
            Dictionary<Guid, string> subStatusDictionary = new Dictionary<Guid, string>();
            Dictionary<Guid, string> contractTypeDictionary = new Dictionary<Guid, string>();
            Dictionary<Guid, string> currentTaskDictionary = new Dictionary<Guid, string>();
            Dictionary<Guid, string> periodDictionary = new Dictionary<Guid, string>();
            Dictionary<Guid, string> providerDictionary = new Dictionary<Guid, string>();
            Dictionary<Guid, string> ownerDictionary = new Dictionary<Guid, string>();

            contracts.ForEach(c =>
            {
                sfa_contract crmContract = null;
                CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
                {
                    crmContract = CrmContractRepository.GetContract(contractNumber: c.ContractNumber, versionNumber: c.Version,
                        subVersionNumber: c.SubVersion);

                    return crmContract != null;
                },
                maxNumChecks: 30,
                waitIntervalSeconds: 3);

                bool isContractPresent = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsTrue(isContractPresent, $"{c} is not present in CRM");

                ClassicAssert.AreEqual(c.FundingType, GetTextNameForGuid(fundingTypesDictionary, crmContract.sfa_FundingType.Id, id => CrmFundingTypeRepository.FindById(id).sfa_name), $"The funding type is not correct - {c} ");
                ClassicAssert.AreEqual(c.ContractValue, crmContract.sfa_ContractValue.Value, $"The contract value is not correct - {c} ");
                ClassicAssert.AreEqual(c.Status, crmContract.sfa_ContractStatusEnum.ToString(), $"The contract status is not correct - {c} ");
                if (c.SubStatus != "?")
                {
                    ClassicAssert.AreEqual(c.SubStatus, GetTextNameForGuid(subStatusDictionary, crmContract.sfa_SubStatus.Id, CrmStatusRepository.GetStatusText), $"The contract status is not correct - {c} ");
                }
                else
                {
                    ClassicAssert.AreEqual(null, crmContract.sfa_SubStatus, $"The contract status is not correct - {c} ");
                }
                ClassicAssert.AreEqual(c.Version, crmContract.sfa_Version, $"The version is not correct - {c} ");
                ClassicAssert.AreEqual(c.SubVersion, crmContract.sfa_SubVersion, $"The subVersion is not correct - {c} ");
                ClassicAssert.AreEqual(c.StartDate, crmContract.sfa_StartDate.Value.Date, $"The startDate is not correct - {c} ");
                ClassicAssert.AreEqual(c.EndDate, crmContract.sfa_EndDate.Value.Date, $"The endDate is not correct - {c} ");
                ClassicAssert.AreEqual(c.LatestVersion, crmContract.sfa_LatestVersion, $"The latest version is not correct - {c} ");
                ClassicAssert.AreEqual(c.LastApproved, crmContract.sfa_LastApprovedVersion, $"The last approved version is not correct - {c} ");
                ClassicAssert.AreEqual(c.ContractType, GetTextNameForGuid(contractTypeDictionary, crmContract.sfa_ContractType.Id, CrmContractRepository.GetContractType), $"The contract type is not correct - {c} ");

                ClassicAssert.AreEqual(c.ContractDescription, crmContract.sfa_Description ?? "?", $"The description is not correct - {c} ");

                ClassicAssert.AreEqual(c.AmendmentType, crmContract.sfa_AmendmentTypeEnum?.ToString(), $"The amendment type is not correct - {c} ");
                ClassicAssert.AreEqual(c.CurrentTask, GetNullableTextNameForGuid(currentTaskDictionary, crmContract.sfa_CurrentTask?.Id, CrmTaskRepository.GetTaskName), $"The currentTask is not correct - {c} ");
                ClassicAssert.AreEqual(c.DocumentationRequired, crmContract.sfa_DocumentationRequired, $"The DocumentationRequired is not correct - {c} ");
                string parentContractNumber = crmContract.sfa_ParentContractId != null
                    ? CrmContractRepository.GetContract(crmContract.sfa_ParentContractId.Id).sfa_number
                    : null;

                ClassicAssert.AreEqual(c.ParentContract, parentContractNumber, $"The parentContractNumber is not correct - {c} ");
                ClassicAssert.AreEqual(c.Period, GetNullableTextNameForGuid(periodDictionary, crmContract.sfa_PeriodId?.Id, CrmPeriodRepository.GetPeriodText), $"The period is not correct - {c} ");
                ClassicAssert.AreEqual(c.ProviderName, GetTextNameForGuid(providerDictionary, crmContract.sfa_ProviderName.Id, CrmOrganisationRepository.GetOrganisationName), $"The org name is not correct - {c} ");
                ClassicAssert.AreEqual(c.State, crmContract.statecode.ToString(), $"The state is not correct - {c} ");
                ClassicAssert.AreEqual(c.TaskOwner, GetTextNameForGuid(ownerDictionary, crmContract.OwnerId.Id, CrmUserRepository.GetUserName), $"The owner is not correct - {c}");
                ClassicAssert.AreEqual(c.ValueVariation, crmContract.sfa_Variation, $"The value variation is not correct - {c}");
            });
        }

        [Then(@"the following Contract Allocations exist in CRM")]
        public void ThenTheFollowingContractAllocationsExistInCrm(TransformedTable table)
        {
            table.Rows.ForEach(row =>
            {
                string allocationNumber = row["ContractAllocationRef"];

                sfa_contractallocation contractAllocation = null;

                CheckResultPoller poller = new CheckResultPoller(
                    checkResult: () =>
                    {
                        contractAllocation = CrmContractAllocationRepository.GetLatestContractAllocation(allocationNumber);
                        return contractAllocation != null;
                    },
                    maxNumChecks: 10,
                    waitIntervalSeconds: 2);

                poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsNotNull(contractAllocation, $"Contract Allocation not found for {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row.ParseNullableString("ContractAllocationDescription"), contractAllocation.sfa_description,
                    $"Unexpected ContractAllocationDescription returned for Contract Allocation {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row.ParseNullableDecimal("AllocationValue"), contractAllocation.sfa_maximumcontractvalue,
                    $"Unexpected AllocationValue returned for Contract Allocation {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row.ParseNullableString("DeliveryUKPRN"), contractAllocation.sfa_deliveryorganisationukprn,
                    $"Unexpected DeliveryUKPRN returned for Contract Allocation {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row.ParseNullableString("DeliveryProvider"), contractAllocation.sfa_deliveryorganisationprovider?.Name,
                    $"Unexpected DeliveryProvider returned for Contract Allocation {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row.ParseNullableDate("StartDate"), contractAllocation.sfa_startdate,
                    $"Unexpected StartDate returned for Contract Allocation {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row.ParseNullableDate("EndDate"), contractAllocation.sfa_enddate,
                    $"Unexpected EndDate returned for Contract Allocation {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row["FundingStream"], contractAllocation.sfa_FundingStreamId.Name,
                    $"Unexpected FundingStream returned for Contract Allocation {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row["FundingStreamPeriod"], contractAllocation.sfa_FundingStreamPeriodId.Name,
                    $"Unexpected FundingStreamPeriod returned for Contract Allocation {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row.ParseEnum<sfa_contractallocationhierarchytype>("HierarchyType"), contractAllocation.sfa_HierarchytypeEnum,
                    $"Unexpected HierarchyType returned for Contract Allocation {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row.ParseNullableDecimal("AllocationValueVariation"), contractAllocation.sfa_Variation,
                    $"Unexpected AllocationValueVariation returned for Contract Allocation: {row.ToHeaderAndValueString()}");
            });
        }

        [Then(@"the following Contract Deliverables exist in CRM")]
        public void ThenTheFollowingContractDeliverablesExistInCrm(TransformedTable table)
        {
            table.Rows.ForEach(row =>
            {
                string allocationNumber = row["ContractAllocationRef"];
                int deliverableCode = row.ParseInt("DeliverableCode");

                sfa_contractdeliverable contractDeliverable = null;

                CheckResultPoller poller = new CheckResultPoller(
                    checkResult: () =>
                    {
                        contractDeliverable = CrmContractDeliverableRepository.GetLatestContractDeliverable(allocationNumber, deliverableCode);
                        return contractDeliverable != null;
                    },
                    maxNumChecks: 10,
                    waitIntervalSeconds: 1);

                poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsNotNull(contractDeliverable, $"Contract Deliverable not found for {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row.ParseInt("DisplayOrder"), contractDeliverable.sfa_DisplayOrder,
                    $"Unexpected DisplayOrder returned for Contract Deliverable {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row.ParseNullableString("ParentDeliverableCode"), contractDeliverable.Referencingsfa_cdeliverable_sfa_cdeliverable?.sfa_DeliverableCode,
                    $"Unexpected ParentDeliverableCode returned for Contract Deliverable {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row.ParseNullableDecimal("PlannedValue"), contractDeliverable.sfa_PlannedValue,
                    $"Unexpected PlannedValue returned for Contract Deliverable {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row.ParseNullableInt("PlannedVolume"), contractDeliverable.sfa_PlannedVolume,
                    $"Unexpected PlannedVolume returned for Contract Deliverable {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row.ParseNullableDecimal("UnitCost"), contractDeliverable.sfa_UnitCost,
                    $"Unexpected UnitCost returned for Contract Deliverable {row.ToHeaderAndValueString()}");
            });
        }

        [Then(@"the following Contract Deliverable Periods exist in CRM")]
        public void ThenTheFollowingContractDeliverablePeriodsExistInCrm(TransformedTable table)
        {
            table.Rows.ForEach(row =>
            {
                string allocationNumber = row["ContractAllocationRef"];
                int deliverableCode = row.ParseInt("DeliverableCode");
                int month = row.ParseInt("Month");
                int year = row.ParseInt("Year");

                sfa_contractdeliverableperiod contractDeliverablePeriod = null;

                CheckResultPoller poller = new CheckResultPoller(
                    checkResult: () =>
                    {
                        contractDeliverablePeriod = CrmContractDeliverablePeriodRepository.GetLatestContractDeliverablePeriod(allocationNumber, deliverableCode, year, month);
                        return contractDeliverablePeriod != null;
                    },
                    maxNumChecks: 10,
                    waitIntervalSeconds: 1);

                poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsNotNull(contractDeliverablePeriod, $"Contract Deliverable Period not found for {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row["PeriodType"], contractDeliverablePeriod.sfa_PeriodTypeId.Name,
                    $"Unexpected PeriodType returned for Contract Deliverable Period {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row["PeriodName"], contractDeliverablePeriod.sfa_PeriodName,
                    $"Unexpected PeriodName returned for Contract Deliverable Period {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row.ParseNullableDecimal("PlannedValue"), contractDeliverablePeriod.sfa_PlannedValue,
                    $"Unexpected PlannedValue returned for Contract Deliverable Period {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row.ParseNullableInt("PlannedVolume"), contractDeliverablePeriod.sfa_PlannedVolume,
                    $"Unexpected PlannedVolume returned for Contract Deliverable Period {row.ToHeaderAndValueString()}");
                ClassicAssert.AreEqual(row.ParseBoolean("PaymentPosted"), contractDeliverablePeriod.sfa_PaymentPosted,
                    $"Unexpected PaymentPosted returned for Contract Deliverable Period {row.ToHeaderAndValueString()}");
            });
        }

        private static string GetTextNameForGuid(Dictionary<Guid, string> textDictionary, Guid id, Func<Guid, string> getTextForGuid)
        {
            if (!textDictionary.ContainsKey(id))
            {
                textDictionary[id] = getTextForGuid(id);
            }

            return textDictionary[id];
        }

        private static string GetNullableTextNameForGuid(Dictionary<Guid, string> textDictionary, Guid? nullableId, Func<Guid, string> getTextForGuid)
        {
            if (nullableId.HasValue && nullableId.Value != Guid.Empty)
            {
                return GetTextNameForGuid(textDictionary, nullableId.Value, getTextForGuid);
            }

            return null;
        }

        private static SimpleLocalContract TableRowToContract(TableRow tableRow)
        {
            return new SimpleLocalContract
            {
                Ukprn = tableRow["UKPRN"],
                ContractNumber = tableRow["ContractNumber"],
                FundingType = tableRow["FundingType"],
                Status = tableRow["ContractStatus"],
                SubStatus = tableRow["ContractSubStatus"],
                ContractValue = tableRow.ParseDecimal("ContractValue"),
                Version = tableRow.ParseInt("ContractVersionNumber"),
                SubVersion = tableRow.ParseInt("ContractSubVersionNumber"),
                StartDate = tableRow.ParseDate("ContractStartDate"),
                EndDate = tableRow.ParseDate("ContractEndDate"),
                LatestVersion = tableRow.ParseBoolean("LatestVersion"),
                LastApproved = tableRow.ParseBoolean("LastApprovedVersion"),
                ContractOwner = tableRow["ContractOwner"],
                ContractType = tableRow["ContractType"],
                ContractDescription = tableRow["ContractDescription"],
                AmendmentType = tableRow.ParseNullableString("AmendmentType"),
                CurrentTask = tableRow.ParseNullableString("CurrentTask"),
                DocumentationRequired = tableRow.ParseNullableBoolean("DocumentationRequired"),
                ParentContract = tableRow.ParseNullableString("ParentContract"),
                Period = tableRow.ParseNullableString("Period"),
                ProviderName = tableRow["ProviderName"],
                State = tableRow["State"],
                TaskOwner = tableRow["TaskOwner"],
                ValueVariation = tableRow.ParseNullableDecimal("ContractValueVariation")
            };
        }

        private class SimpleLocalContract
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
            public string FundingType { get; set; }
            public decimal ContractValue { get; set; }
            public string ContractOwner { get; set; }
            public string ContractType { get; set; }
            public string ContractDescription { get; set; }
            public string CurrentTask { get; set; }
            public bool? DocumentationRequired { get; set; }
            public string ParentContract { get; set; }
            public string Period { get; set; }
            public string ProviderName { get; set; }
            public string State { get; set; }
            public string TaskOwner { get; set; }
            public decimal? ValueVariation { get; set; }

            public override string ToString()
            {
                return $"ContractNumber: {ContractNumber}, Version: {Version}, SubVersion: {SubVersion}";
            }
        }

        private class AllocationDeliverableInfo
        {
            public AllocationDeliverableInfo(int ukprn, string contractNumber, int version, string allocationNumber, int deliverableCode, int parentDeliverableCode, decimal plannedValue, decimal plannedVolume, float unitCost, string deliverableName, string deliverableDesc)
            {
                Ukprn = ukprn;
                ContractNumber = contractNumber;
                Version = version;
                AllocationNumber = allocationNumber;
                DeliverableCode = deliverableCode;
                ParentDeliverableCode = parentDeliverableCode;
                PlannedValue = plannedValue;
                PlannedVolume = plannedVolume;
                UnitCost = unitCost;
                DeliverableName = deliverableName;
                DeliverableDesc = deliverableDesc;
            }

            public int Ukprn { get; }
            public string ContractNumber { get; }
            public int Version { get; }
            public string AllocationNumber { get; }
            public int DeliverableCode { get; }
            public int ParentDeliverableCode { get; }
            public decimal PlannedValue { get; }
            public decimal PlannedVolume { get; }
            public float UnitCost { get; }
            public string DeliverableName { get; }
            public string DeliverableDesc { get; }

            public override string ToString()
            {
                return $"AllocationNumber: {AllocationNumber}, DeliverableCode: {DeliverableCode}";
            }
        }


        private class CreatedContractDto
        {
            public CreatedContractDto(string contractNumber, int version, int subVersion, DateTime dateCreated)
            {
                ContractNumber = contractNumber;
                Version = version;
                SubVersion = subVersion;
                DateCreated = dateCreated;
            }

            public string ContractNumber { get; }

            public int Version { get; }

            public int SubVersion { get; }

            public DateTime DateCreated { get; }

            public override string ToString()
            {
                return
                    $"ContractNumber: {ContractNumber}, Version: {Version}, SubVersion: {SubVersion}";
            }
        }

        private class DocumentTemplateInfo
        {
            public DocumentTemplateInfo(string templateName, DateTime uploadedDateTime)
            {
                TemplateName = templateName;
                UploadedDateTime = uploadedDateTime;
            }

            public string TemplateName { get; }

            public DateTime UploadedDateTime { get; }
        }
    }
}