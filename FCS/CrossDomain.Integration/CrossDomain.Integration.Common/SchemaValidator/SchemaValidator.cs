namespace SFA.FCT.CrossDomain.Integration.Common.SchemaValidator
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    
    public class SchemaValidator:ISchemaValidator
    {
        public SchemaValidatorResultset ValidateAgainstSchema(string assemblyName, string schemaResource, string schemaNameSpace,
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

            return new SchemaValidatorResultset(!validationErrors.Any(), validationErrors);
        }
    }
}
