namespace AllocationDeliveryDomain.DedsClient
{
    using System;
    using System.Collections.Generic;
    using System.Reflection;
    using DedsSearchService;
    using Dtos;

    /// <summary>
    /// Transforms QueryResult to Reported Actuals 
    /// </summary>
    public class QueryResultTransformer
    {
        public static IEnumerable<ReportedActual> TransformToReportedActuals(IList<QueryResults> queryResults)
        {
            IList<ReportedActual> reportedActuals = new List<ReportedActual>();

            foreach (var result in queryResults[0].Results)
            {
                var fieldscount = queryResults[0].FieldNames.Length;
                ReportedActual reportedActual = new ReportedActual();
                for (var i = 0; i < fieldscount; i++)
                {
                    SetObjectValue(reportedActual, queryResults[0].FieldNames[i], result[i]);
                }

                reportedActuals.Add(reportedActual);
            }

            return reportedActuals;
        }

        private static void SetObjectValue<T>(T obj, string fieldName, string value)
        {
            Type myType = obj.GetType();
            PropertyInfo propertyInfo = myType.GetProperty(fieldName);
            if (propertyInfo.PropertyType == typeof(string))
            {
                propertyInfo.SetValue(obj, value, null);
            }
            else if (propertyInfo.PropertyType == typeof(long))
            {
                propertyInfo.SetValue(obj, Convert.ToInt32(value, 16), null);
            }
            else if (propertyInfo.PropertyType == typeof(decimal))
            {
                propertyInfo.SetValue(obj, Convert.ToDecimal(value), null);
            }
        }
    }
}
