namespace DedsClient.Dtos
{
    public class ReportedActual
    {
        /// <summary>
        /// e.g. EopR1
        /// </summary>
        public string CollectionReturnCode { get; set; }

        public string OrganisationId { get; set; }

        public string PeriodTypeCode { get; set; }

        /// <summary>
        /// e.g. 201308
        /// </summary>
        public string Period { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        /// <summary>
        /// e.g. 24ALLF
        /// </summary>
        public string CollectionType { get; set; }

        public string ContractAllocationNumber { get; set; }

        public string UoPCode { get; set; }

        public string DeliverableCode { get; set; }

        public long ActualVolume { get; set; }

        public decimal ActualValue { get; set; }
    }
}
