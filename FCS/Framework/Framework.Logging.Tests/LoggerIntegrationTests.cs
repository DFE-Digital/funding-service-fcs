using System;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using Microsoft.Practices.EnterpriseLibrary.Common.Configuration;
using Microsoft.Practices.EnterpriseLibrary.ExceptionHandling;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Framework.Logging.Interfaces;
using SFA.FCT.Framework.TestHelpers;

namespace SFA.FCT.Framework.Logging.Tests
{
    [TestClass]
    public class LoggerIntegrationTests
    {
        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void LogCritical_ShouldWriteToTraceListener()
        {
            //Arrange
            TestListener.Reset();
            var source = new TraceSource("SFA.FCT.Framework.LoggingSource");
            ILogger logger = new Logger(source);
            const string message = "Critical error.";

            //Act
            logger.LogCritical(2015, message);

            var log = ((TestListener)source.Listeners["TestListener"]).Log;

            //Assert
            Assert.IsTrue(log.Contains("Error: 2015"));
            Assert.IsTrue(log.Contains(message));
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void LogCritical_ShouldWriteToTraceListener_WithOutOfMemoryException()
        {
            //Arrange
            TestListener.Reset();
            var source = new TraceSource("SFA.FCT.Framework.LoggingSource");
            ILogger logger = new Logger(source);
            const string message = "Critical error.";
            var e = new OutOfMemoryException();

            //Act
            logger.LogCritical(2015, e, message);

            var log = ((TestListener)source.Listeners["TestListener"]).Log;

            //Assert
            Assert.IsTrue(log.Contains("Error: 2015"));
            Assert.IsTrue(log.Contains(message));
            Assert.IsTrue(log.Contains(e.Message));
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void LogCritical_ShouldWriteToTraceListener_WithOutOfMemoryException_InnerException()
        {
            //Arrange
            TestListener.Reset();
            var source = new TraceSource("SFA.FCT.Framework.LoggingSource");
            ILogger logger = new Logger(source);
            const string message = "Critical error.";
            var e = new Exception("Out of memory!", new OutOfMemoryException());

            //Act
            logger.LogCritical(2015, e, message);

            var log = ((TestListener)source.Listeners["TestListener"]).Log;

            //Assert
            Assert.IsTrue(log.Contains("Error: 2015"));
            Assert.IsTrue(log.Contains(message));
            Assert.IsTrue(log.Contains(e.Message));
            Assert.IsTrue(log.Contains(e.InnerException.Message));
            Assert.IsTrue(log.Contains("Out of memory!"));
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void LogError_ShouldWriteToTraceListener()
        {
            //Arrange
            TestListener.Reset();
            var source = new TraceSource("SFA.FCT.Framework.LoggingSource");
            ILogger logger = new Logger(source);
            const string message = "Argument cannot be null.";

            //Act
            logger.LogError(2015, message);

            var log = ((TestListener)source.Listeners["TestListener"]).Log;

            //Assert
            Assert.IsTrue(log.Contains("Error: 2015"));
            Assert.IsTrue(log.Contains(message));
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void LogError_ShouldWriteToTraceListener_WithArgumentNullException()
        {
            //Arrange
            TestListener.Reset();
            var source = new TraceSource("SFA.FCT.Framework.LoggingSource");
            ILogger logger = new Logger(source);
            const string message = "Argument cannot be null.";
            var e = new ArgumentNullException();

            //Act
            logger.LogError(2015, e, message);

            var log = ((TestListener)source.Listeners["TestListener"]).Log;

            //Assert
            Assert.IsTrue(log.Contains("Error: 2015"));
            Assert.IsTrue(log.Contains(message));
            Assert.IsTrue(log.Contains(e.Message));
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void LogError_ShouldWriteToTraceListener_WithArgumentNullException_InnerException()
        {
            //Arrange
            TestListener.Reset();
            var source = new TraceSource("SFA.FCT.Framework.LoggingSource");
            ILogger logger = new Logger(source);
            const string message = "Argument cannot be null.";
            var e = new Exception("Argument null.", new ArgumentNullException());

            //Act
            logger.LogError(2015, e, message);

            var log = ((TestListener)source.Listeners["TestListener"]).Log;

            //Assert
            Assert.IsTrue(log.Contains("Error: 2015"));
            Assert.IsTrue(log.Contains(message));
            Assert.IsTrue(log.Contains(e.Message));
            Assert.IsTrue(log.Contains(e.InnerException.Message));
            Assert.IsTrue(log.Contains("Argument null."));
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void LogInformation_ShouldWriteToTraceListener()
        {
            //Arrange
            TestListener.Reset();
            var source = new TraceSource("SFA.FCT.Framework.LoggingSource");
            ILogger logger = new Logger(source);
            const string message = "Something happened.";

            //Act
            logger.LogInformation(message);

            var log = ((TestListener)source.Listeners["TestListener"]).Log;

            //Assert
            Assert.IsTrue(log.Contains("Information: 1"));
            Assert.IsTrue(log.Contains(message));
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void LogInformation_ShouldWriteToTraceListener_WithTimeoutException()
        {
            //Arrange
            var source = new TraceSource("SFA.FCT.Framework.LoggingSource");
            ILogger logger = new Logger(source);
            const string message = "Details about this timeout.";
            var e = new TimeoutException();

            //Act
            logger.LogInformation(e, message);

            var log = ((TestListener)source.Listeners["TestListener"]).Log;

            //Assert
            Assert.IsTrue(log.Contains("Information: 1"));
            Assert.IsTrue(log.Contains(message));
            Assert.IsTrue(log.Contains(e.Message));
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void LogInformation_ShouldWriteToTraceListener_WithTimeoutException_InnerException()
        {
            //Arrange
            TestListener.Reset();
            var source = new TraceSource("SFA.FCT.Framework.LoggingSource");
            ILogger logger = new Logger(source);
            const string message = "Details about this timeout.";
            var e = new Exception("Timeout.", new TimeoutException());

            //Act
            logger.LogInformation(e, message);

            var log = ((TestListener)source.Listeners["TestListener"]).Log;

            //Assert
            Assert.IsTrue(log.Contains("Information: 1"));
            Assert.IsTrue(log.Contains(message));
            Assert.IsTrue(log.Contains(e.Message));
            Assert.IsTrue(log.Contains(e.InnerException.Message));
            Assert.IsTrue(log.Contains("Timeout."));
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void LogVerbose_ShouldWriteToTraceListener()
        {
            //Arrange
            TestListener.Reset();
            var source = new TraceSource("SFA.FCT.Framework.LoggingSource");
            ILogger logger = new Logger(source);
            const string message = "Error ({0}), something went wrong.";

            //Act
            logger.LogVerbose(message, 2015);

            var log = ((TestListener)source.Listeners["TestListener"]).Log;

            //Assert
            Assert.IsTrue(log.Contains("Verbose: 1"));
            Assert.IsTrue(log.Contains("Error (2015), something went wrong."));
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void LogVerbose_ShouldWriteToTraceListener_WithInvalidOperationException()
        {
            //Arrange
            TestListener.Reset();
            var source = new TraceSource("SFA.FCT.Framework.LoggingSource");
            ILogger logger = new Logger(source);
            const string message = "Error ({0}), something went wrong.";
            var e = new InvalidOperationException();

            //Act
            logger.LogVerbose(e, message, 2015);

            var log = ((TestListener)source.Listeners["TestListener"]).Log;

            //Assert
            Assert.IsTrue(log.Contains("Verbose: 1"));
            Assert.IsTrue(log.Contains("Error (2015), something went wrong."));
            Assert.IsTrue(log.Contains(e.Message));
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void LogVerbose_ShouldWriteToTraceListener_WithInvalidOperationException_InnerException()
        {
            //Arrange
            TestListener.Reset();
            var source = new TraceSource("SFA.FCT.Framework.LoggingSource");
            ILogger logger = new Logger(source);
            const string message = "Error ({0}), something went wrong.";
            var e = new Exception("Invalid operation.", new InvalidOperationException());

            //Act
            logger.LogVerbose(e, message, 2015);

            var log = ((TestListener)source.Listeners["TestListener"]).Log;

            //Assert
            Assert.IsTrue(log.Contains("Verbose: 1"));
            Assert.IsTrue(log.Contains("Error (2015), something went wrong."));
            Assert.IsTrue(log.Contains(e.Message));
            Assert.IsTrue(log.Contains(e.InnerException.Message));
            Assert.IsTrue(log.Contains("Invalid operation."));
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void LogVerbose_ShouldWriteToBothTraceListeners_WithInvalidOperationException_InnerException_MultipleTraceSources()
        {
            //Arrange
            TestListener.Reset();
            var source = new TraceSource("SFA.FCT.Framework.LoggingSource");
            var source2 = new TraceSource("SFA.FCT.Framework.LoggingSource2");
            ILogger logger = new Logger(source);
            ILogger logger2 = new Logger(source2);
            const string message = "Error ({0}), something went wrong.";
            var e = new Exception("Invalid operation.", new InvalidOperationException());

            //Act
            logger.LogVerbose(e, message, 2015);
            logger2.LogVerbose(e, message, 2015);

            var log = ((TestListener)source.Listeners["TestListener"]).Log;
            var log2 = ((TestListener) source2.Listeners["TestListener"]).Log;

            //Assert
            Assert.IsTrue(log.Contains("Verbose: 1"));
            Assert.IsTrue(log.Contains("Error (2015), something went wrong."));
            Assert.IsTrue(log.Contains(e.Message));
            Assert.IsTrue(log.Contains(e.InnerException.Message));
            Assert.IsTrue(log.Contains("Invalid operation."));

            Assert.IsTrue(log2.Contains("Verbose: 1"));
            Assert.IsTrue(log2.Contains("Error (2015), something went wrong."));
            Assert.IsTrue(log2.Contains(e.Message));
            Assert.IsTrue(log2.Contains(e.InnerException.Message));
            Assert.IsTrue(log2.Contains("Invalid operation."));
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void LogWarning_ShouldWriteToTraceListener()
        {
            //Arrange
            TestListener.Reset();
            var source = new TraceSource("SFA.FCT.Framework.LoggingSource");
            ILogger logger = new Logger(source);
            const string message = "Warning!!!";

            //Act
            logger.LogWarning(message);

            var log = ((TestListener)source.Listeners["TestListener"]).Log;

            //Assert
            Assert.IsTrue(log.Contains("Warning: 1"));
            Assert.IsTrue(log.Contains(message));
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void LogWarning_ShouldWriteToTraceListener_WithWarningException()
        {
            //Arrange
            TestListener.Reset();
            var source = new TraceSource("SFA.FCT.Framework.LoggingSource");
            ILogger logger = new Logger(source);
            const string message = "Warning!!!";
            var e = new WarningException();

            //Act
            logger.LogWarning(e, message);

            var log = ((TestListener)source.Listeners["TestListener"]).Log;

            //Assert
            Assert.IsTrue(log.Contains("Warning: 1"));
            Assert.IsTrue(log.Contains(message));
            Assert.IsTrue(log.Contains(e.Message));
        }

        [TestMethod]
        [TestCategory("IntegrationTest")]
        public void LogWarning_ShouldWriteToTraceListener_WithWarningException_InnerException()
        {
            //Arrange
            TestListener.Reset();
            var source = new TraceSource("SFA.FCT.Framework.LoggingSource");
            ILogger logger = new Logger(source);
            const string message = "Warning!!!";
            var e = new Exception("!Warning!", new WarningException());

            //Act
            logger.LogWarning(e, message);

            var log = ((TestListener)source.Listeners["TestListener"]).Log;

            //Assert
            Assert.IsTrue(log.Contains("Warning: 1"));
            Assert.IsTrue(log.Contains(message));
            Assert.IsTrue(log.Contains(e.Message));
            Assert.IsTrue(log.Contains(e.InnerException.Message));
            Assert.IsTrue(log.Contains("!Warning!"));
        }
    }
}
