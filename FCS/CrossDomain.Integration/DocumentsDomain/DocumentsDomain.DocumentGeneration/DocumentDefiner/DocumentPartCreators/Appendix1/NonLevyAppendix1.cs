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
    using SFA.FCT.DocumentsDomain.Common;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;

    public class NonLevyAppendix1 : DocumentPartCreator
    {
        private readonly Dictionary<string, int> _nonLevyLegalDeliverableCode = new Dictionary<string, int>();

        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;

        private readonly IPaymentManagementPolicyContext _paymentManagementPolicyContext;

        public NonLevyAppendix1(ITemplateRepository templateRepository,
                            IDocumentConfigurationSource documentConfigurationSource,
                            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository,
                            IPaymentManagementPolicyContext paymentManagementPolicyContext)
            : base (templateRepository, documentConfigurationSource)
        {
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _paymentManagementPolicyContext = paymentManagementPolicyContext;
        }

        public override bool IsHeaderDocumentRequired => false;

        public override string RequiredHeaderDocumentName
        {
            get { throw new ApplicationException("header document requested but do not require one"); }
        }

        public override bool IsDocumentPartRequired(contractType contract)
        {
            var result = contract.fundingType.fundingTypeCode == "NONLEVY";
            return result;
        }

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(
            string masterContractNumber,
            contractType contract,
            string templateContainer)
        {
            Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentPartAppendixOne, "Producing Appendix1 NonLevy document for contract {0}", contract.contractNumber);
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
                MergeData = CreateDocumentGenerationRequestMergeData(masterContractNumber, contract)
            };
            return new Dictionary<string, DocumentGenerationRequest>()
            {
                { "1000", request }
            };
        }

        private DocumentGenerationRequestMergeData CreateDocumentGenerationRequestMergeData(string masterContractNumber, contractType contract)
        {
            UpdateNonLevyLegalDeliverableCodeCache(contract.contractAllocations);

            return new DocumentGenerationRequestMergeData()
            {
                MergeFields = CreateTopLevelMergeFields(masterContractNumber, contract),
                RepeatingSections = CreateTopLevelRepeatingSection(contract)
            };
        }

        private List<MergeFieldType> CreateTopLevelMergeFields(string masterContractNumber, contractType contract)
        {
            return new List<MergeFieldType>()
            {
                new MergeFieldType(
                    "ContractTotal",
                    contract
                        .contractAllocations
                        .Where(DocumentConfigurationSource.ShouldDisplayAllocationOnSummaryOfFunding)
                        .SelectMany(ca => ca.contractDeliverables
                        .Where(cd => cd.deliverable.deliverableCode == _nonLevyLegalDeliverableCode[ca.fundingStreamPeriodCode]))
                        .SelectMany(cd => cd.contractDeliverablePeriods)
                        .Sum(cdp => cdp.plannedValue).ToString(Constants.DecimalToValueFormat)),
                    new MergeFieldType("MasterContractRef", masterContractNumber),
                    new MergeFieldType("UKPRN", contract.contractor.ukprn.ToString()),
                    new MergeFieldType("OrgName", contract.contractor.legalName)
            };
        }

        private List<RepeatingSectionType> CreateTopLevelRepeatingSection(contractType contract)
        {
            int periodStartYear = GetStartYearFromPeriod(contract.period);
            int periodEndYear = GetEndYearFromPeriod(contract.period);

            return new List<RepeatingSectionType>()
            {
                new RepeatingSectionType(Constants.TemplateMainTableName)
                {
                    Rows = new List<RowType>(
                        contract
                        .contractAllocations
                        .Where(DocumentConfigurationSource.ShouldDisplayAllocationOnSummaryOfFunding)
                        .OrderBy(ca => DocumentConfigurationSource.GetFundingStreamPeriodDisplayOrder(ca).ToString("D2") + ca.startDate.ToString("yyyyMMdd") + ca.description)
                        .SelectMany(ca =>
                        {
                            Logger.LogVerbose("Adding allocation {0} to the appendix 1 document", ca.contractAllocationNumber);

                            var tempRows = new List<RowType>()
                            {
                                new RowType()
                                {
                                    MergeFields = new List<MergeFieldType>
                                    {
                                        new MergeFieldType("Column1", DocumentConfigurationSource.GetAllocationName(ca)),
                                        new MergeFieldType("Column2", ca.contractAllocationNumber),
                                        new MergeFieldType(
                                            "Column3",
                                            ca.contractDeliverables
                                                .Where(cd => cd.deliverable.deliverableCode == _nonLevyLegalDeliverableCode[ca.fundingStreamPeriodCode])
                                                .SelectMany(cd => cd.contractDeliverablePeriods)
                                                .Where(cdp => IsInFyOne(cdp, periodStartYear, periodEndYear))
                                                .Sum(cdp => cdp.plannedValue)
                                                .ToString(Constants.DecimalToValueFormat)),
                                        new MergeFieldType(
                                            "Column4",
                                            ca.contractDeliverables
                                                .Where(cd => cd.deliverable.deliverableCode == _nonLevyLegalDeliverableCode[ca.fundingStreamPeriodCode])
                                                .SelectMany(cd => cd.contractDeliverablePeriods)
                                                .Where(cdp => IsInFyTwo(cdp, periodStartYear, periodEndYear))
                                                .Sum(cdp => cdp.plannedValue)
                                                .ToString(Constants.DecimalToValueFormat)),
                                        new MergeFieldType(
                                            "Column5",
                                            ca.contractDeliverables
                                                .Where(cd => cd.deliverable.deliverableCode == _nonLevyLegalDeliverableCode[ca.fundingStreamPeriodCode])
                                                .SelectMany(cd => cd.contractDeliverablePeriods)
                                                .Sum(cdp => cdp.plannedValue)
                                                .ToString(Constants.DecimalToValueFormat))
                                    }
                                }
                            };

                            Logger.LogVerbose("Allocation {0} added {1} rows to the document", ca.contractAllocationNumber, tempRows.Count);

                            return tempRows;
                        }))
                }
            };
        }
        private void UpdateNonLevyLegalDeliverableCodeCache(List<contractAllocationsContractAllocation> contractAllocations)
        {
            contractAllocations.ForEach(m =>
            {
                if (!_nonLevyLegalDeliverableCode.ContainsKey(m.fundingStreamPeriodCode))
                {
                    AddNonLevyLegalDeliverableCodeToPrivateDictionary(m);
                }
            }
           );
        }

        private void AddNonLevyLegalDeliverableCodeToPrivateDictionary(contractAllocationsContractAllocation contractAllocation)
        {
            _nonLevyLegalDeliverableCode.Add(contractAllocation.fundingStreamPeriodCode, _paymentManagementPolicyContext.PolicyDeliverables.
                First(pd => pd.FundingStreamPeriod == contractAllocation.fundingStreamPeriodCode && pd.ParentDeliverableCode == null).DeliverableCode);
        }
    }
}