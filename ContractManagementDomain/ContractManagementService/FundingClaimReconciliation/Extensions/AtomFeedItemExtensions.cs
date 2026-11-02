namespace SFA.FCT.ContractManagementService.FundingClaimReconciliation.Extentions
{
    using System;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public static class AtomFeedItemExtensions
    {
        public static string GetSyndicationContentTitle(this AtomFeedItem atomFeedItem)
        {
            switch (atomFeedItem.ItemType)
            {
                case AtomItemType.Published:
                    return string.Format($"Funding Claim Reconciliation for Provider {atomFeedItem.Ukprn} for Claim Type {atomFeedItem.ClaimTypeName} and Allocation Group {atomFeedItem.AllocationGroupName} period {atomFeedItem.Period} is Published");

                default:
                    throw new ArgumentOutOfRangeException("Unknown AtomItemType generating Summary");
            }
        }
    }
}
