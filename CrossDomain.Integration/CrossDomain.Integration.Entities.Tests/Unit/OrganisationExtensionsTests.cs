namespace CrossDomain.Integration.Entities.Tests.Unit
{
    using System.Collections.Generic;
    using System.IO;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Organisation;

    [TestClass]
    public class OrganisationExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetOrganisationCorporateSchemaXsdFile_ReturnsEmbeddedSchema()
        {
            using (Stream stream = OrganisationExtensions.GetOrganisationCorporateSchemaXsdFile())
            {
                Assert.IsNotNull(stream);
                Assert.IsTrue(stream.Length > 0);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IsOrganisationXmlValid_EmptyOrganisation_ReturnsSchemaErrors()
        {
            var organisation = new organisation();

            bool valid = organisation.IsOrganisationXmlValid(out List<OrganisationSchemaValidationError> errors);

            Assert.IsFalse(valid);
            Assert.IsTrue(errors.Count > 0);
            Assert.IsFalse(string.IsNullOrEmpty(errors[0].ErrorMessage));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IsOrganisationXmlValid_EmptyCollections_AreNulledBeforeValidation()
        {
            var organisation = new organisation();

            organisation.IsOrganisationXmlValid(out List<OrganisationSchemaValidationError> errors);

            Assert.IsNull(organisation.organisationAddresses);
            Assert.IsNull(organisation.organisationContacts);
            Assert.IsNull(organisation.organisationLocators);
            Assert.IsNull(organisation.organisationTypeRelationships);
            Assert.IsNull(organisation.organisationStatusRelationships);
        }
    }
}