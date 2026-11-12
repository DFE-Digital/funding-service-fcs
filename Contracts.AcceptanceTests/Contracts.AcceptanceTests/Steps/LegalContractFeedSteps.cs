namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.ServiceModel.Syndication;
    using CrossDomain.Integration.Common.Extensions;
    using CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using Extensions;
    using Infrastructure.DTO;
    using Infrastructure.Repositories;
    using Infrastructure.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TechTalk.SpecFlow;
    using Utilities;
    using NUnit.Framework.Legacy;

    [Binding]
    public class LegalContractFeedSteps
    {
        [Then(@"the details in CRM for version '(.*)' of contract '(.*)' agree with the most recent entry for this contract in the ContractManagement feed")]
        public void ThenTheDetailsInCrmForVersionOfContractAgreeWithTheMostRecentEntryForThisContractInTheContractManagementFeed(
            int versionNumber, TransformedString contractNumber)
        {
            ContractDetail crmContract = CrmContractRepository.GetLatestContractDetail(contractNumber, versionNumber);
            List<string> errors = new List<string>();

            bool RetrieveAndCompareLatestFeedItemForContract()
            {
                IEnumerable<SyndicationItem> retrievedFeedItems = AtomFeedReader.EnumerateItems(
                    $"{TestConfiguration.Configuration["ContractManagement:ServiceUrl"]}/api/contracts/notifications",
                    AzureAuthenticator.GetAuthenticationConfig(),
                    "application/vnd.sfa.contract.v1+atom+xml");

                contractType feedContract = retrievedFeedItems
                    .Select(feedItem => feedItem.GetContent<Contract>().contracts.Single())
                    .FirstOrDefault(contract => contract.contractNumber == contractNumber);

                errors.Clear();

                if (feedContract != null)
                {
                    errors.AddRange(GetContractComparisonMismatches(feedContract, crmContract));
                    errors.AddRange(GetAllocationComparisonMismatches(feedContract, crmContract));
                }
                else
                {
                    errors.Add("No feed entry found");
                }

                return errors.None();
            }

            CheckResultPoller poller = new CheckResultPoller(checkResult: RetrieveAndCompareLatestFeedItemForContract, maxNumChecks: 10, waitIntervalSeconds: 3);
            poller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsFalse(errors.Any(),
                $"Mismatch between All Contract Atom Feed and CRM for Contract: {contractNumber}, Version: {versionNumber}. Mismatches: {Environment.NewLine + string.Join(Environment.NewLine, errors)}");
        }

        private static IEnumerable<string> GetContractComparisonMismatches(contractType feedContract, ContractDetail crmContract)
        {
            var comparables = new List<(string name, object a, object b)>
            {
                ("SubVersionNumber", feedContract.contractSubVersionNumber, crmContract.SubVersionNumber),
                ("ContractApprovalDate", feedContract.ContractApprovalDate.GetValueOrDefault().Date, crmContract.ContractApprovalDate.GetValueOrDefault().Date),
                ("FundingTypeCode", feedContract.fundingType.fundingTypeCode, crmContract.FundingTypeCode),
                ("FundingTypeName", feedContract.fundingType.fundingTypeName, crmContract.FundingTypeName),
                ("PeriodTypeCode", feedContract.period.periodType.periodTypeCode, crmContract.PeriodTypeCode),
                ("PeriodTypeName", feedContract.period.periodType.periodTypeName, crmContract.PeriodTypeName.ToUpper().Replace(" ", string.Empty)),
                ("Period", feedContract.period.period1, crmContract.Period),
                ("OrganisationId", feedContract.contractor.organisationIdentifier, crmContract.OrganisationId),
                ("Ukprn", feedContract.contractor.ukprn, crmContract.Ukprn),
                ("ContractType", feedContract.contractType1, crmContract.ContractType),
                ("StartDate", feedContract.startDate, crmContract.StartDate),
                ("EndDate", feedContract.endDate, crmContract.EndDate),
                ("Status", feedContract.contractStatus.parentStatus, crmContract.Status),
                ("SubStatus", feedContract.contractStatus.status, crmContract.SubStatus.Replace(" ", string.Empty)),
                ("ContractValue", feedContract.contractValue, crmContract.ContractValue),
                ("AmendmentType", feedContract.amendmentType, crmContract.AmendmentType)
            };

            if (IsTerminationSubStatus(crmContract.SubStatus))
            {
                comparables.Add(("TerminationDate", feedContract.TerminationContractAttrs?.terminationDate, crmContract.TerminationDate));
                comparables.Add(("TerminationReason", feedContract.TerminationContractAttrs?.ReasonForTermination, crmContract.TerminationReason));
            }

            return comparables
                .Where(c => c.a?.ToString() != c.b?.ToString())
                .Select(c => $"Contract {feedContract.contractNumber} {c.name} - Feed: '{c.a}' v CRM: '{c.b}'")
                .ToList();
        }

        private static IEnumerable<string> GetAllocationComparisonMismatches(contractType feedContract, ContractDetail crmContract)
        {
            List<string> errors = new List<string>();

            if (feedContract.contractAllocations.Count != crmContract.Allocations.Count)
            {
                errors.Add("Number of allocations");
            }

            feedContract.contractAllocations.ForEach(feedAllocation =>
            {
                var crmAllocation = crmContract.Allocations.SingleOrDefault(a => a.AllocationNumber == feedAllocation.contractAllocationNumber);

                if (crmAllocation != null)
                {
                    var comparables = new List<(string name, object a, object b)>
                    {
                        ("FundingStreamCode", feedAllocation.fundingStream.fundingStreamCode, crmAllocation.FundingStreamCode),
                        ("FundingStreamName", feedAllocation.fundingStream.fundingStreamName, crmAllocation.FundingStreamName),
                        ("FundingTypeCode", feedAllocation.fundingStream.fundingTypeCode, crmAllocation.FundingTypeCode),
                        ("FundingStreamPeriodCode", feedAllocation.fundingStreamPeriodCode, crmAllocation.FundingStreamPeriodCode),
                        ("StartDate", feedAllocation.startDate, crmAllocation.StartDate),
                        ("EndDate", feedAllocation.endDate, crmAllocation.EndDate),
                        ("MaximumContractValue", feedAllocation.maximumContractValue, crmAllocation.MaximumContractValue)
                    };

                    if (IsTerminationSubStatus(crmContract.SubStatus))
                    {
                        comparables.Add(("FundingCessationDate", feedAllocation.allocationTerminationAttrs?.fundingCessationDate, crmAllocation.FundingCessationDate));
                        comparables.Add(("NewStartsSuspendedReason", feedAllocation.allocationTerminationAttrs?.newStartsSuspendedReason, crmAllocation.NewStartsSuspendedReason));
                        comparables.Add(("StopNewStartsDate", feedAllocation.allocationTerminationAttrs?.stopNewStartsFromDate, crmAllocation.StopNewStartsDate));
                    }

                    errors.AddRange(comparables
                        .Where(c => c.a?.ToString() != c.b?.ToString())
                        .Select(c => $"Allocation {feedAllocation.contractAllocationNumber} {c.name} - Feed: '{c.a}' v CRM: '{c.b}'")
                        .ToList());
                }
                else
                {
                    errors.Add($"No CRM allocation found for {feedAllocation.contractAllocationNumber}");
                }
            });

            return errors;
        }

        private static bool IsTerminationSubStatus(string subStatus)
        {
            var terminationSubStatuses = new[] { "Under Termination", "Terminated" };

            return terminationSubStatuses.Contains(subStatus);
        }
    }
}
