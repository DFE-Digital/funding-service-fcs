using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Datafix.Tests.Automation.Releases.R162a
{
    public class NewDasEventsForProvider10058343 : IApplyDataFix
    {
        public string Release => "R162a";

        public int StoryNumber => 42974;

        public string Name => "Create and publish 1 Levy agreement";

        public int Order => 1;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10058343 // THE KEMNAL ACADEMIES TRUST
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}
