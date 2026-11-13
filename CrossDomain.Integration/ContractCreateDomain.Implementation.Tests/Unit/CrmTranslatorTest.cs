namespace SFA.FCT.ContractCreateDomain.Implementation.Tests.Unit
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Moq;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using Persistence;
    using CrossDomain.Integration.Entities.CorporateContract;

    [TestClass()]
    public class CrmTranslatorTest
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ShouldTranslateContractWithContractNumberSet()
        {
            CrmTranslator translator = GetTranslator();
            Contract contract = new Contract
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
            Contract contract = new Contract
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
            Contract contract = new Contract
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
            contractType contract = new Contract();

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

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldTranslateCurrencyAndDecimalContractValues()
        {
            CrmTranslator translator = GetTranslator();
            ExtendedContractType contract = new ExtendedContractType
            {
                contractValue = 125.50m,
                ValueVariation = 12.25m
            };

            Entity entity = translator.TranslateContract(contract);

            Assert.AreEqual(125.50m, entity.GetAttributeValue<Money>("sfa_contractvalue").Value);
            Assert.AreEqual(12.25m, entity.GetAttributeValue<decimal>("sfa_variation"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldTranslateNullCurrencyAsZero()
        {
            CrmTranslator translator = GetTranslator();

            Entity entity = translator.TranslateContract(new contractType { contractValue = null });

            Assert.AreEqual(0m, entity.GetAttributeValue<Money>("sfa_contractvalue").Value);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldTranslateContractPeriodLookupUsingCompositeKey()
        {
            var lookupManager = new Mock<ILookupManager>();
            var periodId = Guid.NewGuid();
            lookupManager
                .Setup(manager => manager.GetMatchingEntity(CrmLookupType.Period, It.IsAny<CrmCompositeKey>()))
                .Returns(periodId);
            var translator = new CrmTranslator(lookupManager.Object);
            var contract = new contractType
            {
                hierarchyType = hierarchyType.CONTRACT,
                period = new Period
                {
                    period1 = "202627",
                    periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.AY }
                }
            };

            Entity entity = translator.TranslateContract(contract);

            var periodReference = entity.GetAttributeValue<EntityReference>("sfa_periodid");
            Assert.IsNotNull(periodReference);
            Assert.AreEqual(periodId, periodReference.Id);
            lookupManager.Verify(
                manager => manager.GetMatchingEntity(CrmLookupType.Period, It.IsAny<CrmCompositeKey>()),
                Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldTranslateContractOwnerAsSystemUserOrTeam()
        {
            var translator = GetTranslator();
            var systemUserId = Guid.NewGuid();
            var systemUserContract = new contractType
            {
                Owner = new CrmEntityOwner { OwnerId = systemUserId, OwnerType = OwnerType.SystemUser }
            };
            var teamId = Guid.NewGuid();
            var teamContract = new contractType
            {
                Owner = new CrmEntityOwner { OwnerId = teamId, OwnerType = OwnerType.Team }
            };

            var systemUserReference = translator.TranslateContract(systemUserContract)
                .GetAttributeValue<EntityReference>("ownerid");
            var teamReference = translator.TranslateContract(teamContract)
                .GetAttributeValue<EntityReference>("ownerid");

            Assert.AreEqual("systemuser", systemUserReference.LogicalName);
            Assert.AreEqual(systemUserId, systemUserReference.Id);
            Assert.AreEqual("team", teamReference.LogicalName);
            Assert.AreEqual(teamId, teamReference.Id);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldTranslateDirectContractEntityReference()
        {
            var contractId = Guid.NewGuid();
            var entity = GetTranslator().TranslateContract(new contractType { ParentContractId = contractId });
            var reference = entity.GetAttributeValue<EntityReference>("sfa_parentcontractid");

            Assert.IsNotNull(reference);
            Assert.AreEqual(contractId, reference.Id);
            Assert.AreEqual("sfa_contract", reference.LogicalName);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldNotTranslateOwnerWithoutAnId()
        {
            var contract = new contractType
            {
                Owner = new CrmEntityOwner { OwnerId = Guid.Empty, OwnerType = OwnerType.SystemUser }
            };

            Entity entity = GetTranslator().TranslateContract(contract);

            Assert.IsFalse(entity.Attributes.ContainsKey("ownerid"));
        }

        private CrmTranslator GetTranslator()
        {
            Mock<ILookupManager> mockLookupManager = new Mock<ILookupManager>();
            return new CrmTranslator(mockLookupManager.Object);
        }
    }
}
