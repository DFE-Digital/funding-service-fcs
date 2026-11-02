namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System.Collections.Generic;
    using System.Data;
    using System.Linq;
    using Dapper;
    using DTOs;
    using LanguageExt;
    using AllocationDeliveryDomain.Common.DataStore;

    public class MonitoringDeliverablesRepository : IMonitoringDeliverablesRepository
    {
        private readonly IDbConnection _connection;

        public MonitoringDeliverablesRepository(IDbConnection connection)
        {
            _connection = connection;
        }

        public Option<int> GetMultipleCollectionGroupId(string fundingStreamPeriodCode, string collectionType,
            string collectionReturnCode)
        {
            var rows = _connection.Query<int>("sp_Operation_GetMultipleCollectionGroupId @fundingStreamPeriodCode,@collectionType,@collectionReturnCode",
                param: new { fundingStreamPeriodCode, collectionType, collectionReturnCode }).ToList();

            if (rows.Count == 1)
            {
                return rows.Single();
            }

            return Option<int>.None;
        }

        public IReadOnlyCollection<CollectionReturn> GetCollectionReturns(
            int multipleCollectionGroupId,
            string collectionType,
            string collectionReturnCode)
        {
            return _connection.Query<CollectionReturn>("sp_Operation_GetCollectionReturns @multipleCollectionGroupId,@collectionType,@collectionReturnCode",
                param: new { multipleCollectionGroupId, collectionType, collectionReturnCode }).ToList();
        }
    }
}
