namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using DTO;
    using Services;

    public static class CrmContractDeliverablePeriodRepository
    {
        public static IReadOnlyCollection<PeriodValue> GetLatestContractDeliverablePeriodValues(string contractAllocationNumber, string deliverableCode, Func<sfa_contractdeliverableperiod, decimal?> getValue)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                var simpleCdps = (from cdp in context.sfa_contractdeliverableperiodSet
                    join d in context.sfa_contractdeliverableSet on cdp.sfa_ContractDeliverableId.Id equals
                        d.sfa_contractdeliverableId.Value
                    join ca in context.sfa_contractallocationSet on d.sfa_ContractAllocationId.Id equals
                        ca.sfa_contractallocationId.Value
                    join c in context.sfa_contractSet on ca.sfa_ContractId.Id equals c.sfa_contractId.Value
                    where ca.sfa_contractallocationnumber == contractAllocationNumber
                          && c.sfa_LatestVersion.Value == true
                          && d.sfa_DeliverableCode == deliverableCode
                          select cdp).ToList();

                return
                    simpleCdps.Select(
                        cdp =>
                            new PeriodValue(cdp.sfa_PeriodName, getValue(cdp)))
                        .ToList();

            }
        }

        public static IReadOnlyCollection<PeriodValue> GetContractDeliverablePeriodValuesForAGivenVersionNumber(string contractAllocationNumber, string deliverableCode, int versionNumber, Func<sfa_contractdeliverableperiod, decimal?> getValue)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                var simpleCdps = (from cdp in context.sfa_contractdeliverableperiodSet
                    join d in context.sfa_contractdeliverableSet on cdp.sfa_ContractDeliverableId.Id equals
                        d.sfa_contractdeliverableId.Value
                    join ca in context.sfa_contractallocationSet on d.sfa_ContractAllocationId.Id equals
                        ca.sfa_contractallocationId.Value
                    join c in context.sfa_contractSet on ca.sfa_ContractId.Id equals c.sfa_contractId.Value
                    where ca.sfa_contractallocationnumber == contractAllocationNumber
                          && c.sfa_Version == versionNumber
                          && d.sfa_DeliverableCode == deliverableCode
                    select cdp).ToList();

                return
                    simpleCdps.Select(
                            cdp =>
                                new PeriodValue(cdp.sfa_PeriodName, getValue(cdp)))
                        .ToList();

            }
        }

        public static IReadOnlyCollection<PeriodVolume> GetLatestContractDeliverablePeriodVolumes(
            string contractAllocationNumber, string deliverableCode)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                var simpleCdps = (from cdp in context.sfa_contractdeliverableperiodSet
                                  join d in context.sfa_contractdeliverableSet on cdp.sfa_ContractDeliverableId.Id equals
                                      d.sfa_contractdeliverableId.Value
                                  join ca in context.sfa_contractallocationSet on d.sfa_ContractAllocationId.Id equals
                                      ca.sfa_contractallocationId.Value
                                  join c in context.sfa_contractSet on ca.sfa_ContractId.Id equals c.sfa_contractId.Value
                                  where ca.sfa_contractallocationnumber == contractAllocationNumber
                                        && c.sfa_LatestVersion.Value == true
                                        && d.sfa_DeliverableCode == deliverableCode
                                  select cdp).ToList();

                return
                    simpleCdps.Select(
                        cdp =>
                            new PeriodVolume(cdp.sfa_PeriodName, cdp.sfa_PlannedVolume))
                        .ToList();

            }
        }

        public static sfa_contractdeliverableperiod GetLatestContractDeliverablePeriod(string allocationNumber, int deliverableCode, int year, int month)
        {
            using (XrmServiceContext context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                IQueryable<sfa_contractdeliverableperiod> query =
                    from cdp in context.sfa_contractdeliverableperiodSet
                    join cd in context.sfa_contractdeliverableSet on cdp.sfa_ContractDeliverableId.Id equals cd.sfa_contractdeliverableId
                    join ca in context.sfa_contractallocationSet on cd.sfa_ContractAllocationId.Id equals ca.sfa_contractallocationId
                    join c in context.sfa_contractSet on ca.sfa_ContractId.Id equals c.Id
                    where
                        cdp.sfa_Year.Value == year && cdp.sfa_Period.Value == month &&
                        cd.sfa_DeliverableCode == deliverableCode.ToString() &&
                        ca.sfa_contractallocationnumber == allocationNumber &&
                        c.sfa_LatestVersion == true
                    select cdp;

                return query.SingleOrDefault();
            }
        }
    }
}
