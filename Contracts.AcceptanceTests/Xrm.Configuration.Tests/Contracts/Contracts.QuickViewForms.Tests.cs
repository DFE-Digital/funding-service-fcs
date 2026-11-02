namespace SFA.FCT.Xrm.Configuration.Tests.Contracts
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationContracts
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "817")]
        public void MasterContractQuickForm()
        {
            var form = CrmConfiguration.Entity("sfa_contract")
                .Form("Master Contract Quick Form", XrmFormType.QuickView);

            form.Field("sfa_number").IsDisabled(false);
            form.Field("sfa_fundingtype").IsDisabled(true);
            form.Field("sfa_ukprn").IsDisabled(false);
            form.Field("sfa_providername").IsDisabled(false);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "73")]
        public void ContractDetailsQuickForm()
        {
            var form = CrmConfiguration.Entity("sfa_contract")
                .Form("Contract Details", XrmFormType.QuickView);

            form.Field("sfa_number").IsDisabled(true);
            form.Field("sfa_contractadviser").IsDisabled(true);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "73")]
        public void ContractStatusQuickForm()
        {
            var form = CrmConfiguration.Entity("sfa_contract")
                .Form("Contract Statuses", XrmFormType.QuickView);

            form.Field("sfa_contractstatus").IsDisabled(true);
            form.Field("sfa_substatus").IsDisabled(true);
        }
    }
}