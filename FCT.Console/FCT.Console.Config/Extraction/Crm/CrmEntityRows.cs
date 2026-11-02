namespace FCT.Console.Config.Extraction.Crm
{
    using System.Collections.Generic;
    using Microsoft.Xrm.Sdk;

    public class CrmEntityRows
    {
        public CrmEntityRows(IReadOnlyCollection<Entity> entities, IDictionary<string, string> columnLabels)
        {
            Entities = entities;
            ColumnLabels = columnLabels;
        }

        public IReadOnlyCollection<Entity> Entities { get; }

        public IDictionary<string, string> ColumnLabels { get; }
    }
}
