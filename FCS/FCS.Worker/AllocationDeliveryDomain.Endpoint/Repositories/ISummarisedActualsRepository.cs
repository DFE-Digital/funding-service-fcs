namespace AllocationDeliveryDomain.Endpoint.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ISummarisedActualsRepository
    {
        Task AddActual(SummarisedActual actual, ConnectionInfo connectionInfo);

        Task AddActuals(IReadOnlyCollection<SummarisedActual> actuals, ConnectionInfo connectionInfo);
    }
}