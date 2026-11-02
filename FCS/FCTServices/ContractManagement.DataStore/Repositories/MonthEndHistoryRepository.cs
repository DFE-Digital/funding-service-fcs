namespace ContractManagement.DataStore.Repositories
{
    using System;
    using System.Linq;
    using Model;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class MonthEndHistoryRepository : IMonthEndHistoryRepository
    {
        public void StartMonthEnd(ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo))
            {
                context.MonthEndHistories.Add(new MonthEndHistory());
                context.SaveChanges();
            }
        }

        public void StopMonthEnd(ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo))
            {
                context.MonthEndHistories
                    .Where(meh => meh.EndTime == null)
                    .ForEach(meh => meh.EndTime = DateTime.UtcNow);

                context.SaveChanges();
            }
        }

        public bool IsMonthEndInProgress(ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo))
            {
                return context.MonthEndHistories.Any(meh => meh.EndTime == null);
            }
        }

        public DateTime? GetCurrentMonthEndStartTime(ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo))
            {
                MonthEndHistory monthEndHistory = context.MonthEndHistories.FirstOrDefault(meh => meh.EndTime == null);

                return monthEndHistory?.StartTime;
            }
        }
    }
}