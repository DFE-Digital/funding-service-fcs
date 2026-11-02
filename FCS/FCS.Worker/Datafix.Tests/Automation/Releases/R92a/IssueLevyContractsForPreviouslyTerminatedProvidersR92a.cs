namespace Datafix.Tests.Automation.Releases.R92a
{
    using System.Collections.Generic;

    public class IssueLevyContractsForPreviouslyUnderTerminationProvidersR92A : IApplyDataFix
    {
        public string Release => "R92a";

        public int StoryNumber => 30736;

        public string Name => "Issue 4 new apprenticeship provider agreements";

        public int Order => 1;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10038368, // TRAIN 4 LIMITED
                10047761, // EM SKILLS LIMITED
                10026921, // CHRIST THE REDEEMER COLLEGE
                10011147, // GUY'S AND ST THOMAS' NHS FOUNDATION TRUST
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}