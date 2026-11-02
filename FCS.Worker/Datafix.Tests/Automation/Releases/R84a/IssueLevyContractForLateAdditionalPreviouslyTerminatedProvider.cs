namespace Datafix.Tests.Automation.Releases.R84a
{
    using System.Collections.Generic;

    public class IssueLevyContractForLateAdditionalPreviouslyTerminatedProvider : IApplyDataFix
    {
        public string Release => "R84a";

        public int StoryNumber => 29809;

        public string Name => "Issue a late additional apprenticeship provider agreement under datafix story";

        public int Order => 2;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10057910  // EVOLVE ACADEMY LTD
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}
