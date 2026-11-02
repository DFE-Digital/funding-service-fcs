namespace Datafix.Tests.Automation.Releases.R94f
{
    using System.Collections.Generic;

    public class IssueLevyContractsForPreviouslyUnderTerminationProvidersR94f : IApplyDataFix
    {
        public string Release => "R94f";

        public int StoryNumber => 31327;

        public string Name => "Issue 6 new apprenticeship provider agreements (31327)";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var dasProviderList = new List<int>
            {
                10043389,  //     Excellence-Solutions Limited
                10042437,  //     North West Skills Academy Limited
                10055915,  //     The Prime College Limited
                10064537,  //     Hospice in the World
                10043060,  //     Momentum Recruitment Limited
                10005936   //     Sodexo Limited
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}