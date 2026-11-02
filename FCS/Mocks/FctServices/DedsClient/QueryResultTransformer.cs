using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using DedsClient.DedsSearchService;
using DedsClient.Dtos;

namespace DedsClient
{
    /// <summary>
    /// Transforms QueryResult to Reported Actuals 
    /// </summary>
    public class QueryResultTransformer
    {
        public static IEnumerable<ReportedActual> TransformToReportedActuals( IList<QueryResults> queryResults)
        {
            IList<ReportedActual> reportedActuals = new List<ReportedActual>();

            foreach (var result in queryResults[0].Results)
            {
                var fieldscount = queryResults[0].FieldNames.Length;
                ReportedActual reportedActual= new ReportedActual();
                for (var i = 0; i < fieldscount; i++)
                {
                    Console.WriteLine(string.Format("{0}:{1}", queryResults[0].FieldNames[i], result[i]));
                    SetObjectValue(reportedActual, queryResults[0].FieldNames[i], result[i]);
                }
                
                reportedActuals.Add(reportedActual);
            }

            return reportedActuals;

        }

        private static void SetObjectValue<T>(T obj, string fieldName, string value)
        {
            // Get the type and PropertyInfo.
            Type myType = obj.GetType();
            PropertyInfo propertyInfo = myType.GetProperty(fieldName);
            if (propertyInfo != null)
            {
                if (propertyInfo.PropertyType == typeof(string))
                {
                    propertyInfo.SetValue(obj, value, null);
                }
                else if (propertyInfo.PropertyType == typeof(long))
                {
                    propertyInfo.SetValue(obj, Int32.Parse(value), null);
                }
                else if (propertyInfo.PropertyType == typeof(decimal))
                {
                    propertyInfo.SetValue(obj, System.Convert.ToDecimal(value), null);
                }
            }
        }
    }
}
