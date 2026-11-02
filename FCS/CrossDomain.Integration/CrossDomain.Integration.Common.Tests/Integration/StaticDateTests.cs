namespace CrossDomain.Integration.Common.Tests.Integration
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Model;
    using UnitTests.Common;

    [TestClass]
    public class StaticDateTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void StaticDate_GetCalculationDate_ShouldReturnOverrideDate()
        {
            DateTime overrideDate = new DateTime(2018, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);

            // Arrange
            using (OverrideDateDBContext context = new OverrideDateDBContext())
            {
                context.OverrideDate.RemoveAll();
                context.OverrideDate.Add(new OverrideDate {SystemOverrideDate = overrideDate});
                context.SaveChanges();
            }

            // Act
            using (OverrideDateDBContext context = new OverrideDateDBContext())
            {
                IDate staticDate = new StaticDate(context);
                DateTime returnedDate = staticDate.GetCalculationDate();

                // Assert
                Assert.AreEqual(overrideDate, returnedDate, "Returned date incorrect");
                Assert.AreEqual(DateTimeKind.Utc, returnedDate.Kind, "Returned DateTimeKind is not UTC");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void StaticDate_GetCalculationDate_ShouldReturnUtcNowWhenNoOverrideDateSet()
        {
            // Arrange
            using (OverrideDateDBContext context = new OverrideDateDBContext())
            {
                context.OverrideDate.RemoveAll();
                context.SaveChanges();
            }

            // Act
            using (OverrideDateDBContext context = new OverrideDateDBContext())
            {
                IDate staticDate = new StaticDate(context);
                DateTime returnedDate = staticDate.GetCalculationDate();

                // Assert
                Assert.IsTrue(DateTime.UtcNow.Subtract(returnedDate) < TimeSpan.FromSeconds(1), "Returned date incorrect");
                Assert.AreEqual(DateTimeKind.Utc, returnedDate.Kind, "Returned DateTimeKind is not UTC");
            }
        }
    }
}
