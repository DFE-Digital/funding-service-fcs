namespace OrganisationDomain.Implementation.Tests.Mappers
{
    using System;
    using System.Collections.Generic;
    using System.Xml.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using OrganisationDomain.Implementation.Mappers;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using System.Linq;
    using Integration.DataStore.Model;

    [TestClass]
    public class CpdsMapperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void MapDbEntityToCorpSchema_ShouldMapOrganisationDbEntityToOrganisationCorporateSchemaEntity()
        {
            // arrange
            var mapper = new CpdsMapper();
            const int upin = 10;
            const string companyRegNumberTest = "Test CRN";
            const string charityNumberTest = "Test CHARITY";
            const string expectedStatus = "Active";
            const string expectedProviderType = "PRI/LBG/NSC (Use of Limited exemption)";

            //act

            var organisation = mapper.MapDbEntityToCorpSchema(new Integration.DataStore.Model.Organisation
            {
                OrganisationId = 1,
                Ukprn = 50000001,
                Upin = upin,
                TradingName = "NACRO",
                CompanyRegistrationNumber = companyRegNumberTest,
                CharityNumber = charityNumberTest,
                Status = expectedStatus,
                Type = expectedProviderType,
                Address = new Address
                {
                    Line1 = "Line1",
                    Line2 = "Line2",
                    Line3 = "Line3",
                    Line4 = "Line4",
                    Town = "Town",
                    County = "County",
                    Postcode = "Postcode"
                }
            });

            //assert
            Assert.IsTrue(organisation.organisationIdentifiers.Any(orgId => orgId.organisationIdentifierType == organisationIdentifierType.UPIN), "There is no upin in the returned org");
            Assert.AreEqual(organisation.organisationIdentifiers.Single(orgId => orgId.organisationIdentifierType == organisationIdentifierType.UPIN).organisationIdentifier, upin.ToString(), "The upin in the returned org is incorrect");
            Assert.AreEqual(companyRegNumberTest, organisation.organisationIdentifiers.Single(orgId => orgId.organisationIdentifierType == organisationIdentifierType.COMPANYREGISTRATIONNUMBER).organisationIdentifier, "The company reg number in the returned org is incorrect");
            Assert.AreEqual(charityNumberTest, organisation.organisationIdentifiers.Single(orgId => orgId.organisationIdentifierType == organisationIdentifierType.CHARITYNUMBER).organisationIdentifier, "The company reg number in the returned org is incorrect");
            Assert.AreEqual(expectedStatus, organisation.organisationStatusRelationships[0].organisationStatus.organisationStatus, "The organisation status in the returned org is incorrect");
            Assert.AreEqual(expectedProviderType, organisation.organisationTypeRelationships[0].organisationType.organisationType, "The provider type in the returned org is incorrect");
            Assert.AreEqual(1, organisation.organisationAddresses.Count, "Unexpected number of addresses returned");
            Assert.AreEqual("Line1", organisation.organisationAddresses[0].addressLine1, "Unexpected Address Line1 returned");
            Assert.AreEqual("Line2", organisation.organisationAddresses[0].addressLine2, "Unexpected Address Line2 returned");
            Assert.AreEqual("Line3", organisation.organisationAddresses[0].addressLine3, "Unexpected Address Line3 returned");
            Assert.AreEqual("Line4", organisation.organisationAddresses[0].addressLine4, "Unexpected Address Line4 returned");
            Assert.AreEqual("Town", organisation.organisationAddresses[0].town, "Unexpected Address Town returned");
            Assert.AreEqual("County", organisation.organisationAddresses[0].county, "Unexpected Address County returned");
            Assert.AreEqual("Postcode", organisation.organisationAddresses[0].postcode, "Unexpected Address Postcode returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MapDbEntityToCorpSchema_ShouldNotMapEmptyAddress()
        {
            // arrange
            CpdsMapper mapper = new CpdsMapper();

            //act
            organisation organisation = mapper.MapDbEntityToCorpSchema(new Organisation
            {
                OrganisationId = 1,
                Ukprn = 50000001,
                Upin = 10,
                TradingName = "NACRO",
                CompanyRegistrationNumber = "Test CRN",
                CharityNumber = "Test CHARITY",
                Status = "Active",
                Type = "PRI/LBG/NSC (Use of Limited exemption)",
                Address = new Address()
            });

            //assert
            Assert.AreEqual(0, organisation.organisationAddresses.Count, "Unexpected number of addresses returned");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MapDbEntityToCorpSchema_ShouldNotMapCompanyRegNumberWhenCompanyRegIsNull()
        {
            // arrange
            var mapper = new CpdsMapper();
            const int upin = 10;

            //act
            var organisation = mapper.MapDbEntityToCorpSchema(new Integration.DataStore.Model.Organisation
            {
                OrganisationId = 1,
                Ukprn = 50000001,
                Upin = upin,
                TradingName = "NACRO"
            });

            //assert
            Assert.IsTrue(organisation.organisationIdentifiers.Any(orgId => orgId.organisationIdentifierType == organisationIdentifierType.UPIN), "There is no upin in the returned org");
            Assert.AreEqual(organisation.organisationIdentifiers.Single(orgId => orgId.organisationIdentifierType == organisationIdentifierType.UPIN).organisationIdentifier, upin.ToString(), "The upin in the returned org is incorrect");
            Assert.IsTrue(organisation.organisationIdentifiers.None(orgId => orgId.organisationIdentifierType == organisationIdentifierType.COMPANYREGISTRATIONNUMBER), "The company reg number is included in the xml even though it is empty");
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void MapProviderXmlToDbEntity_ShouldMapProviderXmlDocumentToOrganisationDbEntity()
        {
            //arrange
            const string response = "TestData/CpdsResponses/CpdsGetOrganisationByUkprnResponse.xml";            

            var expectedEntity = new Integration.DataStore.Model.Organisation
            {
                Ukprn = 50000001,
                TradingName = "NACRO",
                SequenceNumber = 1004069,
                CharityNumber = "UNKNOWN",
                Type = "PRI/LBG/NSC (Use of Limited exemption)",
                Status = "Active"
            };

            var mapper = new CpdsMapper();

            //act
            var entity = mapper.MapProviderXmlToDbEntity(XDocument.Load(response));

            //assert
            Assert.AreEqual(expectedEntity.TradingName, entity.TradingName, "Trading Name was not mapped.");
            Assert.AreEqual(expectedEntity.Ukprn, entity.Ukprn, "The Organisation UKPRN was not mapped.");
            Assert.AreEqual(expectedEntity.SequenceNumber, entity.SequenceNumber, "The Sequence Number was not mapped.");
            Assert.AreEqual(expectedEntity.Type, entity.Type, "The Provider Type was not mapped.");
            Assert.AreEqual(expectedEntity.Status, entity.Status, "The Organisation status was not mapped.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MapProviderXmlToDbEntity_ShouldThrowException_WhenInvalidXmlReturned()
        {
            // Arrange
            const string response = "<contract></contract>";

            var mapper = new CpdsMapper();
            
            // Act
            try
            {
                mapper.MapProviderXmlToDbEntity(XDocument.Parse(response));
                Assert.Fail();
            }
            catch (NullReferenceException)
            {
            }
        }
    }

    internal static class EnumerableExtensions
    {
        public static bool None<T>(this IEnumerable<T> items, Func<T, bool> predicate)
        {
            return !items.Any(predicate);
        }
    }
}
