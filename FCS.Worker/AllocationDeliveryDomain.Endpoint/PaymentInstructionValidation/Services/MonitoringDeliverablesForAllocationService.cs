namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using MoreLinq;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;

    public class MonitoringDeliverablesForAllocationService : IMonitoringDeliverablesForAllocationService
    {
        private readonly IMonitoringDeliverableStore _monitoringDeliverableStore;

        public MonitoringDeliverablesForAllocationService(IMonitoringDeliverableStore monitoringDeliverableStore)
        {
            _monitoringDeliverableStore = monitoringDeliverableStore;
        }

        public void PopulateMissingValidDeliverables(IReadOnlyCollection<ReportedActual> actuals,
            Action<MonitoringDeliverableAddedPostApprovalEvent> raiseMonitoringDeliverableAddedPostApprovalEvent, 
            ConnectionInfo connectionInfo)
        {
            var firstReportedActual = actuals.First();

            IReadOnlyCollection<AllocationDeliverablePeriod> activeAllocationDeliverablePeriods =
                _monitoringDeliverableStore.GetActiveAllocationDeliverablePeriods(
                    firstReportedActual.OrganisationId,
                    firstReportedActual.FundingStreamPeriodCode,
                    firstReportedActual.UoPCode,
                    connectionInfo);

            if (activeAllocationDeliverablePeriods.Any())
            {
                var deliverableCodesToBeAdded = ValidlActualDeliverabeCodesNotInMonitoringDeliverables(
                    actuals,
                    activeAllocationDeliverablePeriods,
                    firstReportedActual.FundingStreamPeriodCode,
                    connectionInfo);

                Lazy<PeriodInfo> lazyPeriodInfo = new Lazy<PeriodInfo>(() =>
                {
                    return new PeriodInfo(
                        activeAllocationDeliverablePeriods.Select(adp => adp.Period).Distinct().ToArray(),
                        activeAllocationDeliverablePeriods.First());
                });

                deliverableCodesToBeAdded.ForEach(deliverableCode =>
                {
                    PeriodInfo periodInfo = lazyPeriodInfo.Value;
                    AddAllocationDeliverablePeriods(periodInfo.FirstAllocationDeliverablePeriod, deliverableCode,
                        periodInfo.Periods, connectionInfo);

                    RaiseMonitoringDeliverableAddedPostApprovalEvent(periodInfo.FirstAllocationDeliverablePeriod,
                        deliverableCode, periodInfo.Periods,
                        raiseMonitoringDeliverableAddedPostApprovalEvent);
                });
            }
        }

        private IReadOnlyCollection<int> ValidlActualDeliverabeCodesNotInMonitoringDeliverables(IReadOnlyCollection<ReportedActual> actuals,
            IReadOnlyCollection<AllocationDeliverablePeriod> allocationDeliverablePeriods, string fundingStreamPeriodCode,
            ConnectionInfo connectionInfo)
        {
            var distinctActualsDeliverableCodes = actuals.Select(actual => int.Parse(actual.DeliverableCode)).Distinct().ToList();
            var distinctAdpDeliverableCodes = allocationDeliverablePeriods.Select(adp => adp.DeliverableCode).Distinct().ToList();

            return distinctActualsDeliverableCodes.Where(
                actualDeliverableCode => !distinctAdpDeliverableCodes.Contains(actualDeliverableCode) &&
                                         IsActualDeliverableValid(fundingStreamPeriodCode, actualDeliverableCode, connectionInfo)).ToList();
        }

        private void AddAllocationDeliverablePeriods(AllocationDeliverablePeriod adpTemplate, int deliverableCode, string[] periods, ConnectionInfo connectionInfo)
        {
            var allocationDeliverablePeriods = new List<AllocationDeliverablePeriod>();

            periods.ForEach(p =>
            {
                allocationDeliverablePeriods.Add(
                    new AllocationDeliverablePeriod
                    {
                        OrganisationId = adpTemplate.OrganisationId,
                        FundingStreamPeriodCode = adpTemplate.FundingStreamPeriodCode,
                        UopCode = adpTemplate.UopCode,
                        DeliverableCode = deliverableCode,
                        Period = p,
                        ContractAllocationNumber = adpTemplate.ContractAllocationNumber,
                        ContractNumber = adpTemplate.ContractNumber,
                        ContractVersionNumber = adpTemplate.ContractVersionNumber,
                        ContractSubVersionNumber = adpTemplate.ContractSubVersionNumber,
                        AllocationStartDate = adpTemplate.AllocationStartDate,
                        AllocationEndDate = adpTemplate.AllocationEndDate,
                        Ukprn = adpTemplate.Ukprn
                    }
                );
            });

            _monitoringDeliverableStore.AddAllocationDeliverablePeriods(allocationDeliverablePeriods, connectionInfo);
        }

        private static void RaiseMonitoringDeliverableAddedPostApprovalEvent(AllocationDeliverablePeriod adpTemplate,
            int deliverableCode, string[] periods,
            Action<MonitoringDeliverableAddedPostApprovalEvent> raiseMonitoringDeliverableAddedPostApprovalEvent)
        {
            var monitoringDeliverableAddedPostApprovalEvent = new MonitoringDeliverableAddedPostApprovalEvent
            {
                AllocationNumber = adpTemplate.ContractAllocationNumber,
                ContractVersionNumber = adpTemplate.ContractVersionNumber,
                ContractSubVersionNumber = adpTemplate.ContractSubVersionNumber,
                DeliverableCode = deliverableCode,
                Periods = periods
            };

            raiseMonitoringDeliverableAddedPostApprovalEvent(monitoringDeliverableAddedPostApprovalEvent);
        }

        private bool IsActualDeliverableValid(string fundingStreamPeriodCode, int deliverableCode, ConnectionInfo connectionInfo)
        {
            return _monitoringDeliverableStore.DoesFspDeliverableExist(fundingStreamPeriodCode, deliverableCode, connectionInfo);
        }

        private class PeriodInfo
        {
            public PeriodInfo(string[] periods, AllocationDeliverablePeriod firstAllocationDeliverablePeriod)
            {
                Periods = periods;
                FirstAllocationDeliverablePeriod = firstAllocationDeliverablePeriod;
            }

            public string[] Periods { get; }

            public AllocationDeliverablePeriod FirstAllocationDeliverablePeriod { get; }
        }
    }
}