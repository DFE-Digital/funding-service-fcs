namespace ContractCreateDomain.Endpoint
{
    using System;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [Serializable]
    public class ModifyContractSagaData //: ContainSagaData
    {
        public string ProcessId { get; set; }

        public bool IsTimeoutAlreadyScheduled { get; set; }

        public string BatchId { get; set; }

        public byte[] MashedContractRequest { get; set; }

        public byte[] ExtendedCorporateContract { get; set; }

        public byte[] ContractsToProcessHashSet { get; set; }

        public bool UpdateValueVarianceRequired { get; set; } = true;

        [JsonIgnore]
        public Func<contractType, contractType> GetContractTypeForVarianceCalculation { get; set; } = ct => ct;
    }
}
