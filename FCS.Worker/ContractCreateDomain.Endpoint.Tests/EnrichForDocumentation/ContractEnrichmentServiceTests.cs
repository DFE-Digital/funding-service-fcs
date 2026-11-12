namespace ContractCreateDomain.Endpoint.Tests.EnrichForDocumentation
{
    using System.Collections.Generic;
    using System.Linq;
    using Endpoint.EnrichForDocumentation;
    using Endpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ContractEnrichmentServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractEnrichmentService_EnrichContractWithOrganisationData_ShouldEnrich()
        {
            // arrange
            const string orgName = "Test Name";
            Mock<ISiblingApprovedContractService> siblingApprovedContractServiceMock = new Mock<ISiblingApprovedContractService>();
            siblingApprovedContractServiceMock.Setup(r => r.GetSiblingApprovedContractsForDocumentGeneration(
                It.IsAny<string>(),
                It.IsAny<string>(),
                It.IsAny<string>(),
                It.IsAny<string>(),
                null)).ReturnsAsync(new List<ApprovedContractInfo>());
            ContractEnrichmentService contractEnrichmentService = new ContractEnrichmentService(
                Mock.Of<ILogger>(),
                siblingApprovedContractServiceMock.Object,
                Mock.Of<IRelatedAllocationEnricher>());
            Contract contract = new Contract();
            organisation org = new organisation
            {
                organisationNames = new List<organisationNamesOrganisationName>
                {
                    new organisationNamesOrganisationName
                    {
                        organisationName = orgName,
                        organisationNameType = organisationNameType.LEGAL
                    }
                },
                organisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                {
                    new organisationIdentifiersOrganisationIdentifier
                    {
                        organisationIdentifierType = organisationIdentifierType.UPIN,
                        organisationIdentifier = "some identifier"
                    }
                }
            };
            // act
            contractEnrichmentService.EnrichContractWithOrganisationData(contract, masterContractNumber:string.Empty, connectionInfo:null, ukprn => org).Wait();

            // assert
            Assert.AreEqual(orgName, contract.contractor.legalName, "The legalName has not been populated");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractEnrichmentService_EnrichContractWithOrganisationData_ShouldEnrichAllocationWhenDeliveryOrgSet()
        {
            // arrange
            const string orgName = "Test Name";
            Mock<ISiblingApprovedContractService> siblingApprovedContractServiceMock = new Mock<ISiblingApprovedContractService>();
            siblingApprovedContractServiceMock.Setup(r => r.GetSiblingApprovedContractsForDocumentGeneration(
                It.IsAny<string>(),
                It.IsAny<string>(),
                It.IsAny<string>(),
                It.IsAny<string>(),
                null)).ReturnsAsync(new List<ApprovedContractInfo>());

            ContractEnrichmentService contractEnrichmentService = new ContractEnrichmentService(
                Mock.Of<ILogger>(),
                siblingApprovedContractServiceMock.Object,
                Mock.Of<IRelatedAllocationEnricher>());
            Contract contract = new Contract
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        DeliveryOrganisation = "12345678"
                    }
                }
            };
            organisation org = new organisation
            {
                organisationNames = new List<organisationNamesOrganisationName>
                {
                    new organisationNamesOrganisationName
                    {
                        organisationName = orgName,
                        organisationNameType = organisationNameType.LEGAL
                    }
                },
                organisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                {
                    new organisationIdentifiersOrganisationIdentifier
                    {
                        organisationIdentifierType = organisationIdentifierType.UPIN,
                        organisationIdentifier = "some identifier"
                    }
                }
            };
            // act
            contractEnrichmentService.EnrichContractWithOrganisationData(contract, masterContractNumber:string.Empty, connectionInfo:null, ukprn => org).Wait();

            // assert
            Assert.AreEqual(orgName, contract.contractAllocations.Single().DeliveryOrganisationDetail.legalName, "The legalName has not been populated on the allocation");
        }
    }
}
