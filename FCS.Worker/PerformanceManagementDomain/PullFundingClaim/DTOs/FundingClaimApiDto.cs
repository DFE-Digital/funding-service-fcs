namespace PerformanceManagementDomain.PullFundingClaim.DTOs
{
    using System.Collections.Generic;
    using Newtonsoft.Json;

    public class FundingClaimApiDto
    {
        [JsonProperty("fundingClaimId")]
        public string FundingClaimId { get; set; }

        [JsonProperty("organisationIdentifier")]
        public string OrganisationIdentifier { get; set; }

        [JsonProperty("ukprn")]
        public string Ukprn { get; set; }

        [JsonProperty("versionNumber")]
        public int VersionNumber { get; set; }

        [JsonProperty("claimTypeName")]
        public string ClaimTypeName { get; set; }

        [JsonProperty("periodTypeCode")]
        public string PeriodTypeCode { get; set; }

        [JsonProperty("period")]
        public string Period { get; set; }

        [JsonProperty("hasBeenSigned")]
        public string HasBeenSigned { get; set; }

        [JsonProperty("contractAllocations")]
        public List<ContractAllocationApiDto> ContractAllocations { get; set; }

        public string FcsClaimTypeName => ClaimTypeName.Replace(" ", string.Empty).ToUpper();
    }
}
