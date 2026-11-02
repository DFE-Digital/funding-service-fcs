namespace ContractRequestDomain.Cfs.Detail.Services
{
    using System.Threading.Tasks;
    using ContractRequestDomain.Cfs.Common.Dtos;

    public interface IAllocationDetailService
    {
        Task<Allocation> GetAllocationDetail(string allocationId, int version);
    }
}