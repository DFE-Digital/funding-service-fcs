namespace SFA.FCT.Contracts.AcceptanceTests.Utilities.DTO
{
    public class CdaReportComparisonObjectKey
    {
        public CdaReportComparisonObjectKey(string contractNumber, string masterContractReference,
            string contractAllocationNumber, string deliverable, string deliverableYear, string deliverablePeriod)
        {
            ContractNumber = contractNumber;
            MasterContractReference = masterContractReference;
            ContractAllocationNumber = contractAllocationNumber;
            Deliverable = deliverable;
            DeliverableYear = deliverableYear;
            DeliverablePeriod = deliverablePeriod;
        }

        public string ContractNumber { get; }

        public string MasterContractReference { get; }

        public string ContractAllocationNumber { get; }

        public string Deliverable { get; }

        public string DeliverableYear { get; }

        public string DeliverablePeriod { get; }

        protected bool Equals(CdaReportComparisonObjectKey other)
        {
            return string.Equals(ContractNumber, other.ContractNumber) &&
                   string.Equals(MasterContractReference, other.MasterContractReference) &&
                   string.Equals(ContractAllocationNumber, other.ContractAllocationNumber) &&
                   string.Equals(Deliverable, other.Deliverable) &&
                   string.Equals(DeliverableYear, other.DeliverableYear) &&
                   string.Equals(DeliverablePeriod, other.DeliverablePeriod);
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((CdaReportComparisonObjectKey) obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                var hashCode = (ContractNumber != null ? ContractNumber.GetHashCode() : 0);
                hashCode = (hashCode*397) ^
                           (MasterContractReference != null ? MasterContractReference.GetHashCode() : 0);
                hashCode = (hashCode*397) ^
                           (ContractAllocationNumber != null ? ContractAllocationNumber.GetHashCode() : 0);
                hashCode = (hashCode*397) ^ (Deliverable != null ? Deliverable.GetHashCode() : 0);
                hashCode = (hashCode*397) ^ (DeliverableYear != null ? DeliverableYear.GetHashCode() : 0);
                hashCode = (hashCode*397) ^ (DeliverablePeriod != null ? DeliverablePeriod.GetHashCode() : 0);
                return hashCode;
            }
        }

        public static bool operator ==(CdaReportComparisonObjectKey left, CdaReportComparisonObjectKey right)
        {
            return Equals(left, right);
        }

        public static bool operator !=(CdaReportComparisonObjectKey left, CdaReportComparisonObjectKey right)
        {
            return !Equals(left, right);
        }

        public override string ToString()
        {
            return
                $"ContractNumber: {ContractNumber}, MasterContractReference: {MasterContractReference}, ContractAllocationNumber: {ContractAllocationNumber}, Deliverable: {Deliverable}, DeliverableYear: {DeliverableYear}, DeliverablePeriod: {DeliverablePeriod}";
        }
    }
}