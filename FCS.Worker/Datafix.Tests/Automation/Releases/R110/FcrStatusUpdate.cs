namespace Datafix.Tests.Automation.Releases.R110
{
    using Datafix.Tests.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class FcrStatusUpdate : IApplyDataFix
    {
        public string Release => "R110";

        public int StoryNumber => 35862;

        public string Name => "Update FCR (10045119) to manually published";

        public int Order => 2;

        public void ApplyDataFix()
        {
            FundingClaimReconciliationRepository.UpdateStatusAndSubStatus(
                10045119,
                sfa_sfastatuscode.Published,
                sfa_sfasubstatuscode.ManuallyPublished,
                nameStartsWith: "2021_Final");
        }
    }
}