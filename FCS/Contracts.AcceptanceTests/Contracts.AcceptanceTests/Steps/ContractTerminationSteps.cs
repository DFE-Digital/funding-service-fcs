namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Common.Extensions;
    using Extensions;
    using Infrastructure.DTO.ContractTermination;
    using Infrastructure.Repositories;
    using Infrastructure.UI;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using Utilities;
    using TechTalk.SpecFlow;

    [Binding]
    public class ContractTerminationSteps
    {
        private ContractTerminationRequest _contractTerminationRequest;
        private UpdateContractTerminationRequest _updateContractTerminationRequest;
        private ModifyContractRequest _modifyContractRequest;
        private string _validationErrors;

        [When(@"CRM user '(.*)' initiates contract termination for Contract '(.*)' Version '(.*)' SubVersion '(.*)' with the following options")]
        public void WhenCrmUserInitiatesContractTerminationForContractVersionSubVersionWithTheFollowingOptions(
            string user, TransformedString contractNumber, int version, int subVersion, TransformedTable table)
        {
            TableRow terminationValues = table.Rows.Single();

            _contractTerminationRequest = new ContractTerminationRequest
            {
                User = user,
                ContractNumber = contractNumber.Value,
                Version = version,
                SubVersion = subVersion,
                DefaultStopNewStartsDate = terminationValues.ParseNullableDate("DefaultStopNewStartsDate"),
                ContractTerminationDate = terminationValues.ParseNullableDate("ContractTerminationDate"),
                TerminationReason = terminationValues.ParseNullableString("TerminationReason"),
                InitiateAmendmentOnApproval = terminationValues.ParseNullableBoolean("InitiateAmendmentOnApproval"),
                TerminationComments = terminationValues.ParseNullableString("TerminationComments")
            };
        }

        [When(@"CRM user '(.*)' initiates a contract termination with the following values")]
        public void WhenCrmUserInitiatesAContractTerminationWithTheFollowingValues(string user, TransformedTable table)
        {
            TableRow terminationValues = table.Rows.Single();

            _contractTerminationRequest = new ContractTerminationRequest
            {
                User = user,
                ContractNumber = terminationValues["ContractNo"],
                Version = terminationValues.ParseInt("ContractVersion"),
                SubVersion = terminationValues.ParseInt("ContractSubVersion"),
                ContractTerminationDate = terminationValues.ParseNullableDate("ContractTerminationDate"),
                TerminationReason = terminationValues.ParseNullableString("TerminationReason"),
                TerminationComments = terminationValues.ParseNullableString("Comments"),
                ProvisionalTerminationDate = terminationValues.ParseNullableDate("ContractTerminationDate"),
                ProvisionalTerminationReason = terminationValues.ParseNullableString("TerminationReason")
            };
        }

        [When(@"with the following allocation termination options")]
        public void WhenWithTheFollowingAllocationTerminationOptions(TransformedTable table)
        {
            Assert.IsNotNull(_contractTerminationRequest, $"{nameof(_contractTerminationRequest)} variable not set");

            _contractTerminationRequest.Allocations.AddRange(table.Rows.Select(row => new ContractTerminationRequest.AllocationTerminationRequest
            {
                AllocationNumber = row["AllocationNumber"],
                AllocationStopNewStartsDate = row.ContainsKey("AllocationStopNewStartsDate") ?
                    row.ParseNullableDate("AllocationStopNewStartsDate") : row.ParseNullableDate("ProvisionalStopNewStartsDate"),
                AllocationTerminationDate = row.ContainsKey("AllocationTerminationDate") ?
                    row.ParseNullableDate("AllocationTerminationDate") : row.ParseNullableDate("ProvisionalFundingCessationDate"),
                ProvisionalStopNewStartsDate = row.ParseNullableDate("ProvisionalStopNewStartsDate"),
                ProvisionalFundingCessationDate = row.ParseNullableDate("ProvisionalFundingCessationDate")
            }));
        }

        [When(@"the user forwards the termination request for manager approval via UI")]
        public void WhenTheUserForwardsTheTerminationRequestForManagerApproval()
        {
            Assert.IsNotNull(_contractTerminationRequest, $"{nameof(_contractTerminationRequest)} variable not set");

            using (CrmWebDriver driver = CrmWebDriver.Create(_contractTerminationRequest.User))
            {
                Guid contractId = CrmContractRepository.GetContractId(
                    _contractTerminationRequest.ContractNumber,
                    _contractTerminationRequest.Version,
                    _contractTerminationRequest.SubVersion);

                InitiateContractTerminationDialog initiateContractTerminationDialog = InitiateContractTerminationDialog.Create(driver, contractId);

                _validationErrors = initiateContractTerminationDialog.TerminateContract(_contractTerminationRequest);
            }
        }

        [When(@"the user forwards the termination request for manager approval via SDK")]
        public void WhenTheUserForwardsTheTerminationRequestForManagerApprovalViaSdk()
        {
            Assert.IsNotNull(_contractTerminationRequest, $"{nameof(_contractTerminationRequest)} variable not set");

            Guid contractId = CrmContractRepository.GetContractId(
                _contractTerminationRequest.ContractNumber, _contractTerminationRequest.Version, _contractTerminationRequest.SubVersion);

            CrmContractRepository.InsertTerminationValuesAsUser(contractId, _contractTerminationRequest);
            CrmContractRepository.SetSubStatusForContract(contractId, "Awaiting Termination Initiation Approval");
        }

        [When(@"the user forwards the initiate termination request for manager approval via SDK")]
        public void WhenTheUserForwardsTheInitiateTerminationRequestForManagerApprovalViaSdk()
        {
            Assert.IsNotNull(_contractTerminationRequest, $"{nameof(_contractTerminationRequest)} variable not set");

            Guid contractId = CrmContractRepository.GetContractId(
                _contractTerminationRequest.ContractNumber, _contractTerminationRequest.Version, _contractTerminationRequest.SubVersion);
            Guid transitionId = CrmTransitionRepository.GetTransitionId("Initiate Contract Termination");

            CrmContractRepository.InsertTerminationValuesAsUser(contractId, _contractTerminationRequest);
            CrmContractRepository.SetTransitionOnContract(contractId, transitionId, _contractTerminationRequest.User);
        }

        [When(@"CRM user '(.*)' rejects the termination request for Contract '(.*)' Version '(.*)' SubVersion '(.*)' with free-text reason '(.*)'")]
          public void WhenCrmUserRejectsTheTerminationRequestForContractVersionSubVersionWithFreeTextReason(
            string user, TransformedString contractNumber, int version, int subVersion, string rejectionReason)
        {
            using (CrmWebDriver driver = CrmWebDriver.Create(user))
            {
                Guid contractId = CrmContractRepository.GetContractId(contractNumber.Value, version, subVersion);

                ContractMaintenancePage contractPage = ContractMaintenancePage.Create(driver, contractId);

                contractPage.RejectTermination(rejectionReason);
            }
        }

        [When(@"CRM user '(.*)' rejects the termination request for Contract '(.*)' Version '(.*)' SubVersion '(.*)' with free-text reason '(.*)' via SDK")]
        public void WhenCrmUserRejectsTheTerminationRequestForContractVersionSubVersionWithFreeTextReasonViaSdk(
            string user, TransformedString contractNumber, int version, int subVersion, string rejectionReason)
        {
            CrmContractRepository.SetTerminationInitiationRejectionValuesAsUser(user, contractNumber, version, subVersion, rejectionReason);
        }

        [When(@"CRM user '(.*)' cancels the termination request for Contract '(.*)' Version '(.*)' SubVersion '(.*)' via UI")]
        public void WhenCrmUserCancelsTheTerminationRequestForContractVersionSubVersion(string user, TransformedString contractNumber, int version, int subVersion)
        {
            using (CrmWebDriver driver = CrmWebDriver.Create(user))
            {
                Guid contractId = CrmContractRepository.GetContractId(contractNumber.Value, version, subVersion);

                ContractMaintenancePage contractPage = ContractMaintenancePage.Create(driver, contractId);

                contractPage.CancelTermination();
            }
        }

        [When(@"CRM user '(.*)' cancels the termination request for Contract '(.*)' Version '(.*)' SubVersion '(.*)' via SDK")]
        public void WhenCrmUserCancelsTheTerminationRequestForContractVersionSubVersionViaSdk(string user, TransformedString contractNumber, int version, int subVersion)
        {
            CrmContractRepository.CancelContractTerminationAsUser(user, contractNumber.Value, version, subVersion);
        }

        [When(@"CRM user '(.*)' completes the termination request for Contract '(.*)' Version '(.*)' SubVersion '(.*)' via UI")]
        [When(@"CRM user '(.*)' completes the termination request for Contract '(.*)' Version '(.*)' SubVersion '(.*)'")]
        public void WhenCrmUserCompletesTheTerminationRequestForContractVersionSubVersion(string user, TransformedString contractNumber, int version, int subVersion)
        {
            using (CrmWebDriver driver = CrmWebDriver.Create(user))
            {
                Guid contractId = CrmContractRepository.GetContractId(contractNumber.Value, version, subVersion);

                ContractMaintenancePage contractPage = ContractMaintenancePage.Create(driver, contractId);

                contractPage.CompleteTermination();
            }
        }

        [When(@"CRM user '(.*)' completes the termination request for Contract '(.*)' Version '(.*)' SubVersion '(.*)' via SDK")]
        public void WhenCrmUserCompletesTheTerminationRequestForContractVersionSubVersionViaSdk(string user, TransformedString contractNumber, int version, int subVersion)
        {
            CrmContractRepository.TerminateContractAsUser(user, contractNumber.Value, version, subVersion);
        }

        [When(@"CRM user '(.*)' updates contract termination details for Contract '(.*)' Version '(.*)' SubVersion '(.*)' with the following options")]
        public void WhenCrmUserUpdatesContractTerminationDetailsForContractVersionSubVersionWithTheFollowingOptions(string user, TransformedString contractNumber, int version, int subVersion, TransformedTable table)
        {
            TableRow terminationValues = table.Rows.Single();

            _updateContractTerminationRequest = new UpdateContractTerminationRequest
            {
                User = user,
                ContractNumber = contractNumber.Value,
                Version = version,
                SubVersion = subVersion,
                ContractTerminationDate = terminationValues.ParseNullableDate("ContractTerminationDate"),
                TerminationReason = terminationValues.ParseNullableString("TerminationReason"),
                TerminationComments = terminationValues.ParseNullableString("TerminationComments"),
                ProvisionalTerminationDate = terminationValues.ParseNullableDate("ContractTerminationDate"),
                ProvisionalTerminationReason = terminationValues.ParseNullableString("TerminationReason")
            };
        }

        [When(@"with the following updated allocation termination options")]
        public void WhenWithTheFollowingUpdatedAllocationTerminationOptions(TransformedTable table)
        {
            Assert.IsNotNull(_updateContractTerminationRequest, $"{nameof(_updateContractTerminationRequest)} variable not set");

            _updateContractTerminationRequest.Allocations.AddRange(table.Rows.Select(row => new UpdateContractTerminationRequest.UpdateAllocationTerminationRequest
            {
                AllocationNumber = row["AllocationNumber"],
                AllocationStopNewStartsDate = row.ParseNullableDate("AllocationStopNewStartsDate"),
                AllocationTerminationDate = row.ParseNullableDate("AllocationTerminationDate"),
                ProvisionalStopNewStartsDate = row.ParseNullableDate("AllocationStopNewStartsDate"),
                ProvisionalTerminationDate = row.ParseNullableDate("AllocationTerminationDate"),
            }));
        }

        [When(@"the user completes the termination amendment request via UI")]
        public void WhenTheUserCompletesTheTerminationAmendmentRequest()
        {
            Assert.IsNotNull(_updateContractTerminationRequest, $"{nameof(_updateContractTerminationRequest)} variable not set");

            using (CrmWebDriver driver = CrmWebDriver.Create(_updateContractTerminationRequest.User))
            {
                Guid contractId = CrmContractRepository.GetContractId(
                    _updateContractTerminationRequest.ContractNumber,
                    _updateContractTerminationRequest.Version,
                    _updateContractTerminationRequest.SubVersion);

                UpdateContractTerminationDialog updateContractTerminationDialog = UpdateContractTerminationDialog.Create(driver, contractId);

                _validationErrors = updateContractTerminationDialog.UpdateTerminationDetails(_updateContractTerminationRequest);
            }
        }

        [When(@"the user completes the termination amendment request via SDK")]
        public void WhenTheUserCompletesTheTerminationAmendmentRequestViaSdk()
        {
            Assert.IsNotNull(_updateContractTerminationRequest, $"{nameof(_updateContractTerminationRequest)} variable not set");

            CrmContractRepository.UpdateTerminationValuesAsUser(_updateContractTerminationRequest);
        }

        [When(@"CRM user '(.*)' updates a contract modification with the following values")]
        [When(@"CRM user '(.*)' initiates a contract modification with the following values")]
        public void WhenCrmUserInitiatesAContractModificationWithTheFollowingValues(string user, TransformedTable table)
        {
            TableRow modificationValues = table.Rows.Single();

            _modifyContractRequest = new ModifyContractRequest
            {
                User = user,
                ContractNumber = modificationValues["ContractNo"],
                Version = modificationValues.ParseInt("ContractVersion"),
                SubVersion = modificationValues.ParseInt("ContractSubVersion"),
                DefaultStopNewStartsDate = modificationValues.ParseDate("DefaultStopNewStartsDate"),
                DefaultNewStartsSuspendedReason = modificationValues["DefaultNewStartsSuspendedReason"],
                Comments = modificationValues.ParseNullableString("Comments")
            };
        }

        [When(@"the user forwards the initiate modification request for manager approval via SDK")]
        public void WhenTheUserForwardsTheInitiateModificationRequestForManagerApprovalViaSdk()
        {
            Assert.IsNotNull(_modifyContractRequest, $"{nameof(_modifyContractRequest)} variable not set");

            CrmContractRepository.ModifyContractValuesAsUser(_modifyContractRequest);
        }

        [When(@"the user issues an update modification request via SDK")]
        public void WhenTheUserIssuesAnUpdateModificationRequestViaSdk()
        {
            Assert.IsNotNull(_modifyContractRequest, $"{nameof(_modifyContractRequest)} variable not set");

            CrmContractRepository.UpdateModificationValuesAsUser(_modifyContractRequest);
        }

        [When(@"CRM user '(.*)' cancels the authorised modification for Contract '(.*)' Version '(.*)' SubVersion '(.*)' via SDK")]
        public void WhenCrmUserCancelsTheAuthorisedModificationForContractVersionSubVersionViaSdk(string user, TransformedString contractNumber, int version, int subVersion)
        {
            CrmContractRepository.CancelModificationAsUser(user, contractNumber, version, subVersion);
        }

        [Then(@"the contract termination has failed with the following validation errors")]
        public void ThenTheContractTerminationHasFailedWithTheFollowingValidationErrors(Table table)
        {
            Assert.IsNotNull(_validationErrors, $"{nameof(_validationErrors)} variable not set");

            table.Rows.ForEach(row =>
            {
                string expectedError = row["ValidationError"];

                Assert.IsTrue(_validationErrors.Contains(expectedError), $"Expected validation error: \"[{expectedError}]\". Actual validation errors: \"[{_validationErrors}]\".");
            });
        }

        [Then(@"the following contract termination values are present in CRM")]
        [Then(@"the following contract modification values are present in CRM")]
        public void ThenTheFollowingContractTerminationValuesArePresentInCrm(TransformedTable table)
        {
            table.Rows.ForEach(row =>
            {
                List<string> errors = new List<string>();

                CheckResultPoller poller = new CheckResultPoller(() =>
                {
                    ContractTerminationValues actualTerminationValues = CrmContractRepository.GetContractTerminationValues(
                        row["ContractNumber"],
                        row.ParseInt("ContractVersionNumber"),
                        row.ParseInt("ContractSubVersionNumber"));

                    errors.Clear();

                    if (row.ContainsKey("ContractTerminationDate"))
                    {
                        if (row.ParseNullableDate("ContractTerminationDate") != actualTerminationValues.TerminationDate)
                        {
                            errors.Add($"Termination Date incorrect for {row.ToHeaderAndValueString()}");
                        }
                    }

                    if (row.ContainsKey("TerminationComments"))
                    {
                        if (row.ParseNullableString("TerminationComments") != actualTerminationValues.TerminationComments)
                        {
                            errors.Add($"Termination Comments incorrect for {row.ToHeaderAndValueString()}");
                        }
                    }

                    if (row.ContainsKey("InitiateAmendmentOnApproval"))
                    {
                        if (row.ParseNullableBoolean("InitiateAmendmentOnApproval") != actualTerminationValues.InitiateAmendmentOnApproval)
                        {
                            errors.Add($"Initiate Amendment On Approval option incorrect for {row.ToHeaderAndValueString()}");
                        }
                    }

                    if (row.ContainsKey("TerminationReason"))
                    {
                        string expectedTerminationReason = row.ParseNullableString("TerminationReason")?.Replace(" ", "").ToLower();
                        string actualTerminationReason = actualTerminationValues.TerminationReason?.ToLower();

                        if (expectedTerminationReason != actualTerminationReason)
                        {
                            errors.Add($"Termination Reason incorrect for {row.ToHeaderAndValueString()}");
                        }
                    }

                    if (row.ContainsKey("ProvisionalTerminationDate"))
                    {
                        if (row.ParseNullableDate("ProvisionalTerminationDate") != actualTerminationValues.ProvisionalTerminationDate)
                        {
                            errors.Add($"Provisional Termination Date incorrect for {row.ToHeaderAndValueString()}");
                        }
                    }

                    if (row.ContainsKey("ProvisionalTerminationReason"))
                    {
                        string expectedProvisionalTerminationReason = row.ParseNullableString("ProvisionalTerminationReason")?.Replace(" ", "").ToLower();
                        string actualProvisionalTerminationReason = actualTerminationValues.ProvisionalTerminationReason?.ToLower();

                        if (expectedProvisionalTerminationReason != actualProvisionalTerminationReason)
                        {
                            errors.Add($"Provisional Termination Reason incorrect for {row.ToHeaderAndValueString()}");
                        }
                    }

                    if (row.ContainsKey("ProvisionalTerminationComments"))
                    {
                        if (row.ParseNullableString("ProvisionalTerminationComments") != actualTerminationValues.ProvisionalTerminationComments)
                        {
                            errors.Add($"Provisional Termination Comments incorrect for {row.ToHeaderAndValueString()}");
                        }
                    }

                    if (row.ContainsKey("DefaultStopNewStartsDate"))
                    {
                        if (row.ParseNullableDate("DefaultStopNewStartsDate") != actualTerminationValues.DefaultStopNewStartsDate)
                        {
                            errors.Add($"Default Stop New Starts Date incorrect for {row.ToHeaderAndValueString()}");
                        }
                    }

                    if (row.ContainsKey("ProvisionalStopNewStartsDate"))
                    {
                        if (row.ParseNullableDate("ProvisionalStopNewStartsDate") != actualTerminationValues.ProvisionalStopNewStartsDate)
                        {
                            errors.Add($"Provisional Stop New Starts Date incorrect for {row.ToHeaderAndValueString()}");
                        }
                    }

                    if (row.ContainsKey("DefaultNewStartsSuspendedReason"))
                    {
                        string expectedDefaultNewStartsSuspendedReason = row.ParseNullableString("DefaultNewStartsSuspendedReason")?.Replace(" ", "").ToLower();
                        string actualDefaultNewStartsSuspendedReason = actualTerminationValues.DefaultNewStartsSuspendedReason?.ToLower();

                        if (expectedDefaultNewStartsSuspendedReason != actualDefaultNewStartsSuspendedReason)
                        {
                            errors.Add($"Default New Starts Suspended Reason incorrect for {row.ToHeaderAndValueString()}");
                        }
                    }

                    if (row.ContainsKey("ProvisionalNewStartsSuspendedReason"))
                    {
                        string expectedProvisionalNewStartsSuspendedReason = row.ParseNullableString("ProvisionalNewStartsSuspendedReason")?.Replace(" ", "").ToLower();
                        string actualProvisionalNewStartsSuspendedReason = actualTerminationValues.ProvisionalNewStartsSuspendedReason?.ToLower();

                        if (expectedProvisionalNewStartsSuspendedReason != actualProvisionalNewStartsSuspendedReason)
                        {
                            errors.Add($"Provisional New Starts Suspended Reason incorrect for {row.ToHeaderAndValueString()}");
                        }
                    }

                    return errors.Empty();
                }, 10, 2);

                bool success = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                Assert.IsTrue(success, string.Join(Environment.NewLine, errors));
            });
        }

        [Then(@"the following allocation termination values are present in CRM")]
        [Then(@"the following allocation modification values are present in CRM")]
        public void ThenTheFollowingAllocationTerminationValuesArePresentInCrm(TransformedTable table)
        {
            table.Rows.ForEach(row =>
            {
                List<string> errors = new List<string>();

                CheckResultPoller poller = new CheckResultPoller(() =>
                {
                    AllocationTerminationValues actualTerminationValues = CrmContractAllocationRepository.GetAllocationTerminationValues(
                        row["AllocationNumber"],
                        row.ParseInt("ContractVersionNumber"),
                        row.ParseInt("ContractSubVersionNumber"));

                    errors.Clear();
                    if (actualTerminationValues != null)
                    {
                        if (row.ContainsKey("StopNewStartsDate"))
                        {
                            if (row.ParseNullableDate("StopNewStartsDate") != actualTerminationValues.StopNewStartsDate)
                            {
                                errors.Add($"Stop New Starts Date incorrect for {row.ToHeaderAndValueString()}");
                            }
                        }

                        if (row.ContainsKey("AllocationTerminationDate"))
                        {
                            if (row.ParseNullableDate("AllocationTerminationDate") != actualTerminationValues.TerminationDate)
                            {
                                errors.Add($"Termination Date incorrect for {row.ToHeaderAndValueString()}");
                            }
                        }

                        if (row.ContainsKey("ProvisionalStopNewStartsDate"))
                        {
                            if (row.ParseNullableDate("ProvisionalStopNewStartsDate") != actualTerminationValues.ProvisionalStopNewStartsDate)
                            {
                                errors.Add($"Provisional Stop New Starts Date incorrect for {row.ToHeaderAndValueString()}");
                            }
                        }

                        if (row.ContainsKey("ProvisionalFundingCessationDate"))
                        {
                            if (row.ParseNullableDate("ProvisionalFundingCessationDate") != actualTerminationValues.ProvisionalFundingCessationDate)
                            {
                                errors.Add($"Provisional Funding Cessation Date incorrect for {row.ToHeaderAndValueString()}");
                            }
                        }

                        if (row.ContainsKey("FundingCessationDate"))
                        {
                            if (row.ParseNullableDate("FundingCessationDate") != actualTerminationValues.FundingCessationDate)
                            {
                                errors.Add($"Funding Cessation Date incorrect for {row.ToHeaderAndValueString()}");
                            }
                        }

                        if (row.ContainsKey("NewStartsSuspendedReason"))
                        {
                            string expectedNewStartsSuspendedReason = row.ParseNullableString("NewStartsSuspendedReason")?.Replace(" ", "").ToLower();
                            string actualNewStartsSuspendedReason = actualTerminationValues.NewStartsSuspendedReason?.ToLower();

                            if (expectedNewStartsSuspendedReason != actualNewStartsSuspendedReason)
                            {
                                errors.Add($"New Starts Suspended Reason incorrect for {row.ToHeaderAndValueString()}");
                            }
                        }

                        if (row.ContainsKey("ProvisionalNewStartsSuspendedReason"))
                        {
                            string expectedProvisionalNewStartsSuspendedReason = row.ParseNullableString("ProvisionalNewStartsSuspendedReason")?.Replace(" ", "").ToLower();
                            string actualProvisionalNewStartsSuspendedReason = actualTerminationValues.ProvisionalNewStartsSuspendedReason?.ToLower();

                            if (expectedProvisionalNewStartsSuspendedReason != actualProvisionalNewStartsSuspendedReason)
                            {
                                errors.Add($"Provisional New Starts Suspended Reason incorrect for {row.ToHeaderAndValueString()}");
                            }
                        }
                    }
                    else
                    {
                        errors.Add($"We have not found the allocation:{row["AllocationNumber"]}, version:{row.ParseInt("ContractVersionNumber")}");
                    }

                    return errors.Empty();
                }, 10, 2);

                bool success = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                Assert.IsTrue(success, string.Join(Environment.NewLine, errors));
            });
        }

        [Given(@"there are no allocations marked as Under Termination for UKPRN '(.*)'")]
        public void GivenThereIsNoAllocationsUnderTerminationForThisUkprn(int ukprn)
        {
            CrmContractAllocationRepository.GetAllocationNumbersForUkprn(ukprn)
                .ForEach(AllocationUnderTerminationRepository.DeleteAllocation);
        }

        [Given(@"there are no terminated or closed allocations for UKPRN '(.*)'")]
        public void GivenThereAreNoTerminatedOrClosedAllocationsForThisUkprn(int ukprn)
        {
            var allocationNumbers = ApprovedContractRepository.GetAllocationNumbersForUkprn(ukprn);

           allocationNumbers.ForEach(InvalidAllocationRepository.DeleteInvalidAllocation);

           if (!allocationNumbers.Any())
           {
                InvalidAllocationRepository.DeleteAllInvalidAllocations();
           }
        }
    }
}
