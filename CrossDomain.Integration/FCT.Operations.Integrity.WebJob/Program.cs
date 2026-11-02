namespace FCT.Operations.Integrity.WebJob
{
    using System;
    using System.Configuration;
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    class Program
    {
        static async Task Main()
        {
            if (!Convert.ToBoolean(ConfigurationManager.AppSettings["ShouldSendNightlyIntegrityCheckersCommand"]))
            {
                Console.WriteLine("Did not initiate nightly integrity checks, as it has been disabled in the app config settings.");
                return;
            }

            InitiateCheckersCommand command = InitiateCheckersCommand.CreateNightlyIntegrityChecksCommand();

            await EndpointBuilder.CreateSendOnlyEndpoint<InitiateCheckersCommand>()
                .Send("Operations.IntegrityCheckers", command);

            Console.WriteLine($"Initiated integrity checkers:{Environment.NewLine}{string.Join(Environment.NewLine, command.ChecksToRun)}");
        }
    }
}
