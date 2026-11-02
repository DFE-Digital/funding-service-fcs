namespace SFA.FCT.Xrm.Configuration.Tests.Unit_of_Procurement
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class XrmConfigurationUnitofProcurement : TestBase
    {
        #region Entity

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "3549")]
        public void UnitofProcurementEntityExists()
        {
            CrmConfiguration.Entity("sfa_unitofprocurement")
                .HasDisplayName("Unit of Procurement");
        }

        #endregion
    }
}