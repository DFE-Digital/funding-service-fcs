namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Extensions;

    public static class MonthEndHistoryRepository
    {
        public static void StartMonthEnd()
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.MonthEndHistories.Add(new MonthEndHistory());
                context.SaveChanges();
            }
        }

        public static void StopMonthEnd()
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext())
            {
                context.MonthEndHistories.RemoveWhere(meh => meh.EndTime == null);
                context.SaveChanges();
            }
        }
    }
}
