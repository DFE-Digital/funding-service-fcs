namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using Pages.DTO;

    public static class XmlSchemaValidator
    {
        public static bool IsContractManagementAtomFeedItemValidXml(string corporateContractXml)
        {
            var schemaSet = GetSchemaSetToValidate();

            return IsAtomFeedItemValidXml(schemaSet, corporateContractXml);
        }

        private static XmlSchemaSet GetSchemaSetToValidate()
        {
            var schemas = new XmlSchemaSet();
            const string corporateContractSchemaResourceName =
                "SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.contract_corporate_schema_v10.07.xsd";
            const string corporateContractSchemaNamespace = "urn:sfa:schemas:contract";

            var schema =
                typeof(CrossDomain.Integration.Entities.CorporateSchema.Contract.Contract).Assembly.GetManifestResourceStream(
                    corporateContractSchemaResourceName);
            if (schema != null)
            {
                schemas = new XmlSchemaSet();
                // ReSharper disable once AssignNullToNotNullAttribute
                schemas.Add(corporateContractSchemaNamespace, new XmlTextReader(schema));
            }

            return schemas;
        }

        private static bool IsAtomFeedItemValidXml(XmlSchemaSet schemaSet, string xmlContent)
        {
            bool errors = false;

            var xDoc = XDocument.Parse(xmlContent);
            xDoc.Validate(
                schemaSet,
                (o, e) =>
                {
                    new XmlValidationError()
                    {
                        LineNumber = e.Exception.LineNumber,
                        LinePosition = e.Exception.LinePosition,
                        ErrorMessage = e.Exception.Message
                    };
                    errors = true;
                });

            return !errors;
        }
    }
}