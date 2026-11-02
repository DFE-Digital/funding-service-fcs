namespace SFA.FCT.CrossDomain.Integration.Entities
{
    using System.IO;
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using System.Xml;
    using System.Xml.Serialization;
    using Organisation;

    public static class OrganisationExtensions
    {
        private const string OrganisationSchemaNamespace = "urn:sfa:schemas:organisation";
        private const string OrganisationCorporateSchemaResourceName = "SFA.FCT.CrossDomain.Integration.Entities.Organisation.organisation_corporate_schema.xsd";

        public static Stream GetOrganisationCorporateSchemaXsdFile()
        {
            return typeof(OrganisationExtensions).Assembly.GetManifestResourceStream(OrganisationCorporateSchemaResourceName);
        }

        public static bool IsOrganisationXmlValid(this organisation organisationToValidate, out List<OrganisationSchemaValidationError> validationErrors)
        {
            if (!organisationToValidate.organisationAddresses.Any())
            {
                organisationToValidate.organisationAddresses = null;
            }

            if (!organisationToValidate.organisationContacts.Any())
            {
                organisationToValidate.organisationContacts = null;
            }

            if (!organisationToValidate.organisationLocators.Any())
            {
                organisationToValidate.organisationLocators = null;
            }

            if (!organisationToValidate.organisationTypeRelationships.Any())
            {
                organisationToValidate.organisationTypeRelationships = null;
            }

            if (!organisationToValidate.organisationStatusRelationships.Any())
            {
                organisationToValidate.organisationStatusRelationships = null;
            }

            validationErrors = new List<OrganisationSchemaValidationError>();

            List<OrganisationSchemaValidationError> errorMessages = new List<OrganisationSchemaValidationError>();

            // Retrieve schema embedded resource
            Stream xsdStream = GetOrganisationCorporateSchemaXsdFile();

            XmlSchemaSet schemas = new XmlSchemaSet();
            // ReSharper disable once AssignNullToNotNullAttribute
            schemas.Add(OrganisationSchemaNamespace, new XmlTextReader(xsdStream));

            XmlSerializer serializer = new XmlSerializer(typeof(organisation));
            XDocument responseXml;
            using (MemoryStream xmlStream = new MemoryStream())
            {
                serializer.Serialize(xmlStream, organisationToValidate);
                xmlStream.Position = 0;
                responseXml = XDocument.Load(xmlStream, LoadOptions.PreserveWhitespace | LoadOptions.SetLineInfo);
            }

            bool errors = false;
            responseXml.Validate(
                schemas,
                (o, e) =>
                {
                    errorMessages.Add(new OrganisationSchemaValidationError
                    {
                        LineNumber = e.Exception.LineNumber,
                        LinePosition = e.Exception.LinePosition,
                        ErrorMessage = e.Exception.Message
                    });
                    errors = true;
                });

            validationErrors.AddRange(errorMessages);
            return !errors;
        }
    }
}