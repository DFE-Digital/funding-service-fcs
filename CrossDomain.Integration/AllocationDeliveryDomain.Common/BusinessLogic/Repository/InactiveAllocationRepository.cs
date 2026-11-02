namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using System.Data.Entity.Migrations;
    using CrossDomain.Integration.Entities.Data;
    using DataStore;
    using DataStore.Model;

    public class InactiveAllocationRepository : IInactiveAllocationRepository
    {
        private readonly IMonitoringDeliverablesDbContext _context;

        public InactiveAllocationRepository(IMonitoringDeliverablesDbContext context)
        {
            _context = context;
        }

        public void AddOrUpdate(InactiveAllocation inactiveAllocation, ConnectionInfo connectionInfo)
        {
            if (connectionInfo.UseDefault())
            {
                AddOrUpdate(inactiveAllocation, _context);
            }
            else
            {
                using (var context = new MonitoringDeliverablesDbContext(connectionInfo.Connection, connectionInfo.Transaction))
                {
                    AddOrUpdate(inactiveAllocation, context);
                    context.SaveChanges();
                }
            }
        }

        public int SaveChanges()
        {
            return _context.SaveChanges();
        }

        private void AddOrUpdate(InactiveAllocation inactiveAllocation, IMonitoringDeliverablesDbContext context)
        {
            context.InactiveAllocations.AddOrUpdate(inactiveAllocation);
        }
    }
}