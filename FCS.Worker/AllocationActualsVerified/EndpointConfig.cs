namespace PaymentManagementDomain.AllocationActualsVerified
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.Windsor;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class EndpointConfig : IEndpointConfig
    {
        public string EndpointName => "Xrm.AllocationActualsVerified";

        public string NameOfAssembly => "PaymentManagementDomain.AllocationActualsVerified.dll";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>
            {
                new Subscription("AllocationDeliveryDomain.Validation", typeof(AllocationActualsVerified)),
                new Subscription("AllocationDeliveryDomain.ContractUnderTermination", typeof(AllocationActualsUpdated)),
            };

        public IReadOnlyCollection<CommandRoute> Routes => new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(ILoggerFactory loggerFactory)
        {
            EndpointConfiguration configuration = new EndpointConfiguration(EndpointName);

            var logger = new Logger(new System.Diagnostics.TraceSource("WorkerRole"));

            logger.LogInformation(1, $"Started Endpoint {EndpointName} on FCS.Worker");

            configuration.Conventions()
                .DefiningEventsAs(type => type.Namespace == "SFA.FCT.CrossDomain.Integration.Events")
                .DefiningCommandsAs(t =>
                    (t.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    t.GetInterfaces().Contains(typeof(ICommand)));

            configuration.UseContainer<WindsorBuilder>(customizations: customizations =>
            {
                customizations.ExistingContainer(
                    new WindsorContainer().Install(new WindsorInstaller(loggerFactory)));
            });

            return configuration;
        }
    }
}
