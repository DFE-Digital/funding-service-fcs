namespace SFA.FCT.Xrm.Configuration.Tests.Funding_Stream
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationFundingStreams 
    {
        #region Relationships

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "812")]
        public void FundingStreamHasChildFundingStreamPeriod()
        {
            CrmConfiguration.Entity("sfa_fundingstream")
                .Relationship("sfa_fundingstreamperiod")
                .HasFieldName("sfa_fundingstreamcodeid")
                .HasDisplayName("Funding Stream Code")
                .HasRequiredLevel(XrmRequirementLevel.BusinessRequired)
                .HasCascadeDelete(XrmCascadeDeleteType.Restrict);
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "386")]
        public void FundingStreamChildContractAllocation()
        {
            CrmConfiguration.Entity("sfa_fundingstream")
                .Relationship("sfa_contractallocation")
                .HasFieldName("sfa_fundingstreamid")
                .HasDisplayName("Funding Stream")
                .HasRequiredLevel(XrmRequirementLevel.None)
                .HasCascadeDelete(XrmCascadeDeleteType.Restrict);
        }

        #endregion
    }
}