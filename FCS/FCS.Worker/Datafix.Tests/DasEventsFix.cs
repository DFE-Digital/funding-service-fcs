namespace Datafix.Tests
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractRequestDomain.Common.Commands;

    public class DasEventsFix //: IApplyDataFix
    {
        public string Release => "R70A";
        public int StoryNumber => 27415;
        public string Name => "Insert Das Events as is they came from the Feed";
        public int Order => 1;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10007160,
                10007784,
                10013516,
                10019812,
                10044407,
                10044886,
                10045282,
                10045538,
                10048214,
                10052897,
                10055025,
                10055542,
                10062335,
                10063769,
                10065872,
                10066561,
                10066838,
                10067180,
                10067528,
                10081856,
                10081982,
                10082053
            };

            int eventId = -1;
            dasProviderList.ForEach(p => InsertDasEvent(p, eventId--));

            SendMessageToProcessProviderNotFoundDasEvents();
        }

        private static void SendMessageToProcessProviderNotFoundDasEvents()
        {
            IEndpointInstance endpoint =
                EndpointBuilder.CreateSendOnlyEndpoint<RetryNotFoundProviderEngagementsCommand>();

            endpoint.Send("ContractRequestDomain.EngagementWatcher", new RetryNotFoundProviderEngagementsCommand())
                .Wait();
        }

        private void InsertDasEvent(int ukprn, int eventId)
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"insert into [ContractManagement].[EngagementEvent] ([EventId]
                                    ,[EventType]
                                    ,[ProviderId]
                                    ,[ProcessingState]) values (@eventId, 'INITIATED', @ukprn, 5);";

                connection.Execute(sql, new {@ukprn = ukprn, @eventId = eventId});
            }
        }
    }
}