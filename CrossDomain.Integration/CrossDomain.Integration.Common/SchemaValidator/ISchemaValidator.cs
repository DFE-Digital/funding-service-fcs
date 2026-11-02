namespace SFA.FCT.CrossDomain.Integration.Common.SchemaValidator
{
    public interface ISchemaValidator
    {
        SchemaValidatorResultset ValidateAgainstSchema(string assemblyName, string schemaResource, string schemaNameSpace,string xmlToValidate);
    }
}
