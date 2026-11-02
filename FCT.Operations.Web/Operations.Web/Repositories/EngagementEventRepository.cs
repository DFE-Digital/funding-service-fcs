namespace Operations.Web.Repositories
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using System.Threading.Tasks;
    using System.Collections.Generic;
    using ContractManagement.DataStore.Model;
    using System.Linq;
    using Dtos;
    using ContractManagement.DataStore;
    using System.Data.Entity;

    public class EngagementEventRepository : IEngagementEventRepository
    {
        private static string ConnectionString => ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

        public async Task<InsertResult> AddIfNotAlreadyAdded(string providerId)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                return await connection.QuerySingleAsync<InsertResult>("dbo.sp_OpsWeb_AddIfNotAlreadyAdded @providerId", new { providerId });
            }
        }

        public async Task<IReadOnlyCollection<EngagementEventInfo>> GetRecentEngagementEvents()
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                using (var context = new ContractManagementDbContext())
                {
                    var rows = await context.EngagementEvents.ToListAsync();
                    var engagementEvents = (from r in rows
                                            orderby r.CreatedDate descending
                                            select new EngagementEvent
                                            {
                                                EventId = r.EventId,
                                                EventType = r.EventType
                        ,
                                                ProviderId = r.ProviderId
                        ,
                                                CreatedDate = r.CreatedDate
                        ,
                                                ProcessingState = r.ProcessingState
                        ,
                                                ContractNumber = r.ContractNumber                                                 
                                            }).Take(30).ToList();

                    var engagementEventInfos = engagementEvents.Select(ee => new EngagementEventInfo(ee.EventId,
                                ee.ProviderId,
                                ee.CreatedDate,
                                ee.ProcessingState.ToString(),
                                ee.ContractNumber))
                            .ToList();

                    return engagementEventInfos;

                }
            }

        }
    }

    public class InsertResult
    {
        public InsertResult(int added, int eventId)
        {
            Added = added;
            EventId = eventId;
        }

        public int Added { get; }
        public int EventId { get; }

        public bool IsAdded => Added == 1;
    }
}