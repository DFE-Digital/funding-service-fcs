namespace Datafix.Tests.Automation.Releases.R79b
{
    using System.Collections.Generic;

    public class NewDasEventsFor5Providers : IApplyDataFix
    {
        public string Release => "R79b";

        public int StoryNumber => 29190;

        public string Name => "Create and publish Levy agreements for 5 new entries on RoATP (29190)";

        public int Order => 1;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10010549, // C & G ASSESSMENTS AND TRAINING LIMITED.
                10009998, // ELITE TRAINING EUROPEAN LIMITED
                10084420, // FORUM FOR SUSTAINABLE NEW VENTURE
                10035178, // PLYMOUTH ARGYLE FOOTBALL IN THE COMMUNITY TRUST
                10024591 // THE INDEPENDENT WINDSCREEN ACADEMY LTD
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}
