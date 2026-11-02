namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix1
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Common.Models;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentConfiguration;
    using Integration;

    public class ESFAppendix1 : DocumentPartCreator
    {
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;

        public ESFAppendix1(ITemplateRepository templateRepository,
                            IDocumentConfigurationSource documentConfigurationSource,
                            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository)
            : base (templateRepository, documentConfigurationSource)
        {
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
        }

        public override bool IsHeaderDocumentRequired => false;

        public override string RequiredHeaderDocumentName
        {
            get { throw new ApplicationException("ESF Appendix1 was asked for a header document name but said it didn't need one."); }
        }

        public override bool IsDocumentPartRequired(contractType contract)
        {
            var result = contract.fundingType.fundingTypeCode == "ESF";
            return result;
        }

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(
            string masterContractNumber,
            contractType contract,
            string templateContainer)
        {
            string contractDocTemplatePrefix =
                _fundingTypeFundingPeriodQueryRepository.Get(
                    contract.fundingType.fundingTypeCode,
                    contract.GetFundingPeriod())
                .TemplateName;

            var request = new DocumentGenerationRequest()
            {
                TemplateContainer = templateContainer,
                // Changed for Nullable start and end date
                TemplateFilename = GetNameOfTemplateActiveOnDate(templateContainer, contractDocTemplatePrefix, contract.startDate.GetValueOrDefault()),
                MergeData = new DocumentGenerationRequestMergeData()
                {
                    MergeFields = new List<MergeFieldType>()
                    {
                        new MergeFieldType("MasterContractRef", masterContractNumber),
                        new MergeFieldType("ContractTotal", contract.contractAllocations.Sum(ca => ca.maximumContractValue).ToString(Common.Constants.DecimalToValueFormat)),
                        new MergeFieldType("UKPRN", contract.contractor.ukprn.ToString()),
                        new MergeFieldType("OrgName", contract.contractor.legalName)
                    },
                    RepeatingSections = new List<RepeatingSectionType>()
                    {
                        new RepeatingSectionType(Common.Constants.TemplateMainTableName)
                        {
                            Rows = new List<RowType>(
                                from allocation in contract.contractAllocations
                                orderby string.Format("{0:yyyy-MM-dd}-{1}", allocation.startDate, allocation.description)
                                select new RowType()
                                {
                                    MergeFields = new List<MergeFieldType>()
                                    {
                                        new MergeFieldType("AllocationName", allocation.description),
                                        new MergeFieldType("AllocationContractRef", allocation.contractAllocationNumber),
                                        new MergeFieldType("AllocationStartDate", allocation.startDate.ToString("yyyy-MM-dd")),
                                        new MergeFieldType("AllocationEndDate", allocation.endDate?.ToString("yyyy-MM-dd") ?? string.Empty),
                                        new MergeFieldType("AllocationTotal", allocation.maximumContractValue.ToString(Common.Constants.DecimalToValueFormat))
                                    }
                                })
                        }
                    }
                }
            };

            return new Dictionary<string, DocumentGenerationRequest>()
            {
                { "1000", request }
            };
        }
    }
}
