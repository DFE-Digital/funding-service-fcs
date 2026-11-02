namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic
{
    using System.Collections.Generic;
    using System.Linq;
    using Common.DataStore;
    using Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;

    public class MonitoringDeliverableEnrichment : IMonitoringDeliverableEnrichment
    {
        private readonly IMonitoringDeliverablesDbContext _monitoringDeliverableDbContext;

        public MonitoringDeliverableEnrichment(IMonitoringDeliverablesDbContext monitoringDeliverableDbContext)
        {
            _monitoringDeliverableDbContext = monitoringDeliverableDbContext;
        }

        public void Enrich(allocationType allocation)
        {
            var monitoringDeliverables = GetMonitoringDeliverablesForFundingStreamPeriodCode(allocation.fundingStreamPeriod.fundingStreamPeriodCode);

            allocation.contractDeliverables.ForEach(d => EnrichDeliverable(d, monitoringDeliverables));
        }

        private void EnrichDeliverable(contractDeliverableType contractDeliverable, IReadOnlyCollection<FundingStreamPeriodDeliverable> monitoringDeliverables)
        {
            IList<FundingStreamPeriodDeliverable> childMonitoringDeliverables = GetMonitoringDeliverablesWithThisParent(
                parentDeliverableCode:contractDeliverable.deliverable.deliverableCode,
                monitoringDeliverables);

            if (childMonitoringDeliverables.Any())
            {
                List<contractDeliverableType> transformedContractDeliverables =
                    TransformToContractDeliverables(childMonitoringDeliverables, CreateMonitoringDeliverablePeriods(contractDeliverable.contractDeliverablePeriods));

                // Only add children which aren't already there
                contractDeliverable.contractDeliverables.AddRange(transformedContractDeliverables.Where(
                    m => !contractDeliverable.contractDeliverables.Any(cd => cd.deliverable.deliverableCode == m.deliverable.deliverableCode)));    
            }
            
            // set this deliverable to monitoring if it is present 
            contractDeliverable.deliverable.isMonitoring = IsDeliverableMonitoring(contractDeliverable, monitoringDeliverables);

            if (contractDeliverable.deliverable.isMonitoring)
                contractDeliverable.deliverable.DisplayOrder =
                    monitoringDeliverables.First(
                        d => d.DeliverableCode == contractDeliverable.deliverable.deliverableCode).DisplayOrder;

            // we only want to process deliverables that were on the original 
            contractDeliverable.contractDeliverables.Where(cd => !cd.deliverable.isMonitoring)
                .ToList()
                .ForEach(d => EnrichDeliverable(d, monitoringDeliverables));
        }

        private List<contractDeliverablePeriodsTypeContractDeliverablePeriod> CreateMonitoringDeliverablePeriods(
            List<contractDeliverablePeriodsTypeContractDeliverablePeriod> deliverablePeriods)
        {
            return (from delPeriods in deliverablePeriods
                select new contractDeliverablePeriodsTypeContractDeliverablePeriod
                {
                    period = delPeriods.period
                }).ToList();
        }

        private bool IsDeliverableMonitoring(contractDeliverableType contractDeliverable, IEnumerable<FundingStreamPeriodDeliverable> monitoringDeliverables)
        {
            return monitoringDeliverables.Any(d => d.DeliverableCode == contractDeliverable.deliverable.deliverableCode);
        }

        private List<contractDeliverableType> TransformToContractDeliverables(IList<FundingStreamPeriodDeliverable> childMonitoringDeliverables, List<contractDeliverablePeriodsTypeContractDeliverablePeriod> contractDeliverablePeriods)
        {
            return childMonitoringDeliverables.Select(
                cmd =>
                    FundingStreamPeriodDeliverableTransformer.TransformToContractDeliverableType(
                        cmd,
                        contractDeliverablePeriods)).ToList();
        }

        private List<FundingStreamPeriodDeliverable> GetMonitoringDeliverablesWithThisParent(int parentDeliverableCode, IReadOnlyCollection<FundingStreamPeriodDeliverable> monitoringDeliverables)
        {
            return monitoringDeliverables.Where(md => md.ParentDeliverableCode == parentDeliverableCode).ToList();
        }

        private IReadOnlyCollection<FundingStreamPeriodDeliverable> GetMonitoringDeliverablesForFundingStreamPeriodCode(string fundingStreamPeriodCode)
        {
            return _monitoringDeliverableDbContext.FundingStreamPeriodDeliverables.Where(
                d => d.FundingStreamPeriodCode == fundingStreamPeriodCode && d.AllowActuals).ToList();
           
        }
    }
}
