namespace Datafix.Tests.Automation.Releases.R99e
{
    using ContractManagement.DataStore.Model;
    using Services;
    using SFA.FCT.ContractManagementService.Common;

    public class PutCorrectVersionOfContractTerminationInitiatedOnFeed : IApplyDataFix
    {
        public string Release => "R99e";
        public int StoryNumber => 32792;
        public string Name => "Re-publish APPLEVY-2726 Contract Termination Initiated event on feed";
        public int Order => 1;
        public void ApplyDataFix()
        {
            AtomFeedService.AddItemToFeed(new ContractIdentifier(contractNumber: "APPLEVY-2726", versionNumber: 2, subVersionNumber: 0), AtomItemType.ContractTerminationInitiated);
        }
    }
}