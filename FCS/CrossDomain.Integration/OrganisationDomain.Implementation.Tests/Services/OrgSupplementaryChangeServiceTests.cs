namespace OrganisationDomain.Implementation.Tests.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Implementation.Services;
    using Integration.DataStore;
    using Integration.DataStore.Model;
    using Integration.DataStore.Repositories;
    using Integration.Entities;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class OrgSupplementaryChangeServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void OrgSupplementaryChangeService_ShouldProcessOnlyUkrlpChangesForWhichOrganisationsAreHeldInFcs()
        {
            // arrange
            var orgSupplementaryDataCollection = (new[]
                {
                    new OrgSupplementaryData(ukprn: 1, companyNumber: "COMPANY-1", charityNumber: "CHARITYNO1", address: new OrgSupplementaryAddress()),
                    new OrgSupplementaryData(ukprn: 2, companyNumber: "COMPANY-2", charityNumber: "CHARITYNO2", address: new OrgSupplementaryAddress()),
                    new OrgSupplementaryData(ukprn: 3, companyNumber: "COMPANY-3", charityNumber: "CHARITYNO3", address: new OrgSupplementaryAddress()),
                    new OrgSupplementaryData(ukprn: 4, companyNumber: "COMPANY-4", charityNumber: "CHARITYNO4", address: new OrgSupplementaryAddress()),
                    new OrgSupplementaryData(ukprn: 5, companyNumber: "COMPANY-5", charityNumber: "CHARITYNO5", address: new OrgSupplementaryAddress())
                });

            var organisationRepositoryMock = new Mock<IOrganisationRepository>();
            organisationRepositoryMock
                .Setup(m => m.GetOrganisations(It.IsAny<IReadOnlyCollection<int>>()))
                .Returns(new[]
                {
                    new Organisation {Ukprn = 1},
                    new Organisation {Ukprn = 2}
                });

            var publishingActionMock = new Mock<Action<OrgChangedData>>();
            var orgSupplementaryChangeService = new OrgSupplementaryChangeService(Mock.Of<ILogger>(), organisationRepositoryMock.Object);

            // act
            var orgSupplementaryDataList = orgSupplementaryChangeService.ChangeOrgSupplementaryData(orgSupplementaryDataCollection);

            // assert
            Assert.AreEqual(2, orgSupplementaryDataList.Count, "The number returned is not correct");
            Assert.AreEqual(1, orgSupplementaryDataList.Count(d => d.OrgSupplementaryData.Ukprn == 1), "The number returned is not correct for ukprn 1");
            Assert.AreEqual(1, orgSupplementaryDataList.Count(d => d.OrgSupplementaryData.Ukprn == 2), "The number returned is not correct for ukprn 2");
            //publishingActionMock.Verify(m => m(It.IsAny<OrgChangedData>()), Times.Exactly(2));
            //publishingActionMock.Verify(m => m(It.Is<OrgChangedData>(data => data.OrgSupplementaryData.Ukprn == 1)), Times.Once);
            //publishingActionMock.Verify(m => m(It.Is<OrgChangedData>(data => data.OrgSupplementaryData.Ukprn == 2)), Times.Once);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void OrgSupplementaryChangeService_ShouldUpdateAllTestOrganisationsWhenGivenChangesForAllTestOrganisationsCompanyAndCharityNumberChangeAndAddress()
        {
            // arrange
            const string afterChangecompanyRegNumber15 = "ChangedTestCompanyRegNumber15";
            const string afterChangecompanyRegNumber16 = "ChangedTestCompanyRegNumber16";

            const string companyRegNumberNameBeforePrefix = "OrginalTestCompanyRegNumber";
            const string charityNumberBeforePrefix = "CHARITY";
            const string charityNumberUpdated = "Updated";
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "pc";

            Address orgAddressBefore = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };

            Address expectedAddress15 = new Address
            {
                Line1 = line1 + "15", Line2 = line2 + "15", Line3 = line3 + "15", Line4 = line4 + "15",
                Town = town + "15", County = county + "15",Postcode = postcode + "15"
            };
            Address expectedAddress16 = new Address
            {
                Line1 = line1 + "16", Line2 = line2 + "16", Line3 = line3 + "16", Line4 = line4 + "16",
                Town = town + "16", County = county + "16", Postcode = postcode + "16"
            };

            var orgSupplementaryDataCollection =
                new List<OrgSupplementaryData>
                    {
                        new OrgSupplementaryData(ukprn: 15, companyNumber: afterChangecompanyRegNumber15, charityNumber: charityNumberUpdated + "15",
                            address: ToDomainAddress(expectedAddress15)),
                        new OrgSupplementaryData(ukprn: 16, companyNumber: afterChangecompanyRegNumber16, charityNumber: charityNumberUpdated + "16",
                            address: ToDomainAddress(expectedAddress16))
                    };

            IReadOnlyCollection<int> ukprnsToTest = new List<int> { 15, 16 };
            DeleteOrgsForUkrpns(ukprnsToTest);
            CreateOrgs(ukprnsToTest, companyRegNumberNameBeforePrefix, charityNumberBeforePrefix, orgAddressBefore);

            IReadOnlyCollection<OrgChangedData> orgChangedDataCollection = null;
            // act
            using (var context = new OrganisationDomainDbContext())
            {
                IOrgSupplementaryChangeService orgSupplementaryChangeService = new OrgSupplementaryChangeService(Mock.Of<ILogger>(), new OrganisationRepository(context));

                // act
                orgChangedDataCollection = orgSupplementaryChangeService.ChangeOrgSupplementaryData(orgSupplementaryDataCollection);
            }

            // assert            
            using (var context = new OrganisationDomainDbContext())
            {
                Organisation org15 = context.Organisations.Single(o => o.Ukprn == 15);
                Assert.AreEqual(afterChangecompanyRegNumber15, org15.CompanyRegistrationNumber, "The company reg number was not updated for ukprn 15");
                Assert.AreEqual(charityNumberUpdated + "15", org15.CharityNumber, "The charity number was not updated for ukprn 15");
                Assert.IsTrue(org15.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully was not set to true for ukprn 15");
                Assert.AreEqual(expectedAddress15.Line1, org15.Address.Line1, "The address line 1 was not updated correctly for ukprn 15");
                Assert.AreEqual(expectedAddress15.Line2, org15.Address.Line2, "The address line 2 was not updated correctly for ukprn 15");
                Assert.AreEqual(expectedAddress15.Line3, org15.Address.Line3, "The address line 3 was not updated correctly for ukprn 15");
                Assert.AreEqual(expectedAddress15.Line4, org15.Address.Line4, "The address line 4 was not updated correctly for ukprn 15");
                Assert.AreEqual(expectedAddress15.Town, org15.Address.Town, "The address town was not updated correctly for ukprn 15");
                Assert.AreEqual(expectedAddress15.County, org15.Address.County, "The address county was not updated correctly for ukprn 15");
                Assert.AreEqual(expectedAddress15.Postcode, org15.Address.Postcode, "The address postcode was not updated correctly for ukprn 15");

                Organisation org16 = context.Organisations.Single(o => o.Ukprn == 16);
                Assert.AreEqual(afterChangecompanyRegNumber16, org16.CompanyRegistrationNumber, "The company reg number was not updated for ukprn 16");
                Assert.AreEqual(charityNumberUpdated + "16", org16.CharityNumber, "The charity number was not updated for ukprn 16");
                Assert.IsTrue(org16.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully was not set to true for ukprn 16");
                Assert.AreEqual(expectedAddress16.Line1, org16.Address.Line1, "The address line 1 was not updated correctly for ukprn 16");
                Assert.AreEqual(expectedAddress16.Line2, org16.Address.Line2, "The address line 2 was not updated correctly for ukprn 16");
                Assert.AreEqual(expectedAddress16.Line3, org16.Address.Line3, "The address line 3 was not updated correctly for ukprn 16");
                Assert.AreEqual(expectedAddress16.Line4, org16.Address.Line4, "The address line 4 was not updated correctly for ukprn 16");
                Assert.AreEqual(expectedAddress16.Town, org16.Address.Town, "The address town was not updated correctly for ukprn 16");
                Assert.AreEqual(expectedAddress16.County, org16.Address.County, "The address county was not updated correctly for ukprn 16");
                Assert.AreEqual(expectedAddress16.Postcode, org16.Address.Postcode, "The address postcode was not updated correctly for ukprn 16");
            }

            Assert.AreEqual(2, orgChangedDataCollection.Count, "The are an incorrect number of return changes");
            Assert.AreEqual(6, orgChangedDataCollection.Sum(c => c.NotificationMessages.Count), "The are an incorrect number of notification messages");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void OrgSupplementaryChangeService_ShouldUpdateNoTestOrganisationsWhenGivenNoChangesForAllTestOrganisations()
        {
            // arrange
            const string beforecompanyRegNumber15 = "OrginalTestCompanyRegNumber15";
            const string beforecompanyRegNumber16 = "OrginalTestCompanyRegNumber16";

            const string companyRegNumberNameBeforePrefix = "OrginalTestCompanyRegNumber";
            const string charityNumberBeforePrefix = "CHARITY";

            var orgSupplementaryDataCollection =
               new List<OrgSupplementaryData>
                   {
                        new OrgSupplementaryData(ukprn: 15, companyNumber: beforecompanyRegNumber15, charityNumber: charityNumberBeforePrefix + "15", address: new OrgSupplementaryAddress()),
                        new OrgSupplementaryData(ukprn: 16, companyNumber: beforecompanyRegNumber16, charityNumber: charityNumberBeforePrefix + "16", address: new OrgSupplementaryAddress())
                   };

            IReadOnlyCollection<int> ukprnsToTest = new List<int> { 15, 16 };
            DeleteOrgsForUkrpns(ukprnsToTest);
            CreateOrgs(ukprnsToTest, companyRegNumberNameBeforePrefix, charityNumberBeforePrefix, new Address());
            IList<OrgChangedData> orgChangedDataCollection = new List<OrgChangedData>();

            // act
            using (var context = new OrganisationDomainDbContext())
            {
                IOrgSupplementaryChangeService orgSupplementaryChangeService =
                    new OrgSupplementaryChangeService(Mock.Of<ILogger>(), new OrganisationRepository(context));

                // act
                var data = orgSupplementaryChangeService.ChangeOrgSupplementaryData(orgSupplementaryDataCollection);
            }

            // assert            
            using (var context = new OrganisationDomainDbContext())
            {
                Organisation org15 = context.Organisations.Single(o => o.Ukprn == 15);
                Assert.AreEqual(beforecompanyRegNumber15, org15.CompanyRegistrationNumber, "The company reg number was updated for ukprn 15");
                Assert.AreEqual(charityNumberBeforePrefix + "15", org15.CharityNumber, "The charity number was updated for ukprn 15");
                Assert.IsFalse(org15.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully should remain as false for ukprn 15");

                Organisation org16 = context.Organisations.Single(o => o.Ukprn == 16);
                Assert.AreEqual(beforecompanyRegNumber16, org16.CompanyRegistrationNumber, "The company reg number was updated for ukprn 16");
                Assert.AreEqual(charityNumberBeforePrefix + "16", org16.CharityNumber, "The charity number was updated for ukprn 15");
                Assert.IsFalse(org16.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully should remain as false for ukprn 16");
            }

            Assert.AreEqual(0, orgChangedDataCollection.Count, "The are an incorrect number of return changes");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void OrgSupplementaryChangeService_ShouldUpdate_WhenGivenSomeDataWeDoAndSomeWeDontHave()
        {
            // Ukprn 15 to remain unchanged. Ukprn 16 & 17 to change

            // arrange
            const string beforecompanyRegNumber15 = "OrginalTestCompanyRegNumber15";

            const string afterChangecompanyRegNumber16 = "ChangedTestCompanyRegNumber16";
            const string afterChangecompanyRegNumber17 = "ChangedTestCompanyRegNumber17";

            const string companyRegNumberNameBeforePrefix = "OrginalTestCompanyRegNumber";
            const string charityNumberBeforePrefix = "CHARITY";
            const string charityNumberUpdated = "Updated";

            var orgSupplementaryDataCollection =
                new List<OrgSupplementaryData>
                    {
                        new OrgSupplementaryData(ukprn: 15, companyNumber: beforecompanyRegNumber15, charityNumber: charityNumberBeforePrefix + "15", address: new OrgSupplementaryAddress()),
                        new OrgSupplementaryData(ukprn: 16, companyNumber: afterChangecompanyRegNumber16, charityNumber: charityNumberUpdated + "16", address: new OrgSupplementaryAddress()),
                        new OrgSupplementaryData(ukprn: 17, companyNumber: afterChangecompanyRegNumber17, charityNumber: charityNumberUpdated + "17", address: new OrgSupplementaryAddress()),
                        new OrgSupplementaryData(ukprn: 18, companyNumber: afterChangecompanyRegNumber17, charityNumber: charityNumberUpdated + "18", address: new OrgSupplementaryAddress())
                   };

            IReadOnlyCollection<int> ukprnsToTest = new List<int> { 15, 16, 17 };
            DeleteOrgsForUkrpns(ukprnsToTest);
            CreateOrgs(ukprnsToTest, companyRegNumberNameBeforePrefix, charityNumberBeforePrefix, new Address());

            // act
            using (var context = new OrganisationDomainDbContext())
            {
                IOrgSupplementaryChangeService orgSupplementaryChangeService =
                    new OrgSupplementaryChangeService(Mock.Of<ILogger>(), new OrganisationRepository(context));

                // act
                var data = orgSupplementaryChangeService.ChangeOrgSupplementaryData(orgSupplementaryDataCollection);
            }

            // assert            
            using (var context = new OrganisationDomainDbContext())
            {
                // ukprn 15 should NOT change
                Organisation org15 = context.Organisations.Single(o => o.Ukprn == 15);
                Assert.AreEqual(beforecompanyRegNumber15, org15.CompanyRegistrationNumber, "The company reg number was updated for ukprn 15");
                Assert.AreEqual(charityNumberBeforePrefix + "15", org15.CharityNumber, "The charity number was not updated for ukprn 15");
                Assert.IsFalse(org15.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully was set to true for ukprn 15");

                // ukprn 16 should change
                Organisation org16 = context.Organisations.Single(o => o.Ukprn == 16);
                Assert.AreEqual(afterChangecompanyRegNumber16, org16.CompanyRegistrationNumber, "The company reg number was not updated for ukprn 16");
                Assert.AreEqual(charityNumberUpdated + "16", org16.CharityNumber, "The charity number was not updated for ukprn 16");
                Assert.IsTrue(org16.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully was not set to true for ukprn 16");

                // ukprn 17 should change
                Organisation org17 = context.Organisations.Single(o => o.Ukprn == 17);
                Assert.AreEqual(afterChangecompanyRegNumber17, org17.CompanyRegistrationNumber, "The company reg number was not updated for ukprn 17");
                Assert.AreEqual(charityNumberUpdated + "17", org17.CharityNumber, "The charity number was not updated for ukprn 17");
                Assert.IsTrue(org17.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully was not set to true for ukprn 17");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void OrgSupplementaryChangeService_ShouldCallDelegateWithSupplementaryDataForSomeTestOrganisationsWhenGivenChangesForSomeTestOrganisations()
        {
            // Ukprn 15 to remain unchanged. Ukprn 16 & 17 to change

            // arrange
            const string beforecompanyRegNumber15 = "OrginalTestCompanyRegNumber15";

            const string afterChangecompanyRegNumber16 = "ChangedTestCompanyRegNumber16";
            const string afterChangecompanyRegNumber17 = "ChangedTestCompanyRegNumber17";

            const string companyRegNumberNameBeforePrefix = "OrginalTestCompanyRegNumber";
            const string charityNumberBeforePrefix = "CHARITY";
            const string charityNumberUpdated = "Updated";

            var orgSupplementaryDataCollection =
                new List<OrgSupplementaryData>
                    {
                        new OrgSupplementaryData(ukprn: 15, companyNumber: beforecompanyRegNumber15, charityNumber: charityNumberBeforePrefix + "15", address: new OrgSupplementaryAddress()),
                        new OrgSupplementaryData(ukprn: 16, companyNumber: afterChangecompanyRegNumber16, charityNumber: charityNumberUpdated + "16", address: new OrgSupplementaryAddress()),
                        new OrgSupplementaryData(ukprn: 17, companyNumber: afterChangecompanyRegNumber17, charityNumber: charityNumberUpdated + "17", address: new OrgSupplementaryAddress())
                    };

            IReadOnlyCollection<int> ukprnsToTest = new List<int> { 15, 16, 17 };
            DeleteOrgsForUkrpns(ukprnsToTest);

            CreateOrgs(ukprnsToTest, companyRegNumberNameBeforePrefix, charityNumberBeforePrefix, new Address());

            // act
            IReadOnlyCollection<OrgChangedData> results;
            using (var context = new OrganisationDomainDbContext())
            {
                IOrgSupplementaryChangeService orgSupplementaryChangeService =
                    new OrgSupplementaryChangeService(Mock.Of<ILogger>(), new OrganisationRepository(context));

                // act
                results = orgSupplementaryChangeService.ChangeOrgSupplementaryData(orgSupplementaryDataCollection);
            }

            // assert
            Assert.AreEqual(2, results.Count, "Incorrect number of results sent in delegate");
            var resultsArray = results.ToArray();
            Assert.AreEqual(16, resultsArray[0].OrgSupplementaryData.Ukprn, "Ukprn 16 should be updating CRM incorrect");
            Assert.AreEqual(afterChangecompanyRegNumber16, resultsArray[0].OrgSupplementaryData.CompanyNumber, "Ukprn 16 updated Company number was not correct");
            Assert.AreEqual(charityNumberUpdated + "16", resultsArray[0].OrgSupplementaryData.CharityNumber, "The charity number was not updated for ukprn 16");

            Assert.AreEqual(17, resultsArray[1].OrgSupplementaryData.Ukprn, "Ukprn 17 should be updating CRM incorrect");
            Assert.AreEqual(afterChangecompanyRegNumber17, resultsArray[1].OrgSupplementaryData.CompanyNumber, "Ukprn 17 updated Company number was not correct");
            Assert.AreEqual(charityNumberUpdated + "17", resultsArray[1].OrgSupplementaryData.CharityNumber, "The charity number was not updated for ukprn 17");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void OrgSupplementaryChangeService_ShouldUpdateAllTestOrganisationsWhenGivenChangesForAllTestOrganisationsWithOnlyCompanyNumberChange()
        {
            // arrange
            const string afterChangecompanyRegNumber15 = "ChangedTestCompanyRegNumber15";
            const string afterChangecompanyRegNumber16 = "ChangedTestCompanyRegNumber16";

            const string companyRegNumberNameBeforePrefix = "OrginalTestCompanyRegNumber";
            const string charityNumberBeforePrefix = "CHARITY";
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "pc";

            Address orgAddressBefore15 = new Address
            {
                Line1 = line1 + "15", Line2 = line2 + "15",  Line3 = line3 + "15", Line4 = line4 + "15",
                Town = town + "15", County = county + "15", Postcode = postcode + "15"
            };
            Address orgAddressBefore16 = new Address
            {
                Line1 = line1 + "16", Line2 = line2 + "16", Line3 = line3 + "16", Line4 = line4 + "16",
                Town = town + "16", County = county + "16", Postcode = postcode + "16"
            };

            var orgSupplementaryDataCollection =
                new List<OrgSupplementaryData>
                    {
                        new OrgSupplementaryData(ukprn: 15, companyNumber: afterChangecompanyRegNumber15, charityNumber: charityNumberBeforePrefix + "15",
                            address: ToDomainAddress(orgAddressBefore15)),
                        new OrgSupplementaryData(ukprn: 16, companyNumber: afterChangecompanyRegNumber16, charityNumber: charityNumberBeforePrefix + "16",
                            address: ToDomainAddress(orgAddressBefore16)),
                    };

            IReadOnlyCollection<int> ukprnsToTest = new List<int> { 15, 16 };
            DeleteOrgsForUkrpns(ukprnsToTest);
            CreateOrgs(new List<int> { 15 }, companyRegNumberNameBeforePrefix, charityNumberBeforePrefix, orgAddressBefore15);
            CreateOrgs(new List<int> { 16 }, companyRegNumberNameBeforePrefix, charityNumberBeforePrefix, orgAddressBefore16);

            // act
            using (var context = new OrganisationDomainDbContext())
            {
                IOrgSupplementaryChangeService orgSupplementaryChangeService = new OrgSupplementaryChangeService(Mock.Of<ILogger>(), new OrganisationRepository(context));

                // act
                var data = orgSupplementaryChangeService.ChangeOrgSupplementaryData(orgSupplementaryDataCollection);
            }

            // assert            
            using (var context = new OrganisationDomainDbContext())
            {
                Organisation org15 = context.Organisations.Single(o => o.Ukprn == 15);
                Assert.AreEqual(afterChangecompanyRegNumber15, org15.CompanyRegistrationNumber, "The company reg number was not updated for ukprn 15");
                Assert.AreEqual(charityNumberBeforePrefix + "15", org15.CharityNumber, "The charity number was updated for ukprn 15");
                Assert.IsTrue(org15.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully was not set to true for ukprn 15");
                Assert.AreEqual(orgAddressBefore15.Line1, org15.Address.Line1, "The address line 1 was updated incorrectly for ukprn 15");
                Assert.AreEqual(orgAddressBefore15.Line2, org15.Address.Line2, "The address line 2 was updated incorrectly for ukprn 15");
                Assert.AreEqual(orgAddressBefore15.Line3, org15.Address.Line3, "The address line 3 was updated incorrectly for ukprn 15");
                Assert.AreEqual(orgAddressBefore15.Line4, org15.Address.Line4, "The address line 4 was updated incorrectly for ukprn 15");
                Assert.AreEqual(orgAddressBefore15.Town, org15.Address.Town, "The address town was updated incorrectly for ukprn 15");
                Assert.AreEqual(orgAddressBefore15.County, org15.Address.County, "The address county was updated incorrectly for ukprn 15");
                Assert.AreEqual(orgAddressBefore15.Postcode, org15.Address.Postcode, "The address postcode was updated incorrectly for ukprn 15");

                Organisation org16 = context.Organisations.Single(o => o.Ukprn == 16);
                Assert.AreEqual(afterChangecompanyRegNumber16, org16.CompanyRegistrationNumber, "The company reg number was not updated for ukprn 16");
                Assert.AreEqual(charityNumberBeforePrefix + "16", org16.CharityNumber, "The charity number was updated for ukprn 16");
                Assert.IsTrue(org16.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully was not set to true for ukprn 16");
                Assert.AreEqual(orgAddressBefore16.Line1, org16.Address.Line1, "The address line 1 was updated incorrectly for ukprn 16");
                Assert.AreEqual(orgAddressBefore16.Line2, org16.Address.Line2, "The address line 2 was updated incorrectly for ukprn 16");
                Assert.AreEqual(orgAddressBefore16.Line3, org16.Address.Line3, "The address line 3 was updated incorrectly for ukprn 16");
                Assert.AreEqual(orgAddressBefore16.Line4, org16.Address.Line4, "The address line 4 was updated incorrectly for ukprn 16");
                Assert.AreEqual(orgAddressBefore16.Town, org16.Address.Town, "The address town was updated incorrectly for ukprn 16");
                Assert.AreEqual(orgAddressBefore16.County, org16.Address.County, "The address county was updated incorrectly for ukprn 16");
                Assert.AreEqual(orgAddressBefore16.Postcode, org16.Address.Postcode, "The address postcode was updated incorrectly for ukprn 16");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void OrgSupplementaryChangeService_ShouldUpdateAllTestOrganisationsWhenGivenChangesForAllTestOrganisationsWithOnlyCharityNumberChange()
        {
            // arrange
            const string companyRegNumberNameBeforePrefix = "OrginalTestCompanyRegNumber";
            const string charityNumberBeforePrefix = "CHARITY";
            const string charityNumberUpdated = "Updated";
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "pc";

            Address orgAddressBefore15 = new Address
            {
                Line1 = line1 + "15", Line2 = line2 + "15", Line3 = line3 + "15", Line4 = line4 + "15",
                Town = town + "15", County = county + "15", Postcode = postcode + "15" 
            };
            Address orgAddressBefore16 = new Address
            {
                Line1 = line1 + "16", Line2 = line2 + "16", Line3 = line3 + "16", Line4 = line4 + "16",
                Town = town + "16", County = county + "16", Postcode = postcode + "16"
            };

            var orgSupplementaryDataCollection =
                new List<OrgSupplementaryData>
                    {
                        new OrgSupplementaryData(ukprn: 15, companyNumber: companyRegNumberNameBeforePrefix + "15", charityNumber: charityNumberUpdated + "15", 
                            address: ToDomainAddress(orgAddressBefore15)),
                        new OrgSupplementaryData(ukprn: 16, companyNumber: companyRegNumberNameBeforePrefix + "16", charityNumber: charityNumberUpdated + "16", 
                            address: ToDomainAddress(orgAddressBefore16))
                    };

            IReadOnlyCollection<int> ukprnsToTest = new List<int> { 15, 16 };
            DeleteOrgsForUkrpns(ukprnsToTest);

            CreateOrgs(new List<int> { 15 }, companyRegNumberNameBeforePrefix, charityNumberBeforePrefix, orgAddressBefore15);
            CreateOrgs(new List<int> { 16 }, companyRegNumberNameBeforePrefix, charityNumberBeforePrefix, orgAddressBefore16);

            // act
            using (var context = new OrganisationDomainDbContext())
            {
                IOrgSupplementaryChangeService orgSupplementaryChangeService = new OrgSupplementaryChangeService(Mock.Of<ILogger>(), new OrganisationRepository(context));

                // act
                orgSupplementaryChangeService.ChangeOrgSupplementaryData(orgSupplementaryDataCollection);
            }

            // assert            
            using (var context = new OrganisationDomainDbContext())
            {
                Organisation org15 = context.Organisations.Single(o => o.Ukprn == 15);
                Assert.AreEqual(companyRegNumberNameBeforePrefix + "15", org15.CompanyRegistrationNumber, "The company reg number was updated for ukprn 15");
                Assert.AreEqual(charityNumberUpdated + "15", org15.CharityNumber, "The charity number was not updated for ukprn 15");
                Assert.IsTrue(org15.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully was not set to true for ukprn 15");
                Assert.AreEqual(orgAddressBefore15.Line1, org15.Address.Line1, "The address line 1 was updated incorrectly for ukprn 15");
                Assert.AreEqual(orgAddressBefore15.Line2, org15.Address.Line2, "The address line 2 was updated incorrectly for ukprn 15");
                Assert.AreEqual(orgAddressBefore15.Line3, org15.Address.Line3, "The address line 3 was updated incorrectly for ukprn 15");
                Assert.AreEqual(orgAddressBefore15.Line4, org15.Address.Line4, "The address line 4 was updated incorrectly for ukprn 15");
                Assert.AreEqual(orgAddressBefore15.Town, org15.Address.Town, "The address town was updated incorrectly for ukprn 15");
                Assert.AreEqual(orgAddressBefore15.County, org15.Address.County, "The address county was updated incorrectly for ukprn 15");
                Assert.AreEqual(orgAddressBefore15.Postcode, org15.Address.Postcode, "The address postcode was updated incorrectly for ukprn 15");

                Organisation org16 = context.Organisations.Single(o => o.Ukprn == 16);
                Assert.AreEqual(companyRegNumberNameBeforePrefix + "16", org16.CompanyRegistrationNumber, "The company reg number was updated for ukprn 16");
                Assert.AreEqual(charityNumberUpdated + "16", org16.CharityNumber, "The charity number was not updated for ukprn 16");
                Assert.IsTrue(org16.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully was not set to true for ukprn 16");
                Assert.AreEqual(orgAddressBefore16.Line1, org16.Address.Line1, "The address line 1 was updated incorrectly for ukprn 16");
                Assert.AreEqual(orgAddressBefore16.Line2, org16.Address.Line2, "The address line 2 was updated incorrectly for ukprn 16");
                Assert.AreEqual(orgAddressBefore16.Line3, org16.Address.Line3, "The address line 3 was updated incorrectly for ukprn 16");
                Assert.AreEqual(orgAddressBefore16.Line4, org16.Address.Line4, "The address line 4 was updated incorrectly for ukprn 16");
                Assert.AreEqual(orgAddressBefore16.Town, org16.Address.Town, "The address town was updated incorrectly for ukprn 16");
                Assert.AreEqual(orgAddressBefore16.County, org16.Address.County, "The address county was updated incorrectly for ukprn 16");
                Assert.AreEqual(orgAddressBefore16.Postcode, org16.Address.Postcode, "The address postcode was updated incorrectly for ukprn 16");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void OrgSupplementaryChangeService_ShouldUpdateAllTestOrganisationsWhenGivenChangesForAllTestOrganisationsWithOnlyAddressChange()
        {
            // arrange
            const string companyRegNumberNameBeforePrefix = "OrginalTestCompanyRegNumber";
            const string charityNumberBeforePrefix = "CHARITY";
            const string charityNumberUpdated = "Updated";

            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "pc";
            const string updated = "upd";

            Address orgAddressBefore = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };
            var ExpectedOrgSupplementaryAddress15 = new OrgSupplementaryAddress
                {
                    Line1 = line1 + updated + "15", Line2 = line2 + updated + "15", Line3 = line3 + updated + "15",
                    Line4 = line4 + updated + "15",  Town = town + updated + "15", County = county + updated + "15", Postcode = postcode + updated + "15"
                };
            var ExpectedOrgSupplementaryAddress16 = new OrgSupplementaryAddress
                {
                    Line1 = line1 + updated + "16", Line2 = line2 + updated + "16", Line3 = line3 + updated + "16",
                    Line4 = line4 + updated + "16", Town = town + updated + "16", County = county + updated + "16", Postcode = postcode + updated + "16"
                };

            var orgSupplementaryDataCollection =
                new List<OrgSupplementaryData>
                    {
                        new OrgSupplementaryData(ukprn: 15, companyNumber: companyRegNumberNameBeforePrefix + "15", charityNumber: charityNumberUpdated + "15", 
                            address: ExpectedOrgSupplementaryAddress15),
                        new OrgSupplementaryData(ukprn: 16, companyNumber: companyRegNumberNameBeforePrefix + "16", charityNumber: charityNumberUpdated + "16", 
                            address: ExpectedOrgSupplementaryAddress16)
                    };

            IReadOnlyCollection<int> ukprnsToTest = new List<int> { 15, 16 };
            DeleteOrgsForUkrpns(ukprnsToTest);
            CreateOrgs(ukprnsToTest, companyRegNumberNameBeforePrefix, charityNumberBeforePrefix, orgAddressBefore);

            // act
            using (var context = new OrganisationDomainDbContext())
            {
                IOrgSupplementaryChangeService orgSupplementaryChangeService = new OrgSupplementaryChangeService(Mock.Of<ILogger>(), new OrganisationRepository(context));

                // act
                orgSupplementaryChangeService.ChangeOrgSupplementaryData(orgSupplementaryDataCollection);
            }

            // assert            
            using (var context = new OrganisationDomainDbContext())
            {
                Organisation org15 = context.Organisations.Single(o => o.Ukprn == 15);
                Assert.AreEqual(companyRegNumberNameBeforePrefix + "15", org15.CompanyRegistrationNumber, "The company reg number was not updated for ukprn 15");
                Assert.AreEqual(charityNumberUpdated + "15", org15.CharityNumber, "The charity number was not updated for ukprn 15");
                Assert.IsTrue(org15.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully was not set to true for ukprn 15");
                Assert.AreEqual(ExpectedOrgSupplementaryAddress15.Line1, org15.Address.Line1, "The address line 1 was not updated correctly for ukprn 15");
                Assert.AreEqual(ExpectedOrgSupplementaryAddress15.Line2, org15.Address.Line2, "The address line 2 was not updated correctly for ukprn 15");
                Assert.AreEqual(ExpectedOrgSupplementaryAddress15.Line3, org15.Address.Line3, "The address line 3 was not updated correctly for ukprn 15");
                Assert.AreEqual(ExpectedOrgSupplementaryAddress15.Line4, org15.Address.Line4, "The address line 4 was not updated correctly for ukprn 15");
                Assert.AreEqual(ExpectedOrgSupplementaryAddress15.Town, org15.Address.Town, "The address town was not updated correctly for ukprn 15");
                Assert.AreEqual(ExpectedOrgSupplementaryAddress15.County, org15.Address.County, "The address county was not updated correctly for ukprn 15");
                Assert.AreEqual(ExpectedOrgSupplementaryAddress15.Postcode, org15.Address.Postcode, "The address postcode was not updated correctly for ukprn 15");


                Organisation org16 = context.Organisations.Single(o => o.Ukprn == 16);
                Assert.AreEqual(companyRegNumberNameBeforePrefix + "16", org16.CompanyRegistrationNumber, "The company reg number was updated for ukprn 16");
                Assert.AreEqual(charityNumberUpdated + "16", org16.CharityNumber, "The charity number was not updated for ukprn 16");
                Assert.IsTrue(org16.HasUkrlpBeenCalledSuccessfully, "HasUkrlpBeenCalledSuccessfully was not set to true for ukprn 16");
                Assert.AreEqual(ExpectedOrgSupplementaryAddress16.Line1, org16.Address.Line1, "The address line 1 was not updated correctly for ukprn 16");
                Assert.AreEqual(ExpectedOrgSupplementaryAddress16.Line2, org16.Address.Line2, "The address line 2 was not updated correctly for ukprn 16");
                Assert.AreEqual(ExpectedOrgSupplementaryAddress16.Line3, org16.Address.Line3, "The address line 3 was not updated correctly for ukprn 16");
                Assert.AreEqual(ExpectedOrgSupplementaryAddress16.Line4, org16.Address.Line4, "The address line 4 was not updated correctly for ukprn 16");
                Assert.AreEqual(ExpectedOrgSupplementaryAddress16.Town, org16.Address.Town, "The address town was not updated correctly for ukprn 16");
                Assert.AreEqual(ExpectedOrgSupplementaryAddress16.County, org16.Address.County, "The address county was not updated correctly for ukprn 16");
                Assert.AreEqual(ExpectedOrgSupplementaryAddress16.Postcode, org16.Address.Postcode, "The address postcode was not updated correctly for ukprn 16");

            }
        }
        
        private static void DeleteOrgsForUkrpns(IEnumerable<int> ukprnsToTest)
        {
            using (var context = new OrganisationDomainDbContext())
            {
                context.Organisations.Where(o => ukprnsToTest.Contains(o.Ukprn))
                    .ForEach(o => context.Organisations.Remove(o));

                context.SaveChanges();
            }
        }

        private static void CreateOrgs(IEnumerable<int> ukprnsToTest, string companyRegNumberNamePrefix, string charityNumberPrefix, Address address)
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
                        CompanyRegistrationNumber = companyRegNumberNamePrefix + ukprn.ToString(),
                        CharityNumber = charityNumberPrefix + ukprn.ToString(),
                        Address = address
                    });
                });

                context.SaveChanges();
            }
        }

        private static OrgSupplementaryAddress ToDomainAddress(Address dbAddress)
        {
            return new OrgSupplementaryAddress
            {
                Line1 = dbAddress.Line1,
                Line2 = dbAddress.Line2,
                Line3 = dbAddress.Line3,
                Line4 = dbAddress.Line4,
                Town = dbAddress.Town,
                County = dbAddress.County,
                Postcode = dbAddress.Postcode
            };
        }
    }
}
