namespace Datafix.Tests.Automation.Releases.R75d
{
    using System.Collections.Generic;
    public class DasEventsDec2019SecondLot : IApplyDataFix
    {
        public string Release => "R75D";

        public int StoryNumber => 28618;

        public string Name => "Insert Das Events as is they came from the Feed - December 2019 Second Lot";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var dasProviderList = new List<int>
            {
                10028207,
                10061599,
                10081561,
                10052903,
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}
