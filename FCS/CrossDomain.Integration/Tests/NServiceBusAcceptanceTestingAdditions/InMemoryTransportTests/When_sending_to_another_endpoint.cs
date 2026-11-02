namespace NServiceBusAcceptanceTestingAdditions.InMemoryTransportTests
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using NServiceBus.AcceptanceTesting;

    [TestClass]
    public class When_sending_to_another_endpoint
    {
        [TestMethod, TestCategory("IntegrationTest1")]
        public void Should_receive_the_message()
        {
            var context = new Context
            {
                Id = Guid.NewGuid()
            };

            Scenario.Define(context)
                    .WithEndpoint<Receiver>()
                    .WithEndpoint<Sender>(b => b.Given((bus, c) =>
                    {
                        bus.OutgoingHeaders["MyStaticHeader"] = "StaticHeaderValue";
                        bus.Send<MyMessage>(m =>
                        {
                            m.Id = c.Id;
                            bus.SetMessageHeader(m, "MyHeader", "MyHeaderValue");
                        });
                    }))
                    .Done(c => c.WasCalled)
                    .Run();

            Assert.IsTrue(context.WasCalled, "The message handler should be called");
            Assert.AreEqual(1, context.TimesCalled, "The message handler should only be invoked once");
            Assert.AreEqual("StaticHeaderValue", context.ReceivedHeaders["MyStaticHeader"], "Static headers should be attached to outgoing messages");
            Assert.AreEqual("MyHeaderValue", context.MyHeader, "Static headers should be attached to outgoing messages");
        }

        public class Context : ScenarioContext
        {
            public bool WasCalled { get; set; }

            public int TimesCalled { get; set; }

            public IDictionary<string, string> ReceivedHeaders { get; set; }

            public Guid Id { get; set; }

            public string MyHeader { get; set; }
        }

        public class Sender : EndpointConfigurationBuilder
        {
            public Sender()
            {
                EndpointSetup<DefaultServer>()
                    .AddMapping<MyMessage>(typeof(Receiver))
                    .IncludeType<MyMessage>();
            }
        }

        public class Receiver : EndpointConfigurationBuilder
        {
            public Receiver()
            {
                EndpointSetup<DefaultServer>()
                    .IncludeType<MyMessage>()
                    .IncludeType<MyMessageHandler>();
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

                    Context.TimesCalled++;

                    Context.MyHeader = Bus.GetMessageHeader(message, "MyHeader");

                    Context.ReceivedHeaders = Bus.CurrentMessageContext.Headers;

                    Context.WasCalled = true;
                }
            }
        }

        public class MyMessage : IMessage
        {
            public Guid Id { get; set; }
        }
    }
}
