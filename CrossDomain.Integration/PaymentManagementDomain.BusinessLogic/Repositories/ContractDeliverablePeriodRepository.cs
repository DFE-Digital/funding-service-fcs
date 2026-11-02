namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using DTOs;
    using Microsoft.Xrm.Sdk;

    public class ContractDeliverablePeriodRepository : IContractDeliverablePeriodRepository
    {
        private readonly IOrganizationService _organizationService;

        public ContractDeliverablePeriodRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public IReadOnlyCollection<ContractDeliverablePeriodInfo> GetContractDeliverablePeriodsForAllocation(string allocationNumber)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                var data = from a in xrmContext.sfa_contractallocationSet
                           join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                           join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals
                               d.sfa_ContractAllocationId.Id
                           join cdp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals
                               cdp.sfa_ContractDeliverableId.Id
                           where
                               c.sfa_LastApprovedVersion == true &&
                               a.sfa_contractallocationnumber == allocationNumber
                           select new ContractDeliverablePeriodInfo(a, cdp, cdp.sfa_PeriodName, d.sfa_DeliverableCode);
                return data.ToList();
            }
        }
    }
}
