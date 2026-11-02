namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.Linq;
    using System.Reflection;
    using MoreLinq;

    public static class EntityMerger<TEntity>
    {
        public static void MergeNonKeyProperties(TEntity source, TEntity destination)
        {
            GetNonKeyProperties().ForEach(pi => MergeProperty(pi, source, destination));
        }

        private static void MergeProperty(PropertyInfo pi, TEntity source, TEntity destination)
        {
            pi.SetValue(destination, pi.GetValue(source));
        }

        private static IEnumerable<PropertyInfo> GetNonKeyProperties()
        {
            return typeof(TEntity).GetProperties().Where(
                prop => !Attribute.IsDefined(prop, typeof(KeyAttribute)));
        }
    }
}
