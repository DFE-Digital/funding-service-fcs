
namespace SFA.FCT.Xrm.Configuration.Tests.Subnominal
{
    using System;
    using System.Text;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestFramework;

    #region Fields
    public partial class XrmConfigurationSubnominals
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "5043")]
        public void SubnominalEntityContainsSubnominalCode()
        {
            CrmConfiguration.Entity("sfa_subnominalaggregation")
               .Attribute("sfa_subnominalcode")
               .HasType(XrmDataType.Text)
               .OfLength(100)
               .HasDisplayName("Subnominal Code");
        }


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "5043")]
        public void SubnominalEntityContainsPaymentType()
        {
            CrmConfiguration.Entity("sfa_subnominalaggregation")
             .Attribute("sfa_paymenttype")
             .HasType(XrmDataType.OptionSet)
             .HasDisplayName("Payment Type");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "5043")]
        public void SubnominalEntityContainsAggregatedValue()
        {
            CrmConfiguration.Entity("sfa_subnominalaggregation")
            .Attribute("sfa_aggregatedvalue")
            .HasType(XrmDataType.Decimal)
            .HasDisplayName("Aggregated Value");
        }

        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "5043")]
        public void SubnominalEntityContainsPostedFlag()
        {
            CrmConfiguration.Entity("sfa_subnominalaggregation")
            .Attribute("sfa_posted")
            .HasType(XrmDataType.TwoOptions)
            .HasDisplayName("Posted");
        }
    }
    # endregion Fields
}
