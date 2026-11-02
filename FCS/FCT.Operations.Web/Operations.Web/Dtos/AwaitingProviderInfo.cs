namespace Operations.Web.Dtos
{
    using System;

    public class AwaitingProviderInfo
    {
        public AwaitingProviderInfo(string ukprn, string providerType, string providerSubType, DateTime lastParked)
        {
            Ukprn = ukprn;
            ProviderType = providerType;
            ProviderSubType = providerSubType;
            LastParked = lastParked;
        }

        public string Ukprn { get; }
        public string ProviderType { get; }
        public string ProviderSubType { get; }
        public DateTime LastParked { get; }
    }
}