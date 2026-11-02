namespace OrganisationDomain.Implementation.Tests.Services
{
    using System.Collections.Generic;
    using System.Data.Entity.Validation;
    using System.Linq;
    using System.Threading.Tasks;
    using Implementation.Services;
    using Integration.DataStore;
    using Integration.DataStore.Model;
    using Integration.DataStore.Repositories;
    using Integration.Entities;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;

    [TestClass]
    public class OrgSupplementaryPopulationServiceTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public async Task OrgSupplementaryPopulationService_ShouldUpdateAllTestOrganisationsWhenOrgSupplementaryDataServiceGetDataForUkprnIsSuccessfulIsTrueForAllTestOrganisations()
        {
            // arrange
            var orgSupplementaryDataServiceMock = new Mock<IOrgSupplementaryDataService>();
            const string companyRegNumber15 = "TestCompanyRegNumber15";
            const string companyRegNumber16 = "TestCompanyRegNumber16";

            const string charityNumber15 = "1111111";
            const string charityNumber16 = "2222222";

            orgSupplementaryDataServiceMock.Setup(osds => osds.GetDataForUkprn(15))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult(companyRegNumber15, charityNumber15, true));

            orgSupplementaryDataServiceMock.Setup(osds => osds.GetDataForUkprn(16))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult(companyRegNumber16, charityNumber16, true));

            IReadOnlyCollection<int> ukprnsToTest = new List<int> {15, 16};
            DeleteOrgsForUkrpns(ukprnsToTest);
            CreateOrgs(ukprnsToTest);

            using (var context = new OrganisationDomainDbContext())
            {
                IOrgSupplementaryPopulationService orgSupplementaryPopulationService =
                    new OrgSupplementaryPopulationService(
                        Mock.Of<ILogger>(),
                        orgSupplementaryDataServiceMock.Object,
                        new OrganisationRepository(context));

                // act
                var data = await orgSupplementaryPopulationService.PopulateOrgSupplementaryData(ukprnsToTest);
            }

            // assert            
            using (var context = new OrganisationDomainDbContext())
            {
                Organisation org15 = context.Organisations.Single(o => o.Ukprn == 15);
                Assert.AreEqual(companyRegNumber15, org15.CompanyRegistrationNumber, "The company reg number is incorrect for ukprn 15");
                Assert.IsTrue(org15.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully was not set to true for ukprn 15");
                Assert.AreEqual(charityNumber15, org15.CharityNumber, "The charity number is incorrect for ukprn 15");

                Organisation org16 = context.Organisations.Single(o => o.Ukprn == 16);
                Assert.AreEqual(companyRegNumber16, org16.CompanyRegistrationNumber, "The company reg number is incorrect for ukprn 16");
                Assert.IsTrue(org16.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully was not set to true for ukprn 16");
                Assert.AreEqual(charityNumber16, org16.CharityNumber, "The charity number is incorrect for ukprn 16");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task OrgSupplementaryPopulationService_ShouldUpdateNoTestOrganisationsWhenOrgSupplementaryDataServiceGetDataForUkprnIsSuccessfulIsFalseForAllTestOrganisations()
        {
            // arrange
            var orgSupplementaryDataServiceMock = new Mock<IOrgSupplementaryDataService>();
            const string companyRegNumber15 = "TestCompanyRegNumber15";
            const string companyRegNumber16 = "TestCompanyRegNumber16";

            const string charityNumber15 = "1111111";
            const string charityNumber16 = "2222222";

            orgSupplementaryDataServiceMock.Setup(osds => osds.GetDataForUkprn(15))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult(companyRegNumber15, charityNumber15, false));

            orgSupplementaryDataServiceMock.Setup(osds => osds.GetDataForUkprn(16))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult(companyRegNumber16, charityNumber16, false));

            IReadOnlyCollection<int> ukprnsToTest = new List<int> { 15, 16 };
            DeleteOrgsForUkrpns(ukprnsToTest);
            CreateOrgs(ukprnsToTest);

            using (var context = new OrganisationDomainDbContext())
            {
                IOrgSupplementaryPopulationService orgSupplementaryPopulationService =
                    new OrgSupplementaryPopulationService(
                        Mock.Of<ILogger>(),
                        orgSupplementaryDataServiceMock.Object,
                        new OrganisationRepository(context));

                // act
               await orgSupplementaryPopulationService.PopulateOrgSupplementaryData(ukprnsToTest);
            }

            // assert            
            using (var context = new OrganisationDomainDbContext())
            {
                Organisation org15 = context.Organisations.Single(o => o.Ukprn == 15);
                Assert.IsNull(org15.CompanyRegistrationNumber, "The company reg number was incorrectly updated for ukprn 15");
                Assert.IsFalse(org15.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully should remain as false for ukprn 15");
                Assert.IsNull(org15.CharityNumber, "The charity number was incorrectly updated for ukprn 15");

                Organisation org16 = context.Organisations.Single(o => o.Ukprn == 16);
                Assert.IsNull(org16.CompanyRegistrationNumber, "The company reg number was incorrectly updated for ukprn 16");
                Assert.IsFalse(org16.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully should remain as false for ukprn 16");
                Assert.IsNull(org16.CharityNumber, "The charity number was incorrectly updated for ukprn 16");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public async void OrgSupplementaryPopulationService_ShouldCallDelegateForEachOrgsWithSupplementaryData()
        {
            // arrange
            var orgSupplementaryDataServiceMock = new Mock<IOrgSupplementaryDataService>();
            const string companyRegNumber15 = "TestCompanyRegNumber15";
            const string companyRegNumber16 = "TestCompanyRegNumber16";

            const string charityNumber15 = "1111111";
            const string charityNumber16 = "2222222";

            orgSupplementaryDataServiceMock.Setup(osds => osds.GetDataForUkprn(15))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult(companyRegNumber15, charityNumber15, false));

            orgSupplementaryDataServiceMock.Setup(osds => osds.GetDataForUkprn(16))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult(companyRegNumber16, charityNumber16, true));

            var repositoryMock = new Mock<IOrganisationRepository>();
            repositoryMock.Setup(m => m.GetOrganisations(It.IsAny<IReadOnlyCollection<int>>()))
                          .Returns(new List<Organisation>
                          {
                              new Organisation {Ukprn = 15},
                              new Organisation {Ukprn = 16}
                          });

            IOrgSupplementaryPopulationService service =
                new OrgSupplementaryPopulationService(
                    Mock.Of<ILogger>(),
                    orgSupplementaryDataServiceMock.Object, repositoryMock.Object);

            IReadOnlyCollection<OrgSupplementaryDataExtended> results;

            // act
            results = await service.PopulateOrgSupplementaryData(new List<int> { 15, 16 });

            var resultsArray = results.ToArray();
            // assert
            Assert.AreEqual(1, results.Count, "Incorrect number of results sent in delegate");
            Assert.AreEqual(16, resultsArray[0].Ukprn, "Ukprn was incorrect");
            Assert.AreEqual(companyRegNumber16, resultsArray[0].CompanyNumber, "Company number was not correct");
            Assert.AreEqual(charityNumber16, resultsArray[0].CharityNumber, "Charity number was incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        [ExpectedException(typeof(DbEntityValidationException))]
        public void OrgSupplementaryPopulationService_ShouldCauseAnDbEntityValidationExceptionWhenOrgSupplementaryDataServiceGetDataForUkprnReturnsACharityNumberThatIsTooLarge()
        {
            // arrange
            var orgSupplementaryDataServiceMock = new Mock<IOrgSupplementaryDataService>();
            const string companyRegNumber16 = "TestCompanyRegNumber16";

            const string charityNumber16 = "charityNumberTooLarge";

            orgSupplementaryDataServiceMock.Setup(osds => osds.GetDataForUkprn(16))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult(companyRegNumber16, charityNumber16, true));

            IReadOnlyCollection<int> ukprnsToTest = new List<int> { 16 };
            DeleteOrgsForUkrpns(ukprnsToTest);
            CreateOrgs(ukprnsToTest);

            using (var context = new OrganisationDomainDbContext())
            {
                IOrgSupplementaryPopulationService orgSupplementaryPopulationService =
                    new OrgSupplementaryPopulationService(
                        Mock.Of<ILogger>(),
                        orgSupplementaryDataServiceMock.Object,
                        new OrganisationRepository(context));

                // act
                // Assert
                orgSupplementaryPopulationService.PopulateOrgSupplementaryData(ukprnsToTest);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task OrgSupplementaryPopulationService_ShouldStoreAndPublishNewAddressInformation()
        {
            const int ukprn = 12345678;
            OrgSupplementaryDataExtended publishedData = null;

            // arrange
            using (OrganisationDomainDbContext context = new OrganisationDomainDbContext())
            {
                context.Organisations.RemoveWhere(o => o.Ukprn == ukprn || o.Upin == ukprn);
                context.Organisations.Add(new Organisation
                {
                    Ukprn = ukprn,
                    Upin = ukprn,
                    TradingName = "Test",
                    Address = new Address
                    {
                        Line1 = "Old Line1",
                        Line2 = "Old Line2",
                        Line3 = "Old Line3",
                        Line4 = "Old Line4",
                        Town = "Old Town",
                        County = "Old County",
                        Postcode = "Old PC"
                    }
                });
                context.SaveChanges();
            }

            Mock<IOrgSupplementaryDataService> orgSupplementaryDataServiceMock = new Mock<IOrgSupplementaryDataService>();
            orgSupplementaryDataServiceMock
                .Setup(m => m.GetDataForUkprn(It.IsAny<int>()))
                .ReturnsAsync(new OrgSupplementaryDataServiceResult("Company no", true)
                {
                    LegalAddress = new OrgSupplementaryDataServiceResult.Address
                    {
                        Line1 = "New Line1",
                        Line2 = "New Line2",
                        Line3 = "New Line3",
                        Line4 = "New Line4",
                        Town = "New Town",
                        County = "New County",
                        Postcode = "New PC"
                    }
                });
            
            // act
            using (OrganisationDomainDbContext context = new OrganisationDomainDbContext())
            {
                OrgSupplementaryPopulationService orgSupplementaryPopulationService = new OrgSupplementaryPopulationService(
                    Mock.Of<ILogger>(),
                    orgSupplementaryDataServiceMock.Object,
                    new OrganisationRepository(context));

                publishedData = orgSupplementaryPopulationService.PopulateOrgSupplementaryData(new[] { ukprn }).Result.First();
            }

            // assert
            using (OrganisationDomainDbContext context = new OrganisationDomainDbContext())
            {
                Organisation storedOrganisation = context.Organisations.Single(o => o.Ukprn == ukprn);

                Assert.AreEqual("New Line1", storedOrganisation.Address.Line1, "Address Line 1 was not updated");
                Assert.AreEqual("New Line2", storedOrganisation.Address.Line2, "Address Line 2 was not updated");
                Assert.AreEqual("New Line3", storedOrganisation.Address.Line3, "Address Line 3 was not updated");
                Assert.AreEqual("New Line4", storedOrganisation.Address.Line4, "Address Line 4 was not updated");
                Assert.AreEqual("New Town", storedOrganisation.Address.Town, "Address Town was not updated");
                Assert.AreEqual("New County", storedOrganisation.Address.County, "Address County was not updated");
                Assert.AreEqual("New PC", storedOrganisation.Address.Postcode, "Address Postcode was not updated");
            }

            Assert.IsNotNull(publishedData, "No data published");
            Assert.AreEqual("New Line1", publishedData.LegalAddress.Line1, "Updated Address Line 1 was not published");
            Assert.AreEqual("New Line2", publishedData.LegalAddress.Line2, "Updated Address Line 2 was not published");
            Assert.AreEqual("New Line3", publishedData.LegalAddress.Line3, "Updated Address Line 3 was not published");
            Assert.AreEqual("New Line4", publishedData.LegalAddress.Line4, "Updated Address Line 4 was not published");
            Assert.AreEqual("New Town", publishedData.LegalAddress.Town, "Updated Address Town was not published");
            Assert.AreEqual("New County", publishedData.LegalAddress.County, "Updated Address County was not published");
            Assert.AreEqual("New PC", publishedData.LegalAddress.Postcode, "Updated Address Postcode was not published");
        }

        private void DeleteOrgsForUkrpns(IEnumerable<int> ukprnsToTest)
        {
            using (var context = new OrganisationDomainDbContext())
            {
                context.Organisations.Where(o => ukprnsToTest.Contains(o.Ukprn))
                    .ForEach(o => context.Organisations.Remove(o));

                context.SaveChanges();
            }
        }

        private void CreateOrgs(IEnumerable<int> ukprnsToTest)
        {
            using (var context = new OrganisationDomainDbContext())
            {
                ukprnsToTest.ForEach(ukprn =>
                {
                    context.Organisations.Add(new Organisation
                    {
                        Ukprn = ukprn,
                        Upin = ukprn,
                        TradingName = ukprn.ToString(),
                    });
                });
                
                context.SaveChanges();
            }
        }

        private void DoNothing(OrgSupplementaryDataExtended data)
        {
        }
    }
}
