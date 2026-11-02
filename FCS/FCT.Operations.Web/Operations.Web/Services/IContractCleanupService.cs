using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace Operations.Web.Services
{
    public interface IContractCleanupService
    {
        Task<string> CleanContractData(List<string> fundingIds);
    }
}