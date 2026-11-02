namespace Datafix.Tests.Automation.Releases.R94c
{
    using System.Collections.Generic;

    public class IssueLevyContractsForPreviouslyUnderTerminationProvidersR94c   : IApplyDataFix
    {
        public string Release => "R94c";

        public int StoryNumber => 31180;

        public string Name => "Issue 1 new apprenticeship provider agreement (31180)";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var dasProviderList = new List<int>
            {
                10010513 // Trade Skills4U (APPLEVY-2257)
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}