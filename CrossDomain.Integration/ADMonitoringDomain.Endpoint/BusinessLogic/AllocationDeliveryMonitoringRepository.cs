namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    using System.Data.SqlClient;
    using SFA.FCT.CrossDomain.Integration.Common.Extensions;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using System;
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class AllocationDeliveryMonitoringRepository : IAllocationDeliveryMonitoringRepository
    {
        private const int PRIMARY_KEY_DUPLICATE_SQL_EXCEPTION_NUMBER = 2627;

        public IDate DateService { get; private set; }

        public AllocationDeliveryMonitoringRepository(IDate dateService)
        {
            DateService = dateService;
        }

        public PaymentMethod GetPaymentMethod(string fspCode, ConnectionInfo connectionInfo)
        {
            using (var context = new PaymentManagementPolicyContext(connectionInfo))
            {
                return context.PolicyFundingStreamPeriods.Single(f => f.FundingStreamPeriod == fspCode).PaymentMethod;
            }
        }

        public int StoreEvent(AllocationDeliveryPerformance adPerformanceEvent, AllocationDeliveryEntryCategory category, ConnectionInfo connectionInfo)
        {
            using (var context = new AllocationDeliveryDbContext(connectionInfo))
            {
                var allocDeliveryEntry = AllocationDeliveryEntry.Create(adPerformanceEvent, category);

                context.AllocationDeliveryEntries.Add(allocDeliveryEntry);
                context.SaveChanges();

                return allocDeliveryEntry.ID;
            }
        }

        public void StoreMessagePayload(AllocationDeliveryEventReceived eventToStore, ConnectionInfo connectionInfo, Type typeOfEvent)
        {
            using (var context = new AllocationDeliveryMonitoringDbContext(connectionInfo))
            {
                try
                {
                    context.AllocationDeliveryEventsReceived.Add(eventToStore);
                    context.SaveChanges();
                }
                catch (Exception ex)
                {
                    var hasPrimaryKeySqlException = ex.GetAllExceptions()
                        .Where(x => x is SqlException)
                        .Select(y => y as SqlException)
                        .Any(z => z.Number == PRIMARY_KEY_DUPLICATE_SQL_EXCEPTION_NUMBER);

                    if (hasPrimaryKeySqlException)
                    {
                        context.SetModified(eventToStore, typeOfEvent);
                        return;
                    }
                    throw;
                }
            }
        }
        

        public void ClearEvents(string categoryName, string allocationNumber, int versionNumber, ConnectionInfo connectionInfo)
        {
            using (var context = new AllocationDeliveryMonitoringDbContext(connectionInfo))
            {
                var eventsToClear = context.AllocationDeliveryEventsReceived.Where(e => e.CategoryName == categoryName && e.AllocationNumber == allocationNumber && e.VersionNumber == versionNumber);

                foreach (var e in eventsToClear)
                {
                    context.AllocationDeliveryEventsReceived.Remove(e);
                }

                context.SaveChanges();
            }
        }

        public AllocationDeliveryEventReceived GetAllocationDeliveryEventReceivedEntity(string allocationNumber, int versionNumber, string categoryName, string eventName,
            ConnectionInfo connectionInfo)
        {
            using (var context = new AllocationDeliveryMonitoringDbContext(connectionInfo))
            {
                return context.AllocationDeliveryEventsReceived.FirstOrDefault(x =>
                    x.AllocationNumber == allocationNumber &&
                    x.VersionNumber == versionNumber &&
                    x.CategoryName == categoryName &&
                    x.EventName == eventName);
            }
        }
    }
}