namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Infrastructure;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;

    public class CrmHelper
    {
        private ILookupManager _lookupManager;

        public static IOrganizationService GetConnection()
        {
            return CrmConnectionFactory.GetOrganizationService();
        }

        public Guid GetLookupPrimaryKey(CrmLookupType lookupType, string columnName, IEnumerable<string> values)
        {
            var lookupManager = GetLookupManager();
            var columnValues = lookupManager.GetPkColumnValuesForEntity(lookupType, columnName, values);
            return columnValues.Single();
        }

        private ILookupManager GetLookupManager()
        {
            if (_lookupManager == null)
            {
                _lookupManager = new LookupManager
                {
                    BatchId = "XX",
                    OrganizationService = CrmHelper.GetConnection(),
                    EnduringCacheManager = new EnduringCacheManager()
                };
            }

            return _lookupManager;
        }
    }
}
