using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Framework.Logging.Interfaces;
using SFA.FCT.Framework.TestHelpers;

namespace SFA.FCT.Framework.Logging.Tests
{
    /// <summary>
    /// Summary description for EntLibLogger
    /// </summary>
    [TestClass]
    public class EntLibLoggerTests
    {
        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        #region Log Tests
        //[TestMethod]
        //[TestCategory("Unit Test")]
        //public void Log_GivenAMessageWithNoLevel_ShouldWriteToConfiguredListenerWithVerboseSeverity()
        //{
        //    //Arrange
        //    FakeTraceListener.Reset();
        //    IEntlibLogger logger = new EntLibLogger();
        //    string logMessage= "Test Exception";
            
        //    //Act
        //    logger.Log(logMessage);

        //    //Assert
        //    var entry = FakeTraceListener.GetLogEntries()[0];
        //    Assert.IsTrue(entry.Message == logMessage && entry.LoggedSeverity=="Verbose", "Log didn't set the message with verbose.");
        //}

        //[TestMethod]
        //[TestCategory("Unit Test")]
        //public void Log_GivenAMessageWithInfoLevel_ShouldWriteToConfiguredListenerWithInformationSeverity()
        //{
        //    //Arrange
        //    FakeTraceListener.Reset();
        //    IEntlibLogger logger = new EntLibLogger();
        //    string logMessage = "Test Exception";

        //    //Act
        //    logger.Log(logMessage,LoggingLevel.Info);

        //    //Assert
        //    var entry = FakeTraceListener.GetLogEntries()[0];
        //    Assert.IsTrue(entry.Message == logMessage && entry.LoggedSeverity == "Information", "Log didn't set the message with Information.");
        //}

        //[TestMethod]
        //[TestCategory("Unit Test")]
        //public void Log_GivenAMessageWithWarnLevel_ShouldWriteToConfiguredListenerWithWarnningSeverity()
        //{
        //    //Arrange
        //    FakeTraceListener.Reset();
        //    IEntlibLogger logger = new EntLibLogger();
        //    string logMessage = "Test Exception";

        //    //Act
        //    logger.Log(logMessage, LoggingLevel.Warn);

        //    //Assert
        //    var entry = FakeTraceListener.GetLogEntries()[0];
        //    Assert.IsTrue(entry.Message == logMessage && entry.LoggedSeverity == "Warning", "Log didn't set the message with Warning.");
        //}

        //[TestMethod]
        //[TestCategory("Unit Test")]
        //public void Log_GivenAMessageWithErrorLevel_ShouldWriteToConfiguredListenerWithErrorSeverity()
        //{
        //    //Arrange
        //    FakeTraceListener.Reset();
        //    IEntlibLogger logger = new EntLibLogger();
        //    string logMessage = "Test Exception";

        //    //Act
        //    logger.Log(logMessage, LoggingLevel.Error);

        //    //Assert
        //    var entry = FakeTraceListener.GetLogEntries()[0];
        //    Assert.IsTrue(entry.Message == logMessage && entry.LoggedSeverity == "Error", "Log didn't set the message with Error.");
        //}

        //[TestMethod]
        //[TestCategory("Unit Test")]
        //public void Log_GivenAMessageWithCriticalLevel_ShouldWriteToConfiguredListenerWithCriticalSeverity()
        //{
        //    //Arrange
        //    FakeTraceListener.Reset();
        //    IEntlibLogger logger = new EntLibLogger();
        //    string logMessage = "Test Exception";

        //    //Act
        //    logger.Log(logMessage, LoggingLevel.Critical);

        //    //Assert
        //    var entry = FakeTraceListener.GetLogEntries()[0];
        //    Assert.IsTrue(entry.Message == logMessage && entry.LoggedSeverity == "Critical", "Log didn't set the message with Critical.");
        //}
        #endregion
    }
}
