namespace PaymentGenerationDomain.BusinessLogic
{
    using System;
    using System.Collections.Generic;
    using System.Xml.Linq;
    using Integration.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;
    using PaymentGenerationDomain.Integration.DataStore.Dtos;

    public interface IPaymentCorpSchemaMapper
    {
        XDocument ToXml(PaymentPeriod paymentPeriodToConvert);

        PaymentPeriod MapSubnominalAggregationToCorpPaymentSchema(
            IReadOnlyCollection<SubnominalAggregationDto> subnominalAggregations,
            PaymentTimetable paymentTimetableDetails,
            IReadOnlyCollection<EsfAllocationData> esfAllocationData,
            string agency,
            DateTime fundingStreamPeriodStartDate,
            DateTime fundingStreamPeriodEndDate,
            string financeShortCode);
    }
}
