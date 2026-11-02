namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Services
{
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;

    public static class SummarisedActualTransformer
    {
        public static ReportedActual ToReportedActual(SummarisedActual summarisedActual)
        {
            return new ReportedActual
            {
                CollectionType = summarisedActual.CollectionType,
                CollectionReturnCode = summarisedActual.CollectionReturnCode,
                OrganisationId = summarisedActual.OrganisationId,
                FundingStreamPeriodCode = summarisedActual.FundingStreamPeriodCode,
                UoPCode = summarisedActual.UopCode,
                ContractAllocationNumber = summarisedActual.ContractAllocationNumber,
                Period = summarisedActual.Period.ToString(),
                DeliverableCode = summarisedActual.DeliverableCode.ToString(),
                ActualVolume = summarisedActual.ActualVolume ?? 0,
                ActualValue = decimal.ToDouble(summarisedActual.ActualValue),
                PeriodTypeCode = "CM"
            };
        }
    }
}
