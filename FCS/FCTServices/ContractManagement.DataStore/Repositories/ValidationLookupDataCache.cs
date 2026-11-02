namespace ContractManagement.DataStore.Repositories
{
    using System;
    using System.Collections.Concurrent;

    public static class ValidationLookupDataCache
    {
        private static readonly ConcurrentDictionary<ValidationLookupType, Lazy<object>> LookupDataByType = new ConcurrentDictionary<ValidationLookupType, Lazy<object>>();

        public static T Get<T>(ValidationLookupType lookupType, Func<T> getFunction) where T : class
        {
            Lazy<object> getLazy = new Lazy<object>(getFunction);

            getLazy = LookupDataByType.GetOrAdd(lookupType, itemKey => getLazy);

            return getLazy.Value as T;
        }
    }

    public enum ValidationLookupType
    {
        ContractType,
        UnitOfProcurement,
        InvestmentPriority,
        RegionType,
        SpecificationTitle,
        FspLegalDeliverable
    }
}