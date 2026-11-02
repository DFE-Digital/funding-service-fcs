namespace Datafix.Tests.Automation.Releases.R82
{
    using System.Collections.Generic;

    public class IssueLevyContractsFor9PreviouslyTerminatedProviders : IApplyDataFix
    {
        public string Release => "R82";

        public int StoryNumber => 29608;

        public string Name => "Issue 9 new apprenticeship provider agreements (29608)";

        public int Order => 2;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10044705, // ASTRO MARTIN LTD
                10055832, // DENTAL SUPPORT SERVICES LIMITED
                10048326, // IC TRAINING CENTRE LIMITED
                10032448, // EAT THAT FROG C.I.C.
                10036240, // RICHMOND TRAINING ACADEMY LIMITED
                10042014, // KINGSWOOD LEARNING AND LEISURE GROUP LIMITED
                10061144, // RANDSTAD SOLUTIONS LIMITED
                10037449, // UNIVERSITY OF ST MARK & ST JOHN
                10056737  // CONTRACTING SERVICES (EDUCATION AND SKILLS) LIMITED
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}
