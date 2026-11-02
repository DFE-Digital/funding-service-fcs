namespace SFA.FCT.Xrm.Configuration.Tests.Period_Types
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationPeriodTypes 
    {
        #region Relationships

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void PeriodHasChildPeriod()
        {
            CrmConfiguration.Entity("sfa_periodtype").Relationship("sfa_period")
                .HasFieldName("sfa_periodtypeid")
                .HasDisplayName("Period Type")
                .HasRequiredLevel(XrmRequirementLevel.BusinessRequired)
                .HasCascadeDelete(XrmCascadeDeleteType.Restrict);
        }

        #endregion
    }
}