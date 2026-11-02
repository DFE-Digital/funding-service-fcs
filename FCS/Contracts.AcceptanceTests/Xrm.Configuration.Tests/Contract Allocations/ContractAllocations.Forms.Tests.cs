namespace SFA.FCT.Xrm.Configuration.Tests.Contract_Allocations
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationContractAllocations
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "73")]
        public void AllocationFormExists()
        {
            CrmConfiguration.Entity("sfa_contractallocation").Form("Information", XrmFormType.Main);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "73")]
        public void AllocationFormHasDeliverableSubGrid()
        {
            var view = CrmConfiguration.Entity("sfa_contractdeliverable").DefaultView();

            CrmConfiguration.Entity("sfa_contractallocation").Form("Information", XrmFormType.Main)
                .HasTab("Details")
                .HasSubGridWithView(view.ViewId.ToUpperInvariant());
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "73")]
        public void AllocationFormHasFundingStream()
        {
            CrmConfiguration.Entity("sfa_contractallocation").Form("Information", XrmFormType.Main)
                .Field("sfa_fundingstreamid").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "73")]
        public void AllocationFormHasAllocationValue()
        {
            CrmConfiguration.Entity("sfa_contractallocation").Form("Information", XrmFormType.Main)
                .Field("sfa_maximumcontractvalue").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "73")]
        public void AllocationFormHasFundingStreamPeriod()
        {
            CrmConfiguration.Entity("sfa_contractallocation").Form("Information", XrmFormType.Main)
                .Field("sfa_fundingstreamperiodid").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "73")]
        public void AllocationFormHasStartDate()
        {
            CrmConfiguration.Entity("sfa_contractallocation").Form("Information", XrmFormType.Main)
                .Field("sfa_startdate").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "73")]
        public void AllocationFormHasEndDate()
        {
            CrmConfiguration.Entity("sfa_contractallocation").Form("Information", XrmFormType.Main)
                .Field("sfa_enddate").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "73")]
        public void AllocationFormContractDetailsQuickViewForm()
        {
            var form = CrmConfiguration.Entity("sfa_contract")
                .Form("Contract Details", XrmFormType.QuickView);

            CrmConfiguration.Entity("sfa_contractallocation").Form("Information", XrmFormType.Main)
                .HasTab("Details")
                .HasQuickViewForm("Contract Details", form.FormId.ToUpperInvariant());
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "73")]
        public void AllocationFormContractStatusesQuickViewForm()
        {
            var form = CrmConfiguration.Entity("sfa_contract")
                .Form("Contract Statuses", XrmFormType.QuickView);

            CrmConfiguration.Entity("sfa_contractallocation").Form("Information", XrmFormType.Main)
                .HasTab("Details")
                .HasQuickViewForm("Contract Statuses", form.FormId.ToUpperInvariant());
        }
    }
}