namespace PerformanceManagementDomain.PullFundingClaim.DTOs
{
    using Newtonsoft.Json;

    public class DeliverableCodeApiDto
    {

        [JsonProperty("deliverableCodeValue")]
        public int DeliverableCodeValue { get; set; }

        [JsonProperty("actualVolume")]
        public int ActualVolume { get; set; }

        [JsonProperty("actualValue")]
        public decimal ActualValue { get; set; }

        [JsonProperty("forecastValue")]
        public decimal ForecastValue { get; set; }

        [JsonProperty("adjustmentValue")]
        public decimal AdjustmentValue { get; set; }

        [JsonProperty("totalDelivery")]
        public decimal TotalDelivery { get; set; }
    }
}
