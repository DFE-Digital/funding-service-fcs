namespace SFA.FCT.CrossDomain.Integration.Entities.Data
{
    using System;

    public interface IEntityCache<TKey, TEntity>
    {
        TEntity GetOrAdd(TKey key, Func<TKey, TEntity> valueFactory);
    }
}
