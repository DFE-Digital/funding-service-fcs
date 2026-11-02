namespace SFA.FCT.Operations.Maintenance.Endpoint.Repositories
{
    using System;
    
    public class ContractReplicationFailure
    {
        public ContractReplicationFailure(string contractNumber, int contractVersion, int contractSubVersion, Guid recordId, long deleteLogVersionNumber)
        {
            ContractNumber = contractNumber;
            ContractVersion = contractVersion;
            ContractSubVersion = contractSubVersion;
            RecordId = recordId;
            DeleteLogVersionNumber = deleteLogVersionNumber;
        }

        public string ContractNumber { get; }

        public int ContractVersion { get; }

        public int ContractSubVersion { get; }

        public Guid RecordId { get; }

        public long DeleteLogVersionNumber { get; }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, ContractVersion: {ContractVersion}, ContractSubVersion: {ContractSubVersion}, RecordId: {RecordId}, DeleteLogVersionNumber: {DeleteLogVersionNumber}";
        }
    }
}
