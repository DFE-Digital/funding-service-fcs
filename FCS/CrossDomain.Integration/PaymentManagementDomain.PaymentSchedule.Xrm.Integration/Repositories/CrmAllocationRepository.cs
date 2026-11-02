namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Microsoft.Xrm.Sdk;

    public class CrmAllocationRepository : ICrmAllocationRepository
    {
        private readonly IOrganizationService _organizationService;
        private readonly ConcurrentDictionary<string, Guid> _subStatusDictionary = new ConcurrentDictionary<string, Guid>(); 

        public CrmAllocationRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public bool IsReplacedContractPresent(string allocationNumber)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                var replacedContracts = (from a in xrmContext.sfa_contractallocationSet
                    join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                    where a.sfa_contractallocationnumber == allocationNumber &&
                          c.sfa_ContractStatus.Value == (int) sfa_contractstatus.Replaced

                    select c.Id).ToList();

                return replacedContracts.Any();
            }
        }

        public Guid? GetMostRecentAllocationWithSubStatusApproved(string allocationNumber, sfa_contractstatus contractStatus)
        {
            Guid approvedId = _subStatusDictionary.GetOrAdd("Approved", GetSubStatusEntityId);

            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                var allocations = (from a in xrmContext.sfa_contractallocationSet
                    join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                    where a.sfa_contractallocationnumber == allocationNumber &&
                          c.sfa_ContractStatus.Value == (int)contractStatus &&
                          c.sfa_SubStatus.Id == approvedId
                    
                    select new {a.Id, a.CreatedOn}).ToList();

                return allocations.OrderByDescending(a => a.CreatedOn).FirstOrDefault()?.Id;
            }
        }

        public Guid? GetMostRecentAllocation(string allocationNumber, sfa_contractstatus contractStatus)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                var allocations = (from a in xrmContext.sfa_contractallocationSet
                    join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                    where a.sfa_contractallocationnumber == allocationNumber &&
                          c.sfa_ContractStatus.Value == (int)contractStatus

                    select new { a.Id, a.CreatedOn }).ToList();

                return allocations.OrderByDescending(a => a.CreatedOn).FirstOrDefault()?.Id;
            }
        }

        public AllocationInfo GetAllocationInfoFromCrm(string allocationNumber, int version)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                var allocationInfo = (from a in xrmContext.sfa_contractallocationSet
                                        join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                                        where
                                            c.sfa_LastApprovedVersion == true &&
                                            c.sfa_Version == version &&
                                            a.sfa_contractallocationnumber == allocationNumber
                                        orderby a.CreatedOn descending
                                        select new AllocationInfo(a.Id, a.sfa_startdate.Value, a.sfa_enddate, c.sfa_SubVersion.Value, c.sfa_contractId.Value, a.sfa_contractallocationnumber)).FirstOrDefault();

                if (allocationInfo == null)
                {
                    throw new ArgumentException($"Could not retreive Contract Allocation: {allocationNumber} version: {version}");
                }

                return allocationInfo;
            }
        }

        public IReadOnlyCollection<DeliverableInfo> GetContractDeliverablesForAllocation(Guid crmAllocation)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                return (from d in xrmContext.sfa_contractdeliverableSet
                    where
                        d.sfa_ContractAllocationId.Id == crmAllocation
                    select new DeliverableInfo(
                        d.Id,
                        d.sfa_ParentDeliverableId,
                        d.sfa_DeliverableCode,
                        d.OwnerId)).ToList();
            }
        }

        private Guid GetSubStatusEntityId(string name)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                return xrmContext.sfa_statusSet.Single(s => s.sfa_name == name).Id;
            }
        }
    }
}
