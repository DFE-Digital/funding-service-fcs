namespace SFA.FCT.AllocationDeliveryDomain.Common.Storage
{
    using Azure;
    using Azure.Data.Tables;
    using DataStore.Model;
    //using Microsoft.WindowsAzure.Storage.Table;
    using System.Text;

    public class ReportedActual : ITableEntity, IAzureEntity
    {
        public virtual string TableName
        {
            get { return "ReportedActual"; }
        }

        public virtual string EntityPartitionKey
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

        public string UoPCodeOrEmpty => UoPCode ?? string.Empty;

        public string DeliverableCode { get; set; }

        public long ActualVolume { get; set; }

        public double ActualValue { get; set; }

        public override string ToString()
        {
            return $"OrganisationId: {OrganisationId}, FundingStreamPeriodCode: {FundingStreamPeriodCode}, UopCode: {UoPCode}, DeliverableCode: {DeliverableCode}, Period: {Period}, ContractAllocationNumber: {ContractAllocationNumber}";
        }

        public EnrichedReportedActual ToEnrichedReportedActual(AllocationDeliverablePeriod allocationDeliverablePeriod)
        {
            return new EnrichedReportedActual
            {
                CollectionReturnCode = CollectionReturnCode,
                OrganisationId = OrganisationId,
                PeriodTypeCode = PeriodTypeCode,
                Period = Period,
                FundingStreamPeriodCode = FundingStreamPeriodCode,
                ActualValue = ActualValue,
                ActualVolume = ActualVolume,
                CollectionType = CollectionType,
                UoPCode = UoPCode,
                DeliverableCode = DeliverableCode,
                ContractNumber = allocationDeliverablePeriod.ContractNumber,
                ContractVersion = allocationDeliverablePeriod.ContractVersionNumber,
                ContractSubVersion = allocationDeliverablePeriod.ContractSubVersionNumber,
                ContractAllocationNumber = allocationDeliverablePeriod.ContractAllocationNumber,
                AllocationStartDate = allocationDeliverablePeriod.AllocationStartDate,
                AllocationEndDate = allocationDeliverablePeriod.AllocationEndDate.GetValueOrDefault(),
                DeliverablePeriodMatch = true,
                Ukprn = allocationDeliverablePeriod.Ukprn,
                EnrichedDeliverableCode = allocationDeliverablePeriod.DeliverableCode.ToString()
            };
        }

        public string PartitionKey { get; set; }
        public string RowKey { get; set; }
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }

    }
}
