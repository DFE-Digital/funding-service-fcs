namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators
{
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Repositories;
    using DocumentConfiguration;
    using Integration;
    using SFA.FCT.DocumentsDomain.DocumentGeneration.Services;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text.RegularExpressions;

    public class Schedule3DocumentPartCreator : DocumentPartCreator
    {
        private static readonly IList<string> FundingStreamCodeNotSupported = new List<string> { "1619ED", "ALLB", "ALLBC", "ALLF",  "ASFC-ASCL" , "ASFC-FCFJ", "STFIG" };
        private static readonly IList<string> FundingTypesSupported = new List<string> { "EDSK", "DADA", "19TRN2020", "AEB2021", "SB", "AEB2023" };
        private readonly IContractDocumentTemplateRepository _documentTemplateRepository;
        private readonly ITemplateVersionChecker _templateVersionChecker;

        public Schedule3DocumentPartCreator(
            ITemplateRepository templateRepository,
            IDocumentConfigurationSource documentConfigurationSource,
            IContractDocumentTemplateRepository documentTemplateRepository,
            ITemplateVersionChecker templateVersionChecker)
            : base(templateRepository, documentConfigurationSource)
        {
            _documentTemplateRepository = documentTemplateRepository;
            _templateVersionChecker = templateVersionChecker;
        }

        public override bool IsHeaderDocumentRequired => false;

        public override string RequiredHeaderDocumentName => throw new InvalidOperationException("The header document is not required");

        public override bool IsDocumentPartRequired(contractType contract) => FundingTypesSupported.Contains(contract.fundingType.fundingTypeCode) &&
                                                                              (contract.IsNewRevisedNewOrUpdateDraft ||
                                                                               contract.IsNewAmendment ||
                                                                               (!contract.IsPeriod("1920") && contract.IsVariation)) &&
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

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(string masterContractNumber, contractType contract,
            string templateContainer)
        {
            string templatePrefix = _documentTemplateRepository.GetByKey(contract.fundingType.fundingTypeCode,
                contract.GetFundingPeriod(), "S3ON", contract.contractType1).Template;

            var docGenRequests = new Dictionary<string, DocumentGenerationRequest>
            {
                { "3000", new DocumentGenerationRequest
                    {
                        TemplateContainer = templateContainer,
                        TemplateFilename =  GetNameOfTemplateActiveOnDate(templateContainer, templatePrefix, contract.startDate.GetValueOrDefault())
                    }
                }
            };

            return docGenRequests
                .Where(r => _templateVersionChecker.ShouldIncludeTemplate(r.Value.TemplateFilename, contract.LatestCreatedDateForNonNotificationApprovedContract, contract.IsVariation))
                .ToDictionary(r => r.Key, r => r.Value);
        }
    }
}
