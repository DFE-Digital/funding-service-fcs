namespace CrossDomain.Integration.ReportDeliverer.Initiate
{
    using System;
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    class Program
    {
        static async Task Main()
        {
            await EndpointBuilder.CreateSendOnlyEndpoint<RunReportsCommand>()
                .Send("Operations.Cda.ReportGeneration", new RunReportsCommand());

            Console.WriteLine("Sent RunReportsCommand");
        }
    }
}
