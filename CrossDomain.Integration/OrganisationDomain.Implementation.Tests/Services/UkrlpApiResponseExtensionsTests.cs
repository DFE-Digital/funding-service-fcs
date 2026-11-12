namespace OrganisationDomain.Implementation.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Implementation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class UkrlpApiResponseExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ToOrgSupplementaryDataServiceResult_NullList_ReturnsUnsuccessfulResult()
        {
            List<ProviderRecord> providers = null;

            var result = providers.ToOrgSupplementaryDataServiceResult();

            Assert.IsFalse(result.IsSuccessful);
            Assert.IsNull(result.CompanyRegNumber);
            Assert.IsNull(result.CharityNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ToOrgSupplementaryDataServiceResult_EmptyList_ReturnsUnsuccessfulResult()
        {
            var result = new List<ProviderRecord>().ToOrgSupplementaryDataServiceResult();

            Assert.IsFalse(result.IsSuccessful);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ToOrgSupplementaryDataServiceResult_UsesFirstProviderAndMapsDetailsAndAddress()
        {
            var providers = new List<ProviderRecord>
            {
                BuildProvider("10000001", "12345678", "CH1"),
                BuildProvider("10000002", "99999999", "CH2")
            };

            var result = providers.ToOrgSupplementaryDataServiceResult();

            Assert.IsTrue(result.IsSuccessful);
            Assert.AreEqual("12345678", result.CompanyRegNumber);
            Assert.AreEqual("CH1", result.CharityNumber);
            Assert.AreEqual("1 High St", result.LegalAddress.Line1);
            Assert.AreEqual("Line2", result.LegalAddress.Line2);
            Assert.AreEqual("Line3", result.LegalAddress.Line3);
            Assert.AreEqual("Line4", result.LegalAddress.Line4);
            Assert.AreEqual("Town", result.LegalAddress.Town);
            Assert.AreEqual("County", result.LegalAddress.County);
            Assert.AreEqual("AB1 2CD", result.LegalAddress.Postcode);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ToOrgSupplementaryDataServiceResult_NoLegalAddressOrVerificationDetails_ReturnsNullValues()
        {
            var providers = new List<ProviderRecord> { new ProviderRecord { UKPRN = "10000001" } };

            var result = providers.ToOrgSupplementaryDataServiceResult();

            Assert.IsTrue(result.IsSuccessful);
            Assert.IsNull(result.CompanyRegNumber);
            Assert.IsNull(result.CharityNumber);
            Assert.IsNull(result.LegalAddress.Line1);
            Assert.IsNull(result.LegalAddress.Postcode);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ToOrgSupplementaryDataCollection_NullOrEmpty_ReturnsEmptyCollection()
        {
            List<ProviderRecord> providers = null;

            Assert.AreEqual(0, providers.ToOrgSupplementaryDataCollection().Count);
            Assert.AreEqual(0, new List<ProviderRecord>().ToOrgSupplementaryDataCollection().Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ToOrgSupplementaryDataCollection_MapsEveryProvider()
        {
            var providers = new List<ProviderRecord>
            {
                BuildProvider("10000001", "12345678", "CH1"),
                BuildProvider("10000002", "87654321", "CH2")
            };

            var result = providers.ToOrgSupplementaryDataCollection().ToList();

            Assert.AreEqual(2, result.Count);
            Assert.AreEqual(10000001, result[0].Ukprn);
            Assert.AreEqual("12345678", result[0].CompanyNumber);
            Assert.AreEqual("CH1", result[0].CharityNumber);
            Assert.AreEqual("1 High St", result[0].LegalAddress.Line1);
            Assert.AreEqual("AB1 2CD", result[0].LegalAddress.Postcode);
            Assert.AreEqual(10000002, result[1].Ukprn);
            Assert.AreEqual("87654321", result[1].CompanyNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ToOrgSupplementaryDataCollection_ProviderWithoutAddress_MapsEmptyAddress()
        {
            var providers = new List<ProviderRecord> { new ProviderRecord { UKPRN = "10000003" } };

            var result = providers.ToOrgSupplementaryDataCollection().Single();

            Assert.IsNull(result.CompanyNumber);
            Assert.IsNotNull(result.LegalAddress);
            Assert.IsNull(result.LegalAddress.Line1);
        }

        private static ProviderRecord BuildProvider(string ukprn, string companyNumber, string charityNumber)
        {
            return new ProviderRecord
            {
                UKPRN = ukprn,
                LegalAddress = new LegalAddress
                {
                    Address1 = "1 High St",
                    Address2 = "Line2",
                    Address3 = "Line3",
                    Address4 = "Line4",
                    Town = "Town",
                    County = "County",
                    Postcode = "AB1 2CD"
                },
                VerificationDetails = new List<VerificationDetail>
                {
                    new VerificationDetail { VerificationAuthority = "OTHER", VerificationID = "X" },
                    new VerificationDetail { VerificationAuthority = "COMPANY", VerificationID = companyNumber },
                    new VerificationDetail { VerificationAuthority = "CHARITY", VerificationID = charityNumber }
                }
            };
        }
    }
}
