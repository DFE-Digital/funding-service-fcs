namespace OrganisationDomain.Implementation.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml.Linq;
    using Implementation.Services;
    using Integration.DataStore.Model;
    using Integration.Entities;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class OrgChangeDataComparerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_ShouldIdentifyThatThereIsNoChange()
        {
            const string companyRegNumber = "CRN";
            const string charityNumber = "ChN";
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";

            // arrange 
            Organisation orgFromDb = new Organisation
            {
                CompanyRegistrationNumber = companyRegNumber,
                CharityNumber = charityNumber,
                Address = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode }
            };

            OrgSupplementaryData orgSupplementaryData = new OrgSupplementaryData(ukprn: 1, companyNumber: companyRegNumber, charityNumber: charityNumber,
                address: new OrgSupplementaryAddress { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode });

            // act
            bool areTheSame = OrgChangeDataComparer.AreObjectContentsTheSame(orgSupplementaryData, orgFromDb);

            // assert
            Assert.IsTrue(areTheSame);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_ShouldIdentifyThatThereIsAChange_WhenCharityNumbersDiffer()
        {
            const string companyRegNumber = "CRN";
            const string charityNumber = "ChN";
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";
            // arrange 
            Organisation orgFromDb = new Organisation
            {
                CompanyRegistrationNumber = companyRegNumber,
                CharityNumber = charityNumber,
                Address = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode }
            };

            OrgSupplementaryData orgSupplementaryData = new OrgSupplementaryData(ukprn: 1, companyNumber: companyRegNumber, charityNumber: "123",
            address: new OrgSupplementaryAddress { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode });

            // act
            bool areTheSame = OrgChangeDataComparer.AreObjectContentsTheSame(orgSupplementaryData, orgFromDb);

            // assert
            Assert.IsFalse(areTheSame);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_ShouldIdentifyThatThereIsAChange_WhenCompanyNumbersDiffer()
        {
            const string companyRegNumber = "CRN";
            const string charityNumber = "ChN";
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";
            // arrange 
            Organisation orgFromDb = new Organisation
            {
                CompanyRegistrationNumber = companyRegNumber,
                CharityNumber = charityNumber,
                Address = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode }
            };

            OrgSupplementaryData orgSupplementaryData = new OrgSupplementaryData(ukprn: 1, companyNumber: "123", charityNumber: charityNumber,
                address: new OrgSupplementaryAddress { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode });

            // act
            bool areTheSame = OrgChangeDataComparer.AreObjectContentsTheSame(orgSupplementaryData, orgFromDb);

            // assert
            Assert.IsFalse(areTheSame);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_ShouldIdentifyThatThereIsAChange_WhenAddressDiffer()
        {
            const string companyRegNumber = "CRN";
            const string charityNumber = "ChN";
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";
            const string line1Diff = "line1Diff";

            // arrange 
            Organisation orgFromDb = new Organisation
            {
                CompanyRegistrationNumber = companyRegNumber,
                CharityNumber = charityNumber,
                Address = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode }
            };

            OrgSupplementaryData orgSupplementaryData = new OrgSupplementaryData(ukprn: 1, companyNumber: companyRegNumber, charityNumber: charityNumber,
                address: new OrgSupplementaryAddress { Line1 = line1Diff, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode });

            // act
            bool areTheSame = OrgChangeDataComparer.AreObjectContentsTheSame(orgSupplementaryData, orgFromDb);

            // assert
            Assert.IsFalse(areTheSame);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_GetNotificationMessages_ForOrgSupplementaryData_ShouldreturnOneCompanyNumberNotificationMessage()
        {
            // Arrange
            const string providerName = "ProviderName";
            const int ukprn = 88888888;

            const string companyNumberOriginal = "ORIGCompanyNumber";
            const string companyNumberUpdated = "UPDATEDCompanyNumber";
            const string charityNumberOriginal = "ORIGCharityNumber";
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";

            Organisation organisation = new Organisation
            {
                Ukprn = ukprn,
                CompanyRegistrationNumber = companyNumberOriginal,
                CharityNumber = charityNumberOriginal,
                TradingName = providerName,
                Address = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode }
            };
            OrgSupplementaryData orgSupplementaryData = new OrgSupplementaryData(ukprn: ukprn, companyNumber: companyNumberUpdated, charityNumber: charityNumberOriginal,
                address: new OrgSupplementaryAddress { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode });


            string expectedCompanyNumberNotificationMessage = $"Company Number has been updated for provider {ukprn} ({providerName})";

            // Act           
            IReadOnlyCollection<string> messages = OrgChangeDataComparer.GetNotificationMessages(orgSupplementaryData, organisation);

            // Assert
            Assert.AreEqual(1, messages.Count, "Incorrect number of notification messages were returned");
            Assert.AreEqual(expectedCompanyNumberNotificationMessage, messages.First(), "Company number change message was not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_GetNotificationMessages_ForOrgSupplementaryData_ShouldreturnOneCharityNumberNotificationMessage()
        {
            // Arrange
            const string providerName = "ProviderName";
            const int ukprn = 88888888;

            const string companyNumberOriginal = "ORIGCompanyNumber";
            const string charityNumberOriginal = "ORIGCharityNumber";
            const string charityNumberUpdated = "UPDATEDCharityNumber";
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";

            Organisation organisation = new Organisation
            {
                Ukprn = ukprn,
                CompanyRegistrationNumber = companyNumberOriginal,
                CharityNumber = charityNumberOriginal,
                TradingName = providerName,
                Address = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode }
            };
            OrgSupplementaryData orgSupplementaryData = new OrgSupplementaryData(ukprn: ukprn, companyNumber: companyNumberOriginal, charityNumber: charityNumberUpdated,
                address: new OrgSupplementaryAddress { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode });

            string expectedCharityNumberNotificationMessage = $"Charity Number has been updated for provider {ukprn} ({providerName})";

            // Act           
            IReadOnlyCollection<string> messages = OrgChangeDataComparer.GetNotificationMessages(orgSupplementaryData, organisation);

            // Assert
            Assert.AreEqual(1, messages.Count, "Incorrect number of notification messages were returned");
            Assert.AreEqual(expectedCharityNumberNotificationMessage, messages.First(), "Charity number change message was not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_GetNotificationMessages_ForOrgSupplementaryData_ShouldreturnOneAddressNotificationMessage()
        {
            // Arrange
            const string providerName = "ProviderName";
            const int ukprn = 88888888;

            const string companyNumber = "ORIGCompanyNumber";
            const string charityNumber = "ORIGCharityNumber";
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";
            const string line1Diff = "line1Diff";

            Organisation organisation = new Organisation
            {
                Ukprn = ukprn,
                CompanyRegistrationNumber = companyNumber,
                CharityNumber = charityNumber,
                TradingName = providerName,
                Address = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode }
            };
            OrgSupplementaryData orgSupplementaryData = new OrgSupplementaryData(ukprn: ukprn, companyNumber: companyNumber, charityNumber: charityNumber,
                address: new OrgSupplementaryAddress { Line1 = line1Diff, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode });

            string expectedCharityNumberNotificationMessage = $"Address has been updated for provider {ukprn} ({providerName})";

            // Act           
            IReadOnlyCollection<string> messages = OrgChangeDataComparer.GetNotificationMessages(orgSupplementaryData, organisation);

            // Assert
            Assert.AreEqual(1, messages.Count, "Incorrect number of notification messages were returned");
            Assert.AreEqual(expectedCharityNumberNotificationMessage, messages.First(), "Address change message was not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_GetNotificationMessages_ForOrgSupplementaryData_ShouldreturnCompanyNumberMessageAndCharityNumberMessagesAndAddressMessage()
        {
            // Arrange
            const string providerName = "ProviderName";
            const int ukprn = 88888888;

            const string companyNumberOriginal = "ORIGCompanyNumber";
            const string companyNumberUpdated = "UPDATEDCompanyNumber";
            const string charityNumberOriginal = "ORIGCharityNumber";
            const string charityNumberUpdated = "UPDATEDCharityNumber";
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";
            const string line1Diff = "line1Diff";

            Organisation organisation = new Organisation
            {
                Ukprn = ukprn,
                CompanyRegistrationNumber = companyNumberOriginal,
                CharityNumber = charityNumberOriginal,
                TradingName = providerName,
                Address = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode }
            };
            OrgSupplementaryData orgSupplementaryData = new OrgSupplementaryData(ukprn: ukprn, companyNumber: companyNumberUpdated, charityNumber: charityNumberUpdated,
                address: new OrgSupplementaryAddress { Line1 = line1Diff, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode });

            string expectedCompanyNumberNotificationMessage = $"Company Number has been updated for provider {ukprn} ({providerName})";
            string expectedCharityNumberNotificationMessage = $"Charity Number has been updated for provider {ukprn} ({providerName})";
            string expectedAddressNotificationMessage = $"Address has been updated for provider {ukprn} ({providerName})";

            // Act           
            IReadOnlyCollection<string> messages = OrgChangeDataComparer.GetNotificationMessages(orgSupplementaryData, organisation);

            // Assert
            Assert.AreEqual(3, messages.Count, "Incorrect number of notification messages were returned");
            Assert.IsTrue(messages.Any(str => str.Contains(expectedCompanyNumberNotificationMessage)), "Company number change message was not correct");
            Assert.IsTrue(messages.Any(str => str.Contains(expectedCharityNumberNotificationMessage)), "Charity number change message was not correct");
            Assert.IsTrue(messages.Any(str => str.Contains(expectedAddressNotificationMessage)), "Address change message was not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_GetNotificationMessages_ForOrgSupplementaryData_ShouldreturnNoNotificationMessages_WhenObjectContentsAreTheSame()
        {
            // Arrange
            const string providerName = "ProviderName";
            const int ukprn = 88888888;

            const string companyNumberOriginal = "ORIGCompanyNumber";
            const string charityNumberOriginal = "ORIGCharityNumber";
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";

            Organisation organisation = new Organisation
            {
                Ukprn = ukprn,
                CompanyRegistrationNumber = companyNumberOriginal,
                CharityNumber = charityNumberOriginal,
                TradingName = providerName,
                Address = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode }
            };
            OrgSupplementaryData orgSupplementaryData = new OrgSupplementaryData(ukprn: ukprn, companyNumber: companyNumberOriginal, charityNumber: charityNumberOriginal,
                address: new OrgSupplementaryAddress { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode });

            // Act           
            IReadOnlyCollection<string> messages = OrgChangeDataComparer.GetNotificationMessages(orgSupplementaryData, organisation);

            // Assert
            Assert.AreEqual(0, messages.Count, "Incorrect number of notification messages were returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_GetNotificationMessages_ForOrgSupplementaryDataExtended_ShouldreturnOneCompanyNumberNotificationMessage()
        {
            // Arrange
            const string providerName = "ProviderName";
            const int ukprn = 88888888;
            const string companyNumberUpdated = "UPDATEDCompanyNumber";
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";

            OrgSupplementaryDataExtended orgSupplementaryDataExtended =
                new OrgSupplementaryDataExtended(ukprn: ukprn, companyNumber: companyNumberUpdated, charityNumber: null, tradingName: providerName,
                    address: new OrgSupplementaryAddress { Line1 = null, Line2 = null, Line3 = null, Line4 = null, Town = null, County = null, Postcode = null });


            string expectedCompanyNumberNotificationMessage = $"Company Number has been updated for provider {ukprn} ({providerName})";

            // Act           
            IReadOnlyCollection<string> messages = OrgChangeDataComparer.GetNotificationMessages(orgSupplementaryDataExtended);

            // Assert
            Assert.AreEqual(1, messages.Count, "Incorrect number of notification messages were returned");
            Assert.AreEqual(expectedCompanyNumberNotificationMessage, messages.First(), "Company number change message was not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_GetNotificationMessages_ForOrgSupplementaryDataExtended_ShouldreturnOneCharityNumberNotificationMessage()
        {
            // Arrange
            const string providerName = "ProviderName";
            const int ukprn = 88888888;

            const string charityNumberUpdated = "UPDATEDCharityNumber";
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";

            OrgSupplementaryDataExtended orgSupplementaryDataExtended =
                new OrgSupplementaryDataExtended(ukprn: ukprn, companyNumber: null, charityNumber: charityNumberUpdated, tradingName: providerName,
                    address: new OrgSupplementaryAddress { Line1 = null, Line2 = null, Line3 = null, Line4 = null, Town = null, County = null, Postcode = null });

            string expectedCharityNumberNotificationMessage = $"Charity Number has been updated for provider {ukprn} ({providerName})";

            // Act           
            IReadOnlyCollection<string> messages = OrgChangeDataComparer.GetNotificationMessages(orgSupplementaryDataExtended);

            // Assert
            Assert.AreEqual(1, messages.Count, "Incorrect number of notification messages were returned");
            Assert.AreEqual(expectedCharityNumberNotificationMessage, messages.First(), "Charity number change message was not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_GetNotificationMessages_ForOrgSupplementaryDataExtended_ShouldreturnOneAddressNotificationMessage()
        {
            // Arrange
            const string providerName = "ProviderName";
            const int ukprn = 88888888;
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";

            OrgSupplementaryDataExtended orgSupplementaryDataExtended = new OrgSupplementaryDataExtended(ukprn: ukprn, companyNumber: null, charityNumber: null, tradingName: providerName,
                address: new OrgSupplementaryAddress { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode });

            string expectedAddressNotificationMessage = $"Address has been updated for provider {ukprn} ({providerName})";

            // Act           
            IReadOnlyCollection<string> messages = OrgChangeDataComparer.GetNotificationMessages(orgSupplementaryDataExtended);

            // Assert
            Assert.AreEqual(1, messages.Count, "Incorrect number of notification messages were returned");
            Assert.AreEqual(expectedAddressNotificationMessage, messages.First(), "Address change message was not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_GetNotificationMessages_ForOrgSupplementaryDataExtended_ShouldreturnCompanyNumberMessageAndCharityNumberMessagesAndAddressMessage()
        {
            // Arrange
            const string providerName = "ProviderName";
            const int ukprn = 88888888;

            const string companyNumberUpdated = "UPDATEDCompanyNumber";
            const string charityNumberUpdated = "UPDATEDCharityNumber";
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";

            OrgSupplementaryDataExtended orgSupplementaryDataExtended =
                new OrgSupplementaryDataExtended(ukprn: ukprn, companyNumber: companyNumberUpdated, charityNumber: charityNumberUpdated, tradingName: providerName,
                    address: new OrgSupplementaryAddress { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode });

            string expectedCompanyNumberNotificationMessage = $"Company Number has been updated for provider {ukprn} ({providerName})";
            string expectedCharityNumberNotificationMessage = $"Charity Number has been updated for provider {ukprn} ({providerName})";
            string expectedAddressNotificationMessage = $"Address has been updated for provider {ukprn} ({providerName})";

            // Act           
            IReadOnlyCollection<string> messages = OrgChangeDataComparer.GetNotificationMessages(orgSupplementaryDataExtended);

            // Assert
            Assert.AreEqual(3, messages.Count, "Incorrect number of notification messages were returned");
            Assert.IsTrue(messages.Any(str => str.Contains(expectedCompanyNumberNotificationMessage)), "Company number change message was not correct");
            Assert.IsTrue(messages.Any(str => str.Contains(expectedCharityNumberNotificationMessage)), "Charity number change message was not correct");
            Assert.IsTrue(messages.Any(str => str.Contains(expectedAddressNotificationMessage)), "Address change message was not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_GetNotificationMessages_ForOrgSupplementaryDataExtended_ShouldreturnNoNotificationMessages_WhenObjectHaveNullValues()
        {
            // Arrange
            const string providerName = "ProviderName";
            const int ukprn = 88888888;
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";

            OrgSupplementaryDataExtended orgSupplementaryDataExtended = new OrgSupplementaryDataExtended(ukprn: ukprn, companyNumber: null, charityNumber: null, tradingName: providerName,
                address: new OrgSupplementaryAddress { Line1 = null, Line2 = null, Line3 = null, Line4 = null, Town = null, County = null, Postcode = null });

            // Act           
            IReadOnlyCollection<string> messages = OrgChangeDataComparer.GetNotificationMessages(orgSupplementaryDataExtended);

            // Assert
            Assert.AreEqual(0, messages.Count, "Incorrect number of notification messages were returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_GetNotificationMessages_ForTwoOrganisationEntities_ShouldReturnTwoMessages_WhenStatusAndNameChanged()
        {
            // arrange
            string originalName = "NACRO";
            int ukprn = 12345678;
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";
            Address orgAddress = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };

            var originalOrg = new Organisation
            {
                TradingName = originalName,
                Type = "PRI/LBG/NSC (Use of Limited exemption)",
                Status = "Active",
                Ukprn = ukprn,
                Address = orgAddress
            };

            var modifiedOrg = new Organisation
            {
                TradingName = "CHANGEDNAME",
                Type = "PRI/LBG/NSC (Use of Limited exemption)",
                Status = "Dissolved",
                Ukprn = ukprn,
                Address = orgAddress
            };

            string expectedNameChangeMessage = $"Name has been updated for provider {ukprn} ({originalName})";
            string expectedStatusChangeMessage = $"Status has been updated to Dissolved for provider {ukprn} ({originalName})";

            // act
            IReadOnlyCollection<string> messages =
                OrgChangeDataComparer.GetNotificationMessages(originalOrg, modifiedOrg);

            // assert
            Assert.AreEqual(2, messages.Count, "Incorrect number of notification messages were returned");
            Assert.IsTrue(messages.Any(msg => msg.Contains(expectedNameChangeMessage)), "Name change message was incorrect");
            Assert.IsTrue(messages.Any(msg => msg.Contains(expectedStatusChangeMessage)), "Status change message was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_GetNotificationMessages_ForTwoOrganisationEntities_ShouldReturnNameChangeMessageOnly_WhenOnlyNameChanged()
        {
            // arrange
            string originalName = "NACRO";
            int ukprn = 12345678;
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";
            Address orgAddress = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };

            var originalOrg = new Organisation
            {
                TradingName = originalName,
                Type = "PRI/LBG/NSC (Use of Limited exemption)",
                Status = "Active",
                Ukprn = ukprn,
                Address = orgAddress
            };

            var modifiedOrg = new Organisation
            {
                TradingName = "CHANGEDNAME",
                Type = "PRI/LBG/NSC (Use of Limited exemption)",
                Status = "Active",
                Ukprn = ukprn,
                Address = orgAddress
            };

            string expectedNameChangeMessage = $"Name has been updated for provider {ukprn} ({originalName})";

            // act
            IReadOnlyCollection<string> messages =
                OrgChangeDataComparer.GetNotificationMessages(originalOrg, modifiedOrg);

            // assert
            Assert.AreEqual(1, messages.Count, "Incorrect number of notification messages were returned");
            Assert.IsNotNull(messages.FirstOrDefault(msg => msg.Contains(expectedNameChangeMessage)), "Name change message was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_GetNotificationMessages_ForTwoOrganisationEntities_ShouldReturnStatusChangeMessageOnly_WhenOnlyStatusChanged()
        {
            // arrange
            string originalName = "NACRO";
            int ukprn = 12345678;
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";
            Address orgAddress = new Address { Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode };


            var originalOrg = new Organisation
            {
                TradingName = originalName,
                Type = "PRI/LBG/NSC (Use of Limited exemption)",
                Status = "Active",
                Ukprn = ukprn,
                Address = orgAddress
            };

            var modifiedOrg = new Organisation
            {
                TradingName = originalName,
                Type = "PRI/LBG/NSC (Use of Limited exemption)",
                Status = "Dissolved",
                Ukprn = ukprn,
                Address = orgAddress
            };

            string expectedStatusChangeMessage = $"Status has been updated to Dissolved for provider {ukprn} ({originalName})";

            // act
            IReadOnlyCollection<string> messages =
                OrgChangeDataComparer.GetNotificationMessages(originalOrg, modifiedOrg);

            // assert
            Assert.AreEqual(1, messages.Count, "Incorrect number of notification messages were returned");
            Assert.IsNotNull(messages.FirstOrDefault(msg => msg.Contains(expectedStatusChangeMessage)), "Status change message was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgChangeDataComparer_GetNotificationMessages_ForTwoOrganisationEntities_ShouldReturnNoNotificationMessages_WhenObjectContentsAreTheSame()
        {
            // arrange
            string originalName = "NACRO";
            int ukprn = 12345678;
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";
            
            Address orgAddress = new Address {Line1 = line1, Line2 = line2, Line3 = line3, Line4 = line4, Town = town, County = county, Postcode = postcode};
            var originalOrg = new Organisation
            {
                TradingName = originalName,
                Type = "PRI/LBG/NSC (Use of Limited exemption)",
                Status = "Active",
                Ukprn = ukprn,
                Address = orgAddress
            };

            var modifiedOrg = new Organisation
            {
                TradingName = "NACRO",
                Type = "PRI/LBG/NSC (Use of Limited exemption)",
                Status = "Active",
                Ukprn = ukprn,
                Address = orgAddress
            };

            // act
            IReadOnlyCollection<string> messages =
                OrgChangeDataComparer.GetNotificationMessages(originalOrg, modifiedOrg);

            // assert
            Assert.AreEqual(0, messages.Count, "Incorrect number of notification messages were returned");
        }
    }
}
