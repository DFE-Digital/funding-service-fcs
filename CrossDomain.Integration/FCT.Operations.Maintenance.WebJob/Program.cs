namespace FCT.Operations.Maintenance.WebJob
{
    using System;
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    class Program
    {
        static async Task Main()
        {
            Console.WriteLine("Initiating Operational Maintenance");

            await EndpointBuilder.CreateSendOnlyEndpoint<MaintainAuditQueueCommand>()
                .Send("Operations.Maintenance", new MaintainAuditQueueCommand());

            await EndpointBuilder.CreateSendOnlyEndpoint<DeleteCrmReplicationFailuresCommand>()
                .Send("Operations.Maintenance", new DeleteCrmReplicationFailuresCommand());

            await EndpointBuilder.CreateSendOnlyEndpoint<HousekeepProcessedMessageTables>()
                .Send("Operations.Maintenance", new HousekeepProcessedMessageTables());

            await EndpointBuilder.CreateSendOnlyEndpoint<HousekeepAuditMessageTable>()
                .Send("Operations.Maintenance", new HousekeepAuditMessageTable());

            Console.WriteLine("Successfully initiated Operational Maintenance");
        }
    }
}
