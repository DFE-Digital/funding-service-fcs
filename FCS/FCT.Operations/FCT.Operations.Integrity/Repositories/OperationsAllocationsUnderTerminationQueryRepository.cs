namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System;
    using System.Collections.Concurrent;
    using System.Data;
    using CrossDomain.Integration.Entities.Data;
    using Dapper;
    using global::AllocationDeliveryDomain.Endpoint.Repositories;

    public class OperationsAllocationsUnderTerminationQueryRepository : IAllocationsUnderTerminationQueryRepository
    {
        private readonly IDbConnection _connection;

        private readonly ConcurrentDictionary<string, DateTime?> _terminationDateForAllocationNumber = new ConcurrentDictionary<string, DateTime?>();

        public OperationsAllocationsUnderTerminationQueryRepository(IDbConnection connection)
        {
            _connection = connection;
        }

        public DateTime? GetTerminationDate(string allocationNumber, ConnectionInfo connectionInfo)
        {
            return _terminationDateForAllocationNumber.GetOrAdd(allocationNumber, _ => GetEntityFromDatabase(allocationNumber));
        }

        private DateTime? GetEntityFromDatabase(string allocationNumber)
        {
            return _connection.QuerySingleOrDefault<DateTime?>("sp_Operation_GetEntityFromDatabase @allocationNumber", param: new { allocationNumber });
        }
    }
}
