namespace ContractCreateDomain.Endpoint.Services.Repositories
{
    using System;
    using System.Linq;
    using DTOs;
    using Microsoft.Xrm.Sdk;
    using Optional;
    using SFA.FCT.ContractCreateDomain.Implementation.Extensions;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class CrmContractQueryRepository : ICrmContractQueryRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmContractQueryRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public Option<CrmContract> GetApprovedContract(string contractNumber)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                var allocationList = (from c in xrmContext.sfa_contractSet
                    join a in xrmContext.sfa_contractallocationSet on c.sfa_contractId.Value equals a.sfa_ContractId.Id
                    join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId.Value equals d
                        .sfa_ContractAllocationId.Id
                    join dp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId.Value equals
                        dp.sfa_ContractDeliverableId.Id
                    where c.sfa_number == contractNumber
                          && c.sfa_LastApprovedVersion == true
                    select new
                    {
                        a.sfa_contractallocationnumber,
                        a.sfa_startdate,
                        a.sfa_enddate,
                        d.sfa_DeliverableCode,
                        dp.sfa_PlannedValue,
                        dp.sfa_Period,
                        dp.sfa_PeriodName,
                        dp.sfa_Year
                    }).ToList();

                var crmAllocations = allocationList
                    .GroupBy(a => new {a.sfa_contractallocationnumber, a.sfa_startdate, a.sfa_enddate})
                    .Select(allocGroup =>
                        new CrmAllocation(
                            number: allocGroup.Key.sfa_contractallocationnumber,
                            startDate: allocGroup.Key.sfa_startdate,
                            endDate: allocGroup.Key.sfa_enddate,
                            deliverables: allocGroup.GroupBy(a => a.sfa_DeliverableCode)
                                .Select(delGroup => new CrmDeliverable(code: delGroup.Key,
                                    periods: delGroup.Select(dp => new CrmDeliverablePeriod(
                                        period: dp.sfa_Period.GetValueOrDefault(),
                                        periodName: dp.sfa_PeriodName, plannedValue: dp.sfa_PlannedValue, year:dp.sfa_Year.Value)).ToList()))
                                .ToList()))
                    .ToList();

                return allocationList.Select(a => new CrmContract(contractNumber, crmAllocations))
                    .FirstOrDefault()
                    .SomeWhen(c => c != null);
            }
        }

        public bool HasSiblingContractWithDraftStatus(string masterContractNumber, string contractNumber)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                return  (from m in xrmContext.sfa_contractSet
                            join c in xrmContext.sfa_contractSet on m.sfa_contractId equals c.sfa_ParentContractId.Id
                            where m.sfa_number == masterContractNumber &&
                                c.sfa_LatestVersion == true &&
                                c.sfa_ContractStatus.Value == (int)sfa_contractstatus.Draft &&
                                c.sfa_number != contractNumber
                         select c.sfa_number).ToList().Any();
            }
        }
    }
}