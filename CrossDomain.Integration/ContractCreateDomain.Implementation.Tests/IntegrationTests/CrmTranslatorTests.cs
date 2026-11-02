namespace ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Tests.IntegrationTests;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class CrmTranslatorTests : IntegrationTestBase
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmTranslator_ShouldPopulateProviderOnAllocation()
        {
            // arrange
            SimpleOrg org = GetUkprnFromCrm();

            LookupManager lookupManager = new LookupManager
            {
                BatchId = "1",
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager(),
                OrganizationService = CrmOrganizationService
            };

            lookupManager.Lookup(new LookupCriteria
            {
                UkPrns = new HashSet<string>
                {
                    org.Ukprn
                }
            });

            CrmTranslator translator = new CrmTranslator(lookupManager);
            Entity allocationEntity = new Entity();
            contractAllocationsContractAllocation allocation = new contractAllocationsContractAllocation
            {
                DeliveryOrganisation = org.Ukprn,
                period = new period
                {
                    period1 = "1718",
                    periodType = new periodTypeType
                    {
                        periodTypeCode = periodTypeCodeType.AY
                    }
                },
                fundingStreamPeriodCode = "16-18APPS1718",
                fundingStream = new fundingStream
                {
                    fundingStreamCode = "16-18 APPS"
                }
            };

            // act
            translator.PopulateAttributesViaFieldMapping(allocationEntity, allocation);

            // assert
            Assert.IsTrue(allocationEntity.Attributes.ContainsKey("sfa_deliveryorganisationprovider"), "The sfa_deliveryorganisationprovider column is not populated");
            EntityReference entityReference = allocationEntity.Attributes["sfa_deliveryorganisationprovider"] as EntityReference;
            Assert.AreEqual(org.Id, entityReference.Id, "The sfa_deliveryorganisationprovider column does not have the correct EntityReference");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmTranslator_ShouldPopulateTerminationDataOnAllocation()
        {
            // arrange
            LookupManager lookupManager = new LookupManager
            {
                BatchId = "1",
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager(),
                OrganizationService = CrmOrganizationService
            };

            CrmTranslator translator = new CrmTranslator(lookupManager);
            Entity allocationEntity = new Entity();
            contractAllocationsContractAllocation allocation = new contractAllocationsContractAllocation
            {
                FundingCessationDate = new DateTime(2018, 1, 1),
                StopNewStartsDate = new DateTime(2017, 2, 3)
            };

            // act
            translator.PopulateAttributesViaFieldMapping(allocationEntity, allocation);

            // assert
            Assert.IsTrue(allocationEntity.Attributes.ContainsKey("sfa_stopnewstartsdate"), "The sfa_stopnewstartsdate column is not populated");
            Assert.IsTrue(allocationEntity.Attributes.ContainsKey("sfa_terminationdate"), "The sfa_terminationdate column is not populated");
            Assert.AreEqual(allocationEntity.Attributes["sfa_terminationdate"] as DateTime?, allocation.FundingCessationDate);
            Assert.AreEqual(allocationEntity.Attributes["sfa_stopnewstartsdate"] as DateTime?, allocation.StopNewStartsDate);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmTranslator_ShouldPopulateTerminationDataOnContract()
        {
            // arrange
            LookupManager lookupManager = new LookupManager
            {
                BatchId = "1",
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager(),
                OrganizationService = CrmOrganizationService
            };

            CrmTranslator translator = new CrmTranslator(lookupManager);
            Entity contractEntity = new Entity();
            contractType contract = new contractType
            {
                TerminationDate = new DateTime(2018, 1, 1),
                TerminationReason = sfa_TerminationReasons.ProviderinLiquidation.ToString()
            };

            // act
            translator.PopulateAttributesViaFieldMapping(contractEntity, contract);

            // assert
            Assert.IsTrue(contractEntity.Attributes.ContainsKey("sfa_terminationreason"), "The sfa_terminationreason column is not populated");
            Assert.IsTrue(contractEntity.Attributes.ContainsKey("sfa_terminationdate"), "The sfa_terminationdate column is not populated");
            Assert.AreEqual(contractEntity.Attributes["sfa_terminationdate"] as DateTime?, contract.TerminationDate);
            Assert.AreEqual(((OptionSetValue)contractEntity.Attributes["sfa_terminationreason"]).Value, (int)Enum.Parse(typeof(sfa_TerminationReasons), contract.TerminationReason));
        }

        private SimpleOrg GetUkprnFromCrm()
        {
            var connection = CrmOrganizationService;

            using (var context = new XrmServiceContext(connection))
            {
                var org = context.AccountSet.First(a => a.sfa_UKPRN != null);

                return new SimpleOrg(org.Id, org.sfa_UKPRN);
            }
        }

        private class SimpleOrg
        {
            public SimpleOrg(Guid id, string ukprn)
            {
                Id = id;
                Ukprn = ukprn;
            }

            public Guid Id { get; }
            public string Ukprn { get; }
        }
    }
}