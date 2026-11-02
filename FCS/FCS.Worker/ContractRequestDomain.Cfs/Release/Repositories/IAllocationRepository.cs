namespace ContractRequestDomain.Cfs.Release.Repositories
{
    using System.Collections.Generic;
    using Common.Dtos;

    public interface IAllocationRepository
    {
        IReadOnlyCollection<Allocation> GetAllocationsForRelease(string fundingType, string fundingPeriod);
    }
}