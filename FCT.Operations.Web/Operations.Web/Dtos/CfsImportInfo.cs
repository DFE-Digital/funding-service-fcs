namespace Operations.Web.Dtos
{
    using System;

    public class CfsImportInfo
    {
        public DateTime? RunStart { get; }
        public DateTime? RunEnd { get; }
        public string AllFundingAllocationsRead { get; }
        public string AllFundingAllocationsProcessed { get; }
        public int FundingAllocationsReceived { get; }
        public int ProviderFundingsReceived { get; }
        public int FundingAllocationPutInCrm { get; }
        public int FundingAllocationsDiscarded { get; }
        public int FundingAllocationsParked { get; }
        public int TotalRowsInTable { get; }
        public bool DoTotalsReconcile => FundingAllocationsReceived == 
            FundingAllocationPutInCrm + FundingAllocationsDiscarded + FundingAllocationsParked;

        public CfsImportInfo(DateTime? runStart, DateTime? runEnd, string allFundingAllocationsRead,
            string allFundingAllocationsProcessed, int fundingAllocationsReceived, int providerFundingsReceived,
            int fundingAllocationPutInCrm, int fundingAllocationsDiscarded, int fundingAllocationsParked,
            int totalRowsInTable)
        {
            RunStart = runStart;
            RunEnd = runEnd;
            AllFundingAllocationsRead = allFundingAllocationsRead;
            AllFundingAllocationsProcessed = allFundingAllocationsProcessed;
            FundingAllocationsReceived = fundingAllocationsReceived;
            ProviderFundingsReceived = providerFundingsReceived;
            FundingAllocationPutInCrm = fundingAllocationPutInCrm;
            FundingAllocationsDiscarded = fundingAllocationsDiscarded;
            FundingAllocationsParked = fundingAllocationsParked;
            TotalRowsInTable = totalRowsInTable;
        }
    }
}