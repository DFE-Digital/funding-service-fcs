using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OrganisationDomain.Implementation.BusinessLogic
{
    public class PimsApiClient : IPimsApiClient
    {
        public Task<string> GetProvidersByUkprnAsync(int ukprn)
        {
            return Task.FromResult(
                File.ReadAllText("..\\ProviderByUkprn.json"));
        }

        public Task<string> GetProviderSummaryAsync()
        {
            throw new NotImplementedException();
        }
    }
}
