using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests
{
    public partial class XrmConfigurationFundingPeriod : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodEntityHasPeriodField()
        {
            TestBase.CrmConfiguration.Entity("sfa_period")
                .Attribute("sfa_period")
                .HasType(XrmDataType.Text)
                .OfLength(50);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodEntityHasStartdateField()
        {
            TestBase.CrmConfiguration.Entity("sfa_period")
                .Attribute("sfa_startdate")
                .HasType(XrmDataType.DateTime);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodEntityHasEnddateField()
        {
            TestBase.CrmConfiguration.Entity("sfa_period")
                .Attribute("sfa_enddate")
                .HasType(XrmDataType.DateTime);
        }
    }
}