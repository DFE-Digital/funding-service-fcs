namespace NServiceBusAcceptanceTestingAdditions.InMemoryTransportTests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using NServiceBus.AcceptanceTesting;
    using NServiceBus.Config;

    [TestClass]
    public class When_sending_from_a_send_only
    {
        [TestMethod, TestCategory("IntegrationTest1")]
        public void Should_receive_the_message()
        {
            var context = new Context
            {
                Id = Guid.NewGuid()
            };
            Scenario.Define(context)
                    .WithEndpoint<Sender>(b => b.Given((bus, c) => bus.Send(new MyMessage { Id = c.Id })))
                    .WithEndpoint<Receiver>()
                    .Done(c => c.WasCalled)
                    .Run();

            Assert.IsTrue(context.WasCalled, "The message handler should be called");
        }

        [TestMethod, TestCategory("IntegrationTest1")]
        public void Should_not_need_audit_or_fault_forwarding_config_to_start()
        {
            var context = new Context
            {
                Id = Guid.NewGuid()
            };
            Scenario.Define(context)
                    .WithEndpoint<SendOnlyEndpoint>()
                    .Done(c => c.SendOnlyEndpointWasStarted)
                    .Run();

            Assert.IsTrue(context.SendOnlyEndpointWasStarted, "The endpoint should have started without any errors");
        }

        public class Context : ScenarioContext
        {
            public bool WasCalled { get; set; }

            public Guid Id { get; set; }

            public bool SendOnlyEndpointWasStarted { get; set; }
        }

        public class SendOnlyEndpoint : EndpointConfigurationBuilder
        {
            public SendOnlyEndpoint()
            {
                EndpointSetup<DefaultServer>()
                    .SendOnly()
                    .IncludeType<Bootstrapper>();
            }

            public class Bootstrapper : IWantToRunWhenConfigurationIsComplete
            {
                public Context Context { get; set; }

                public void Run(Configure config)
                {
                    Context.SendOnlyEndpointWasStarted = true;
                }
            }
        }

        public class Sender : EndpointConfigurationBuilder
        {
            public Sender()
            {
                EndpointSetup<DefaultServer>()
                    .SendOnly()
                    .AddMapping<MyMessage>(typeof(Receiver))
                    .IncludeType<MyMessage>();
            }
        }

        public class Receiver : EndpointConfigurationBuilder
        {
            public Receiver()
            {
                EndpointSetup<DefaultServer>()
                    .IncludeType<MyMessageHandler>()
                    .IncludeType<MyMessage>();
            }
        }

        [Serializable]
        public class MyMessage : ICommand
        {
            public Guid Id { get; set; }
        }

        public class MyMessageHandler : IHandleMessages<MyMessage>
        {
            public Context Context { get; set; }

            public IBus Bus { get; set; }

            public void Handle(MyMessage message)
            {
                if (Context.Id != message.Id)
                {
                    return;
                }

                Context.WasCalled = true;
            }
        }
    }
}
