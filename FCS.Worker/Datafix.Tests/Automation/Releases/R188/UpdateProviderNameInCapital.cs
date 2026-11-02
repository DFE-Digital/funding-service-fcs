using Datafix.Tests.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Datafix.Tests.Automation.Releases.R188
{
    public class UpdateProviderNameInCapital : IApplyDataFix
    {
        public string Release => "R188d";

        public int StoryNumber => 51203;

        public string Name => "Update Provider name to capital for 1007469";
        private const string ProviderName = "COASTLAND COLLEGE";
        private const int Ukprn = 10007469;

        public int Order => 1;
        public void ApplyDataFix()
        {
            CrmAccountRepository.UpdateName(Ukprn, ProviderName);

            OrganisationRepository.UpdateOrgName(Ukprn, ProviderName);

        }
    }
}
