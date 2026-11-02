namespace Operations.Web.Dtos
{
    public class ProviderTypeSubtypeInfo
    {
        public ProviderTypeSubtypeInfo(string cfsFundingPeriod, string providerType, string providerSubType)
        {
            CfsFundingPeriod = cfsFundingPeriod;
            ProviderType = providerType;
            ProviderSubType = providerSubType;
        }

        public string CfsFundingPeriod { get; }
        public string ProviderType { get; }
        public string ProviderSubType { get; }
    }
}