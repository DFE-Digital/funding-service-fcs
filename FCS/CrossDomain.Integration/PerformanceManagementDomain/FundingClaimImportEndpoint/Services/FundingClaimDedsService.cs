namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint.Services
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml;
    using CrossDomain.Integration.Common.Extensions;
    using DedsSearchService;

    public class FundingClaimDedsService : IFundingClaimDedsService
    {
        private const string DataSetCode = "Funding_Claims";
        private readonly IDedsSearchProxyServiceChannelFactory _dedsSearchProxyServiceChannelFactory;

        private readonly ConcurrentDictionary<Guid, QueryDescriptor[]> _queryDescriptorCache =
            new ConcurrentDictionary<Guid, QueryDescriptor[]>();

        public FundingClaimDedsService(IDedsSearchProxyServiceChannelFactory dedsSearchProxyServiceChannelFactory)
        {
            _dedsSearchProxyServiceChannelFactory = dedsSearchProxyServiceChannelFactory;
        }

        public Guid GetLatestPublishedDataSetVersionId()
        {
            using (IDedsSearchServiceChannel channel = _dedsSearchProxyServiceChannelFactory.Create())
            {
                DataSetVersionDescriptor dataSetVersionDescriptor = channel.GetLatestPublishedDataSetVersion(DataSetCode);

                if (dataSetVersionDescriptor?.Id == null)
                {
                    throw new Exception(
                        "Call to DCFS GetLatestPublishedDataSetVersion returned null DataSetVersionDescriptor or Id");
                }

                return dataSetVersionDescriptor.Id.Value;
            }
        }

        public IEnumerable<string> GetFundingClaimCompletedCollections(Guid dataSetVersionId, DateTime dateTime)
        {
            QueryDescriptor queryDescriptor = GetQueryDescriptorForMethodCall(dataSetVersionId,
                "GetFundingClaimCompletedCollections");

            QueryExecution queryExecution = new QueryExecution
            {
                FilterValues = new []
                {
                    new FilterValue
                    {
                        FieldName = "Since",
                        FieldValue = dateTime.ToSqlServerCompatibleString()
                    }
                },
                SortValues = new SortValue[0]
            };

            QueryResults[] queryResults = ExecuteQuery(queryDescriptor, queryExecution);

            return QueryResultTransformer<CollectionDetails>.TransformQueryResults(queryResults)
                .Select(cd => cd.DataCollectionKey);
        }

        public int GetFundingClaimsThatAreCompletedCount(Guid dataSetVersionId, string dataCollectionKey)
        {
            QueryDescriptor queryDescriptor = GetQueryDescriptorForMethodCall(dataSetVersionId,
                "GetFundingClaimsThatAreCompletedCount");

            QueryExecution queryExecution = new QueryExecution
            {
                FilterValues = new []
                {
                    new FilterValue
                    {
                        FieldName = "dataCollectionKey",
                        FieldValue = dataCollectionKey
                    }
                },
                SortValues = new SortValue[0]
            };

            QueryResults[] queryResults = ExecuteQuery(queryDescriptor, queryExecution);

            return TransformToRowCount(queryResults);
        }

        public IEnumerable<string> GetFundingClaimsThatAreCompleted(Guid dataSetVersionId, string dataCollectionKey, int? pageSize, int? pageNumber)
        {
            QueryDescriptor queryDescriptor = GetQueryDescriptorForMethodCall(dataSetVersionId,
                "GetFundingClaimsThatAreCompleted");

            QueryExecution queryExecution = new QueryExecution
            {
                FilterValues = new []
                {
                    new FilterValue
                    {
                        FieldName = "dataCollectionKey",
                        FieldValue = dataCollectionKey
                    }
                },
                SortValues = new SortValue[0],
                PageSize = pageSize,
                PageNumber = pageNumber
            };

            QueryResults[] queryResults = ExecuteQuery(queryDescriptor, queryExecution);
            
            return queryResults[0].Results
                .Skip(1) // the first result contains header info which we don't want
                .Select(r => r[0])
                .ToList();
        }

        private QueryResults[] ExecuteQuery(QueryDescriptor queryDescriptor, QueryExecution queryExecution)
        {
            using (IDedsSearchServiceChannel channel = _dedsSearchProxyServiceChannelFactory.Create())
            {
                return channel.ExecuteQuery((Guid) queryDescriptor.Id, queryExecution);
            }
        }

        private QueryDescriptor GetQueryDescriptorForMethodCall(Guid dataSetVersionId, string methodName)
        {
            return GetDataSetVersionQueryDescriptors(dataSetVersionId).Single(qd => qd.Code == methodName);
        }

        private QueryDescriptor[] GetDataSetVersionQueryDescriptors(Guid dataSetVersionId)
        {
            return _queryDescriptorCache.GetOrAdd(dataSetVersionId, dsvId =>
            {
                using (IDedsSearchServiceChannel channel = _dedsSearchProxyServiceChannelFactory.Create())
                {
                    QueryDescriptor[] queryDescriptors = channel.DiscoverQueries(new DiscoverQueriesCriteria
                    {
                        DataSetVersionId = dsvId
                    });

                    return queryDescriptors;
                }
            });
        }

        private static int TransformToRowCount(IList<QueryResults> queryResults)
        {
            int rowCount = 0;

            QueryResults queryResult = queryResults.FirstOrDefault();
            if (queryResult != null)
            {
                string rowCountStr = queryResult.Results.First().First();
                XmlDocument xDoc = new XmlDocument();
                xDoc.LoadXml(rowCountStr);
                rowCount = int.Parse(xDoc.DocumentElement.InnerText); // result will be in format <Count>28</Count>
            }

            return rowCount;
        }
    }
}
