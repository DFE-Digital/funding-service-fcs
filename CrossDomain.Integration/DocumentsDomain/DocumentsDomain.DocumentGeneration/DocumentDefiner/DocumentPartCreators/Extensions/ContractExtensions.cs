namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Appendix1.Dtos;
    using Common;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Repositories;
    using DocumentConfiguration;

    public static class ContractExtensions
    {
        private const string NovemberStartFundingPeriod = "AY1718";
        private const string AY2021FundingPeriod = "AY2021";
        private const string Traineeships19To24ProcFundingType = "19TRN2020";


        public static string GetProviderName(this contractType contractType)
        {
            return contractType.contractor.legalName.ToUpper();
        }

        public static string GetAebFinancialPeriod(this contractType contractType)
        {
            string startYear = contractType.StartYearOfPeriod();
            string endYear = contractType.EndYearOfPeriod();

            return GetFinancialPeriod(startYear, endYear, contractType.GetFundingPeriod(), contractType.fundingType.fundingTypeCode);
        }

        public static string GetAebFinancialEnvelopePeriod1(this contractType contractType)
        {
            string startYear = contractType.StartYearOfPeriod();
            string endYear = contractType.EndYearOfPeriod();

            return GetFinancialEnvelope1(startYear, endYear, contractType.GetFundingPeriod(), contractType.fundingType.fundingTypeCode);
        }

        public static string GetAebFinancialEnvelopePeriod2(this contractType contractType)
        {
            string endYear = contractType.EndYearOfPeriod();

            return GetFinancialEnvelope2(endYear);
        }

        public static decimal GetSharedMasterContractsTotal(this contractType contractType)
        {
            return contractType.SharedMasterApprovedContracts.Sum(c => c.Allocations.Sum(a => a.TotalPlannedValue));
        }

        public static IReadOnlyCollection<ContractTableInfo> GetSharedMasterContractTableInfos(
            this contractType contractType, IFundingStreamPeriodRepository fspRepository, IDocumentConfigurationSource documentConfigurationSource, string moneyFormat = "£#,##0")
        {
            return contractType.SharedMasterApprovedContracts.Select(c =>
            {
                string startYear = c.FundingPeriod.Substring(2, 2);
                string endYear = c.FundingPeriod.Substring(4, 2);
                string fundingType = contractType.fundingType.fundingTypeCode;
                string financialPeriod = GetFinancialPeriod(startYear, endYear, c.FundingPeriod, fundingType);
                string financialEnvelopePeriod1 = GetFinancialEnvelope1(startYear, endYear, c.FundingPeriod, fundingType);
                string financialEnvelopePeriod2 = GetFinancialEnvelope2(endYear);
                decimal contractPlannedValue = c.Allocations.Sum(a => a.TotalPlannedValue);

                var allocationsWithDisplayOrder = c.Allocations.Select(a => new
                    {
                        Allocation = a,
                        fspRepository.GetByKey(a.FundingStreamPeriodCode).DisplayOrder
                    }).ToList();

                return new ContractTableInfo(
                    allocationRowTypes: allocationsWithDisplayOrder
                        .OrderBy(a => a.DisplayOrder)
                        .SelectMany(a =>
                        {
                            var allocation = a.Allocation;
                            string fspSummaryOfFundingDisplayName =
                                fspRepository.GetByKey(a.Allocation.FundingStreamPeriodCode).SummaryOfFundingDisplayName;

                            var rows = new List<RowTypeWithFormattingInfo>
                            {
                                new RowTypeWithFormattingInfo(false, false)
                                {
                                    MergeFields = new List<MergeFieldType>
                                    {
                                        new MergeFieldType("Column1", fspSummaryOfFundingDisplayName),
                                        new MergeFieldType("Column2", allocation.ContractAllocationNumber),
                                        new MergeFieldType("Column3", allocation.PlannedValueEnvelope1.ToString(moneyFormat)),
                                        new MergeFieldType("Column4", allocation.PlannedValueEnvelope2.ToString(moneyFormat)),
                                        new MergeFieldType("Column5", allocation.TotalPlannedValue.ToString(moneyFormat))
                                    },
                                }
                            };

                            var deliverablesToDisplay = a.Allocation.Deliverables
                                .Select(d => new
                                {
                                    Deliverable = d,
                                    ShouldDisplayOnSummaryOfFunding = documentConfigurationSource.ShouldDisplayDeliverableOnSummaryOfFunding(a.Allocation.FundingStreamPeriodCode, d.DeliverableCode),
                                    DisplayNameOnSoF = documentConfigurationSource.GetDeliverableNameForSummaryOfFunding(a.Allocation.FundingStreamPeriodCode, d.DeliverableCode)
                                })
                                .Where(d => d.ShouldDisplayOnSummaryOfFunding)
                                .ToList();

                            // now add the 'of which' deliverables, if there are any
                            rows.AddRange(
                                deliverablesToDisplay
                                .Select(deliverableToDisplay => new RowTypeWithFormattingInfo(false, isOfWhichRow: true)
                                {
                                    MergeFields = new List<MergeFieldType>
                                    {
                                        new MergeFieldType("Column1", Constants.SubRowMarker + Constants.IndentTextMarker + deliverableToDisplay.DisplayNameOnSoF),
                                        new MergeFieldType("Column2", string.Empty),
                                        new MergeFieldType("Column3", deliverableToDisplay.Deliverable.PlannedValueEnvelope1?.ToString(moneyFormat)),
                                        new MergeFieldType("Column4", deliverableToDisplay.Deliverable.PlannedValueEnvelope2?.ToString(moneyFormat)),
                                        new MergeFieldType("Column5", deliverableToDisplay.Deliverable.TotalPlannedValue.ToString(moneyFormat))
                                    }
                                })
                            );

                            return rows;
                        })
                        .Cast<RowType>()
                        .ToList(),
                    fundingPeriod: financialPeriod,
                    financialEnvelopePeriod1: financialEnvelopePeriod1,
                    financialEnvelopePeriod2: financialEnvelopePeriod2,
                    startDate:c.StartDate,
                    contractTotal: contractPlannedValue
                );
            }).ToList();
        }

        private static string GetFinancialPeriod(string startYear, string endYear, string fundingPeriod, string fundingType)
        {
            if (fundingPeriod == NovemberStartFundingPeriod)
            {
                return "1 November 2017 to 31 July 2018";
            }

            if(fundingPeriod == AY2021FundingPeriod && fundingType == Traineeships19To24ProcFundingType)
            {
                return "1 February 2021 to 31 July 2021";
            }

            return $"1 August 20{startYear} to 31 July 20{endYear}";
        }

        private static string GetFinancialEnvelope1(string startYear, string endYear, string fundingPeriod, string fundingType)
        {
            if (fundingPeriod == NovemberStartFundingPeriod)
            {
                return "Nov 17 - Mar 18";
            }

            if (fundingPeriod == AY2021FundingPeriod && fundingType == Traineeships19To24ProcFundingType)
            {
                return "Feb 21 - Mar 21";
            }

            return $"Aug {startYear} - Mar {endYear}";
        }

        private static string GetFinancialEnvelope2(string endYear)
        {
            return $"Apr {endYear} - Jul {endYear}";
        }

        private static string StartYearOfPeriod(this contractType contractType)
        {
            return contractType.period.period1.Substring(0, 2);
        }

        private static string EndYearOfPeriod(this contractType contractType)
        {
            return contractType.period.period1.Substring(2, 2);
        }
    }
}