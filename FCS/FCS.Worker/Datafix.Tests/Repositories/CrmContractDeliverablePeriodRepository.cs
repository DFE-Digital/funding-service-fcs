namespace Datafix.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public static class CrmContractDeliverablePeriodRepository
    {
        public static IReadOnlyCollection<Guid> GetCdpIdsLatestAllocation(string allocationNumber, int deliverableCode, string periodName)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                return (
                        from contract in context.sfa_contractSet
                        join alloc in context.sfa_contractallocationSet on contract.sfa_contractId.Value equals alloc.sfa_ContractId.Id
                        join d in context.sfa_contractdeliverableSet on alloc.sfa_contractallocationId equals d.sfa_ContractAllocationId.Id
                        join cdp in context.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals cdp.sfa_ContractDeliverableId.Id
                        
                        where contract.sfa_LatestVersion == true
                              && alloc.sfa_contractallocationnumber == allocationNumber
                              && d.sfa_DeliverableCode == deliverableCode.ToString()
                              && cdp.sfa_PeriodName == periodName
                        select cdp.sfa_contractdeliverableperiodId.Value
                    )
                    .ToList();
            }
        }
    }
}
