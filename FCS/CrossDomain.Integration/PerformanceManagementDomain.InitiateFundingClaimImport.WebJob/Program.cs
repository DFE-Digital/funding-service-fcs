namespace PerformanceManagementDomain.InitiateFundingClaimImport.WebJob
{
    using System;
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    class Program
    {
        static async Task Main()
        {
            Console.WriteLine("Initiating Funding Claim Import WebJob");

            await EndpointBuilder.CreateSendOnlyEndpoint<BeginFundingClaimPullCommand>()
                .Send("PerformanceManagementDomain.PullFundingClaim", new BeginFundingClaimPullCommand());

            Console.WriteLine("Initiate Funding Claim Import WebJob completed successfully");
        }
    }
}