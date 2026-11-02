namespace SFA.FCT.Contracts.AcceptanceTests.Extensions
{
    using Microsoft.Xrm.Sdk;

    public static class EntityExtensions
    {
        public static string GetAttributeStringValue(this Entity entity, string attributeName)
        {
            if (entity.Attributes.ContainsKey(attributeName))
            {
                return entity.GetAttributeValue<string>(attributeName);
            }
            
            return string.Empty;
        }

        public static string GetAttributeAliasedStringValue(this Entity entity, string attributeName)
        {
            if (entity.Attributes.ContainsKey(attributeName))
            {
                return entity.GetAttributeValue<AliasedValue>(attributeName).Value.ToString();
            }

            return string.Empty;
        }

        public static T GetAttributeOrDefault<T>(this Entity entity, string attributeName, T defaultValue)
        {
            if (entity.Attributes.ContainsKey(attributeName))
            {
                return entity.GetAttributeValue<T>(attributeName);
            }

            return defaultValue;
        }
    }
}
