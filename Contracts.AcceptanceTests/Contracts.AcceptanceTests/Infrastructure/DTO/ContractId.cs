namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    using System;

    public class ContractId
    {
        public ContractId(Guid crmId, Guid crmMasterId, string contractNumber, int version, string masterContractNumber, Guid orgId)
        {
            CrmId = crmId;
            CrmMasterId = crmMasterId;
            ContractNumber = contractNumber;
            Version = version;
            MasterContractNumber = masterContractNumber;
            OrgId = orgId;
        }

        public Guid CrmId { get; }

        public Guid CrmMasterId { get; }

        public string ContractNumber { get; }

        public string MasterContractNumber { get; }

        public Guid OrgId { get; }

        public int Version { get; }
        public override string ToString()
        {
            return $"Contract Number: {ContractNumber} Version: {Version} MasterContractNumber: {MasterContractNumber}";
        }
    }
}
