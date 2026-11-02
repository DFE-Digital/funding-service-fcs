namespace SFA.FCT.Contracts.AcceptanceTests.Pages.DTO
{
    public class PerformanceManagementAtomFeedItemBusinessKey
    {
        
        public PerformanceManagementAtomFeedItemBusinessKey(int ukprn, string period, string claimTypeName, int itemType, string allocationGroupCode)
        {
            Ukprn = ukprn;
            Period = period;
            ClaimTypeName = claimTypeName;
            ItemType = itemType;
            AllocationGroupCode = allocationGroupCode;
        }

        public int Ukprn { get; }

        public string Period { get; }

        public string ClaimTypeName { get; }

        public int ItemType { get; }

        public string AllocationGroupCode { get; }
    }
}
