namespace ContractManagementDomain.Endpoint.Xrm.ContractNotification.Dtos
{
    public class ProviderInfo
    {
        public ProviderInfo(string name, string ukprn)
        {
            ProviderName = name;
            Ukprn = ukprn;
        }

        public string ProviderName { get; }

        public string Ukprn { get; }
    }
}