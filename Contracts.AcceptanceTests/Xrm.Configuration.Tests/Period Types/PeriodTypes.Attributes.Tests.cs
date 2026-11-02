namespace SFA.FCT.Xrm.Configuration.Tests.Period_Types
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationPeriodTypes 
    {
        #region Attributes

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodEntityHasPeriodTypeCodeField()
        {
            CrmConfiguration.Entity("sfa_periodtype")
                .Attribute("sfa_periodtypecode")
                .HasType(XrmDataType.Text)
                .OfLength(10);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodEntityHasPeriodTypeNameField()
        {
            CrmConfiguration.Entity("sfa_periodtype")
                .Attribute("sfa_periodtypename")
                .HasType(XrmDataType.Text)
                .OfLength(100);
        }

        #endregion
    }
}