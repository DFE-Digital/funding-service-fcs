namespace FundingAllocation.DataStore.Model
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Dto;
    using Extensions;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public enum FundingAllocationStatus
    {
        NotSet,
        ContractApproved,
        Withdrawn,
        Parked,
        Discarded,
        ParkedPending,
        InRelease
    }

    public enum FundingAllocationSubStatus
    {
        NotSet,
        Superseded,
        NonMaterialUpdate,
        AwaitingOutcome,
        Withdrawn,
        ContractApproved,
        AwaitingFundingAllocationConfig,
        AwaitingContractTypeConfig,
        AwaitingFundingLineConfig,
        AwaitingProvider,
        ProviderCheck,
        Queued,
        NonMaterial,
        NonMutualExclusive
    }

    public class FundingAllocation
    {
        private FundingAllocation()
        {
        }

        public FundingAllocation(string fundingId, string fundingVersion, string period,
            string allocationFundingStream, string ukprn, decimal value,
            int pageNumber, int positionInPage, int providerFundingCount,
            int readId)
        {
            FundingId = fundingId;
            FundingVersion = fundingVersion;
            Period = period;
            AllocationFundingStream = allocationFundingStream;
            UKPRN = ukprn;
            Value = value;
            PageNumber = pageNumber;
            PositionInPage = positionInPage;
            ProviderFundingCount = providerFundingCount;
            ReadId = readId;
            FundingAllocationName = FundingId.RemoveVersionFromId();
        }

        /// <remarks>
        /// Represents the unique ID (the bookmark) of an entry in the atom feed.
        /// </remarks>
        public string FundingId { get; private set; }

        public string FundingVersion { get; private set; }

        public string Period { get; private set; }

        public string AllocationFundingStream { get; private set; }

        public string UKPRN { get; private set; }

        public decimal Value { get; private set; }

        public int PageNumber { get; private set; }

        public int PositionInPage { get; private set; }

        public int ProviderFundingCount { get; private set; }

        public Contract Contract { get; set; }

        public int? ContractId { get; set; }

        public Guid? CrmEntityId { get; set; }

        public ReleaseGroup ReleaseGroup { get; set; }
        
        public ParkingAndDiscardedInfo ParkingAndDiscardedInfo { get; set; }

        public int? ReleaseGroupId { get; set; }

        public int ReadId { get; private set; }

        public string Status { get; set; }

        public FundingAllocationStatus FundingAllocationStatus
        {
            get
            {
                if (Status.HasValue())
                {
                    return (FundingAllocationStatus)Enum.Parse(typeof(FundingAllocationStatus), Status);
                }

                return FundingAllocationStatus.NotSet;
            }
            set => Status = (value != FundingAllocationStatus.NotSet) ? value.ToString() : null;
        }

        public string FundingAllocationName { get; private set; }

        public string SubStatus { get; set; }

        public bool IsPublished { get; set; }

        public FundingAllocationSubStatus FundingAllocationSubStatus
        {
            get
            {
                if (SubStatus.HasValue())
                {
                    return (FundingAllocationSubStatus)Enum.Parse(typeof(FundingAllocationSubStatus), SubStatus);
                }

                return FundingAllocationSubStatus.NotSet;
            }
            set => SubStatus = (value != FundingAllocationSubStatus.NotSet) ? value.ToString() : null;
        }

        public FundingAllocationPageControl FundingAllocationPageControl { get; set; }

        public List<ProviderFundingAllocation> ProviderFundingAllocations { get; private set; } = new List<ProviderFundingAllocation>();

        public decimal GetTotalPlannedValue() =>
            ProviderFundingAllocations
                .Sum(pfa =>
                    pfa.ProviderFunding.FundingAllocationLines
                        .SelectMany(fal => fal.FundingAllocationProfilePeriods)
                        .Sum(p => p.PlannedValue));

        public IReadOnlyCollection<(FundingAllocationLine fundingAllocationLine, ProviderFundingAllocation providerFundingAllocation, string allocationFundingStream, string cfsPeriod, string contractingUkprn)>
            GetProviderAllocationLines() =>
            ProviderFundingAllocations.SelectMany(pfa =>
                pfa.ProviderFunding.FundingAllocationLines.Select(fundingAllocationLine => (fundingAllocationLine, pfa, AllocationFundingStream, Period, UKPRN))).ToList();

        public IReadOnlyCollection<FundingAllocationLine> GetFundingAllocationLines() => ProviderFundingAllocations
            .SelectMany(pfa => pfa.ProviderFunding.FundingAllocationLines).ToList();

        public ContractItemsMappingInput GetContractItemsMappingInput()
        {
            ProviderFundingAllocations.ShouldNotBeEmpty("FundingAllocation must have one or more ProviderFundingAllocations");
            var providerFundings = ProviderFundingAllocations.Select(pfa => pfa.ProviderFunding).ToList();

            var firstProviderFunding = providerFundings.First();

            return new ContractItemsMappingInput(AllocationFundingStream, Period, firstProviderFunding.ProviderType, firstProviderFunding.ProviderSubType, UKPRN);
        }

        public FundingAllocationValidationInput ToValidationInput()
        {
            var fundingLineCodes = ProviderFundingAllocations.Select(pfa => pfa.ProviderFunding).SelectMany(pfa => pfa.FundingAllocationLines.Select(l => l.FundingLineCode))
                .ToList();

            return new FundingAllocationValidationInput(FundingId, GetContractItemsMappingInput(), fundingLineCodes);
        }

        public void RemoveLines(IReadOnlyCollection<FundingAllocationLine> linesToBeRemoved)
        {
            ProviderFundingAllocations.ToList().ForEach(pfa =>
            {
                pfa.ProviderFunding.FundingAllocationLines =
                    pfa.ProviderFunding.FundingAllocationLines.WhereNotIn(linesToBeRemoved).ToList();
            });
        }

        public bool HasLinesOfInterest => ProviderFundingAllocations
            .SelectMany(p => p.ProviderFunding.FundingAllocationLines.Where(l => !l.IsOfNoInterest)).Any();

        public int UkprnAsInt() => int.Parse(UKPRN);
    }
}