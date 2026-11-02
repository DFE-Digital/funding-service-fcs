namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.PaymentAggregated.Repositories
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using PaymentSchedule.PaymentAggregated.Repositories;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class FundingStreamPeriodRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodRepository_ShouldGetFsp()
        {
            // arrange
            IFundingStreamPeriodRepository repository = GetContainer().Resolve<IFundingStreamPeriodRepository>();

            // act
            EntityReference fsp = repository.GetFundingStreamPeriod("SSF1718");

            // assert
            Assert.IsNotNull(fsp);
        }

        private static IWindsorContainer GetContainer()
        {
            ILoggerFactory factory = new LoggerFactory();
            IWindsorContainer container = new WindsorContainer();
            container.Install(new PaymentSchedule.PaymentAggregated.WindsorInstaller(factory));
            container.BeginScope();

            return container;
        }
    }
}
