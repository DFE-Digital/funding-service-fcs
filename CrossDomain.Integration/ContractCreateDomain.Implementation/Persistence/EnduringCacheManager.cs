namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using Implementation.Entities;
    using Microsoft.Xrm.Sdk;

    /// <summary>
    /// This is responsible for holding catched data that will not be expired
    /// </summary>
    public class EnduringCacheManager : IEnduringCacheManager
    {
        private readonly ConcurrentDictionary<OptionSetKey, int?> _optionSets = new ConcurrentDictionary<OptionSetKey, int?>();

        private readonly ConcurrentDictionary<PeriodKey, Guid?> _periods = new ConcurrentDictionary<PeriodKey, Guid?>();

        private readonly ConcurrentDictionary<LookupWithColumnFilterKey, IList<Guid>> _columnValues = new ConcurrentDictionary<LookupWithColumnFilterKey, IList<Guid>>();

        private readonly ConcurrentDictionary<CrmLookupType, Lazy<EntityCollection>> _generalLookupCache = new ConcurrentDictionary<CrmLookupType, Lazy<EntityCollection>>();

        public int? GetOptionSetValue(OptionSetKey optionSetKey, Func<OptionSetKey, int?> getOptionSetValueFromCrm)
        {
            return _optionSets.GetOrAdd(optionSetKey, getOptionSetValueFromCrm);
        }

        public Guid? GetPeriodId(PeriodKey periodKey, Func<PeriodKey, Guid?> getOptionSetValueFromCrm)
        {
            return _periods.GetOrAdd(periodKey, getOptionSetValueFromCrm);
        }

        public IList<Guid> GetPkColumnValuesForEntity(LookupWithColumnFilterKey key, Func<LookupWithColumnFilterKey, IList<Guid>> getValuesFromCrm)
        {
            return _columnValues.GetOrAdd(key, getValuesFromCrm);
        }

        public EntityCollection GetEntitiesForLookupType(CrmLookupType lookupType, Func<EntityCollection> getDataFromCrm)
        {
            Lazy<EntityCollection> lazyGetData = new Lazy<EntityCollection>(getDataFromCrm);

            lazyGetData = _generalLookupCache.GetOrAdd(lookupType, keyLookupType => lazyGetData);

            return lazyGetData.Value;
        }
    }
}
