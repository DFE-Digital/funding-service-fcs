namespace Operations.Web.Checkers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DedsSearchService;
    using Dtos;

    public class DedsCheckAvailability : ICheckAvailability
    {
        private readonly IDedsSearchServiceChannel _channel;

        public string ServiceName => "DCT";

        public DedsCheckAvailability(IDedsSearchServiceChannel channel)
        {
            _channel = channel;
        }

        public async Task<AvailabilityCheckResult> GetCheckResult()
        {
            try
            {
                DataSetVersionDescriptor dataSetVersionDescriptor =
                    await _channel.GetLatestPublishedDataSetVersionAsync("SummarisedActuals").ConfigureAwait(false);

                QueryDescriptor[] queries =
                    await
                        _channel.DiscoverQueriesAsync(new DiscoverQueriesCriteria
                        {
                            DataSetVersionId = dataSetVersionDescriptor.Id.Value
                        }).ConfigureAwait(false);

                QueryDescriptor closedCollectionsQuery = queries.First(q => q.Code == "GetClosedCollectionEvents");

                IList<string> valuesList = new List<string>();
                valuesList.Add(new DateTime(1753, 1, 1).ToString("s"));
                List<FilterValue> filterValues = GetQueryFilterValues(closedCollectionsQuery, valuesList);

                QueryExecution queryExecution = new QueryExecution
                {
                    FilterValues = filterValues.Where(x => !string.IsNullOrEmpty(x.FieldValue)).ToArray(),
                    SortValues = new SortValue[0]
                };

                await _channel.ExecuteQueryAsync(closedCollectionsQuery.Id.Value, queryExecution).ConfigureAwait(false);

                return new AvailabilityCheckResult(ServiceName, true);
            }
            catch (Exception ex)
            {
                return new AvailabilityCheckResult(ServiceName, false) {Details = ex.Message};
            }
        }

        private static List<FilterValue> GetQueryFilterValues(QueryDescriptor queryDescriptor, IList<string> values)
        {
            int valuesIndex = 0;
            Dictionary<string, string> queryFilterValues = queryDescriptor.FilterDescriptors.ToDictionary(filter => filter.FieldName, filter => values[valuesIndex++]);

            List<FilterValue> filterValues = new List<FilterValue>();

            filterValues.AddRange(queryFilterValues.Select(queryFilterValue => new FilterValue
            {
                FieldName = queryFilterValue.Key,
                FieldValue = queryFilterValue.Value
            }));

            return filterValues;
        }
    }
}