namespace SFA.FCT.Framework.NSBLogging.UnitTests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class NSBLoggerTests
    {
        private Mock<ILogger> _inner;
        private NSBLogger _log;

        [TestInitialize]
        public void Setup()
        {
            _inner = new Mock<ILogger>();
            _log = new NSBLogger(_inner.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IsEnabledProperties_ShouldMapToInnerLogger()
        {
            _inner.Setup(l => l.IsVerboseEnabled()).Returns(true);
            _inner.Setup(l => l.IsInformationEnabled()).Returns(false);
            _inner.Setup(l => l.IsWarningEnabled()).Returns(true);
            _inner.Setup(l => l.IsErrorEnabled()).Returns(false);
            _inner.Setup(l => l.IsCriticalEnabled()).Returns(true);

            Assert.IsTrue(_log.IsDebugEnabled);
            Assert.IsFalse(_log.IsInfoEnabled);
            Assert.IsTrue(_log.IsWarnEnabled);
            Assert.IsFalse(_log.IsErrorEnabled);
            Assert.IsTrue(_log.IsFatalEnabled);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Debug_ShouldLogVerbose()
        {
            var ex = new Exception("x");

            _log.Debug("m");
            _log.Debug("m2", ex);
            _log.DebugFormat("f {0}", 1);

            _inner.Verify(l => l.LogVerbose("m", It.IsAny<object[]>()), Times.Once());
            _inner.Verify(l => l.LogVerbose(ex, "m2", It.IsAny<object[]>()), Times.Once());
            _inner.Verify(l => l.LogVerbose("f {0}", It.Is<object[]>(a => a.Length == 1 && (int)a[0] == 1)), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Info_ShouldLogInformation()
        {
            var ex = new Exception("x");

            _log.Info("m");
            _log.Info("m2", ex);
            _log.InfoFormat("f {0}", 1);

            _inner.Verify(l => l.LogInformation("m", It.IsAny<object[]>()), Times.Once());
            _inner.Verify(l => l.LogInformation(ex, "m2", It.IsAny<object[]>()), Times.Once());
            _inner.Verify(l => l.LogInformation("f {0}", It.Is<object[]>(a => a.Length == 1)), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Warn_ShouldLogWarning()
        {
            var ex = new Exception("x");

            _log.Warn("m");
            _log.Warn("m2", ex);
            _log.WarnFormat("f {0}", 1);

            _inner.Verify(l => l.LogWarning("m", It.IsAny<object[]>()), Times.Once());
            _inner.Verify(l => l.LogWarning(ex, "m2", It.IsAny<object[]>()), Times.Once());
            _inner.Verify(l => l.LogWarning("f {0}", It.Is<object[]>(a => a.Length == 1)), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Error_ShouldLogErrorWithIdOne()
        {
            var ex = new Exception("x");

            _log.Error("m");
            _log.Error("m2", ex);
            _log.ErrorFormat("f {0}", 1);

            _inner.Verify(l => l.LogError(1, "m", It.IsAny<object[]>()), Times.Once());
            _inner.Verify(l => l.LogError(1, ex, "m2", It.IsAny<object[]>()), Times.Once());
            _inner.Verify(l => l.LogError(1, "f {0}", It.Is<object[]>(a => a.Length == 1)), Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Fatal_ShouldLogCriticalWithIdOne()
        {
            var ex = new Exception("x");

            _log.Fatal("m");
            _log.Fatal("m2", ex);
            _log.FatalFormat("f {0}", 1);

            _inner.Verify(l => l.LogCritical(1, "m", It.IsAny<object[]>()), Times.Once());
            _inner.Verify(l => l.LogCritical(1, ex, "m2", It.IsAny<object[]>()), Times.Once());
            _inner.Verify(l => l.LogCritical(1, "f {0}", It.Is<object[]>(a => a.Length == 1)), Times.Once());
        }
    }

    [TestClass]
    public class NSBLoggerFactoryTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetLogger_ByName_ShouldReturnNSBLogger()
        {
            var factory = new NSBLoggerFactory(new Mock<ILogger>().Object);

            Assert.IsInstanceOfType(factory.GetLogger("name"), typeof(NSBLogger));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetLogger_ByType_ShouldReturnNSBLoggerThatUsesInnerLogger()
        {
            var inner = new Mock<ILogger>();
            var factory = new NSBLoggerFactory(inner.Object);

            var log = factory.GetLogger(typeof(string));
            log.Info("hi");

            Assert.IsInstanceOfType(log, typeof(NSBLogger));
            inner.Verify(l => l.LogInformation("hi", It.IsAny<object[]>()), Times.Once());
        }
    }
}
