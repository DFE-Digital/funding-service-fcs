namespace SFA.FCT.Contracts.AcceptanceTests.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Linq.Expressions;

    public static class DbSetExtensions
    {
        public static void RemoveWhere<TEntity>(this IDbSet<TEntity> dbset, Expression<Func<TEntity, bool>> predicate) where TEntity : class
        {
            List<TEntity> entitiesToDelete = dbset.Where(predicate).ToList();
            entitiesToDelete.ForEach(e => dbset.Remove(e));
        }
    }
}   