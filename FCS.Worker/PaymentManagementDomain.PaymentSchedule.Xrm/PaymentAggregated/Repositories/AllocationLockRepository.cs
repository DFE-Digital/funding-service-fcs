namespace PaymentManagementDomain.PaymentSchedule.PaymentAggregated.Repositories
{
    extern alias IntegrationEntities;
    using System;
    using System.Linq;
    using Dapper;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class AllocationLockRepository : IAllocationLockRepository
    {
        public bool CanAquireLockOnAllocation(string allocationNumber, int version, ConnectionInfo connectionInfo)
        {
            const int timeToWaitForLockSeconds = 2;
            try
            {
                const string sql = @"SELECT AllocationNumber
                FROM [PaymentSchedule].[Allocation] WITH (ROWLOCK, XLOCK)
                where AllocationNumber = @allocationNumber and VersionNumber = @version";

                var query = connectionInfo.Connection.Query<string>(
                    sql, 
                    transaction:connectionInfo.Transaction,
                    commandTimeout: timeToWaitForLockSeconds,
                    param:new {allocationNumber, version});

                query.ToList();
                
                return true;
            }
            catch (Exception e)
                when (e.Message.Contains("Execution Timeout Expired"))
            {
                return false;
            }
        }
    }
}
