namespace OrganisationDomain.Web.Tests
{
    using System.Linq;
    using Castle.Core;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using Integration.DataStore;
    using Integration.DataStore.Model;
    using IoC;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.Framework.Logging.Bespoke;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class LocalOrganisationRetrieverTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void LocalOrganisationRetriever_ShouldResolve()
        {
            var retriever = GetContainer().Resolve<ILocalOrganisationRetriever>();

            Assert.IsNotNull(retriever);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LocalOrganisationRetriever_ShouldGetOrganisationFromLocalDb()
        {
            // arrange
            var retriever = GetContainer().Resolve<ILocalOrganisationRetriever>();
            var orgFromDb = GetFirstOrgFronDb();

            // act
            organisation organisationSchema = retriever.GetOrganisationFromLocalDb(orgFromDb.Ukprn);

            // assert
            Assert.AreEqual(orgFromDb.Ukprn.ToString(), organisationSchema.organisationIdentifiers.First(oi => oi.organisationIdentifierType == organisationIdentifierType.UKPROVIDERREFERENCENUMBER).organisationIdentifier);
        }

        private IWindsorContainer GetContainer()
        {
            Mock<ILoggerFactory> mockLoggerFactory = new Mock<ILoggerFactory>();
            mockLoggerFactory.Setup(f => f.CreateLogger(It.IsAny<string>())).Returns(Mock.Of<ILogger>());

            var container = new WindsorContainer();
            container.Kernel.ComponentModelCreated += model =>
            {
                if (model.LifestyleType == LifestyleType.Scoped)
                {
                    model.LifestyleType = LifestyleType.Scoped;
                }
            };
            container.Install(new WindsorInstaller(mockLoggerFactory.Object));
            container.BeginScope();

            return container;
        }

        private Organisation GetFirstOrgFronDb()
        {
            using (var context = new OrganisationDomainDbContext())
            {
                return context.Organisations.First();
            }
        }
    }
}
