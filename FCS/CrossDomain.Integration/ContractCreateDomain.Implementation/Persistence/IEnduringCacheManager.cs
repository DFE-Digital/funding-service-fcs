namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Generic;
    using Implementation.Entities;
    using Microsoft.Xrm.Sdk;

    public interface IEnduringCacheManager
    {
        int? GetOptionSetValue(OptionSetKey optionSetKey, Func<OptionSetKey, int?> getOptionSetValueFromCrm);

        Guid? GetPeriodId(PeriodKey periodKey, Func<PeriodKey, Guid?> getOptionSetValueFromCrm);

        IList<Guid> GetPkColumnValuesForEntity(LookupWithColumnFilterKey key, Func<LookupWithColumnFilterKey, IList<Guid>> getValuesFromCrm);

        EntityCollection GetEntitiesForLookupType(CrmLookupType lookupType, Func<EntityCollection> getDataFromCrm);
    }
}