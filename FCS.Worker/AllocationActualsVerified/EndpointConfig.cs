
namespace PaymentManagementDomain.AllocationActualsVerified
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Extensions.Logging;
    using Microsoft.Extensions.DependencyInjection;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Common;

    public class EndpointConfig : IEndpointConfig
    {
        public string EndpointName => "Xrm.AllocationActualsVerified";

        public string NameOfAssembly =>
            "PaymentManagementDomain.AllocationActualsVerified.dll";

        public IReadOnlyCollection<Subscription> Subscriptions =>
            new List<Subscription>
            {
                new Subscription("AllocationDeliveryDomain.Validation", typeof(AllocationActualsVerified)),
                new Subscription("AllocationDeliveryDomain.ContractUnderTermination", typeof(AllocationActualsUpdated)),
            };

        public IReadOnlyCollection<CommandRoute> Routes =>
            new List<CommandRoute>();

        public EndpointConfiguration GetEndpointConfiguration(
            ILoggerFactory loggerFactory)
        {
            var configuration = new EndpointConfiguration(EndpointName);

            // ✅ Logging
            var logger = loggerFactory.CreateLogger<EndpointConfig>();
            logger.LogInformation("Started Endpoint {EndpointName}", EndpointName);

            // ✅ Conventions (PRESERVED EXACT LOGIC)
            configuration.Conventions()
                .DefiningEventsAs(type =>
                    type.Namespace == "SFA.FCT.CrossDomain.Integration.Events")
                .DefiningCommandsAs(t =>
                    (t?.Namespace != null && t.Namespace.EndsWith("Commands")) ||
                    t.GetInterfaces().Contains(typeof(ICommand)));

            // ✅ Serialization
            configuration.UseSerialization<SystemJsonSerializer>();

            // ✅ ✅ Local DI
            configuration.RegisterComponents(services =>
            {
                services.AddSingleton(loggerFactory);
                services.AddAllocationActualsVerifiedServices();
            });

            return configuration;
        }
    }
}
