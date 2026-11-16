namespace CrossDomain.Integration.Entities.Tests.CorporateContract
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ContractorPartialTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractorPartial_GetLegalAddressCsv_ShouldGetWhenAllFieldsPopulated()
        {
            // arrange
            Contractor contractor = new Contractor
            {
                addressLine1 = "Some Road",
                addressLine2 = "Some Village",
                addressLine3 = "Some Town",
                addressLine4 = "Some Further Classification",
                town = "Some Town",
                county = "Some County",
                postcode = "L1 3AB"
            };

            // act
            string legalAddress = contractor.GetLegalAddressCsv();

            // assert
            string expectedAddress =
                $"{contractor.addressLine1}, {contractor.addressLine2}, {contractor.addressLine3}, " +
                $"{contractor.addressLine4}, {contractor.town}, {contractor.county}, {contractor.postcode}";

            Assert.AreEqual(expectedAddress, legalAddress);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractorPartial_GetLegalAddressCsv_ShouldGetWhenSomeFieldsPopulated()
        {
            // arrange
            Contractor contractor = new Contractor
            {
                addressLine1 = "Some Road",
                addressLine3 = "Some Town",
                addressLine4 = "Some Further Classification",
                town = "Some Town",
                county = "Some County",
                postcode = "L1 3AB"
            };

            // act
            string legalAddress = contractor.GetLegalAddressCsv();

            // assert
            string expectedAddress =
                $"{contractor.addressLine1}, {contractor.addressLine3}, " +
                $"{contractor.addressLine4}, {contractor.town}, {contractor.county}, {contractor.postcode}";

            Assert.AreEqual(expectedAddress, legalAddress);
        }
    }
}
