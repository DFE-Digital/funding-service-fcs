namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Services;

    public static class CrmAllocationPeriodRepository
    {
        public static IReadOnlyCollection<sfa_allocationperiod> GetByAllocationReference(string allocationRef)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                IQueryable<sfa_allocationperiod> query =
                    from ap in context.sfa_allocationperiodSet
                    join a in context.sfa_allocationSet on ap.sfa_allocation.Id equals a.sfa_allocationId
                    where
                        a.sfa_name == allocationRef
                    select ap;

                return query.ToList();
            }
        }

        public static int GetRowCountByUkprn(int ukprn)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                IQueryable<Guid> query =
                    from ap in context.sfa_allocationperiodSet
                    join a in context.sfa_allocationSet on ap.sfa_allocation.Id equals a.sfa_allocationId
                    where
                        a.sfa_ukprn == ukprn.ToString()
                    select ap.Id;

                return query
                    .AsEnumerable()
                    .Count();
            }
        }
    }
}
