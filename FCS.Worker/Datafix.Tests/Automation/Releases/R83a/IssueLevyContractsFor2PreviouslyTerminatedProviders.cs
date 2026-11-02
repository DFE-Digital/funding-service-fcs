namespace Datafix.Tests.Automation.Releases.R83a
{
    using System.Collections.Generic;

    public class IssueLevyContractsFor2PreviouslyTerminatedProviders : IApplyDataFix
    {
        public string Release => "R83a";

        public int StoryNumber => 29680;

        public string Name => "Issue 2 new apprenticeship provider agreements (29680)";

        public int Order => 1;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10043617, // TECHNIQUE LEARNING SOLUTIONS LTD
                10054802  // RPC CONTAINERS LIMITED
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}
