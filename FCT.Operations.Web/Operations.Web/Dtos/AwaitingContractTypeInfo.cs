namespace Operations.Web.Dtos
{
    using System;

    public class AwaitingContractTypeInfo
    {
        public AwaitingContractTypeInfo(string ukprn, string fcsFundingType, string fcsFundingPeriod, string providerType, string providerSubType, DateTime lastParked)
        {
            FcsFundingType = fcsFundingType;
            FcsFundingPeriod = fcsFundingPeriod;
            ProviderType = providerType;
            ProviderSubType = providerSubType;
            LastParked = lastParked;
            Ukprn = ukprn;
        }

        public string Ukprn { get; } 
        public string FcsFundingType { get; }
        public string FcsFundingPeriod { get; }
        public string ProviderType { get; }
        public string ProviderSubType { get; }
        public DateTime LastParked { get; }
    }
}