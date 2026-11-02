namespace FundingAllocation.DataStore.Model
{
    public class ProviderTypeConfig
    {
        private ProviderTypeConfig()
        {
        }

        public ProviderTypeConfig(string type, string subtype, string category)
        {
            Type = type;
            Subtype = subtype;
            Category = category;
        }

        public string Type { get; private set; }

        public string Subtype { get; private set; }

        public string Category { get; private set; }
    }
}