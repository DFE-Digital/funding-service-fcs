namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Common;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentConfiguration;
    using Integration;

    public abstract class MultipleOrgAppendix1CreatorBase : DocumentPartCreator
    {
        private static readonly string[] RegularAppendixOneColumnNames =
            {"Column1", "Column2", "Column3", "Column4", "Column5"};

        private static readonly string[] LoansAppendixOneColumnNames =
            { "AllocationName", "AllocationContractRef", "AllocationPeriodOneTotal", "AllocationPeriodTwoTotal", "AllocationTotal" };

        private readonly Dictionary<string, string[]> _columnNamesForFundingType = new Dictionary<string, string[]>
        {
            { "AEB", RegularAppendixOneColumnNames },
            { "MAIN", RegularAppendixOneColumnNames },
            { "24+LOANS", LoansAppendixOneColumnNames },
            { "LOANS", LoansAppendixOneColumnNames }
        };

        protected MultipleOrgAppendix1CreatorBase(ITemplateRepository templateRepository, IDocumentConfigurationSource documentConfigurationSource) : base(templateRepository, documentConfigurationSource)
        {
        }

        protected virtual Func<contractAllocationsContractAllocation, string> OrderAllocationBy { get { return (ca) => string.Empty; } }

        protected RepeatingSectionType GetMainTableRepeatingSection(string tableRepeatingSectionName, contractType contract, Dictionary<string, int> parentDeliverableCodeForFsp)
        {
            string[] columnNames = _columnNamesForFundingType[contract.fundingType.fundingTypeCode];

            int periodStartYear = GetStartYearFromPeriod(contract.period);
            int periodEndYear = GetEndYearFromPeriod(contract.period);

            bool hasMultipleOrgs = DoesContractHaveDeliveryOrgsDifferentToTheContractingOrg(contract);

            return new RepeatingSectionType(tableRepeatingSectionName)
            {
                Rows = contract.contractAllocations
                    .OrderBy(OrderAllocationBy)
                    .SelectMany(ca => ca.contractDeliverables
                        .Select(d => new
                        {
                            FspCode = ca.fundingStreamPeriodCode,
                            Name = DocumentConfigurationSource.GetAllocationName(ca),
                            Reference = hasMultipleOrgs
                                    ? ca.GetAllocationPrefix()
                                    : ca.contractAllocationNumber,
                            FyOnePlannedValue = d.contractDeliverablePeriods
                                .Where(cdp => IsInFyOne(cdp, periodStartYear, periodEndYear))
                                .Sum(cdp => cdp.plannedValue),
                            FyTwoPlannedValue = d.contractDeliverablePeriods
                                .Where(cdp => IsInFyTwo(cdp, periodStartYear, periodEndYear))
                                .Sum(cdp => cdp.plannedValue),
                            ShouldDisplayOnSummaryOfFunding = DocumentConfigurationSource.ShouldDisplayDeliverableOnSummaryOfFunding(ca, d),
                            DisplayNameOnSoF = DocumentConfigurationSource.GetDeliverableNameForSummaryOfFunding(ca, d.deliverable.deliverableCode),
                            IsTopLevelDeliverable = d.deliverable.deliverableCode == parentDeliverableCodeForFsp[ca.fundingStreamPeriodCode],
                            DeliverableCode = d.deliverable.deliverableCode
                        }))
                    .ToLookup(deliverableInfo => new RowKeyInfo(deliverableInfo.FspCode, deliverableInfo.Name, deliverableInfo.Reference))
                    .SelectMany(g =>
                    {
                        Logger.LogVerbose("Adding group {0} to the {1} Document", g.Key, contract.fundingType.fundingTypeCode);

                        RowKeyInfo rowKeyInfo = g.Key;
                        var deliverablesForTopLevelSum = g.Where(d => d.IsTopLevelDeliverable).ToList();

                        List<RowType> tempRows = new List<RowType>
                        {
                            new RowType
                            {
                                MergeFields = new List<MergeFieldType>
                                {
                                    new MergeFieldType(columnNames[0], rowKeyInfo.Name),
                                    new MergeFieldType(columnNames[1], rowKeyInfo.Reference),
                                    new MergeFieldType(columnNames[2], deliverablesForTopLevelSum.Sum(cd => cd.FyOnePlannedValue).ToString(Constants.DecimalToValueFormat)),
                                    new MergeFieldType(columnNames[3], deliverablesForTopLevelSum.Sum(cd => cd.FyTwoPlannedValue).ToString(Constants.DecimalToValueFormat)),
                                    new MergeFieldType(columnNames[4], deliverablesForTopLevelSum.Sum(cd => cd.FyOnePlannedValue + cd.FyTwoPlannedValue).ToString(Constants.DecimalToValueFormat))
                                }
                            }
                        };

                        // add "of which..." rows immediately after the Funding Stream they are relevant to
                        tempRows.AddRange(new List<RowType>(
                            g.Where(cd => cd.ShouldDisplayOnSummaryOfFunding)
                                .GroupBy(cd => cd.DeliverableCode)
                                .Select(cdGroup => new RowType
                                {
                                    MergeFields = new List<MergeFieldType>
                                    {
                                        new MergeFieldType(columnNames[0], Constants.SubRowMarker + Constants.IndentTextMarker + cdGroup.First().DisplayNameOnSoF),
                                        new MergeFieldType(columnNames[1], string.Empty),
                                        new MergeFieldType(columnNames[2], cdGroup.Sum(cd => cd.FyOnePlannedValue).ToString(Constants.DecimalToValueFormat)),
                                        new MergeFieldType(columnNames[3], cdGroup.Sum(cd => cd.FyTwoPlannedValue).ToString(Constants.DecimalToValueFormat)),
                                        new MergeFieldType(columnNames[4], cdGroup.Sum(cd => cd.FyOnePlannedValue + cd.FyTwoPlannedValue).ToString(Constants.DecimalToValueFormat))
                                    }
                                })));

                        return tempRows;
                    })
                .ToList()
            };
        }

        private bool DoesContractHaveDeliveryOrgsDifferentToTheContractingOrg(contractType contract)
        {
            return contract.contractAllocations.Any(ca =>
                ca.HasDeliveryOrganisation() 
                && ca.DeliveryOrganisation != contract.contractor.ukprn.ToString());
        }

        private class RowKeyInfo
        {
            public RowKeyInfo(string fspCode, string name, string reference)
            {
                FundingStreamPeriodCode = fspCode;
                Name = name;
                Reference = reference;
            }

            public string FundingStreamPeriodCode { get; }

            public string Name { get; }

            public string Reference { get; }

            public override bool Equals(object obj)
            {
                if (ReferenceEquals(null, obj)) return false;
                if (ReferenceEquals(this, obj)) return true;
                if (obj.GetType() != this.GetType()) return false;
                return Equals((RowKeyInfo)obj);
            }

            public override int GetHashCode()
            {
                return (FundingStreamPeriodCode != null ? FundingStreamPeriodCode.GetHashCode() : 0)
                       ^ (Name != null ? Name.GetHashCode() : 0)
                       ^ (Reference != null ? Reference.GetHashCode() : 0);
            }

            private bool Equals(RowKeyInfo other)
            {
                return string.Equals(FundingStreamPeriodCode, other.FundingStreamPeriodCode)
                    && string.Equals(Name, other.Name)
                    && string.Equals(Reference, other.Reference);
            }
        }
    }
}