namespace CrossDomain.Integration.Entities.Tests.Unit
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;

    [TestClass]
    public class PaymentAggregationOrganisationTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentAggregationOrganisation_GetUkrn_ShouldGetUkprn()
        {
            const string expectedUkprn = "12345";

            // arrange
            Organisation organisation = new Organisation
            {
                MainOrganisationIdentifier = "ORG00001",
                AlternativeOrganisationIdentifiers = new List<OrgainsationIdentifier>
                {
                    new OrgainsationIdentifier
                    {
                        OrganisationId = expectedUkprn,
                        OrganisationIdentifierName = OrgainsationIdentifierOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                    }
                }
            };

            // act
            string actualUkprn = organisation.GetUkprn();

            // assert
            Assert.AreEqual(expectedUkprn, actualUkprn);
        }
    }
}
