namespace WorkerRole.Tests
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Bespoke;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class BespokeLoggingTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void LogEntryTests_ShouldBeAbleToReadLogEntry()
        {
            var logEntry = LogEntry.Create("Test log entry", 11, "5461ec5829c246a5b3a999f25b2fba68", 
                "WorkerRole_IN_0", "WorkerRole", LogLevel.Information);

            var azureStorageConnectionString = ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString;

            var azureTable = AzureTableStore.GetTable("WADLogsTable", azureStorageConnectionString);

            AzureTableStore.CreateRow(azureTable, logEntry);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void QueueReader_ShouldProcessAllLogEntries()
        {
            const int totalLogEntries = 10;
            IReadOnlyCollection<LogEntry> logEntries = Enumerable.Range(0, totalLogEntries).Select(i => LogEntry.Create("Test log entry", i, "5461ec5829c246a5b3a999f25b2fba68",
                " WorkerRole_IN_0", "WorkerRole", LogLevel.Information))
                .ToList();
            
            ConcurrentQueue<LogEntry> queue = new ConcurrentQueue<LogEntry>(logEntries);

            QueueReader queueReader = new QueueReader(queue);

            queueReader.StartDequeuingAndProcessing(e => { });

            Assert.AreEqual(totalLogEntries, queue.Count, "we should not have started processing yet");

            Task.Delay(TimeSpan.FromSeconds(3)).Wait();

            Assert.AreEqual(0, queue.Count, "we have not dequeued all messages");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void QueueReader_ShouldProcessAllLogEntriesWhenTheyAreSlowToProcess()
        {
            const int totalLogEntries = 10;
            IReadOnlyCollection<LogEntry> logEntries = Enumerable.Range(0, totalLogEntries).Select(i => LogEntry.Create("Test log entry", i, "5461ec5829c246a5b3a999f25b2fba68",
                    " WorkerRole_IN_0", "WorkerRole", LogLevel.Information))
                .ToList();

            ConcurrentQueue<LogEntry> queue = new ConcurrentQueue<LogEntry>(logEntries);

            QueueReader queueReader = new QueueReader(queue);

            queueReader.StartDequeuingAndProcessing(e => { Task.Delay(TimeSpan.FromSeconds(1)).Wait(); });

            Assert.AreEqual(totalLogEntries, queue.Count, "we should not have started processing yet");

            Task.Delay(TimeSpan.FromSeconds(13)).Wait();

            Assert.AreEqual(0, queue.Count, "we have not dequeued all messages");

            queue.Enqueue(LogEntry.Create("Test log entry", 11, "5461ec5829c246a5b3a999f25b2fba68",
                " WorkerRole_IN_0", "WorkerRole", LogLevel.Information));

            Task.Delay(TimeSpan.FromSeconds(3)).Wait();

            Assert.AreEqual(0, queue.Count, "we have stopped processing");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void LoggerFactory_ShouldCreateLoggerWhichWritesToAzureAble()
        {
            Mock<ICloudEnvironment> cloudEnvironmentMock = new Mock<ICloudEnvironment>();

            cloudEnvironmentMock.Setup(c => c.GetDeploymentId()).Returns("5461ec5829c246a5b3a999f25b2fba68");
            cloudEnvironmentMock.Setup(c => c.GetRoleId()).Returns("WorkerRole_IN_0");
            cloudEnvironmentMock.Setup(c => c.GetRoleName()).Returns("WorkerRole");

            var logger = GetDefaultLogger(cloudEnvironmentMock.Object);

            logger.LogInformation(111, "Test Logger");

            Task.Delay(TimeSpan.FromSeconds(10)).Wait();
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void BespokeLogWriter_ShouldNotLogInformationWhenLevelIsError()
        { 
            Mock<ICloudLogQueue> cloudLogQueue = new Mock<ICloudLogQueue>();

            var logger = new BespokeLogWriter(cloudLogQueue.Object, LogLevel.Error);

            logger.LogInformation(111, "Test Logger");

            cloudLogQueue.Verify(q => q.AddEntry(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<LogLevel>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void BespokeLogWriter_ShouldLogInformationWhenLevelIsInformation()
        {
            Mock<ICloudLogQueue> cloudLogQueue = new Mock<ICloudLogQueue>();

            var logger = new BespokeLogWriter(cloudLogQueue.Object, LogLevel.Information);

            logger.LogInformation(111, "Test Logger");

            cloudLogQueue.Verify(q => q.AddEntry(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<LogLevel>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void BespokeLogWriter_ShouldLogInformationWhenLevelIsVerbose()
        {
            Mock<ICloudLogQueue> cloudLogQueue = new Mock<ICloudLogQueue>();

            var logger = new BespokeLogWriter(cloudLogQueue.Object, LogLevel.Verbose);

            logger.LogInformation(111, "Test Logger");

            cloudLogQueue.Verify(q => q.AddEntry(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<LogLevel>()), Times.Once);
        }

        private ILogger GetDefaultLogger(ICloudEnvironment cloudEnvironment)
        {
            ConcurrentQueue<LogEntry> logEntries = new ConcurrentQueue<LogEntry>();
            QueueReader reader = new QueueReader(logEntries);
            
            BespokeLogWriter logWriter = new BespokeLogWriter(new CloudLogQueue(logEntries, cloudEnvironment), LogLevel.Verbose);

            var azureStorageConnectionString = ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString;

            var azureTable = AzureTableStore.GetTable(
                tableName: "WADLogsTable",
                connectionString: azureStorageConnectionString);

            reader.StartDequeuingAndProcessing(logEntry =>
            {
                AzureTableStore.CreateRow(azureTable, logEntry);
            });

            return logWriter;
        }
    }
}
