namespace SFA.FCT.ContractCreateDomain.Implementation.Tests.Unit
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Moq;
    using Persistence;
    using CrossDomain.Integration.Entities.CorporateContract;

    [TestClass()]
    public class CrmTranslatorTest
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ShouldTranslateContractWithContractNumberSet()
        {
            CrmTranslator translator = GetTranslator();
            contract contract = new contract
            {
                contractNumber = "2"
            };
 
            Entity entity = translator.TranslateContract(contract);
            Assert.IsTrue(entity.Attributes.Count(a => a.Key == "sfa_number") == 1);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ShouldTranslateContract_WithDasLevyFieldsSet()
        {
            CrmTranslator translator = GetTranslator();
            contract contract = new contract
            {
                SkipReviewAndInternalApproval = true,
                SkipCaseloadAssignment = true,
                SkipDocumentMerge = true
            };

            Entity entity = translator.TranslateContract(contract);
            Assert.IsTrue(entity.GetAttributeValue<bool>("sfa_skipreviewandinternalapproval"));
            Assert.IsTrue(entity.GetAttributeValue<bool>("sfa_skipcaseloadassignment"));
            Assert.IsTrue(entity.GetAttributeValue<bool>("sfa_skipdocumentmerge"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ShouldTranslateContractWithStartDateGoodSet()
        {
            CrmTranslator translator = GetTranslator();
            contract contract = new contract
            {
                startDate = new DateTime(2016, 7, 31)
            };
            
            Entity entity = translator.TranslateContract(contract);
            Assert.IsTrue(entity.Attributes.Count(a => a.Key == "sfa_startdate") == 1);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldTranslateContractWithIsNonFinancialAmendmentWhenNotSetForContract()
        {
            CrmTranslator translator = GetTranslator();
            contractType contract = new contract();

            Entity entity = translator.TranslateContract(contract);
            Assert.IsTrue(entity.Attributes.Count(a => a.Key == "sfa_isnonfinancialamendment") == 1, "The attribute is not present");
            Assert.AreEqual(null, entity.GetAttributeValue<bool?>("sfa_isnonfinancialamendment"), "The attribute value is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldTranslateContractWithIsNonFinancialAmendmentWhenSet()
        {
            CrmTranslator translator = GetTranslator();
            ExtendedContractType contract = new ExtendedContractType
            {
                IsNonFinancialAmendment = true
            };

            Entity entity = translator.TranslateContract(contract);
            Assert.IsTrue(entity.Attributes.Count(a => a.Key == "sfa_isnonfinancialamendment") == 1, "The attribute is not present");
            Assert.AreEqual(true, entity.GetAttributeValue<bool?>("sfa_isnonfinancialamendment"), "The attribute value is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldTranslateContractWithIsNonFinancialAmendmentWhenNotSet()
        {
            CrmTranslator translator = GetTranslator();
            ExtendedContractType contract = new ExtendedContractType();

            Entity entity = translator.TranslateContract(contract);
            Assert.IsTrue(entity.Attributes.Count(a => a.Key == "sfa_isnonfinancialamendment") == 1, "The attribute is not present");
            Assert.AreEqual(null, entity.GetAttributeValue<bool?>("sfa_isnonfinancialamendment"), "The attribute value is not correct");
        }

        private CrmTranslator GetTranslator()
        {
            Mock<LookupManager> mockLookupManager = new Mock<LookupManager>();
            return new CrmTranslator(mockLookupManager.Object);
        }
    }
}
