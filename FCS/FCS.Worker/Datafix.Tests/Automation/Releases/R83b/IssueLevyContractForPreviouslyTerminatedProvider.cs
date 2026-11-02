namespace Datafix.Tests.Automation.Releases.R83b
{
    using System.Collections.Generic;

    public class IssueLevyContractForPreviouslyTerminatedProvider : IApplyDataFix
    {
        public string Release => "R83b";

        public int StoryNumber => 29759;

        public string Name => "Issue 1 new apprenticeship provider agreement (29759)";

        public int Order => 1;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10047671 // TAGADVANCE LIMITED
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}
