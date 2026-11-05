namespace ContractCreateDomain.Endpoint.Tests.UpdateContract
{
    using Moq;
    using Microsoft.Xrm.Sdk;
    using System.Configuration;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.UpdateContract;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class UpdateDraftContractSagaTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UpdateDraftContractSaga_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new ContractCreateDomain.Endpoint.WindsorInstallerForSagas(new LoggerFactory()))
                .Register(Component.For<IOrganizationService>().Instance(Mock.Of<IOrganizationService>()).Named("OrganizationServiceMock").IsDefault())
                .Register(Component.For<UpdateDraftContractSaga>());

            container.BeginScope();
            ConfigurationManager.AppSettings["ContractOperationSagaTimeoutInMinutes"] = "1";

            // act, assert
            container.Resolve<UpdateDraftContractSaga>();
        }
    }
}
