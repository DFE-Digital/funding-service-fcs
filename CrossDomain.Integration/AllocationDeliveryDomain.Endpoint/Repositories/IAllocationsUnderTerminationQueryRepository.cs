namespace AllocationDeliveryDomain.Endpoint.Repositories
{
    using System;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IAllocationsUnderTerminationQueryRepository
    {
        DateTime? GetTerminationDate(string allocationNumber, ConnectionInfo connectionInfo);
    }
}
