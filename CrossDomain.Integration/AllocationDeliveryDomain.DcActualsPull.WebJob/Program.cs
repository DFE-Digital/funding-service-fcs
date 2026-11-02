namespace AllocationDeliveryDomain.DcActualsPull.WebJob
{
    using System;
    using System.Threading.Tasks;
    using AllocationDelivery.Messages.Commands;
    using NServiceBus;

    class Program
    {
        static async Task Main()
        {
            Console.WriteLine("** Initiating DC Actuals Pull");

            Console.WriteLine("** Sending BeginDcActualsPullCommand");

            await EndpointBuilder.CreateSendOnlyEndpoint<BeginDcActualsPullCommand>()
                .Send("AllocationDeliveryDomain.ActualsPull", new BeginDcActualsPullCommand());

            Console.WriteLine("** Successfully initiated DC Actuals Pull");
        }
    }
}

