using ContractCreateDomain.Endpoint.Extensions;

namespace ContractCreateDomain.Tests.Integration_Tests
{
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using OrganisationDomain.Integration.DataStore;
    using OrganisationDomain.Integration.DataStore.Model;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;

    [TestClass]
    public class OrganisationServiceTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void OrganisationService_ShouldReturnAnOrganisationForAnActiveUkprn()
        {
            const int testUkprn = 12345678;

            // arrange
            using (OrganisationDomainDbContext context = new OrganisationDomainDbContext())
            {
                context.Organisations.RemoveWhere(o => o.Ukprn == testUkprn);
                context.Organisations.RemoveWhere(o => o.Upin == testUkprn);
                context.Organisations.Add(new Organisation
                {
                    Ukprn = testUkprn,
                    Upin = testUkprn,
                    TradingName = testUkprn.ToString()
                });
                context.SaveChanges();
            }

            IWindsorContainer container = new WindsorContainer()
                .Install(new ContractCreateDomain.Endpoint.WindsorInstallerForSagas(new LoggerFactory()))
                .Register(Component.For<ILogger>().Instance(Mock.Of<ILogger>()).IsDefault());
            container.BeginScope();

            IOrganisationService organisationService = container.Resolve<IOrganisationService>();

            // act
            organisation organisation = organisationService.GetOrganisationForUkprn(testUkprn);

            // assert
            Assert.IsNotNull(organisation, "The service has not returned the org");
            Assert.IsTrue(organisation.organisationIdentifiers.Any(oi => oi.organisationIdentifierType == organisationIdentifierType.UPIN), "The service has not returned the UPIN");

        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void OrganisationService_CheckContentsOfGetProvidersByUKPRNXmlResponse()
        {
            const int testUkprn = 6379217;

            IWindsorContainer container = new WindsorContainer()
                .Install(new ContractCreateDomain.Endpoint.WindsorInstallerForSagas(new LoggerFactory()))
                .Register(Component.For<ILogger>().Instance(Mock.Of<ILogger>()).IsDefault());
            container.BeginScope();

            IOrganisationService organisationService = container.Resolve<IOrganisationService>();

            // act
            organisation organisation = organisationService.GetOrganisationForUkprn(testUkprn);

            // assert
            var contractOrganisation = organisation.ToContractOrganisation();
            var t = 1;
        }
    }
}
