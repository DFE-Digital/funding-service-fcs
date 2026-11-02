namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ReportedPaymentEnricher : IReportedPaymentEnricher
    {
        public IMonitoringDeliverableStore DeliverableStore { get; set; }

        public IReadOnlyCollection<EnrichedReportedActual> Enrich(ConnectionInfo connectionInfo, IReadOnlyCollection<ReportedActual> reportedPayments)
        {
            var enrichedReportedPayments = new List<EnrichedReportedActual>();
            var firstReportedPayment = reportedPayments.First();

            var activeAllocationDeliverablePeriods = DeliverableStore.GetActiveAllocationDeliverablePeriods(
                firstReportedPayment.OrganisationId,
                firstReportedPayment.FundingStreamPeriodCode,
                firstReportedPayment.UoPCode,
                connectionInfo);

            // If there are no active ADPs, ignore these reported payments as the allocation associated is for a closed contract
            if (activeAllocationDeliverablePeriods.Any())
            {
                AutoMapper.Mapper.CreateMap<ReportedActual, EnrichedReportedActual>();

                foreach (var reportedPayment in reportedPayments)
                {
                    var matchingAllocationDeliverablePeriod = activeAllocationDeliverablePeriods.First();

                    var enrichedReportedPayment = AutoMapper.Mapper.Map<ReportedActual, EnrichedReportedActual>(reportedPayment);

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