namespace ContractRequestDomain.Cfs.Xrm.Repositories
{
    using ContractRequestDomain.Cfs.Common.Dtos;

    public interface IAllocationRepository
    {
        void CreateAllocationAndPeriods(Allocation allocation);
    }
}