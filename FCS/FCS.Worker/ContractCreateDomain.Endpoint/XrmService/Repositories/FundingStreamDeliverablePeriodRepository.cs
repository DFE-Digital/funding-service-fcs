namespace ContractCreateDomain.Endpoint.XrmService.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Collections.Concurrent;
    using System.Collections.ObjectModel;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class FundingStreamDeliverablePeriodRepository : IFundingStreamDeliverablePeriodRepository
    {
        private readonly ConcurrentDictionary<string, IReadOnlyCollection<sfa_fundingstreamperioddeliverable>>
            _fundingStreamPeriodDeliverableCache =
                new ConcurrentDictionary<string, IReadOnlyCollection<sfa_fundingstreamperioddeliverable>>();

        public IReadOnlyCollection<sfa_fundingstreamperioddeliverable> GetFundingStreamPeriodDeliverables(XrmServiceContext xrmContext, string fundingStreamPeriodCode)
        {
            Func<string, IReadOnlyCollection<sfa_fundingstreamperioddeliverable>> valueFactory =
                key =>
                {
                    IList<sfa_fundingstreamperioddeliverable> policy =
                        (from fspDel in xrmContext.sfa_fundingstreamperioddeliverableSet
                            join fspCode in xrmContext.sfa_fundingstreamperiodSet
                                on fspDel.sfa_FundingStreamPeriodId.Id equals fspCode.sfa_fundingstreamperiodId
                            where fspCode.sfa_fundingstreamperiodcode == fundingStreamPeriodCode
                            select fspDel).ToList();
                    return new ReadOnlyCollection<sfa_fundingstreamperioddeliverable>(policy);
                };

            return _fundingStreamPeriodDeliverableCache.GetOrAdd(fundingStreamPeriodCode, valueFactory);
        }
    }
}
