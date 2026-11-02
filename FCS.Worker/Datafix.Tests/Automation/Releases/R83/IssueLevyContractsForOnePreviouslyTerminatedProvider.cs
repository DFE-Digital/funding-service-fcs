namespace Datafix.Tests.Automation.Releases.R83
{
    using System.Collections.Generic;

    public class IssueLevyContractsForOnePreviouslyTerminatedProvider : IApplyDataFix
    {
        public string Release => "R83";

        public int StoryNumber => 29658;

        public string Name => "Issue 1 new apprenticeship provider agreement (29658)";

        public int Order => 1;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10008899 // The Ashridge (Bonar Law Memorial) Trust
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}
