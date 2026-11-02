namespace Datafix.Tests.Automation.Releases.R93a
{
    using System.Collections.Generic;

    public class IssueLevyContractsForPreviouslyUnderTerminationProvidersR93a : IApplyDataFix
    {
        public string Release => "R93a";

        public int StoryNumber => 30794;

        public string Name => "Issue 1 new apprenticeship provider agreements (30794)";

        public int Order => 1;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10002424  // Provider 'FNTC Training and Consultancy Limited'   Original Contract 'APPLEVY-1557'
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}