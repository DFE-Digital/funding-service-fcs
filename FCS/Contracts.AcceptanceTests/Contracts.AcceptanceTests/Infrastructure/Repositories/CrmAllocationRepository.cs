namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using MoreLinq;
    using Services;

    public static class CrmAllocationRepository
    {
        public static void RemoveByUkprn(int ukprn)
        {
            var organizationService = CrmConnectionFactory.GetConnection();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                context.sfa_allocationSet
                    .Where(a => a.sfa_ukprn == ukprn.ToString())
                    .Select(a => a.Id)
                    .AsEnumerable()
                    .ForEach(id => organizationService.Delete("sfa_allocation", id));
            }
        }

        public static sfa_allocation FindByBusinessKey(
            string fundingStreamPeriodCode,
            int deliverableCode,
            int contractingUkprn,
            int? deliveryUkprn, // not yet implemented
            int majorVersion,
            int minorVersion)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                IQueryable<sfa_allocation> query =
                    from a in context.sfa_allocationSet
                    join fsp in context.sfa_fundingstreamperiodSet on a.sfa_fundingstreamperiod.Id equals fsp.sfa_fundingstreamperiodId
                    join d in context.sfa_deliverableSet on a.sfa_deliverable.Id equals d.sfa_deliverableId
                    where
                        fsp.sfa_fundingstreamperiodcode == fundingStreamPeriodCode &&
                        d.sfa_DeliverableCode == deliverableCode &&
                        a.sfa_ukprn == contractingUkprn.ToString() &&
                        a.sfa_majorversion == majorVersion &&
                        a.sfa_minorversion == minorVersion
                    select a;

                return query.SingleOrDefault();
            }
        }

        public static Guid GetEntityIdByAllocationReference(string allocationRef)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.sfa_allocationSet
                    .Single(a => a.sfa_name == allocationRef)
                    .Id;
            }
        }

        public static int GetRowCountByUkprn(int ukprn)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.sfa_allocationSet
                    .Where(a => a.sfa_ukprn == ukprn.ToString())
                    .Select(a => a.Id)
                    .AsEnumerable()
                    .Count();
            }
        }

        public static void UpdateAllocationStatusesAndSubStatuses(sfa_AllocationStatus status, sfa_AllocationSubStatus subStatus)
        {
            var organizationService = CrmConnectionFactory.GetConnection();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                var allocations = context.sfa_allocationSet
                    .ToList();

                allocations.ForEach(a =>
                {
                    var updatedAllocation = new sfa_allocation
                    {
                        Id = a.Id,
                        sfa_statusEnum = status,
                        sfa_substatusEnum = subStatus
                    };

                   organizationService.Update(updatedAllocation);
                });
            }
        }
    }
}
