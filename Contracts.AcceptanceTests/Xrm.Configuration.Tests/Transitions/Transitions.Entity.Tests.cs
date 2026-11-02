namespace SFA.FCT.Xrm.Configuration.Tests.Transitions
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationTransitions : TestBase
    {
        #region Entity

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "70")]
        public void TransitionEntityExists()
        {
            CrmConfiguration.Entity("sfa_transition").HasDisplayName("Transition").IsUserOwned();
        }

        #endregion
    }
}