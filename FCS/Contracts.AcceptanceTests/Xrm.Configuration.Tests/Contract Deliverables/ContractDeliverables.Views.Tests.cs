namespace SFA.FCT.Xrm.Configuration.Tests.Contract_Deliverables
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationContractDeliverables
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "386")]
        public void ContractDeliverablesDefaultViewHasCorrectColumns()
        {
            CrmConfiguration.Entity("sfa_contractdeliverable").DefaultView()
                .HasColumn("sfa_deliverablename")
                .HasColumn("sfa_plannedvalue")
                .HasColumn("sfa_plannedvolume");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "386")]
        public void ContractEntityDefaultViewHasCorrectSort()
        {
            CrmConfiguration.Entity("sfa_contractdeliverable").DefaultView()
                .HasSortColumn("sfa_deliverablename", XrmSortOrder.Ascending);
        }
    }
}