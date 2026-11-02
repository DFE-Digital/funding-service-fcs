namespace SFA.FCT.Xrm.Configuration.Tests.Period_Types
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationPeriodTypes : TestBase
    {
        #region Entity

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodTypeEntityExists()
        {
            CrmConfiguration.Entity("sfa_periodtype").HasDisplayName("Period Type");
        }

        #endregion
    }
}