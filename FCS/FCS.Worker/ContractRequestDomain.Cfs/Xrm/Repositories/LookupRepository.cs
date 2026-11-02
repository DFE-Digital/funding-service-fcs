using System;

namespace ContractRequestDomain.Cfs.Xrm.Repositories
{
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class LookupRepository
    {
        private readonly IOrganizationService _organizationService;
        private static readonly ConcurrentDictionary<CrmKey, EntityReference> CrmCachedEntityReferences = new ConcurrentDictionary<CrmKey, EntityReference>(); 

        public LookupRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public EntityReference GetOrgEntityReference(string ukprn)
        {
            return GetOrgEntityReferenceFromCrm(ukprn, Account.EntityLogicalName);
        }

        public EntityReference GetFundingTypeEntityReference(string fundingTypeCode)
        {
            return CrmCachedEntityReferences.GetOrAdd(new CrmKey(logicalName: sfa_fundingtype.EntityLogicalName, key: fundingTypeCode),
                k => GetFundingTypeEntityReferenceFromCrm(k.Key, k.LogicalName));
        }

        public EntityReference GetFundingStreamPeriodEntityReference(string fundingStreamPeriodCode)
        {
            return CrmCachedEntityReferences.GetOrAdd(new CrmKey(logicalName: sfa_fundingstreamperiod.EntityLogicalName, key: fundingStreamPeriodCode),
                k => GetFundingStreamPeriodEntityReferenceFromCrm(k.Key, k.LogicalName));
        }

        public EntityReference GetFundingPeriodEntityReference(string fundingPeriodName)
        {
            return CrmCachedEntityReferences.GetOrAdd(new CrmKey(logicalName: sfa_period.EntityLogicalName, key: fundingPeriodName),
                k => GetFundingPeriodEntityReferenceFromCrm(k.Key, k.LogicalName));
        }

        public EntityReference GetDeliverableEntityReference(string fundingStreamPeriodCode, int deliverableCode)
        {
            string compositeKey = $"{fundingStreamPeriodCode}_{deliverableCode}";

            return CrmCachedEntityReferences.GetOrAdd(new CrmKey(logicalName: sfa_fundingstreamperioddeliverable.EntityLogicalName, key: compositeKey),
                k => GetFspDeliverableEntityReferenceFromCrm(fundingStreamPeriodCode, deliverableCode, k.LogicalName));
        }

        private EntityReference GetOrgEntityReferenceFromCrm(string ukprn, string entityLogicalName)
        {
            using (var context = new XrmServiceContext(_organizationService))
            {
                var id = context.AccountSet.Where(a => a.sfa_UKPRN == ukprn)
                    .Select(e => e.Id)
                    .First();

                return new EntityReference(entityLogicalName, id);
            }
        }

        private EntityReference GetFundingTypeEntityReferenceFromCrm(string fundingTypeCode, string entityLogicalName)
        {
            using (var context = new XrmServiceContext(_organizationService))
            {
                var id = context.sfa_fundingtypeSet.Where(ft => ft.sfa_fundingtypecode == fundingTypeCode)
                    .Select(e => e.Id)
                    .First();

                return new EntityReference(entityLogicalName, id);
            }
        }

        private EntityReference GetFundingStreamPeriodEntityReferenceFromCrm(string fundingStreamPeriodCode, string entityLogicalName)
        {
            using (var context = new XrmServiceContext(_organizationService))
            {
                var id = context.sfa_fundingstreamperiodSet.Where(fsp => fsp.sfa_fundingstreamperiodcode == fundingStreamPeriodCode)
                    .Select(e => e.Id)
                    .First();

                return new EntityReference(entityLogicalName, id);
            }
        }

        private EntityReference GetFundingPeriodEntityReferenceFromCrm(string fundingPeriodName, string entityLogicalName)
        {
            using (var context = new XrmServiceContext(_organizationService))
            {
                var id = context.sfa_periodSet.Where(p => p.sfa_periodname == fundingPeriodName)
                    .Select(e => e.Id)
                    .First();

                return new EntityReference(entityLogicalName, id);
            }
        }

        private EntityReference GetFspDeliverableEntityReferenceFromCrm(string fundingStreamPeriodCode, int deliverableCode, string entityLogicalName)
        {
            using (var context = new XrmServiceContext(_organizationService))
            {
                var id =
                    (from del in context.sfa_deliverableSet
                        join fsCode in context.sfa_fundingstreamSet
                            on del.sfa_FundingStreamId.Id equals fsCode.sfa_fundingstreamId
                        join fspCode in context.sfa_fundingstreamperiodSet
                            on fsCode.sfa_fundingstreamId equals fspCode.sfa_FundingStreamCodeId.Id
                     where fspCode.sfa_fundingstreamperiodcode == fundingStreamPeriodCode
                           && del.sfa_DeliverableCode == deliverableCode
                        select del.Id).First();
                return new EntityReference(entityLogicalName, id);
            }
        }

        private class CrmKey
        {
            public CrmKey(string logicalName, string key)
            {
                LogicalName = logicalName;
                Key = key;
            }

            public string LogicalName { get; }

            public string Key { get; }

            public override bool Equals(object obj)
            {
                return obj is CrmKey other &&
                       LogicalName == other.LogicalName &&
                       Key.Equals(other.Key);
            }

            public override int GetHashCode()
            {
                var hashCode = -1999113593;
                hashCode = hashCode * -1521134295 + EqualityComparer<string>.Default.GetHashCode(LogicalName);
                hashCode = hashCode * -1521134295 + EqualityComparer<string>.Default.GetHashCode(Key);
                return hashCode;
            }
        }
    }
}
