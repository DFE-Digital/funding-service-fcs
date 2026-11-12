using AutoMapper;
using System.Collections.Generic;
using System.Linq;
using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
using SFA.FCT.CrossDomain.Integration.Entities.Data;

namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Services
{
    public class ReportedPaymentEnricher : IReportedPaymentEnricher
    {
        private readonly IMapper _mapper;

        public IMonitoringDeliverableStore DeliverableStore { get; set; }

        // ✅ Inject IMapper
        public ReportedPaymentEnricher(IMapper mapper)
        {
            _mapper = mapper;
        }

        public IReadOnlyCollection<EnrichedReportedActual> Enrich(
            ConnectionInfo connectionInfo,
            IReadOnlyCollection<ReportedActual> reportedPayments)
        {
            var enrichedReportedPayments = new List<EnrichedReportedActual>();
            var firstReportedPayment = reportedPayments.First();

            var activeAllocationDeliverablePeriods =
                DeliverableStore.GetActiveAllocationDeliverablePeriods(
                    firstReportedPayment.OrganisationId,
                    firstReportedPayment.FundingStreamPeriodCode,
                    firstReportedPayment.UoPCode,
                    connectionInfo);

            if (activeAllocationDeliverablePeriods.Any())
            {
                foreach (var reportedPayment in reportedPayments)
                {
                    var matchingAllocationDeliverablePeriod =
                        activeAllocationDeliverablePeriods.First();

                    // ✅ Instance-based mapping
                    var enrichedReportedPayment =
                        _mapper.Map<EnrichedReportedActual>(reportedPayment);

                    enrichedReportedPayment.ContractNumber =
                        matchingAllocationDeliverablePeriod.ContractNumber;
                    enrichedReportedPayment.ContractVersion =
                        matchingAllocationDeliverablePeriod.ContractVersionNumber;
                    enrichedReportedPayment.ContractSubVersion =
                        matchingAllocationDeliverablePeriod.ContractSubVersionNumber;
                    enrichedReportedPayment.ContractAllocationNumber =
                        matchingAllocationDeliverablePeriod.ContractAllocationNumber;
                    enrichedReportedPayment.AllocationStartDate =
                        matchingAllocationDeliverablePeriod.AllocationStartDate;
                    enrichedReportedPayment.AllocationEndDate =
                        matchingAllocationDeliverablePeriod
                            .AllocationEndDate.GetValueOrDefault();
                    enrichedReportedPayment.Ukprn =
                        matchingAllocationDeliverablePeriod.Ukprn;
                    enrichedReportedPayment.EnrichedDeliverableCode =
                        enrichedReportedPayment.DeliverableCode;

                    enrichedReportedPayments.Add(enrichedReportedPayment);
                }
            }

            return enrichedReportedPayments;
        }
    }
}