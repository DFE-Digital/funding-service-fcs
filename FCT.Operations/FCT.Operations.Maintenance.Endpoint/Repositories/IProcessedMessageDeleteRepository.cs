namespace SFA.FCT.Operations.Maintenance.Endpoint.Repositories
{
    using System;
    using System.Threading.Tasks;

    public interface IProcessedMessageDeleteRepository
    {
        Task HousekeepProcessedMessageTable(string schemaName, DateTime houseKeepOlderThanDate);
    }
}