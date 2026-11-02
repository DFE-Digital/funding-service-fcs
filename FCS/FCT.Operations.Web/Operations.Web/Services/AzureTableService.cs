namespace Operations.Web.Services
{
    using Microsoft.WindowsAzure.Storage.Table;
    using Operations.Web.Dtos;
    using System.Collections.Generic;
    using System.Threading.Tasks;

    public class AzureTableService : IAzureTableService
    {
        private readonly CloudTable _table;

        public AzureTableService(CloudTable table)
        {
            _table = table;
        }

        public async Task InsertReleaseEntityAsync(ReleaseEntity releaseEntity)
        {
            var insertOperation = TableOperation.Insert(releaseEntity);
            await _table.ExecuteAsync(insertOperation);
        }

        public async Task<List<ReleaseEntity>> GetAllEntitiesAsync()
        {
            var query = new TableQuery<ReleaseEntity>();
            var entities = new List<ReleaseEntity>();
            TableContinuationToken token = null;

            do
            {
                var resultSegment = await _table.ExecuteQuerySegmentedAsync(query, token);
                entities.AddRange(resultSegment.Results);
                token = resultSegment.ContinuationToken;
            } while (token != null);

            return entities;
        }


        public async Task<ReleaseEntity> GetReleaseEntityAsync(string rowkey)
        {
            var retrieveOperation = TableOperation.Retrieve<ReleaseEntity>("APPLEVY", rowkey);
            var result = await _table.ExecuteAsync(retrieveOperation);
            return result.Result as ReleaseEntity;
        }

        public async Task UpdateReleaseEntityAsync(ReleaseEntity releaseEntity)
        {
            var updateOperation = TableOperation.Replace(releaseEntity);
            await _table.ExecuteAsync(updateOperation);
        }
    }

}
