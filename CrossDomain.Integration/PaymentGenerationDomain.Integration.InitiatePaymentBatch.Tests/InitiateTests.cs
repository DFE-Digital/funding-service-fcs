namespace PaymentGenerationDomain.Integration.InitiatePaymentBatch.Tests
{
    using System;
    using Moq;
    using NServiceBus;
    using Common.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    /// <summary>
    /// Summary description for InitiateTests
    /// </summary>
    [TestClass]
    public class InitiateTests
    {
        public InitiateTests()
        {
            // TODO: Add constructor logic here
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

        [TestMethod,TestCategory("UnitTest")]
        public void Start_ShouldSendInitiateBatchCommandMessage()
        {
            var busMock = new Mock<IBus>();
            var loggerMock = new Mock<ILogger>();
            var initiator = new Initiate()
            {
                Bus = busMock.Object,
                Logger = loggerMock.Object
            };
            var result = initiator.Start();
            busMock.Verify(x => x.Send(It.IsAny<InitiatePaymentBatchCommand>()), Times.Once(), "Start didn't sen the initiate batch command message");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Start_ShouldReturnTrue_IfNoErrorThrown()
        {
            var busMock = new Mock<IBus>();
            var loggerMock = new Mock<ILogger>();
            var initiator = new Initiate()
            {
                Bus = busMock.Object,
                Logger = loggerMock.Object
            };
            var result = initiator.Start();
            Assert.IsTrue(result, "Start did not return true");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Start_ShouldReturnFalse_IfErrorIsThrown()
        {
            var busMock = new Mock<IBus>();
            busMock.Setup(x => x.Send(It.IsAny<InitiatePaymentBatchCommand>())).Throws(new Exception("Test Exception"));
            var loggerMock = new Mock<ILogger>();
            var initiator = new Initiate()
            {
                Bus = busMock.Object,
                Logger = loggerMock.Object
            };
            var result = initiator.Start();
            Assert.IsFalse(result, "Start did not return false");
        }
    }
}
