namespace SFA.FCT.Framework.Logging.UnitTests
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.IO;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Bespoke;
    using SFA.FCT.Framework.Logging.NullObjects;

    [TestClass]
    public class BespokeLogWriterTests
    {
        private Mock<ICloudLogQueue> _queue;

        [TestInitialize]
        public void Setup()
        {
            _queue = new Mock<ICloudLogQueue>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IsEnabled_ShouldDependOnLogLevel()
        {
            var verbose = new BespokeLogWriter(_queue.Object, LogLevel.Verbose);
            var info = new BespokeLogWriter(_queue.Object, LogLevel.Information);
            var warn = new BespokeLogWriter(_queue.Object, LogLevel.Warning);

            Assert.IsTrue(verbose.IsVerboseEnabled());
            Assert.IsTrue(verbose.IsInformationEnabled());
            Assert.IsFalse(info.IsVerboseEnabled());
            Assert.IsTrue(info.IsInformationEnabled());
            Assert.IsFalse(warn.IsInformationEnabled());
            Assert.IsTrue(warn.IsWarningEnabled());
            Assert.IsTrue(warn.IsErrorEnabled());
            Assert.IsTrue(warn.IsCriticalEnabled());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LogVerbose_ShouldNotWrite_WhenLevelIsInformation()
        {
            var writer = new BespokeLogWriter(_queue.Object, LogLevel.Information);

            writer.LogVerbose("msg");
            writer.LogVerbose(5, "msg");
            writer.LogVerbose(new Exception("x"), "msg");

            _queue.Verify(q => q.AddEntry(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<LogLevel>()), Times.Never());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LogVerbose_ShouldWrite_WhenLevelIsVerbose()
        {
            var writer = new BespokeLogWriter(_queue.Object, LogLevel.Verbose);

            writer.LogVerbose("hello {0}", "world");
            writer.LogVerbose(7, "id");

            _queue.Verify(q => q.AddEntry(1, "hello world", LogLevel.Verbose), Times.Once());
            _queue.Verify(q => q.AddEntry(7, "id", LogLevel.Verbose), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LogVerbose_WithException_ShouldAppendExceptionDetails()
        {
            var writer = new BespokeLogWriter(_queue.Object, LogLevel.Verbose);

            writer.LogVerbose(new InvalidOperationException("boom"), "plain", "a");

            _queue.Verify(q => q.AddEntry(1, "plainSystem.Object[],boom,", LogLevel.Verbose), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LogInformation_ShouldWriteWithExpectedIds()
        {
            var writer = new BespokeLogWriter(_queue.Object, LogLevel.Information);

            writer.LogInformation("a {0}", 1);
            writer.LogInformation(9, "b");
            writer.LogInformation(new Exception("e"), "c");

            _queue.Verify(q => q.AddEntry(1, "a 1", LogLevel.Information), Times.Once());
            _queue.Verify(q => q.AddEntry(9, "b", LogLevel.Information), Times.Once());
            _queue.Verify(q => q.AddEntry(1, It.IsAny<string>(), LogLevel.Information), Times.Exactly(2));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LogInformation_ShouldNotWrite_WhenLevelIsWarning()
        {
            var writer = new BespokeLogWriter(_queue.Object, LogLevel.Warning);

            writer.LogInformation("a");
            writer.LogInformation(3, "a");
            writer.LogInformation(new Exception("e"), "a");

            _queue.Verify(q => q.AddEntry(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<LogLevel>()), Times.Never());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LogWarning_ShouldAlwaysWrite()
        {
            var writer = new BespokeLogWriter(_queue.Object, LogLevel.Critical);

            writer.LogWarning("w");
            writer.LogWarning(4, "w4");
            writer.LogWarning(new Exception("ex"), "we");

            _queue.Verify(q => q.AddEntry(1, "w", LogLevel.Warning), Times.Once());
            _queue.Verify(q => q.AddEntry(4, "w4", LogLevel.Warning), Times.Once());
            _queue.Verify(q => q.AddEntry(1, It.IsAny<string>(), LogLevel.Warning), Times.Exactly(2));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LogError_ShouldAlwaysUseIdOne()
        {
            var writer = new BespokeLogWriter(_queue.Object, LogLevel.Critical);

            writer.LogError(42, "e {0}", "x");
            writer.LogError(42, new Exception("ex"), "msg");

            _queue.Verify(q => q.AddEntry(1, "e x", LogLevel.Error), Times.Once());
            _queue.Verify(q => q.AddEntry(1, It.IsAny<string>(), LogLevel.Error), Times.Exactly(2));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LogCritical_ShouldPreserveId()
        {
            var writer = new BespokeLogWriter(_queue.Object, LogLevel.Critical);

            writer.LogCritical(11, "c {0}", "x");
            writer.LogCritical(12, new Exception("ex"), "msg {1}", "a");

            _queue.Verify(q => q.AddEntry(11, "c x", LogLevel.Critical), Times.Once());
            _queue.Verify(q => q.AddEntry(12, "msg ex", LogLevel.Critical), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Log_WithoutArgs_ShouldPassFormatThrough()
        {
            var writer = new BespokeLogWriter(_queue.Object, LogLevel.Verbose);

            writer.LogWarning("{not formatted}");

            _queue.Verify(q => q.AddEntry(1, "{not formatted}", LogLevel.Warning), Times.Once());
        }
    }

    [TestClass]
    public class LogEntryTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Create_ShouldPopulateAllFields()
        {
            var entry = LogEntry.Create("hello", 5, "dep", "role1", "name", LogLevel.Error);

            Assert.IsTrue(entry.Message.EndsWith(" : hello"));
            Assert.AreEqual(5, entry.EventId);
            Assert.AreEqual("dep", entry.DeploymentId);
            Assert.AreEqual("role1", entry.RoleInstance);
            Assert.AreEqual((int)LogLevel.Error, entry.Level);
            Assert.IsTrue(entry.PartitionKey.StartsWith("0"));
            Assert.AreEqual("dep__name__role1__" + entry.RowIndex, entry.RowKey);
            Guid parsed;
            Assert.IsTrue(Guid.TryParse(entry.RowIndex, out parsed));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Create_ShouldGenerateUniqueRowKeys()
        {
            var a = LogEntry.Create("m", 1, "d", "r", "n", LogLevel.Verbose);
            var b = LogEntry.Create("m", 1, "d", "r", "n", LogLevel.Verbose);

            Assert.AreNotEqual(a.RowKey, b.RowKey);
        }
    }

    [TestClass]
    public class EnvironmentTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AppServiceEnvironment_ShouldReturnConstructorValues()
        {
            var env = new AppServiceEnvironment("role", "id", "dep");

            Assert.AreEqual("role", env.GetRoleName());
            Assert.AreEqual("id", env.GetRoleId());
            Assert.AreEqual("dep", env.GetDeploymentId());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WebJobEnvironment_GetRoleId_ShouldBeZero()
        {
            Assert.AreEqual("0", new WebJobEnvironment().GetRoleId());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WebJobEnvironment_ShouldNotThrowWhenSettingsMissing()
        {
            var env = new WebJobEnvironment();

            env.GetRoleName();
            env.GetDeploymentId();
        }
    }

    [TestClass]
    public class NullObjectTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void LoggerNullObject_ShouldNotThrowAndReportEnabled()
        {
            var logger = new LoggerNullObject();
            var ex = new Exception("x");

            logger.LogVerbose("a");
            logger.LogVerbose(1, "a");
            logger.LogVerbose(ex, "a");
            logger.LogInformation("a");
            logger.LogInformation(1, "a");
            logger.LogInformation(ex, "a");
            logger.LogWarning("a");
            logger.LogWarning(1, "a");
            logger.LogWarning(ex, "a");
            logger.LogError(1, "a");
            logger.LogError(1, ex, "a");
            logger.LogCritical(1, "a");
            logger.LogCritical(1, ex, "a");

            Assert.IsTrue(logger.IsVerboseEnabled());
            Assert.IsTrue(logger.IsInformationEnabled());
            Assert.IsTrue(logger.IsWarningEnabled());
            Assert.IsTrue(logger.IsErrorEnabled());
            Assert.IsTrue(logger.IsCriticalEnabled());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ActivityCorrelatorNullObject_ShouldReturnGuids()
        {
            var correlator = new ActivityCorrelatorNullObject();

            Assert.AreNotEqual(Guid.Empty, correlator.ActivityId);
            Assert.AreNotEqual(Guid.Empty, correlator.Start());
            correlator.Start(Guid.NewGuid());
            correlator.Finish();
        }
    }

    [TestClass]
    public class LogDetailAttributeTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void LogDetailAttribute_ShouldCaptureName()
        {
            Assert.AreEqual("Name", new LogDetailAttribute("Name").LogPropertyName);
        }
    }

    [TestClass]
    public class SimpleConsoleLoggerTests
    {
        private TextWriter _origOut;
        private TextWriter _origErr;
        private StringWriter _out;
        private StringWriter _err;

        [TestInitialize]
        public void Setup()
        {
            _origOut = Console.Out;
            _origErr = Console.Error;
            _out = new StringWriter();
            _err = new StringWriter();
            Console.SetOut(_out);
            Console.SetError(_err);
        }

        [TestCleanup]
        public void Cleanup()
        {
            Console.SetOut(_origOut);
            Console.SetError(_origErr);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NonErrorLevels_ShouldWriteToStdOut()
        {
            var logger = new SimpleConsoleLogger();

            logger.LogVerbose("v {0}", 1);
            logger.LogInformation("i {0}", 2);
            logger.LogWarning("w {0}", 3);

            var text = _out.ToString();
            StringAssert.Contains(text, "v 1");
            StringAssert.Contains(text, "i 2");
            StringAssert.Contains(text, "w 3");
            Assert.AreEqual(string.Empty, _err.ToString());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ErrorAndCritical_ShouldWriteToStdErr()
        {
            var logger = new SimpleConsoleLogger();

            logger.LogError(1, "e {0}", 1);
            logger.LogCritical(1, "c {0}", 2);

            StringAssert.Contains(_err.ToString(), "e 1");
            StringAssert.Contains(_err.ToString(), "c 2");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IsEnabled_ShouldAlwaysBeTrue()
        {
            var logger = new SimpleConsoleLogger();

            Assert.IsTrue(logger.IsVerboseEnabled());
            Assert.IsTrue(logger.IsInformationEnabled());
            Assert.IsTrue(logger.IsWarningEnabled());
            Assert.IsTrue(logger.IsErrorEnabled());
            Assert.IsTrue(logger.IsCriticalEnabled());
        }
    }

    [TestClass]
    public class LoggerTests
    {
        private RecordingListener _listener;

        private Logger CreateLogger(SourceLevels levels)
        {
            _listener = new RecordingListener();
            var source = new TraceSource("Framework.Logging.UnitTests", levels);
            source.Listeners.Clear();
            source.Listeners.Add(_listener);
            Trace.CorrelationManager.ActivityId = Guid.NewGuid();
            return new Logger(source);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Logger_ShouldWriteEachSeverityWithFormattedMessage()
        {
            var logger = CreateLogger(SourceLevels.All);

            logger.LogVerbose("v {0}", 1);
            logger.LogInformation("i {0}", 2);
            logger.LogWarning("w {0}", 3);
            logger.LogError(4, "e {0}", 4);
            logger.LogCritical(5, "c {0}", 5);

            CollectionAssert.AreEqual(
                new[] { TraceEventType.Verbose, TraceEventType.Information, TraceEventType.Warning, TraceEventType.Error, TraceEventType.Error },
                _listener.Types);
            CollectionAssert.AreEqual(new[] { 1, 1, 1, 4, 5 }, _listener.Ids);
            StringAssert.EndsWith(_listener.Messages[0], " : v 1");
            StringAssert.EndsWith(_listener.Messages[4], " : c 5");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Logger_WithIdOverloads_ShouldUseSuppliedId()
        {
            var logger = CreateLogger(SourceLevels.All);

            logger.LogVerbose(8, "a");
            logger.LogInformation(9, "b");
            logger.LogWarning(10, "c");

            CollectionAssert.AreEqual(new[] { 8, 9, 10 }, _listener.Ids);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Logger_WithException_ShouldIncludeExceptionDetails()
        {
            var logger = CreateLogger(SourceLevels.All);
            var ex = new InvalidOperationException("bad thing");

            logger.LogVerbose(ex, "ctx {0}", 1);
            logger.LogInformation(ex, "ctx {0}", 1);
            logger.LogWarning(ex, "ctx {0}", 1);
            logger.LogError(2, ex, "ctx {0}", 1);
            logger.LogCritical(3, ex, "ctx {0}", 1);

            Assert.AreEqual(5, _listener.Messages.Count);
            foreach (var message in _listener.Messages)
            {
                StringAssert.Contains(message, "Exception. ctx 1. Details: ");
                StringAssert.Contains(message, "bad thing");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Logger_IsEnabled_ShouldFollowSwitch()
        {
            var warnings = CreateLogger(SourceLevels.Warning);

            Assert.IsFalse(warnings.IsVerboseEnabled());
            Assert.IsFalse(warnings.IsInformationEnabled());
            Assert.IsTrue(warnings.IsWarningEnabled());
            Assert.IsTrue(warnings.IsErrorEnabled());

            var all = CreateLogger(SourceLevels.All);

            Assert.IsTrue(all.IsVerboseEnabled());
            Assert.IsTrue(all.IsInformationEnabled());
            Assert.IsTrue(all.IsCriticalEnabled());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Logger_ShouldFilterBelowSwitchLevel()
        {
            var logger = CreateLogger(SourceLevels.Warning);

            logger.LogVerbose("hidden");
            logger.LogInformation("hidden");
            logger.LogWarning("shown");

            Assert.AreEqual(1, _listener.Messages.Count);
        }
    }

    [TestClass]
    public class ActivityCorrelatorTests
    {
        [TestInitialize]
        public void Setup()
        {
            Trace.CorrelationManager.ActivityId = Guid.Empty;
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Start_ShouldSetNewActivityId_AndFinishShouldReset()
        {
            var correlator = new ActivityCorrelator(new TraceSource("ac", SourceLevels.All));

            var id = correlator.Start();

            Assert.AreNotEqual(Guid.Empty, id);
            Assert.AreEqual(id, correlator.ActivityId);

            correlator.Finish();

            Assert.AreEqual(Guid.Empty, correlator.ActivityId);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Start_WithId_ShouldUseSuppliedId()
        {
            var correlator = new ActivityCorrelator(new TraceSource("ac", SourceLevels.All));
            var id = Guid.NewGuid();

            correlator.Start(id);

            Assert.AreEqual(id, correlator.ActivityId);
            correlator.Finish();
        }
    }

    [TestClass]
    public class LoggerFactoryTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CreateLogger_ShouldReturnNullObject_WhenNoCloudEnvironment()
        {
            var factory = new LoggerFactory(null);

            Assert.IsInstanceOfType(factory.CreateLogger("x"), typeof(LoggerNullObject));
        }
    }

    public class RecordingListener : TraceListener
    {
        public List<string> Messages { get; } = new List<string>();

        public List<TraceEventType> Types { get; } = new List<TraceEventType>();

        public List<int> Ids { get; } = new List<int>();

        public override void TraceEvent(TraceEventCache eventCache, string source, TraceEventType eventType, int id, string format, params object[] args)
        {
            Types.Add(eventType);
            Ids.Add(id);
            Messages.Add(args == null || args.Length == 0 ? format : string.Format(format, args));
        }

        public override void TraceEvent(TraceEventCache eventCache, string source, TraceEventType eventType, int id, string message)
        {
            Types.Add(eventType);
            Ids.Add(id);
            Messages.Add(message);
        }

        public override void TraceTransfer(TraceEventCache eventCache, string source, int id, string message, Guid relatedActivityId)
        {
        }

        public override void Write(string message)
        {
        }

        public override void WriteLine(string message)
        {
        }
    }
}
