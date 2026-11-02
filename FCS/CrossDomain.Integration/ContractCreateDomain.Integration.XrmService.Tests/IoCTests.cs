namespace ContractCreateDomain.Integration.XrmService.Tests
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Integration.XrmService;
    using SFA.FCT.ContractCreateDomain.Integration.XrmService.IoC;
    using SFA.FCT.ContractCreateDomain.Integration.XrmService.Repositories;

    [TestClass]
    public class IoCTests
    {
        [TestMethod,TestCategory("UnitTest")]
        public void IXrmAllocationEvidenceManager_ShouldResolve()
        {
            IWindsorContainer windsorContainer = GetContainer();
            IXrmAllocationEvidenceManager evidenceManager = windsorContainer.Resolve<IXrmAllocationEvidenceManager>();
            Assert.IsNotNull(evidenceManager);
        }

        private IWindsorContainer GetContainer()
        {
            IWindsorContainer container = new WindsorContainer();
            WindsorInstaller windsorInstaller = new WindsorInstaller();
            container.Install(windsorInstaller);
            container.BeginScope();
            return container;
        }
    }
}
