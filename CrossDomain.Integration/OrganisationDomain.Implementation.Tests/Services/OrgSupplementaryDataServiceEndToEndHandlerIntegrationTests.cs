namespace OrganisationDomain.Implementation.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using Implementation.Services;
    using Integration.DataStore;
    using Integration.DataStore.Model;
    using Integration.DataStore.Repositories;
    using Integration.MainEndpoint;
    using Integration.MainEndpoint.Handlers;
    using Integration.MainEndpoint.Ioc;
    using Integration.Messages.Commands;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using NServiceBus.Testing;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;

    [TestClass]
    public class OrgSupplementaryDataServiceEndToEndHandlerIntegrationTests
    {
        private Mock<IOrgSupplementaryDataService> _orgSupplementaryDataServiceMock;
        private InitiateOrgSupplementaryDataPopulationCommandHandler _initiateOrgSupplementaryDataPopulationCommandHandler;
        private PopulateSupplementaryDataForUkprnBatchCommandHandler _createPopulateSupplementaryDataForUkprnBatchCommandHandler;

        [TestInitialize]
        public void TestInitialize()
        {
            _orgSupplementaryDataServiceMock = new Mock<IOrgSupplementaryDataService>();

            _orgSupplementaryDataServiceMock
                .Setup(m => m.GetDataForUkprn(It.IsAny<int>()))
                .Returns((int ukprn) =>
                    Task.FromResult(
                        new OrgSupplementaryDataServiceResult(
                            $"COMPANY-{ukprn}",
                            $"CH-{ukprn}",
                            true)
                        {
                            LegalAddress = new OrgSupplementaryDataServiceResult.Address
                            {
                                Line1 = $"LINE1-{ukprn}",
                                Line2 = $"LINE2-{ukprn}",
                                Line3 = $"LINE3-{ukprn}",
                                Line4 = $"LINE4-{ukprn}",
                                Town = $"TOWN-{ukprn}",
                                County = $"COUNTY-{ukprn}",
                                Postcode = $"PC-{ukprn}"
                            }
                        }));


            _initiateOrgSupplementaryDataPopulationCommandHandler = CreateInitiateOrgSupplementaryDataPopulationCommandHandler();
            _createPopulateSupplementaryDataForUkprnBatchCommandHandler = CreatePopulateSupplementaryDataForUkprnBatchCommandHandler();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void OrgSupplementaryPopulationService_ShouldUpdateOrganisationsCorrectlyWhenRunInPipelineOfHandlers()
        {
            List<int> ukprns = Enumerable.Range(10001, 25).ToList();

            // arrange
            SetAllOrganisationsToUkrlpCalledSuccessfully();
            DeleteOrganisations(ukprns);
            CreateOrganisations(ukprns);

            var context = new TestableMessageHandlerContext();

            // act
            _initiateOrgSupplementaryDataPopulationCommandHandler.Handle(new InitiateOrgSupplementaryDataPopulationCommand(), context).Wait();
            context.SentMessages
                .Select(sm => sm.Message)
                .OfType<PopulateSupplementaryDataForUkprnBatchCommand>()
                .ToList()
                .ForEach(c => _createPopulateSupplementaryDataForUkprnBatchCommandHandler.Handle(c, new TestableMessageHandlerContext()).Wait());

            // assert
            using (OrganisationDomainDbContext organisationDomainDbContext = new OrganisationDomainDbContext())
            {
                ukprns.ForEach(ukprn =>
                {
                    Organisation paasOrganisation = organisationDomainDbContext.Organisations.Single(o => o.Ukprn == ukprn);
                    Assert.AreEqual(true, paasOrganisation.HasUkrlpBeenCalledSuccessfully, $"HasUkrlpBeenCalledSuccessfully has not been updated for UKPRN {ukprn}");
                    Assert.AreEqual($"COMPANY-{ukprn}", paasOrganisation.CompanyRegistrationNumber, $"CompanyRegistrationNumber has not been updated successfully for UKPRN {ukprn}");
                    Assert.AreEqual($"CH-{ukprn}", paasOrganisation.CharityNumber, $"CharityNumber has not been updated successfully for UKPRN {ukprn}");
                    Assert.AreEqual($"LINE1-{ukprn}", paasOrganisation.Address.Line1, $"Address Line1 has not been updated successfully for UKPRN {ukprn}");
                    Assert.AreEqual($"LINE2-{ukprn}", paasOrganisation.Address.Line2, $"Address Line2 has not been updated successfully for UKPRN {ukprn}");
                    Assert.AreEqual($"LINE3-{ukprn}", paasOrganisation.Address.Line3, $"Address Line3 has not been updated successfully for UKPRN {ukprn}");
                    Assert.AreEqual($"LINE4-{ukprn}", paasOrganisation.Address.Line4, $"Address Line4 has not been updated successfully for UKPRN {ukprn}");
                    Assert.AreEqual($"TOWN-{ukprn}", paasOrganisation.Address.Town, $"Address Town has not been updated successfully for UKPRN {ukprn}");
                    Assert.AreEqual($"COUNTY-{ukprn}", paasOrganisation.Address.County, $"Address County has not been updated successfully for UKPRN {ukprn}");
                    Assert.AreEqual($"PC-{ukprn}", paasOrganisation.Address.Postcode, $"Address Postcode has not been updated successfully for UKPRN {ukprn}");
                });
            }
        }

        private static InitiateOrgSupplementaryDataPopulationCommandHandler CreateInitiateOrgSupplementaryDataPopulationCommandHandler()
        {
            IWindsorContainer container = new WindsorContainer().Install(new ComponentInstaller(new LoggerFactory()));
            container.BeginScope();

            return new InitiateOrgSupplementaryDataPopulationCommandHandler(container.Resolve<IOrganisationRepository>(),  Mock.Of<ILogger>());
        }

        private PopulateSupplementaryDataForUkprnBatchCommandHandler CreatePopulateSupplementaryDataForUkprnBatchCommandHandler()
        {
            IWindsorContainer container = new WindsorContainer().Install(new ComponentInstaller(new LoggerFactory()));
            container.BeginScope();

            return new PopulateSupplementaryDataForUkprnBatchCommandHandler(
                Mock.Of<ILogger>(),
                new OrgSupplementaryPopulationService(Mock.Of<ILogger>(), _orgSupplementaryDataServiceMock.Object, container.Resolve<IOrganisationRepository>()));
        }

        private static void SetAllOrganisationsToUkrlpCalledSuccessfully()
        {
            using (OrganisationDomainDbContext context = new OrganisationDomainDbContext())
            {
                context.Database.ExecuteSqlCommand(@"UPDATE Organisation.Organisation SET HasUkrlpBeenCalledSuccessfully = 1");
            }
        }

        private static void DeleteOrganisations(IEnumerable<int> ukprns)
        {
            using (OrganisationDomainDbContext organisationDomainDbContext = new OrganisationDomainDbContext())
            {
                organisationDomainDbContext.Organisations.RemoveWhere(o => ukprns.Contains(o.Ukprn));

                organisationDomainDbContext.SaveChanges();
            }
        }

        private static void CreateOrganisations(IEnumerable<int> ukprns)
        {
            using (OrganisationDomainDbContext organisationDomainDbContext = new OrganisationDomainDbContext())
            {
                ukprns.ForEach(ukprn => 
                {
                    organisationDomainDbContext.Organisations.Add(new Organisation
                    {
                        Ukprn = ukprn,
                        Upin = ukprn,
                        SequenceNumber = 0,
                        TradingName = ukprn.ToString(),
                        CompanyRegistrationNumber = null,
                        HasUkrlpBeenCalledSuccessfully = false
                    });
                });

                organisationDomainDbContext.SaveChanges();
            }
        }
    }
}
