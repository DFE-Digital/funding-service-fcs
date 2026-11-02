namespace OrganisationDomain.InitiateOrgSupplementaryDataPopulation.WebJob
{
    using System;
    using System.Threading.Tasks;
    using Integration.Messages.Commands;
    using NServiceBus;

    class Program
    {
        static async Task Main()
        {
            Console.WriteLine("Initiating Organisation Supplementary Data Population");

            await EndpointBuilder.CreateSendOnlyEndpoint<InitiateOrgSupplementaryDataPopulationCommand>()
                .Send("OrgService.Main", new InitiateOrgSupplementaryDataPopulationCommand { ShouldIssueCrmNotifications = true });

            Console.WriteLine("Successfully initiated Organisation Supplementary Data Population");
        }
    }
}
