namespace CrossDomain.Integration.InitiateMonthEndCDAReport.WebJob
{
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using System;
    using System.Threading.Tasks;

    class Program
    {
        static async Task Main()
        {
            await EndpointBuilder.CreateSendOnlyEndpoint<RunReportsAndArchiveExistingCommand>()
                .Send("Operations.Cda.ReportGeneration", new RunReportsAndArchiveExistingCommand());

            Console.WriteLine("RunReportsAndArchiveExistingCommand sent successfully");
        }
    }
}
