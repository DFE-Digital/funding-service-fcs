namespace SFA.FCT.Operations.Maintenance.Endpoint.Repositories
{
    using System.Threading.Tasks;
    using System.Collections.Generic;

    public interface ISchemaQueryRepository
    {
        Task<IReadOnlyCollection<string>> GetSchemaNamesWithProcessedMessageTable();
    }
}