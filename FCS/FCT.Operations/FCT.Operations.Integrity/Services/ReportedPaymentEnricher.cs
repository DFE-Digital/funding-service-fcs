namespace SFA.FCT.Operations.Integrity.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDeliveryDomain.Common.DataStore.Model;
    using AllocationDeliveryDomain.Common.Storage;
    using Repositories;
    using SFA.FCT.Operations.Integrity.Extensions;

    /// <remarks>
    /// Local replica of NSB 7 AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Services.ReportedPaymentEnricher
    /// </remarks>
    public class ReportedPaymentEnricher
    {
        private readonly IAllocationDeliverablePeriodRepository _allocationDeliverablePeriodRepository;

        public ReportedPaymentEnricher(IAllocationDeliverablePeriodRepository allocationDeliverablePeriodRepository)
        {
            _allocationDeliverablePeriodRepository = allocationDeliverablePeriodRepository;
        }

        public IReadOnlyCollection<EnrichedReportedActual> Enrich(IList<ReportedActual> reportedPayments)
        {
            List<EnrichedReportedActual> enrichedReportedPayments = new List<EnrichedReportedActual>();
            ReportedActual firstReportedPayment = reportedPayments.First();

            IReadOnlyCollection<AllocationDeliverablePeriod> activeAllocationDeliverablePeriods = 
                _allocationDeliverablePeriodRepository.GetActiveAllocationDeliverablePeriods(
                    firstReportedPayment.OrganisationId,
                    firstReportedPayment.FundingStreamPeriodCode,
                    firstReportedPayment.UoPCode);

            // If there are no active ADPs, ignore these reported payments as the allocation associated is for a closed contract
            if (activeAllocationDeliverablePeriods.Any())
            {
               

                foreach (ReportedActual reportedPayment in reportedPayments)
                {
                    AllocationDeliverablePeriod matchingAllocationDeliverablePeriod = activeAllocationDeliverablePeriods.First();

                    EnrichedReportedActual enrichedReportedPayment = reportedPayment.ToEnrichedReportedActualFromReportedActual();

                    enrichedReportedPayment.ContractNumber = matchingAllocationDeliverablePeriod.ContractNumber;
                    enrichedReportedPayment.ContractVersion = matchingAllocationDeliverablePeriod.ContractVersionNumber;
                    enrichedReportedPayment.ContractSubVersion = matchingAllocationDeliverablePeriod.ContractSubVersionNumber;
                    enrichedReportedPayment.ContractAllocationNumber = matchingAllocationDeliverablePeriod.ContractAllocationNumber;
                    enrichedReportedPayment.AllocationStartDate = matchingAllocationDeliverablePeriod.AllocationStartDate;
                    enrichedReportedPayment.AllocationEndDate = matchingAllocationDeliverablePeriod.AllocationEndDate.GetValueOrDefault();
                    enrichedReportedPayment.Ukprn = matchingAllocationDeliverablePeriod.Ukprn;
                    enrichedReportedPayment.EnrichedDeliverableCode = enrichedReportedPayment.DeliverableCode;

                    // Add result to the list
                    enrichedReportedPayments.Add(enrichedReportedPayment);
                }
            }

            return enrichedReportedPayments;
        }
    }
}
