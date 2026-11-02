using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Framework.ExceptionHandling.Interfaces;
using SFA.FCT.Framework.TestHelpers;

namespace SFA.FCT.Framework.ExceptionHandling.Tests
{
    /// <summary>
    /// Summary description for EntLibExceptionManagerTests
    /// </summary>
    [TestClass]
    public class EntLibExceptionManagerTests
    {
        public EntLibExceptionManagerTests()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

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

        [TestMethod, TestCategory("UnitTest")]
        public void Publish_GivenAnException_ShouldWriteToConfiguredListener()
        {
            //Arrange
            FakeTraceListener.Reset();
            
            IExceptionManager manager = new EntLibExceptionManager();
            string exceptionMessage = "Test Exception";
            ApplicationException testException = new ApplicationException(exceptionMessage);

            //Act
            manager.Publish(testException);

            //Assert
            var entries = FakeTraceListener.GetLogEntries();
            Assert.IsTrue(entries[0].Message.Contains(exceptionMessage), "Publish didn't record the exception.");
        }
    }
}
