namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Extensions;
    using Infrastructure.DTO;
    using Infrastructure.DTO.PaymentGeneration;
    using Infrastructure.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using Pages;
    using State;
    using TechTalk.SpecFlow;
    using Utilities;

    [Binding]
    public class EfaSteps
    {
        private readonly RetrievedContractFromCrmState _state;
        private readonly ContractDocumentGenerationPageObject _contractDocumentGenerationPageObject;

        public EfaSteps(RetrievedContractFromCrmState state, ContractDocumentGenerationPageObject contractDocumentGenerationPageObject)
        {
            _state = state;
            _contractDocumentGenerationPageObject = contractDocumentGenerationPageObject;
        }

        [Given(@"I retrieve the latest EFA contract details from CRM for provider '(.*)' for FundingType '(.*)' and period '(.*)' and Delivery Organisation '(.*)'")]
        [When(@"I retrieve the latest EFA contract details from CRM for provider '(.*)' for FundingType '(.*)' and period '(.*)' and Delivery Organisation '(.*)'")]
        [Then(@"I retrieve the latest EFA contract details from CRM for provider '(.*)' for FundingType '(.*)' and period '(.*)' and Delivery Organisation '(.*)'")]
        public void WhenIRetrieveTheLatestEFAContractDetailsFromCRMForProviderForFundingTypeAndPeriodAndDeliveryOrganisation(int ukprn, string fundingType, int period, string deliveryOrgUkprn)
        {
            ContractDto contractInCrm = CrmContractRepository.GetLatestContractInfoByProviderAndDeliveryOrg(ukprn.ToString(), period.ToString(), fundingType,
                 deliveryOrgUkprn.ParseNullableString());

            _state.Contract = contractInCrm;
            FeatureVariables.Set("ContractNo", contractInCrm.ContractNumber);
            FeatureVariables.Set("MasterContractNo", contractInCrm.MasterContractNumber);

            _state.Contract.AllocationNumberPrefixes.ForEach(allocPrefix => FeatureVariables.Set($"[AllocRef_{allocPrefix.Prefix}]", allocPrefix.AllocationNumber));
            Assert.IsNotNull(contractInCrm, "There is no contract returned for this query");
        }

        [Then(@"the pdf file which contains a upin and the following parameterized lines in order")]
        public void ThenUpinThePdfFileWithContainsTheFollowingParameterizedLinesInOrder(string multilineText)
        {
            multilineText = multilineText.Replace("[UPIN]", _state.Contract.Upin);
            multilineText = multilineText.Replace("[ContractNo]", _state.Contract.ContractNumber);
            multilineText = multilineText.Replace("[MasterContractNo]", _state.Contract.MasterContractNumber);
            
            multilineText = multilineText.Replace("[AllocRef_SSF]", _state.Contract.AllocationNumberPrefixes.FirstOrDefault(allocationPrefix => allocationPrefix.Prefix.Equals("SSF"))?.AllocationNumber);
            multilineText = multilineText.Replace("[AllocRef_NMF]", _state.Contract.AllocationNumberPrefixes.FirstOrDefault(allocationPrefix => allocationPrefix.Prefix.Equals("NMF"))?.AllocationNumber);
            multilineText = multilineText.Replace("[AllocRef_16LR]", _state.Contract.AllocationNumberPrefixes.FirstOrDefault(allocationPrefix => allocationPrefix.Prefix.Equals("16LR"))?.AllocationNumber);
            _contractDocumentGenerationPageObject.VerifyPageLinesInOrderAndAssertIfNotFound(multilineText);
        }

        [Given(@"I retrieve the latest EFA contract details from CRM for provider '(.*)' for FundingType '(.*)' and period '(.*)'")]
        [Then(@"I retrieve the latest EFA contract details from CRM for provider '(.*)' for FundingType '(.*)' and period '(.*)'")]
        public void ThenIRetrieveTheLatestEFAContractDetailsFromCRMForProviderForFundingTypeAndPeriod(int ukprn, string fundingType, int period)
        {
            ContractDto contractInCrm = CrmContractRepository.GetLatestContractInfoByProvider(ukprn.ToString(), period.ToString(), fundingType);
            _state.Contract = contractInCrm;
            Assert.IsNotNull(contractInCrm, "There is no contract returned for this query");
        }
   
        [Given(@"the SubnominalAggregations table contains the following data")]
        [Then(@"the SubnominalAggregations table contains the following data")]
        public void ThenTheSubnominalAggregationsTableContainsTheFollowingData(Table table)
        {
            var simpleSubnominals = table.Rows.Select(r => new SimpleSubnominal(subnominalCode: r["SubnominalCode"],
                subnominalAggregationKey: GetSubnominalAggregateKey(r["SubnominalAggregateKey"]),
                paymentType: r["PaymentType"],
                fundingStreamPeriodCode: r["FundingStreamPeriod"],
                expectedValue: decimal.Parse(r["AggregateValue"]),
                providerName: r["Provider"])).ToList();

            List<string> distinctAllocationNumbers = simpleSubnominals.Select(s => s.GetAllocationNumber()).Distinct().ToList();
            List<AllocationInfo> allocationInfos = distinctAllocationNumbers.Select(n => new AllocationInfo(n, CrmContractAllocationRepository.GetLatestApprovedAllocationsGuid(n))).ToList();
            Dictionary<string, IReadOnlyCollection<sfa_subnominalaggregation>> subnominalsForAllocations = new Dictionary<string, IReadOnlyCollection<sfa_subnominalaggregation>>();
            
            simpleSubnominals.ForEach(sa =>
            {
                sfa_subnominalaggregation matchedSubnominalaggregation = null;
                IReadOnlyCollection<sfa_subnominalaggregation> subnominalaggregationsForAllocation = null;

                CheckResultPoller checkResultPoller = new CheckResultPoller(
                    checkResult: () =>
                    {
                        EntityReference organisationEntityReference = CrmOrganisationRepository.GetOrganisationEntityReferenceByName(sa.ProviderName);

                        Assert.IsNotNull(organisationEntityReference, $"The provider name {sa.ProviderName} does not exist in the Organisation (account) table");

                        if (!subnominalsForAllocations.ContainsKey(sa.GetAllocationNumber()))
                        {
                            subnominalaggregationsForAllocation =
                                CrmSubnominalAggregationRepository.GetSubnominalAggregationsForLatestApprovedAllocation(
                                    allocationInfos.Single(ai => ai.AllocationNumber == sa.GetAllocationNumber())
                                        .AllocationId.Value);
                            subnominalsForAllocations.Add(sa.GetAllocationNumber(), subnominalaggregationsForAllocation);
                        }

                        subnominalaggregationsForAllocation = subnominalsForAllocations[sa.GetAllocationNumber()];

                        int paymentTypeCode = CrmSubnominalAggregationRepository.GetPaymentTypeCode(CultureInfo.CurrentCulture.TextInfo.ToTitleCase(sa.PaymentType.ToLower()));
                        Assert.AreNotEqual(0, paymentTypeCode, $"The payment type {sa.PaymentType} is not supported");
                        matchedSubnominalaggregation = subnominalaggregationsForAllocation.FirstOrDefault(
                            s =>
                                s.sfa_SubnominalAggregateKey == sa.SubnominalAggregationKey &&
                                s.sfa_PaymentType.Value == paymentTypeCode);

                        if (matchedSubnominalaggregation == null ||
                            matchedSubnominalaggregation.sfa_AggregatedValue.Value != sa.ExpectedValue)
                        {
                            // reset the cache of values if a row doesn't match
                            subnominalsForAllocations.Remove(sa.GetAllocationNumber());
                        }

                        if (matchedSubnominalaggregation?.sfa_provider != null)
                        {
                            Assert.AreEqual(organisationEntityReference.Id, matchedSubnominalaggregation.sfa_provider.Id, $"The subnominal aggregation {sa} does not have the correct provider on it in CRM");
                        }

                        return matchedSubnominalaggregation != null && matchedSubnominalaggregation.sfa_AggregatedValue.Value == sa.ExpectedValue;
                    },
                    maxNumChecks: 20,
                    waitIntervalSeconds: 6);

                bool haveFoundValue = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();
                string aggregatedValueStr = matchedSubnominalaggregation.sfa_AggregatedValue.HasValue ? matchedSubnominalaggregation.sfa_AggregatedValue.ToString() : "Null";

                Assert.IsTrue(haveFoundValue, $"We have not found the expected subnominal aggregation value for {sa} - actual value - {aggregatedValueStr}");
                
            });
            
        }

        [Then(@"the PaymentGeneration\.SubnominalAggregation table contains the following values")]
        [Then(@"the below Subnominal Aggregation exists in the PayGen data store")]
        public void ThenTheBelowSubnominalAggregationExistsInTheDataStore(TransformedTable table)
        {
            var expectedSubNomAggregations = table.Rows.Select(row => new Payment
            {
                Ukprn = int.Parse(row["UKPRN"]),
                OrganisationId = row["Org ID"],
                AllocationNumber = GetAllocationNumber(row["Allocation Number"]),
                SubnominalCode = row["Subnominal Code"],
                FundingStreamPeriodCode = row["Funding Stream Period Code"],
                Period = row["Calendar Year/Period"],
                PeriodTypeCode = row["PeriodTypeCode"],
                SubnominalType = row["Payment Type"],
                AggregatedValue = decimal.Parse(row["AggregatedValue"]),
                PostedFlag = bool.Parse(row["Posted Flag"])
            }).ToList();

            expectedSubNomAggregations.ForEach(expectedSubnominal =>
            {
                CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
                {
                    var subnominal = SubnominalAggregationRepository.GetSubnominalAggregationKeyForKey(
                    allocationNumber: expectedSubnominal.AllocationNumber,
                    period: expectedSubnominal.Period,
                    subnominalCode: expectedSubnominal.SubnominalCode,
                    paymentType: expectedSubnominal.SubnominalType);

                    return subnominal != null && expectedSubnominal.AggregatedValue == subnominal.AggregatedValue && expectedSubnominal.Ukprn == subnominal.Ukprn && expectedSubnominal.PostedFlag == subnominal.PostedFlag;
                },
                maxNumChecks: 10,
                waitIntervalSeconds: 6
                );

                bool isPresent = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

                Assert.IsTrue(isPresent, $"The PaaS table SubnominalAggregation does not have a row with matching values for this {expectedSubnominal}");
            });
        }

        [Then(@"a file for a contract with Contract Number '(.*)' version '(.*)' for UKPRN '(.*)' exists in sharepoint location '(.*)'")]
        public void ThenAFileForAContractWithContractNumberVersionForUKPRNExistsInSharepointLocation(string contractNumber, string versionNumber, string ukprn, string location)
        {
            string fileName = $"{ukprn}_{contractNumber}_v{versionNumber}.pdf";

            _contractDocumentGenerationPageObject.TargetFileName = fileName;
            _contractDocumentGenerationPageObject.DocumentLocation = location;

            _contractDocumentGenerationPageObject.RemovePdfFromCache();

            Assert.IsTrue(_contractDocumentGenerationPageObject.DoesFileExist(location, fileName), $"output file not found {fileName} in {location}");
        }
        
        private string GetAllocationNumber(string allocationTestString)
        {
            if (allocationTestString.Contains("["))
            {
                string prefix = GetAllocationNumberPrefixFromTestString(allocationTestString);

                return _state.Contract.AllocationNumberPrefixes.First(a => a.Prefix == prefix).AllocationNumber;
            }

            return allocationTestString;
        }

        private static string GetAllocationNumberPrefixFromTestString(string allocationNumberIdentifier)
        {
            string cleanedAllocationNumberIdentifier = allocationNumberIdentifier.Replace("[", string.Empty)
                .Replace("]", string.Empty);

            int indexOfUnderscore = cleanedAllocationNumberIdentifier
                    .IndexOf("_", StringComparison.Ordinal);

            return cleanedAllocationNumberIdentifier.Substring(indexOfUnderscore + 1);
        }

        private string GetSubnominalAggregateKey(string aggregateKeyInTable)
        {
            string aggregateKey = aggregateKeyInTable;

            if (aggregateKeyInTable.Contains("["))
            {
                var regexString = "\\[.*\\]";
                var allocationRefIdentifier = System.Text.RegularExpressions.Regex.Match(aggregateKeyInTable,
                    regexString);
                var replacement = GetAllocationNumber(allocationRefIdentifier.Value);
                aggregateKey = System.Text.RegularExpressions.Regex.Replace(aggregateKeyInTable, regexString, replacement);
            }

            return aggregateKey;
        }

        private class AllocationInfo
        {
            public AllocationInfo(string allocationNumber, Guid? allocationId)
            {
                AllocationNumber = allocationNumber;
                AllocationId = allocationId;
            }

            public string AllocationNumber { get; }

            public Guid? AllocationId { get; }
        }

        private class SimpleSubnominal
        {
            public SimpleSubnominal(string subnominalCode, string subnominalAggregationKey, string paymentType, string fundingStreamPeriodCode, decimal expectedValue, string providerName)
            {
                SubnominalCode = subnominalCode;
                SubnominalAggregationKey = subnominalAggregationKey;
                PaymentType = paymentType;
                FundingStreamPeriodCode = fundingStreamPeriodCode;
                ExpectedValue = expectedValue;
                ProviderName = providerName;
            }

            public string SubnominalCode { get; }

            public string SubnominalAggregationKey { get; }

            public string PaymentType { get; }

            public string FundingStreamPeriodCode { get; }

            public decimal ExpectedValue { get; }

            public string ProviderName { get; }

            public string GetAllocationNumber()
            {
                return SubnominalAggregationKey.Split('_')[1];
            }

            public override string ToString()
            {
                return
                    $"SubnominalCode: {SubnominalCode}, SubnominalAggregationKey: {SubnominalAggregationKey}, PaymentType: {PaymentType}, FundingStreamPeriodCode: {FundingStreamPeriodCode}, ExpectedValue: {ExpectedValue}, ProviderName: {ProviderName}";
            }
        }
    }
}
