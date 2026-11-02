namespace SFA.FCT.ContractManagementService.FundingClaimReconciliation.Extentions
{
    using System;
    using PerformanceManagementDomain.DataStore.Models;

    public static class AtomItemTypeExtensions
    {
        public static string GetCategoryTerm(this AtomItemType itemType)
        {
            switch (itemType)
            {
                case AtomItemType.Published:
                    return "Funding Claim Reconciliation Published";

                default:
                    throw new ArgumentOutOfRangeException("Unknown AtomItemType generating Category Term");
            };
        }

        public static string GetCategoryLabel(this AtomItemType itemType)
        {
            switch (itemType)
            {
                case AtomItemType.Published:
                    return "A funding claim reconciliation has been published";

                default:
                    throw new ArgumentOutOfRangeException("Unknown AtomItemType generating Category Label");
            }
        }
    }
}
