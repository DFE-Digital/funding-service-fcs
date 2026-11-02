namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Dapper;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using DTOs;
    using System.Data.SqlClient;
    using FCS.Worker.Common;
    using AllocationDeliveryDomain.Common.DataStore;

    public class SummarisedActualRepository
    {
        private readonly IFcsConfiguration _configuration;

        public SummarisedActualRepository(IFcsConfiguration configuration)
        {
            _configuration = configuration;
        }

        private string ConnectionString => _configuration["ConnectionStrings:MonitoringDeliverablesDbContext"];

        public IReadOnlyCollection<SummarisedActualOrgFspGroupKey> GetSummarisedActualOrgFspGroupKeys(string collectionType, string collectionReturnCode)
        {            
            using (var sqlConnection = new SqlConnection(ConnectionString))
            {
                var groupKeys = sqlConnection
                    .Query<SummarisedActualOrgFspGroupKey>("sp_Operation_GetSummarisedActualOrgFspGroupKeys @collectionType,@collectionReturnCode",
                    param: new { 
                        collectionType,
                        collectionReturnCode 
                    });

                return groupKeys.ToList();
            }
        }

        public IReadOnlyCollection<SummarisedActual> GetSummarisedActuals(SummarisedActualOrgFspGroupKey groupKey)
        {
            using (var sqlConnection = new SqlConnection(ConnectionString))
            {
                return sqlConnection.Query<SummarisedActual>("dbo.sp_Operation_GetSummarisedActuals @CollectionType,@CollectionReturnCode," +
                    "@OrganisationId,@FundingStreamPeriodCode,@UopCode", param: new
                    {
                        groupKey.CollectionType,
                        groupKey.CollectionReturnCode,
                        groupKey.OrganisationId,
                        groupKey.FundingStreamPeriodCode,
                        groupKey.UopCode
                    }).ToList();
            }
        }

        public IReadOnlyCollection<SummarisedActual> GetSummarisedActualsForCollectionTypeAndReturnCode(string collectionType, string collectionReturnCode)
        {
            using (var sqlConnection = new SqlConnection(ConnectionString))
            {
                return sqlConnection.Query<SummarisedActual>(
                   "sp_Operation_GetSummarisedActualsForCollectionTypeAndReturnCode @collectionType,@collectionReturnCode",
                   param: new { collectionType, collectionReturnCode },
                   commandTimeout: 300
               ).ToList();
            }
        }
    }
}