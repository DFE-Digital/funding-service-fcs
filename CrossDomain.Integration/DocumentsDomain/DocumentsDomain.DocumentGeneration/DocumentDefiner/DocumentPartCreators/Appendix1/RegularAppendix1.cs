namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix1
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Common;
    using Common.Models;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentConfiguration;
    using Integration;
    using PaymentManagementDomain.PolicyCache.DataStore;
    using PaymentManagementDomain.PolicyCache.DataStore.Model;

    public class RegularAppendix1 : MultipleOrgAppendix1CreatorBase
    {
        private readonly Dictionary<string, int> _topLevelParentDeliverableCodeCache = new Dictionary<string, int>();
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;
        private readonly IPaymentManagementPolicyContext _paymentManagementPolicyContext;
        private readonly IReadOnlyCollection<string> _regularFundingTypeCodes = new List<string> {"MAIN"}; 

        public RegularAppendix1(
            ITemplateRepository templateRepository,
            IDocumentConfigurationSource documentConfigurationSource,
            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository,
            IPaymentManagementPolicyContext paymentManagementPolicyContext)
            : base (templateRepository, documentConfigurationSource)
        {
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _paymentManagementPolicyContext = paymentManagementPolicyContext;
        }

        public override bool IsHeaderDocumentRequired => false;

        protected override Func<contractAllocationsContractAllocation, string> OrderAllocationBy => (ca) =>
        {
            return DocumentConfigurationSource.GetFundingStreamPeriodDisplayOrder(ca).ToString("D2") + ca.startDate.ToString("yyyyMMdd") + ca.description;
        };

        public override string RequiredHeaderDocumentName
        {
            get { throw new ApplicationException("header document requested but do not require one"); }
        }

        public override bool IsDocumentPartRequired(contractType contract)
        {
            return _regularFundingTypeCodes.Contains(contract.fundingType.fundingTypeCode);
        }

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(
            string masterContractNumber,
            contractType contract,
            string templateContainer)
        {
            Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentPartAppendixOne, "Producing Appendix1 {0} document for contract {1}", contract.fundingType.fundingTypeCode, contract.contractNumber);

            string contractDocTemplatePrefix =
                _fundingTypeFundingPeriodQueryRepository.Get(contract.fundingType.fundingTypeCode, contract.GetFundingPeriod()).TemplateName;

            DocumentGenerationRequest request = new DocumentGenerationRequest
            {
                TemplateContainer = templateContainer,
                TemplateFilename = GetNameOfTemplateActiveOnDate(templateContainer, contractDocTemplatePrefix, contract.startDate.GetValueOrDefault()),
                MergeData = CreateDocumentGenerationRequestMergeData(masterContractNumber, contract)
            };

            return new Dictionary<string, DocumentGenerationRequest>
            {
                { "1000", request }
            };
        }

        private DocumentGenerationRequestMergeData CreateDocumentGenerationRequestMergeData(string masterContractNumber, contractType contract)
        {
            UpdateTopLevelParentDeliverableCodeCache(contract.contractAllocations);

            return new DocumentGenerationRequestMergeData
            {
                MergeFields = CreateTopLevelMergeFields(masterContractNumber, contract),
                RepeatingSections = new List<RepeatingSectionType>
                {
                    GetMainTableRepeatingSection(Constants.TemplateMainTableName, contract, _topLevelParentDeliverableCodeCache)
                }
            };
        }

        private List<MergeFieldType> CreateTopLevelMergeFields(string masterContractNumber, contractType contract)
        {
            return new List<MergeFieldType>
            {
                new MergeFieldType("ContractTotal",
                    contract.contractAllocations
                        .SelectMany(ca => ca.contractDeliverables.Where(cd => cd.deliverable.deliverableCode == _topLevelParentDeliverableCodeCache[ca.fundingStreamPeriodCode]))
                        .SelectMany(cd => cd.contractDeliverablePeriods)
                        .Sum(cdp => cdp.plannedValue)
                        .ToString(Constants.DecimalToValueFormat)),
                    new MergeFieldType("MasterContractRef", masterContractNumber),
                    new MergeFieldType("UKPRN", contract.contractor.ukprn.ToString()),
                    new MergeFieldType("OrgName", contract.contractor.legalName)
            };
        }

        private void UpdateTopLevelParentDeliverableCodeCache(List<contractAllocationsContractAllocation> contractAllocations)
        {
            contractAllocations.ForEach(a =>
            {
                if (!_topLevelParentDeliverableCodeCache.ContainsKey(a.fundingStreamPeriodCode))
                {
                    PolicyDeliverable firstParentDeliverable =
                        _paymentManagementPolicyContext.PolicyDeliverables.First(pd =>
                            pd.FundingStreamPeriod == a.fundingStreamPeriodCode && pd.ParentDeliverableCode == null);

                    _topLevelParentDeliverableCodeCache.Add(a.fundingStreamPeriodCode, firstParentDeliverable.DeliverableCode);
                }
            });
        }
    }
}
