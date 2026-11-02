namespace FCT.Console.Config.Extraction.Crm
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Metadata;
    using MoreLinq;

    public class CrmValueExtractor
    {
        private static List<OptionFieldKeyValue> _cachedOptionSetValues;

        public CrmValueExtractor()
        {
            _cachedOptionSetValues = new List<OptionFieldKeyValue>();
        }

        public string GetOptionSetValueLabel(string entityName, string fieldName, int optionSetValue, IOrganizationService service)
        {
            if (_cachedOptionSetValues.Any(okv => okv.EntityName == entityName && okv.FieldName == fieldName))
            {
                return
                    _cachedOptionSetValues.SingleOrDefault(
                        okv => okv.EntityName == entityName && okv.FieldName == fieldName)?.Options[optionSetValue];
            }

            var attReq = new RetrieveAttributeRequest
            {
                EntityLogicalName = entityName,
                LogicalName = fieldName,
                RetrieveAsIfPublished = true
            };

            var attResponse = (RetrieveAttributeResponse) service.Execute(attReq);
            var attMetadata = (EnumAttributeMetadata) attResponse.AttributeMetadata;
            string label = attMetadata.OptionSet.Options.FirstOrDefault(x => x.Value == optionSetValue)?
                .Label.UserLocalizedLabel.Label;

            OptionFieldKeyValue keyValue = new OptionFieldKeyValue
            {
                EntityName = entityName,
                FieldName = fieldName
            };

            Dictionary<int, string> options = new Dictionary<int, string>();

            attMetadata.OptionSet.Options.ForEach(o => options.Add((int)o.Value, o.Label.UserLocalizedLabel.Label));

            keyValue.Options = options;

            _cachedOptionSetValues.Add(keyValue);

            return label;
        }

        private class OptionFieldKeyValue
        {
            public string EntityName { get; set; }

            public string FieldName { get; set; }

            public Dictionary<int, string> Options { get; set; }
        }
    }
}