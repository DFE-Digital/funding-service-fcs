namespace Datafix.Tests.Automation.Releases.R89
{
    using System.Collections.Generic;

    public class IssueLevyContractsForPreviouslyTerminatedProvidersR89 : IApplyDataFix
    {
        public string Release => "R89";

        public int StoryNumber => 30406;

        public string Name => "Issue 2 new apprenticeship provider agreements (30406)";

        public int Order => 1;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10007805, //  UNIVERSITY OF STRATHCLYDE      APPLEVY-2887
                10028716, //  FBP VENTURES LTD               APPLEVY-1536
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}