namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix1
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Common;
    using Common.Models;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Repositories;
    using DocumentConfiguration;
    using Dtos;
    using Extensions;
    using Integration;
    using PaymentManagementDomain.PolicyCache.DataStore.Repositories;
    using Repositories;
    using FundingTypeFundingPeriod = ContractManagement.DataStore.Model.FundingTypeFundingPeriod;

    public class MultiContractSummaryOfFundingCreator : DocumentPartCreator
    {
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;
        private readonly IPayCalcPolicyQueryRepository _payCalcPolicyQueryRepository;
        private readonly IFundingStreamPeriodRepository _fundingStreamPeriodRepository;
        private readonly IContractReferenceConfigRepository _contractReferenceConfigRepository;

        public MultiContractSummaryOfFundingCreator(
            ITemplateRepository templateRepository,
            IDocumentConfigurationSource documentConfigurationSource,
            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository,
            IPayCalcPolicyQueryRepository payCalcPolicyQueryRepository,
            IFundingStreamPeriodRepository fundingStreamPeriodRepository,
            IContractReferenceConfigRepository contractReferenceConfigRepository) : base(templateRepository, documentConfigurationSource)
        {
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _payCalcPolicyQueryRepository = payCalcPolicyQueryRepository;
            _fundingStreamPeriodRepository = fundingStreamPeriodRepository;
            _contractReferenceConfigRepository = contractReferenceConfigRepository;
        }

        public override bool IsHeaderDocumentRequired => false;

        public override string RequiredHeaderDocumentName => throw new InvalidOperationException("Header document name requested but not required");

        public override bool IsDocumentPartRequired(contractType contract)
        {
            string[] associatedFundingTypes = { "AEB", "DADA", "19TRN2020", "AEB2021", "AEB2023" };
            
            return associatedFundingTypes.Contains(contract.fundingType.fundingTypeCode);
        }

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(
            string masterContractNumber,
            contractType contract,
            string templateContainer)
        {
            const string moneyFormat = "£#,##0";
            var topLevelParentDeliverableCodesGroupedByFsp = contract.contractAllocations.GetTopLevelParentDeliverableCodes(_payCalcPolicyQueryRepository);

            int periodStartYear = GetStartYearFromPeriod(contract.period);
            int periodEndYear = GetEndYearFromPeriod(contract.period);

            FundingTypeFundingPeriod fundingTypeFundingPeriod =
                _fundingTypeFundingPeriodQueryRepository.Get(contract.fundingType.fundingTypeCode, contract.GetFundingPeriod());

            string templateFilename = GetNameOfTemplateActiveOnDate(templateContainer, fundingTypeFundingPeriod.TemplateName, contract.startDate.GetValueOrDefault());

            // the oldest value goes in MainTable and most recent in MainTable3
            List<ContractTableInfo> contractInfos = new List<ContractTableInfo>();

            IReadOnlyCollection<RowTypeWithFormattingInfo> allocationRowsWithFormattingInfo = GetAllocationRowsWithFormattingInfo();
            decimal contractTotal = allocationRowsWithFormattingInfo.Where(r => !r.IsOfWhichRow)
                .Sum(r => r.Total);

            List<RowType> allocationRows = allocationRowsWithFormattingInfo.Cast<RowType>().ToList();

            contractInfos.Add(GenerateContractTableInfo(contract, contractTotal, allocationRows));
            contractInfos.AddRange(contract.GetSharedMasterContractTableInfos(_fundingStreamPeriodRepository, DocumentConfigurationSource));
            contractInfos = contractInfos.OrderBy(c => c.StartDate).ToList();

            decimal masterContractTotal = contractTotal + contract.GetSharedMasterContractsTotal();
            return contractInfos.Select((contractInfo, i) => new KeyValuePair<string, DocumentGenerationRequest>(
                $"100{i}",

                new DocumentGenerationRequest
                {
                    TemplateContainer = templateContainer,
                    TemplateFilename = templateFilename,
                    MergeData = new DocumentGenerationRequestMergeData
                    {
                        MergeFields = new List<MergeFieldType>
                        {
                            new MergeFieldType("OrgName", contract.contractor.legalName),
                            new MergeFieldType("Ukprn", contract.contractor.ukprn.ToString()),
                            new MergeFieldType("ContractTotal", contractInfo.ContractTotal.ToString(moneyFormat)),
                            new MergeFieldType("MasterContractRef", masterContractNumber),
                            new MergeFieldType("ShowMasterContractTotal", IsLastContract(contractInfo, contractInfos) ? "Y" : "N"),
                            new MergeFieldType("FundingPeriod", contractInfo.FundingPeriod),
                            new MergeFieldType("FinancialEnvelope1", contractInfo.FinancialEnvelopePeriod1),
                            new MergeFieldType("FinancialEnvelope2", contractInfo.FinancialEnvelopePeriod2),
                            new MergeFieldType("MasterContractTotal", masterContractTotal.ToString(moneyFormat)),
                        },
                        RepeatingSections = new List<RepeatingSectionType>
                        {
                            new RepeatingSectionType("MainTable")
                            {
                                Rows = contractInfo.AllocationRowTypes
                            }
                        }
                    },
                    IsNewPageRequired = false,
                    IndentMarkersOverride = DocumentGenerationRequest.CleanupIndentMarkers
                })).ToDictionary(kv => kv.Key, kv => kv.Value);
            
            IReadOnlyCollection<RowTypeWithFormattingInfo> GetAllocationRowsWithFormattingInfo()
            {
                const string rowCellMoneyFormat = "£#,##0";
                return
                    contract.contractAllocations
                        .Select(a => new { Allocation = a, _fundingStreamPeriodRepository.GetByKey(a.fundingStreamPeriodCode).DisplayOrder })
                        .GroupBy(a => a.Allocation.fundingStreamPeriodCode)
                        .OrderBy(fundingStreamGroup => fundingStreamGroup.First().DisplayOrder)
                        .SelectMany(allocationsForFundingStream =>
                        {
                            List<RowTypeWithFormattingInfo> rows = new List<RowTypeWithFormattingInfo>();
                            contractAllocationsContractAllocation allocation = allocationsForFundingStream.First().Allocation;

                            var deliverablesToDisplay = allocationsForFundingStream
                                .SelectMany(a => a.Allocation.GetAllDeliverables().Select(d => new
                                {
                                    Deliverable = d,
                                    ShouldDisplayOnSummaryOfFunding = DocumentConfigurationSource.ShouldDisplayDeliverableOnSummaryOfFunding(a.Allocation, d),
                                    DisplayNameOnSoF = DocumentConfigurationSource.GetDeliverableNameForSummaryOfFunding(a.Allocation, d.deliverable.deliverableCode)
                                }))
                                .Where(d => d.ShouldDisplayOnSummaryOfFunding)
                                .Distinct()
                                .ToList();

                            rows.AddRange(allocationsForFundingStream
                                .OrderByDescending(ca =>
                                    ca.Allocation.DeliveryOrganisationDetail.ukprn == contract.contractor.ukprn)
                                .ThenBy(ca => ca.Allocation.DeliveryOrganisationDetail.legalName)
                                .SelectMany(ca =>
                                {
                                    var parentDeliverableCodes = topLevelParentDeliverableCodesGroupedByFsp[ca.Allocation.fundingStreamPeriodCode];
                                    var deliverablePeriodsForParentCodes = ca.Allocation.GetDeliverablePeriodsForDeliverables(parentDeliverableCodes);
                                    var periodOneTotal = deliverablePeriodsForParentCodes.GetTotalValue(cdp => IsInFyOne(cdp, periodStartYear, periodEndYear));

                                    var periodTwoTotal = deliverablePeriodsForParentCodes.GetTotalValue(cdp => IsInFyTwo(cdp, periodStartYear, periodEndYear));

                                    var total = deliverablePeriodsForParentCodes.GetTotalValue(cdp => true);

                                    var rowValues = EdskSummaryOfFundingRoundingService.GetSummaryRowResult(periodOneTotal,
                                        periodTwoTotal, total, ca.Allocation.fundingStreamPeriodCode);

                                    string fspSummaryOfFundingDisplayName = _fundingStreamPeriodRepository.GetByKey(ca.Allocation.fundingStreamPeriodCode).SummaryOfFundingDisplayName;
                                        // first add the allocation
                                        List<RowTypeWithFormattingInfo> rowTypeWithFormattingInfos =
                                        new List<RowTypeWithFormattingInfo>
                                        {
                                                new RowTypeWithFormattingInfo(
                                                    isFundingStreamNameRow:false,
                                                    isOfWhichRow: false)
                                                {
                                                    MergeFields = new List<MergeFieldType>
                                                    {
                                                        new MergeFieldType($"Column1",fspSummaryOfFundingDisplayName),
                                                        new MergeFieldType($"Column2",ca.Allocation.contractAllocationNumber),
                                                        new MergeFieldType($"Column3",rowValues.PeriodOne.ToString(rowCellMoneyFormat)),
                                                        new MergeFieldType($"Column4",rowValues.PeriodTwo.ToString(rowCellMoneyFormat)),
                                                        new MergeFieldType($"Column5",rowValues.Total.ToString(rowCellMoneyFormat))
                                                    },
                                                    Total = rowValues.Total
                                                }
                                        };

                                    // now add the 'of which' deliverables, if there are any
                                    rowTypeWithFormattingInfos.AddRange(
                                        deliverablesToDisplay
                                        .Select(deliverableToDisplay => new RowTypeWithFormattingInfo(false, isOfWhichRow: true)
                                        {
                                            MergeFields = new List<MergeFieldType>
                                            {
                                                new MergeFieldType("Column1", Constants.SubRowMarker + Constants.IndentTextMarker + deliverableToDisplay.DisplayNameOnSoF),
                                                new MergeFieldType("Column2", string.Empty),
                                                new MergeFieldType("Column3",
                                                    GetFormattedTotalValue(GetDeliverablePeriodsForDeliverable(ca.Allocation, deliverableToDisplay.Deliverable.deliverable.deliverableCode),
                                                        cdp => IsInFyOne(cdp, periodStartYear, periodEndYear))),
                                                new MergeFieldType("Column4",
                                                    GetFormattedTotalValue(GetDeliverablePeriodsForDeliverable(ca.Allocation, deliverableToDisplay.Deliverable.deliverable.deliverableCode),
                                                        cdp => IsInFyTwo(cdp, periodStartYear, periodEndYear))),
                                                new MergeFieldType("Column5",
                                                    GetFormattedTotalValue(GetDeliverablePeriodsForDeliverable(ca.Allocation, deliverableToDisplay.Deliverable.deliverable.deliverableCode),
                                                        cdp => true))
                                            }
                                        })
                                    );

                                    // add any 'of which Sector-based Work Academies' line
                                    if (IsFundingStreamPeriodWithSectorBasedWorkAcademyProvision(ca.Allocation.fundingStreamPeriodCode))
                                    {
                                        decimal financialEnvelope1Funding = 0;
                                        decimal financialEnvelope2Funding = 0;

                                        var referenceConfigOption = _contractReferenceConfigRepository.GetContractReferenceConfig(
                                            ca.Allocation.GetDeliverOrgOrDefault(contract.contractor.ukprn),
                                            ca.Allocation.fundingStreamPeriodCode);

                                        referenceConfigOption.MatchSome(referenceConfig =>
                                        {
                                            financialEnvelope1Funding = referenceConfig.FinancialEnvelope1Funding;
                                            financialEnvelope2Funding = referenceConfig.FinancialEnvelope2Funding;
                                        });

                                        rowTypeWithFormattingInfos.Add(new RowTypeWithFormattingInfo(false, true)
                                        {
                                            MergeFields = new List<MergeFieldType>
                                            {
                                                new MergeFieldType("Column1", Constants.SubRowMarker + Constants.IndentTextMarker + "of which Sector-based Work Academies"),
                                                new MergeFieldType("Column2", string.Empty),
                                                new MergeFieldType("Column3", financialEnvelope1Funding.ToString("£#,##0")),
                                                new MergeFieldType("Column4", financialEnvelope2Funding.ToString("£#,##0")),
                                                new MergeFieldType("Column5", (financialEnvelope1Funding + financialEnvelope2Funding).ToString("£#,##0"))
                                            }
                                        });
                                    }

                                    return rowTypeWithFormattingInfos;
                                }));

                            return rows;
                        }
                        )
                        .ToList();
            }
        }

        private static bool IsFundingStreamPeriodWithSectorBasedWorkAcademyProvision(string fundingStreamPeriodCode)
        {
            const string fspWithSectorBasedWorkAcademyProvision = "AEB-AS2021";

            return fspWithSectorBasedWorkAcademyProvision == fundingStreamPeriodCode;
        }

        private static bool IsLastContract(ContractTableInfo contractTableInfo,
            List<ContractTableInfo> contractTableInfos)
        {
            return object.ReferenceEquals(contractTableInfo, contractTableInfos.Last());
        }

        private static IEnumerable<contractDeliverablePeriodsTypeContractDeliverablePeriod> GetDeliverablePeriodsForDeliverable(
            contractAllocationsContractAllocation allocation,
            int deliverableCode)
        {
            return allocation.GetAllDeliverables()
                .Where(d => d.deliverable.deliverableCode == deliverableCode)
                .SelectMany(d => d.contractDeliverablePeriods)
                .ToList();
        }

        private static string GetFormattedTotalValue(
            IEnumerable<contractDeliverablePeriodsTypeContractDeliverablePeriod> deliverablePeriods,
            Func<contractDeliverablePeriodsTypeContractDeliverablePeriod, bool> periodFilter)
        {
            return deliverablePeriods
                .Where(periodFilter)
                .Sum(cdp => cdp.plannedValue)
                .ToString("£#,##0");
        }
        
        private static ContractTableInfo GenerateContractTableInfo(contractType contract, decimal contractTotal, List<RowType> allocationRows)
        {
            if (contract.fundingType.fundingTypeCode == "19TRN2020" && contract.GetFundingPeriod() == "AY2021")
            {
                return new ContractTableInfo(
                    allocationRows,
                    "1 February 2021 to 31 July 2021",
                    "Feb 21 - Mar 21",
                    contract.GetAebFinancialEnvelopePeriod2(),
                    contract.startDate.Value,
                    contractTotal);
            }

            return new ContractTableInfo(
                allocationRows,
                contract.GetAebFinancialPeriod(),
                contract.GetAebFinancialEnvelopePeriod1(),
                contract.GetAebFinancialEnvelopePeriod2(),
                contract.startDate.Value,
                contractTotal);
        }
    }
}
