
namespace Operations.Web.Services
{
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using System.Threading.Tasks;

    public interface IDasRequestService
    {
        Task<DasRequest> SetupDasRequest(string ukprn, int eventId);
    }
}