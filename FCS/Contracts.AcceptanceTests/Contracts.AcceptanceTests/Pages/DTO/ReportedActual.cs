namespace SFA.FCT.Contracts.AcceptanceTests.Pages.DTO
{
    using System.Text;
    using AllocationDeliveryDomain.Common.Storage;
    using Microsoft.WindowsAzure.Storage.Table;

    public class ReportedActual : TableEntity, IAzureEntity
    {
        public virtual string TableName => "ReportedActual";

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

        public virtual string EntityRowKey => $"{CollectionType}_{CollectionReturnCode}_{OrganisationId}_{FundingStreamPeriodCode}_{UoPCode}_{PeriodTypeCode}_{Period}_{DeliverableCode}_{ContractAllocationNumber}";

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

        public string CollectionReturnCode { get; set; }

        public string OrganisationId { get; set; }

        public string PeriodTypeCode { get; set; }

        public string Period { get; set; }

        public string FundingStreamPeriodCode { get; set; }

        public string CollectionType { get; set; }

        public string ContractAllocationNumber { get; set; }

        public string UoPCode { get; set; }

        public string DeliverableCode { get; set; }

        public long ActualVolume { get; set; }

        public double? ActualValue { get; set; }
    }
}
