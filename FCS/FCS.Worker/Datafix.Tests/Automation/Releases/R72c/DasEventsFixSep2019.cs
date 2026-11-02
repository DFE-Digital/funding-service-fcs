namespace Datafix.Tests
{
    using System.Collections.Generic;
    using Automation.Releases;
    using Automation;

    public class DasEventsFixSep2019 //: IApplyDataFix
    {
        public string Release => "R72C";
        public int StoryNumber => 27823;
        public string Name => "Insert Das Events as is they came from the Feed - September 2019";
        public int Order => 1;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10083146,
                10082756,
                10081319,
                10068197,
                10065422,
                10065332,
                10065020,
                10064386,
                10063395,
                10063276,
                10062447,
                10062157,
                10054679,
                10047048,
                10044666,
                10043779,
                10039308,
                10034301,
                10026744,
                10025109,
                10023866,
                10006580,
                10004497,
                10004063
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}