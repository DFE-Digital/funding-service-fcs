namespace Datafix.Tests.Automation.Releases.R94d
{
    using System.Collections.Generic;
    
    public class IssueLevyContractsForPreviouslyUnderTerminationProvidersR94d : IApplyDataFix
    {
        public string Release => "R94d";

        public int StoryNumber => 31204;

        public string Name => "Issue 4 new apprenticeship provider agreements (31204)";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var dasProviderList = new List<int>
            {
                10008119,  //   BRIDGEND COLLEGE OF TECHNOLOGY            APPLEVY-2531
                10041108,  //   FIRST STEP EDUCATION & TRAINING LIMITED   APPLEVY-1561
                10044985,  //   GATEWAY EDUCATION (LONDON) LIMITED        APPLEVY-1577
                10040170   //   NEXT LEVEL IMPACT                         APPLEVY-1881
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}