namespace SFA.FCT.Operations.Maintenance.Endpoint.Repositories
{
    using System;
    using System.Threading.Tasks;

    public interface IAuditMessageDeleteRepository
    {
        Task HousekeepAuditMessageTable(DateTime removeOlderThanDate);
    }
}