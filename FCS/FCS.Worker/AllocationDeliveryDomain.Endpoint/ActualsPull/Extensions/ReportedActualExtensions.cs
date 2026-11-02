namespace AllocationDeliveryDomain.Endpoint.ActualsPull.Extensions
{
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;

    public static class ReportedActualExtensions
    {
        public static SummarisedActual ToSummarisedActual(this ReportedActual reportedActual)
        {
            return new SummarisedActual
            {
                CollectionType = reportedActual.CollectionType,
                CollectionReturnCode = reportedActual.CollectionReturnCode,
                ActualValue = (decimal) reportedActual.ActualValue,
                ActualVolume = (int) reportedActual.ActualVolume,
                ContractAllocationNumber = reportedActual.ContractAllocationNumber,
                DataCollectionsId = 1,
                DeliverableCode = int.Parse(reportedActual.DeliverableCode),
                FundingStreamPeriodCode = reportedActual.FundingStreamPeriodCode,
                OrganisationId = reportedActual.OrganisationId,
                Period = int.Parse(reportedActual.Period),
                UopCode = (string.IsNullOrEmpty(reportedActual.UoPCode)) ? null : reportedActual.UoPCode 
            };
        }
    }
}
