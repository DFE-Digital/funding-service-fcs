namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;
    using System.Reflection;
    using MoreLinq;

    public class EntityMerger<TEntity>
    {
        private static IDictionary<Type, IEnumerable<PropertyInfo>> _propertyInfosForType = new Dictionary<Type, IEnumerable<PropertyInfo>>(); 
       
        public static void MergeNonKeyAndNonIndexProperties(TEntity source, TEntity destination, string indexName)
        {
            if (string.IsNullOrEmpty(indexName))
            {
                throw new ArgumentException("The indexName cannnot be null or empty");
            }

            GetNonKeyAndNonIndexProperties(indexName).ForEach(pi => MergeProperty(pi, source, destination));
        }

        private static void MergeProperty(PropertyInfo pi, TEntity source, TEntity destination)
        {
            pi.SetValue(destination, pi.GetValue(source));
        }

        private static IEnumerable<PropertyInfo> GetNonKeyAndNonIndexProperties(string indexName)
        {
            Type entityType = typeof (TEntity);
            if (!_propertyInfosForType.ContainsKey(entityType))
            {
                _propertyInfosForType.Add(entityType, typeof(TEntity).GetProperties().Where(
                prop => !Attribute.IsDefined(prop, typeof(KeyAttribute)) && !HasPropertyAnIndexAttributeWithThisName(prop, indexName)));
            }

            return _propertyInfosForType[entityType];
        }

        private static bool HasPropertyAnIndexAttributeWithThisName(PropertyInfo propertyInfo, string indexName)
        {
            bool hasRelevantIndex = false;
            if (Attribute.IsDefined(propertyInfo, typeof (IndexAttribute)))
            {
                IEnumerable<CustomAttributeData> indexAttributes = propertyInfo.CustomAttributes.Where(ca => ca.AttributeType == typeof (IndexAttribute));

                hasRelevantIndex = indexAttributes.Any(ia => ia.ConstructorArguments.Any(ca => ca.Value.Equals(indexName)));
            }

            return hasRelevantIndex;
        }
    }
}
