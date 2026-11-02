namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    using System;
    using System.Linq;
    using ADMonitoringDomain.DataStore.Model;
    using ADMonitoringDomain.DataStore;
    using System.Data.SqlClient;

    using SFA.FCT.CrossDomain.Integration.Common.Extensions;
    public class ADMonitoringDeliveryEventStore : IADMonitoringDeliveryEventStore
    {
        private IAllocationDeliveryMonitoringDbContext _context;
        private const int PRIMARY_KEY_DUPLICATE_SQL_EXCEPTION_NUMBER = 2627;
        public ADMonitoringDeliveryEventStore(IAllocationDeliveryMonitoringDbContext context)
        {
            _context = context;
        }
        public void StoreEvent(AllocationDeliveryEventReceived eventToStore, Type typeOfEvent)
        {
            try
            {
                _context.AllocationDeliveryEventsReceived.Add(eventToStore);
                _context.SaveChanges();
            }
            catch (Exception ex)
            {
                var hasPrimaryKeySqlException = ex.GetAllExceptions()
                    .Where(x => x is SqlException)
                    .Select(y => y as SqlException)
                    .Any(z=>z.Number==PRIMARY_KEY_DUPLICATE_SQL_EXCEPTION_NUMBER);

                if (hasPrimaryKeySqlException)
                {
                    _context.SetModified(eventToStore, typeOfEvent);
                    return;
                }
                throw;
            }
        }

        private AllocationDeliveryEventReceived GetMatchingItem(AllocationDeliveryEventReceived eventToStore)
        {
            return
                _context.AllocationDeliveryEventsReceived.Single(
                    ader => ader.AllocationNumber == eventToStore.AllocationNumber &&
                            ader.VersionNumber == eventToStore.VersionNumber &&
                            ader.CategoryName == eventToStore.CategoryName &&
                            ader.EventName == eventToStore.EventName);
        }
    }
}
