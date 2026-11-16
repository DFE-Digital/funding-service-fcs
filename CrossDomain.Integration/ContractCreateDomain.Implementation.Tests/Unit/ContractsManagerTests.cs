namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using Moq;
    using MoreLinq;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Exceptions;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using UnitTests.Common;

    [TestClass]
    public class ContractsManagerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractsManager_GetCorporateContract_ShouldReturnNullWhenNoContractsMatch()
        {
            // Arrange 
            const string masterContractNumber = "111111";
            const string contractNumber = "123456";

            Mock<ContractsManager> mockContractManager = new Mock<ContractsManager> { CallBase = true };
            mockContractManager
                .Setup(c => c.GetMatchingCorporateContract(It.IsAny<string>(), It.IsAny<string>(), true))
                .Returns(new Contract());

            // Act
            Contract returnedContract = mockContractManager.Object.GetCorporateContract(masterContractNumber, contractNumber);

            // Assert
            Assert.IsNull(returnedContract);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractsManager_GetHierarchicalCorporateContract_ShouldReturnNullWhenNoContractsMatch()
        {
            // Arrange 
            const string masterContractNumber = "111111";
            const string contractNumber = "123456";
            Contract contract = null;

            Mock<ContractsManager> mockContractManager = new Mock<ContractsManager> { CallBase = true };
            mockContractManager.Setup(c => c.GetMatchingCorporateContract(It.IsAny<string>(), It.IsAny<string>(), true)).Returns(contract);

            // Act
            Contract returnedContract = mockContractManager.Object.GetCorporateContract(masterContractNumber, contractNumber);

            // Assert
            Assert.IsNull(returnedContract);
        }

        [TestMethod]
        [TestCategory("UnitTest")]
        public void ContractsManager_GetXrmContract_ShouldThrowContractDoesntExistExceptionIfNoMatchingContractIsFound()
        {
            // Arrange
            const string contractNumber = "123456";

            Mock<ContractsManager> mockContractManager =
                new Mock<ContractsManager> { CallBase = true };

            mockContractManager
                .Setup(c => c.GetMatchingXrmContracts(
                    It.Is<string>(s => s == contractNumber)))
                .Returns(new List<sfa_contract>());

            // Act / Assert
            try
            {
                mockContractManager.Object.GetXrmContract(contractNumber);

                Assert.Fail(
                    "Expected ContractDoesntExistException was not thrown.");
            }
            catch (ContractDoesntExistException)
            {
                // expected
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractsManager_GetXrmContract_ShouldReturnLatestVersionWhenMultipleChildContractsMatch()
        {
            // Arrange 
            const string contractNumber = "123456";

            List<sfa_contract> contractsList = new List<sfa_contract>
            {
                new sfa_contract { sfa_number = contractNumber, sfa_Version = 1 },
                new sfa_contract { sfa_number = contractNumber, sfa_Version = 1, sfa_SubVersion = 1 },
                new sfa_contract { sfa_number = contractNumber, sfa_Version = 2, sfa_SubVersion = 0 },
                new sfa_contract { sfa_number = contractNumber, sfa_Version = 2, sfa_SubVersion = 1 }
            };

            Mock<ContractsManager> mockContractManager = new Mock<ContractsManager> { CallBase = true };
            mockContractManager
                .Setup(c => c.GetMatchingXrmContracts(It.Is<string>(s => s == contractNumber)))
                .Returns(contractsList);

            // Act
            sfa_contract returnedContract = mockContractManager.Object.GetXrmContract(contractNumber);

            // Assert
            Assert.AreEqual(returnedContract.sfa_Version, 2, "Major version is incorrect");
            Assert.AreEqual(returnedContract.sfa_SubVersion, 1, "Sub version is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractsManager_CreateContract_ShouldCreateDeliveryOrgs()
        {
            // arrange
            List<string> deliveryOrgUkprns = Enumerable.Range(1030, 4).Select(i => i.ToString()).ToList();
            deliveryOrgUkprns.Add(null);

            List<ExtendedContractAllocation> allocations =
                deliveryOrgUkprns.Select(ukprn => new ExtendedContractAllocation
                {
                    contractAllocationNumber = ukprn,
                    DeliveryOrganisation = ukprn,
                    period = new Period
                    {
                        period1 = "1516",
                        periodType = new periodTypeType
                        {
                            periodTypeCode = periodTypeCodeType.AY
                        }
                    },
                    fundingStream = new fundingStream
                    {
                        fundingStreamCode = "TEST"
                    },
                    DeliveryOrganisationDetail = new Contractor
                    {
                        ukprn = (ukprn != null) ? int.Parse(ukprn):0,
                        legalName = "Some name",
                        Status = "Active"
                    }

                }).ToList();

            CreateContractCommand contractCreateCommand = TestResource.FromJson<CreateContractCommand>(
                "ContractCreateDomain.Implementation.Tests",
                "Resources.CreateContractCommand.json");

            ExtendedContractType contract = contractCreateCommand.CorporateContract;

            contract.contracts.First().contractAllocations = allocations;

            Mock<IXrmOrganisationManager> xrmOrganisationManagerMock = new Mock<IXrmOrganisationManager>();

            ContractsManager contractsManager = new ContractsManager
            {
                BatchId = "BATCH",
                LookupManager = Mock.Of<ILookupManager>(),
                OrganizationService = Mock.Of<IOrganizationService>(),
                XrmOrganisationManager = xrmOrganisationManagerMock.Object,
                XrmWorkflowManager = Mock.Of<IXrmWorkflowManager>()
            };

            // act
            contractsManager.CreateContract(contract, string.Empty);

            // assert
            deliveryOrgUkprns.Where(org => !string.IsNullOrEmpty(org)).ForEach(org => xrmOrganisationManagerMock.Verify(m =>
                m.CreateOrganisationIfNotExists(It.Is<ContractOrganisation>(co =>
                    co.UKPRN == org && co.Status == "Active"))));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractsManager_CreateContract_ShouldCallCreateOrganisationTheCorrectNumberOfTimes()
        {
            // arrange
            List<string> deliveryOrgs = new List<string> {"1234", "1234", "1234", null};

            List<ExtendedContractAllocation> allocations =
                deliveryOrgs.Select(org => new ExtendedContractAllocation
                {
                    contractAllocationNumber = org,
                    DeliveryOrganisation = org,
                    period = new Period
                    {
                        period1 = "1516",
                        periodType = new periodTypeType
                        {
                            periodTypeCode = periodTypeCodeType.AY
                        }
                    },
                    fundingStream = new fundingStream
                    {
                        fundingStreamCode = "TEST"
                    },
                    DeliveryOrganisationDetail = {legalName = "some name"}
                }).ToList();

            CreateContractCommand contractCreateCommand = TestResource.FromJson<CreateContractCommand>(
                "ContractCreateDomain.Implementation.Tests",
                "Resources.CreateContractCommand.json");

            ExtendedContractType contract = contractCreateCommand.CorporateContract;

            contract.contracts.First().contractAllocations = allocations;

            Mock<IXrmOrganisationManager> xrmOrganisationManagerMock = new Mock<IXrmOrganisationManager>();           

            ContractsManager contractsManager = new ContractsManager
            {
                BatchId = "BATCH",
                LookupManager = Mock.Of<ILookupManager>(),
                OrganizationService = Mock.Of<IOrganizationService>(),
                XrmOrganisationManager = xrmOrganisationManagerMock.Object,
                XrmWorkflowManager = Mock.Of<IXrmWorkflowManager>()
            };

            // act
            contractsManager.CreateContract(contract, string.Empty);

            // assert
            xrmOrganisationManagerMock.Verify(m => m.CreateOrganisationIfNotExists(It.IsAny<ContractOrganisation>()), Times.Exactly(2));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractsManager_CreateContract_ShouldCallCreateOrganisationOnceIfDeliveryOrgIsTheSameAsContractUkprn()
        {
            // arrange
            CreateContractCommand contractCreateCommand = TestResource.FromJson<CreateContractCommand>(
              "ContractCreateDomain.Implementation.Tests",
              "Resources.CreateContractCommand.json");

            ExtendedContractType contract = contractCreateCommand.CorporateContract;
            string contractUkprn = contract.contractor.ukprn.ToString();

            List<string> deliveryOrgsUkprns = new List<string> { contractUkprn, contractUkprn, contractUkprn, null };

            List<ExtendedContractAllocation> allocations =
                deliveryOrgsUkprns.Select(ukprn => new ExtendedContractAllocation
                {
                    contractAllocationNumber = ukprn,
                    DeliveryOrganisation = ukprn,
                    period = new Period
                    {
                        period1 = "1516",
                        periodType = new periodTypeType
                        {
                            periodTypeCode = periodTypeCodeType.AY
                        }
                    },
                    fundingStream = new fundingStream
                    {
                        fundingStreamCode = "TEST"
                    },
                    DeliveryOrganisationDetail = new Contractor
                    {
                        ukprn = (ukprn != null) ? int.Parse(ukprn) : 0
                    }
                }).ToList();

            contract.contracts.First().contractAllocations = allocations;

            Mock<IXrmOrganisationManager> xrmOrganisationManagerMock = new Mock<IXrmOrganisationManager>();

            ContractsManager contractsManager = new ContractsManager
            {
                BatchId = "BATCH",
                LookupManager = Mock.Of<ILookupManager>(),
                OrganizationService = Mock.Of<IOrganizationService>(),
                XrmOrganisationManager = xrmOrganisationManagerMock.Object,
                XrmWorkflowManager = Mock.Of<IXrmWorkflowManager>()
            };

            // act
            contractsManager.CreateContract(contract, string.Empty);

            // assert
            xrmOrganisationManagerMock.Verify(m => m.CreateOrganisationIfNotExists(It.IsAny<ContractOrganisation>()), Times.Once);
        }
    }
}