namespace SFA.FCT.CrossDomain.Integration.Common
{
    using System;
    using System.Linq;
    using System.Transactions;
    using OverrideDate.DataStore;

    public class StaticDate : IDate
    {
        private readonly IOverrideDateDBContext _overrideDateDbContext;

        public StaticDate(IOverrideDateDBContext overrideDateDbContext)
        {
            _overrideDateDbContext = overrideDateDbContext;
        }

        DateTime IDate.GetCalculationDate()
        {
            using (var tran = new TransactionScope(TransactionScopeOption.Suppress))
            {
                if (_overrideDateDbContext.OverrideDate.Any())
                {
                    return DateTime.SpecifyKind(_overrideDateDbContext.OverrideDate.FirstOrDefault().SystemOverrideDate, DateTimeKind.Utc);
                }
                
                return DateTime.UtcNow;
            }
        }
    }
}