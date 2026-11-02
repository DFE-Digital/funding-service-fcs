namespace ContractCreateDomain.IncrementContractVersionEndpoint.Tests.Services.Unit_Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using IoC;
    using IncrementContractVersionEndpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.Framework.Logging;
    using contractType = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.contractType;

    [TestClass]
    public class ContractVersionIncrementServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractVersionIncrementService_UpdateVersionForAmendment__WhenIsNonFinancial_ShouldIncrementVersionAndSetPropertiesCorrectly()
        {
            const string firstContractNumber = "LEVY-1234";
            const string secondContractNumber = "LEVY-5678";
            Guid firstContractId = Guid.NewGuid();
            Guid secondContractId = Guid.NewGuid();

            // arrange
            contractType contract = new contractType
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = firstContractNumber,
                        contractVersionNumber = 1,
                        contractSubVersionNumber = 1,
                        Id = firstContractId
                    },
                    new contractType
                    {
                        contractNumber = secondContractNumber,
                        contractVersionNumber = 1,
                        contractSubVersionNumber = 1,
                        Id = secondContractId
                    }
                },
                Id = Guid.NewGuid()
            };

            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(m => m.GetApprovedContractId(It.Is<string>(s => s == firstContractNumber)))
                .Returns(firstContractId);
            contractsManagerMock
                .Setup(m => m.GetApprovedContractId(It.Is<string>(s => s == secondContractNumber)))
                .Returns<Guid?>(null);
            contractsManagerMock.Setup(m => m.GetMaximumContractVersionNumber(It.IsAny<string>())).Returns(1);

            ContractVersionIncrementService service = new ContractVersionIncrementService(contractsManagerMock.Object,
                Mock.Of<IContractDeliverableEnricher>(),
                Mock.Of<IContractRequestTransformer>(),
                Mock.Of<IContractValueAggregator>());

            // act
            service.UpdateVersionForAmendment(contract, isNonFinancialAmendment: true);

            // assert
            contractType childContractToTest = contract.contracts[0];

            Assert.AreEqual(2, childContractToTest.contractVersionNumber, "The first contract's version number has not been incremented");
            Assert.AreEqual(0, childContractToTest.contractSubVersionNumber, "The first contract's sub version number has not been incremented");
            Assert.AreEqual(firstContractId, childContractToTest.PreviousVersionId, "The first contract's PreviousVersionId has not been set correctly");
            Assert.IsNull(childContractToTest.Id, "The first contract's id has not been nulled");

            childContractToTest = contract.contracts[1];

            Assert.AreEqual(2, childContractToTest.contractVersionNumber, "The second contract's version number has not been incremented");
            Assert.AreEqual(0, childContractToTest.contractSubVersionNumber, "The second contract's sub version number has not been incremented");
            Assert.IsNull(childContractToTest.PreviousVersionId, "The second contract's PreviousVersionId has not been set correctly");
            Assert.IsNull(childContractToTest.Id, "The second contract's id has not been nulled");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractVersionIncrementService_UpdateVersionForAmendment_WhenIsNonFinancial_ShouldIncrementVersionAndSetPropertiesCorrectlyTakingIntoAccountWithdrawnVersions()
        {
            const string firstContractNumber = "LEVY-1234";
            const string secondContractNumber = "LEVY-5678";
            Guid firstContractId = Guid.NewGuid();
            Guid secondContractId = Guid.NewGuid();

            // arrange
            contractType contract = new contractType
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = firstContractNumber,
                        contractVersionNumber = 1,
                        contractSubVersionNumber = 1,
                        Id = firstContractId
                    },
                    new contractType
                    {
                        contractNumber = secondContractNumber,
                        contractVersionNumber = 1,
                        contractSubVersionNumber = 1,
                        Id = secondContractId
                    }
                },
                Id = Guid.NewGuid()
            };

            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(m => m.GetApprovedContractId(It.Is<string>(s => s == firstContractNumber)))
                .Returns(firstContractId);
            contractsManagerMock
                .Setup(m => m.GetApprovedContractId(It.Is<string>(s => s == secondContractNumber)))
                .Returns<Guid?>(null);
            contractsManagerMock.Setup(m => m.GetMaximumContractVersionNumber(It.IsAny<string>())).Returns(5);

            ContractVersionIncrementService service = new ContractVersionIncrementService(contractsManagerMock.Object,
               Mock.Of<IContractDeliverableEnricher>(),
               Mock.Of<IContractRequestTransformer>(),
               Mock.Of<IContractValueAggregator>());

            // act
            service.UpdateVersionForAmendment(contract, isNonFinancialAmendment: true);

            // assert
            contractType childContractToTest = contract.contracts[0];

            Assert.AreEqual(6, childContractToTest.contractVersionNumber, "The first contract's version number has not been incremented");
            Assert.AreEqual(0, childContractToTest.contractSubVersionNumber, "The first contract's sub version number has not been incremented");
            Assert.AreEqual(firstContractId, childContractToTest.PreviousVersionId, "The first contract's PreviousVersionId has not been set correctly");
            Assert.IsNull(childContractToTest.Id, "The first contract's id has not been nulled");

            childContractToTest = contract.contracts[1];

            Assert.AreEqual(6, childContractToTest.contractVersionNumber, "The second contract's version number has not been incremented");
            Assert.AreEqual(0, childContractToTest.contractSubVersionNumber, "The second contract's sub version number has not been incremented");
            Assert.IsNull(childContractToTest.PreviousVersionId, "The second contract's PreviousVersionId has not been set correctly");
            Assert.IsNull(childContractToTest.Id, "The second contract's id has not been nulled");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractVersionIncrementService_UpdateVersionForAmendment_WhenIsNotNonFinancial_ShouldIncrementVersionAndSetPropertiesCorrectly()
        {
            const string firstContractNumber = "LEVY-1234";
            Guid firstContractId = Guid.NewGuid();

            // arrange
            contractType contract = new contractType
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = firstContractNumber,
                        contractVersionNumber = 1,
                        contractSubVersionNumber = 1,
                        Id = firstContractId
                    }
                },
                Id = Guid.NewGuid()
            };

            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            contractsManagerMock
                .Setup(m => m.GetLatestVersionContractId(It.IsAny<string>()))
                .Returns(firstContractId);

            contractsManagerMock.Setup(m => m.GetMaximumContractVersionNumber(It.IsAny<string>())).Returns(5);

            ContractVersionIncrementService service = new ContractVersionIncrementService(contractsManagerMock.Object,
               Mock.Of<IContractDeliverableEnricher>(),
               Mock.Of<IContractRequestTransformer>(),
               Mock.Of<IContractValueAggregator>());

            // act
            service.UpdateVersionForAmendment(contract, isNonFinancialAmendment: false);

            // assert
            contractType childContractToTest = contract.contracts[0];

            Assert.AreEqual(6, childContractToTest.contractVersionNumber, "The first contract's version number has not been incremented");
            Assert.AreEqual(0, childContractToTest.contractSubVersionNumber, "The first contract's sub version number has not been incremented");
            Assert.AreEqual(firstContractId, childContractToTest.PreviousVersionId, "The first contract's PreviousVersionId has not been set correctly");
            Assert.IsNull(childContractToTest.Id, "The first contract's id has not been nulled");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractVersionIncrementService_ShouldCreateContractWithAmendmentTypeVariation()
        {
            // arrange
            const string correlationId = "testid";
            const string contractNumber = "SFA-123";

            var contractsManagerMock = new Mock<IContractsManager>();
            var enricherMock = new Mock<IContractDeliverableEnricher>();
            var valueAggregatorMock = new Mock<IContractValueAggregator>();

            contractsManagerMock.Setup(m => m.GetMostRecentContractId(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(Guid.NewGuid());

            contractsManagerMock.Setup(m => m.GetContractForId(It.IsAny<Guid>()))
                 .Returns(new contractType
                 {
                     correlationId = correlationId,
                     contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractAllocations = new List<contractAllocation>()
                            {
                                new contractAllocation()
                            }
                        }
                    }
                 });

            contractsManagerMock.Setup(m => m.DoesContractVersionExist(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(false);

            ContractVersionIncrementService service = new ContractVersionIncrementService(contractsManagerMock.Object,
                enricherMock.Object,
                new ContractRequestTransformer(),
                valueAggregatorMock.Object);
            //act
            ExtendedContractType extendedContractType = service.CreateAmendedContractVersionIfNotAlreadyCreated(new ContractIdentifier(contractNumber, 1, 1),
                AmendmentType.Variation, isNonFinancialAmendment: true);

            //assert
            Assert.AreEqual("Variation", extendedContractType.contracts[0].amendmentType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractVersionIncrementService_ShouldCreateContractWithAmendmentTypeNotification()
        {
            // arrange
            const string correlationId = "testid";
            const string contractNumber = "SFA-123";

            var contractsManagerMock = new Mock<IContractsManager>();
            var enricherMock = new Mock<IContractDeliverableEnricher>();
            var valueAggregatorMock = new Mock<IContractValueAggregator>();

            contractsManagerMock.Setup(m => m.GetMostRecentContractId(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(Guid.NewGuid());

            contractsManagerMock.Setup(m => m.GetContractForId(It.IsAny<Guid>()))
                 .Returns(new contractType
                 {
                     correlationId = correlationId,
                     contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractAllocations = new List<contractAllocation>()
                            {
                                new contractAllocation()
                            }
                        }
                    }
                 });

            contractsManagerMock.Setup(m => m.DoesContractVersionExist(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(false);

            ContractVersionIncrementService service = new ContractVersionIncrementService(contractsManagerMock.Object,
                enricherMock.Object,
                new ContractRequestTransformer(),
                valueAggregatorMock.Object);
            //act
            ExtendedContractType extendedContractType = service.CreateAmendedContractVersionIfNotAlreadyCreated(new ContractIdentifier(contractNumber, 1, 1),
                AmendmentType.Notification, isNonFinancialAmendment: true);

            //assert
            Assert.AreEqual("Notification", extendedContractType.contracts[0].amendmentType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractVersionIncrementService_ShouldCreateContractWithZeroVariance()
        {
            // arrange
            const string correlationId = "testid";
            const string contractNumber = "SFA-123";

            var contractsManagerMock = new Mock<IContractsManager>();
            var enricherMock = new Mock<IContractDeliverableEnricher>();
            var valueAggregatorMock = new Mock<IContractValueAggregator>();

            contractsManagerMock.Setup(m => m.GetMostRecentContractId(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(Guid.NewGuid());

            contractsManagerMock.Setup(m => m.GetContractForId(It.IsAny<Guid>()))
                .Returns(new contractType
                {
                    correlationId = correlationId,
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractAllocations = new List<contractAllocation>()
                            {
                                new contractAllocation()
                            }
                        }
                    }
                });

            contractsManagerMock.Setup(m => m.DoesContractVersionExist(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(false);

            ContractVersionIncrementService service = new ContractVersionIncrementService(contractsManagerMock.Object,
                enricherMock.Object,
                new ContractRequestTransformer(),
                valueAggregatorMock.Object);
            //act
            ExtendedContractType extendedContractType = service.CreateAmendedContractVersionIfNotAlreadyCreated(new ContractIdentifier(contractNumber, 1, 1),
                AmendmentType.Variation, isNonFinancialAmendment: true);

            //assert
            Assert.IsTrue(extendedContractType.contracts.All(c => c.ValueVariation == 0), "The contracts do not all have the correct ValueVariation");
            Assert.IsTrue(extendedContractType.contracts.All(c => c.contractAllocations.All(a => a.ValueVariation == 0)), "The contractAllocations do not all have the correct ValueVariation");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractVersionIncrementService_ShouldCreateContractWithAllocationWithFieldsSet()
        {
            // arrange
            const string correlationId = "testid";
            const string contractNumber = "SFA-123";

            var contractsManagerMock = new Mock<IContractsManager>();
            var enricherMock = new Mock<IContractDeliverableEnricher>();
            var valueAggregatorMock = new Mock<IContractValueAggregator>();

            contractsManagerMock.Setup(m => m.GetMostRecentContractId(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(Guid.NewGuid());

            var contractAllocationInCrm = new contractAllocation
            {
                activityDescription = "activity",
                agreementNumber = "aggree",
                investmentPriority = "invest",
                learningRatePremium = "lrp",
                LEPCode = "lepCode",
                LEPName = "lepName",
                lotReference = "lotReference",
                regionType = "regionType",
                specificationTitle = "specificationTitle",
                tenderAwardReference = "award",
                tenderSpecificationReference = "tender"
            };

            contractsManagerMock.Setup(m => m.GetContractForId(It.IsAny<Guid>()))
                .Returns(new contractType
                {
                    correlationId = correlationId,
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractAllocations = new List<contractAllocation>()
                            {
                                contractAllocationInCrm
                            }
                        }
                    }
                });

            contractsManagerMock.Setup(m => m.DoesContractVersionExist(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(false);

            ContractVersionIncrementService service = new ContractVersionIncrementService(contractsManagerMock.Object,
                enricherMock.Object,
                new ContractRequestTransformer(),
                valueAggregatorMock.Object);
            //act
            ExtendedContractType extendedContractType = service.CreateAmendedContractVersionIfNotAlreadyCreated(new ContractIdentifier(contractNumber, 1, 1),
                AmendmentType.Variation, isNonFinancialAmendment: true);

            //assert
            ExtendedContractAllocation contractAllocation = extendedContractType.contracts.First().contractAllocations.First();
            Assert.AreEqual(contractAllocationInCrm.activityDescription, contractAllocation.ActivityDescription, "The ActivityDescription on the allocation is not correct");
            Assert.AreEqual(contractAllocationInCrm.agreementNumber, contractAllocation.AgreementNumber, "The AgreementNumber on the allocation is not correct");
            Assert.AreEqual(contractAllocationInCrm.investmentPriority, contractAllocation.InvestmentPriority, "The InvestmentPriority on the allocation is not correct");
            Assert.AreEqual(contractAllocationInCrm.learningRatePremium, contractAllocation.LearningRatePremium, "The LearningRatePremium on the allocation is not correct");
            Assert.AreEqual(contractAllocationInCrm.LEPCode, contractAllocation.LEPCode, "The LEPCode on the allocation is not correct");
            Assert.AreEqual(contractAllocationInCrm.LEPName, contractAllocation.LEPName, "The LEPName on the allocation is not correct");
            Assert.AreEqual(contractAllocationInCrm.lotReference, contractAllocation.lotReference, "The lotReference on the allocation is not correct");
            Assert.AreEqual(contractAllocationInCrm.regionType, contractAllocation.RegionType, "The RegionType on the allocation is not correct");
            Assert.AreEqual(contractAllocationInCrm.specificationTitle, contractAllocation.SpecificationTitle, "The SpecificationTitle on the allocation is not correct");
            Assert.AreEqual(contractAllocationInCrm.tenderAwardReference, contractAllocation.tenderAwardReference, "The tenderAwardReference on the allocation is not correct");
            Assert.AreEqual(contractAllocationInCrm.tenderSpecificationReference, contractAllocation.tenderSpecificationReference, "The tenderSpecificationReference on the allocation is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractVersionIncrementService_ShouldCreateAllocationsWithNullReasonForAmendment()
        {
            // arrange
            Mock<IContractsManager> contractsManagerMock = new Mock<IContractsManager>();
            Mock<IContractDeliverableEnricher> contractDeliverableEnricherMock = new Mock<IContractDeliverableEnricher>();
            Mock<IContractValueAggregator> contractValueAggregatorMock = new Mock<IContractValueAggregator>();

            contractsManagerMock
                .Setup(m => m.GetMostRecentContractId(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(Guid.NewGuid());

            contractsManagerMock
                .Setup(m => m.GetContractForId(It.IsAny<Guid>()))
                .Returns(new contractType
                {
                    correlationId = Guid.NewGuid().ToString(),
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    amendmentReason = "Amendment Reason"
                                },
                                new contractAllocation
                                {
                                    amendmentReason = "Amendment Reason"
                                }
                            }
                        }
                    }
                });

            contractsManagerMock
                .Setup(m => m.DoesContractVersionExist(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(false);

            ContractVersionIncrementService service = new ContractVersionIncrementService(
                contractsManagerMock.Object,
                contractDeliverableEnricherMock.Object,
                new ContractRequestTransformer(),
                contractValueAggregatorMock.Object);

            // act
            ExtendedContractType extendedContractType = service.CreateAmendedContractVersionIfNotAlreadyCreated(
                new ContractIdentifier("MAIN-1234", 1, 0), AmendmentType.Variation, isNonFinancialAmendment: true);

            // assert
            Assert.IsTrue(extendedContractType.contracts.All(c => c.contractAllocations.All(a => a.reasonForAmendment == null)), "The contractAllocations do not all have a null reasonForAmendment value");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractVersionIncrementService_ShouldResolveFromIncrementContractVersionEndpointContainer()
        {
            using (IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory())))
            using (container.BeginScope())
            {
                IContractVersionIncrementService service = container.Resolve<IContractVersionIncrementService>();
                Assert.IsTrue(service is ContractVersionIncrementService);
            }
        }
    }
}