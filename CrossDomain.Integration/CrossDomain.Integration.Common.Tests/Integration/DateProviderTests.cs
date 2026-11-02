namespace CrossDomain.Integration.Common.Tests.Integration
{
    using System;
    using System.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using UnitTests.Common;

    [TestClass]
    public class DateProviderTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void DateProvider_WhenUseRealDateSettingIsTrueAndOverrideDateIsPresent_ShouldReturnUtcNow()
        {
            DateTime overrideDate = new DateTime(2015, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);

            // arrange
            ConfigurationManager.AppSettings["UseRealDate"] = "true";

            using (OverrideDateDBContext context = new OverrideDateDBContext())
            {
                context.OverrideDate.RemoveAll();
                context.OverrideDate.Add(new OverrideDate { SystemOverrideDate = overrideDate });
                context.SaveChanges();
            }

            // act
            using (OverrideDateDBContext context = new OverrideDateDBContext())
            {
                DateProvider dateProvider = new DateProvider();
                DateTime returnedDate = dateProvider.GetDate(new ConnectionInfo(null, context.Database.Connection));

                // assert
                Assert.IsTrue(DateTime.UtcNow.Subtract(returnedDate) < TimeSpan.FromSeconds(1), "Returned date incorrect");
                Assert.AreEqual(DateTimeKind.Utc, returnedDate.Kind, "Returned DateTimeKind is not UTC");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DateProvider_WhenUseRealDateSettingIsTrueAndOverrideDateIsNotPresent_ShouldReturnUtcNow()
        {
            // arrange
            ConfigurationManager.AppSettings["UseRealDate"] = "true";

            using (OverrideDateDBContext context = new OverrideDateDBContext())
            {
                context.OverrideDate.RemoveAll();
                context.SaveChanges();
            }

            // act
            using (OverrideDateDBContext context = new OverrideDateDBContext())
            {
                DateProvider dateProvider = new DateProvider();
                DateTime returnedDate = dateProvider.GetDate(new ConnectionInfo(null, context.Database.Connection));

                // assert
                Assert.IsTrue(DateTime.UtcNow.Subtract(returnedDate) < TimeSpan.FromSeconds(1), "Returned date incorrect");
                Assert.AreEqual(DateTimeKind.Utc, returnedDate.Kind, "Returned DateTimeKind is not UTC");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DateProvider_WhenUseRealDateSettingIsFalseAndOverrideDateIsPresent_ShouldReturnOverrideDate()
        {
            DateTime overrideDate = new DateTime(2015, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);

            // arrange
            ConfigurationManager.AppSettings["UseRealDate"] = "false";

            using (OverrideDateDBContext context = new OverrideDateDBContext())
            {
                context.OverrideDate.RemoveAll();
                context.OverrideDate.Add(new OverrideDate { SystemOverrideDate = overrideDate });
                context.SaveChanges();
            }

            // act
            using (OverrideDateDBContext context = new OverrideDateDBContext())
            {
                DateProvider dateProvider = new DateProvider();
                DateTime returnedDate = dateProvider.GetDate(new ConnectionInfo(null, context.Database.Connection));

                // assert
                Assert.AreEqual(overrideDate, returnedDate, "Returned date incorrect");
                Assert.AreEqual(DateTimeKind.Utc, returnedDate.Kind, "Returned DateTimeKind is not UTC");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DateProvider_WhenUseRealDateSettingIsFalseAndOverrideDateIsNotPresent_ShouldReturnUtcNow()
        {
            // arrange
            ConfigurationManager.AppSettings["UseRealDate"] = "false";

            using (OverrideDateDBContext context = new OverrideDateDBContext())
            {
                context.OverrideDate.RemoveAll();
                context.SaveChanges();
            }

            // act
            using (OverrideDateDBContext context = new OverrideDateDBContext())
            {
                DateProvider dateProvider = new DateProvider();
                DateTime returnedDate = dateProvider.GetDate(new ConnectionInfo(null, context.Database.Connection));

                // assert
                Assert.IsTrue(DateTime.UtcNow.Subtract(returnedDate) < TimeSpan.FromSeconds(1), "Returned date incorrect");
                Assert.AreEqual(DateTimeKind.Utc, returnedDate.Kind, "Returned DateTimeKind is not UTC");
            }
        }
    }
}
