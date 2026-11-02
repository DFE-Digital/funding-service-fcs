namespace Datafix.Tests.RunBeforeStartup
{
    using System;
    using WorkerRole.Common;

    public class CreateMissingTopicsAndSubscriptions : IRunBeforeStartup
    {
        public void Run()
        {
            Console.WriteLine("Starting CreateMissingTopicsAndSubscriptions");

            new NServiceBus7SubscriptionTests().ShouldCreateTopicesAndSubscriptionsThatAreMissing();

            Console.WriteLine("Finished CreateMissingTopicsAndSubscriptions");
        }
    }
}
