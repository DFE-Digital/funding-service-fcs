namespace Operations.Worker.Tests.Slack
{
    using System.Collections.Generic;
    using NServiceBus.Faults;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Operations.Worker.Slack;

    [TestClass]
    public class SlackMessageSenderTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void SlackMessageSender_SendMessage_ShouldSendSlackMessageWithNServiceBusHeaderValues()
        {
            var appConfigurationRoot = AppConfiguration.Configuration();
            const string suffixText = "- TechnicalExploration - Text";

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
            slackMessageSender.SendMessage(failedMessage, Mock.Of<ILogger>()).Wait();
        }


        [TestMethod, TestCategory("TechnicalExploration")]
        public void SlackMessageSender_SendMessage_ShouldSendSlackTextMessage()
        {
            var appConfigurationRoot = AppConfiguration.Configuration();

            var slackMessageSender = new SlackMessageSender(appConfigurationRoot);
            slackMessageSender.SendMessage("TechnicalExploration - Slack text message", Mock.Of<ILogger>()).Wait();
        }
    }
}