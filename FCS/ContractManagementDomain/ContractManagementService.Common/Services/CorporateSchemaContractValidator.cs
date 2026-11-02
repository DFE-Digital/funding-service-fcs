namespace SFA.FCT.ContractManagementService.Common.Services
{
    using System.IO;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;

    public static class CorporateSchemaContractValidator
    {
        public static bool IsContractXmlValid(string xml)
        {
            var xDocument = XDocument.Parse(xml);
            var schemas = new XmlSchemaSet();
            Stream xsdStream = GetCorporateSchemaXsdFile();
            schemas.Add("urn:sfa:schemas:contract", new XmlTextReader(xsdStream));

            bool isValid = true;
            try
            {
                xDocument.Validate(schemas, (o, e) =>
                {
                    isValid = false;
                });
            }
            catch (XmlSchemaValidationException)
            {
                return isValid = false;
            }

            return isValid;
        }

        private static Stream GetCorporateSchemaXsdFile()
        {
            const string corpContractSchemaResourceName = "SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.contract_corporate_schema_v11.09.xsd";

            return typeof(SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contract).Assembly.GetManifestResourceStream(corpContractSchemaResourceName);
        }
    }
}
