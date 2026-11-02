namespace PaymentManagement.Calculation.Tests.Services
{
    using Calculation.Dtos;
    using Calculation.Repositories;
    using Calculation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    [TestClass]
    public class BehaviourFactoryUnitTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void BehaviourFactory_ShouldGetFinancialYearAllocationLevelBehaviour_WhenFinancialYearAndContractAllocation()
        {
            // arrange
            Mock<IPolicyFundingStreamPeriodRepository> repositoryMock = new Mock<IPolicyFundingStreamPeriodRepository>();
            repositoryMock.Setup(r => r.GetFspCalcConfigInfo(It.IsAny<string>(), It.IsAny<Period>(), It.IsAny<ConnectionInfo>()))
                .Returns(new FspCalcConfigInfo( PaymentMethod.PayOnActuals, PaymentCappingPeriodType.FinancialYear,
                    PaymentCappingLevelType.ContractAllocation, false, null, null, null));

            BehaviourFactory behaviourFactory = new BehaviourFactory(repositoryMock.Object);

            // act
            var behaviourOption = behaviourFactory.GetBehaviour(It.IsAny<string>(), It.IsAny<Period>(), It.IsAny<ConnectionInfo>());

            // assert
            behaviourOption.Match(
                some: b =>
                {
                    Assert.AreEqual(b.CalculateCappingAmount.Method.DeclaringType.Name, "FinancialYearAllocationLevelBehaviour");
                },
                none:() => Assert.Fail("The FSP should return a behaviour"));

        }
    }
}
