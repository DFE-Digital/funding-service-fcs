namespace SFA.FCT.PerformanceManagementDomain.DataStore
{
    using SFA.FCS.Worker.Common;
    using System;
    using System.Collections.Generic;

    public static class PerformanceManagementIoCHelper
    {
        public static IReadOnlyCollection<(Type serviceType, object implementation)> GetTypesWithImplementations(IFcsConfiguration configuration)
        {
            return new List<(Type serviceType, object implementation)>
            {
                (typeof(IPerformanceManagementDbContext), GetDbContext(configuration))
            };
            
        }

        private static PerformanceManagementDbContext GetDbContext(IFcsConfiguration configuration)
        {
            var context = new PerformanceManagementDbContext();

            context.Database.Connection.ConnectionString =
                configuration["ConnectionStrings:ContractManagementDbContext"];

            return context;
        }
    }
}
