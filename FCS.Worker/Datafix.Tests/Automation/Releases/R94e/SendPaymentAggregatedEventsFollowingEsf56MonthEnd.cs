namespace Datafix.Tests.Automation.Releases.R94e
{
    using System.IO;
    using System.Reflection;
    using Newtonsoft.Json;
    using System.Collections.Generic;
    using System.Linq;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Events;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;

    public class SendPaymentAggregatedEventsFollowingEsf56MonthEnd : IApplyDataFix
    {
        public string Release => "R94e";

        public int StoryNumber => 31305;

        public string Name => "Send 122 PaymentAggregatedEvent messages following ESF56 MonthEnd";

        public int Order => 1;

        public void ApplyDataFix()
        {
            var paymentAggregatedEvents = GetPaymentAggregatedEventsFromJson(
                "Datafix.Tests", "Resources.R94e.PaymentAggregatedEventsEsf56.json");

            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<PaymentAggregatedEvent>();

            paymentAggregatedEvents.ToList().ForEach(paymentAggregatedEvent =>
            {
                if (IsCurrentVersionTheSame(paymentAggregatedEvent))
                {
                    endpoint.Send("ADMonitoringDomain.Endpoint", paymentAggregatedEvent).Wait();
                }
            });
        }

        private static IReadOnlyCollection<PaymentAggregatedEvent> GetPaymentAggregatedEventsFromJson(string nameSpace, string resourceName)
        {
            using (var stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (var streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<List<PaymentAggregatedEvent>>(streamReader.ReadToEnd());
            }
        }

        private bool IsCurrentVersionTheSame(PaymentAggregatedEvent paymentAggregatedEvent)
        {
            var allocationNumber = paymentAggregatedEvent.Allocation.AllocationNumber;
            var versionNumber = paymentAggregatedEvent.Allocation.VersionNumber;

            return LatestVersionNumber(allocationNumber) == versionNumber;
        }

        public int LatestVersionNumber(string allocationNumber)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentSchedulePolicyContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"SELECT MAX([VersionNumber]) 
                                      FROM [PaymentSchedule].[Allocation]
                                     WHERE [AllocationNumber] = @allocationNumber";

                return connection.ExecuteScalar<int>(sql, new {allocationNumber});
            }
        }
    }
}