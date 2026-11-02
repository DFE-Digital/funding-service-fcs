namespace Datafix.Tests.Automation.Releases.R98
{
    using System.Configuration;
    using System.Linq;
    using System.Threading.Tasks;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public class CopyPaymentSummariesToSharepoint : IApplyDataFix
    {
        public string Release => "R98";
        public int StoryNumber => 31750;
        public string Name => "Make Consolidated Payment Summary Report available to end-users (31750)";
        public int Order => 1;
        private static string ContainerName => $"fcs-payment-report{GetEnvironmentSuffix()}";

        public void ApplyDataFix()
        {
            var blobNames = AzureStorageWrapper.GetBlobsInContainer(ContainerName);
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<UploadPaymentSummaryReportToSharePointCommand>();

            var sendTasks = blobNames.Select(blobName =>
            {
                var command = new UploadPaymentSummaryReportToSharePointCommand
                {
                    Filename = blobName
                };

                return endpoint.Send("Operations.PaymentSummary", command);
            }).ToArray();

            Task.WaitAll(sendTasks);
        }

        private static string GetEnvironmentSuffix()
        {
            var environment = ConfigurationManager.AppSettings["StorageTableSuffix"].ToLower();

            if (!string.IsNullOrEmpty(environment))
            {
                return "-" + environment;
            }

            return environment;
        }
    }
}
