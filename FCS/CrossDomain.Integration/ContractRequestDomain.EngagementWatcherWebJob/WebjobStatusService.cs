using SFA.FCT.ContractRequestDomain.DataStore.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ContractRequestDomain.EngagementWatcherWebJob
{
    public class WebjobStatusService
    {
        private readonly IWebjobStatusRepository _webjobStatusRepository;
        public WebjobStatusService()
        {
            _webjobStatusRepository = new WebjobStatusRepository(); 
        }

        public bool CheckjobStatus(string jobName)
        { 
            var status = _webjobStatusRepository.GetJobStatus(jobName);
            return status;
        }
    }
}
