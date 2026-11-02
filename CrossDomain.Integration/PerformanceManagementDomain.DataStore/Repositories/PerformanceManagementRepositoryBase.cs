namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using System.Data.Entity;
    using System.Linq;
    using System.Data.Entity.Migrations;

    public abstract class PerformanceManagementRepositoryBase<TEntity> where TEntity : class
    {
        private readonly IDbSet<TEntity> _dbSet;

        protected PerformanceManagementRepositoryBase(IDbSet<TEntity> dbSet)
        {
            _dbSet = dbSet;
        }

        public TEntity FindByKey(object[] primaryKey)
        {
            return _dbSet.Find(primaryKey);
        }

        public void DeleteEntity(TEntity entity)
        {
            _dbSet.Remove(entity);
        }

        public void AddEntity(TEntity entity)
        {
            _dbSet.Add(entity);
        }

        public void AddOrUpdateEntity(TEntity entity)
        {
            _dbSet.AddOrUpdate(entity);
        }

        public IQueryable<TEntity> RetrieveAll()
        {
            return _dbSet.AsQueryable();
        }
    }
}
