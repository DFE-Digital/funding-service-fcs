namespace DocumentsDomain.Integration.DocumentGenerationEndpointTests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using NServiceBus.AcceptanceTesting;
    using NServiceBus.MessageMutator;
    using NServiceBus.Saga;
    using NServiceBusAcceptanceTestingAdditions;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;

    [TestClass]
    public class DocumentGenerationRequestFromASaga
    {
        private const string CompleteReceivedBySaga = "CompleteReceivedBySaga";

        [TestMethod, TestCategory("IntegrationTest1")]
        public void DocumentGenerationRequestFromASaga_ShouldReplyToTheSameSaga()
        {
            using (var ctx = GetInitialContext())
            {
                Scenario.Define(ctx.Data)

                    .WithEndpoint<DocumentGenerationEndpointFullyMocked>(b => b.CustomConfig(DocumentGenerationEndpointFullyMocked.Configure(ctx)))

                    .WithEndpoint<EndpointThatHostsASaga>(b => b
                        .CustomConfig(EndpointThatHostsASaga.Configure(ctx))
                        .When(context => ctx.IsReadyToStart, bus => bus.SendLocal(new StartSaga())))
                    .Done(c => ctx.IsAllDone)
                    .Run(new TimeSpan(0, 0, 30));
            }
        }

        public Context GetInitialContext()
        {
            return new Context
            {
                ReadyToStart = contextData => contextData.EndpointsStarted,
                AllDone = contextData =>
                {
                    bool flag;
                    return contextData.Flags.TryGetValue(CompleteReceivedBySaga, out flag) && flag;
                }
            };
        }
    
        public class EndpointThatHostsASaga : EndpointConfigurationBuilder
        {
            public EndpointThatHostsASaga()
            {
                EndpointSetup<DefaultServer>()
                    .AddMapping<DocumentGenerationCommand>(typeof(DocumentGenerationEndpointFullyMocked))
                    .IncludeType<StartSaga>()
                    .IncludeType<TestSaga>()
                    .IncludeType<Handlers>()
                    .IncludeType<DocumentGenerationCommand>()
                    .IncludeType<DocumentGenerationComplete>();
            }

            public class Handlers : IHandleMessages<DocumentGenerationComplete>
            {
                public void Handle(DocumentGenerationComplete message)
                {
                    Assert.Fail("Message should have been stopped by the Saga handler but wasn't.");
                }
            }

            public static Action<BusConfiguration> Configure(Context ctx)
            {
                return configuration =>
                {
                    configuration.Conventions()
                                .DefiningCommandsAs(t => (null != t.Namespace && t.Namespace.EndsWith("Commands")) || t == typeof(StartSaga))
                                .DefiningMessagesAs(t => null != t.Namespace && t.Namespace.EndsWith("Messages"));

                    configuration.RegisterComponents(c => c.ConfigureComponent<Handlers>(DependencyLifecycle.InstancePerCall));
                };
            }
        }

        private const string NonSagaHandlerGotMessage = "NonSagaHandlerGotMessage";

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentGenerationRequestFromASaga_ShouldNotReplyToAnotherSaga()
        {
            var ctx = new Context
            {
                ReadyToStart = contextData => contextData.EndpointsStarted,
                AllDone = contextData =>
                {
                    bool flag;
                    return contextData.Flags.TryGetValue(NonSagaHandlerGotMessage, out flag) && flag;
                }
            };

            Scenario.Define(ctx.Data)

                .WithEndpoint<DocumentGenerationEndpointFullyMocked>(b => b.CustomConfig(DocumentGenerationEndpointFullyMocked.Configure(ctx)))

                .WithEndpoint<EndpointThatMutatesTheIncomingSagaId>(b =>
                    b.CustomConfig(configuration =>
                    {
                        configuration.Conventions()
                            .DefiningCommandsAs(t => (null != t.Namespace && t.Namespace.EndsWith("Commands")) || t == typeof(StartSaga))
                            .DefiningMessagesAs(t => null != t.Namespace && t.Namespace.EndsWith("Messages"));

                        configuration.RegisterComponents(c => c.ConfigureComponent<EndpointThatMutatesTheIncomingSagaId.MessageMutator>(DependencyLifecycle.InstancePerCall));
                    })

                    .When(context => ctx.IsReadyToStart, bus => bus.SendLocal(new StartSaga())))

                .Done(c => ctx.IsAllDone)
                .Run(new TimeSpan(0, 0, 30));
        }       

        public class EndpointThatMutatesTheIncomingSagaId : EndpointConfigurationBuilder
        {
            public EndpointThatMutatesTheIncomingSagaId()
            {
                EndpointSetup<DefaultServer>()
                    .AddMapping<DocumentGenerationCommand>(typeof(DocumentGenerationEndpointFullyMocked))
                    .IncludeType<StartSaga>()
                    .IncludeType<TestSaga>()
                    .IncludeType<MessageMutator>()
                    .IncludeType<DocumentGenerationCommand>()
                    .IncludeType<DocumentGenerationComplete>();
            }

            public class MessageMutator : IMutateIncomingTransportMessages, IHandleMessages<DocumentGenerationComplete>
            {
                public Context.ContextData TestContext { get; set; }

                public IBus Bus { get; set; }

                public void MutateIncoming(TransportMessage transportMessage)
                {
                    if (transportMessage.Headers.ContainsKey(Headers.MessageIntent) 
                        && transportMessage.Headers[Headers.MessageIntent] ==  "Reply"
                        && transportMessage.Headers.ContainsKey(Headers.SagaId))
                    {
                        // change the SagaId so that it won't be corralated
                        transportMessage.Headers[Headers.SagaId] = Guid.NewGuid().ToString();
                    }
                }

                public void Handle(DocumentGenerationComplete message)
                {
                    new Context(TestContext).AddOrUpdateFlag(NonSagaHandlerGotMessage, true);
                }
            }
        }

        public class TestSaga : Saga<MyTestSagaData>, IAmStartedByMessages<StartSaga>, IHandleMessages<DocumentGenerationComplete>
        {
            public Context.ContextData ContextData { get; set; }

            public void Handle(StartSaga message)
            {
                Bus.Send<DocumentGenerationCommand>(c => { });
            }

            public void Handle(DocumentGenerationComplete message)
            {
                new Context(ContextData).AddOrUpdateFlag(CompleteReceivedBySaga, true);
                MarkAsComplete();
                Bus.DoNotContinueDispatchingCurrentMessageToHandlers();
            }

            protected override void ConfigureHowToFindSaga(SagaPropertyMapper<MyTestSagaData> mapper)
            {
            }
        }

        public class MyTestSagaData : ContainSagaData
        {
            [Unique]
            public virtual Guid DataId { get; set; }
        }

        public class StartSaga : ICommand
        {
            public Guid DataId { get; set; }
        }
    }
}