namespace ContractCreateDomain.Endpoint.Tests.Infrastructure.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Data.Entity;
    using System.Linq.Expressions;

    public static class DbSetExtensions
    {
        public static void RemoveAll<TEntity>(this IDbSet<TEntity> dbset) where TEntity : class
        {
            List<TEntity> entitiesToDelete = dbset.ToList();

            entitiesToDelete.ForEach(e => dbset.Remove(e));
        }

        public static void RemoveWhere<TEntity>(this IDbSet<TEntity> dbset, Expression<Func<TEntity, bool>> predicate) where TEntity : class
        {
            List<TEntity> entitiesToDelete = dbset.Where(predicate).ToList();

            entitiesToDelete.ForEach(e => dbset.Remove(e));
        }
    }
}
