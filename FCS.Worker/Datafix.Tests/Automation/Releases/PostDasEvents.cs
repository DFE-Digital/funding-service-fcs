namespace Datafix.Tests.Automation.Releases
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractRequestDomain.Common.Commands;

    public class PostDasEvents
    {
        public static void AddAndProcessDasEvents(List<int> dasProviderList)
        {
            int eventId = GetLowestDasEventId() - 1;

            dasProviderList.ForEach(p => InsertDasEvent(p, eventId--));

            SendMessageToProcessProviderNotFoundDasEvents();
        }

        private static int GetLowestDasEventId()
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"Select TOP 1 EventId from [ContractManagement].[EngagementEvent] order by EventId;";

                return connection.ExecuteScalar<int>(sql);
            }
        }

        private static void InsertDasEvent(int ukprn, int eventId)
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"insert into [ContractManagement].[EngagementEvent] ([EventId]
                                    ,[EventType]
                                    ,[ProviderId]
                                    ,[ProcessingState]) values (@eventId, 'INITIATED', @ukprn, 5);";

                connection.Execute(sql, new { @ukprn = ukprn, @eventId = eventId });
            }
        }

        private static void SendMessageToProcessProviderNotFoundDasEvents()
        {
            var endpoint =
                EndpointBuilder.CreateSendOnlyEndpoint<RetryNotFoundProviderEngagementsCommand>();

            endpoint.Send("ContractRequestDomain.EngagementWatcher", new RetryNotFoundProviderEngagementsCommand())
                .Wait();
        }
    }
}