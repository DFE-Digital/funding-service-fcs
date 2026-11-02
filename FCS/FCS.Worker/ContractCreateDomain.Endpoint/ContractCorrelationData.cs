namespace ContractCreateDomain.Endpoint
{
    using System;

    [Serializable]
    public class ContractCorrelationData
    {
        public ContractCorrelationData(string contractNumber)
        {
            ContractNumber = contractNumber;
            IsCompleteDocGen = false;
        }

        public string ContractNumber { get; }

        public bool IsCompleteDocGen { get; set; }

        protected bool Equals(ContractCorrelationData other)
        {
            return string.Equals(ContractNumber, other.ContractNumber);
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != GetType()) return false;
            return Equals((ContractCorrelationData)obj);
        }

        public override int GetHashCode()
        {
            return ContractNumber?.GetHashCode() ?? 0;
        }
    }
}
