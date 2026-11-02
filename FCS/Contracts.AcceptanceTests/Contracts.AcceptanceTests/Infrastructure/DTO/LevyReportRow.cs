namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    public class LevyReportRow
    {
        public LevyReportRow(string contractNumber, string masterContractNumber,
            int contractVersionNumber, int subVersionNumber, string ukprn, string contractStatus, string contractSubStatus)
        {
            ContractNumber = contractNumber;
            MasterContractNumber = masterContractNumber;
            Ukprn = ukprn;
            ContractVersionNumber = contractVersionNumber;
            ContractStatus = contractStatus;
            ContractSubStatus = contractSubStatus;
            SubVersionNumber = subVersionNumber;
        }

        public string ContractNumber { get; }

        public string MasterContractNumber { get; }

        public string Ukprn { get; }

        public int SubVersionNumber { get; }

        public int ContractVersionNumber { get; }

        public string ContractStatus { get; }

        public string ContractSubStatus { get; }

        protected bool Equals(LevyReportRow other)
        {
            return string.Equals(ContractNumber, other.ContractNumber)
                   && string.Equals(MasterContractNumber, other.MasterContractNumber)
                   && string.Equals(Ukprn, other.Ukprn)
                   && SubVersionNumber == other.SubVersionNumber
                   && ContractVersionNumber == other.ContractVersionNumber
                   && string.Equals(ContractStatus, other.ContractStatus)
                   && string.Equals(ContractSubStatus, other.ContractSubStatus);
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((LevyReportRow) obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                int hashCode = (ContractNumber != null ? ContractNumber.GetHashCode() : 0);
                hashCode = (hashCode * 397) ^ (MasterContractNumber != null ? MasterContractNumber.GetHashCode() : 0);
                hashCode = (hashCode * 397) ^ (Ukprn != null ? Ukprn.GetHashCode() : 0);
                hashCode = (hashCode * 397) ^ SubVersionNumber;
                hashCode = (hashCode * 397) ^ ContractVersionNumber;
                hashCode = (hashCode * 397) ^ (ContractStatus != null ? ContractStatus.GetHashCode() : 0);
                hashCode = (hashCode * 397) ^ (ContractSubStatus != null ? ContractSubStatus.GetHashCode() : 0);
                return hashCode;
            }
        }

        public override string ToString()
        {
            return
                $"ContractNumber: {ContractNumber}, MasterContractNumber: {MasterContractNumber}, Ukprn: {Ukprn}, ContractVersionNumber: {ContractVersionNumber},  SubVersionNumber: {SubVersionNumber}, ContractStatus: {ContractStatus}, ContractSubStatus: {ContractSubStatus}";
        }
    }
}