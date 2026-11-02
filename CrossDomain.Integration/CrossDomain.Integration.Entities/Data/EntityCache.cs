namespace SFA.FCT.CrossDomain.Integration.Entities.Data
{
    using System.Collections.Concurrent;

    public class EntityCache<TKey, TEntity> : ConcurrentDictionary<TKey, TEntity>, IEntityCache<TKey, TEntity>
    {
    }
}