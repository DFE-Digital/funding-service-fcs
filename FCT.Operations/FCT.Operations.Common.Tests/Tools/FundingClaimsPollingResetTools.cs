namespace FCT.Operations.Common.Tests.Tools
{
    using System;
    using System.Data.SqlClient;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Model;
    using SFA.FCT.PerformanceManagementDomain.DataStore;

    [TestClass]
    public class FundingClaimsPollingResetTools
    {
        // connection settings
        private const string SqlConnectionString = "Data Source=gy2thhzgc4.database.windows.net;Initial Catalog=fct-database-oat;Persist Security Info=True;User ID=fctsa;Password=PPPassword@9";

        // reset values
        private static readonly DateTime SystemOverrideDateToSet = new DateTime(2019, 06, 14, 10, 00, 00, DateTimeKind.Utc);
        private static readonly FundingClaimsCollectionInfo[] CollectionsToRemove =
        {
            new FundingClaimsCollectionInfo
            {
                PeriodClaimType = "1618-YearEnd",
                ClaimTypeName = "YEAREND",
                Period = 1718
            }
        };

        [TestMethod, TestCategory("DataDependentOAT")]
        public void ResetSystemToReceiveFundingClaims()
        {
            PerformanceManagementDbContext performanceManagementDbContext = new PerformanceManagementDbContext(new SqlConnection(SqlConnectionString));
            OverrideDateDBContext overrideDateDbContext = new OverrideDateDBContext(new SqlConnection(SqlConnectionString));

            // remove any collections to be re-imported
            CollectionsToRemove.ForEach(collection =>
            {
                performanceManagementDbContext.Database.ExecuteSqlCommand(
                    "DELETE FROM PerformanceManagement.FundingClaimCollectionImportInfo WHERE PeriodClaimType = @periodClaimType",
                    new SqlParameter("@periodClaimType", collection.PeriodClaimType));

                performanceManagementDbContext.Database.ExecuteSqlCommand(
                    "DELETE FROM PerformanceManagement.FundingClaim WHERE ClaimTypeName = @claimTypeName AND Period = @period",
                    new SqlParameter("@claimTypeName", collection.ClaimTypeName),
                    new SqlParameter("@period", collection.Period));
            });

            // clear out and set override date
            overrideDateDbContext.Database.ExecuteSqlCommand("DELETE FROM OverrideDate.OverrideDate");
            overrideDateDbContext.Database.ExecuteSqlCommand("DELETE FROM OverrideDate.OverrideDateWithKey");
            overrideDateDbContext.OverrideDate.Add(new OverrideDate { SystemOverrideDate = SystemOverrideDateToSet });
            overrideDateDbContext.SaveChanges();
        }

        [TestMethod, TestCategory("DataDependentOAT")]
        public void SetSystemOverrideDate()
        {
            OverrideDateDBContext overrideDateDbContext = new OverrideDateDBContext(new SqlConnection(SqlConnectionString));

            // clear out and set override date
            overrideDateDbContext.Database.ExecuteSqlCommand("DELETE FROM OverrideDate.OverrideDate");
            overrideDateDbContext.Database.ExecuteSqlCommand("DELETE FROM OverrideDate.OverrideDateWithKey");
            overrideDateDbContext.OverrideDate.Add(new OverrideDate { SystemOverrideDate = SystemOverrideDateToSet });
            overrideDateDbContext.SaveChanges();
        }

        private class FundingClaimsCollectionInfo
        {
            public string PeriodClaimType { get; set; }

            public string ClaimTypeName { get; set; }

            public int Period { get; set; }
        }

    }
}
