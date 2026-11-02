namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix1
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Aspose.Words;
    using Aspose.Words.Tables;
    using Common;
    using Common.Models;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Repositories;
    using DocumentConfiguration;
    using Extensions;
    using Integration;
    using PaymentManagementDomain.PolicyCache.DataStore.Repositories;
    using Dtos;
    using Repositories;
    using FundingTypeFundingPeriod = ContractManagement.DataStore.Model.FundingTypeFundingPeriod;

    public class EdskSummaryOfFundingDocumentPartCreator : DocumentPartCreator
    {
        private static readonly IList<string> FundingTypesSupported = new List<string> { "EDSK" };

        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;
        private readonly IPayCalcPolicyQueryRepository _payCalcPolicyQueryRepository;
        private readonly IFundingStreamPeriodRepository _fundingStreamPeriodRepository;
        private readonly IContractReferenceConfigRepository _contractReferenceConfigRepository;

        public EdskSummaryOfFundingDocumentPartCreator(
            ITemplateRepository templateRepository,
            IDocumentConfigurationSource documentConfigurationSource,
            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository,
            IPayCalcPolicyQueryRepository payCalcPolicyQueryRepository,
            IFundingStreamPeriodRepository fundingStreamPeriodRepository, 
            IContractReferenceConfigRepository contractReferenceConfigRepository)
            : base(templateRepository, documentConfigurationSource)
        {
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;
            _payCalcPolicyQueryRepository = payCalcPolicyQueryRepository;
            _fundingStreamPeriodRepository = fundingStreamPeriodRepository;
            _contractReferenceConfigRepository = contractReferenceConfigRepository;
        }

        public override bool IsHeaderDocumentRequired => false;

        public override string RequiredHeaderDocumentName => throw new ApplicationException("Header document name requested but not required");

        public override bool IsDocumentPartRequired(contractType contract) => FundingTypesSupported.Contains(contract.fundingType.fundingTypeCode);

        public override IDictionary<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(
            string masterContractNumber,
            contractType contract,
            string templateContainer)
        {
            var topLevelParentDeliverableCodesGroupedByFsp = contract.contractAllocations.GetTopLevelParentDeliverableCodes(_payCalcPolicyQueryRepository);

            int periodStartYear = GetStartYearFromPeriod(contract.period);
            int periodEndYear = GetEndYearFromPeriod(contract.period);

            FundingTypeFundingPeriod fundingTypeFundingPeriod =
                _fundingTypeFundingPeriodQueryRepository.Get(contract.fundingType.fundingTypeCode, contract.GetFundingPeriod());

            string templateFilename = GetNameOfTemplateActiveOnDate(templateContainer, fundingTypeFundingPeriod.TemplateName, contract.startDate.GetValueOrDefault());

            IReadOnlyCollection<RowTypeWithFormattingInfo> allocationRowsWithFormattingInfo = GetAllocationRowsWithFormattingInfo();
            decimal contractTotal = allocationRowsWithFormattingInfo.Where(r => !r.IsOfWhichRow)
                .Sum(r => r.Total);
            contractTotal = decimal.Truncate(contractTotal);

            List<RowType> allocationRows = allocationRowsWithFormattingInfo.Cast<RowType>().ToList();
            IReadOnlyCollection<FormattingInfo> formattingInfo = allocationRowsWithFormattingInfo.Select(ar => ar.FormattingInfo).ToList();

            return new Dictionary<string, DocumentGenerationRequest>
            {
                {
                    "1000", // place before all other parts
                    new DocumentGenerationRequest
                    {
                        TemplateContainer = templateContainer,
                        TemplateFilename = templateFilename,
                        MergeData = new DocumentGenerationRequestMergeData
                        {
                            MergeFields = new List<MergeFieldType>
                            {
                                new MergeFieldType("ContractingOrgName", contract.contractor.legalName),
                                new MergeFieldType("ContractingOrgUkprn", contract.contractor.ukprn.ToString()),
                                new MergeFieldType("ContractTotal", contractTotal.ToString("£#,##0")),
                                new MergeFieldType("MasterContractRef", masterContractNumber),
                            },
                            RepeatingSections = new List<RepeatingSectionType>
                            {
                                new RepeatingSectionType("MainTable")
                                {
                                    Rows = allocationRows
                                }
                            }
                        },
                        MutateGeneratedDocument = doc => RemoveBordersFromAllocationTableRows(doc, formattingInfo),
                        IndentMarkersOverride = DocumentGenerationRequest.CleanupIndentMarkers
                    }
                }
            };

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
                            string fundingStreamName = DocumentConfigurationSource.GetAllocationName(allocation);

                            bool isSingleAllocationForFundingStreamPeriodAndDeliveredByContractingOrg =
                                IsSingleAllocationForFundingStreamPeriodAndDeliveredByContractingOrg(allocation.fundingStreamPeriodCode);

                            if (!isSingleAllocationForFundingStreamPeriodAndDeliveredByContractingOrg)
                            {
                                rows.Add(new RowTypeWithFormattingInfo(true, false)
                                {
                                    MergeFields = new List<MergeFieldType>
                                        {
                                            new MergeFieldType("FundingStreamName", fundingStreamName)
                                        }
                                });
                            }

                            var deliverablesToDisplay = allocationsForFundingStream.SelectMany(a => a.Allocation.GetAllDeliverables().Select(
                                    d =>
                                        new
                                        {
                                            Deliverable = d,
                                            ShouldDisplayOnSummaryOfFunding =
                                                DocumentConfigurationSource.ShouldDisplayDeliverableOnSummaryOfFunding(
                                                    a.Allocation, d),
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
                                    var deliverablePeriodsForParentCodes =
                                        ca.Allocation.GetDeliverablePeriodsForDeliverables(parentDeliverableCodes);
                                    var periodOneTotal = deliverablePeriodsForParentCodes.GetTotalValue(
                                        cdp => IsInFyOne(cdp, periodStartYear, periodEndYear));

                                    var periodTwoTotal = deliverablePeriodsForParentCodes.GetTotalValue(
                                        cdp => IsInFyTwo(cdp, periodStartYear, periodEndYear));

                                    var unroundedTotal = deliverablePeriodsForParentCodes.GetTotalValue(
                                        cdp => true);

                                    var rowValues = EdskSummaryOfFundingRoundingService.GetSummaryRowResult(periodOneTotal,
                                        periodTwoTotal, unroundedTotal, ca.Allocation.fundingStreamPeriodCode);

                                        // first add the allocation
                                        List<RowTypeWithFormattingInfo> rowTypeWithFormattingInfos =
                                        new List<RowTypeWithFormattingInfo>
                                        {
                                                new RowTypeWithFormattingInfo(
                                                    isFundingStreamNameRow:isSingleAllocationForFundingStreamPeriodAndDeliveredByContractingOrg,
                                                    isOfWhichRow: false)
                                                {
                                                    MergeFields = new List<MergeFieldType>
                                                    {
                                                        new MergeFieldType("FundingStreamName",isSingleAllocationForFundingStreamPeriodAndDeliveredByContractingOrg
                                                                ? fundingStreamName
                                                                : ""),
                                                        new MergeFieldType("OrgName",isSingleAllocationForFundingStreamPeriodAndDeliveredByContractingOrg
                                                                ? ""
                                                                : ca.Allocation.DeliveryOrganisationDetail.legalName),
                                                        new MergeFieldType("AllocationRef",ca.Allocation.contractAllocationNumber),
                                                        new MergeFieldType("AllocationPeriodOneTotal",rowValues.PeriodOne.ToString(rowCellMoneyFormat)),
                                                        new MergeFieldType("AllocationPeriodTwoTotal",rowValues.PeriodTwo.ToString(rowCellMoneyFormat)),
                                                        new MergeFieldType("AllocationTotal",rowValues.Total.ToString(rowCellMoneyFormat))
                                                    },
                                                    Total = unroundedTotal
                                                }
                                        };

                                        // now add the 'of which' deliverables, if there are any
                                        rowTypeWithFormattingInfos.AddRange(
                                        deliverablesToDisplay
                                            .Where(deliverableToDisplay => IsDeliverablePresentInAllocation(ca.Allocation, deliverableToDisplay.Deliverable.deliverable.deliverableCode))
                                            .Select(deliverableToDisplay => new RowTypeWithFormattingInfo(false, isOfWhichRow: true)
                                            {
                                                MergeFields = new List<MergeFieldType>
                                                {
                                                        new MergeFieldType("FundingStreamName", string.Empty),
                                                        new MergeFieldType("OrgName", Constants.SubRowMarker + Constants.IndentTextMarker + deliverableToDisplay.DisplayNameOnSoF),
                                                        new MergeFieldType("AllocationRef", string.Empty),
                                                        new MergeFieldType("AllocationPeriodOneTotal",
                                                            GetFormattedTotalValue(GetDeliverablePeriodsForDeliverable(ca.Allocation, deliverableToDisplay.Deliverable.deliverable.deliverableCode),
                                                                cdp => IsInFyOne(cdp, periodStartYear, periodEndYear))),
                                                        new MergeFieldType("AllocationPeriodTwoTotal",
                                                            GetFormattedTotalValue(GetDeliverablePeriodsForDeliverable(ca.Allocation, deliverableToDisplay.Deliverable.deliverable.deliverableCode),
                                                                cdp => IsInFyTwo(cdp, periodStartYear, periodEndYear))),
                                                        new MergeFieldType("AllocationTotal",
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
                                                    new MergeFieldType("FundingStreamName", string.Empty),
                                                    new MergeFieldType("OrgName", Constants.SubRowMarker + Constants.IndentTextMarker + "of which Sector-based Work Academies"),
                                                    new MergeFieldType("AllocationRef", string.Empty),
                                                    new MergeFieldType("AllocationPeriodOneTotal", financialEnvelope1Funding.ToString("£#,##0")),
                                                    new MergeFieldType("AllocationPeriodTwoTotal",financialEnvelope2Funding.ToString("£#,##0")),
                                                    new MergeFieldType("AllocationTotal", (financialEnvelope1Funding + financialEnvelope2Funding).ToString("£#,##0")),
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

            bool IsSingleAllocationForFundingStreamPeriodAndDeliveredByContractingOrg(string fundingStreamPeriodCode)
            {
                IReadOnlyCollection<contractAllocationsContractAllocation> allocationsForFundingStreamPeriod = contract.contractAllocations
                    .Where(ca => ca.fundingStreamPeriodCode == fundingStreamPeriodCode)
                    .ToList();

                if (allocationsForFundingStreamPeriod.Count == 1)
                {
                    contractAllocationsContractAllocation singleAllocationForFundingStreamPeriod = allocationsForFundingStreamPeriod.Single();
                    return !singleAllocationForFundingStreamPeriod.HasDeliveryOrganisation() || singleAllocationForFundingStreamPeriod.DeliveryOrganisationDetail.ukprn == contract.contractor.ukprn;
                }

                return false;
            }

            IReadOnlyCollection<contractDeliverablePeriodsTypeContractDeliverablePeriod> GetDeliverablePeriodsForDeliverable(contractAllocationsContractAllocation allocation, int deliverableCode)
            {
                return allocation.GetAllDeliverables()
                    .Where(d => d.deliverable.deliverableCode == deliverableCode)
                    .SelectMany(d => d.contractDeliverablePeriods)
                    .ToList();
            }
        }

        private static bool IsFundingStreamPeriodWithSectorBasedWorkAcademyProvision(string fundingStreamPeriodCode)
        {
            const string fspWithSectorBasedWorkAcademyProvision = "AEBC-ASCL2021";

            return fspWithSectorBasedWorkAcademyProvision == fundingStreamPeriodCode;
        }

        private static void RemoveBordersFromAllocationTableRows(Document generateDocument, IEnumerable<FormattingInfo> formattingInfo)
        {
            Table table = (Table)generateDocument.GetChild(NodeType.Table, 1, true);

            Row[] allocationRows = table.Rows
                .Cast<Row>()
                .Take(table.Rows.Count - 1) // exclude footer row
                .Skip(2) // exclude header rows
                .ToArray();

            // all but the first allocation should have no top border
            allocationRows
                .Skip(1)
                .ToList()
                .ForEach(row => row.Cells.Cast<Cell>().ToList().ForEach(cell => cell.CellFormat.Borders.Top.LineStyle = LineStyle.None));

            // all but the last allocation should have no bottom border
            allocationRows
                .Take(allocationRows.Length - 1)
                .ToList()
                .ForEach(row => row.Cells.Cast<Cell>().ToList().ForEach(cell => cell.CellFormat.Borders.Bottom.LineStyle = LineStyle.None));

            // any funding stream name rows should have a top border
            allocationRows
                .Zip(formattingInfo, (r, f) => new { AsposeRow = r, Formatting = f })
                .Where(row => row.Formatting.IsFundingStreamNameRow)
                .ToList()
                .ForEach(row => row.AsposeRow.Cells.Cast<Cell>().ToList().ForEach(cell => cell.CellFormat.Borders.Top.LineStyle = LineStyle.Single));
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

        private static bool IsDeliverablePresentInAllocation(contractAllocationsContractAllocation allocation, int deliverableCode)
        {
            return allocation.GetAllDeliverables().Any(cd => cd.deliverable.deliverableCode == deliverableCode);
        }
    }
}