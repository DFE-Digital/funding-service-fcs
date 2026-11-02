namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using AllocationDelivery.Messages.DTOs;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IMultiSourceActualRepository
    {
        Task<IReadOnlyCollection<ReportedActual>> GetReportedActuals(string tableStoragePartitionKey, SummarisedActualOrgFspGroupKey sqlOrgFspGroupKey, ConnectionInfo connectionInfo);
    }
}
