namespace FCT.Operations.FundingConfirmationReport.DTOs
{
    using System.Collections.Generic;

    public class ReportRow
    {
        public ReportRow(int ukprn, string providerName, string providerType, IReadOnlyCollection<FspAllocationAndFunded> fsps)
        {
            Ukprn = ukprn;
            ProviderName = providerName;
            ProviderType = providerType;
            Fsps = fsps;
        }

        public int Ukprn { get; }
        public string ProviderName { get; }
        public string ProviderType { get; }
        public IReadOnlyCollection<FspAllocationAndFunded> Fsps { get; }
    }
}
