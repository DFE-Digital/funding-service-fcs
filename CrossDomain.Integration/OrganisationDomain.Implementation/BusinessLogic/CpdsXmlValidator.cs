namespace OrganisationDomain.Implementation.BusinessLogic
{
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.IO;
    using System.Linq;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using System.Xml.Serialization;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Organisation;

    public class CpdsXmlValidator : ICpdsXmlValidator
    {
        private const string CodeTypeLookup = "91";
        private const string CodeTypeExternalStatus = "EXTSTATUS";
        private const string CodeValueLookup = "214";
        private const string CodeValueName = "ES_ACTIVE";
        private const string organisationSchemaNamespace = "urn:sfa:schemas:organisation";
        private const string organisationCorporateSchemaResourceName = "SFA.FCT.CrossDomain.Integration.Entities.Organisation.organisation_corporate_schema.xsd";
        private readonly XNamespace _ns = "http://xpims.lsc.gov.uk/ProviderDataSetV2";

        public static Stream GetOrganisationCorporateSchemaXsdFile()
        {
            return typeof(OrganisationExtensions).Assembly.GetManifestResourceStream(organisationCorporateSchemaResourceName);
        }

        [SuppressMessage("ReSharper", "PossibleNullReferenceException")]
        public bool HasMultipleActiveProvidersWithTheSameUkprn(XDocument cpdsXml)
        {
            var activeProviders = cpdsXml.Root.Elements(_ns + "Provider").Where(ProviderHasAnActiveStatusCodeElement);
            return activeProviders.Count() > 1;
        }

        [SuppressMessage("ReSharper", "PossibleNullReferenceException")]
        public bool ProviderHasAnActiveStatusCodeElement(XElement provider)
        {
            return provider.Descendants(_ns + "Codes")
                .Any(codes => codes.Element(_ns + "CodeType").Attribute("id").Value == CodeTypeLookup
                              && codes.Element(_ns + "CodeType").Element(_ns + "CodeType").Value == CodeTypeExternalStatus
                              && codes.Element(_ns + "CodeValue").Attribute("id").Value == CodeValueLookup
                              && codes.Element(_ns + "CodeValue").Element(_ns + "CodeValueName").Value == CodeValueName);
        }

        [SuppressMessage("ReSharper", "PossibleNullReferenceException")]
        public bool ProviderHasANumericUpin(XElement provider)
        {
            int number;
            bool isUpinNumeric = int.TryParse(provider.Element(_ns + "Upin").Value, out number);
            return isUpinNumeric;
        }

        [SuppressMessage("ReSharper", "PossibleNullReferenceException")]
        public void RemoveProvidersThatAreNotActiveOrDoNotHaveANumericUpin(XDocument cpdsXml)
        {
            cpdsXml.Root.Elements(_ns + "Provider")
                .Where(provider => !ProviderHasAnActiveStatusCodeElement(provider) || !ProviderHasANumericUpin(provider))
                .Remove();
        }

        [SuppressMessage("ReSharper", "PossibleNullReferenceException")]
        public void RemoveProvidersThatDoNotHaveAMatchingUpin(XDocument cpdsXml, int upin)
        {
            cpdsXml.Root.Elements(_ns + "Provider")
                .Where(provider => provider.Element(_ns + "Upin").Value != upin.ToString()).Remove();
        }

        public bool IsOrganisationValidAgainstOrganisationCorporateSchema(organisation organisationToValidate, out List<OrganisationSchemaValidationError> validationErrors)
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
            bool errors = false;

            // Retrive schema embedded resource
            Stream xsdStream = GetOrganisationCorporateSchemaXsdFile();

            if (xsdStream != null)
            {
                XmlSchemaSet schemas = new XmlSchemaSet();
                // ReSharper disable once AssignNullToNotNullAttribute
                schemas.Add(organisationSchemaNamespace, new XmlTextReader(xsdStream));

                XmlSerializer serializer = new XmlSerializer(typeof(organisation));

                XDocument responseXml;
                using (MemoryStream xmlStream = new MemoryStream())
                {
                    serializer.Serialize(xmlStream, organisationToValidate);
                    xmlStream.Position = 0;
                    responseXml = XDocument.Load(xmlStream, LoadOptions.PreserveWhitespace | LoadOptions.SetLineInfo);
                }

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
            }
            else
            {
                errors = true;
                errorMessages.Add(new OrganisationSchemaValidationError
                {
                    LineNumber = 1,
                    LinePosition = 1,
                    ErrorMessage = "Could not locate organisation corporate schema file: " + organisationCorporateSchemaResourceName
                });
            }

            validationErrors.AddRange(errorMessages);
            return !errors;
        }
    }
}