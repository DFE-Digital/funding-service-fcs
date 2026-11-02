namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories
{
    using System;
    using System.Data.Entity;

    public class UpSertHelper<TEntity> where TEntity : class
    {
        private readonly Func<int> _saveChanges;
        private readonly Action<TEntity, TEntity> _updateExisting;

        public UpSertHelper(Func<int> saveChanges, Action<TEntity, TEntity> updateExisting)
        {
            _saveChanges = saveChanges;
            _updateExisting = updateExisting;
        }

        public void AddOrUpdateEntity(
            TEntity entityToAddOrUpdate,
            Func<TEntity> getExisting,
            IDbSet<TEntity> dbSet)
        {
            TEntity entityInDb = getExisting();

            if (entityInDb == null)
            {
                dbSet.Add(entityToAddOrUpdate);
            }
            else
            {
                _updateExisting(entityInDb, entityToAddOrUpdate);
            }

            _saveChanges();
        }
    }
}
