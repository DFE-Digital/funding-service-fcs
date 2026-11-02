namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.TsAndCs
{
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
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
    public class EdskSchedule2DocumentPartCreator : DocumentPartCreator
    {
        private static readonly IList<string> FundingStreamCodeNotSupported = new List<string> { "1619ED", "ALLB", "ALLBC", "ALLF",  "ASFC-ASCL", "ASFC-FCFJ", "STFIG" };
        private readonly IFspGroupDocumentTemplateRepository _documentTemplateRepository;
        private readonly IFundingTypeFundingPeriodContractTypeRepository _fundingTypeFundingPeriodContractTypeRepository;
        private readonly ITemplateRepository _templateRepository;
        private readonly IFundingStreamPeriodRepository _fundingStreamPeriodRepository;
        private readonly ITemplateVersionChecker _templateVersionChecker;

        public EdskSchedule2DocumentPartCreator(
            ITemplateRepository templateRepository,
            IDocumentConfigurationSource documentConfigurationSource,
            IFspGroupDocumentTemplateRepository documentTemplateRepository,
            IFundingTypeFundingPeriodContractTypeRepository fundingTypeFundingPeriodContractTypeRepository,
            IFundingStreamPeriodRepository fundingStreamPeriodRepository,
            ITemplateVersionChecker templateVersionChecker)
            : base(templateRepository, documentConfigurationSource)

        {
            _documentTemplateRepository = documentTemplateRepository;
            _fundingTypeFundingPeriodContractTypeRepository = fundingTypeFundingPeriodContractTypeRepository;
            _fundingStreamPeriodRepository = fundingStreamPeriodRepository;
            _templateRepository = templateRepository;
            _templateVersionChecker = templateVersionChecker;
        }

        public override bool IsHeaderDocumentRequired => false;
        public override string RequiredHeaderDocumentName => throw new ApplicationException("Header document name requested but not required");
        public override bool IsDocumentPartRequired(contractType contract) => EdskScheduleDocGenRequestCreator.IsDocumentPartRequired(contract) &&
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
            var docGenRequests = EdskScheduleDocGenRequestCreator.GetDocumentGenerationRequestsWithSortOrder(
                "S2",
                masterContractNumber,
                contract,
                templateContainer,
                _fundingTypeFundingPeriodContractTypeRepository,
                _fundingStreamPeriodRepository,
                _documentTemplateRepository,
                _templateRepository);

            return docGenRequests
                .Where(r => ShouldIncludeTemplate(r.Value, contract))
                .ToDictionary(r => r.Key, r => r.Value);
        }

        private bool ShouldIncludeTemplate(DocumentGenerationRequest documentGenerationRequest, contractType contract)
        {
            return HasFspGroupBeenAddedSinceLastApprovedContract(documentGenerationRequest.FspGroupCode, contract, _fundingStreamPeriodRepository)
                   || _templateVersionChecker.ShouldIncludeTemplate(documentGenerationRequest.TemplateFilename, contract.LatestCreatedDateForNonNotificationApprovedContract, contract.IsVariation);
        }

        private static bool HasFspGroupBeenAddedSinceLastApprovedContract(string fspGroupCode, contractType contract, IFundingStreamPeriodRepository fundingStreamPeriodRepository)
        {
            return FSPGroupService.GetFspGroupsNewToTheContract(contract, fundingStreamPeriodRepository).Any(fspGroup => fspGroup.FSPGroupCode == fspGroupCode);
        }
    }
}