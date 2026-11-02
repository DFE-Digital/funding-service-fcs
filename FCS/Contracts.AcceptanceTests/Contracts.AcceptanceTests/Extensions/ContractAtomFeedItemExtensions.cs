namespace SFA.FCT.Contracts.AcceptanceTests.Extensions
{
    using System.Linq;
    using ContractManagement.DataStore.Model;

    public static class ContractAtomFeedItemExtensions
    {
        public static int GetVersionNumber(this AtomFeedItem item)
        {
            // the Business key: [ContractNo]:[Version].[Subversion]
            return int.Parse(item.BusinessKey.Split(':').Last().Split('.').First());
        }
    }
}
