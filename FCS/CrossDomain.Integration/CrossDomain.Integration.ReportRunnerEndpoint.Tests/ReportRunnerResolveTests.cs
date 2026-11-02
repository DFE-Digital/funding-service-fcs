namespace CrossDomain.Integration.ReportRunnerEndpoint.Tests
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore;
    using SFA.FCT.Framework.Logging;
    using Ioc;

    [TestClass]
    public class ReportRunnerResolveTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ICdaReportFundingStreamPeriodQueryReporitory_ShouldResolve()
        {
            var repository = GetContainer().Resolve<ICdaReportFundingStreamPeriodQueryRepository>();

            Assert.IsNotNull(repository);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IOverrideDateDBContext_ShouldResolve()
        {
            var overrideDateDbContext = GetContainer().Resolve<IOverrideDateDBContext>();

            Assert.IsNotNull(overrideDateDbContext);
        }

        private IWindsorContainer GetContainer()
        {
            var container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory()));

            container.BeginScope();

            return container;
        }
    }
}
