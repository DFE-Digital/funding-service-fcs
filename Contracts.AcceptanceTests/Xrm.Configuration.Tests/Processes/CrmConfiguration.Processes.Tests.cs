namespace SFA.FCT.Xrm.Configuration.Tests.Processes
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    [TestClass]
    public class XrmConfigurationProcesses : TestBase
    {
        #region Entity

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void ProcessEntityExists()
        {
            CrmConfiguration.Entity("sfa_process").HasDisplayName("Business Procedure");
        }

        #endregion

        #region Relationships

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "79")]
        public void ProcessHasChildStatus()
        {
            CrmConfiguration.Entity("sfa_process").Relationship("sfa_status")
                .HasFieldName("sfa_process")
                .HasDisplayName("Process")
                .HasRequiredLevel(XrmRequirementLevel.None);
        }

        #endregion

        #region Attributes

        #endregion

        #region Forms

        #endregion

        #region Views

        #endregion
    }
}