namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using DTO;
    using Microsoft.Xrm.Client.Services;
    using Services;

    public static class CrmContractDeliverableRepository
    {
        public static SimpleDeliverable GetSimpleLatestDeliverable(string allocationNumber, int deliverableCode)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return (from d in context.sfa_contractdeliverableSet
                        join ca in context.sfa_contractallocationSet on d.sfa_ContractAllocationId.Id equals ca
                            .sfa_contractallocationId
                        join c in context.sfa_contractSet on ca.sfa_ContractId.Id equals c.Id
                        where ca.sfa_contractallocationnumber == allocationNumber
                              && c.sfa_LatestVersion == true
                              && d.sfa_DeliverableCode == deliverableCode.ToString()
                        select new {d.sfa_ActualValue, d.sfa_ActualVolume}).AsEnumerable()
                    .Select(d => new SimpleDeliverable(allocationNumber,
                        deliverableCode, d.sfa_ActualValue,
                        d.sfa_ActualVolume))
                    .FirstOrDefault();
            }
        }

        public static void DeleteDeliverableForAllVersionsOfAllocation(string allocationNumber, int deliverableCode)
        {
            var organizationService = CrmConnectionFactory.GetConnection();
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                (from d in context.sfa_contractdeliverableSet
                 join a in context.sfa_contractallocationSet on d.sfa_ContractAllocationId.Id equals a.sfa_contractallocationId
                 where
                     a.sfa_contractallocationnumber == allocationNumber
                     && d.sfa_DeliverableCode == deliverableCode.ToString()
                select d.Id)
                .ToList()
                .ForEach(id => organizationService.Delete("sfa_contractdeliverable", id));
            }
        }

        public static sfa_contractdeliverable GetLatestContractDeliverable(string allocationNumber, int deliverableCode)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                IQueryable<sfa_contractdeliverable> query = 
                    from cd in context.sfa_contractdeliverableSet
                    join ca in context.sfa_contractallocationSet on cd.sfa_ContractAllocationId.Id equals ca.sfa_contractallocationId
                    join c in context.sfa_contractSet on ca.sfa_ContractId.Id equals c.Id
                    where
                        cd.sfa_DeliverableCode == deliverableCode.ToString() &&
                        ca.sfa_contractallocationnumber == allocationNumber &&
                        c.sfa_LatestVersion == true
                    select cd;

                    return query
                        .AsEnumerable()
                        .Select(cd =>
                        {
                            context.LoadProperty(cd, "Referencingsfa_cdeliverable_sfa_cdeliverable");
                            return cd;
                        })
                        .SingleOrDefault();
            }
        }
    }
}
