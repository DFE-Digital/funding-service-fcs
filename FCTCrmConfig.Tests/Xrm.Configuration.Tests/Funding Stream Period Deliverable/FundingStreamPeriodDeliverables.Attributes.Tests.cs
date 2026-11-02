using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;

namespace SFA.FCT.Xrm.Configuration.Tests
{
    public partial class XrmConfigurationFundingStreamPeriodDeliverables : TestBase   
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2175")]
        public void FundingStreamPeriodDeliverableHasDeliverableCode()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstreamperioddeliverable")
                .Attribute("sfa_deliverablecode")
                .HasType(XrmDataType.WholeNumber)
                ;
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2175")]
        public void FundingStreamPeriodDeliverableHasMandatory()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstreamperioddeliverable")
                .Attribute("sfa_mandatory")
                .HasType(XrmDataType.TwoOptions)
                ;
        }
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "2175")]
        public void FundingStreamPeriodDeliverableHasParentType()
        {
            TestBase.CrmConfiguration.Entity("sfa_fundingstreamperioddeliverable")
                .Attribute("sfa_parentdeliverabletype")
                .HasType(XrmDataType.OptionSet)
                ;
        }   
    }
}