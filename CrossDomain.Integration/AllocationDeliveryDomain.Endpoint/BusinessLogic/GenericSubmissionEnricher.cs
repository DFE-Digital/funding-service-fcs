namespace AllocationDeliveryDomain.Endpoint.BusinessLogic
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Extensions;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class GenericSubmissionEnricher : IGenericSubmissionEnricher
    {
        private readonly IMonitoringDeliverableStore _monitoringDeliverableRepository;

        private readonly IDate _dateProvider;

        public GenericSubmissionEnricher(IMonitoringDeliverableStore monitoringDeliverableRepository, IDate dateProvider)
        {
            _monitoringDeliverableRepository = monitoringDeliverableRepository;
            _dateProvider = dateProvider;
        }

        public List<EnrichedReportedActual> AddMissingActualsWithZeroValues(
            IReadOnlyCollection<EnrichedReportedActual> submittedActuals, FundingStreamZeroisationBehaviour zeroisationBehaviour, ConnectionInfo connectionInfo)
        {
            if (!submittedActuals.Any())
            {
                return submittedActuals.ToList();
            }

            IEnumerable<IGrouping<string, EnrichedReportedActual>> periodGroupsForSubmittedActuals = submittedActuals.GroupBy(actual => actual.Period).ToList();

            IList<string> distinctPeriodsForSubmittedActuals = periodGroupsForSubmittedActuals.Select(pg => pg.Key).ToList();

            AddCurrentPeriodIfNotPresent(distinctPeriodsForSubmittedActuals, submittedActuals.First().ContractAllocationNumber);

            string contractAllocationNumber = submittedActuals.First().ContractAllocationNumber;

            IEnumerable<AllocationDeliverablePeriod> allocationDeliverablePeriodsInDb = GetAllocationDeliverablePeriods(
                contractAllocationNumber,
                zeroisationBehaviour,
                distinctPeriodsForSubmittedActuals,
                connectionInfo);
            
            List<EnrichedReportedActual> submittedActualsWithMissingDeliverablesAdded = new List<EnrichedReportedActual>();
            submittedActualsWithMissingDeliverablesAdded.AddRange(submittedActuals);

            IReadOnlyCollection<AllocationDeliverablePeriod> missingDeliverablePeriods = GetMissingDeliverablePeriods(submittedActuals, allocationDeliverablePeriodsInDb);

            IEnumerable<EnrichedReportedActual> missingEnrichedReportedActuals = AllocationDeliverablePeriodTransformer.ToEnrichedReportedActuals(missingDeliverablePeriods,
                submittedActuals.First());

            submittedActualsWithMissingDeliverablesAdded.AddRange(missingEnrichedReportedActuals);
            
            return submittedActualsWithMissingDeliverablesAdded;
        }

        private void AddCurrentPeriodIfNotPresent(ICollection<string> distinctPeriodsForSubmittedActuals, string allocationNumber)
        {
            var currentPeriod = _dateProvider.GetCurrentPeriod(_dateProvider.GetCalculationDate());
            if (!distinctPeriodsForSubmittedActuals.Contains(currentPeriod))
            {
                distinctPeriodsForSubmittedActuals.Add(currentPeriod);
            }
        }

        private IReadOnlyCollection<AllocationDeliverablePeriod> GetMissingDeliverablePeriods(
            IEnumerable<EnrichedReportedActual> submittedActuals,
            IEnumerable<AllocationDeliverablePeriod> allocationDeliverablePeriodsInDb)
        {

            return allocationDeliverablePeriodsInDb.Where(dpInDb => !submittedActuals.Any(sa => dpInDb.Period == sa.Period
                                                                                        &&
                                                                                        int.Parse(sa.DeliverableCode) ==
                                                                                        dpInDb.DeliverableCode))
                .ToList();
        }

        private IEnumerable<AllocationDeliverablePeriod> GetAllocationDeliverablePeriods(
            string contractAllocationNumber,
            FundingStreamZeroisationBehaviour zeroisationBehaviour,
            IEnumerable<string> distinctPeriodsForSubmittedActuals,
            ConnectionInfo connectionInfo)
        {
            IEnumerable<AllocationDeliverablePeriod> allocationDeliverablePeriods = null;

            switch (zeroisationBehaviour)
            {
                case FundingStreamZeroisationBehaviour.PersistCurrentViewActualsState:
                    allocationDeliverablePeriods = _monitoringDeliverableRepository.GetAllocationDeliverablePeriodsForAllocationAndPeriodList(
                        contractAllocationNumber,
                        distinctPeriodsForSubmittedActuals,
                        connectionInfo);
                    break;
                case FundingStreamZeroisationBehaviour.ProcessFutureActuals:
                    allocationDeliverablePeriods = _monitoringDeliverableRepository.GetActiveAllocationDeliverablePeriods(
                        new List<string> { contractAllocationNumber }, connectionInfo);
                    break;
                case FundingStreamZeroisationBehaviour.ZeroiseMissingActuals:
                    allocationDeliverablePeriods =
                    _monitoringDeliverableRepository.GetCurrentAndPastActiveAllocationDeliverablePeriodsForAllocation(
                        contractAllocationNumber,
                        _dateProvider.GetCurrentPeriod(_dateProvider.GetCalculationDate()),
                        connectionInfo);
                    break;
                default:
                    throw new ArgumentException($"Zeroisation behaviour is not valid", nameof(zeroisationBehaviour));
            }

            return allocationDeliverablePeriods;
        }
    }
}
