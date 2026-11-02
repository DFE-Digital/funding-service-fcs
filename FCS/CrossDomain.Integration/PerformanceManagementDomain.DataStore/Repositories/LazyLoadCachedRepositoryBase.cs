namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using System.Collections.Concurrent;
    using System.Data.Entity;

    public abstract class LazyLoadCachedRepositoryBase<TEntity> where TEntity : class
    {
        private readonly IDbSet<TEntity> _dbSet;
        private readonly ConcurrentDictionary<object[], TEntity> _cachedData = new ConcurrentDictionary<object[], TEntity>(); 

        protected LazyLoadCachedRepositoryBase(IDbSet<TEntity> dbSet)
        {
            _dbSet = dbSet;
        }

        protected TEntity FindByKey(params object[] primaryKey)
        {
            return _cachedData.GetOrAdd(primaryKey, pk => _dbSet.Find(pk));
        }
    }
}
