namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.TsAndCs
{
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Models;
    using DataStore.Repositories;
    using DocumentConfiguration;
    using Integration;
    using Repositories;
    using Services;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text.RegularExpressions;

    /// <summary>
    /// This type is used to create a document part for both EDSK and DADA funding types, observing template versioning and selected intents.
    /// Within the team this is referred to as 'EDSK style' documentation and represents the style the business are moving towards.
    /// </summary>
    public class EdskTermsAndConditionsDocumentPartCreator : DocumentPartCreator
    {
        private static readonly IList<string> FundingTypesSupported = new List<string> { "EDSK", "DADA", "19TRN2020", "AEB2021", "SB", "AEB2023" };
        private static readonly IList<string> FundingStreamCodeNotSupported = new List<string> { "1619ED", "ALLB", "ALLBC", "ALLF",  "ASFC-ASCL", "ASFC-FCFJ", "STFIG" };

        private readonly IContractDocumentTemplateRepository _documentTemplateRepository;
        private readonly IFundingTypeFundingPeriodContractTypeRepository _fundingTypeFundingPeriodContractTypeRepository;
        private readonly IFundingStreamPeriodRepository _fundingStreamPeriodRepository;
        private readonly ITemplateVersionChecker _templateVersionChecker;

        public EdskTermsAndConditionsDocumentPartCreator(
            ITemplateRepository templateRepository,
            IDocumentConfigurationSource documentConfigurationSource,
            IContractDocumentTemplateRepository documentTemplateRepository,
            IFundingTypeFundingPeriodContractTypeRepository fundingTypeFundingPeriodContractTypeRepository,
            IFundingStreamPeriodRepository fundingStreamPeriodRepository,
            ITemplateVersionChecker templateVersionChecker)
            : base(templateRepository, documentConfigurationSource)
        {
            _documentTemplateRepository = documentTemplateRepository;
            _fundingTypeFundingPeriodContractTypeRepository = fundingTypeFundingPeriodContractTypeRepository;
            _fundingStreamPeriodRepository = fundingStreamPeriodRepository;
            _templateVersionChecker = templateVersionChecker;
        }

        public override bool IsHeaderDocumentRequired => false;

        public override string RequiredHeaderDocumentName => throw new ApplicationException("Header document name requested but not required");

        public override bool IsDocumentPartRequired(contractType contract) => FundingTypesSupported.Contains(contract.fundingType.fundingTypeCode) &&
                                                                              (contract.IsNewRevisedNewOrUpdateDraft || contract.IsNewAmendment || (!contract.IsPeriod("1920") && contract.IsVariation)) &&

    (
        // Check that NONE of the allocations use unsupported Funding Streams
        !contract.contractAllocations
            .Any(x => FundingStreamCodeNotSupported.Contains(x.fundingStream.fundingStreamCode))
        ||

 contract.contractAllocations
            .Any(a => IsAllowedPeriod(a.fundingStreamPeriodCode)));

        /// <summary>
        /// Returns true if the fundingStreamPeriodCode corresponds to an allowed period (<= 2526).
        /// Assumes codes like "ALLB2526", "ALLBC2425", "1619ED2526", etc.
        /// Extracts the trailing number, compares numerically.
        /// </summary>
        private static bool IsAllowedPeriod(string fundingStreamPeriodCode)
        {
            if (string.IsNullOrWhiteSpace(fundingStreamPeriodCode))
                return false;

            // Extract the last contiguous digit group (e.g., "2526" from "ALLB2526")
            var match = Regex.Match(fundingStreamPeriodCode, @"(\d{4})$");
            if (!match.Success)
                return false;

            if (!int.TryParse(match.Value, out int periodNumber))
                return false;

            // Allow up to and including 2526; disallow 2627 onwards
            return periodNumber <= 2526;
        }


        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(
            string masterContractNumber,
            contractType contract,
            string templateContainer)
        {
            ContractDocumentTemplate documentTemplateConfig = _documentTemplateRepository.GetByKey(
                contract.fundingType.fundingTypeCode, contract.GetFundingPeriod(), "TAC", contract.contractType1);
            string templateFilename = GetNameOfTemplateActiveOnDate(templateContainer, documentTemplateConfig.Template, contract.startDate.Value);
            string fullAddress = MergeAddressLines(contract.contractor);
            string companyNo = FormatCompanyNo(contract.contractor.registeredCompanyNumber);

            var definedContractTermForProvider = _fundingTypeFundingPeriodContractTypeRepository.GetDefinedContractTermForProvider(
                contract.fundingType.fundingTypeCode, contract.GetFundingPeriod(), contract.contractType1);

            var fundingStreamPeriodCodes = contract.GetFspCodes();
            var fspGroupDisplayNames = _fundingStreamPeriodRepository.GetFspGroupDisplayNames(fundingStreamPeriodCodes).ToList();
            var fspGroupDisplayNamesFormatted = string.Join(Environment.NewLine, fspGroupDisplayNames);

            var docGenRequests = new Dictionary<string, DocumentGenerationRequest>
            {
                {
                    "1500", // place document part between appendix 1 and appendix 2
                    new DocumentGenerationRequest
                    {
                        TemplateContainer = templateContainer,
                        TemplateFilename = templateFilename,
                        MergeData = new DocumentGenerationRequestMergeData
                        {
                            MergeFields = new List<MergeFieldType>
                            {
                                new MergeFieldType("MasterContractRef", masterContractNumber),
                                new MergeFieldType("ProviderName", contract.contractor.legalName),
                                new MergeFieldType("ProviderAddress", fullAddress),
                                new MergeFieldType("ProviderCompanyNo", companyNo),
                                new MergeFieldType("ProviderTerm", definedContractTermForProvider),
                                new MergeFieldType("FSPGroupList", fspGroupDisplayNamesFormatted),
                                new MergeFieldType("ContractEndDate", contract.endDate?.ToString()),
                            }
                        }
                    }
                }
            };

            return docGenRequests
                .Where(r => _templateVersionChecker.ShouldIncludeTemplate(r.Value.TemplateFilename, contract.LatestCreatedDateForNonNotificationApprovedContract, contract.IsVariation))
                .ToDictionary(r => r.Key, r => r.Value);
        }

        private static string MergeAddressLines(Contractor contractor)
        {
            return ConditionallyAddAddressLine(contractor.addressLine1) +
                   ConditionallyAddAddressLine(contractor.addressLine2) +
                   ConditionallyAddAddressLine(contractor.addressLine3) +
                   ConditionallyAddAddressLine(contractor.addressLine4) +
                   ConditionallyAddAddressLine(contractor.town) +
                   ConditionallyAddAddressLine(contractor.county) +
                   ConditionallyAddAddressLine(contractor.postcode);
        }

        private static string ConditionallyAddAddressLine(string addressLine)
        {
            return string.IsNullOrEmpty(addressLine) ? string.Empty : addressLine + Environment.NewLine;
        }

        private static string FormatCompanyNo(string registeredCompanyNumber)
        {
            return string.IsNullOrEmpty(registeredCompanyNumber) ? string.Empty : "Company No: " + registeredCompanyNumber;
        }
    }
}