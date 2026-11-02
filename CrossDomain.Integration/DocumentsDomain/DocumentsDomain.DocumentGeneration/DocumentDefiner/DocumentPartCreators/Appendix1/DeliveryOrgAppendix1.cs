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

    public class DeliveryOrgAppendix1 : DocumentPartCreator
    {
        private static readonly IReadOnlyCollection<string> FundingTypeCodesForThisAppendix = new List<string>
        {
            "AEB", "MAIN", "LOANS"
        };

        private const string DeliveryOrgTemplateMarker = "DELIVERYORG";

        // "200" prefix ensures it is in the range of appendix 2 docs
        // {0} is 1 if allocation is for the "parent" org, 2 if not
        // {1} is the provider name
        private const string OrderFormatString = "200{0}-{1}";

        private readonly Dictionary<string, int> _topLevelParentDeliverableCodeCache = new Dictionary<string, int>();

        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;
        private readonly IPaymentManagementPolicyContext _paymentManagementPolicyContext;

        public DeliveryOrgAppendix1(ITemplateRepository templateRepository, IDocumentConfigurationSource documentConfigurationSource, IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository, IPaymentManagementPolicyContext paymentManagementPolicyContext) 
            : base(templateRepository, documentConfigurationSource)
        {
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _paymentManagementPolicyContext = paymentManagementPolicyContext;
        }

        public override bool IsHeaderDocumentRequired => false;

        public override string RequiredHeaderDocumentName => throw new ApplicationException("header document requested but do not require one");

        public override bool IsDocumentPartRequired(contractType contract)
        {
            return FundingTypeCodesForThisAppendix.Contains(contract.fundingType.fundingTypeCode)
                && contract.contractAllocations.Any(ca => AllocationIsForNonContractingDeliveryOrg(ca, contract.contractor));
        }

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(string masterContractNumber, contractType contract,
            string templateContainer)
        {
            UpdateTopLevelParentDeliverableCodeCache(contract.contractAllocations);

            string contractDocTemplatePrefix =
                _fundingTypeFundingPeriodQueryRepository.Get(
                        contract.fundingType.fundingTypeCode,
                        contract.GetFundingPeriod())
                    .TemplateName;

            string deliveryOrgTemplatePrefix = $"{contractDocTemplatePrefix}_{DeliveryOrgTemplateMarker}";

            string templateFilename = GetNameOfTemplateActiveOnDate(templateContainer, deliveryOrgTemplatePrefix, contract.startDate.GetValueOrDefault());

            return contract.contractAllocations
                .GroupBy(ca => ca.DeliveryOrganisation)
                .Select(g => new KeyValuePair<string, DocumentGenerationRequest>(
                    GetOrderString(g.First(), contract.contractor),
                    GetDocumentGenerationRequest(
                        contract: contract,
                        allocationsForOrganisation: g.ToList(),
                        masterContractNumber: masterContractNumber,
                        templateContainer: templateContainer,
                        templateFilename: templateFilename)))
                .ToDictionary(kvp => kvp.Key, kvp => kvp.Value);
        }

        private string GetOrderString(contractAllocationsContractAllocation allocation, contractor contractingProvider)
        {
            return string.Format(
                OrderFormatString,
                AllocationIsForNonContractingDeliveryOrg(allocation, contractingProvider) ? "2" : "1",
                allocation.HasDeliveryOrganisation() ? allocation.DeliveryOrganisationDetail.legalName : contractingProvider.legalName);
        }

        private DocumentGenerationRequest GetDocumentGenerationRequest(
            contractType contract,
            IReadOnlyCollection<contractAllocationsContractAllocation> allocationsForOrganisation,
            string masterContractNumber,
            string templateContainer, 
            string templateFilename)
        {
            int periodStartYear = GetStartYearFromPeriod(contract.period);
            int periodEndYear = GetEndYearFromPeriod(contract.period);

            bool hasDeliveryOrganisation = allocationsForOrganisation.First().HasDeliveryOrganisation();

            string ukprn = hasDeliveryOrganisation
                ? allocationsForOrganisation.First().DeliveryOrganisation
                : contract.contractor.ukprn.ToString();

            string organisationName = hasDeliveryOrganisation
                ? allocationsForOrganisation.First().DeliveryOrganisationDetail.legalName
                : contract.contractor.legalName;

            List<RowType> rows = allocationsForOrganisation
                .OrderBy(a =>
                    DocumentConfigurationSource.GetFundingStreamPeriodDisplayOrder(a).ToString("D2") +
                    a.startDate.ToString("yyyyMMdd") + a.description)
                .Select(a => new
                {
                    Allocation = a,
                    ParentDeliverablePeriods = a.GetAllDeliverables()
                        .Where(d => d.deliverable.deliverableCode ==
                                    _topLevelParentDeliverableCodeCache[a.fundingStreamPeriodCode])
                        .SelectMany(d => d.contractDeliverablePeriods)
                })
                .Select(x => new RowType
                {
                    MergeFields = new List<MergeFieldType>
                    {
                        new MergeFieldType("AllocationName",
                            DocumentConfigurationSource.GetAllocationName(x.Allocation)),
                        new MergeFieldType("AllocationContractRef", x.Allocation.contractAllocationNumber),
                        new MergeFieldType("AllocationPeriodOneTotal", GetFormattedTotalValue(
                            x.ParentDeliverablePeriods, cdp => IsInFyOne(cdp, periodStartYear, periodEndYear))),
                        new MergeFieldType("AllocationPeriodTwoTotal", GetFormattedTotalValue(
                            x.ParentDeliverablePeriods, cdp => IsInFyTwo(cdp, periodStartYear, periodEndYear))),
                        new MergeFieldType("AllocationTotal",
                            GetFormattedTotalValue(x.ParentDeliverablePeriods, cdp => true))
                    }
                })
                .ToList();

            rows.AddRange(
                allocationsForOrganisation.SelectMany(a => a.contractDeliverables
                    .Where(d => DocumentConfigurationSource.ShouldDisplayDeliverableOnSummaryOfFunding(a, d))
                    .Select(d => new RowType
                    {
                        MergeFields = new List<MergeFieldType>
                        {
                            new MergeFieldType("AllocationName",
                                Constants.SubRowMarker + Constants.IndentTextMarker + DocumentConfigurationSource.GetDeliverableNameForSummaryOfFunding(a, d.deliverable.deliverableCode)),
                            new MergeFieldType("AllocationContractRef", string.Empty),
                            new MergeFieldType("AllocationPeriodOneTotal", GetFormattedTotalValue(
                                d.contractDeliverablePeriods, cdp => IsInFyOne(cdp, periodStartYear, periodEndYear))),
                            new MergeFieldType("AllocationPeriodTwoTotal", GetFormattedTotalValue(
                                d.contractDeliverablePeriods, cdp => IsInFyTwo(cdp, periodStartYear, periodEndYear))),
                            new MergeFieldType("AllocationTotal", GetFormattedTotalValue(d.contractDeliverablePeriods, cdp => true))
                        }
                    })));

            return new DocumentGenerationRequest
            {
                TemplateContainer = templateContainer,
                TemplateFilename = templateFilename,
                MergeData = new DocumentGenerationRequestMergeData
                {
                    MergeFields = new List<MergeFieldType>
                    {
                        new MergeFieldType("MasterContractRef", masterContractNumber),
                        new MergeFieldType(
                            "ContractTotal",
                            allocationsForOrganisation
                                .SelectMany(ca => ca.contractDeliverables
                                    .Where(cd => cd.deliverable.deliverableCode == _topLevelParentDeliverableCodeCache[ca.fundingStreamPeriodCode]))
                                .SelectMany(cd => cd.contractDeliverablePeriods)
                                .Sum(cdp => cdp.plannedValue).ToString(Constants.DecimalToValueFormat)),
                        new MergeFieldType("UKPRN", ukprn),
                        new MergeFieldType("OrgName", organisationName)
                    },
                    RepeatingSections = new List<RepeatingSectionType>
                    {
                        new RepeatingSectionType(Constants.TemplateMainTableName)
                        {
                            Rows = rows
                        }
                    }
                }
            };
        }

        private string GetFormattedTotalValue(IEnumerable<contractDeliverablePeriodsTypeContractDeliverablePeriod> deliverablePeriods, 
            Func<contractDeliverablePeriodsTypeContractDeliverablePeriod, bool> periodFilter)
        {
            return deliverablePeriods
                .Where(periodFilter)
                .Sum(cdp => cdp.plannedValue)
                .ToString(Constants.DecimalToValueFormat);
        }

        private void UpdateTopLevelParentDeliverableCodeCache(List<contractAllocationsContractAllocation> contractAllocations)
        {
            contractAllocations.ForEach(m =>
                {
                    if (!_topLevelParentDeliverableCodeCache.ContainsKey(m.fundingStreamPeriodCode))
                    {
                        _topLevelParentDeliverableCodeCache.Add(
                            m.fundingStreamPeriodCode,
                            _paymentManagementPolicyContext.PolicyDeliverables.First(
                                pd => pd.FundingStreamPeriod == m.fundingStreamPeriodCode 
                                   && pd.ParentDeliverableCode == null).DeliverableCode);
                    }
                }
            );
        }

        private bool AllocationIsForNonContractingDeliveryOrg(contractAllocationsContractAllocation allocation, contractor contractingProvider)
        {
            return allocation.HasDeliveryOrganisation()
                && allocation.DeliveryOrganisation != contractingProvider.ukprn.ToString();
        }
    }
}