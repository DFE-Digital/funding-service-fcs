using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FundingAllocation.Services
{
    public interface IContractValueAggregator
    {
        void Aggregate(ExtendedContractType masterContract);
    }
}
