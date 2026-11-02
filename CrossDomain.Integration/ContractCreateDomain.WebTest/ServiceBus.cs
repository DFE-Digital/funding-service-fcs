using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Web;
using NServiceBus;
using SFA.FCT.CrossDomain.Integration.Common;

namespace SFA.FCT.ContractCreateDomain.WebTest
{
    [ExcludeFromCodeCoverage]
    public static class ServiceBus
    {
        public static IBus Bus { get; private set; }
        private static readonly object padlock = new object();
        public static void Init()
        {
            if (Bus != null)
                return;
            lock (padlock)
            {
                if (Bus != null)
                    return;
                var cfg = new BusConfiguration();
                cfg.UseTransport<MsmqTransport>();
                cfg.UsePersistence<InMemoryPersistence>();
                cfg.EndpointName(FctEndpoint.GenerateEndpointName("ContractRequestDomain.BulkUpload"));
                cfg.PurgeOnStartup(true);
                cfg.EnableInstallers();

                Bus = NServiceBus.Bus.Create(cfg).Start();
            }
        }
    }
}