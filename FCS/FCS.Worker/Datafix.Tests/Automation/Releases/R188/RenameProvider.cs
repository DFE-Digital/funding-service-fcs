using Datafix.Tests.Repositories;
using schemas.sfa.gov.uk.cpds.gatewayservice;
using System;
using System.Collections.Generic;
using System.Configuration.Provider;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Datafix.Tests.Automation.Releases.R188
{
    public class RenameProvider : IApplyDataFix
    {
        public string Release => "R188c";

        public int StoryNumber => 51203;

        public string Name => "Rename Provider name for 1007469";
        private const string ProviderName = "Coastland College";
        private const int Ukprn = 10007469;

        public int Order => 1;
        public void ApplyDataFix()
        {
            CrmAccountRepository.UpdateName(Ukprn, ProviderName);

            OrganisationRepository.UpdateOrgName(Ukprn, ProviderName);

        }
    }
}
