namespace Datafix.Tests
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;

    [TestClass]
    public class SendInitiateCheckersCommandTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void SendInitiateCheckerCommandsWithDelayedDelivery()
        {
            // arrange
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<InitiateCheckersCommand>();

            // act 1
            endpoint.Send("Operations.IntegrityCheckers", InitiateCheckersCommand.CreatePostMonthEndImmediateBatchIntegrityChecksCommand())
                .Wait();

            // act 2
            SendOptions sendOptions = new SendOptions();
            sendOptions.SetDestination("Operations.IntegrityCheckers");
            sendOptions.DelayDeliveryWith(TimeSpan.FromMinutes(10));
            endpoint.Send(InitiateCheckersCommand.CreatePostMonthEndDelayedBatchIntegrityChecksCommand(), sendOptions)
                .Wait();
        }
        
        [TestMethod, TestCategory("TechnicalExploration")]
        public void SendOperationalCheckShortIntervalCommand()
        {
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<OperationalCheckShortIntervalCommand>();

            endpoint.Send("Operations.IntegrityCheckers", new OperationalCheckShortIntervalCommand())
                .Wait();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void SendCheckConnectivityReply()
        {
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<CheckConnectivityReply>();

            var first = new CheckConnectivityReply.Result("service1", true, "errinfo1", "supInfo1");
            var second = new CheckConnectivityReply.Result("service2", true, "errinfo2", "supInfo2");
            var results = new List<CheckConnectivityReply.Result> { first, second };

            endpoint.Send("Operations.Connectivity", new CheckConnectivityReply(results))
                .Wait();
        }
    }
}
