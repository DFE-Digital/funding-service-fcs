namespace ContractCreateDomain.Endpoint
{
    using System;

    [Serializable]
    public class CreateContractSagaData
    {
        public string ProcessId { get; set; }

        public byte[] ContractRequestContract { get; set; }

        public byte[] ExtendedContractType { get; set; }

        public bool IsTimeoutAlreadyScheduled { get; set; }

        public long? DasEngagementEventId { get; set; }

        public bool ShouldReply { get; set; } = true;

        public bool AddContractAllocationNumbersOnly { get; set; }
    }
}
