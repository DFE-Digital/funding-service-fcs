namespace SFA.FCT.Operations.DataStore.Repositories
{
    using System.Data.Entity;

    public abstract class OperationsRepositoryBase<TEntity> where TEntity : class
    {
        private readonly IDbSet<TEntity> _dbSet;

        protected OperationsRepositoryBase(IDbSet<TEntity> dbSet)
        {
            _dbSet = dbSet;
        }

        public void AddEntity(TEntity entity)
        {
            _dbSet.Add(entity);
        }
    }
}
