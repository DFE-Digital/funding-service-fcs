namespace Datafix.Tests.Automation.Releases.R93c
{
    using System.Collections.Generic;

    public class IssueLevyContractsForPreviouslyUnderTerminationProvidersR93c : IApplyDataFix
    {
        public string Release => "R93c";

        public int StoryNumber => 30959;

        public string Name => "Issue 5 new apprenticeship provider agreements (30959)";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var dasProviderList = new List<int>
            {
                10028919,   //  EXCEED TRAINING COMPANY LIMITED
                10031131,   //  ALTHAUS DIGITAL LIMITED
                10046146,   //  ACADEMY TRAINING HAIR AND BEAUTY LIMITED
                10041086,   //  DMR TRAINING & CONSULTANCY LIMITED
                10021068    //  FIRST AVENUE TRAINING LIMITED
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}