namespace ContractRequestDomain.Cfs.Release.Services
{
    using System;
    using System.Threading.Tasks;
    using Dto;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAllocationReleaseService
    {
        Task ReleaseAllocations(string fundingType, string fundingPeriod, Func<ContractCfsAllocation, Task> contractGenerated, ConnectionInfo connectionInfo);
    }
}