namespace FCT.Console.Config.Extraction.Crm
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using Microsoft.Xrm.Sdk;
    using Synchronizers.Writers.CRM;

    public static class CrmEntityTransformer
    {
        public static string TransformEntitiesToCsv(CrmEntityRows crmEntityRows)
        {
            StringBuilder sb = new StringBuilder();
            CrmValueExtractor crmValueExtractor = new CrmValueExtractor();

            //Entity firstEntity = entityRows.Entities.First();

            // CF: Removed the where as it causes some columns which may not be populated for the first entity to not feature at all on the extract.
            IReadOnlyCollection<KeyValuePair<string, string>> columnLabelsToInclude = crmEntityRows.ColumnLabels.ToList();
                //.Where(c => firstEntity.Attributes.Keys.Contains(c.Key)).ToList();

            IEnumerable<string> physicalColumnNames = columnLabelsToInclude.Select(c => c.Key).ToList();

            IEnumerable<string> headerColumns = columnLabelsToInclude.Select(c => c.Value);

            sb.AppendLine(string.Join(",", headerColumns));

            foreach (Entity entity in crmEntityRows.Entities)
            {
                IList<string> values = new List<string>();
                foreach (var physicalColumnName in physicalColumnNames)
                {
                    if (entity.Attributes.Contains(physicalColumnName))
                    {
                        object columnValue = entity.Attributes[physicalColumnName];
                        switch (columnValue)
                        {
                            case EntityReference entityRef:
                                values.Add(QuoteValueAsNecessary(entityRef.Name));
                                break;
                            case OptionSetValue osv:
                                string associatedKey = physicalColumnName;
                                values.Add(crmValueExtractor.GetOptionSetValueLabel(entity.LogicalName, associatedKey,
                                    osv.Value, CrmHelper.GetConnection()));
                                break;
                            case DateTime dt:
                                values.Add(dt.ToString("yyyy-MM-dd HH:mm:ss"));
                                break;
                            default:
                                values.Add(QuoteValueAsNecessary(columnValue.ToString()));
                                break;
                        }
                    }
                    else
                    {
                        values.Add(string.Empty);
                    }
                }
                
                sb.AppendLine(string.Join(",", values));
            }

            return sb.ToString();
        }

        private static string QuoteValueAsNecessary(string value)
        {
            return value.Contains(",") ? $"\"{value}\"" : value;
        }
    }
}