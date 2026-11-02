namespace OrganisationDomain.Integration.MainEndpoint.Tests.Extensions
{
    using Entities;
    using MainEndpoint.Extensions;
    using Messages.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class OrgSupplementaryAddressExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void OrgSupplementaryAddressExtensions_ToDtoAddress_ShouldCorrectlyTransformAddressToDtoAddress()
        {
            // arrange
            const string line1 = "line1";
            const string line2 = "line2";
            const string line3 = "line3";
            const string line4 = "line4";
            const string town = "town";
            const string county = "county";
            const string postcode = "postcode";

            var orgSupplementaryAddress = new OrgSupplementaryAddress
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
            OrgSupplementaryAddressDto assertOrgSupplementaryAddressDto = orgSupplementaryAddress.ToDtoAddress();

            // assert
            Assert.AreEqual(line1, assertOrgSupplementaryAddressDto.Line1);
            Assert.AreEqual(line2, assertOrgSupplementaryAddressDto.Line2);
            Assert.AreEqual(line3, assertOrgSupplementaryAddressDto.Line3);
            Assert.AreEqual(line4, assertOrgSupplementaryAddressDto.Line4);
            Assert.AreEqual(town, assertOrgSupplementaryAddressDto.Town);
            Assert.AreEqual(county, assertOrgSupplementaryAddressDto.County);
            Assert.AreEqual(postcode, assertOrgSupplementaryAddressDto.Postcode);
        }
    }
}