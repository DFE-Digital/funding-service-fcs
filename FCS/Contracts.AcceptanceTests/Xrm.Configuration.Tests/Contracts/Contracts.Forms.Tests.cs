namespace SFA.FCT.Xrm.Configuration.Tests.Contracts
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationContracts
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormExists()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormHasContractNo()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("sfa_number").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormHasWorkflowHistorySubGrid()
        {
            var view = CrmConfiguration.Entity("sfa_contracttransitionhistory").View("Contract Workflow History");

            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .HasTab("Workflow History")
                .HasSubGridWithView(view.ViewId.ToUpperInvariant());
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormHasContractValue()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("sfa_contractvalue").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormHasLatestVersion()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("sfa_latestversion").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormHasLastApprovedVersion()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("sfa_lastapprovedversion").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormHasContractAdviser()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("sfa_contractadviser").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormHasUkprn()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("sfa_ukprn").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormHasProviderName()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("sfa_providername").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormHasFundingType()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("sfa_fundingtype").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormHasContractVersion()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("sfa_version").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormHasContractStatus()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("sfa_contractstatus").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormHasContractSubStatus()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("Sub Status").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormHasStartDate()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("sfa_startdate").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormHasEndDate()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("sfa_enddate").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormHasTaskOwner()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("sfa_contractadviser").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractFormHasOwner()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("ownerid").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractEntityHasFilteredLookupToTransition()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("sfa_nextaction")
                .Lookup()
                .FilterAttribute("sfa_substatus")
                .DisableMRU(true)
                .AutoResolve(false)
                .AllowFilterOff(false);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "386")]
        public void ContractEntityHasAllocationSubGrid()
        {
            var associatedView =
                CrmConfiguration.Entity("sfa_contractallocation")
                    .DefaultView()
                    .ViewId;

            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .HasTab("tabGeneral")
                .HasSubGridWithView(associatedView.ToUpperInvariant());
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "72")]
        public void ContractEntityHasPreviousVersion()
        {
            CrmConfiguration.Entity("sfa_contract").Form("Information", XrmFormType.Main)
                .Field("sfa_previousversion")
                .Lookup()
                .DisableMRU(true)
                .AutoResolve(false)
                .AllowFilterOff(false);
        }
    }
}