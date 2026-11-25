using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OrganisationDomain.Implementation.BusinessLogic
{
    public interface IPimsApiClient
    {
        Task<string> GetProvidersByUkprnAsync(int ukprn);

        Task<string> GetProviderSummaryAsync();
    }
}
