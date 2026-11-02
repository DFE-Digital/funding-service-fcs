namespace SFA.FCT.Xrm.Configuration.Tests.Contract_Deliverable_Periods
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationContractDeliverablePeriods
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "74")]
        public void ContractDeliverablePeriodsDefaultViewHasCorrectColumns()
        {
            CrmConfiguration.Entity("sfa_contractdeliverableperiod").DefaultView()
                .HasColumn("sfa_periodname")
                .HasColumn("sfa_plannedvalue")
                .HasColumn("sfa_plannedvolume");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "386")]
        public void ContractEntityDefaultViewHasCorrectSort()
        {
            CrmConfiguration.Entity("sfa_contractdeliverableperiod").DefaultView()
                .HasSortColumn("sfa_displayorder", XrmSortOrder.Ascending);
        }
    }
}