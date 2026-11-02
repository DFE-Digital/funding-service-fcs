namespace ContractCreateDomain.Endpoint.Tests.XrmService
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.XrmService;
    using Microsoft.VisualStudio.TestTools.UnitTesting;    
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class AmendContractHandlerTests
    {
     
        [TestMethod, TestCategory("UnitTest")]
        public void AmendContractHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<AmendContractHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<AmendContractHandler>();
        }   
    }
}
