namespace Datafix.Tests.Automation.Releases.R84a
{
    using System.Collections.Generic;

    public class IssueLevyContractsFor7PreviouslyTerminatedProviders : IApplyDataFix
    {
        public string Release => "R84a";

        public int StoryNumber => 29809;

        public string Name => "Issue 7 new apprenticeship provider agreements (29809)";

        public int Order => 1;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10061316, // PROFESSIONAL FUTURES LIMITED
                10005127, // PLYMOUTH COLLEGE OF ART
                10059658, // HERTFORDSHIRE CATERING LIMITED
                10033608, // BEACON EDUCATION PARTNERSHIP LIMITED
                10063587, // CARE PRECIOUS LTD
                10048806, // SEMESTER: LEARNING AND DEVELOPMENT LIMITED
                10057288, // STAFFORDSHIRE COMMISSIONER FIRE AND RESCUE AUTHORITY
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}
