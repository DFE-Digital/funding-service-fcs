namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.TsAndCs
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using Common.Models;
    using DocumentConfiguration;
    using Integration;
    using ContractManagement.DataStore.Repositories;
    using Extensions;
    using ContractManagement.DataStore.Model;

    public class LEVYTermsAndConditionsDocumentPartCreator : DocumentPartCreator
    {
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;

        public LEVYTermsAndConditionsDocumentPartCreator(ITemplateRepository templateRepository,
                            IDocumentConfigurationSource documentConfigurationSource,
                            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository)
            : base (templateRepository, documentConfigurationSource)
        {
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
        }

        public override bool IsHeaderDocumentRequired => false;

        public override string RequiredHeaderDocumentName => throw new ApplicationException("Levy Terms and Conditions was asked for a header document name but said it didn't need one.");

        public override bool IsDocumentPartRequired(contractType contract)
        {
            var result = contract.fundingType.fundingTypeCode == "LEVY";

            return result;
        }

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(
           string masterContractNumber,
           contractType contract,
           string templateContainer)
        {
            IReadOnlyCollection<TemplateInfo> templatesToGenerate = GetTemplateInfosToGenerate(contract);

            string fullAddress = MergeAddressLines(contract.contractor);
            var terminationDate = string.Empty;
            if (contract.IsLastApprovedUnderTermination && contract.LastApprovedTerminationDate.HasValue)
            {
                terminationDate = contract.LastApprovedTerminationDate.Value.ToString("d MMMM yyyy");
            }

            if (contract.contractAllocations != null && contract.contractAllocations.Any())
            {
                return templatesToGenerate.Select(t => new
                {
                    t.TemplateOrder, DocGenReq = new DocumentGenerationRequest
                    {
                        TemplateContainer = templateContainer,

                        TemplateFilename = GetNameOfTemplateActiveOnDate(
                            templateContainer,
                            t.TemplatePrefix,
                            contract.startDate.GetValueOrDefault()),

                        MergeData = new DocumentGenerationRequestMergeData()
                        {
                            MergeFields = new List<MergeFieldType>()
                            {
                                new MergeFieldType("UKPRN", contract.contractor.ukprn.ToString()),
                                new MergeFieldType("OrgName", contract.contractor.legalName),
                                new MergeFieldType("CompanyNumber",
                                    contract.contractor.registeredCompanyNumber.AddPrefixIfNotEmpty("Company No: ")),
                                new MergeFieldType("ProviderAddress", fullAddress),
                                new MergeFieldType("LegalAddress", contract.contractor.GetLegalAddressCsv()),
                                new MergeFieldType("MasterContractRef", masterContractNumber),
                                new MergeFieldType("TerminationDate", terminationDate),
                            }
                        }
                    }
                }).ToDictionary(t => t.TemplateOrder, t => t.DocGenReq);
            }

            return new Dictionary<string, DocumentGenerationRequest>();
        }

        private static string MergeAddressLines(contractor contractor)
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

        private IReadOnlyCollection<TemplateInfo> GetTemplateInfosToGenerate(contractType contract)
        {
            FundingTypeFundingPeriod fundingTypeFundingPeriod = _fundingTypeFundingPeriodQueryRepository.Get(contract.fundingType.fundingTypeCode, contract.GetFundingPeriod());

            if (contract.IsAmendment && contract.ShouldMergeAmendmentTemplate)
            {
                var amendmentTemplate =
                    contract.OverrideAmendmentTemplate.GetValueOrDefault(fundingTypeFundingPeriod.AmendmentTemplate);

                var templateName =
                    contract.OverrideTemplateName.GetValueOrDefault(fundingTypeFundingPeriod.TemplateName);
                return new List<TemplateInfo>
                {
                    new TemplateInfo(amendmentTemplate, templateOrder: "1000"),
                    new TemplateInfo(templateName, templateOrder: "1001"),
                };
            }

            string templatePrefix = contract.IsAmendment ? contract.OverrideAmendmentTemplate.GetValueOrDefault(fundingTypeFundingPeriod.AmendmentTemplate)
                : fundingTypeFundingPeriod.TemplateName;

            return new List<TemplateInfo>
            {
                new TemplateInfo(templatePrefix, templateOrder: "1000"),
            };
        }

        private class TemplateInfo
        {
            public TemplateInfo(string templatePrefix, string templateOrder)
            {
                TemplatePrefix = templatePrefix;
                TemplateOrder = templateOrder;
            }

            public string TemplatePrefix { get; }

            public string TemplateOrder { get; }
        }
    }
}
