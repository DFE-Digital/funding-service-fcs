namespace ContractRequestDomain.Cfs.Release.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Common.Dtos;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class AllocationRepository : IAllocationRepository
    {
        private readonly IOrganizationService _organizationService;

        public AllocationRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public IReadOnlyCollection<Allocation> GetAllocationsForRelease(string fundingType, string fundingPeriod)
        {
            using (XrmServiceContext context = new XrmServiceContext(_organizationService))
            {
                var query = (
                    from a in context.sfa_allocationSet
                    join ft in context.sfa_fundingtypeSet on a.sfa_fundingtype.Id equals ft.sfa_fundingtypeId
                    join fp in context.sfa_periodSet on a.sfa_fundingperiod.Id equals fp.sfa_periodId
                    join d in context.sfa_deliverableSet on a.sfa_deliverable.Id equals d.sfa_deliverableId
                    where
                        a.sfa_status != null && a.sfa_status.Value == (int)sfa_AllocationStatus.InRelease &&
                        a.sfa_substatus != null && a.sfa_substatus.Value == (int)sfa_AllocationSubStatus.ReleaseinProgress &&
                        ft.sfa_fundingtypecode == fundingType &&
                        fp.sfa_periodname == fundingPeriod
                    select new
                    {
                        Allocation = a,
                        FundingTypeCode = ft.sfa_fundingtypecode,
                        DeliverableCode = d.sfa_DeliverableCode
                    });

                return query
                    .AsEnumerable()
                    .Select(result =>
                    {
                        context.MergeOption = MergeOption.NoTracking;
                        context.LoadProperty(result.Allocation, "sfa_sfa_allocation_sfa_allocationperiod_allocation");

                        return new Allocation
                        {
                            Id = result.Allocation.sfa_name,
                            FundingStreamPeriodCode = result.Allocation.sfa_fundingstreamperiod.Name,
                            DeliverableCode = result.DeliverableCode.Value,
                            FundingTypeCode = result.FundingTypeCode,
                            FundingPeriod = result.Allocation.sfa_fundingperiod.Name,
                            Ukprn = int.Parse(result.Allocation.sfa_ukprn),
                            MajorVersion = result.Allocation.sfa_majorversion.Value,
                            MinorVersion = result.Allocation.sfa_minorversion.Value,
                            StartDate = result.Allocation.sfa_startdate.Value,
                            EndDate = result.Allocation.sfa_enddate.Value,
                            CrmEntityId = result.Allocation.Id,
                            AllocationPeriods = result.Allocation.sfa_sfa_allocation_sfa_allocationperiod_allocation
                                .Select(ap => new AllocationPeriod
                                {
                                    Month = ap.sfa_month.Value,
                                    Year = int.Parse(ap.sfa_year),
                                    ProfileValue = ap.sfa_value.Value,
                                    Period = ap.sfa_name
                                })
                                .ToList()
                        };
                    })
                    .ToList();
            }
        }
    }
}
