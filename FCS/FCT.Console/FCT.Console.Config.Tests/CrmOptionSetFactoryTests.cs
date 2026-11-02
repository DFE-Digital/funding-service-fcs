namespace FCT.Console.Config.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Synchronizers.Writers.CRM;

    [TestClass]
    public class CrmOptionSetFactoryTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CrmOptionSetFactory_ShouldGetFundingStreamPaymentTypeOptionSet_WhenPassedAValidPaymentMethod()
        {
            // act
            OptionSetValue payOnActualsOptionSetValue =
                CrmOptionSetFactory.CreateFundingStreamPaymentTypeFromString("Pay on Actuals");

            OptionSetValue payOnProfileOptionSetValue =
               CrmOptionSetFactory.CreateFundingStreamPaymentTypeFromString("Pay on Profile");

            OptionSetValue paidExternallyOptionSetValue =
              CrmOptionSetFactory.CreateFundingStreamPaymentTypeFromString("Paid Externally");

            OptionSetValue noCalcAndNoPayOptionSetValue =
              CrmOptionSetFactory.CreateFundingStreamPaymentTypeFromString("Not Calculated or Paid");

            // assert
            Assert.AreEqual(sfa_fundingstreampaymenttype.PayOnActuals, (sfa_fundingstreampaymenttype)payOnActualsOptionSetValue.Value, "Pay on Actuals not supported");
            Assert.AreEqual(sfa_fundingstreampaymenttype.PayOnProfile, (sfa_fundingstreampaymenttype)payOnProfileOptionSetValue.Value, "Pay on Profile not supported");
            Assert.AreEqual(sfa_fundingstreampaymenttype.NotPaid, (sfa_fundingstreampaymenttype)paidExternallyOptionSetValue.Value, "Paid Externally not supported");
            Assert.AreEqual(sfa_fundingstreampaymenttype.NoCalcAndNoPay, (sfa_fundingstreampaymenttype)noCalcAndNoPayOptionSetValue.Value, "Not Calculated or Paid not supported");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmOptionSetFactory_ShouldGetPaymentCappingLevelOptionSet_WhenPassedAValidPaymentCappingLevel()
        {
            // act
            OptionSetValue deliverableGroupOptionSetValue =
                CrmOptionSetFactory.CreatePaymentCappingLevelFromString("Deliverable Group");

            OptionSetValue contractAlloccationOptionSetValue =
               CrmOptionSetFactory.CreatePaymentCappingLevelFromString("Contract Allocation");

            OptionSetValue deliverableLineOptionSetValue =
              CrmOptionSetFactory.CreatePaymentCappingLevelFromString("Deliverable Line");

            OptionSetValue emptyOptionSetValue =
              CrmOptionSetFactory.CreatePaymentCappingLevelFromString(string.Empty);


            // assert
            Assert.AreEqual(sfa_paymentcappinglevel.Group, (sfa_paymentcappinglevel)deliverableGroupOptionSetValue.Value, "Deliverable Group not supported");
            Assert.AreEqual(sfa_paymentcappinglevel.ContractAllocation, (sfa_paymentcappinglevel)contractAlloccationOptionSetValue.Value, "Contract Allocation not supported");
            Assert.AreEqual(sfa_paymentcappinglevel.DeliverableLine,
                (sfa_paymentcappinglevel)deliverableLineOptionSetValue.Value, "Deliverable Line not supported");

            Assert.IsNull(emptyOptionSetValue, "An Empty should have returned back a null");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CrmOptionSetFactory_ShouldGetCappingGroupOptionSet_WhenPassedAValidCappingGroup()
        {
            // act
            OptionSetValue apprenticeshipsOptionSetValue =
                CrmOptionSetFactory.CreateCappingGroupFromString("Apprenticeships");

            OptionSetValue nonapprenticeshipsOptionSetValue =
                CrmOptionSetFactory.CreateCappingGroupFromString("Non-Apprenticeships");

            OptionSetValue otherASBOptionSetValue =
                CrmOptionSetFactory.CreateCappingGroupFromString("Other ASB");

            OptionSetValue emptyOptionSetValue =
              CrmOptionSetFactory.CreateCappingGroupFromString(string.Empty);

            // assert
            Assert.AreEqual(sfa_cappinggroup.Apprenticeships, (sfa_cappinggroup)apprenticeshipsOptionSetValue.Value, "Apprenticeships Capping Group not supported");
            Assert.AreEqual(sfa_cappinggroup.NonApprenticeships, (sfa_cappinggroup)nonapprenticeshipsOptionSetValue.Value, "Non-Apprenticeships Capping Group not supported");
            Assert.AreEqual(sfa_cappinggroup.OtherASB,
                (sfa_cappinggroup)otherASBOptionSetValue.Value, "Other ASB Capping Group not supported");

            Assert.IsNull(emptyOptionSetValue, "An Empty should have returned back a null");
        }




    }
}
