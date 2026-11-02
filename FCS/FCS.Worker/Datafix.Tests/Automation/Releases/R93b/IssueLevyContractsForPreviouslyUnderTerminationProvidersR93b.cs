namespace Datafix.Tests.Automation.Releases.R93b
{
    using System.Collections.Generic;

    public class IssueLevyContractsForPreviouslyUnderTerminationProvidersR93b : IApplyDataFix
    {
        public string Release => "R93b";

        public int StoryNumber => 30864;

        public string Name => "Issue 3 new apprenticeship provider agreements (30864)";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var dasProviderList = new List<int>
            {
                10053951,   // Achievement Training & Skills Ltd    
                10034050,   // Ultima Skills Ltd                    
                10025748    // Keyturn Training Ltd                 
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}