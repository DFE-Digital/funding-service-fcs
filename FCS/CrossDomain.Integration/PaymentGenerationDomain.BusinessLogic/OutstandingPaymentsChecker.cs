namespace PaymentGenerationDomain.BusinessLogic
{
    using Integration.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class OutstandingPaymentsChecker : IOutstandingPaymentsChecker
    {
        private readonly IPaymentTimetableRepository _paymentTimetableRepository;
        private readonly ISubnominalAggregationRepository _subnominalAggregationRepository;

        public OutstandingPaymentsChecker(IPaymentTimetableRepository paymentTimetableRepository, ISubnominalAggregationRepository subnominalAggregationRepository)
        {
            _paymentTimetableRepository = paymentTimetableRepository;
            _subnominalAggregationRepository = subnominalAggregationRepository;
        }

        public bool HasOutstandingPaymentsForAllocation(string fundingStreamPeriodCode, string allocationNumber, ConnectionInfo connectionInfo)
        {
            /***
             * For some FSPs we don't generate payments but we do create subnonimal aggregation rows.
             * There should be a column on the FSP table in this domain to tell use this but in the absence of this we look at the payment timetable,
             * later we might add this table column to this domain
             */
            return _paymentTimetableRepository.HasOutstandingPaymentTimetablesForFundingStreamPeriod(fundingStreamPeriodCode, connectionInfo) &&
                _subnominalAggregationRepository.HasOutstandingPaymentsForAllocation(allocationNumber, connectionInfo);
        }
    }
}
