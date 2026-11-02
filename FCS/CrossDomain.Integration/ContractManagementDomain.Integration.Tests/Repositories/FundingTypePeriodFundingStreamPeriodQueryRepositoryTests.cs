namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractCreateDomain.Integration.ContractRequest.IoC;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class FundingTypePeriodFundingStreamPeriodQueryRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodFundingStreamPeriodQueryRepository_GetByFundingType_ShouldReturnCorrectEntities()
        {
            // arrange
            var repository = new FundingTypePeriodFundingStreamPeriodQueryRepository(
                new ContractManagementDbContext());

            const string fundingTypeCode = "24+LOANS";

            // act
            IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod> entities = repository.GetByFundingType(fundingTypeCode);

            // assert
            Assert.IsNotNull(entities, "Returned value is null.");
            Assert.IsTrue(entities.All(ftpfsp => ftpfsp.FundingTypeCode == fundingTypeCode), "Incorrect FundingTypeCode value returned.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodFundingStreamPeriodQueryRepository_ShouldResolveFromContractCreateEndpointContainer()
        {
            // arrange
            Mock<ILoggerFactory> loggerFactoryMock = new Mock<ILoggerFactory>();
            loggerFactoryMock.Setup(m => m.CreateLogger(It.IsAny<string>())).Returns(Mock.Of<ILogger>());
            using (IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(loggerFactoryMock.Object)))
            {
                using (container.BeginScope())
                {
                    // act
                    container.Resolve<IFundingTypePeriodFundingStreamPeriodQueryRepository>();
                }
            }
        }
    }
}
