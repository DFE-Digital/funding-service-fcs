namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos
{
    using System;
    using System.Collections.Generic;
    using Entities.CorporateContract;

    public class ContractItemsMappingResult : IEquatable<ContractItemsMappingResult>
    {
        public ContractItemsMappingResult(string fundingTypeCode, string fundingPeriodCode, string fspGroupCode, string contractType)
        {
            FundingTypeCode = fundingTypeCode;
            FundingPeriodCode = fundingPeriodCode;
            FSPGroupCode = fspGroupCode;
            ContractType = contractType;
        }

        public string FundingTypeCode { get; }
        public string FundingPeriodCode { get; }
        public string FSPGroupCode { get; }
        public string ContractType { get; }

        public override string ToString()
        {
            return $"FundingTypeCode: {FundingTypeCode}, FundingPeriodCode: {FundingPeriodCode}, FSPGroupCode: {FSPGroupCode}, ContractType: {ContractType}";
        }

        public bool Equals(ContractItemsMappingResult other)
        {
            if (ReferenceEquals(null, other)) return false;
            if (ReferenceEquals(this, other)) return true;
            return FundingTypeCode == other.FundingTypeCode && FundingPeriodCode == other.FundingPeriodCode && FSPGroupCode == other.FSPGroupCode && ContractType == other.ContractType;
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((ContractItemsMappingResult) obj);
        }

        public override int GetHashCode()
        {
            return FundingTypeCode.GetHashCode() ^ FundingPeriodCode.GetHashCode() ^ FSPGroupCode.GetHashCode() ^ ContractType.GetHashCode();
        }

        public periodTypeCodeType GetPeriodTypeCode()
        {
            List<string> allowedPeriods = new List<string>
            {
                "AY",
                "FY"
            };

            var possiblePeriod = FundingPeriodCode.Substring(0, 2);
            if (allowedPeriods.Contains(possiblePeriod))
            {
                return (periodTypeCodeType)Enum.Parse(typeof(periodTypeCodeType), possiblePeriod);
            }

            throw new InvalidOperationException($"We can't work out the period from this: {FundingPeriodCode}");
        }
    }
}
