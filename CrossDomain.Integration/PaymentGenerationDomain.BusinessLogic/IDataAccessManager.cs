namespace PaymentGenerationDomain.BusinessLogic
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Integration.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using PaymentGenerationDomain.Integration.DataStore.Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IDataAccessManager
    {
        IReadOnlyCollection<PaymentTimetable> GetPaymentTimetableByDateAndStatus(DateTime date, string status, ConnectionInfo connectionInfo);

        void UpdateTimetableStatusForPaymentRun(
            string fundingStreamPeriodCode,
            string calendarPeriod,
            ConnectionInfo connectionInfo);

        void UpdateTimetableStatusForFailedPaymentRun(
            string fundingStreamPeriodCode,
            string calendarPeriod,
            ConnectionInfo connectionInfo);

        void UpdateTimetableForCompletedPaymentRun(
            string fundingStreamPeriodCode,
            string calendarPeriod, 
            string linkCode,
            ConnectionInfo connectionInfo);

        IReadOnlyCollection<SubnominalAggregation> UpdatePaymentsToPostedForPaymentRun(
            string fundingStreamPeriodCode,
            string calendarPeriod,
            ConnectionInfo connectionInfo);

        void AddOrUpdateSubnominalAggregations(List<SubnominalAggregation> subnominalAggregationsToAdd, ConnectionInfo connectionInfo);

        string GetFundingStreamPeriodCodeFromShortCode(
            string fundingStreamShortCode, 
            DateTime periodStartDate,
            DateTime periodEndDate,
            ConnectionInfo connectionInfo);

        IReadOnlyCollection<SubnominalAggregation> GetPaymentsForPaymentRun(
            string fundingStreamPeriodCode, 
            string calendarPeriod,
            ConnectionInfo connectionInfo);

        bool IsPaymentPosted(string subnominalCode, AggregationPaymentType paymentType, string allocationNumber, string fundingStreamPeriodCode, string calendarPeriod,
            ConnectionInfo connectionInfo);

        string GetCalendarPeriodForPaymentTimetableFspAndCensusEndDate(
            string fundingStreamPeriodCode,
            DateTime censusEndDate,
            ConnectionInfo connectionInfo);

        IReadOnlyCollection<SubnominalAggregationDto> UpdateAndGetPaymentsForPaymentRun(
            string fundingStreamPeriodCode,
            string calendarPeriod,
            ConnectionInfo connectionInfo);
    }
}