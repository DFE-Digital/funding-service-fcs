namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using Repositories;

    public class LevyMissingDeliverablePeriodCreator : ILevyMissingDeliverablePeriodCreator
    {
        private readonly ICrmAllocationRepository _crmAllocationRepository;
        private readonly ICrmDeliverablePeriodRepository _crmDeliverablePeriodRepository;

        public LevyMissingDeliverablePeriodCreator(
            ICrmAllocationRepository crmAllocationRepository,
            ICrmDeliverablePeriodRepository crmDeliverablePeriodRepository)
        { 
            _crmAllocationRepository = crmAllocationRepository;
            _crmDeliverablePeriodRepository = crmDeliverablePeriodRepository;
        }

        public void CreateMissingDeliverablePeriodsWhenNecessary(string allocationNumber)
        {
            Guid? replacedAllocationId = _crmAllocationRepository.GetMostRecentAllocation(allocationNumber, sfa_contractstatus.Replaced);

            if (replacedAllocationId.HasValue)
            {
                IReadOnlyCollection<DeliverablePeriodInfo> replacedContractDeliverablePeriods =_crmDeliverablePeriodRepository.GetDeliverablePeriods(replacedAllocationId.Value);
                ILookup<string, DeliverablePeriodInfo> replacedCDPsGroupedByDeliverable = replacedContractDeliverablePeriods.ToLookup(cdp => cdp.DeliverableCode);

                // the current allocation is approved
                Guid? approvedAllocataionId = _crmAllocationRepository.GetMostRecentAllocation(allocationNumber, sfa_contractstatus.Approved);
                IReadOnlyCollection<DeliverablePeriodInfo> approvedContractDeliverablePeriods = _crmDeliverablePeriodRepository.GetDeliverablePeriods(approvedAllocataionId.Value);
                ILookup<string, DeliverablePeriodInfo> approvedCDPsGroupedByDeliverable = approvedContractDeliverablePeriods.ToLookup(cdp => cdp.DeliverableCode);
                
                // any periods on the old contract that are not on the new should be created
                foreach (IGrouping<string, DeliverablePeriodInfo> replacedCDPsForDeliverable in replacedCDPsGroupedByDeliverable)
                {
                    // we will never lose a deliverable so the replaced contracts deliverables will always be on the amended contract
                    IEnumerable<DeliverablePeriodInfo> approvedCDPsForDeliverableCode = approvedCDPsGroupedByDeliverable[replacedCDPsForDeliverable.Key].ToList();
                    var approvedPeriodNames = approvedCDPsForDeliverableCode.Select(di => di.ContractDeliverablePeriod.sfa_name);

                    IEnumerable<DeliverablePeriodInfo> missingCDPS = replacedCDPsForDeliverable.Where(cdp => !approvedPeriodNames.Contains(cdp.ContractDeliverablePeriod.sfa_name));

                    missingCDPS.ForEach(cdp => _crmDeliverablePeriodRepository.InsertDeliverablePeriod(
                        basedOnContractDeliverablePeriod: cdp.ContractDeliverablePeriod,
                        deliverableToRelateTo: new EntityReference(sfa_contractdeliverable.EntityLogicalName, approvedCDPsForDeliverableCode.First().DeliverableId)));
                }
            }
        }
    }
}
