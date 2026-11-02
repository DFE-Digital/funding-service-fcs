namespace PerformanceManagementDomain.PullFundingClaim.DTOs
{
    using System.Collections.Generic;
    using Newtonsoft.Json;

    public class ContractAllocationApiDto
    {
        [JsonProperty("contractAllocationNumber")]
        public string ContractAllocationNumber { get; set; }

        [JsonProperty("fundingStreamPeriodCode")]
        public string FundingStreamPeriodCode { get; set; }

        [JsonProperty("maximumContractValue")]
        public decimal MaximumContractValue { get; set; }

        public List<DeliverableCodeApiDto> DeliverableCodes { get; set; }
    }
}
