namespace SFA.FCT.Xrm.Configuration.Tests.Contract_Allocations
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationContractAllocations
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "386")]
        public void ContractAllocationAssociatedViewHasCorrectColumns()
        {
            CrmConfiguration.Entity("sfa_contractallocation").DefaultView()
                .HasColumn("sfa_contractallocationnumber")
                .HasColumn("sfa_fundingstreamid")
                .HasColumn("sfa_description")
                .HasColumn("sfa_maximumcontractvalue")
                .HasColumn("sfa_startdate")
                .HasColumn("sfa_enddate");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "386")]
        public void ContractEntityDefaultViewHasCorrectSort()
        {
            CrmConfiguration.Entity("sfa_contractallocation").DefaultView()
                .HasSortColumn("sfa_contractallocationnumber", XrmSortOrder.Ascending)
                .HasSortColumn("sfa_startdate", XrmSortOrder.Ascending);
        }
    }
}