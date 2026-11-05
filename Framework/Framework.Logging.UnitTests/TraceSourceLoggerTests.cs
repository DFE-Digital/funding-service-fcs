using System;
using System.Collections.Generic;
using System.Diagnostics;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Framework.Logging.NullObjects;

namespace SFA.FCT.Framework.Logging.UnitTests
{
    [TestClass]
    public class TraceSourceLoggerTests
    {
        private sealed class CapturingListener : TraceListener
        {
            public readonly List<string> Events = new List<string>();

            public override void TraceEvent(TraceEventCache eventCache, string source, TraceEventType eventType, int id, string format, params object[] args)
            {
                Events.Add(eventType + "|" + id + "|" + string.Format(format, args));
            }

            public override void Write(string message) { }

            public override void WriteLine(string message) { }
        }

        private CapturingListener _listener;
        private Logger _logger;
        private Guid _originalActivity;

        [TestInitialize]
        public void Setup()
        {
            _originalActivity = Trace.CorrelationManager.ActivityId;
            Trace.CorrelationManager.ActivityId = Guid.NewGuid();
            _listener = new CapturingListener();
            var source = new TraceSource("LoggerTests", SourceLevels.All);
            source.Listeners.Clear();
            source.Listeners.Add(_listener);
            _logger = new Logger(source);
        }

        [TestCleanup]
        public void Cleanup()
        {
            Trace.CorrelationManager.ActivityId = _originalActivity;
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LogMethods_WithoutId_UseDefaultIdOne()
        {
            _logger.LogVerbose("v {0}", 1);
            _logger.LogInformation("i {0}", 2);
            _logger.LogWarning("w {0}", 3);

            Assert.AreEqual(3, _listener.Events.Count);
            StringAssert.StartsWith(_listener.Events[0], "Verbose|1|");
            StringAssert.StartsWith(_listener.Events[1], "Information|1|");
            StringAssert.StartsWith(_listener.Events[2], "Warning|1|");
            StringAssert.EndsWith(_listener.Events[0], "v 1");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LogMethods_WithId_UseSuppliedId()
        {
            _logger.LogVerbose(5, "v");
            _logger.LogInformation(6, "i");
            _logger.LogWarning(7, "w");
            _logger.LogError(8, "e");
            _logger.LogCritical(9, "c");

            StringAssert.StartsWith(_listener.Events[0], "Verbose|5|");
            StringAssert.StartsWith(_listener.Events[1], "Information|6|");
            StringAssert.StartsWith(_listener.Events[2], "Warning|7|");
            StringAssert.StartsWith(_listener.Events[3], "Error|8|");
            StringAssert.StartsWith(_listener.Events[4], "Error|9|");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LogMethods_WithException_IncludeExceptionDetails()
        {
            var ex = new InvalidOperationException("boom");

            _logger.LogVerbose(ex, "ctx {0}", "a");
            _logger.LogInformation(ex, "ctx {0}", "b");
            _logger.LogWarning(ex, "ctx {0}", "c");
            _logger.LogError(3, ex, "ctx {0}", "d");
            _logger.LogCritical(4, ex, "ctx {0}", "e");

            Assert.AreEqual(5, _listener.Events.Count);
            foreach (var e in _listener.Events)
            {
                StringAssert.Contains(e, "Exception. ctx");
                StringAssert.Contains(e, "boom");
            }

            StringAssert.StartsWith(_listener.Events[3], "Error|3|");
            StringAssert.StartsWith(_listener.Events[4], "Error|4|");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IsEnabled_ReflectsSwitchLevel()
        {
            var source = new TraceSource("LoggerTestsLevel", SourceLevels.Warning);
            var logger = new Logger(source);

            Assert.IsFalse(logger.IsVerboseEnabled());
            Assert.IsFalse(logger.IsInformationEnabled());
            Assert.IsTrue(logger.IsWarningEnabled());
            Assert.IsTrue(logger.IsErrorEnabled());
            Assert.IsTrue(logger.IsCriticalEnabled());
        }
    }

    [TestClass]
    public class LoggerNullObjectCoverageTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllMethods_DoNotThrow()
        {
            var logger = new LoggerNullObject();
            var ex = new Exception("x");

            logger.LogVerbose("f");
            logger.LogVerbose(1, "f");
            logger.LogVerbose(ex, "f");
            logger.LogInformation("f");
            logger.LogInformation(1, "f");
            logger.LogInformation(ex, "f");
            logger.LogWarning("f");
            logger.LogWarning(1, "f");
            logger.LogWarning(ex, "f");
            logger.LogError(1, "f");
            logger.LogError(1, ex, "f");
            logger.LogCritical(1, "f");
            logger.LogCritical(1, ex, "f");

            logger.IsVerboseEnabled();
            logger.IsInformationEnabled();
            logger.IsWarningEnabled();
            logger.IsErrorEnabled();
            logger.IsCriticalEnabled();
        }
    }
}
