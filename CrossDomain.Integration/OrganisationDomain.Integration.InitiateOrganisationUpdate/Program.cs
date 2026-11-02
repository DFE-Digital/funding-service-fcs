namespace OrganisationDomain.Integration.InitiateOrganisationUpdate
{
    using System;
    using System.Threading.Tasks;
    using Messages.Commands;
    using NServiceBus;

    class Program
    {
        static async Task Main()
        {
            Console.WriteLine("InitiateOrganisationUpdate web job started.");

            await EndpointBuilder.CreateSendOnlyEndpoint<InitOrganisationUpdate>()
                .Send("OrgService.Main", new InitOrganisationUpdate { ProcessId = "UpdateOrgServiceSaga" });

            await EndpointBuilder.CreateSendOnlyEndpoint<UpdateSupplementaryDataChangesCommand>()
                .Send("OrgService.Main", new UpdateSupplementaryDataChangesCommand());

            Console.WriteLine("InitiateOrganisationUpdate web job complete.");
        }
    }
}