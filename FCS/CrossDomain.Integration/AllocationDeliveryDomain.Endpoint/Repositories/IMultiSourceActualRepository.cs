namespace AllocationDeliveryDomain.Endpoint.Repositories
{
    using System.Collections.Generic;
    using AllocationDelivery.Messages.DTOs;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IMultiSourceActualRepository
    {
        IReadOnlyCollection<ReportedActual> GetReportedActuals(string[] tableStoragePartitionKeys, SummarisedActualOrgFspGroupKey[] sqlOrgFspGroupKeys, ConnectionInfo connectionInfo);
    }
}
