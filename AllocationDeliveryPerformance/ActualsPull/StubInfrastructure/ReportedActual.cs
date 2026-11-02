namespace ActualsPull.StubInfrastructure
{
    using System.Text;
    using Microsoft.WindowsAzure.Storage.Table;

    public class ReportedActual : TableEntity
    {
        public virtual string TableName
        {
            get { return "ReportedActual"; }
        }

        public string EntityPartitionKey
        {
            get
            {
                const string delimiter = "_";
                StringBuilder stringBuilder = new StringBuilder();
                stringBuilder.Append(CollectionType);
                stringBuilder.Append(CollectionReturnCode);
                stringBuilder.Append(delimiter);
                stringBuilder.Append(AllocationGroupIdentifier);

                return stringBuilder.ToString();
            }
        }

        public virtual string EntityRowKey
        {
            get
            {
                return $"{CollectionType}_{CollectionReturnCode}_{OrganisationId}_{FundingStreamPeriodCode}_{UoPCode}_{PeriodTypeCode}_{Period}_{DeliverableCode}_{ContractAllocationNumber}";
            }
        }

        public string AllocationGroupIdentifier
        {
            get
            {
                StringBuilder stringBuilder = new StringBuilder();
                stringBuilder.Append(OrganisationId);
                stringBuilder.Append(FundingStreamPeriodCode);
                stringBuilder.Append(UoPCode);

                return stringBuilder.ToString();
            }
        }

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

        public double ActualValue { get; set; }

        public override string ToString()
        {
            return $"OrganisationId: {OrganisationId}, FundingStreamPeriodCode: {FundingStreamPeriodCode}, UopCode: {UoPCode}, DeliverableCode: {DeliverableCode}, Period: {Period}, ContractAllocationNumber: {ContractAllocationNumber}";
        }
    }
}
