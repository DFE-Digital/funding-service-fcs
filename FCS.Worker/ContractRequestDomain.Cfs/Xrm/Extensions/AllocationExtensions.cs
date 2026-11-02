namespace ContractRequestDomain.Cfs.Xrm.Extensions
{
    using ContractRequestDomain.Cfs.Common.Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public static class AllocationExtensions
    {
        public static sfa_allocation ToCrmAllocation(this Allocation allocation)
        {
            sfa_allocation crmAllocation = new sfa_allocation
            {
                sfa_ukprn = allocation.Ukprn.ToString(),
                sfa_value = allocation.GetProfileValue(),
                sfa_startdate = allocation.StartDate,
                sfa_enddate = allocation.EndDate,
                sfa_majorversion = allocation.MajorVersion,
                sfa_minorversion = allocation.MinorVersion,
                sfa_name = allocation.Id
                // sfa_deliveryukprn = this is not required at the moment as it is not on the feed (Spoke to Vikas 10/12/2018)
            };

            return crmAllocation;
        }

        public static sfa_allocationperiod ToCrmAllocationPeriod(this AllocationPeriod allocationPeriod)
        {
            sfa_allocationperiod crmAllocationPeriod = new sfa_allocationperiod
            {
                sfa_name = allocationPeriod.Period,
                sfa_value = allocationPeriod.ProfileValue,
                sfa_month = allocationPeriod.Month,
                sfa_year = allocationPeriod.Year.ToString(),
                sfa_period = allocationPeriod.Period
            };

            return crmAllocationPeriod;
        }
    }
}
