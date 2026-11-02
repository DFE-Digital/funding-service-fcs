namespace OrganisationDomain.Integration.MainEndpoint.Tests.Extensions
{
    using Entities;
    using MainEndpoint.Extensions;
    using Messages.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class OrgSupplementaryAddressDtoExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void OrgSupplementaryAddressDtoExtensions_ToDomainAddress_ShouldCorrectlyTransformAddressToDomainAddress()
        {
            // arrange
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";

            var orgSupplementaryAddressDto = new OrgSupplementaryAddressDto
            {
                Line1 = line1,
                Line2 = line2,
                Line3 = line3,
                Line4 = line4,
                Town = town,
                County = county,
                Postcode = postcode
            };

            // act
            OrgSupplementaryAddress assertOrgSupplementaryAddress = orgSupplementaryAddressDto.ToDomainAddress();

            // assert
            Assert.AreEqual(line1, assertOrgSupplementaryAddress.Line1);
            Assert.AreEqual(line2, assertOrgSupplementaryAddress.Line2);
            Assert.AreEqual(line3, assertOrgSupplementaryAddress.Line3);
            Assert.AreEqual(line4, assertOrgSupplementaryAddress.Line4);
            Assert.AreEqual(town, assertOrgSupplementaryAddress.Town);
            Assert.AreEqual(county, assertOrgSupplementaryAddress.County);
            Assert.AreEqual(postcode, assertOrgSupplementaryAddress.Postcode);
        }
    }
}