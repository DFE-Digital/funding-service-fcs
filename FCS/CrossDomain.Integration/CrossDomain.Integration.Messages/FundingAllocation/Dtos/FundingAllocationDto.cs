namespace SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos
{
    using System;
    using System.Collections.Generic;

    public class FundingAllocationDto
    {
        public string FundingId { get; set; }

        public string FundingVersion { get; set; }

        public string FundingType { get; set; }

        public string Period { get; set; }

        public string ContractType { get; set; }

        public string AllocationFundingStream { get; set; }

        public string FSPGroup { get; set; }

        public string UKPRN { get; set; }

        public decimal? Value { get; set; }

        public List<string> ProviderFundingIds { get; set; } = new List<string>();
        public Guid? CrmEntityId { get; set; }

        public override string ToString() => $"FundingId: {FundingId}, FundingVersion: {FundingVersion}";
    }
}
