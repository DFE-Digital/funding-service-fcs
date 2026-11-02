namespace Datafix.Tests.Automation.Releases._74
{
    using System.Collections.Generic;

    public class DasEventsFixNov6th2019 : IApplyDataFix
    {
        public string Release => "R74";
        public int StoryNumber => 28127;
        public string Name => "Insert Das Events as is they came from the Feed - November 6th 2019";
        public int Order => 1;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10052570, // BONA FIDE SITE SERVICES LIMITED
                10049342, // YETI PARTNERSHIP LIMITED
                10035614  // CENTRAL CONSTRUCTION TRAINING LIMITED
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}