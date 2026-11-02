namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix1
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Aspose.Words.Tables;
    using Common.Models;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentConfiguration;
    using Integration;
    using Common;
    using DataStore.Models;
    using DataStore.Repositories;
    using Dtos;
    using Optional;

    public class NlaAppendix1 : DocumentPartCreator
    {
        private const string OfWhichNewStartsText = "of which New Starts";

        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;
        private readonly INlapFundingConfigRepository _nlapFundingConfigRepository;

        public NlaAppendix1(ITemplateRepository templateRepository,
                            IDocumentConfigurationSource documentConfigurationSource,
                            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository,
                            INlapFundingConfigRepository nlapFundingConfigRepository)
            : base(templateRepository, documentConfigurationSource)
        {
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _nlapFundingConfigRepository = nlapFundingConfigRepository;
        }

        public override bool IsHeaderDocumentRequired => false;

        public override string RequiredHeaderDocumentName => throw new ApplicationException("header document requested but do not require one");

        public override bool IsDocumentPartRequired(contractType contract) => contract.fundingType.fundingTypeCode == "NLA";

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(
            string masterContractNumber,
            contractType contract,
            string templateContainer)
        {
            Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentPartAppendixOne, "Producing Appendix1 NonLevy document for contract {0}", contract.contractNumber);

            var nlapFundingConfig = GetNlapFundingConfig(contract);

            return new Dictionary<string, DocumentGenerationRequest>
            {
                {
                    "1000",
                    new DocumentGenerationRequest
                    {
                        TemplateContainer = templateContainer,
                        TemplateFilename = GetTemplateFilenameFromPolicyConfig(contract, templateContainer),
                        MergeData = CreateDocumentGenerationRequestMergeData(masterContractNumber, contract, nlapFundingConfig),
                        IndentMarkersOverride = CleanupIndentMarkers
                    }
                }
            };
        }

        private NlapFundingConfig GetNlapFundingConfig(contractType contract)
        {
            Option<NlapFundingConfig> nlapFundingConfig = _nlapFundingConfigRepository.FindByUkprn(contract.contractor.ukprn);

            return nlapFundingConfig
                .ValueOr(new NlapFundingConfig(contract.contractor.ukprn, 0, 0, 0, 0));
        }

        private static void CleanupIndentMarkers(Row row)
        {
            const string fourSpaces = "    ";

            if (row.FirstCell.GetText().Contains(OfWhichNewStartsText))
            {
                row.FirstCell.Range.Replace(Constants.IndentTextMarker, fourSpaces, true, false);
            }
            else
            {
                DocumentGenerationRequest.CleanupIndentMarkers(row);
            }
        }

        private string GetTemplateFilenameFromPolicyConfig(contractType contract, string templateContainer)
        {
            string documentTemplatePrefix =
                _fundingTypeFundingPeriodQueryRepository.Get(contract.fundingType.fundingTypeCode, contract.GetFundingPeriod())
                    .TemplateName;

            string templateFilename = GetNameOfTemplateActiveOnDate(templateContainer, documentTemplatePrefix, contract.startDate.GetValueOrDefault());

            return templateFilename;
        }

        private DocumentGenerationRequestMergeData CreateDocumentGenerationRequestMergeData(string masterContractNumber, contractType contract, NlapFundingConfig nlapFundingConfig)
        {
            DocumentGenerationRequestMergeData mergeData = new DocumentGenerationRequestMergeData
            {
                MergeFields = CreateTopLevelMergeFields(masterContractNumber, contract),
                RepeatingSections = new List<RepeatingSectionType>
                {
                    CreateMainTableRepeatingSection(contract, nlapFundingConfig)
                },
            };

            mergeData.RepeatingSections.Add(CreateFutureFundingTableRepeatingSection(contract, nlapFundingConfig));

            return mergeData;
        }

        private List<MergeFieldType> CreateTopLevelMergeFields(string masterContractNumber, contractType contract)
        {
            return new List<MergeFieldType>
            {
                new MergeFieldType(
                    "ContractTotal",
                    contract.contractAllocations
                        .SelectMany(ca => ca.GetAllDeliverables())
                        .SelectMany(cd => cd.contractDeliverablePeriods)
                        .Sum(cdp => cdp.plannedValue)
                        .ToString(Constants.DecimalToValueFormat)),
                new MergeFieldType("MasterContractRef", masterContractNumber),
                new MergeFieldType("UKPRN", contract.contractor.ukprn.ToString()),
                new MergeFieldType("OrgName", contract.contractor.legalName)
            };
        }

        private RepeatingSectionType CreateMainTableRepeatingSection(contractType contract, NlapFundingConfig nlapFundingConfig)
        {
            return new RepeatingSectionType(Constants.TemplateMainTableName)
            {
                Rows = contract.contractAllocations
                    .OrderBy(ca => DocumentConfigurationSource.GetFundingStreamPeriodDisplayOrder(ca).ToString("D2") + ca.startDate.ToString("yyyyMMdd") + ca.description)
                    .SelectMany(ca =>
                    {
                        var rows = new List<RowTypeWithFormattingInfo>
                        {
                            new RowTypeWithFormattingInfo(false, false)
                            {
                                MergeFields = new List<MergeFieldType>
                                {
                                    new MergeFieldType("AllocName", GetAllocNameMergeFieldValue(ca, nlapFundingConfig)),
                                    new MergeFieldType("AllocRef", ca.contractAllocationNumber),
                                    new MergeFieldType("Jan18ToMar18",
                                        GetSumOfPlannedValuesMergeFieldValue(ca, IsJan18ToMar18, d => d.ToString(Constants.DecimalToValueFormat))),
                                    new MergeFieldType("Apr18ToMar19",
                                        GetSumOfPlannedValuesMergeFieldValue(ca, IsApr18ToMar19, d => d.ToString(Constants.DecimalToValueFormat))),
                                    new MergeFieldType("Apr19ToMar20",
                                        GetSumOfPlannedValuesMergeFieldValue(ca, IsApr19ToMar20, d => d.ToString(Constants.DecimalToValueFormat))),
                                    new MergeFieldType("Apr20ToMar21",
                                        GetApr20ToMar21MergeFieldValue(ca, nlapFundingConfig)),
                                    new MergeFieldType("Apr21ToMar22",
                                        GetSumOfPlannedValuesMergeFieldValue(ca, IsApr21ToMar22, d => d.ToString(Constants.DecimalToValueFormat))),
                                    new MergeFieldType("Apr22ToMar23",
                                        GetSumOfPlannedValuesMergeFieldValue(ca, IsApr22ToMar23, d => d.ToString(Constants.DecimalToValueFormat))),
                                    new MergeFieldType("Apr23ToMar24",
                                        GetSumOfPlannedValuesMergeFieldValue(ca, IsApr23ToMar24, d => d.ToString(Constants.DecimalToValueFormat))),
                                    new MergeFieldType("Apr24ToMar25",
                                        GetSumOfPlannedValuesMergeFieldValue(ca, IsApr24ToMar25, d => d.ToString(Constants.DecimalToValueFormat))),
                                    new MergeFieldType("Apr25ToMar26",
                                        GetSumOfPlannedValuesMergeFieldValue(ca, IsApr25ToMar26, d => d.ToString(Constants.DecimalToValueFormat))),
                                     new MergeFieldType("Apr26ToMar27",
                                        GetSumOfPlannedValuesMergeFieldValue(ca, IsApr26ToMar27, d => d.ToString(Constants.DecimalToValueFormat))),
                                    new MergeFieldType("TotalFunding",
                                        GetTotalFundingMergeFieldValue(ca, nlapFundingConfig))
                                }
                            }
                        };

                        var deliverablesToDisplay =
                                ca.GetAllDeliverables()
                                    .Select(d => new
                                    {
                                        Deliverable = d,
                                        ShouldDisplayOnSummaryOfFunding = DocumentConfigurationSource.ShouldDisplayDeliverableOnSummaryOfFunding(ca, d),
                                        DisplayNameOnSoF = DocumentConfigurationSource.GetDeliverableNameForSummaryOfFunding(ca, d.deliverable.deliverableCode)
                                    })
                                    .Where(d => d.ShouldDisplayOnSummaryOfFunding)
                                    .ToList();

                        // now add the dynamic 'of which' deliverables, if there are any
                        rows.AddRange(
                            deliverablesToDisplay
                            .Select(deliverableToDisplay =>
                            {
                                var deliverableCodeToDisplay = deliverableToDisplay.Deliverable.deliverable.deliverableCode;

                                var janToMar18 = GetSummedPlannedValue(ca.GetAllDeliverables(), deliverableCodeToDisplay, IsJan18ToMar18);
                                var apr18ToMar19 = GetSummedPlannedValue(ca.GetAllDeliverables(), deliverableCodeToDisplay, IsApr18ToMar19);
                                var apr19ToMar20 = GetSummedPlannedValue(ca.GetAllDeliverables(), deliverableCodeToDisplay, IsApr19ToMar20);
                                var apr20ToMar21 = GetSummedPlannedValue(ca.GetAllDeliverables(), deliverableCodeToDisplay, IsApr20ToMar21);
                                var apr21ToMar22 = GetSummedPlannedValue(ca.GetAllDeliverables(), deliverableCodeToDisplay, IsApr21ToMar22);
                                var apr22ToMar23 = GetSummedPlannedValue(ca.GetAllDeliverables(), deliverableCodeToDisplay, IsApr22ToMar23);
                                var apr23ToMar24 = GetSummedPlannedValue(ca.GetAllDeliverables(), deliverableCodeToDisplay, IsApr23ToMar24);
                                var apr24ToMar25 = GetSummedPlannedValue(ca.GetAllDeliverables(), deliverableCodeToDisplay, IsApr24ToMar25);
                                var apr25ToMar26 = GetSummedPlannedValue(ca.GetAllDeliverables(), deliverableCodeToDisplay, IsApr25ToMar26);
                                var apr26ToMar27 = GetSummedPlannedValue(ca.GetAllDeliverables(), deliverableCodeToDisplay, IsApr26ToMar27);


                                var total = GetSummedPlannedValue(ca.GetAllDeliverables(), deliverableCodeToDisplay, cdp => true);
                                return new RowTypeWithFormattingInfo(false, isOfWhichRow: true)
                                {
                                    MergeFields = new List<MergeFieldType>
                                    {
                                        new MergeFieldType("AllocName",
                                            Constants.SubRowMarker + Constants.IndentTextMarker +
                                            deliverableToDisplay.DisplayNameOnSoF),
                                        new MergeFieldType("AllocRef", string.Empty),
                                        new MergeFieldType("Jan18ToMar18", janToMar18),
                                        new MergeFieldType("Apr18ToMar19", apr18ToMar19),
                                        new MergeFieldType("Apr19ToMar20", apr19ToMar20),
                                        new MergeFieldType("Apr20ToMar21", apr20ToMar21),
                                        new MergeFieldType("Apr21ToMar22", apr21ToMar22),
                                        new MergeFieldType("Apr22ToMar23", apr22ToMar23),
                                        new MergeFieldType("Apr23ToMar24", apr23ToMar24),
                                        new MergeFieldType("Apr24ToMar25", apr24ToMar25),
                                        new MergeFieldType("Apr25ToMar26", apr25ToMar26),
                                        new MergeFieldType("Apr26ToMar27", apr26ToMar27),
                                        new MergeFieldType("TotalFunding", total)
                                    }
                                };
                            }));

                        return rows;
                    })
                    .Cast<RowType>()
                    .ToList()
            };
        }

        private static string GetSummedPlannedValue(
            IReadOnlyCollection<contractDeliverablesTypeContractDeliverable> deliverables,
            int deliverableCode,
            Func<contractDeliverablePeriodsTypeContractDeliverablePeriod, bool> filter)
        {
            var cdps = deliverables.Where(cd =>
                    cd.deliverable.deliverableCode == deliverableCode)
                .SelectMany(cd => cd.contractDeliverablePeriods)
                .Where(filter)
                .ToList();

            if (cdps.Any())
            {
                return cdps.Sum(cdp => cdp.plannedValue)
                    .ToString(Constants.DecimalToValueFormat);
            }

            return string.Empty;
        }

        private static bool IsPayableAllocation(contractAllocationsContractAllocation contractAllocation)
        {
            string[] payableFundingStreamPeriods = { "16-18NLAP2018", "ANLAP2018" };

            return payableFundingStreamPeriods.Contains(contractAllocation.fundingStreamPeriodCode);
        }

        private string GetAllocNameMergeFieldValue(contractAllocationsContractAllocation contractAllocation, NlapFundingConfig nlapFundingConfig)
        {
            string mergeFieldValue = DocumentConfigurationSource.GetAllocationName(contractAllocation);

            if (IsPayableAllocation(contractAllocation))
            {
                mergeFieldValue += Environment.NewLine + Constants.IndentTextMarker + OfWhichNewStartsText;
            }

            return mergeFieldValue;
        }

        private string GetApr20ToMar21MergeFieldValue(contractAllocationsContractAllocation contractAllocation, NlapFundingConfig nlapFundingConfig)
        {
            decimal amountForPeriod =
                contractAllocation.GetAllDeliverables()
                    .SelectMany(cd => cd.contractDeliverablePeriods)
                    .Where(IsApr20ToMar21)
                    .Sum(cdp => cdp.plannedValue);

            string mergeFieldValue = $"£{amountForPeriod:N0}";

            if (IsPayableAllocation(contractAllocation))
            {
                decimal ofWhichNewStartsAmount = GetNewStarts2021FundingForFsp(nlapFundingConfig, contractAllocation.fundingStreamPeriodCode);
                mergeFieldValue = $"{mergeFieldValue}{Environment.NewLine}£{ofWhichNewStartsAmount:N0}";
            };

            return mergeFieldValue;
        }

        private string GetSumOfPlannedValuesMergeFieldValue(contractAllocationsContractAllocation contractAllocation,
            Func<contractDeliverablePeriodsTypeContractDeliverablePeriod, bool> shouldIncludePeriod, Func<decimal, string> formatWhenValue)
        {
            var periodsToInclude = contractAllocation.GetAllDeliverables()
                    .SelectMany(cd => cd.contractDeliverablePeriods)
                    .Where(shouldIncludePeriod)
                    .ToList();

            if (periodsToInclude.Any())
            {
                var plannedValueForPeriod = periodsToInclude.Sum(cdp => cdp.plannedValue);

                return formatWhenValue(plannedValueForPeriod);
            }

            return string.Empty;
        }

        private string GetTotalFundingMergeFieldValue(contractAllocationsContractAllocation contractAllocation, NlapFundingConfig nlapFundingConfig)
        {
            decimal totalFundingForPeriod =
                contractAllocation.contractDeliverables
                    .SelectMany(cd => cd.contractDeliverablePeriods)
                    .Sum(cdp => cdp.plannedValue);

            string mergeFieldValue = $"£{totalFundingForPeriod:N0}";

            if (IsPayableAllocation(contractAllocation))
            {
                decimal ofWhichNewStartsAmount = GetTotalFundingForNewStarts(nlapFundingConfig, contractAllocation.fundingStreamPeriodCode);
                mergeFieldValue = $"{mergeFieldValue}{Environment.NewLine}£{ofWhichNewStartsAmount:N0}";
            }

            return mergeFieldValue;
        }

        private RepeatingSectionType CreateFutureFundingTableRepeatingSection(contractType contract, NlapFundingConfig nlapFundingConfig)
        {
            return new RepeatingSectionType("FutureFundingTable")
            {
                Rows = contract.contractAllocations
                    .Where(IsPayableAllocation)
                    .OrderBy(ca => DocumentConfigurationSource.GetFundingStreamPeriodDisplayOrder(ca).ToString("D2") + ca.startDate.ToString("yyyyMMdd") + ca.description)
                    .Select(ca => new RowType
                    {
                        MergeFields = new List<MergeFieldType>
                        {
                            new MergeFieldType("AllocName", DocumentConfigurationSource.GetAllocationName(ca)),
                            new MergeFieldType("FutureFundingNewStarts", GetFutureFundingForNewStarts(nlapFundingConfig, ca.fundingStreamPeriodCode).ToString(Constants.DecimalToValueFormat))
                        }
                    })
                    .ToList()
            };
        }

        private static decimal GetNewStarts2021FundingForFsp(NlapFundingConfig nlapFundingConfig, string fundingStreamPeriodCode)
        {
            switch (fundingStreamPeriodCode)
            {
                case "16-18NLAP2018":
                    return nlapFundingConfig.NewStarts2021Funding1618;
                case "ANLAP2018":
                    return nlapFundingConfig.NewStarts2021FundingAdult;
                default:
                    throw new Exception($"No NLAP reference data held for FSP: {fundingStreamPeriodCode}");
            }
        }

        private static decimal GetTotalFundingForNewStarts(NlapFundingConfig nlapFundingConfig, string fundingStreamPeriodCode)
        {
            switch (fundingStreamPeriodCode)
            {
                case "16-18NLAP2018":
                    return nlapFundingConfig.NewStarts2021Funding1618;
                case "ANLAP2018":
                    return nlapFundingConfig.NewStarts2021FundingAdult;
                default:
                    throw new Exception($"No NLAP reference data held for FSP: {fundingStreamPeriodCode}");
            }
        }

        private static decimal GetFutureFundingForNewStarts(NlapFundingConfig nlapFundingConfig, string fundingStreamPeriodCode)
        {
            switch (fundingStreamPeriodCode)
            {
                case "16-18NLAP2018":
                    return nlapFundingConfig.NewStartsEstimatedFutureFunding1618;
                case "ANLAP2018":
                    return nlapFundingConfig.NewStartsEstimatedFutureFundingAdult;
                default:
                    throw new Exception($"No NLAP reference data held for FSP: {fundingStreamPeriodCode}");
            }
        }

        private static bool IsJan18ToMar18(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod)
        {
            return IsInFy2ndYear(deliverablePeriod, 2018);
        }

        private static bool IsApr18ToMar19(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod)
        {
            return IsInFy1stYear(deliverablePeriod, 2018) || IsInFy2ndYear(deliverablePeriod, 2019);
        }

        private static bool IsApr19ToMar20(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod)
        {
            return IsInFy1stYear(deliverablePeriod, 2019) || IsInFy2ndYear(deliverablePeriod, 2020);
        }

        private static bool IsApr20ToMar21(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod)
        {
            return IsInFy1stYear(deliverablePeriod, 2020) || IsInFy2ndYear(deliverablePeriod, 2021);
        }

        private static bool IsApr21ToMar22(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod)
        {
            return IsInFy1stYear(deliverablePeriod, 2021) || IsInFy2ndYear(deliverablePeriod, 2022);
        }

        private static bool IsApr22ToMar23(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod)
        {
            return IsInFy1stYear(deliverablePeriod, 2022) || IsInFy2ndYear(deliverablePeriod, 2023);
        }

        private static bool IsApr23ToMar24(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod)
        {
            return IsInFy1stYear(deliverablePeriod, 2023) || IsInFy2ndYear(deliverablePeriod, 2024);
        }

        private static bool IsApr24ToMar25(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod)
        {
            return IsInFy1stYear(deliverablePeriod, 2024) || IsInFy2ndYear(deliverablePeriod, 2025);
        }

        private static bool IsApr25ToMar26(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod)
        {
            return IsInFy1stYear(deliverablePeriod, 2025) || IsInFy2ndYear(deliverablePeriod, 2026);
        }

        private static bool IsApr26ToMar27(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod)
        {
            return IsInFy1stYear(deliverablePeriod, 2026) || IsInFy2ndYear(deliverablePeriod, 2027);
        }

        private static bool IsInFy1stYear(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod, int periodYear)
        {
            return deliverablePeriod.year == periodYear && (deliverablePeriod.period >= 4 && deliverablePeriod.period <= 12);
        }

        private static bool IsInFy2ndYear(contractDeliverablePeriodsTypeContractDeliverablePeriod deliverablePeriod, int periodYear)
        {
            return deliverablePeriod.year == periodYear && (deliverablePeriod.period >= 1 && deliverablePeriod.period <= 3);
        }
    }
}