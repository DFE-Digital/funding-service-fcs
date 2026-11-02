namespace PullFundingAllocations
{
    using System;
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    class Program
    {
        static async Task Main()
        {
            Console.WriteLine("Sending PullFundingAllocationsCommand.");

            await EndpointBuilder.CreateSendOnlyEndpoint<PullFundingAllocationsCommand>()
                .Send("FundingAllocation.PullFundingAllocation", new PullFundingAllocationsCommand());

            Console.WriteLine("PullFundingAllocationsCommand sent successfully.");
        }
    }
}
