namespace SFA.FCT.PaymentManagementDomain.BusinessLogic
{
    using System;
    using System.Data.Entity;

    public static class UpSertHelper
    {
        public static void AddOrUpdatePaymentScheduleEntity<TEntity>(TEntity entity, Func<TEntity> getExisting, IDbSet<TEntity> dbSet, Action<TEntity, TEntity> updateDb ) where TEntity : class
        {
            TEntity entityInDb = getExisting();

            if (entityInDb == null)
            {
                dbSet.Add(entity);
            }
            else
            {
                updateDb(entityInDb, entity);
            }
        }
    }
}
