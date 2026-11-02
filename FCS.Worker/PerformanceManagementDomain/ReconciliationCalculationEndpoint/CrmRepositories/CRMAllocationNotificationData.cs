namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.CrmRepositories
{
    public class CRMAllocationNotificationData
    {
        public CRMAllocationNotificationData(string fundingStreamName, string allocationNumber, int contractVersionNumber, int ukprn, string providerLegalName)
        {
            FundingStreamName = fundingStreamName;
            AllocationNumber = allocationNumber;
            ContractVersionNumber = contractVersionNumber;
            Ukprn = ukprn;
            ProviderLegalName = providerLegalName;
        }

        public string AllocationNumber { get; }

        public string FundingStreamName { get; }

        public int ContractVersionNumber { get; }

        public int Ukprn { get; }

        public string ProviderLegalName { get; }

        public string CreateNotificationName()
        {
            return $"Amendment Approval-Allocation {AllocationNumber} - {FundingStreamName}";
        }

        public string CreateNotificationText()
        {
            return $"{AllocationNumber} v{ContractVersionNumber} ({Ukprn}: {ProviderLegalName}) approved";
        }
    }
}