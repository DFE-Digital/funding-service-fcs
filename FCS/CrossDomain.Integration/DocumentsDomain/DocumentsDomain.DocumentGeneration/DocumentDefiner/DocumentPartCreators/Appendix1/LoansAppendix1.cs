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
    using PaymentManagementDomain.PolicyCache.DataStore;

    public class LoansAppendix1 : MultipleOrgAppendix1CreatorBase
    {
        private static readonly IReadOnlyCollection<string> FundingTypeCodesForThisAppendix = new List<string> { "24+LOANS", "LOANS" };
        private readonly Dictionary<string, int> _deliverableCodesForFundingStreamPeriod = new Dictionary<string, int>();

        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;

        private readonly IPaymentManagementPolicyContext _paymentManagementPolicyContext;

        protected override Func<contractAllocationsContractAllocation, string> OrderAllocationBy => ca =>
            DocumentConfigurationSource.GetFundingStreamPeriodDisplayOrder(ca).ToString("D2");

        public LoansAppendix1(ITemplateRepository templateRepository,
                            IDocumentConfigurationSource documentConfigurationSource,
                            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository,
                            IPaymentManagementPolicyContext paymentManagementPolicyContext)
            : base(templateRepository, documentConfigurationSource)
        {
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _paymentManagementPolicyContext = paymentManagementPolicyContext;
        }

        public override bool IsHeaderDocumentRequired => false;

        public override string RequiredHeaderDocumentName
        {
            get { throw new ApplicationException("This should not have been called as IsHeaderDocumentRequired return false."); }
        }

        public override bool IsDocumentPartRequired(contractType contract)
        {
            return FundingTypeCodesForThisAppendix.Contains(contract.fundingType.fundingTypeCode);
        }

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(
            string masterContractNumber,
            contractType contract,
            string templateContainer)
        {
            Update24PlusLegalDeliverableCodeCache(contract.contractAllocations);
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
                        new MergeFieldType(
                            "ContractTotal",
                            contract.contractAllocations
                                .SelectMany(ca => ca.contractDeliverables
                                .Where(cd => cd.deliverable.deliverableCode == _deliverableCodesForFundingStreamPeriod[ca.fundingStreamPeriodCode]))
                                .SelectMany(cd => cd.contractDeliverablePeriods)
                                .Sum(cdp => cdp.plannedValue).ToString(Common.Constants.DecimalToValueFormat)),
                        new MergeFieldType("UKPRN", contract.contractor.ukprn.ToString()),
                        new MergeFieldType("OrgName", contract.contractor.legalName)
                    },
                    RepeatingSections = new List<RepeatingSectionType>()
                    {
                        GetMainTableRepeatingSection(Common.Constants.TemplateMainTableName, contract, _deliverableCodesForFundingStreamPeriod)
                    }
                }
            };

            return new Dictionary<string, DocumentGenerationRequest>()
            {
                { "1000", request }
            };
        }

        private void Update24PlusLegalDeliverableCodeCache(List<contractAllocationsContractAllocation> contractAllocations)
        {
            contractAllocations.ForEach(m =>
            {
                if (!_deliverableCodesForFundingStreamPeriod.ContainsKey(m.fundingStreamPeriodCode))
                {
                    Add24PlusLegalDeliverableCodeToPrivateDictionary(m);
                }
            }
           );
        }

        private void Add24PlusLegalDeliverableCodeToPrivateDictionary(contractAllocationsContractAllocation contractAllocation)
        {
            _deliverableCodesForFundingStreamPeriod.Add(contractAllocation.fundingStreamPeriodCode, _paymentManagementPolicyContext.PolicyDeliverables.
                First(pd => pd.FundingStreamPeriod == contractAllocation.fundingStreamPeriodCode && pd.ParentDeliverableCode == null).DeliverableCode);
        }
    }
}