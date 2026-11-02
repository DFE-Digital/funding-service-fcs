namespace NServiceBusAcceptanceTestingAdditions.InMemoryTransportTests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using NServiceBus.AcceptanceTesting;
    using NServiceBus.Saga;

    [TestClass]
    public class When_an_endpoint_replies_to_a_saga
    {
        [TestMethod, TestCategory("IntegrationTest1")]
        public void Should_correlate_all_saga_messages_properly()
        {
            Scenario.Define<Context>()
                    .WithEndpoint<EndpointThatHostsASaga>(b => b.Given(bus => bus.SendLocal(new StartSaga { DataId = Guid.NewGuid() })))
                    .WithEndpoint<EndpointThatHandlesAMessageFromSagaAndReplies>()
                    .Done(c => c.DidSagaReplyMessageGetCorrelated)
                    .Run();
        }

        public class Context : ScenarioContext
        {
            public bool DidSagaReplyMessageGetCorrelated { get; set; }
        }

        public class EndpointThatHandlesAMessageFromSagaAndReplies : EndpointConfigurationBuilder
        {
            public EndpointThatHandlesAMessageFromSagaAndReplies()
            {
                EndpointSetup<DefaultServer>()
                    .IncludeType<DoSomething>()
                    .IncludeType<DoSomethingResponse>()
                    .IncludeType<DoSomethingHandler>();
            }

            public class DoSomethingHandler : IHandleMessages<DoSomething>
            {
                public IBus Bus { get; set; }

                public void Handle(DoSomething message)
                {
                    Console.WriteLine("Received DoSomething command for DataId:{0} ... and responding with a reply", message.DataId);
                    Bus.Reply(new DoSomethingResponse { DataId = message.DataId });
                }
            }
        }

        public class EndpointThatHostsASaga : EndpointConfigurationBuilder
        {
            public EndpointThatHostsASaga()
            {
                EndpointSetup<DefaultServer>()
                    .AddMapping<DoSomething>(typeof(EndpointThatHandlesAMessageFromSagaAndReplies))
                    .IncludeType<StartSaga>()
                    .IncludeType<DoSomething>()
                    .IncludeType<DoSomethingResponse>()
                    .IncludeType<Saga2>();
            }

            public class Saga2 : Saga<Saga2.MySaga2Data>, IAmStartedByMessages<StartSaga>, IHandleMessages<DoSomethingResponse>
            {
                public Context Context { get; set; }

                public void Handle(StartSaga message)
                {
                    Console.Out.WriteLine("Saga2 sending DoSomething for DataId: {0}", message.DataId);
                    Data.DataId = message.DataId;
                    Bus.Send(new DoSomething { DataId = message.DataId });
                }

                public void Handle(DoSomethingResponse message)
                {
                    Context.DidSagaReplyMessageGetCorrelated = message.DataId == Data.DataId;
                    Console.Out.WriteLine("Saga received DoSomethingResponse for DataId: {0} and MarkAsComplete", message.DataId);
                    MarkAsComplete();
                }

                protected override void ConfigureHowToFindSaga(SagaPropertyMapper<MySaga2Data> mapper)
                {
                }

                public class MySaga2Data : ContainSagaData
                {
                    [Unique]
                    public virtual Guid DataId { get; set; }
                }
            }
        }

        [Serializable]
        public class StartSaga : ICommand
        {
            public Guid DataId { get; set; }
        }

        public class DoSomething : ICommand
        {
            public Guid DataId { get; set; }
        }

        public class DoSomethingResponse : IMessage
        {
            public Guid DataId { get; set; }
        }
    }
}
