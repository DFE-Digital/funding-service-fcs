namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Data.Entity;
    using System.Linq;
    using DocumentsDomain.DataStore;
    using DocumentsDomain.DataStore.Models;
    using Extensions;

    public static class NlapFundingConfigRepository
    {
        public static void AddOrUpdate(NlapFundingConfig entity)
        {
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                bool isExistingEntity = context.NlapFundingConfigs.Any(n => n.Ukprn == entity.Ukprn);

                if (isExistingEntity)
                {
                    context.NlapFundingConfigs.Attach(entity);
                    context.Entry(entity).State = EntityState.Modified; 
                }
                else
                {
                    context.NlapFundingConfigs.Add(entity);
                }

                context.SaveChanges();
            }
        }

        public static void RemoveByUkprn(int ukprn)
        {
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                context.NlapFundingConfigs.RemoveWhere(n => n.Ukprn == ukprn);
                context.SaveChanges();
            }
        }
    }
}
