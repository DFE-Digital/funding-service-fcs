namespace SFA.FCT.Xrm.Configuration.Tests.ContractNumbers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    public partial class XrmConfigurationContractNumbers
    {
        #region Attributes

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "432")]
        public void PeriodEntityHasPeriodField()
        {
            var contractNumber = CrmConfiguration.Entity("sfa_contractnumber");

            contractNumber.Attribute("sfa_prefix")
                .HasType(XrmDataType.Text)
                .OfLength(10);

            contractNumber.Attribute("sfa_contractnumbertype")
                .HasType(XrmDataType.OptionSet);

            contractNumber.Attribute("sfa_lastnumber")
                .HasType(XrmDataType.WholeNumber);

            contractNumber.Attribute("sfa_locked")
                .HasType(XrmDataType.TwoOptions);
        }

        #endregion
    }
}