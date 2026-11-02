using System;
using System.Configuration;
using System.Runtime.Remoting.Proxies;
using System.Threading.Tasks;
using NServiceBus;
using SFA.FCT.ContractRequestDomain.Common.Commands;
using SFA.FCT.ContractRequestDomain.DataStore.Repositories;

namespace ContractRequestDomain.EngagementWatcherWebJob
{
    class Program
    {
        static async Task Main()
        {
            Console.WriteLine("EngagementWatcherWebJob starting.");
             
            if (ShouldPollForDasEngagements())
            {
                Console.WriteLine("Sending InitiateEngagementPollingCommand and RetryNotFoundProviderEngagementsCommand.");

                await EndpointBuilder.CreateSendOnlyEndpoint<InitiateEngagementPollingCommand>()
                    .Send("ContractRequestDomain.EngagementWatcher", new InitiateEngagementPollingCommand());

                await EndpointBuilder.CreateSendOnlyEndpoint<RetryNotFoundProviderEngagementsCommand>()
                    .Send("ContractRequestDomain.EngagementWatcher", new RetryNotFoundProviderEngagementsCommand());

                Console.WriteLine("InitiateEngagementPollingCommand and RetryNotFoundProviderEngagementsCommand sent successfully.");
            }

            Console.WriteLine("EngagementWatcherWebJob complete.");
        }

        private static bool ShouldPollForDasEngagements()
        {

            WebjobStatusService webStatusService = new WebjobStatusService();

            var status = webStatusService.CheckjobStatus("EngagmenetWatcherWebjob");
            Console.WriteLine($"ShouldPollForDasEngagements set to be {status}.");
            return status;
        }
    }
}
