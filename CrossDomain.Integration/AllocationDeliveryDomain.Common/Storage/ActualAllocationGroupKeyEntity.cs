namespace SFA.FCT.AllocationDeliveryDomain.Common.Storage
{
    using System.Text;
    using Microsoft.WindowsAzure.Storage.Table;

    public class ActualAllocationGroupKeyEntity : TableEntity, IAzureEntity
    {
        public string TableName
        {
            get { return "ActualAllocationGroupEntity"; }
        }

        public string EntityPartitionKey
        {
            get { return CollectionType + "_" + CollectionReturnCode; }
        }

        public string EntityRowKey { get; set; }
        
        public string CollectionType { get; set; }

        public string CollectionReturnCode { get; set; }

        private string CompositeKey
        {
            get { return EntityPartitionKey + EntityRowKey; }
        }

        public static ActualAllocationGroupKeyEntity CreateFromReportedActual(ReportedActual reportedActual)
        {
            ActualAllocationGroupKeyEntity groupKeyEntity = new ActualAllocationGroupKeyEntity();
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(reportedActual.OrganisationId);
            stringBuilder.Append(reportedActual.FundingStreamPeriodCode);
            stringBuilder.Append(reportedActual.UoPCode);

            groupKeyEntity.CollectionReturnCode = reportedActual.CollectionReturnCode;
            groupKeyEntity.CollectionType = reportedActual.CollectionType;
            groupKeyEntity.EntityRowKey = stringBuilder.ToString();

            return groupKeyEntity;
        }

        public override bool Equals(object other)
        {
            ActualAllocationGroupKeyEntity otherKey = other as ActualAllocationGroupKeyEntity;
            if (otherKey != null)
            {
                return otherKey.CompositeKey.Equals(CompositeKey);
            }

            return false;
        }

        public override int GetHashCode()
        {
            return CompositeKey.GetHashCode();
        }
    }
}
