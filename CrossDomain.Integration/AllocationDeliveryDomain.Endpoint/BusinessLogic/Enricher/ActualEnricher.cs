namespace AllocationDeliveryDomain.Endpoint.BusinessLogic
{
    using System.Collections.Generic;
    using System.Linq;
    using Enricher;
    using SFA.FCT.AllocationDeliveryDomain.Common;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.Config;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    /// <summary>
    /// Implementation of IActualEnricher. Enriches with data from the Monitoring Deliverables repositories
    /// </summary>
    public class ActualEnricher : IActualEnricher
    {
        private IEnumerable<AllocationDeliverablePeriod> _activeAllocationDeliverablePeriods;

        private readonly IMonitoringDeliverableStore _deliverableStore;
        private readonly ILogger _logger;

        public ActualEnricher(IMonitoringDeliverableStore deliverableStore, ILogger logger)
        {
            _deliverableStore = deliverableStore;
            _logger = logger;
        }

        public IEnumerable<EnrichedReportedActual> Enrich(IEnumerable<ReportedActual> actuals, ConnectionInfo connectionInfo)
        {
            var result = new List<EnrichedReportedActual>();
            var firstReportedActual = actuals.FirstOrDefault();

            if (firstReportedActual != null)
            {
                if (TrustedData.FundingStreamsWithTrustedAllocationNumbers.Exists(m => firstReportedActual.FundingStreamPeriodCode.Contains(m)))
                {
                    _activeAllocationDeliverablePeriods =
                        _deliverableStore.GetActiveAllocationDeliverablePeriods(
                            actuals.GroupBy(a => a.ContractAllocationNumber)
                                   .Select(a => a.Key)
                                   .ToList(), connectionInfo);
                }
                else
                {
                    _activeAllocationDeliverablePeriods =
                        _deliverableStore.GetActiveAllocationDeliverablePeriods(
                            firstReportedActual.OrganisationId,
                            firstReportedActual.FundingStreamPeriodCode,
                            firstReportedActual.UoPCode,
                            connectionInfo);
                }

                foreach (var actual in actuals)
                {
                    var matchingActiveAllocationDeliverablePeriod = ResolveAllocationDeliverablePeriod(actual);

                    if (matchingActiveAllocationDeliverablePeriod != null)
                    {
                        var enrichedActual = actual.ToEnrichedReportedActual(matchingActiveAllocationDeliverablePeriod);

                        result.Add(enrichedActual);
                    }
                    else
                    {
                        _logger.LogInformation(AllocationDeliverDomainEventLoggingId.NoMatchingActiveAllocationDeliverablePeriod,
                            $"No matching Active AllocationDeliverablePeriod for Actual: {actual}");
                    }
                }
            }

            return result;
        }

        private AllocationDeliverablePeriod ResolveAllocationDeliverablePeriod(ReportedActual src)
        {
            AllocationDeliverablePeriod activeAllocationDeliverablePeriod = null;

            if (TrustedData.FundingStreamsWithTrustedAllocationNumbers.Exists(m => src.FundingStreamPeriodCode.Contains(m)))
            {
                activeAllocationDeliverablePeriod = _activeAllocationDeliverablePeriods
                    .FirstOrDefault(a => a.ContractAllocationNumber == src.ContractAllocationNumber
                            && a.DeliverableCode.ToString() == src.DeliverableCode
                            && a.Period == src.Period);
            }
            else
            {
                //
                // _activeAllocationDeliverablePeriods always hold Uop as an empty string if not present
                // 
                activeAllocationDeliverablePeriod = _activeAllocationDeliverablePeriods
                    .FirstOrDefault(a => a.OrganisationId == src.OrganisationId
                                         && a.FundingStreamPeriodCode == src.FundingStreamPeriodCode
                                         && a.UopCode == src.UoPCodeOrEmpty
                                         && a.DeliverableCode.ToString() == src.DeliverableCode
                                         && a.Period == src.Period);
            }

            return activeAllocationDeliverablePeriod;
        }
    }
}