namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Services
{
    using System.Collections.Generic;   
    using CrossDomain.Integration.Common.Serializers;
    using DedsSearchService;

    public static class QueryResultTransformer<T> where T : class, new()
    {
       
        public static IEnumerable<T> TransformQueryResults(IList<QueryResults> queryResults)
        {
            IList<T> items = new List<T>();

            foreach (string[] resultArray in queryResults[0].Results)
            {   
                foreach (string collectionDetailsXml in resultArray)
                {
                    T item = collectionDetailsXml.DeserializeXml<T>();
                    items.Add(item);
                }
            }

            return items;
        }
    }
}
