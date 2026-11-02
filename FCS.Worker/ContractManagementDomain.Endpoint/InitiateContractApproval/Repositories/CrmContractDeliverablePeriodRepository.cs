namespace ContractManagementDomain.Endpoint.InitiateContractApproval.Repositories
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Text;
    using Dtos;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class CrmContractDeliverablePeriodRepository : ICrmContractDeliverablePeriodRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmContractDeliverablePeriodRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public IReadOnlyCollection<ContractDeliverablePeriodDto> GetContractDeliverablePeriods(string contractNumber, int versionNumber)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                return (from c in xrmContext.sfa_contractSet
                        join a in xrmContext.sfa_contractallocationSet on c.sfa_contractId equals a.sfa_ContractId.Id
                        join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals d.sfa_ContractAllocationId.Id
                        join dp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals dp.sfa_ContractDeliverableId.Id
                        where c.sfa_number == contractNumber && c.sfa_Version == versionNumber && c.sfa_LatestVersion == true
                        select new ContractDeliverablePeriodDto(c.Id, a.sfa_contractallocationId.Value, dp.sfa_contractdeliverableperiodId.Value)).ToList();
            }
        }

        public IReadOnlyCollection<ContractDeliverablePeriodDto> GetContractDeliverablePeriodsForAllocation(string contractNumber, int versionNumber, string fundingStreamPeriodCode)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                return (from c in xrmContext.sfa_contractSet
                    join a in xrmContext.sfa_contractallocationSet on c.sfa_contractId equals a.sfa_ContractId.Id
                    join fsp in xrmContext.sfa_fundingstreamperiodSet on a.sfa_FundingStreamPeriodId.Id equals fsp.sfa_fundingstreamperiodId
                    join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals d.sfa_ContractAllocationId.Id
                    join dp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals dp.sfa_ContractDeliverableId.Id
                    where c.sfa_number == contractNumber && 
                          c.sfa_Version == versionNumber &&
                          c.sfa_LatestVersion == true && 
                          fsp.sfa_fundingstreamperiodcode == fundingStreamPeriodCode
                    select new ContractDeliverablePeriodDto(c.Id, a.sfa_contractallocationId.Value, dp.sfa_contractdeliverableperiodId.Value)).ToList();
            }
        }

        public void UpdatePeriod(Guid cpdId, int year, int month)
        {
            string periodName = GetPeriodName(year, month);

            sfa_contractdeliverableperiod cdp = new sfa_contractdeliverableperiod
            {
                Id = cpdId,
                sfa_PeriodName = periodName,
                sfa_Period = month,
                sfa_Year = year,
                sfa_name = periodName,
                EntityState = EntityState.Changed
            };

            _organizationService.Update(cdp);
        }

        private static string GetPeriodName(int year, int period)
        {
            var date = new DateTime(year, period, 1);

            return new StringBuilder().Append(date.ToString("MMM", CultureInfo.InvariantCulture))
                    .Append("-")
                    .Append(date.ToString("yy"))
                    .ToString();
        }

    }
}
