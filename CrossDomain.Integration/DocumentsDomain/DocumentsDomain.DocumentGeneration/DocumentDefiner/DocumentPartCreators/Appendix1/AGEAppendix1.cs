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

    public class AGEAppendix1 : DocumentPartCreator
    {
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;

        public AGEAppendix1(ITemplateRepository templateRepository,
                            IDocumentConfigurationSource documentConfigurationSource,
                            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository)
            : base(templateRepository, documentConfigurationSource)
        {
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
        }

        public override bool IsHeaderDocumentRequired => false;

        public override string RequiredHeaderDocumentName
        {
            get { throw new ApplicationException("AGE Appendix1 was asked for a header document name but said it didn't need one."); }
        }

        public override bool IsDocumentPartRequired(contractType contract)
        {
            var result = contract.fundingType.fundingTypeCode == "AGE";

            return result;
        }

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(
            string masterContractNumber,
            contractType contract,
            string templateContainer)
        {
            var response = new Dictionary<string, DocumentGenerationRequest>();
            string contractDocTemplatePrefix =
                _fundingTypeFundingPeriodQueryRepository.Get(
                    contract.fundingType.fundingTypeCode,
                    contract.GetFundingPeriod())
                .TemplateName;

            if (contract.contractAllocations != null && contract.contractAllocations.Any())
            {
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
                            new MergeFieldType("UKPRN", contract.contractor.ukprn.ToString()),
                            new MergeFieldType("OrgName", contract.contractor.legalName),
                            new MergeFieldType("AllocationContractRef", contract.contractAllocations.First().contractAllocationNumber),
                            new MergeFieldType(
                                "ContractTotal",
                                contract.contractAllocations
                                    .SelectMany(ca => ca.contractDeliverables)
                                    .SelectMany(cd => cd.contractDeliverablePeriods)
                                    .Sum(cdp => cdp.plannedValue)
                                    .ToString(Common.Constants.DecimalToValueFormat)),
                            new MergeFieldType(
                                "AGE16-18",
                                contract.contractAllocations
                                    .SelectMany(ca => ca.contractDeliverables)
                                    .Where(cd => cd.deliverable.deliverableCode == 1)
                                    .SelectMany(cd => cd.contractDeliverablePeriods)
                                    .Sum(cdp => cdp.plannedValue)
                                    .ToString(Common.Constants.DecimalToValueFormat)),
                            new MergeFieldType(
                                "AGE19-24",
                                contract.contractAllocations
                                    .SelectMany(ca => ca.contractDeliverables)
                                    .Where(cd => cd.deliverable.deliverableCode == 2)
                                    .SelectMany(cd => cd.contractDeliverablePeriods)
                                    .Sum(cdp => cdp.plannedValue)
                                    .ToString(Common.Constants.DecimalToValueFormat))
                        }
                    }
                };

                response.Add("1000", request);
            }

            return response;
        }
    }
}