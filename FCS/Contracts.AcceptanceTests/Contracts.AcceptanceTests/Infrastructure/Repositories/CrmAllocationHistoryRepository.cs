namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using Services;

    public static class CrmAllocationHistoryRepository
    {
        public static void RemoveByUkprn(int ukprn)
        {
            var organizationService = CrmConnectionFactory.GetConnection();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                IQueryable<Guid> query =
                    from ah in context.sfa_allocationhistorySet
                    join a in context.sfa_allocationSet on ah.sfa_allocation.Id equals a.sfa_allocationId
                    where a.sfa_ukprn == ukprn.ToString()
                    select ah.Id;

                query
                    .AsEnumerable()
                    .ForEach(id => organizationService.Delete("sfa_allocationhistory", id));
            }
        }

        public static IReadOnlyCollection<sfa_allocationhistory> GetByAllocationReference(string allocationRef)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                IQueryable<sfa_allocationhistory> query =
                    from ah in context.sfa_allocationhistorySet
                    join a in context.sfa_allocationSet on ah.sfa_allocation.Id equals a.sfa_allocationId
                    where a.sfa_name == allocationRef
                    select ah;

                return query.ToList();
            }
        }

        public static int GetRowCountByUkprn(int ukprn)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                IQueryable<Guid> query =
                    from ah in context.sfa_allocationhistorySet
                    join a in context.sfa_allocationSet on ah.sfa_allocation.Id equals a.sfa_allocationId
                    where a.sfa_ukprn == ukprn.ToString()
                    select ah.Id;

                return query
                    .AsEnumerable()
                    .Count();
            }
        }
    }
}
