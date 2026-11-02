namespace SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Data;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Cache;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    public class FundingStreamConfigurationStore : IFundingStreamConfigurationStore
    {
        private readonly TimeSpan _defaultTimeSpan = new TimeSpan(4, 0, 0);

        public IFundingStreamPeriodCache FundingStreamPeriodCache { get; set; }

        public FundingStreamPeriod GetFundingStreamPeriod(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                var fundingStreamPeriodLazy = new Lazy<FundingStreamPeriod>(() => context.FundingStreamPeriods.FirstOrDefault(fsp => fsp.Code == fundingStreamPeriodCode));
                var fundingStreamPeriod = (Lazy<FundingStreamPeriod>)FundingStreamPeriodCache.Add(fundingStreamPeriodCode, fundingStreamPeriodLazy, _defaultTimeSpan);

                return (fundingStreamPeriod ?? fundingStreamPeriodLazy).Value;
            }
        }

        public IEnumerable<FundingStreamPeriodDeliverable> GetFundingStreamPeriodDeliverables(string fundingStreamPeriodCode, ConnectionInfo connectionInfo)
        {
            using (var context = new MonitoringDeliverablesDbContext(connectionInfo))
            {
                var fundingStreamPeriodDeliverablesLazy = new Lazy<IEnumerable<FundingStreamPeriodDeliverable>>(context.FundingStreamPeriodDeliverables.ToList);
                var fundingStreamPeriodDeliverables = (Lazy<IEnumerable<FundingStreamPeriodDeliverable>>)FundingStreamPeriodCache.Add("AllDeliverables", fundingStreamPeriodDeliverablesLazy, _defaultTimeSpan);

                return (fundingStreamPeriodDeliverables ?? fundingStreamPeriodDeliverablesLazy).Value.Where(x => x.FundingStreamPeriodCode == fundingStreamPeriodCode);
            }
        }
    }
}