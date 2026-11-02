namespace ContractManagement.DataStore
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using SFA.FCS.Worker.Common;

    public static class ContractManagementIoCHelper
    {
        public static IReadOnlyCollection<(Type serviceType, object implementation)> GetTypesWithImplementations(IFcsConfiguration configuration)
        {
            return new List<(Type serviceType, object implementation)>
            {
                (typeof(IContractManagementDbContext), GetDbContext(configuration))
            };
            
        }

        private static ContractManagementDbContext GetDbContext(IFcsConfiguration configuration)
        {
            var connectionString = configuration["ConnectionStrings:ContractManagementDbContext"];
            var connectionInfo = new SFA.FCT.CrossDomain.Integration.Entities.Data.ConnectionInfo(null, new SqlConnection(connectionString));
            var context = new ContractManagementDbContext(connectionInfo: connectionInfo);

            return context;
        }
    }
}
