using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OrganisationDomain.Implementation.BusinessLogic
{
    public class PimsApiClient : IPimsApiClient
    {
        public Task<string> GetProvidersByUkprnAsync(int ukprn)
        {
            throw new NotImplementedException();
        }

        public Task<string> GetProviderSummaryAsync()
        {
            throw new NotImplementedException();
        }
    }
}
