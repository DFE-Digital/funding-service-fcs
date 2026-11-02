namespace PaymentManagement.Calculation.Tests.Services
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System;
    using PaymentManagement.Calculation.Services;
    using System.Configuration;
    using Dapper;
    using System.Data.SqlClient;

    [TestClass]
    public class DateServiceTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void DateProvider_WhenUseRealDateSettingIsTrueAndOverrideDateIsPresent_ShouldReturnUtcNow()
        {
            // arrange
            ConfigurationManager.AppSettings["UseRealDate"] = "true";

            ClearOverrideDateTable();
            var overrideDate = new DateTime(2015, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
            AddOverrideDateToTable(overrideDate);

            var dateService = new DateService();

            // act
            var returnedDate = dateService.GetCurrentDate();

            // assert
            Assert.IsTrue(DateTime.UtcNow.Subtract(returnedDate) < TimeSpan.FromSeconds(1), "Returned date incorrect");
            Assert.AreEqual(DateTimeKind.Utc, returnedDate.Kind, "Returned DateTimeKind is not UTC");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DateProvider_WhenUseRealDateSettingIsTrueAndOverrideDateIsNotPresent_ShouldReturnUtcNow()
        {
            // arrange
            ConfigurationManager.AppSettings["UseRealDate"] = "true";

            ClearOverrideDateTable();

            var dateService = new DateService();

            // act
            var returnedDate = dateService.GetCurrentDate();

            // assert
            Assert.IsTrue(DateTime.UtcNow.Subtract(returnedDate) < TimeSpan.FromSeconds(1), "Returned date incorrect");
            Assert.AreEqual(DateTimeKind.Utc, returnedDate.Kind, "Returned DateTimeKind is not UTC");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DateProvider_WhenUseRealDateSettingIsFalseAndOverrideDateIsPresent_ShouldReturnOverrideDate()
        {
            // arrange
            ConfigurationManager.AppSettings["UseRealDate"] = "false";

            ClearOverrideDateTable();
            var overrideDate = new DateTime(2015, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
            AddOverrideDateToTable(overrideDate);

            var dateService = new DateService();

            // act
            var returnedDate = dateService.GetCurrentDate();

            // assert
            Assert.AreEqual(overrideDate, returnedDate, "Returned date incorrect");
            Assert.AreEqual(DateTimeKind.Utc, returnedDate.Kind, "Returned DateTimeKind is not UTC");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DateProvider_WhenUseRealDateSettingIsFalseAndOverrideDateIsNotPresent_ShouldReturnUtcNow()
        {
            // arrange
            ConfigurationManager.AppSettings["UseRealDate"] = "false";

            ClearOverrideDateTable();

            var dateService = new DateService();

            // act
            var returnedDate = dateService.GetCurrentDate();

            Assert.IsTrue(DateTime.UtcNow.Subtract(returnedDate) < TimeSpan.FromSeconds(1), "Returned date incorrect");
            Assert.AreEqual(DateTimeKind.Utc, returnedDate.Kind, "Returned DateTimeKind is not UTC");
        }

        private static void ClearOverrideDateTable()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentManagementPolicyContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sqlDelete = "DELETE FROM OverrideDate.OverrideDate";

                connection.Execute(sqlDelete);
            }
        }

        private static void AddOverrideDateToTable(DateTime systemOverrideDate)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["PaymentManagementPolicyContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sqlInsert = @"INSERT INTO OverrideDate.OverrideDate
                                          (SystemOverrideDate) VALUES (@SystemOverrideDate)";

                connection.Execute(sqlInsert, new { systemOverrideDate });
            }
        }
    }
}