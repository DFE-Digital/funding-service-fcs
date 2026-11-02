namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos
{
    public class ContractItemsMappingInput
    {
        public ContractItemsMappingInput(string allocationFundingStreamCode, string allocationPeriodId, string providerType, string providerSubType, string contractingUkprn)
        {
            AllocationFundingStreamCode = allocationFundingStreamCode;
            AllocationPeriodId = allocationPeriodId;
            ProviderType = providerType;
            ProviderSubType = providerSubType;
            ContractingUkprn = contractingUkprn;
        }

        public string AllocationFundingStreamCode { get; }
        public string AllocationPeriodId { get; }
        public string ProviderType { get; }
        public string ProviderSubType { get; }
        public string ContractingUkprn { get; }

        protected bool Equals(ContractItemsMappingInput other)
        {
            return AllocationFundingStreamCode == other.AllocationFundingStreamCode &&
                   AllocationPeriodId == other.AllocationPeriodId &&
                   ProviderType == other.ProviderType &&
                   ProviderSubType == other.ProviderSubType &&
                   ContractingUkprn == other.ContractingUkprn;
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;

            return Equals((ContractItemsMappingInput) obj);
        }

        public override int GetHashCode()
        {
            return
                AllocationFundingStreamCode.GetHashCode() ^
                AllocationPeriodId.GetHashCode() ^
                ProviderType.GetHashCode() ^
                ProviderSubType.GetHashCode() ^
                ContractingUkprn.GetHashCode();
        }

        public override string ToString() =>
            $"AllocationFundingStreamCode: {AllocationFundingStreamCode}, AllocationPeriodId: {AllocationPeriodId}, " +
            $"ProviderType: {ProviderType}, ProviderSubType: {ProviderSubType}, ContractingUkprn: {ContractingUkprn}";
    }
}
