namespace WorkerRole.Tests.Slack
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Security.Policy;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Faults;
    using SFA.FCS.Worker.Common.Slack;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ErrorMessageNotifierTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ErrorMessageNotifier_ShouldSendSlackMessageWithEnvironmentIncludedInMessage()
        {
            // arrange
            const string suffixText = "- TechnicalExploration - FCS.Worker - TeamsMessageWithEnvironmentIncluded";

            var headers = new Dictionary<string, string>
            {
                {"NServiceBus.OriginatingEndpoint", $"OriginatingEndpoint {suffixText}"},
                {"NServiceBus.ProcessingEndpoint", $"ProcessingEndpoint {suffixText}"},
                {"NServiceBus.ExceptionInfo.Message", $"ExceptionInfo.Message {suffixText}"},
                {"NServiceBus.FailedQ", $"NServiceBus.FailedQ {suffixText}"},
                {"NServiceBus.OtherHeaderNotToBeMessaged", $"NServiceBus.OtherHeaderNotToBeMessaged {suffixText}"}
            };

            var failedMessage = new FailedMessage("", headers, null, null, "");
            string url = "<<check with devops>>";
            url = System.Net.WebUtility.HtmlDecode(url);
            ConfigurationManager.AppSettings["ErrorWebhook:UrlXml"] = url;
            
            ConfigurationManager.AppSettings["SlackError:ShouldSend"] = "true";
            ConfigurationManager.AppSettings["StorageTableSuffix"] = "CI";
            
            // act
            ErrorMessageNotifier.SendMessage(failedMessage, Mock.Of<ILogger>(), "FCS.Worker");
        }
    }
}
