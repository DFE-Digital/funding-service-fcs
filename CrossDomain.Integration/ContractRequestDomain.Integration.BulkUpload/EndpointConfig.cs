namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using Common.Commands;
    using Common.Utils;
    using CrossDomain.Integration.Events;
    using CrossDomain.Integration.Messages.Commands;
    using FCS.Worker.Common;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using IoC;
    using NServiceBus;

    public class EndpointConfig : IEndpointConfig
    {
        static EndpointConfig()
        {
            BulkImportProcessingTable = ConfigurationHelper.GetSetting(ConfigurationHelper.BulkUpdateProcessingTableConfigEntryKey);
            BulkImportLocationMappingTable = ConfigurationHelper.GetSetting(ConfigurationHelper.BulkUpdateLocationMappingTableConfigEntryKey);
        }

        private static readonly IReadOnlyCollection<string> EventsUsedInThisEndpoint = new List<string>
        {
            nameof(INewExcelUploadFileEvent),
            nameof(BulkUploadInProgressEvent),
            nameof(BulkUploadCompleteEvent)
        };

        public static string BulkImportProcessingTable { get; private set; }

        public static string BulkImportLocationMappingTable { get; private set; }

        public string NameOfAssembly => "ContractRequestDomain.Integration.BulkUpload.dll";

        public string EndpointName => "ContractRequestDomain.BulkUpload";

        public IReadOnlyCollection<Subscription> Subscriptions => new List<Subscription>
        {
            new Subscription("ContractRequestDomain.FileWatcher", typeof(INewExcelUploadFileEvent))
        };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>
        {
            new CommandRoute("ContractCreateDomain.CreateContract", typeof(NewContractRequestCommand)),
            new CommandRoute("ContractCreateDomain.CreateContract", typeof(NewAmendmentRequestCommand)),
            new CommandRoute("ContractCreateDomain.CreateContract", typeof(RevisedNewContractRequestCommand)),
            new CommandRoute("ContractCreateDomain.UpdateContract", typeof(DraftContractUpdateRequestCommand)),
            new CommandRoute("ContractCreateDomain.AmendContract", typeof(ContractAmendmentRequestCommand)),
            new CommandRoute("ContractCreateDomain.UpdateDraftContractAmendment", typeof(UpdateDraftContractAmendmentRequestCommand)),
            new CommandRoute(EndpointName, typeof(StartBulkImportProcessingCommand))
        };

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = new Logger(new System.Diagnostics.TraceSource("WorkerRole"));

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on CDI");

            configuration.Conventions()
                .DefiningCommandsAs(t =>
                    (t.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    t.GetInterfaces().Contains(typeof(ICommand)))
                .DefiningEventsAs(t => EventsUsedInThisEndpoint.Any(e => t.Name.EndsWith(e)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
