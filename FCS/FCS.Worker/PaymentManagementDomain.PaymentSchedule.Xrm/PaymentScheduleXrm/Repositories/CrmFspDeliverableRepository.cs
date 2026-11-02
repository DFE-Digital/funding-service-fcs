namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Repositories
{
    using System.Collections.Concurrent;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk;

    public class CrmFspDeliverableRepository : ICrmFspDeliverableRepository
    {
        private readonly IOrganizationService _organizationService;

        private static readonly ConcurrentDictionary<string, Lazy<IReadOnlyCollection<FspDeliverableInfo>>>
            FundingStreamPeriodDeliverables =
                new ConcurrentDictionary<string, Lazy<IReadOnlyCollection<FspDeliverableInfo>>>();


        public CrmFspDeliverableRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public IReadOnlyCollection<FspDeliverableInfo> GetFundingStreamPeriodDeliverables(string fundingStreamPeriodCode)
        {
            Lazy<IReadOnlyCollection<FspDeliverableInfo>> lazy = 
                new Lazy<IReadOnlyCollection<FspDeliverableInfo>>
            (() => GetDataFromCrm(fundingStreamPeriodCode));

            Lazy<IReadOnlyCollection<FspDeliverableInfo>> lazyFspDeliverables = FundingStreamPeriodDeliverables.GetOrAdd(fundingStreamPeriodCode, lazy);

            return lazyFspDeliverables.Value;
        }

        private IReadOnlyCollection<FspDeliverableInfo> GetDataFromCrm(string fundingStreamPeriodCode)
        {
            var xrmContext = new XrmServiceContext(_organizationService);

            var fspDs = (from fspDel in xrmContext.sfa_fundingstreamperioddeliverableSet
                join fspCode in xrmContext.sfa_fundingstreamperiodSet
                    on fspDel.sfa_FundingStreamPeriodId.Id equals fspCode.sfa_fundingstreamperiodId
                where fspCode.sfa_fundingstreamperiodcode == fundingStreamPeriodCode
                select new{fspDel.sfa_DeliverableCode, fspDel.sfa_setting_displayorder, fspDel.sfa_name, fspDel.Id, fspDel.sfa_ParentDeliverableId, fspDel.sfa_setting_AllowProfile}).ToList();

            return fspDs.Select(f => new FspDeliverableInfo(f.sfa_setting_displayorder.Value, f.sfa_name, f.Id,
                f.sfa_DeliverableCode.Value,
                GetDeliverableCode(f.sfa_ParentDeliverableId, xrmContext), f.sfa_setting_AllowProfile.Value)).ToList();
        }

        private int? GetDeliverableCode(EntityReference fspDeliverableId, XrmServiceContext xrmContext)
        {
            if (fspDeliverableId != null)
            {
                return xrmContext.sfa_fundingstreamperioddeliverableSet
                    .Where(fspD => fspD.sfa_fundingstreamperioddeliverableId == fspDeliverableId.Id)
                    .Select(fspD => fspD.sfa_DeliverableCode)
                    .Single();
            }

            return null;
        }
       
    }
}
