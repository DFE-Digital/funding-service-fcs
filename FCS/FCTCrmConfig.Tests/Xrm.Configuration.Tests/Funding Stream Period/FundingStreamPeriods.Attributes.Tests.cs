using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests
{
    public partial class XrmConfigurationFundingStreamPeriods : TestBase   
    {
       
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void FundingStreamPeriodEntityHasFundingStreamPeriodCodeField()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstreamperiod")
                .Attribute("sfa_fundingstreamperiodcode")
                .HasType(XrmDataType.Text)
                .OfLength(100);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void FundingStreamPeriodEntityHasFundingStreamPeriodNameField()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstreamperiod")
                .Attribute("sfa_fundingstreamperiodname")
                .HasType(XrmDataType.Text)
                .OfLength(100);
        }

       
    }
}