namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix2
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentConfiguration;
    using Integration;
    using Common.Models;
    using Common;
    using Dtos;
    using SFA.FCT.DocumentsDomain.DataStore.Repositories;
    using TsAndCs;

    public class Appendix2DocumentCreator : DocumentPartCreator
    {
        // {0} is always 2 because Appendix 2 
        // {1} is 1 if allocation is for the "parent" org, 2 if not
        // {2} is the provider name
        // {3:D3} is fsp order from config
        // {4} is the delivery org name (contract allocation description)
        // {5:yyyyMMdd} is allocation start date
        // {6:D2} is the month offset
        private const string OrderFormatString = "{0}00{1}-{2}-{3:D3}-{4}-{5:yyyyMMdd}-{6:D2}";

        private bool IsNonLevy = false;
        private readonly IFundingStreamPeriodRepository _fundingStreamPeriodRepository;


        public Appendix2DocumentCreator(ITemplateRepository templateRepository,
                                        IDocumentConfigurationSource documentConfigurationSource,
                                        IFundingStreamPeriodRepository fundingStreamPeriodRepository)
            : base(templateRepository, documentConfigurationSource)
        {
            _fundingStreamPeriodRepository = fundingStreamPeriodRepository;
        }



        public enum DisplayRowType
        {
            Value = 1,
            Volume = 2
        }

        public override bool IsHeaderDocumentRequired => false;

        public override string RequiredHeaderDocumentName
        {
            get { return Appendix2HeaderCreator.HeaderName; }
        }

        public override bool IsDocumentPartRequired(contractType contract)
        {
            IsNonLevy = contract.fundingType.fundingTypeCode == "NONLEVY";

            bool doesContractHaveDeliveryOrgOtherThanSelf =
                    contract.contractAllocations.Any(
                        ca =>
                            !string.IsNullOrEmpty(ca.DeliveryOrganisation) &&
                            ca.DeliveryOrganisation != contract.contractor.ukprn.ToString());

            bool isDocRequired =
                contract.contractAllocations.Any(ca => DocumentConfigurationSource.IsFundingAgreementRequiredForAllocation(ca));

            if (IsContractEfa(contract) && !doesContractHaveDeliveryOrgOtherThanSelf || contract.IsRoundOneEsf())
            {
                isDocRequired = false;
            }

            return isDocRequired;
        }

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(
            string masterContractNumber,
            contractType contract,
            string templateContainer)
        {
            Logger.LogVerbose("Appendix 2 SupplyDocumentGenerationRequest called for contract number {0}", contract.contractNumber);

            IDictionary<string, DocumentGenerationRequest> response = GetDocGenRequests(masterContractNumber, templateContainer,
                contract);

            return response;
        }

        protected override string GetContractNumber(contractType contract)
        {
            string contractNumber = base.GetContractNumber(contract);

            if (IsContractEfa(contract))
            {
                contractNumber = contract.contractNumber;
            }

            return contractNumber;
        }
        
        private IDictionary<string, DocumentGenerationRequest> GetDocGenRequests(string masterContractNumber, string templateContainer, contractType contract)
        {
            IDictionary<string, DocumentGenerationRequest> response = new Dictionary<string, DocumentGenerationRequest>();

            Func<contractAllocationsContractAllocation, bool> filter =
                AllocationSelectionFilter.GetContractAllocationFilter(
                    fundingTypeCode: contract.fundingType.fundingTypeCode,
                    fundingPeriod: contract.GetFundingPeriod(),
                    intent: contract.GetIntent(),
                    documentConfigurationSource: DocumentConfigurationSource);

            var contractAllocations =
                contract
                    .contractAllocations
                    .Where(filter)
                    .ToList();

            foreach (var contractAllocation in contractAllocations)
            {
                string[] monthsInPeriod = GetMonthsInPeriod(contractAllocation);
                Dictionary<PeriodValueDictKey, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> periodValuesDictionary = GetDeliverablePeriodValueDictionary(contractAllocation);
                int monthOffset = 0;

                int fspDisplayOrder = DocumentConfigurationSource.GetFundingStreamPeriodDisplayOrder(contractAllocation);

                while (monthOffset < monthsInPeriod.Length)
                {
                    // Only applicable for NonLevy 1718 - after this period has finished the non levy contracts will revert to 12 months and this change should be removed
                    // Converted new function for accept 15 month HTE-SIF FSP
                    string[] monthsInDocument = GetmonthsInDocument(contract.fundingType.fundingTypeCode,monthsInPeriod,monthOffset);                    
                    
                    Logger.LogVerbose(
                        "Building DocumentGenerationRequest for {0} using offset {1} is month {2} to {3}",
                        contractAllocation.contractAllocationNumber,
                        monthOffset,
                        monthsInDocument.First(),
                        monthsInDocument.Last());

                    List<MergeFieldType> mergeFields = new List<MergeFieldType>();
                    mergeFields.AddRange(
                        GetDocumentHeaderAndFooterAndMonthHeaderMergeFields(masterContractNumber, contract, contractAllocation, monthsInDocument));

                    List<RepeatingSectionType> repeatingSections;
                    string groupId;

                    bool isNonContractDeliveryOrganisation = contractAllocation.HasDeliveryOrganisation() &&
                                                             contractAllocation.DeliveryOrganisation != contract.contractor.ukprn.ToString();

                    string orderString = GetOrderFormatString(contract, contractAllocation, fspDisplayOrder, monthOffset, isNonContractDeliveryOrganisation);

                    if (IsContractEfa(contract))
                    {
                        mergeFields.AddRange(GetTotalMergeFields(contractAllocation));

                        groupId = Constants.PaymentScheduleGroupId;
                        repeatingSections = GetDeliverablesRepeatingSection(periodValuesDictionary, contractAllocation,
                            monthsInDocument, shouldExcludeTotals: true);
                        repeatingSections.ForEach(rp => rp.RemoveZerosFromFields(fieldsToIgnore: new List<string> { Constants.CashFieldName }));
                    }
                    else
                    {
                        // we may have overriden the allocation number in contract create, the original is needed for page numbering
                        groupId = contractAllocation.OriginalAllocationNumber ?? contractAllocation.contractAllocationNumber;
                        repeatingSections = GetDeliverablesRepeatingSection(periodValuesDictionary, contractAllocation,
                            monthsInDocument);
                    }

                    response.Add(
                        orderString,
                        new DocumentGenerationRequest
                        {
                            TemplateContainer = templateContainer,
                            TemplateFilename = GetTemplateFilename(
                                contractAllocation,
                                templateContainer,
                                monthOffset,
                                contractAllocation.startDate,
                                contract.fundingType.fundingTypeCode),
                            GroupId = groupId,
                            MergeData = new DocumentGenerationRequestMergeData()
                            {
                                MergeFields = mergeFields,
                                RepeatingSections = repeatingSections
                            }
                        });

                    // Only applicable for NonLevy 1718 - after this period has finished the non levy contracts will revert to 12 months and this change should be removed
                    if (!IsNonLevy && !(contract.fundingType.fundingTypeCode == "HTE-SIF") && !(contract.fundingType.fundingTypeCode == "HTE-SIF2"))
                    {
                        monthOffset += 12;
                    }
                    else if(contract.fundingType.fundingTypeCode == "HTE-SIF2")
                    {
                        monthOffset += 14;
                    }
                    else
                    {
                        monthOffset += 15;
                    }
                }
            }

            return response;
        }

        private string[] GetmonthsInDocument(string fundingTypeCode, string[] monthsInPeriod, int monthOffset)
        {
            string[] monthsInDocument;
            switch (fundingTypeCode)
            {
                case "NONLEVY":
                    monthsInDocument = monthsInPeriod.Skip(monthOffset).Take(15).ToArray();
                    break;
                case "HTE-SIF":
                    monthsInDocument = monthsInPeriod.Skip(monthOffset).Take(15).ToArray();
                    break;
                case "HTE-SIF2":
                    monthsInDocument = monthsInPeriod.Skip(monthOffset).Take(14).ToArray();
                    break;
                default:
                    monthsInDocument = monthsInPeriod.Skip(monthOffset).Take(12).ToArray();
                    break;
            }

            return monthsInDocument;
        }

        protected override string[] GetMonthsInPeriod(contractAllocationsContractAllocation contractAllocation)
        {
            var aebProviderReliefSchemeFsps = new[] { "AEB-PRS1920", "AEB-PRS2021" };
            var nlapProviderReliefSchemeFsps = new[] { "16-18NLAP-PRS2020", "ANLAP-PRS2020" };

            if (aebProviderReliefSchemeFsps.Contains(contractAllocation.fundingStreamPeriodCode))
            {
                return GetMonthsInPeriodForAebProviderReliefSchemeFsps(contractAllocation);
            }

            if (nlapProviderReliefSchemeFsps.Contains(contractAllocation.fundingStreamPeriodCode))
            {
                return GetMonthsInPeriodForNlapProviderReliefSchemeFsps(contractAllocation);
            }

            return base.GetMonthsInPeriod(contractAllocation);
        }

        private static string[] GetMonthsInPeriodForAebProviderReliefSchemeFsps(contractAllocationsContractAllocation contractAllocation)
        {
            int startYear = contractAllocation.startDate.Year;
            int startMonth = 8;
            int endYear = contractAllocation.endDate.Value.Year;
            int endMonth = 7;

            if (endYear == startYear)
            {
                endYear++; // we must show a full year Aug to July even for short contracts
            }

            List<string> result = new List<string>();

            while (startYear < endYear || (startYear == endYear && startMonth <= endMonth))
            {
                result.Add(string.Format(PeriodStringFormat, new DateTime(startYear, startMonth, 1)));
                startMonth++;
                if (startMonth == 13)
                {
                    startMonth = 1;
                    startYear++;
                }
            }

            return result.ToArray();
        }

        private static string[] GetMonthsInPeriodForNlapProviderReliefSchemeFsps(contractAllocationsContractAllocation contractAllocation)
        {
            int startYear = contractAllocation.startDate.Year;
            int startMonth = 4;
            int endYear = contractAllocation.endDate.Value.Year;
            int endMonth = 3;

            if (endYear == startYear)
            {
                endYear++; // we must show a full year April to March even for short contracts
            }

            List<string> result = new List<string>();

            while (startYear < endYear || (startYear == endYear && startMonth <= endMonth))
            {
                result.Add(string.Format(PeriodStringFormat, new DateTime(startYear, startMonth, 1)));
                startMonth++;
                if (startMonth == 13)
                {
                    startMonth = 1;
                    startYear++;
                }
            }

            return result.ToArray();
        }

        private string GetOrderFormatString(contractType contract, contractAllocationsContractAllocation contractAllocation, int fspDisplayOrder, int monthOffset, bool isNonContractDeliveryOrganisation)
        {
            var fspGroups = _fundingStreamPeriodRepository.GetFspGroups(new List<string> {contractAllocation.fundingStreamPeriodCode});
            string isNonContractingSortOrder = isNonContractDeliveryOrganisation ? "2" : "1";
            if (IsContractEfa(contract) && string.Equals(contract.period.period1, "1718"))
            {
                return string.Format(
                    OrderFormatString,
                    2,
                    isNonContractingSortOrder,
                    contractAllocation.description ?? contractAllocation.DeliveryOrganisation,
                    fspDisplayOrder,
                    contractAllocation.description ??
                    contractAllocation.DeliveryOrganisation, // we don't expect this as the desc should always be set
                    contractAllocation.startDate,
                    monthOffset);
            }

            if (fspGroups.Any())
            {
                string deliveryDesc = contractAllocation.HasDeliveryOrganisation()
                    ? contractAllocation.DeliveryOrganisation
                    : contractAllocation.description;

                string legalName = contractAllocation.DeliveryOrganisationDetail.legalName ??
                                   contract.contractor.legalName;
                var fspGroup = fspGroups.Single();
                return $"{EdskScheduleDocGenRequestCreator.EdskScheduleOrderPrefix}S2{fspGroup.DisplayOrder}{fspDisplayOrder}{isNonContractingSortOrder}{legalName}{deliveryDesc}";
            }

            return string.Format(
                OrderFormatString,
                2,
                isNonContractingSortOrder,
                contractAllocation.DeliveryOrganisationDetail.legalName ?? contract.contractor.legalName,
                fspDisplayOrder,
                contractAllocation.HasDeliveryOrganisation()
                    ? contractAllocation.DeliveryOrganisation
                    : contractAllocation.description,
                contractAllocation.startDate,
                monthOffset);
        }

        private IEnumerable<MergeFieldType> GetTotalMergeFields(contractAllocationsContractAllocation contractAllocation)
        {
            List<MergeFieldType> totalMergeFields = new List<MergeFieldType>();

            var cdps = contractAllocation.GetAllDeliverables().SelectMany(cd => cd.contractDeliverablePeriods);

            ILookup<int, contractDeliverablePeriodsTypeContractDeliverablePeriod> groupedCdpsByPeriod = cdps.ToLookup(cdp => cdp.period);

            List<PeriodTotalValue> summedValues =
                groupedCdpsByPeriod.Select(g => new PeriodTotalValue(g.Key, g.Sum(cdp => cdp.plannedValue))).ToList();

            int firstPeriodInContract = summedValues.Select(ptv => ptv.Period).Min();

            int firstColumnWithData = PeriodIndexHelper.GetColumnIndexOfPeriod(firstPeriodInContract);

            int lastPeriodInContract = summedValues.Select(ptv => ptv.Period).Max();

            int lastColumnWithData = PeriodIndexHelper.GetColumnIndexOfPeriod(lastPeriodInContract);

            List<PeriodTotalValue> supplementedSummedValues =
                PeriodIndexHelper.GetZeroPeriodTotalValuesAugToJuly(firstColumnWithData, lastColumnWithData)
                    .Select(ptv => summedValues.SingleOrDefault(sv => sv.Period == ptv.Period) ?? ptv).ToList();

            totalMergeFields.Add(new MergeFieldType(Constants.TotalCashFieldName, ToFormattedDecimal(supplementedSummedValues.Sum(t => t.Value))));
            totalMergeFields.AddRange(supplementedSummedValues.Select((dv, i) => new MergeFieldType($"T{i + 1}", ToFormattedDecimal(dv.Value))));

            return totalMergeFields;
        }

        private static string ToFormattedDecimal(decimal? optionalDecimal)
        {
            if (optionalDecimal.HasValue)
            {
                return optionalDecimal.Value.ToString(Constants.DecimalToValueFormat);
            }

            return string.Empty;
        }

        private IEnumerable<MergeFieldType> GetDocumentHeaderAndFooterAndMonthHeaderMergeFields(string masterContractNumber, contractType contract, contractAllocationsContractAllocation contractAllocation, string[] monthsInDocument)
        {
            var mergeFields = new List<MergeFieldType>();
            mergeFields.AddRange(GetDocumentHeaderFields(masterContractNumber, contract, contractAllocation));
            mergeFields.AddRange(GetMonthColumnHeaderMergeFields(monthsInDocument));
            mergeFields.AddRange(GetFspGroupField(contractAllocation.fundingStreamPeriodCode));

            return mergeFields;
        }

        private List<RepeatingSectionType> GetDeliverablesRepeatingSection(Dictionary<PeriodValueDictKey, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> periodValuesDictionary, contractAllocationsContractAllocation contractAllocation, string[] monthsInDocument, bool shouldExcludeTotals = false)
        {
            Func<DeliverableConfiguration, bool> totalsFilter = dc => true;
            if (shouldExcludeTotals)
            {
                totalsFilter = dc => dc.DeliverableCode != 0;
            }

            return new List<RepeatingSectionType>
            {
                new RepeatingSectionType()
                {
                    Name = "MainTable",
                    Rows = new List<RowType>(
                        periodValuesDictionary.Keys
                            .Select(pvdk => DocumentConfigurationSource.GetDeliverableConfigurationForFundingAgreement(contractAllocation, pvdk.DeliverableCode))
                            .Where(config => config.IncludeOnFundingAgreement)
                            .Where(totalsFilter)
                            .OrderBy(config => config.DisplayOrder)
                            .SelectMany(GetRowTypesFromConfiguration)
                            .Select(configAndRowType => new RowType
                            {
                                MergeFields = GetRowMergeFields(contractAllocation, "P{0}", periodValuesDictionary, configAndRowType.Item1, configAndRowType.Item2, monthsInDocument)
                            }))
                }
            };
        }

        private IEnumerable<Tuple<DeliverableConfiguration, DisplayRowType>> GetRowTypesFromConfiguration(DeliverableConfiguration dc)
        {
            if (dc.ShouldDisplayValue)
            {
                yield return new Tuple<DeliverableConfiguration, DisplayRowType>(dc, DisplayRowType.Value);
            }

            if (dc.ShouldDisplayVolume)
            {
                yield return new Tuple<DeliverableConfiguration, DisplayRowType>(dc, DisplayRowType.Volume);
            }
        }

        private List<MergeFieldType> GetRowMergeFields(
            contractAllocationsContractAllocation contractAllocation,
            string mergeFieldNameFormat,
            Dictionary<PeriodValueDictKey, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> periodValuesDictionary,
            DeliverableConfiguration delConfig,
            DisplayRowType rowType,
            string[] monthsInPeriod)
        {
            Logger.LogVerbose("Adding deliverable with code {0} to the appendix 2 document", delConfig.DeliverableCode);

            List<MergeFieldType> mergeFields = new List<MergeFieldType>
            {
                CreateNameMergeFieldType(contractAllocation, delConfig, rowType)
            };

            CreateCVMergeField(mergeFields, rowType);
            CreateCashMergeField(mergeFields, contractAllocation, periodValuesDictionary, delConfig, rowType);
            CreateVolumeValueFields(mergeFields, mergeFieldNameFormat, periodValuesDictionary, delConfig, rowType, monthsInPeriod, contractAllocation.DeliveryOrganisation);

            CreateUnitCostMergeFieldType(mergeFields, contractAllocation, delConfig, rowType);

            return mergeFields;
        }

        private void CreateVolumeValueFields(List<MergeFieldType> mergeFields, string mergeFieldNameFormat, Dictionary<PeriodValueDictKey, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> periodValuesDictionary, DeliverableConfiguration delConfig, DisplayRowType rowType, string[] monthsInPeriod, string deliveryOrg)
        {
            mergeFields.AddRange(monthsInPeriod.Select((period, i) => new MergeFieldType(string.Format(mergeFieldNameFormat, i + 1), CalculatePeriodValue(periodValuesDictionary, delConfig, rowType, period, deliveryOrg))).ToList());
        }

        private void CreateCashMergeField(List<MergeFieldType> mergeFields, contractAllocationsContractAllocation contractAllocation, Dictionary<PeriodValueDictKey, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> periodValuesDictionary, DeliverableConfiguration delConfig, DisplayRowType rowType)
        {
            mergeFields.Add(new MergeFieldType(Constants.CashFieldName, GetTotalForDeliverable(periodValuesDictionary, contractAllocation, delConfig.DeliverableCode, rowType, contractAllocation.DeliveryOrganisation)));
        }

        private static void CreateCVMergeField(List<MergeFieldType> mergeFields, DisplayRowType rowType)
        {
            if (rowType == DisplayRowType.Value)
            {
                mergeFields.Add(new MergeFieldType(Constants.CvFieldName, "Cash (£)"));
            }
            else if (rowType == DisplayRowType.Volume)
            {
                mergeFields.Add(new MergeFieldType(Constants.CvFieldName, Constants.ItalicTextMarker + "Volume" + Constants.EndOfTextMarker));
            }
        }

        private void CreateUnitCostMergeFieldType(List<MergeFieldType> mergeFields, contractAllocationsContractAllocation contractAllocation, DeliverableConfiguration delConfig, DisplayRowType rowType)
        {
            int totalFundingRowDeliverableCode;
            if (!int.TryParse(ConfigurationManager.AppSettings["DocumentGeneration.TotalFundingDeliverableCode"], out totalFundingRowDeliverableCode))
            {
                totalFundingRowDeliverableCode = 0;
            }

            if (!delConfig.ShouldDisplayUnitCost && delConfig.DeliverableCode != totalFundingRowDeliverableCode)
            {
                mergeFields.Add(new MergeFieldType(Constants.UnitCostFieldName, Constants.NotApplicable));
            }
            else if ((rowType == DisplayRowType.Value) && delConfig.ShouldDisplayUnitCost)
            {
                // If this is the value row and we show unit cost for this deliverable  then get & format unit cost 
                string formatString = ConfigurationManager.AppSettings["DocumentGeneration.UnitCostFormat"];
                if (string.IsNullOrEmpty(formatString))
                {
                    throw new ConfigurationErrorsException("The 'DocumentGeneration.UnitCostFormat' app.config setting has not been set and is required to produce this contract.");
                }
                mergeFields.Add(new MergeFieldType(Constants.UnitCostFieldName,
                    string.Format(formatString, GetDeliverableFromAllocation(contractAllocation, delConfig.DeliverableCode).unitCost)));
            }
            else if ((rowType == DisplayRowType.Volume) && delConfig.ShouldDisplayUnitCost)
            {
                // If this is the volume row merge with call above
                mergeFields.Add(new MergeFieldType(Constants.UnitCostFieldName, Constants.MergeThisAndCellAboveMarker));
            }
        }

        private MergeFieldType CreateNameMergeFieldType(contractAllocationsContractAllocation contractAllocation, DeliverableConfiguration delConfig, DisplayRowType rowType)
        {
            string name;

            // allow for the situation where it is value only, value and volume, or volume only
            // desciption will always go on the value row if it exists, or the volume row if there isn't a value row.
            bool useDescription = rowType == DisplayRowType.Value || !delConfig.ShouldDisplayValue;
            if (useDescription)
            {
                name = delConfig.DisplayName;

                if (delConfig.AllowCustomDescription
                    && contractAllocation != null
                    && contractAllocation.contractDeliverables != null
                    && contractAllocation.GetAllDeliverables().ToList().Exists(cd => cd.deliverable.deliverableCode == delConfig.DeliverableCode))
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
                    .GetAllDeliverables()
                    .First(cd => cd.deliverable.deliverableCode == deliverableCode);

            return deliverable;
        }

        private string GetTotalForDeliverable(
            Dictionary<PeriodValueDictKey, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> periodValuesFromAllocation,
            contractAllocationsContractAllocation contractAllocation,
            int deliverableCode,
            DisplayRowType rowType,
            string deliveryOrg)
        {
            const int deliverableCodeRepresentingTotalsLine = 0;
            decimal total = 0;
            if (contractAllocation.fundingStreamPeriodCode == "1619ED1920" && deliverableCode == deliverableCodeRepresentingTotalsLine)
            {
                total = EdskTotalValueCalculator.GetAllocationTotal(contractAllocation);
            }
            else
            {
                total =
                    DocumentConfigurationSource
                        .GetDeliverableConfigurationForFundingAgreement(contractAllocation, deliverableCode)
                        .DisplayValueIsAggregate
                        .Select(dc => GetPeriodValueDictKey(dc, deliveryOrg))
                        .Where(periodValuesFromAllocation.ContainsKey)
                        .SelectMany(dc => periodValuesFromAllocation[dc])
                        .Sum(entry => rowType == DisplayRowType.Value ? entry.Value.plannedValue : entry.Value.plannedVolume);
            }
            
            if (rowType == DisplayRowType.Value)
            {
                return total.ToString(Constants.DecimalToValueFormat);
            }
            else
            {

                return string.Format("{0}{1:#,0}{2}", Constants.RemovePoundSignMarker, total, Constants.EndOfTextMarker);
            }
        }

        private string CalculatePeriodValue(
            Dictionary<PeriodValueDictKey, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> periodValuesDictionary,
            DeliverableConfiguration deliverableConfig,
            DisplayRowType rowType,
            string periodToCalculate,
            string deliveryOrg)
        {
            string value = string.Empty;


            bool any = deliverableConfig
                .DisplayValueIsAggregate
                .Select(dc => GetPeriodValueDictKey(dc, deliveryOrg))
                .Any(k => periodValuesDictionary.ContainsKey(k) && periodValuesDictionary[k].ContainsKey(periodToCalculate));

            if (any)
            {
                var sum = deliverableConfig
                    .DisplayValueIsAggregate
                    .Select(dc => GetPeriodValueDictKey(dc, deliveryOrg))
                    .Where(k => periodValuesDictionary.ContainsKey(k) && periodValuesDictionary[k].ContainsKey(periodToCalculate))
                    .Select(pvdk => rowType == DisplayRowType.Value
                        ? periodValuesDictionary[pvdk][periodToCalculate].plannedValue
                        : periodValuesDictionary[pvdk][periodToCalculate].plannedVolume)
                    .Sum();

                value = rowType == DisplayRowType.Value
                    ? sum.ToString(Constants.DecimalToValueFormat)
                    : string.Format(Constants.DecimalToVolumeFormat, Constants.RemovePoundSignMarker, sum, Constants.EndOfTextMarker);
            }

            return value;
        }

        private string GetTemplateFilename(
            contractAllocationsContractAllocation contractAllocation,
            string templateContainer,
            int monthOffset,
            DateTime contractStartDate,
            string fundingTypeCode)
        {
            FundingAgreementTemplate templateNames = DocumentConfigurationSource.GetFundingAgreementTemplateNamesForAllocation(
                contractAllocation.fundingStream.fundingStreamCode, contractAllocation.fundingStreamPeriodCode, fundingTypeCode);
            string templateToUse = templateNames.TemplateName;
            if (monthOffset > 0)
            {
                templateToUse = templateNames.ExtraPagesTemplate;
            }

            string templateStartsWith = string.Format(templateToUse, contractAllocation.period.period1);
            string templateName = GetNameOfTemplateActiveOnDate(templateContainer, templateStartsWith, contractStartDate);

            return templateName;
        }

        private IEnumerable<MergeFieldType> GetFspGroupField(string fundingStreamPeriodCode)
        {
            return _fundingStreamPeriodRepository.GetFspGroupDisplayNames(new List<string> {fundingStreamPeriodCode})
                .Select(n => new MergeFieldType("FSPGroup", n))
                .ToList();
        }

        /// <summary>
        /// This builds a dictionary with the key being the deliverable code and the value
        /// being a dictionary of the month and value of the deliverable.
        /// </summary>
        /// <param name="contractAllocation"></param>
        /// <returns></returns>
        private Dictionary<PeriodValueDictKey, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> GetDeliverablePeriodValueDictionary(contractAllocationsContractAllocation contractAllocation)
        {
            // This builds a dictionary of Deliverable Code => Dictionary of period strings to planned value            
            Dictionary<PeriodValueDictKey, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>> periodValuesDictionary = new Dictionary<PeriodValueDictKey, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>>(
                contractAllocation
                    .GetAllDeliverables()
                    .Select(cd =>
                        new KeyValuePair<PeriodValueDictKey, Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>>(
                            GetPeriodValueDictKey(cd.deliverable.deliverableCode, contractAllocation.DeliveryOrganisation),
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
                    .Where(config => !periodValuesDictionary.ContainsKey(GetPeriodValueDictKey(config.DeliverableCode, contractAllocation.DeliveryOrganisation))))
            {
                periodValuesDictionary.Add(
                    GetPeriodValueDictKey(config.DeliverableCode, contractAllocation.DeliveryOrganisation),
                    new Dictionary<string, contractDeliverablePeriodsTypeContractDeliverablePeriod>());
            }

            return periodValuesDictionary;
        }

        private PeriodValueDictKey GetPeriodValueDictKey(int deliverableCode, string allocationDeliveryOrg)
        {
            int deliveryOrg;
            if (int.TryParse(allocationDeliveryOrg, out deliveryOrg))
            {
                return new PeriodValueDictKey(deliverableCode, deliveryOrg);
            }

            return new PeriodValueDictKey(deliverableCode);
        }

        private struct PeriodValueDictKey
        {
            public PeriodValueDictKey(int deliverableCode)
            {
                DeliverableCode = deliverableCode;
                DeliveryOrganisation = null;
            }

            public PeriodValueDictKey(int deliverableCode, int deliveryOrganisation)
            {
                DeliverableCode = deliverableCode;
                DeliveryOrganisation = deliveryOrganisation;
            }

            public int DeliverableCode { get; }

            public int? DeliveryOrganisation { get; }

            public override bool Equals(object obj)
            {
                bool isEqual = false;

                if (obj is PeriodValueDictKey)
                {
                    PeriodValueDictKey other = (PeriodValueDictKey)obj;
                    isEqual = DeliverableCode == other.DeliverableCode &&
                              DeliveryOrganisation == other.DeliveryOrganisation;
                }

                return isEqual;
            }

            public override int GetHashCode()
            {
                return DeliverableCode.GetHashCode() ^ DeliveryOrganisation.GetHashCode();
            }           
        }
    }
}