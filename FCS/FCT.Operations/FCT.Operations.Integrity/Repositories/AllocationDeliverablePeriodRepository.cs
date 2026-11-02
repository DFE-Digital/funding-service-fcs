namespace SFA.FCT.Operations.Integrity.Repositories
{
    using Dapper;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using System.Collections.Generic;
    using System.Data;
    using AllocationDeliveryDomain.Common.DataStore;
    using System.Data.Entity;
    using System.Linq;
    public class AllocationDeliverablePeriodRepository : IAllocationDeliverablePeriodRepository
    {
        private readonly IDbConnection _connection;

        public AllocationDeliverablePeriodRepository(IDbConnection connection)
        {
            _connection = connection;
        }

        public IReadOnlyCollection<AllocationDeliverablePeriod> GetActiveAllocationDeliverablePeriods(
            string organisationId,
            string fundingStreamPeriodCode,
            string uopCode)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {       
                var allocationDeliverablePeriods = _connection.Query<AllocationDeliverablePeriod>(
                        "sp_Operation_GetActiveAllocationDeliverablePeriods @organisationId,@fundingStreamPeriodCode,@UopCode",param: new { organisationId, fundingStreamPeriodCode, uopCode });


                return allocationDeliverablePeriods.ToList();
            }

        }
    }
}