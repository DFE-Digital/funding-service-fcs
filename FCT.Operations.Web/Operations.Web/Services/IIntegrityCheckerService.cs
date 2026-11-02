using System.Threading.Tasks;

namespace Operations.Web.Services
{
    public interface IIntegrityCheckerService
    {
        Task StartIntegrityChecker(string integrityCheckerName);

        Task StartPostMonthEndIntegrityChecks();
    }
}