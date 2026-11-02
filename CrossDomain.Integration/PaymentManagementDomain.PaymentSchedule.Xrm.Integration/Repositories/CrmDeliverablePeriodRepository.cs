namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Sdk;

    public class CrmDeliverablePeriodRepository : ICrmDeliverablePeriodRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmDeliverablePeriodRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public void InsertDeliverablePeriod(sfa_contractdeliverableperiod basedOnContractDeliverablePeriod, EntityReference deliverableToRelateTo)
        {
            var deliverablePeriodEntity = new sfa_contractdeliverableperiod
            {
                sfa_name = basedOnContractDeliverablePeriod.sfa_name,
                sfa_PeriodName = basedOnContractDeliverablePeriod.sfa_PeriodName,
                sfa_Period = basedOnContractDeliverablePeriod.sfa_Period,
                sfa_Year = basedOnContractDeliverablePeriod.sfa_Year,
                sfa_ContractDeliverableId = deliverableToRelateTo,
                OwnerId = basedOnContractDeliverablePeriod.OwnerId,
                sfa_PeriodTypeId = basedOnContractDeliverablePeriod.sfa_PeriodTypeId,
                sfa_DisplayOrder = basedOnContractDeliverablePeriod.sfa_DisplayOrder,
                sfa_PaymentPosted = basedOnContractDeliverablePeriod.sfa_PaymentPosted,
                sfa_profilesubnominal = basedOnContractDeliverablePeriod.sfa_profilesubnominal,
                sfa_CappingSubnominal = basedOnContractDeliverablePeriod.sfa_CappingSubnominal,
                sfa_ActualValue = basedOnContractDeliverablePeriod.sfa_ActualValue,
                sfa_ActualVolume = basedOnContractDeliverablePeriod.sfa_ActualVolume,
                sfa_BalancingPaymentAmount = basedOnContractDeliverablePeriod.sfa_BalancingPaymentAmount,
                sfa_CappedPaymentAmount = basedOnContractDeliverablePeriod.sfa_CappedPaymentAmount,
                sfa_NetPaymentAmount = basedOnContractDeliverablePeriod.sfa_NetPaymentAmount,
                sfa_PlannedValue = basedOnContractDeliverablePeriod.sfa_PlannedValue,
                sfa_PlannedVolume = basedOnContractDeliverablePeriod.sfa_PlannedVolume,
                sfa_ProfilePaymentAmount = basedOnContractDeliverablePeriod.sfa_ProfilePaymentAmount,
                sfa_ReconciliationPaymentAmount = basedOnContractDeliverablePeriod.sfa_ReconciliationPaymentAmount,
                sfa_reconciliationsubnominal = basedOnContractDeliverablePeriod.sfa_reconciliationsubnominal,
                sfa_UnitCost = basedOnContractDeliverablePeriod.sfa_UnitCost,
                sfa_aggregate = basedOnContractDeliverablePeriod.sfa_aggregate
            };

            _organizationService.Create(deliverablePeriodEntity);
        }

        public IReadOnlyCollection<DeliverablePeriodInfo> GetDeliverablePeriods(Guid allocationId)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                return (from d in xrmContext.sfa_contractdeliverableSet
                        join dp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals dp.sfa_ContractDeliverableId.Id
                        where d.sfa_ContractAllocationId.Id == allocationId
                        select new DeliverablePeriodInfo(d.sfa_DeliverableCode, d.Id, dp)).ToList();
            }
        }

        public IReadOnlyCollection<DeliverablePeriodYear> GetDeliverablePeriodYears(Guid crmAllocation)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                return
                    (from d in xrmContext.sfa_contractdeliverableSet
                     join cdp in xrmContext.sfa_contractdeliverableperiodSet on
                         d.sfa_contractdeliverableId
                         equals
                         cdp.sfa_ContractDeliverableId.Id
                     where
                         d.sfa_ContractAllocationId.Id == crmAllocation
                     select new DeliverablePeriodYear(cdp.sfa_Period, cdp.sfa_PeriodName, cdp.sfa_Year, d.sfa_DeliverableCode, cdp)).ToList();
            }
        }
    }
}
