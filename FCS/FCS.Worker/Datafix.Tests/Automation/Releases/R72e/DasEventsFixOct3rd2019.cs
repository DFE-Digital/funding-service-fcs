namespace Datafix.Tests.Automation.Releases.R72e
{
    using System.Collections.Generic;
    public class DasEventsFixOct3rd2019 : IApplyDataFix
    {
        public string Release => "R72E";
        public int StoryNumber => 27893;
        public string Name => "Insert Das Events as is they came from the Feed - October 3rd 2019";
        public int Order => 1;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10007349,
                10008015,
                10083232,
                10055748,
                10002457,
                10048446,
                10063978,
                10011094,
                10063615,
                10001298,
                10082111,
                10035601,
                10052799,
                10049084,
                10028200,
                10031111,
                10023081,
                10002634,
                10028410,
                10037669,
                10012965,
                10045754,
                10037119,
                10002756,
                10064883,
                10047260,
                10064537,
                10062910,
                10027505,
                10046227,
                10052832,
                10038528,
                10021233,
                10067871,
                10044252,
                10065784,
                10083042,
                10083691,
                10083696,
                10003003,
                10031460,
                10024217,
                10064088,
                10064141,
                10065400,
                10049117,
                10083265,
                10001769
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }


    }
}
