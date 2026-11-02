namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using System.Collections.Generic;
    using Dapper;
    using DataStore;
    using DataStore.Model;
    using MoreLinq;

    public class AllocationDeliverablePeriodActualAuditRepository
    {
        private readonly IMonitoringDeliverablesDbContext _dbContext;

        public AllocationDeliverablePeriodActualAuditRepository(IMonitoringDeliverablesDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void InsertAuditRows(IEnumerable<AllocationDeliverablePeriodActualAudit> actuals)
        {
            const int batchSize = 10;

            actuals.Batch(batchSize).ForEach(InsertBatch);
        }

        private void InsertBatch(IEnumerable<AllocationDeliverablePeriodActualAudit> actualsBatch)
        {
            _dbContext.Database.Connection.Execute(@"
insert Member(Username, IsActive)
values(@Username, @IsActive)", actualsBatch, transaction: _dbContext.Database.CurrentTransaction.UnderlyingTransaction);


        }
    }
}
