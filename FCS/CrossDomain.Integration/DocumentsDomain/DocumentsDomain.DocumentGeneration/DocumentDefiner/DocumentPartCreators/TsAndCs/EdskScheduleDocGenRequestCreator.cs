namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.TsAndCs
{
    using System.Collections.Generic;
    using System.Linq;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Models;
    using DataStore.Repositories;
    using Integration;
    using Repositories;

    public static class EdskScheduleDocGenRequestCreator
    {
        private static readonly IList<string> FundingTypesSupported = new List<string> { "EDSK", "DADA", "19TRN2020", "AEB2021", "SB", "AEB2023" };
        private static readonly IList<DocumentPartCreators.ContractIntent> IntentsSupported = new List<DocumentPartCreators.ContractIntent>
        {
            DocumentPartCreators.ContractIntent.IsAmendment, 
            DocumentPartCreators.ContractIntent.IsNewRevisedNewOrUpdateDraft,
            DocumentPartCreators.ContractIntent.IsNewAmendment
        };

        public const string EdskScheduleOrderPrefix = "1520";

        public static bool IsDocumentPartRequired(contractType contract) => FundingTypesSupported.Contains(contract.fundingType.fundingTypeCode) &&
                                                                            IntentsSupported.Contains(contract.GetIntent());

        public static IDictionary<string, DocumentGenerationRequest> GetDocumentGenerationRequestsWithSortOrder(
            string documentComponentCode,
            string masterContractNumber,
            contractType contract,
            string templateContainer,
            IFundingTypeFundingPeriodContractTypeRepository fundingTypeFundingPeriodContractTypeRepository,
            IFundingStreamPeriodRepository fundingStreamPeriodRepository,
            IFspGroupDocumentTemplateRepository documentTemplateRepository,
            ITemplateRepository templateRepository)
        {
            string fundingTypeCode = contract.fundingType.fundingTypeCode;
            string fundingPeriod = contract.GetFundingPeriod();
            string contractType = contract.contractType1;

            var definedContractTermForProvider = fundingTypeFundingPeriodContractTypeRepository.GetDefinedContractTermForProvider(
                fundingTypeCode, fundingPeriod, contractType);

            var documentGenerationRequestAndSortOrders = GetFspGroupCodes(contract, fundingStreamPeriodRepository)
                .Select(fspGroup =>
                {
                    var documentTemplateConfig = documentTemplateRepository.GetByKeyOrUseDefaultForContractType(
                        fundingTypeCode: fundingTypeCode,
                        fundingPeriodCode: fundingPeriod,
                        documentComponentCode: documentComponentCode,
                        contractType: contractType,
                        fspGroupCode: fspGroup.FSPGroupCode);

                    string templateFilename = templateRepository.GetNameOfTemplateActiveOnDate(
                        templateContainer,
                        documentTemplateConfig.Template,
                        contract.startDate.Value);

                    return new DocumentGenerationRequestAndSortOrder(
                        sortOrder: $"{EdskScheduleOrderPrefix}{documentComponentCode}{fspGroup.DisplayOrder}",
                        documentGenerationRequest: new DocumentGenerationRequest
                        {
                            FspGroupCode = fspGroup.FSPGroupCode,
                            TemplateContainer = templateContainer,
                            TemplateFilename = templateFilename,
                            MergeData = new DocumentGenerationRequestMergeData
                            {
                                MergeFields = new List<MergeFieldType>
                                {
                                    new MergeFieldType("ProviderTerm", definedContractTermForProvider)
                                }
                            }
                        });
                }).ToList();

            return documentGenerationRequestAndSortOrders
                .ToDictionary(d => d.SortOrder, d => d.DocumentGenerationRequest);
        }

        private static IReadOnlyCollection<FSPGroup> GetFspGroupCodes(contractType contract, IFundingStreamPeriodRepository fundingStreamPeriodRepository)
        {
            if (contract.IsAmendment && (contract.IsPeriod("1920") || contract.IsNotification))
            {
                return FSPGroupService.GetFspGroupsNewToTheContract(contract, fundingStreamPeriodRepository);
            }

            IReadOnlyCollection<string> fundingStreamPeriodCodes = contract.GetFspCodesForAllAllocations();

            return fundingStreamPeriodRepository.GetFspGroups(fundingStreamPeriodCodes);
        }

        private class DocumentGenerationRequestAndSortOrder
        {
            public string SortOrder { get; }

            public DocumentGenerationRequest DocumentGenerationRequest { get; }

            public DocumentGenerationRequestAndSortOrder(string sortOrder, DocumentGenerationRequest documentGenerationRequest)
            {
                SortOrder = sortOrder;
                DocumentGenerationRequest = documentGenerationRequest;
            }
        }
    }
}
