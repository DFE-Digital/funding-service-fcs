namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Data.Entity;
    using System.Linq;
    using DocumentsDomain.DataStore;
    using DocumentsDomain.DataStore.Models;
    using Extensions;

    public static class ContractReferenceConfigRepository
    {
        public static void AddOrUpdate(ContractReferenceConfig entity)
        {
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                bool isExistingEntity = context.ContractReferenceConfigs.Any(c =>
                    c.Ukprn == entity.Ukprn && c.FundingStreamPeriodCode == entity.FundingStreamPeriodCode);

                if (isExistingEntity)
                {
                    context.ContractReferenceConfigs.Attach(entity);
                    context.Entry(entity).State = EntityState.Modified; 
                }
                else
                {
                    context.ContractReferenceConfigs.Add(entity);
                }

                context.SaveChanges();
            }
        }

        public static void RemoveByUkprn(int ukprn)
        {
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                context.ContractReferenceConfigs.RemoveWhere(n => n.Ukprn == ukprn);
                context.SaveChanges();
            }
        }
    }
}
