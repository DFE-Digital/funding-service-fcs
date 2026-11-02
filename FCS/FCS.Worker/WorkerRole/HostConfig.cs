//namespace WorkerRole
//{
//    using NServiceBus;
//    using NServiceBus.Persistence;

//    public class HostConfig : IConfigureThisEndpoint, AsA_Worker
//    {
//        public void Customize(EndpointConfiguration configuration)
//        {
//            var transport = configuration.UseTransport<AzureServiceBusTransport>();
//            transport.ConnectionStringName("NsbTransport");

//            configuration.AssemblyScanner()
//                .ExcludeAssemblies("PaymentManagementDomain.Xrm.Integration.dll");
//                //.ExcludeTypes(Assembly.GetExecutingAssembly().GetTypes().Where(t => t.GetInterfaces().Any(i => i.Name == "AsA_FctEndpoint")).ToArray()); // a bit difficult to follow

//            configuration.UsePersistence<NHibernatePersistence, StorageType.Sagas>();
//            configuration.UsePersistence<NHibernatePersistence, StorageType.Subscriptions>();
//            configuration.UsePersistence<NHibernatePersistence, StorageType.Timeouts>();
//            configuration.UsePersistence<NHibernatePersistence, StorageType.Outbox>();
//            configuration.UsePersistence<NHibernatePersistence, StorageType.GatewayDeduplication>();

//            configuration.EnableInstallers();
//        }
//    }
//}
