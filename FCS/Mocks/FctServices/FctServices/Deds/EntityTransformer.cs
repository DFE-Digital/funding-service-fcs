namespace FctServices.Deds
{
    using global::DedsSearchService;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    /// <summary>
    /// Transforms Reported Actuals to QueryResult
    /// </summary>
    public class EntityTransformer<T>
    {
        private static string[] _fieldNames;
        private static PropertyInfo[] _propertyInfos;
        public static QueryResults[] TransformToQueryResults(IEnumerable<T> entities, string dateTimeFormat = null)
        {
            QueryResults results = new QueryResults
            {
                FieldNames = GetFieldNamesList(),
                Results = GetRowValuesForEachRow(entities, dateTimeFormat)
            };

            QueryResults[] resultsArray = new QueryResults[1];
            resultsArray[0] = results;
            return resultsArray;
        }

        private static string[][] GetRowValuesForEachRow(IEnumerable<T> entities, string dateTimeFormat)
        {
            return entities.Select(r => GetValuesArray(r, dateTimeFormat)).ToArray();
        }

        private static string[] GetValuesArray(T reportedActual, string dateTimeFormat)
        {
            string[] fieldNames = GetFieldNamesList();
            string[] values = new string[fieldNames.Length];
            int index = 0;
            foreach (var fieldName in fieldNames)
            {
                values[index++] = GetObjectValue(reportedActual, fieldName, dateTimeFormat);
            }

            return values;
        }

        private static string GetObjectValue(T obj, string fieldName, string dateTimeFormat)
        {
            string value = null;
            object propertyValue = GetProperties().Single(pi => pi.Name == fieldName).GetValue(obj);
            if (propertyValue != null)
            {
                if (propertyValue is DateTime && !string.IsNullOrWhiteSpace(dateTimeFormat))
                    value = ((DateTime)propertyValue).ToString(dateTimeFormat);
                else
                    value = propertyValue.ToString();
            }

            return value;
        }

        private static string[] GetFieldNamesList()
        {
            if (_fieldNames == null)
            {
                _fieldNames = GetProperties().Select(m => m.Name).ToArray();
            }

            return _fieldNames;
        }

        private static PropertyInfo[] GetProperties()
        {
            if (_propertyInfos == null)
            {
                _propertyInfos = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly);
            }

            return _propertyInfos;
        }
    }
}