namespace FundingAllocation.Tests.Slack
{
    using System.Collections.Generic;
    using System.Runtime.InteropServices;
    using NServiceBus.Faults;
    using FundingAllocation.Slack;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class SlackMessageSenderTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void SlackMessageSender_SendMessage_ShouldSendSlackMessageWithEnvironmentIncludedInMessage()
        {
            var appConfigurationRoot = AppConfiguration.Configuration();
            const string suffixText = "- TechnicalExploration - TEAMSMessageWithEnvironmentIncluded";

            var headers = new Dictionary<string, string>
            {
                {"NServiceBus.OriginatingEndpoint", $"OriginatingEndpoint {suffixText}"},
                {"NServiceBus.ProcessingEndpoint", $"ProcessingEndpoint {suffixText}"},
                {"NServiceBus.ExceptionInfo.Message", $"ExceptionInfo.Message {suffixText}"},
                {"NServiceBus.FailedQ",$"NServiceBus.FailedQ {suffixText}"},
                {"NServiceBus.OtherHeaderNotToBeMessaged", $"NServiceBus.OtherHeaderNotToBeMessaged {suffixText}"}
            };

            var failedMessage = new FailedMessage("", headers, null, null, "");

            var slackMessageSender = new SlackMessageSender(appConfigurationRoot);
            slackMessageSender.SendMessage(failedMessage, Mock.Of<ILogger>(), SlackChannel.General).Wait();
        }
    }
}