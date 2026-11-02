namespace UnitTests.Common
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Linq.Expressions;

    public static class TestTidyUpHelper
    {
        public static void RemoveByKey<TEntity>(this IDbSet<TEntity> dbset, params object[] primaryKey) where TEntity : class
        {
            TEntity entityToDelete = dbset.Find(primaryKey);

            if (entityToDelete != null)
            {
                dbset.Remove(entityToDelete);
            }
        }

        public static void RemoveWhere<TEntity>(this IDbSet<TEntity> dbset, Expression<Func<TEntity, bool>> predicate) where TEntity : class
        {
            List<TEntity> entitiesToDelete = dbset.Where(predicate).ToList();

            entitiesToDelete.ForEach(e => dbset.Remove(e));
        }

        public static void RemoveAll<TEntity>(this IDbSet<TEntity> dbset) where TEntity : class
        {
            List<TEntity> entitiesToDelete = dbset.ToList();

            entitiesToDelete.ForEach(e => dbset.Remove(e));
        }
    }
}
