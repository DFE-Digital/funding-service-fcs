namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_2
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Common.Models;
    using ContractManagement.DataStore;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.Appendix2;
    using Framework.Logging;
    using Integration;
    using IoC;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentManagementDomain.PolicyCache.DataStore;
    using UnitTests.Common;

    [TestClass]
    public class Appendix2DocumentCreatorOrderTests
    {
        // “Funding Agreement” pages order Rules from story 23208
        // ======================================================
        // “Funding Agreement” pages will be produced in this order:
        //      Contract allocations where the Delivery Org either is not specified or is the same as the Contracting Org:
        //          In the "Contract Document Display Order" for the FSP's
        //      Remaining contract allocations:
        //          Ordered by Delivery Org(provider name)
        //          For any given Delivery Org, ordered in the "Contract Document Display Order" for the FSP's

        [TestMethod, TestCategory("IntegrationTest")]
        public void Appendix2DocumentCreator_MultipleOrgsNonEFA_ShouldReturnFundingAgreementsInCorrectOrderWhenNoAllocationsHaveADeliveryorg()
        {

            // Arrange 
            contractType contractType = TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractAeb1819.json")
                .SetContractor(ukprn: 88888888, legalName: "Contract provider name")
                .SetDefaultAllocationDescriptions();

            contractType.fundingType.fundingTypeCode = "MAIN";

            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests;

            var container = GetDocumentGenerationEndpointContainer();
            using (container.BeginScope())
            {
                var appendix2DocumentCreator = new Appendix2DocumentCreator(
                    container.Resolve<ITemplateRepository>(),
                    new DocumentConfigurationSource(
                        container.Resolve<IFundingStreamPeriodRepository>(), 
                        container.Resolve<IFspDeliverableRepository>(),
                        new FundingTypeFundingPeriodRepository(container.Resolve<DocumentsDomainDbContext>())),
                    container.Resolve<IFundingStreamPeriodRepository>());

                // act
                documentGenerationRequests = appendix2DocumentCreator.SupplyDocumentGenerationRequest("TestMasterContractNumber",
                                                contractType, ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);
            }

            // Assert
            string[] sortedOrderStringKeys = documentGenerationRequests.OrderBy(entry => entry.Key)
                                                                       .Select(k => k.Key)
                                                                       .ToArray();

            Assert.AreEqual("2001-Contract provider name-001-Allocation Description APPS1000-20180801-00", sortedOrderStringKeys[0],
                "NonEFA DocumentGenerationRequest - Where allocation with no delivery org, APPS1000 is in the wrong order");
            Assert.AreEqual("2001-Contract provider name-002-Allocation Description 16TR1300-20180801-00", sortedOrderStringKeys[1],
                "NonEFA DocumentGenerationRequest - Where allocation with no delivery org, 16TR1300 is in the wrong order");
            Assert.AreEqual("2001-Contract provider name-003-Allocation Description AEC3200-20180801-00", sortedOrderStringKeys[2],
                "NonEFA DocumentGenerationRequest - Where allocation with no delivery org, AEC3200 is in the wrong order");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Appendix2DocumentCreator_MultipleOrgsNonEFA_ShouldReturnFundingAgreementsInCorrectOrderWhenAllAllocationsHaveADeliveryorgThatIsTheSameAsContractOrg()
        {
            // Arrange 
            contractType contractType = TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractAeb1819.json")
                .SetContractor(ukprn: 88888888, legalName: "Contract provider name")
                .SetDefaultAllocationDescriptions()
                .SetAllocationDeliveryOrgsToSameAsContractor();

            contractType.fundingType.fundingTypeCode = "MAIN";

            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests;

            var container = GetDocumentGenerationEndpointContainer();
            using (container.BeginScope())
            {
                var appendix2DocumentCreator = new Appendix2DocumentCreator(
                    container.Resolve<ITemplateRepository>(),
                    new DocumentConfigurationSource(container.Resolve<IFundingStreamPeriodRepository>(), 
                        container.Resolve<IFspDeliverableRepository>(), new FundingTypeFundingPeriodRepository(container.Resolve<DocumentsDomainDbContext>())),
                    container.Resolve<IFundingStreamPeriodRepository>());

                // act
                documentGenerationRequests = appendix2DocumentCreator.SupplyDocumentGenerationRequest("TestMasterContractNumber",
                                                contractType, ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);
            }

            // Assert
            Assert.AreEqual(3, documentGenerationRequests.Count, "Incorrect number of DocumentGenerationRequest returned");

            List<KeyValuePair<string, DocumentGenerationRequest>> documentGenerationRequestKeyValues = documentGenerationRequests.OrderBy(d => d.Key)
                .ToList();

            // the group id is the allocation number for non EFA
            Assert.IsTrue(documentGenerationRequestKeyValues[0].Value.GroupId == "APPS-1000",
                "NonEFA DocumentGenerationRequest - Where all allocations with delivery org the same as contract org, APPS1000 is in the wrong order");
            Assert.IsTrue(documentGenerationRequestKeyValues[1].Value.GroupId == "16TR-1300",
                "NonEFA DocumentGenerationRequest - Where all allocations with delivery org the same as contract org, 16TR1300 is in the wrong order");
            Assert.IsTrue(documentGenerationRequestKeyValues[2].Value.GroupId == "AEC-3200",
                "NonEFA DocumentGenerationRequest - Where all allocations with delivery org the same as contract org, AEC3200 is in the wrong order");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Appendix2DocumentCreator_MultipleOrgsNonEFA_ShouldReturnFundingAgreementsInCorrectOrderWhenAllAllocationHaveADeliveryorgThatAreDifferentToContractOrg()
        {
            // Arrange 
            contractType contractType = TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractAeb1819.json")
                .SetContractor(ukprn: 88888888, legalName: "Contract provider name")
                .SetDefaultAllocationDescriptions();
            contractType.fundingType.fundingTypeCode = "MAIN";

            contractType.contractAllocations[0].SetDeliveryOrganisation(deliveryUkprn: 1000, deliveryLegalName: "Allocation Provider name APPS1000");
            contractType.contractAllocations[1].SetDeliveryOrganisation(deliveryUkprn: 1300, deliveryLegalName: "Allocation Provider name 16TR1300");
            contractType.contractAllocations[2].SetDeliveryOrganisation(deliveryUkprn: 3200, deliveryLegalName: "Allocation Provider name AEC3200");

            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests;

            var container = GetDocumentGenerationEndpointContainer();
            using (container.BeginScope())
            {
                var appendix2DocumentCreator = new Appendix2DocumentCreator(
                    container.Resolve<ITemplateRepository>(),
                    new DocumentConfigurationSource(container.Resolve<IFundingStreamPeriodRepository>(), 
                        container.Resolve<IFspDeliverableRepository>(), new FundingTypeFundingPeriodRepository(container.Resolve<DocumentsDomainDbContext>())),
                    container.Resolve<IFundingStreamPeriodRepository>());

                // act
                documentGenerationRequests = appendix2DocumentCreator.SupplyDocumentGenerationRequest("TestMasterContractNumber",
                    contractType, ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);
            }

            string[] sortedOrderStringKeys = documentGenerationRequests.OrderBy(entry => entry.Key)
                                                                       .Select(k => k.Key)
                                                                       .ToArray();

            Assert.AreEqual(3, documentGenerationRequests.Count, "Incorrect number of DocumentGenerationRequest returned");
            Assert.IsTrue(sortedOrderStringKeys[0].Contains("16TR1300"),
                "NonEFA DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, APPS1000 is in the wrong order");
            Assert.IsTrue(sortedOrderStringKeys[1].Contains("AEC3200"),
                "NonEFA DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, AEC3200 is in the wrong order");
            Assert.IsTrue(sortedOrderStringKeys[2].Contains("APPS1000"),
                "NonEFA DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, APPS1000 is in the wrong order");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Appendix2DocumentCreator_MultipleOrgsNonEFA_ShouldReturnFundingAgreementsInCorrectOrderWhenOnlyOneAllocationHasADeliveryorgThatIsDifferentToContractOrg()
        {
            // Arrange 
            contractType contractType = TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractAeb1819.json")
                .SetContractor(ukprn: 88888888, legalName: "Contract provider name")
                .SetDefaultAllocationDescriptions()
                .SetAllocationDeliveryOrgsToSameAsContractor();
            contractType.fundingType.fundingTypeCode = "MAIN";

            contractType.contractAllocations[0]
                .SetDeliveryOrganisation(deliveryUkprn: 1000, deliveryLegalName: "Allocation Provider name APPS1000");

            contractType.contractAllocations[1]
                .SetDeliveryOrganisation(deliveryUkprn: 1300, deliveryLegalName: "Allocation Provider name 16TR1300");

            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests;

            var container = GetDocumentGenerationEndpointContainer();
            using (container.BeginScope())
            {
                var appendix2DocumentCreator = new Appendix2DocumentCreator(
                    container.Resolve<ITemplateRepository>(),
                    new DocumentConfigurationSource(container.Resolve<IFundingStreamPeriodRepository>(), 
                        container.Resolve<IFspDeliverableRepository>(), new FundingTypeFundingPeriodRepository(container.Resolve<DocumentsDomainDbContext>())),
                    container.Resolve<IFundingStreamPeriodRepository>());

                // act
                documentGenerationRequests = appendix2DocumentCreator.SupplyDocumentGenerationRequest("TestMasterContractNumber",
                    contractType, ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);
            }

            // the group id is the allocation number for non EFA
            Assert.AreEqual(3, documentGenerationRequests.Count, "Incorrect number of DocumentGenerationRequest returned");
            List<KeyValuePair<string, DocumentGenerationRequest>> documentGenerationRequestKeyValues = documentGenerationRequests.OrderBy(d => d.Key)
                .ToList();

            Assert.IsTrue(documentGenerationRequestKeyValues[0].Value.GroupId == "AEC-3200",
                "NonEFA DocumentGenerationRequest - Where one allocation delivery org is different to contract org, AEC3200 is in the wrong order");
            Assert.IsTrue(documentGenerationRequestKeyValues[1].Value.GroupId == "16TR-1300",
                "NonEFA DocumentGenerationRequest - Where one allocation delivery org is different to contract org, 16TR1300 is in the wrong order");
            Assert.IsTrue(documentGenerationRequestKeyValues[2].Value.GroupId == "APPS-1000",
                "NonEFA DocumentGenerationRequest - Where one allocation delivery org is different to contract org, APPS1000 is in the wrong order");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Appendix2DocumentCreator_MultipleOrgsEFA1718_ShouldReturnFundingAgreementsInCorrectOrderWhenNoAllocationsHaveADeliveryorg()
        {
            // Arrange 
            contractType contractType =
                TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractEfa.json")
                    .SetContractor(ukprn: 88888888, legalName: "Contract provider name")
                    .SetDefaultAllocationDescriptions();

            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests;

            var container = GetDocumentGenerationEndpointContainer();
            using (container.BeginScope())
            {
                var appendix2DocumentCreator = new Appendix2DocumentCreator(
                    container.Resolve<ITemplateRepository>(),
                    new DocumentConfigurationSource(container.Resolve<IFundingStreamPeriodRepository>(), 
                        container.Resolve<IFspDeliverableRepository>(),
                        new FundingTypeFundingPeriodRepository(container.Resolve<DocumentsDomainDbContext>())),
                    container.Resolve<IFundingStreamPeriodRepository>());

                // act
                documentGenerationRequests = appendix2DocumentCreator.SupplyDocumentGenerationRequest("TestMasterContractNumber",
                                                contractType, ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);
            }

            // Assert
            string[] sortedOrderStringKeys = documentGenerationRequests.OrderBy(entry => entry.Key)
                                                                       .Select(k => k.Key)
                                                                       .ToArray();

            Assert.AreEqual(9, documentGenerationRequests.Count, "Incorrect number of DocumentGenerationRequest returned");

            Assert.AreEqual("2001-Allocation Description 16LR1046-001-Allocation Description 16LR1046-20170801-00", sortedOrderStringKeys[0],
                "EFA DocumentGenerationRequest - Where allocation with no delivery org, 16LR1046 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description 16LR1047-001-Allocation Description 16LR1047-20170801-00", sortedOrderStringKeys[1],
                "EFA DocumentGenerationRequest - Where allocation with no delivery org, 16LR1047 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description 16LR1048-001-Allocation Description 16LR1048-20170801-00", sortedOrderStringKeys[2],
                "EFA DocumentGenerationRequest - Where allocation with no delivery org, 16LR1048 is in the wrong order");

            Assert.AreEqual("2001-Allocation Description NMF1045-003-Allocation Description NMF1045-20170801-00", sortedOrderStringKeys[3],
                "EFA DocumentGenerationRequest - Where allocation with no delivery org, NMF1045 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description NMF1046-003-Allocation Description NMF1046-20170801-00", sortedOrderStringKeys[4],
                "EFA DocumentGenerationRequest - Where allocation with no delivery org, NMF1046 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description NMF1047-003-Allocation Description NMF1047-20170801-00", sortedOrderStringKeys[5],
                "EFA DocumentGenerationRequest - Where allocation with no delivery org, NMF1047 is in the wrong order");

            Assert.AreEqual("2001-Allocation Description SSF1045-002-Allocation Description SSF1045-20170801-00", sortedOrderStringKeys[6],
                "EFA DocumentGenerationRequest - Where allocation with no delivery org, SSF1045 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description SSF1046-002-Allocation Description SSF1046-20170801-00", sortedOrderStringKeys[7],
                "EFA DocumentGenerationRequest - Where allocation with no delivery org, SSF1046 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description SSF1047-002-Allocation Description SSF1047-20170801-00", sortedOrderStringKeys[8],
                "EFA DocumentGenerationRequest - Where allocation with no delivery org, SSF1047 is in the wrong order");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Appendix2DocumentCreator_MultipleOrgsEFA1718_ShouldReturnFundingAgreementsInCorrectOrderWhenAllAllocationsHaveADeliveryorgThatIsTheSameAsContractOrg()
        {
            // Arrange 
            contractType contractType =
                TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractEfa.json")
                    .SetContractor(ukprn: 88888888, legalName: "Contract provider name")
                    .SetDefaultAllocationDescriptions()
                    .SetAllocationDeliveryOrgsToSameAsContractor();

            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests;

            var container = GetDocumentGenerationEndpointContainer();
            using (container.BeginScope())
            {
                var appendix2DocumentCreator = new Appendix2DocumentCreator(
                    container.Resolve<ITemplateRepository>(),
                    new DocumentConfigurationSource(container.Resolve<IFundingStreamPeriodRepository>(), 
                        container.Resolve<IFspDeliverableRepository>(),
                        new FundingTypeFundingPeriodRepository(container.Resolve<DocumentsDomainDbContext>())),
                    container.Resolve<IFundingStreamPeriodRepository>());

                // act
                documentGenerationRequests = appendix2DocumentCreator.SupplyDocumentGenerationRequest("TestMasterContractNumber",
                                                contractType, ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);
            }

            // Assert
            string[] sortedOrderStringKeys = documentGenerationRequests.OrderBy(entry => entry.Key)
                                                                       .Select(k => k.Key)
                                                                       .ToArray();

            Assert.AreEqual(9, documentGenerationRequests.Count, "Incorrect number of DocumentGenerationRequest returned");

            Assert.AreEqual("2001-Allocation Description 16LR1046-001-Allocation Description 16LR1046-20170801-00", sortedOrderStringKeys[0],
                "EFA DocumentGenerationRequest - Where all allocations with delivery org the same as contract org, 16LR1046 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description 16LR1047-001-Allocation Description 16LR1047-20170801-00", sortedOrderStringKeys[1],
                "EFA DocumentGenerationRequest - Where all allocations with delivery org the same as contract org, 16LR1047 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description 16LR1048-001-Allocation Description 16LR1048-20170801-00", sortedOrderStringKeys[2],
                "EFA DocumentGenerationRequest - Where all allocations with delivery org the same as contract org, 16LR1048 is in the wrong order");

            Assert.AreEqual("2001-Allocation Description NMF1045-003-Allocation Description NMF1045-20170801-00", sortedOrderStringKeys[3],
                "EFA DocumentGenerationRequest - Where all allocations with delivery org the same as contract org, NMF1045 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description NMF1046-003-Allocation Description NMF1046-20170801-00", sortedOrderStringKeys[4],
                "EFA DocumentGenerationRequest - Where all allocations with delivery org the same as contract org, NMF1046 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description NMF1047-003-Allocation Description NMF1047-20170801-00", sortedOrderStringKeys[5],
                "EFA DocumentGenerationRequest - Where all allocations with delivery org the same as contract org, NMF1047 is in the wrong order");

            Assert.AreEqual("2001-Allocation Description SSF1045-002-Allocation Description SSF1045-20170801-00", sortedOrderStringKeys[6],
                "EFA DocumentGenerationRequest - Where all allocations with delivery org the same as contract org, SSF1045 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description SSF1046-002-Allocation Description SSF1046-20170801-00", sortedOrderStringKeys[7],
                "EFA DocumentGenerationRequest - Where all allocations with delivery org the same as contract org, SSF1046 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description SSF1047-002-Allocation Description SSF1047-20170801-00", sortedOrderStringKeys[8],
                "EFA DocumentGenerationRequest - Where all allocations with delivery org the same as contract org, SSF1047 is in the wrong order");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Appendix2DocumentCreator_MultipleOrgsEFA1718_ShouldReturnFundingAgreementsInCorrectOrderWhenAllAllocationHaveADeliveryorgThatAreDifferentToContractOrg()
        {
            // Arrange 
            contractType contractType =
                TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractEfa.json")
                    .SetContractor(ukprn: 88888888, legalName: "Contract provider name")
                    .SetDefaultAllocationDescriptions();

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "16LR-1046")
                .SetDeliveryOrganisation(11046, "Allocation provider name 16LR1046");

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "NMF-1045")
                .SetDeliveryOrganisation(21045, "Allocation provider name NMF1045");

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "SSF-1045")
                .SetDeliveryOrganisation(31045, "Allocation provider name SSF1045");

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "16LR-1047")
                .SetDeliveryOrganisation(41047, "Allocation provider name 16LR1047");

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "NMF-1046")
                .SetDeliveryOrganisation(51046, "Allocation provider name NMF1046");

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "SSF-1046")
                .SetDeliveryOrganisation(61046, "Allocation provider name SSF1046");

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "16LR-1048")
                .SetDeliveryOrganisation(71048, "Allocation provider name 16LR1048");

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "NMF-1047")
                .SetDeliveryOrganisation(81047, "Allocation provider name NMF1047");

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "SSF-1047")
                .SetDeliveryOrganisation(91047, "Allocation provider name SSF1047");

            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests;

            var container = GetDocumentGenerationEndpointContainer();
            using (container.BeginScope())
            {
                var appendix2DocumentCreator = new Appendix2DocumentCreator(
                    container.Resolve<ITemplateRepository>(),
                    new DocumentConfigurationSource(
                        container.Resolve<IFundingStreamPeriodRepository>(), 
                        container.Resolve<IFspDeliverableRepository>(),
                        new FundingTypeFundingPeriodRepository(container.Resolve<DocumentsDomainDbContext>())),
                        container.Resolve<IFundingStreamPeriodRepository>());

                // act
                documentGenerationRequests = appendix2DocumentCreator.SupplyDocumentGenerationRequest("TestMasterContractNumber",
                    contractType, ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);
            }

            string[] sortedOrderStringKeys = documentGenerationRequests.OrderBy(entry => entry.Key)
                                                                       .Select(k => k.Key)
                                                                       .ToArray();

            Assert.AreEqual(9, documentGenerationRequests.Count, "Incorrect number of DocumentGenerationRequest returned");

            Assert.AreEqual("2002-Allocation Description 16LR1046-001-Allocation Description 16LR1046-20170801-00", sortedOrderStringKeys[0],
                "EFA DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, 16LR1046 is in the wrong order");
            Assert.AreEqual("2002-Allocation Description 16LR1047-001-Allocation Description 16LR1047-20170801-00", sortedOrderStringKeys[1],
                "EFA DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, 16LR1047 is in the wrong order");
            Assert.AreEqual("2002-Allocation Description 16LR1048-001-Allocation Description 16LR1048-20170801-00", sortedOrderStringKeys[2],
                "EFA DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, 16LR1048 is in the wrong order");

            Assert.AreEqual("2002-Allocation Description NMF1045-003-Allocation Description NMF1045-20170801-00", sortedOrderStringKeys[3],
                "EFA DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, NMF1045 is in the wrong order");
            Assert.AreEqual("2002-Allocation Description NMF1046-003-Allocation Description NMF1046-20170801-00", sortedOrderStringKeys[4],
                "EFA DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, NMF1046 is in the wrong order");
            Assert.AreEqual("2002-Allocation Description NMF1047-003-Allocation Description NMF1047-20170801-00", sortedOrderStringKeys[5],
                "EFA DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, NMF1047 is in the wrong order");

            Assert.AreEqual("2002-Allocation Description SSF1045-002-Allocation Description SSF1045-20170801-00", sortedOrderStringKeys[6],
                "EFA DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, SSF1045 is in the wrong order");
            Assert.AreEqual("2002-Allocation Description SSF1046-002-Allocation Description SSF1046-20170801-00", sortedOrderStringKeys[7],
                "EFA DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, SSF1046 is in the wrong order");
            Assert.AreEqual("2002-Allocation Description SSF1047-002-Allocation Description SSF1047-20170801-00", sortedOrderStringKeys[8],
                "EFA DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, SSF1047 is in the wrong order");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Appendix2DocumentCreator_MultipleOrgsEFA1718_ShouldReturnFundingAgreementsInCorrectOrderWhenOnlyOneAllocationHasADeliveryorgThatIsDifferentToContractOrg()
        {
            // Arrange 
            contractType contractType =
                TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractEfa.json")
                    .SetContractor(ukprn: 88888888, legalName: "Contract provider name")
                    .SetAllocationDeliveryOrgsToSameAsContractor()
                    .SetDefaultAllocationDescriptions();

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "16LR-1048")
                .SetDeliveryOrganisation(71048, "Allocation provider name 16LR1048");

            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests;

            var container = GetDocumentGenerationEndpointContainer();
            using (container.BeginScope())
            {
                var appendix2DocumentCreator = new Appendix2DocumentCreator(
                    container.Resolve<ITemplateRepository>(),
                    new DocumentConfigurationSource(container.Resolve<IFundingStreamPeriodRepository>(), 
                        container.Resolve<IFspDeliverableRepository>(),
                        new FundingTypeFundingPeriodRepository(container.Resolve<DocumentsDomainDbContext>())),
                    container.Resolve<IFundingStreamPeriodRepository>());

                // act
                documentGenerationRequests = appendix2DocumentCreator.SupplyDocumentGenerationRequest("TestMasterContractNumber",
                    contractType, ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);
            }

            string[] sortedOrderStringKeys = documentGenerationRequests.OrderBy(entry => entry.Key)
                                                                       .Select(k => k.Key)
                                                                       .ToArray();

            Assert.AreEqual(9, documentGenerationRequests.Count, "Incorrect number of DocumentGenerationRequest returned");

            Assert.AreEqual("2001-Allocation Description 16LR1046-001-Allocation Description 16LR1046-20170801-00", sortedOrderStringKeys[0],
                "EFA DocumentGenerationRequest - Where one allocation delivery org is different to contract org, 16LR1046 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description 16LR1047-001-Allocation Description 16LR1047-20170801-00", sortedOrderStringKeys[1],
                "EFA DocumentGenerationRequest - Where one allocation delivery org is different to contract org, 16LR1047 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description NMF1045-003-Allocation Description NMF1045-20170801-00", sortedOrderStringKeys[2],
                "EFA DocumentGenerationRequest - Where one allocation delivery org is different to contract org, NMF1045 is in the wrong order");

            Assert.AreEqual("2001-Allocation Description NMF1046-003-Allocation Description NMF1046-20170801-00", sortedOrderStringKeys[3],
                "EFA DocumentGenerationRequest - Where one allocation delivery org is different to contract org, NMF1046 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description NMF1047-003-Allocation Description NMF1047-20170801-00", sortedOrderStringKeys[4],
                "EFA DocumentGenerationRequest - Where one allocation delivery org is different to contract org, NMF1047 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description SSF1045-002-Allocation Description SSF1045-20170801-00", sortedOrderStringKeys[5],
                "EFA DocumentGenerationRequest - Where one allocation delivery org is different to contract org, SSF1045 is in the wrong order");

            Assert.AreEqual("2001-Allocation Description SSF1046-002-Allocation Description SSF1046-20170801-00", sortedOrderStringKeys[6],
                "EFA DocumentGenerationRequest - Where one allocation delivery org is different to contract org, SSF1046 is in the wrong order");
            Assert.AreEqual("2001-Allocation Description SSF1047-002-Allocation Description SSF1047-20170801-00", sortedOrderStringKeys[7],
                "EFA DocumentGenerationRequest - Where one allocation delivery org is different to contract org, SSF1047 is in the wrong order");
            Assert.AreEqual("2002-Allocation Description 16LR1048-001-Allocation Description 16LR1048-20170801-00", sortedOrderStringKeys[8],
                "EFA DocumentGenerationRequest - Where one allocation delivery org is different to contract org, 16LR1048 is in the wrong order");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Appendix2DocumentCreator_MultipleOrgsEFA1819_ShouldReturnFundingAgreementsInCorrectOrderWhenNoAllocationsHaveADeliveryorg()
        {
            // Arrange 
            contractType contractType =
                TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractEfa1819.json")
                    .WithOnlyTheseAllocations(allocationNumbers: new[] { "16LR-1046", "NMF-1045", "SSF-1045" })
                    .SetContractor(ukprn: 88888888, legalName: "Contract provider name")
                    .SetDefaultAllocationDescriptions();

            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests;

            var container = GetDocumentGenerationEndpointContainer();
            using (container.BeginScope())
            {
                var appendix2DocumentCreator = new Appendix2DocumentCreator(
                    container.Resolve<ITemplateRepository>(),
                    new DocumentConfigurationSource(container.Resolve<IFundingStreamPeriodRepository>(), 
                        container.Resolve<IFspDeliverableRepository>(),
                        new FundingTypeFundingPeriodRepository(container.Resolve<DocumentsDomainDbContext>())),
                    container.Resolve<IFundingStreamPeriodRepository>());

                // act
                documentGenerationRequests = appendix2DocumentCreator.SupplyDocumentGenerationRequest("TestMasterContractNumber",
                                                contractType, ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);
            }

            // Assert
            string[] sortedOrderStringKeys = documentGenerationRequests.OrderBy(entry => entry.Key)
                                                                       .Select(k => k.Key)
                                                                       .ToArray();

            Assert.AreEqual(3, documentGenerationRequests.Count, "Incorrect number of DocumentGenerationRequest returned");

            Assert.AreEqual("2001-Contract provider name-001-Allocation Description 16LR1046-20180801-00", sortedOrderStringKeys[0],
                "EFA 1819 DocumentGenerationRequest - Where allocation with no delivery org, 16LR1046 is in the wrong order");

            Assert.AreEqual("2001-Contract provider name-002-Allocation Description SSF1045-20180801-00", sortedOrderStringKeys[1],
                "EFA 1819 DocumentGenerationRequest - Where allocation with no delivery org, SSF1045 is in the wrong order");

            Assert.AreEqual("2001-Contract provider name-003-Allocation Description NMF1045-20180801-00", sortedOrderStringKeys[2],
                "EFA 1819 DocumentGenerationRequest - Where allocation with no delivery org, NMF1045 is in the wrong order");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Appendix2DocumentCreator_MultipleOrgsEFA1819_ShouldReturnFundingAgreementsInCorrectOrderWhenAllAllocationsHaveADeliveryorgThatIsTheSameAsContractOrg()
        {
            // Arrange 
            contractType contractType =
                TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractEfa1819.json")
                    .WithOnlyTheseAllocations(allocationNumbers: new[] { "16LR-1046", "NMF-1045", "SSF-1045" })
                    .SetContractor(ukprn: 88888888, legalName: "Contract provider name")
                    .SetDefaultAllocationDescriptions()
                    .SetAllocationDeliveryOrgsToSameAsContractor();

            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests;

            var container = GetDocumentGenerationEndpointContainer();
            using (container.BeginScope())
            {
                var appendix2DocumentCreator = new Appendix2DocumentCreator(
                    container.Resolve<ITemplateRepository>(),
                    new DocumentConfigurationSource(container.Resolve<IFundingStreamPeriodRepository>(), 
                        container.Resolve<IFspDeliverableRepository>(),
                        new FundingTypeFundingPeriodRepository(container.Resolve<DocumentsDomainDbContext>())),
                    container.Resolve<IFundingStreamPeriodRepository>());

                // act
                documentGenerationRequests = appendix2DocumentCreator.SupplyDocumentGenerationRequest("TestMasterContractNumber",
                                                contractType, ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);
            }

            // Assert
            string[] sortedOrderStringKeys = documentGenerationRequests.OrderBy(entry => entry.Key)
                                                                       .Select(k => k.Key)
                                                                       .ToArray();

            Assert.AreEqual(3, documentGenerationRequests.Count, "Incorrect number of DocumentGenerationRequest returned");

            Assert.AreEqual("2001-Contract provider name-001-88888888-20180801-00", sortedOrderStringKeys[0],
                "EFA 1819 DocumentGenerationRequest - Where all allocations with delivery org the same as contract org, 16LR1046 is in the wrong order");

            Assert.AreEqual("2001-Contract provider name-002-88888888-20180801-00", sortedOrderStringKeys[1],
                "EFA 1819 DocumentGenerationRequest - Where all allocations with delivery org the same as contract org, SSF1045 is in the wrong order");

            Assert.AreEqual("2001-Contract provider name-003-88888888-20180801-00", sortedOrderStringKeys[2],
                "EFA 1819 DocumentGenerationRequest - Where all allocations with delivery org the same as contract org, NMF1045 is in the wrong order");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Appendix2DocumentCreator_MultipleOrgsEFA1819_ShouldReturnFundingAgreementsInCorrectOrderWhenAllAllocationHaveADeliveryorgThatAreDifferentToContractOrg()
        {
            // Arrange 
            contractType contractType =
                TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractEfa1819.json")
                    .SetContractor(ukprn: 88888888, legalName: "Contract provider name")
                    .SetDefaultAllocationDescriptions();

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "16LR-1046")
                .SetDeliveryOrganisation(11046, "Allocation provider name 16LR1046");

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "NMF-1045")
                .SetDeliveryOrganisation(21045, "Allocation provider name NMF1045");

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "SSF-1045")
                .SetDeliveryOrganisation(31045, "Allocation provider name SSF1045");

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "16LR-1047")
                .SetDeliveryOrganisation(41047, "Allocation provider name 16LR1047");

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "NMF-1046")
                .SetDeliveryOrganisation(51046, "Allocation provider name NMF1046");

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "SSF-1046")
                .SetDeliveryOrganisation(61046, "Allocation provider name SSF1046");

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "16LR-1048")
                .SetDeliveryOrganisation(71048, "Allocation provider name 16LR1048");

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "NMF-1047")
                .SetDeliveryOrganisation(81047, "Allocation provider name NMF1047");

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "SSF-1047")
                .SetDeliveryOrganisation(91047, "Allocation provider name SSF1047");

            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests;

            var container = GetDocumentGenerationEndpointContainer();
            using (container.BeginScope())
            {
                var appendix2DocumentCreator = new Appendix2DocumentCreator(
                    container.Resolve<ITemplateRepository>(),
                    new DocumentConfigurationSource(container.Resolve<IFundingStreamPeriodRepository>(), 
                        container.Resolve<IFspDeliverableRepository>(),
                        new FundingTypeFundingPeriodRepository(container.Resolve<DocumentsDomainDbContext>())),
                    container.Resolve<IFundingStreamPeriodRepository>());

                // act
                documentGenerationRequests = appendix2DocumentCreator.SupplyDocumentGenerationRequest("TestMasterContractNumber",
                    contractType, ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);
            }

            string[] sortedOrderStringKeys = documentGenerationRequests.OrderBy(entry => entry.Key)
                                                                       .Select(k => k.Key)
                                                                       .ToArray();

            Assert.AreEqual(9, documentGenerationRequests.Count, "Incorrect number of DocumentGenerationRequest returned");

            Assert.AreEqual("2002-Allocation provider name 16LR1046-001-11046-20180801-00", sortedOrderStringKeys[0],
                "EFA 1819 DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, 16LR1046 is in the wrong order");
            Assert.AreEqual("2002-Allocation provider name 16LR1047-001-41047-20180801-00", sortedOrderStringKeys[1],
                "EFA 1819 DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, 16LR1047 is in the wrong order");
            Assert.AreEqual("2002-Allocation provider name 16LR1048-001-71048-20180801-00", sortedOrderStringKeys[2],
                "EFA 1819 DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, 16LR1048 is in the wrong order");

            Assert.AreEqual("2002-Allocation provider name NMF1045-003-21045-20180801-00", sortedOrderStringKeys[3],
                "EFA 1819 DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, NMF1045 is in the wrong order");
            Assert.AreEqual("2002-Allocation provider name NMF1046-003-51046-20180801-00", sortedOrderStringKeys[4],
                "EFA 1819 DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, NMF1046 is in the wrong order");
            Assert.AreEqual("2002-Allocation provider name NMF1047-003-81047-20180801-00", sortedOrderStringKeys[5],
                "EFA 1819 DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, NMF1047 is in the wrong order");

            Assert.AreEqual("2002-Allocation provider name SSF1045-002-31045-20180801-00", sortedOrderStringKeys[6],
                "EFA 1819 DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, SSF1045 is in the wrong order");
            Assert.AreEqual("2002-Allocation provider name SSF1046-002-61046-20180801-00", sortedOrderStringKeys[7],
                "EFA 1819 DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, SSF1046 is in the wrong order");
            Assert.AreEqual("2002-Allocation provider name SSF1047-002-91047-20180801-00", sortedOrderStringKeys[8],
                "EFA 1819 DocumentGenerationRequest - Where all allocation delivery orgs are different to contract org, SSF1047 is in the wrong order");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Appendix2DocumentCreator_MultipleOrgsEFA1819_ShouldReturnFundingAgreementsInCorrectOrderWhenOnlyOneAllocationHasADeliveryorgThatIsDifferentToContractOrg()
        {
            // Arrange 
            contractType contractType =
                TestResource.FromJson<Contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Resources", "corpContractEfa1819.json")
                    .SetContractor(ukprn: 88888888, legalName: "Contract provider name")
                    .WithOnlyTheseAllocations(allocationNumbers: new[] { "16LR-1046", "NMF-1045", "SSF-1045", "16LR-1048" })
                    .SetAllocationDeliveryOrgsToSameAsContractor()
                    .SetDefaultAllocationDescriptions();

            contractType.contractAllocations.Single(ca => ca.contractAllocationNumber == "16LR-1048")
                .SetDeliveryOrganisation(71048, "Allocation provider name 16LR1048");

            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests;

            var container = GetDocumentGenerationEndpointContainer();
            using (container.BeginScope())
            {
                var appendix2DocumentCreator = new Appendix2DocumentCreator(
                    container.Resolve<ITemplateRepository>(),
                    new DocumentConfigurationSource(
                        container.Resolve<IFundingStreamPeriodRepository>(), 
                        container.Resolve<IFspDeliverableRepository>(),
                        new FundingTypeFundingPeriodRepository(container.Resolve<DocumentsDomainDbContext>())), 
                    container.Resolve<IFundingStreamPeriodRepository>());

                // act
                documentGenerationRequests = appendix2DocumentCreator.SupplyDocumentGenerationRequest("TestMasterContractNumber",
                    contractType, ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"]);
            }

            string[] sortedOrderStringKeys = documentGenerationRequests.OrderBy(entry => entry.Key)
                                                                       .Select(k => k.Key)
                                                                       .ToArray();

            Assert.AreEqual(4, documentGenerationRequests.Count, "Incorrect number of DocumentGenerationRequest returned");

            Assert.AreEqual("2001-Contract provider name-001-88888888-20180801-00", sortedOrderStringKeys[0],
                "EFA 1819 DocumentGenerationRequest - Where one allocation delivery org is different to contract org, 16LR1046 is in the wrong order");

            Assert.AreEqual("2001-Contract provider name-002-88888888-20180801-00", sortedOrderStringKeys[1],
                "EFA 1819 DocumentGenerationRequest - Where one allocation delivery org is different to contract org, SSF1046 is in the wrong order");

            Assert.AreEqual("2001-Contract provider name-003-88888888-20180801-00", sortedOrderStringKeys[2],
                "EFA 1819 DocumentGenerationRequest - Where one allocation delivery org is different to contract org, NMF1046 is in the wrong order");

            Assert.AreEqual("2002-Allocation provider name 16LR1048-001-71048-20180801-00", sortedOrderStringKeys[3],
                "EFA 1819 DocumentGenerationRequest - Where one allocation delivery org is different to contract org, 16LR1048 is in the wrong order");
        }

        private static IWindsorContainer GetDocumentGenerationEndpointContainer()
        {
            return WindsorInstallerForDocumentGenerator.Container;
        }
    }

    internal static class ContractTestExtensions
    {
        public static contractAllocationsContractAllocation SetDeliveryOrganisation(
            this contractAllocationsContractAllocation allocation, int deliveryUkprn, string deliveryLegalName)
        {
            allocation.DeliveryOrganisation = deliveryUkprn.ToString();
            allocation.DeliveryOrganisationDetail = new Contractor
            {
                ukprn = deliveryUkprn,
                legalName = deliveryLegalName
            };

            return allocation;
        }

        public static contractType SetAllocationDeliveryOrgsToSameAsContractor(this contractType contract)
        {
            contract.contractAllocations
                .ForEach(a =>
                {
                    a.DeliveryOrganisation = contract.contractor.ukprn.ToString();
                    a.DeliveryOrganisationDetail = contract.contractor;
                });

            return contract;
        }

        public static contractType SetDefaultAllocationDescriptions(this contractType contract)
        {
            contract.contractAllocations.ForEach(a =>
                a.description = $"Allocation Description {a.contractAllocationNumber.Replace("-", string.Empty)}");

            return contract;
        }

        public static contractType SetContractor(this contractType contract, int ukprn, string legalName)
        {
            contract.contractor = new Contractor { legalName = legalName, ukprn = ukprn };

            return contract;
        }

        public static contractType WithOnlyTheseAllocations(this contractType contract, string[] allocationNumbers)
        {
            contract.contractAllocations = contract.contractAllocations
                .Where(a => allocationNumbers.Contains(a.contractAllocationNumber)).ToList();

            return contract;
        }
    }
}
