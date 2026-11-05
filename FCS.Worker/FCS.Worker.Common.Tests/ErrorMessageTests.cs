using System;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using NServiceBus.Faults;
using SFA.FCS.Worker.Common.Slack;
using SFA.FCT.Framework.Logging.Interfaces;

namespace SFA.FCS.Worker.Common.Tests
{
    [TestClass]
    public class ErrorMessageTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ErrorMessage_PrefixesServiceAndSendsAsUser()
        {
            var message = new ErrorMessage("svc", "oops");

            Assert.AreEqual("svc oops", message.text);
            Assert.IsTrue(message.as_user);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ToErrorMessage_IncludesOnlyPresentHeaders()
        {
            var headers = new Dictionary<string, string>
            {
                { "NServiceBus.ProcessingEndpoint", "ep" },
                { "NServiceBus.ExceptionInfo.Message", "bad" }
            };
            var failed = new FailedMessage("id", headers, new byte[0], new Exception("x"), "errors");

            var message = failed.ToErrorMessage("Test", "svc");

            Assert.AreEqual("svc (Test) NServiceBus.ProcessingEndpoint : ep, NServiceBus.ExceptionInfo.Message : bad", message.text);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SendMessage_PostFails_LogsErrorInsteadOfThrowing()
        {
            var logger = new Mock<ILogger>();

            ErrorMessageNotifier.SendMessage("hello", logger.Object, "svc");

            logger.Verify(l => l.LogError(1, It.IsAny<string>(), It.IsAny<object[]>()), Times.Once);
        }
    }
}
