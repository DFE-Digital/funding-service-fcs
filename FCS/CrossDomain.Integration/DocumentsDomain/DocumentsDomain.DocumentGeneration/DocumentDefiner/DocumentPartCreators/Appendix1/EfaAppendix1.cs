namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix1
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Common;
    using Common.Models;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Repositories;
    using DocumentConfiguration;
    using Integration;
    using PaymentManagementDomain.PolicyCache.DataStore;

    public class EfaApendix1 : DocumentPartCreator
    {
        private readonly Dictionary<string, int> _mainLegalDeliverableCode = new Dictionary<string, int>();

        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;

        private readonly IPaymentManagementPolicyContext _paymentManagementPolicyContext;

        private readonly IFundingStreamPeriodRepository _fundingStreamPeriodRepository;

        public EfaApendix1(ITemplateRepository templateRepository,
                            IDocumentConfigurationSource documentConfigurationSource,
                            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository,
                            IPaymentManagementPolicyContext paymentManagementPolicyContext,
                            IFundingStreamPeriodRepository fundingStreamPeriodRepository)
            : base(templateRepository, documentConfigurationSource)
        {
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _paymentManagementPolicyContext = paymentManagementPolicyContext;
            _fundingStreamPeriodRepository = fundingStreamPeriodRepository;
        }

        public override bool IsHeaderDocumentRequired => false;

        public override string RequiredHeaderDocumentName
        {
            get { throw new ApplicationException("header document requested but do not require one"); }
        }

        public override bool IsDocumentPartRequired(contractType contract)
        {
            var result = contract.fundingType.fundingTypeCode == "1619FUND";
            return result;
        }

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(
            string masterContractNumber,
            contractType contract,
            string templateContainer)
        {
            Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentPartAppendixOne, "Producing Appendix1 Mainstream document for contract {0}", contract.contractNumber);
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
                MergeData = CreateDocumentGenerationRequestMergeData(masterContractNumber, contract),
                GroupId = Constants.PaymentScheduleGroupId
            };
            return new Dictionary<string, DocumentGenerationRequest>()
            {
                { "1000", request }
            };
        }

        private DocumentGenerationRequestMergeData CreateDocumentGenerationRequestMergeData(string masterContractNumber, contractType contract)
        {
            UpdateMainLegalDeliverableCodeCache(contract.contractAllocations);

            return new DocumentGenerationRequestMergeData()
            {
                MergeFields = CreateTopLevelMergeFields(masterContractNumber, contract),
                RepeatingSections = GetDeliverablesRepeatingSection(contract)
            };
        }

        private List<MergeFieldType> CreateTopLevelMergeFields(string masterContractNumber, contractType contract)
        {
            var mf = new List<MergeFieldType>()
            {
                new MergeFieldType("OrgName", contract.contractor.legalName),
                new MergeFieldType("MasterContractRef", masterContractNumber),
                new MergeFieldType("ContractRef", contract.contractNumber),
                new MergeFieldType("UKPRN", contract.contractor.ukprn.ToString()),
                new MergeFieldType("UPIN", contract.contractor.Upin),
                new MergeFieldType("StartDate", contract.startDate?.ToString("yyyy-MM-dd")),
                new MergeFieldType("EndDate", contract.endDate?.ToString("yyyy-MM-dd")),
            };

            mf.AddRange(GetTotalMergeFields(contract));

            return mf;
        }

        private void UpdateMainLegalDeliverableCodeCache(List<contractAllocationsContractAllocation> contractAllocations)
        {
            contractAllocations.ForEach(m =>
            {
                if (!_mainLegalDeliverableCode.ContainsKey(m.fundingStreamPeriodCode))
                {
                    Add1619LRLegalDeliverableCodeToPrivateDictionary(m);
                }
            }
           );
        }

        private void Add1619LRLegalDeliverableCodeToPrivateDictionary(contractAllocationsContractAllocation contractAllocation)
        {
            _mainLegalDeliverableCode.Add(contractAllocation.fundingStreamPeriodCode, _paymentManagementPolicyContext.PolicyDeliverables.
                First(pd => pd.FundingStreamPeriod == contractAllocation.fundingStreamPeriodCode && pd.ParentDeliverableCode == null).DeliverableCode);
        }

        private List<RepeatingSectionType> GetDeliverablesRepeatingSection(contractType contract)
        {
            List<RepeatingSectionType> repeatingSections = new List<RepeatingSectionType>();
            var table = new RepeatingSectionType("MainTable") { Rows = new List<RowType>() };
            List<contractAllocationsContractAllocation> allocations = contract.contractAllocations;

            IReadOnlyCollection<contractAllocationsContractAllocation> aggregatedAllocations = EfaAllocationAggregator.AggregateDeliverablePeriodValueWithTheSameFsp(allocations);

            // order these before looping
            foreach (var aggregatedAllocation in aggregatedAllocations.OrderBy(a => _fundingStreamPeriodRepository.GetByKey(a.fundingStreamPeriodCode).DisplayOrder))
            {
                string[] monthsInPeriod = GetMonthsInPeriod(aggregatedAllocation);
                Dictionary<int, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> periodValuesDictionary = GetDeliverablePeriodValueDictionary(aggregatedAllocation);
                table.Rows.AddRange(GetDeliverablesRows(periodValuesDictionary, aggregatedAllocation, monthsInPeriod));
            }

            repeatingSections.Add(table);

            return repeatingSections;
        }

        private List<RowType> GetDeliverablesRows(Dictionary<int, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> periodValuesDictionary, contractAllocationsContractAllocation contractAllocation, string[] monthsInDocument)
        {
            return new List<RowType>(
                periodValuesDictionary.Keys
                                      .Select(
                                          cd =>
                                              DocumentConfigurationSource.GetDeliverableConfigurationForFundingAgreement
                                                  (contractAllocation, cd))
                                      .Where(config => config.IncludeOnFundingAgreement)
                                      .Where(config => config.DeliverableCode != 0) // exclude total
                                      .OrderBy(config => config.DisplayOrder)
                                      .Select(config => new RowType
                                      {
                                          MergeFields =
                                              GetRowMergeFields(contractAllocation, "P{0}", periodValuesDictionary,
                                                  config, monthsInDocument)
                                      }));
        }

        private List<MergeFieldType> GetRowMergeFields(
            contractAllocationsContractAllocation contractAllocation,
            string mergeFieldNameFormat,
            Dictionary<int, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> periodValuesDictionary,
            DeliverableConfiguration delConfig,
            string[] monthsInPeriod)
        {
            Logger.LogVerbose("Adding deliverable with code {0} to the EFA document", delConfig.DeliverableCode);

            List<MergeFieldType> mergeFields = new List<MergeFieldType>
            {
                CreateNameMergeFieldType(contractAllocation, delConfig)
            };

            CreateCashMergeField(mergeFields, contractAllocation, periodValuesDictionary, delConfig);
            CreatePeriodValueFields(mergeFields, mergeFieldNameFormat, periodValuesDictionary, delConfig, monthsInPeriod);

            return mergeFields;
        }

        private List<MergeFieldType> GetTotalMergeFields(contractType contract)
        {
            Logger.LogVerbose("Adding total to the EFA document");

            List<DeliverableConfiguration> delConfig = DocumentConfigurationSource.GetDeliverableConfigurationForSummaryOfFunding(contract).ToList();

            List<MergeFieldType> mergeFields = new List<MergeFieldType>();
            //{
            //    new MergeFieldType("Name", delConfig.First(dc => dc.DeliverableCode == 0).DisplayName)
            //};

            CreateAggregateValueFields(mergeFields, "T{0}", contract);

            return mergeFields;
        }

        private void CreateCashMergeField(List<MergeFieldType> mergeFields, contractAllocationsContractAllocation contractAllocation, Dictionary<int, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> periodValuesDictionary, DeliverableConfiguration delConfig)
        {
            mergeFields.Add(new MergeFieldType(Constants.CashFieldName, GetTotalForDeliverable(periodValuesDictionary, contractAllocation, delConfig.DeliverableCode)));
        }

        private MergeFieldType CreateNameMergeFieldType(contractAllocationsContractAllocation contractAllocation, DeliverableConfiguration delConfig)
        {
            string name;

            // allow for the situation where it is value only, value and volume, or volume only
            // desciption will always go on the value row if it exists, or the volume row if there isn't a value row.
            bool useDescription = delConfig.ShouldDisplayValue;
            if (useDescription)
            {
                name = delConfig.DisplayName;

                if (delConfig.AllowCustomDescription
                    && contractAllocation != null
                    && contractAllocation.contractDeliverables != null
                    && contractAllocation.contractDeliverables.Exists(cd => cd.deliverable.deliverableCode == delConfig.DeliverableCode))
                {
                    var deliverableDescription = GetDeliverableFromAllocation(contractAllocation, delConfig.DeliverableCode).deliverableDescription;

                    if (!string.IsNullOrEmpty(deliverableDescription))
                    {
                        Logger.LogVerbose("Using deliverable description instead of configured value: {0}", deliverableDescription);
                        name = deliverableDescription;
                    }
                }

                if (delConfig.ShouldDisplayUnitCost)
                {
                    string formatString = ConfigurationManager.AppSettings["DocumentGeneration.UnitCostFormat"];
                    if (string.IsNullOrEmpty(formatString))
                    {
                        throw new ConfigurationErrorsException("The 'DocumentGeneration.UnitCostFormat' app.config setting has not been set and is required to produce this contract.");
                    }

                    name = string.Format(formatString, name, Environment.NewLine, GetDeliverableFromAllocation(contractAllocation, delConfig.DeliverableCode).unitCost);
                }
            }
            else
            {
                // if it's not the description then the row above will have the description so the cells should be vertically merged.
                name = Constants.MergeThisAndCellAboveMarker;
            }

            return new MergeFieldType(Constants.NameFielddName, name);
        }

        private contractDeliverablesTypeContractDeliverable GetDeliverableFromAllocation(contractAllocationsContractAllocation contractAllocation, int deliverableCode)
        {
            var deliverable =
                contractAllocation
                    .contractDeliverables
                    .First(cd => cd.deliverable.deliverableCode == deliverableCode);

            return deliverable;
        }

        private void CreatePeriodValueFields(List<MergeFieldType> mergeFields, string mergeFieldNameFormat, Dictionary<int, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> periodValuesDictionary, DeliverableConfiguration delConfig, string[] monthsInPeriod)
        {
            mergeFields.AddRange(monthsInPeriod.Select((period, i) => new MergeFieldType(string.Format(mergeFieldNameFormat, i + 1), CalculatePeriodValue(periodValuesDictionary, delConfig, period))).ToList());
        }

        private void CreateAggregateValueFields(List<MergeFieldType> mergeFields, string mergeFieldNameFormat, contractType contract)
        {
            var cdps = contract.contractAllocations.SelectMany(ca =>
                ca.contractDeliverables.SelectMany(cd => cd.contractDeliverablePeriods));

            var groupedCdpsByPeriod = cdps.ToLookup(cdp => cdp.period);

            var summedValues =
                groupedCdpsByPeriod.Select(g => new { Period = g.Key, Value = g.Sum(cdp => cdp.plannedValue) }).ToList();

            mergeFields.Add(new MergeFieldType("TCash", summedValues.Sum(t => t.Value).ToString(Constants.DecimalToValueFormat)));
            mergeFields.AddRange(summedValues.Select(dv => new MergeFieldType(string.Format(mergeFieldNameFormat, PeriodIndexHelper.GetColumnIndexOfPeriod(dv.Period) + 1), dv.Value.ToString(Constants.DecimalToValueFormat))));
        }

        private string GetTotalForDeliverable(
            Dictionary<int, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> periodValuesFromAllocation,
            contractAllocationsContractAllocation contractAllocation,
            int deliverableCode)
        {
            var total =
                DocumentConfigurationSource
                    .GetDeliverableConfigurationForFundingAgreement(contractAllocation, deliverableCode)
                    .DisplayValueIsAggregate
                    .Where(periodValuesFromAllocation.ContainsKey)
                    .SelectMany(dc => periodValuesFromAllocation[dc])
                    .Sum(entry => entry.Value.plannedValue);

            return total.ToString(Constants.DecimalToValueFormat);
        }

        private string CalculatePeriodValue(
            Dictionary<int, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> periodValuesDictionary,
            DeliverableConfiguration deliverableConfig,
            string periodToCalculate)
        {
            string value = string.Empty;

            bool any = deliverableConfig
                .DisplayValueIsAggregate
                .Any(dc => periodValuesDictionary.ContainsKey(dc) && periodValuesDictionary[dc].ContainsKey(periodToCalculate));

            if (any)
            {
                var sum = deliverableConfig
                    .DisplayValueIsAggregate
                    .Where(dc => periodValuesDictionary.ContainsKey(dc) && periodValuesDictionary[dc].ContainsKey(periodToCalculate))
                    .Select(dc => periodValuesDictionary[dc][periodToCalculate].plannedValue)
                    .Sum();

                if (sum != 0)
                {
                    value = sum.ToString(Constants.DecimalToValueFormat);
                }
            }

            return value;
        }

        /// <summary>
        /// This builds a dictionary with the key being the deliverable code and the value
        /// being a dictionary of the month and value of the deliverable.
        /// </summary>
        /// <param name="contractAllocation"></param>
        /// <returns></returns>
        private Dictionary<int, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> GetDeliverablePeriodValueDictionary(contractAllocationsContractAllocation contractAllocation)
        {
            // This builds a dictionary of Deliverable Code => Dictionary of period strings to planned value            
            Dictionary<int, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> periodValuesDictionary = new Dictionary<int, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>>(
                contractAllocation
                    .contractDeliverables
                    .Select(cd =>
                        new KeyValuePair<int, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>>(
                            cd.deliverable.deliverableCode,
                            new Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>(
                                cd
                                    .contractDeliverablePeriods
                                    .Select(cdp => new
                                    {
                                        Key = string.Format(PeriodStringFormat, new DateTime(cdp.year, cdp.period, 1)),
                                        Value = cdp
                                    })
                                    .ToList()
                                    .ToDictionary(k => k.Key, v => v.Value))))
                    .ToDictionary(k => k.Key, v => v.Value));

            foreach (DeliverableConfiguration config in
                DocumentConfigurationSource.GetMandatoryDeliverablesOnFundingAgreementForAllocation(contractAllocation)
                    .Where(config => !periodValuesDictionary.ContainsKey(config.DeliverableCode)))
            {
                periodValuesDictionary.Add(config.DeliverableCode, new Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>());
            }

            return periodValuesDictionary;
        }
    }
}
