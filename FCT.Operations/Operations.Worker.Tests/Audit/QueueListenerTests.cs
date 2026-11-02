namespace Operations.Worker.Tests.Audit
{
    using System;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Worker.Audit;

    [TestClass]
    public class QueueListenerTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void QueueListener_ShouldProcessMessage()
        {
            QueueListener.BeginListening(m => FcsMessageProcessor.WriteAuditMessageToTable(m, new FcsConfiguration(AppConfiguration.Configuration())), "audit", Mock.Of<ILogger>(), new FcsConfiguration(AppConfiguration.Configuration())).Wait();

            Task.Delay(TimeSpan.FromSeconds(300)).Wait();
        }
    }
}
