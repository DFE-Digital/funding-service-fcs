namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Common.Models;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentConfiguration;
    using Extensions;
    using Integration;

    public class NcsSchedule6DocumentPartCreator : DocumentPartCreator
    {
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;

        public static readonly IReadOnlyCollection<string> Schedule6Periods = new List<string>{"1819", "1920", "2021","2122","2022"};

        public NcsSchedule6DocumentPartCreator(ITemplateRepository templateRepository,
                            IDocumentConfigurationSource documentConfigurationSource,
                            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository)
            : base(templateRepository, documentConfigurationSource)
        {
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
        }

        public override bool IsHeaderDocumentRequired => false;

        public override string RequiredHeaderDocumentName
        {
            get
            {
                throw new InvalidOperationException("NcsSchedule6DocumentPartCreator was asked for a header document name but said it didn't need one.");
            }
        }

        public override bool IsDocumentPartRequired(contractType contract)
        {
            return contract.fundingType.fundingTypeCode == "NCS" && Schedule6Periods.Contains(contract.period.period1);
        }

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(string masterContractNumber, contractType contract, string templateContainer)
        {
            string contractDocTemplatePrefix =
                _fundingTypeFundingPeriodQueryRepository.Get(
                    contract.fundingType.fundingTypeCode,
                    contract.GetFundingPeriod())
                .TemplateName;

            var allocationNcsDev1819 = GetContractAllocationByFsp("NCS-DEV1819", contract);

            DocumentGenerationRequest documentGenerationRequest = new DocumentGenerationRequest
            {
                TemplateContainer = templateContainer,
                TemplateFilename = GetNameOfTemplateActiveOnDate(templateContainer, contractDocTemplatePrefix, contract.startDate.GetValueOrDefault()),
                MergeData = new DocumentGenerationRequestMergeData
                {
                    MergeFields = new List<MergeFieldType>
                    {
                        new MergeFieldType("ContractTotal", contract.contractValue.ToString()),
                        new MergeFieldType("NCSCDel6Volume", GetContractAllocationByFsp("NCS-C1819", contract).GetDeliverableVolume(6)),

                        new MergeFieldType("PROVIDERNAME", contract.contractor.legalName),
                        new MergeFieldType("NCSVDel1Jan19Value", allocationNcsDev1819.GetDeliverablePeriodPlannedValue(deliverableCode: 1, year: 2019, period: 1)),
                        new MergeFieldType("NCSVDel1Feb19Value", allocationNcsDev1819.GetDeliverablePeriodPlannedValue(deliverableCode: 1, year: 2019, period: 2)),
                        new MergeFieldType("NCSVDel1Mar19Value", allocationNcsDev1819.GetDeliverablePeriodPlannedValue(deliverableCode: 1, year: 2019, period: 3)),
                        new MergeFieldType("NCSVDel1TotalValue", allocationNcsDev1819.GetAllocationValue())
                    }
                }
            };

            return new Dictionary<string, DocumentGenerationRequest>()
            {
                { "1000", documentGenerationRequest }
            };
        }

        private static contractAllocationsContractAllocation GetContractAllocationByFsp(string fundingStreamPeriodCode, contractType contract)
        {
            if (contract.period.period1 == "1819")
            {
                return contract.contractAllocations.SingleOrDefault(ca => ca.fundingStreamPeriodCode == fundingStreamPeriodCode);
            }

            return contract.contractAllocations.Single();

        }
    }
}
