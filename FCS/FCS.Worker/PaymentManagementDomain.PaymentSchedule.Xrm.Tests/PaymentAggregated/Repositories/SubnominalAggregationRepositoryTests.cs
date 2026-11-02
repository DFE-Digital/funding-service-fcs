namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.PaymentAggregated.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using MoreLinq;
    using PaymentSchedule.PaymentAggregated.Repositories;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class SubnominalAggregationRepositoryTests
    {
        private const string UkprnTest = "123_Test";

        [TestMethod, TestCategory("IntegrationTest")]
        public void SubnominalAggregationRepository_ShouldFindRelatedSubnominalWhenItHasBeenRelatedToAnAllocation()
        {
            // arrange
            const string allocationNumber = "Alloc-Test";
            const string subnominalCode = "XXXX-SC-Test";
            const string contractNumber = "XXXX-C-Test";

            string subnominalAggKey = subnominalCode + "_" + allocationNumber + "_Aug-15";

            DeleteSubnominalsForCode(subnominalCode);
            DeleteTestContract(contractNumber);
            DeleteTestAllocation(allocationNumber);

            Guid subnominalAggId = CreateSubnominalAggregation(subnominalAggKey, sfa_paymenttype.Profile);

            Guid contractGuid = CreateTestContract(contractNumber);
            Guid allocationId = CreateTestAllocation(contractGuid, allocationNumber);

            AssociateToContractAllocation(allocationId, subnominalAggId);
            SubnominalAggregationRepository repository = new SubnominalAggregationRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act 
            IReadOnlyCollection<sfa_subnominalaggregation> subnominalsRelatedToAllocationId = repository.GetSubnominalsRelatedToAllocationId(allocationId);

            // assert
            Assert.AreEqual(1, subnominalsRelatedToAllocationId.Count(), "we have not found a related subnominal aggregation");
            Assert.AreEqual(subnominalAggId, subnominalsRelatedToAllocationId.First().Id, "we have not found the correct related subnominal aggregation");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SubnominalAggregationRepository_ShouldGetSubnominalsRelatedSubnominalCodesAndAggregateKeys()
        {
            // arrange
            const string allocationNumber = "Alloc-Test";
            const string subnominalCode1 = "XXXX-SC1-Test";
            const string subnominalCode2 = "XXXX-SC2-Test";

            string subnominalAggKey1 = subnominalCode1 + "_" + allocationNumber + "_Aug-15";
            string subnominalAggKey2 = subnominalCode2 + "_" + allocationNumber + "_Aug-15";

            DeleteSubnominalsForCode(subnominalCode1);
            DeleteSubnominalsForCode(subnominalCode2);

            Guid subnominal1AggId = CreateSubnominalAggregation(subnominalAggKey1, sfa_paymenttype.Profile, subnominalCode1);
            Guid subnominal2AggId = CreateSubnominalAggregation(subnominalAggKey2, sfa_paymenttype.Profile, subnominalCode1);

            SubnominalAggregationRepository repository = new SubnominalAggregationRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act 
            IReadOnlyCollection<sfa_subnominalaggregation> relatedSubnominals = repository.GetSubnominalsRelatedToSubnominalCodesAndAggregateKeys(
                new List<string> { subnominalCode1, subnominalCode2 },
            new List<string> { subnominalAggKey1, subnominalAggKey2 });

            // assert
            Assert.AreEqual(2, relatedSubnominals.Count, "we have not found the related subnominal aggregations");
            Assert.IsTrue(!relatedSubnominals.Select(sa => sa.Id).Except(new List<Guid> { subnominal1AggId, subnominal2AggId }).Any(), "we have not found all the subnominal aggregations");
            var sa1 = relatedSubnominals.Single(sa => sa.sfa_SubnominalAggregateKey == subnominalAggKey1);
            Assert.AreEqual(null, sa1.sfa_AggregatedValue, "the aggregated value has not been retrieved correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SubnominalAggregationRepository_ShouldGetSubnominalsRelatedSubnominalCodesAndAggregateKeysWithAggregatedValuesSet()
        {
            // arrange
            const string allocationNumber = "Alloc-Test";
            const string subnominalCode1 = "XXXX-SC1-Test";
            const string subnominalCode2 = "XXXX-SC2-Test";

            string subnominalAggKey1 = subnominalCode1 + "_" + allocationNumber + "_Aug-15";
            string subnominalAggKey2 = subnominalCode2 + "_" + allocationNumber + "_Aug-15";

            DeleteSubnominalsForCode(subnominalCode1);
            DeleteSubnominalsForCode(subnominalCode2);

            CreateSubnominalAggregation(subnominalAggKey1, sfa_paymenttype.Profile, subnominalCode1, 10.10M);
            CreateSubnominalAggregation(subnominalAggKey2, sfa_paymenttype.Profile, subnominalCode1, 11.11M);

            SubnominalAggregationRepository repository = new SubnominalAggregationRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act 
            IReadOnlyCollection<sfa_subnominalaggregation> relatedSubnominals = repository.GetSubnominalsRelatedToSubnominalCodesAndAggregateKeys(
                new List<string> { subnominalCode1, subnominalCode2 },
            new List<string> { subnominalAggKey1, subnominalAggKey2 });

            // assert
            Assert.AreEqual(2, relatedSubnominals.Count, "we have not found the related subnominal aggregations");
            var sa2 = relatedSubnominals.Single(sa => sa.sfa_SubnominalAggregateKey == subnominalAggKey2);
            var sa1 = relatedSubnominals.Single(sa => sa.sfa_SubnominalAggregateKey == subnominalAggKey1);
            Assert.AreEqual(10.10M, sa1.sfa_AggregatedValue, "the aggregated value has not been retrieved");
            Assert.AreEqual(11.11M, sa2.sfa_AggregatedValue, "the aggregated value has not been retrieved");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SubnominalAggregationRepository_GetSubnominalsRelatedToSubnominalCodesAndAggregateKeys_ShouldReturnEmptyCollectionWhenGivenEmptySubnominalCodesAndAggregateKeys()
        {
            // arrange
            SubnominalAggregationRepository repository = new SubnominalAggregationRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act 
            IReadOnlyCollection<sfa_subnominalaggregation> relatedSubnominals = repository
                .GetSubnominalsRelatedToSubnominalCodesAndAggregateKeys(
                    Enumerable.Empty<string>().ToList(),
                    Enumerable.Empty<string>().ToList());

            // assert
            Assert.IsFalse(relatedSubnominals.Any());
        }

        private void AssociateToContractAllocation(Guid allocationId, Guid subnominalAggregationId)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                AssociateRequest subnominalToAlocation = new AssociateRequest
                {
                    Target =
                        new EntityReference(
                            sfa_subnominalaggregation.EntityLogicalName,
                            subnominalAggregationId),
                    RelatedEntities = new EntityReferenceCollection
                    {
                        new EntityReference(
                            sfa_contractallocation.EntityLogicalName,
                            allocationId)
                    },
                    Relationship = new Relationship("sfa_sfa_subnominalaggregation_sfa_contractall")
                };

                xrmContext.Execute(subnominalToAlocation);
            }
        }

        private void DeleteTestAllocation(string allocationNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                xrmContext.sfa_contractallocationSet.Where(a => a.sfa_contractallocationnumber == allocationNumber)
               .ForEach(a => organizationService.Delete(sfa_contractallocation.EntityLogicalName, a.Id));
            }
        }

        private void DeleteTestContract(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                xrmContext.sfa_contractSet.Where(c => c.sfa_number == contractNumber)
               .ForEach(a => organizationService.Delete(sfa_contract.EntityLogicalName, a.Id));
            }
        }

        private void DeleteSubnominalsForCode(string subnominalCode)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (var xrmserivce = new XrmServiceContext(organizationService))
            {
                xrmserivce.sfa_subnominalaggregationSet.Where(sa => sa.sfa_SubnominalCode == subnominalCode)
                .ForEach(sa => organizationService.Delete(sfa_subnominalaggregation.EntityLogicalName, sa.Id));
            }
        }

        private Guid CreateTestContract(string contractNumber)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_LastApprovedVersion = true,
                sfa_ProviderName = GetOrgEntityReference()
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(contract);
        }

        private EntityReference GetOrgEntityReference()
        {
            Account org = GetOrg();

            if (org == null)
            {
                Account acc = new Account
                {
                    sfa_UKPRN = UkprnTest
                };

                CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(acc);

                org = GetOrg();
            }

            return org.ToEntityReference();
        }

        private Account GetOrg()
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.AccountSet.FirstOrDefault(a => a.sfa_UKPRN == UkprnTest);
            }
        }

        private Guid CreateTestAllocation(Guid contractId, string allocationNumber)
        {
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = allocationNumber,
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId)
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(allocation);
        }

        private Guid CreateSubnominalAggregation(string subnominalAggKey, sfa_paymenttype paymentType, string subnominalCode = null, decimal? aggregatedValue = null)
        {
            sfa_subnominalaggregation subnominalaggregation = new sfa_subnominalaggregation
            {
                sfa_SubnominalAggregateKey = subnominalAggKey,
                sfa_name = subnominalCode,
                sfa_SubnominalCode = subnominalCode,
                sfa_PaymentTypeEnum = paymentType,
                sfa_AggregatedValue = aggregatedValue
            };

            return CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(subnominalaggregation);
        }
    }
}
