namespace Datafix.Tests.Automation.Releases.R85b
{
    using System.Collections.Generic;

    public class IssueLevyContractsForPreviouslyTerminatedProvidersR85b : IApplyDataFix
    {
        public string Release => "R85b";

        public int StoryNumber => 30106;

        public string Name => "Issue 5 new apprenticeship provider agreements (30106)";

        public int Order => 1;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10061438, // CADENT GAS LIMITED                   APPLEVY-1081
                10036788, // STARS RECRUITMENT LIMITED            APPLEVY-1160
                10026128, // WHITE ROSE TRAINING LIMITED          APPLEVY-2849
                10001947, // DEVELOPMENT PROCESSES GROUP LIMITED  APPLEVY-2892
                10001733, // CP TRAINING SERVICES LIMITED         APPLEVY-2963
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}