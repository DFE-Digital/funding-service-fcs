namespace ContractManagementDomain.InitiateRoatpUpdate.WebJob
{
    using System;
    using System.Configuration;
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCT.ContractManagementService.Common.Commands;

    class Program
    {
        static async Task Main()
        {
            if (!ShouldSendInitiateRoatpUpdateCommand())
            {
                Console.WriteLine("InitiateRoatpUpdateCommand not sent, appSetting set to false");
                return;
            }

            await EndpointBuilder.CreateSendOnlyEndpoint<InitiateRoatpUpdateCommand>()
                .Send("ContractManagementDomain.LevyAmendmentEndpoint", new InitiateRoatpUpdateCommand());
            
            Console.WriteLine("Sent InitiateRoatpUpdateCommand");
        }

        private static bool ShouldSendInitiateRoatpUpdateCommand()
        {
            return bool.Parse(ConfigurationManager.AppSettings["ShouldSendInitiateRoatpUpdateCommand"]);
        }
    }
}
