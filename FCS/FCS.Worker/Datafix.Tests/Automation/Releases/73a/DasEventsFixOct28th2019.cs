namespace Datafix.Tests.Automation.Releases._73a
{
    using System.Collections.Generic;

    public class DasEventsFixOct28th2019 : IApplyDataFix
    {
        public string Release => "R73A";
        public int StoryNumber => 28121;
        public string Name => "Insert Das Events as is they came from the Feed - October 28th 2019";
        public int Order => 2;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10057068,
                10082520,
                10063515,
                10043784,
                10032350,
                10083757,
                10062680,
                10040792,
                10054505,
                10082896,
                10062202,
                10007091,
                10037401,
                10064877,
                10083920,
                10067082,
                10067355,
                10083314
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}