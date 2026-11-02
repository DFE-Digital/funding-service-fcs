namespace SFA.FCT.FundingPolicy.Test.UnitTests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NSB;
    using Framework.Logging.Interfaces;

    [TestClass]
    public class FundingPolicyControllerTests
    {
        private const string UnitTestCategory = "UnitTest";
        private FundingPolicyController _controller;

        [TestInitialize]
        public void StartUp()
        {
            //_contractsManagerMock = new Mock<IContractsManager>();
            //_contractsManagerMock.Setup(
            //    x => x.GetCorporateContract(It.Is<string>(s => s.Equals("Valid")), It.IsAny<string>()))
            //    .Returns(new contract());
            //_contractsManagerMock.Setup(
            //    x => x.GetCorporateContract(It.Is<string>(s => s.Equals("Invalid")), It.IsAny<string>()))
            //    .Returns<contract>(null);

            _controller = new ContractManagementController();
            _controller.ContractManager = _contractsManagerMock.Object;

            _loggerMock = new Mock<ILoggerFactory>();
        }

        [TestMethod, TestCategory("Integration")]
        public void EnsureTheControllerExecutes()
        {
            // Arrange
            //Act
            var result = _controller.Gte("Valid", "Valid");
            //Assert
            Assert.AreEqual(typeof(OkResult), result.GetType());
        }

        [TestMethod, TestCategory(UnitTestCategory), ExpectedException(typeof(DataException), "No Contract found with a contract number of Invalid and a master contract number of Invalid")]
        public void EnsureTheControllerThrowsADataException()
        {
            //Act
            var result = _controller.Put("Invalid", "Invalid");
        }
    }
}
