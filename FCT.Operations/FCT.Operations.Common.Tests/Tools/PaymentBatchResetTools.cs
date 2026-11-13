namespace FCT.Operations.Common.Tests.Tools
{
    using System;
    using System.Data.SqlClient;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.Integration.DataStore;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Model;

    [TestClass]
    public class PaymentBatchResetTools
    {
        // connection settings
        private const string SqlConnectionString = "Data Source=gy2thhzgc4.database.windows.net;Initial Catalog=fct-database-oat;Persist Security Info=True;User ID=fctsa;Password=PPPassword@9";

        // reset values
        // Values for NAV testing requested by Michelle Brown 11-Sep-2018. Run payment batch for July.
        private static readonly DateTime CensusEndDateOfPaymentTimetablesToReset = new DateTime(2018, 08, 07, 22, 00, 00, DateTimeKind.Utc);
        private static readonly DateTime SystemOverrideDateToSet = new DateTime(2018, 08, 07, 22, 01, 00, DateTimeKind.Utc);

        [TestMethod, TestCategory("DataDependentOAT")]
        public void ResetSystemToRunPaymentBatch()
        {
            PaymentGenerationDbContext paymentGenerationDbContext = new PaymentGenerationDbContext(new SqlConnection(SqlConnectionString));
            OverrideDateDBContext overrideDateDbContext = new OverrideDateDBContext(new SqlConnection(SqlConnectionString));

            // reset payment timetable status to NotStarted and link code to A or R
            paymentGenerationDbContext.Database.ExecuteSqlCommand(
                "UPDATE PaymentGeneration.PaymentTimetable SET LinkCodeSuffix = 'A', Status = 'NotStarted' WHERE CensusEndDate = @censusEndDate AND LinkCodeSuffix IN('A', 'B', 'C', 'D')",
                new SqlParameter("@censusEndDate", CensusEndDateOfPaymentTimetablesToReset));

            paymentGenerationDbContext.Database.ExecuteSqlCommand(
                "UPDATE PaymentGeneration.PaymentTimetable SET LinkCodeSuffix = 'R', Status = 'NotStarted' WHERE CensusEndDate = @censusEndDate AND LinkCodeSuffix IN('R', 'S', 'T', 'U')",
                new SqlParameter("@censusEndDate", CensusEndDateOfPaymentTimetablesToReset));

            paymentGenerationDbContext.Database.ExecuteSqlCommand(
                "DELETE FROM PaymentGeneration.PaymentBatchFeedItem WHERE CensusEndDate = @censusEndDate",
                new SqlParameter("@censusEndDate", CensusEndDateOfPaymentTimetablesToReset));

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
    }
}
