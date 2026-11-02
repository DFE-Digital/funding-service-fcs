namespace OrganisationDomain.Integration.MainEndpoint.Tests
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Handlers;
    using Ioc;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class IocTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void InitiateOrgSupplementaryDataPopulationCommandHandler_ShouldResolve()
        {
            var handler = CreateContainer()
                .Register(Component.For<InitiateOrgSupplementaryDataPopulationCommandHandler>())
                .Resolve<InitiateOrgSupplementaryDataPopulationCommandHandler>();

            Assert.IsNotNull(handler);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PopulateSupplementaryDataForUkprnBatchCommandHandler_ShouldResolve()
        {
            var handler = CreateContainer()
                .Register(Component.For<PopulateSupplementaryDataForUkprnBatchCommandHandler>())
                .Resolve<PopulateSupplementaryDataForUkprnBatchCommandHandler>();

            Assert.IsNotNull(handler);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateSupplementaryDataChangesCommandHandler_ShouldResolve()
        {
            var handler = CreateContainer()
                .Register(Component.For<UpdateSupplementaryDataChangesCommandHandler>())
                .Resolve<UpdateSupplementaryDataChangesCommandHandler>();

            Assert.IsNotNull(handler);
        } 

        private IWindsorContainer CreateContainer()
        {
            ILoggerFactory loggerFactory = new LoggerFactory();

            IWindsorContainer container = Bootstrapper.CreateContainer(loggerFactory);

            container.BeginScope();

            return container;
        }
    }
}