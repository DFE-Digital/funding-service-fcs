namespace PerformanceManagementDomain.ReconciliationPublication.Services
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;

    public static class SchemaValidator
    {
        public static bool IsValid(string assemblyName, string schemaResource, string schemaNameSpace,
            string xmlToValidate)
        {
            XmlSchemaSet schemas = new XmlSchemaSet();
            List<string> validationErrors = new List<string>();
            using (Stream stream = Assembly.LoadFrom(assemblyName).GetManifestResourceStream(schemaResource))
            {
                schemas.Add(schemaNameSpace, new XmlTextReader(stream));
            }

            // act
            XDocument
                .Parse(xmlToValidate, LoadOptions.PreserveWhitespace | LoadOptions.SetLineInfo)
                .Validate(schemas, (sender, e) => validationErrors.Add($"Error: {e.Exception.Message} at line {e.Exception.LineNumber}"));

            return !validationErrors.Any();
        }
    }
}
