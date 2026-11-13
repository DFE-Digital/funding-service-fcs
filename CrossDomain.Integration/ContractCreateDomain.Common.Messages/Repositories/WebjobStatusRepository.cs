using System.Linq;

namespace SFA.FCT.ContractRequestDomain.DataStore.Repositories
{
    public class WebjobStatusRepository : IWebjobStatusRepository
    {
        //private IContractRequestDbContext context;
        public bool GetJobStatus(string jobName)
        {
            var context = new ContractRequestDbContext();
            var jobStatus = context.WebjobStatuses.FirstOrDefault(w => w.Webjobname == jobName);
            return jobStatus.Enabled;
        }
    }
}
