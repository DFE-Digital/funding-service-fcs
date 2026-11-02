namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Linq;
    using Endpoint.Services;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ContractValidationLookupDataTest
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractValidationLookupData_ShouldSetIsContractNumberWithMatchingUKPRNPeriodAndFundingTypePresentInCrm_ToTrue_WhenInCrm()
        {
            // arrange
            var lookupManagerMock = new Mock<ILookupManager>();
            lookupManagerMock.Setup(
                l => l.IsContractNumberWithMatchingUkprnPeriodAndFundingTypePresentInCrm(It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<int>(),
                    It.IsAny<Guid>(),
                    It.IsAny<Guid>())).Returns(true);

            lookupManagerMock.Setup(
                l => l.GetColumnValuesForEntity<string>(It.IsAny<CrmLookupType>(), It.IsAny<string>()))
                .Returns(new List<string>());

            lookupManagerMock.Setup(
               l => l.GetColumnValuesForEntity<string>(
                   It.IsAny<CrmLookupType>(),
                   It.IsAny<string>(),
                   It.IsAny<string>(),
                   It.IsAny<List<string>>()))
               .Returns(new List<string>());

            lookupManagerMock.Setup(
              l => l.GetPeriodId(It.IsAny<string>(), It.IsAny<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeCodeType>()))
              .Returns(Guid.Empty);

            lookupManagerMock.Setup(
              l => l.GetFundingTypeId(It.IsAny<string>()))
              .Returns(Guid.Empty);

            lookupManagerMock
                .Setup(m => m.GetUnitOfProcurementReferenceData())
                .Returns(new List<UnitOfProcurement>());

            lookupManagerMock.Setup(m => m.GetPkColumnValuesForEntity(CrmLookupType.SubStatus, It.IsAny<string>(), It.IsAny<IEnumerable<string>>()))
                .Returns(new List<Guid>());

            var ftpFspQueryRepositoryMock = new Mock<IFundingTypePeriodFundingStreamPeriodQueryRepository>();
            ftpFspQueryRepositoryMock.Setup(m => m.GetByFundingType(It.IsAny<string>()))
                                     .Returns(new List<FundingTypePeriodFundingStreamPeriod>());

            var policyConfigRepoMock = new Mock<IPolicyConfigRepository>();
            policyConfigRepoMock.Setup(m => m.GetAllContractTypes(It.IsAny<ConnectionInfo>())).Returns(new List<string>());
            policyConfigRepoMock.Setup(m => m.GetAllRegionTypes(It.IsAny<ConnectionInfo>())).Returns(new List<string>());

            var fspLegalDeliverableRepositoryMock = new Mock<IFundingStreamPeriodLegalDeliverableRepository>();
            fspLegalDeliverableRepositoryMock.Setup(m => m.GetAllProfileLegalFspDeliverables(It.IsAny<ConnectionInfo>()))
                .Returns(new List<FundingStreamPeriodLegalDeliverable> { new FundingStreamPeriodLegalDeliverable(string.Empty, 0, true, "", 0) });

            var contractValidationLookupDataCreator =
                new ContractCreateDomain.Endpoint.Infrastructure.ContractValidationLookupDataCreator(
                    policyConfigRepoMock.Object,
                    Mock.Of<IFundingStreamConfigService>(),
                    ftpFspQueryRepositoryMock.Object,
                    Mock.Of<ILogger>(),
                    lookupManagerMock.Object,
                    fspLegalDeliverableRepositoryMock.Object,
                    Mock.Of<ISiblingContractCheckService>());

            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            period = new periodType
                            {
                                periodType1 = new periodTypeType
                                {
                                    periodTypeCode = "AY"
                                }
                            },
                            startDate = new DateTime(),
                            endDate = new DateTime(),
                            contractAllocations = new List<contractAllocation>(),
                            CRMIntent = intent.RevisedNew,
                            fundingTypeCode = "GG"
                        }
                    },
                    period = new periodType
                    {
                        periodType1 = new periodTypeType
                        {
                            periodTypeCode = "AY"
                        }
                    },
                    startDate = new DateTime(),
                    endDate = new DateTime(),
                    CRMIntent = intent.RevisedNew,
                    fundingTypeCode = "GG"
                }
            };

            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            contractValidationLookupDataCreator.CreateLookupDataAndSetContractPresence(contractRequest, mockConnectionInfo.Object);

            // assert
            Assert.AreEqual(true, contractRequest.contract.contracts.First().IsContractNumberWithMatchingUKPRNPeriodAndFundingTypePresentInCrm);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractValidationLookupData_ShouldSetIsContractNumberWithMatchingUKPRNPeriodAndFundingTypePresentInCrm_ToFalse_WhenInCrm()
        {
            const bool lookupReturnValue = false;
            // arrange
            var lookupManagerMock = new Mock<ILookupManager>();
            lookupManagerMock.Setup(
                l => l.IsContractNumberWithMatchingUkprnPeriodAndFundingTypePresentInCrm(It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<int>(),
                    It.IsAny<Guid>(),
                    It.IsAny<Guid>())).Returns(lookupReturnValue);

            lookupManagerMock.Setup(
                l => l.GetColumnValuesForEntity<string>(It.IsAny<CrmLookupType>(), It.IsAny<string>()))
                .Returns(new List<string>());

            lookupManagerMock.Setup(
               l => l.GetColumnValuesForEntity<string>(
                   It.IsAny<CrmLookupType>(),
                   It.IsAny<string>(),
                   It.IsAny<string>(),
                   It.IsAny<List<string>>()))
               .Returns(new List<string>());

            lookupManagerMock.Setup(
              l => l.GetPeriodId(It.IsAny<string>(), It.IsAny<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeCodeType>()))
              .Returns(Guid.Empty);

            lookupManagerMock.Setup(
              l => l.GetFundingTypeId(It.IsAny<string>()))
              .Returns(Guid.Empty);

            lookupManagerMock
                .Setup(m => m.GetUnitOfProcurementReferenceData())
                .Returns(new List<UnitOfProcurement>());

            lookupManagerMock.Setup(m => m.GetPkColumnValuesForEntity(CrmLookupType.SubStatus, It.IsAny<string>(), It.IsAny<IEnumerable<string>>()))
                .Returns(new List<Guid>());

            var ftpFspQueryRepositoryMock = new Mock<IFundingTypePeriodFundingStreamPeriodQueryRepository>();
            ftpFspQueryRepositoryMock.Setup(m => m.GetByFundingType(It.IsAny<string>()))
                                     .Returns(new List<FundingTypePeriodFundingStreamPeriod>());

            var policyConfigRepoMock = new Mock<IPolicyConfigRepository>();
            policyConfigRepoMock.Setup(m => m.GetAllContractTypes(It.IsAny<ConnectionInfo>())).Returns(new List<string>());
            policyConfigRepoMock.Setup(m => m.GetAllRegionTypes(It.IsAny<ConnectionInfo>())).Returns(new List<string>());

            var fspLegalDeliverableRepositoryMock = new Mock<IFundingStreamPeriodLegalDeliverableRepository>();
            fspLegalDeliverableRepositoryMock.Setup(m => m.GetAllProfileLegalFspDeliverables())
                .Returns(new List<FundingStreamPeriodLegalDeliverable> { new FundingStreamPeriodLegalDeliverable(string.Empty, 0, true, "", 0) });

            var contractValidationLookupDataCreator =
                new ContractCreateDomain.Endpoint.Infrastructure.ContractValidationLookupDataCreator(
                    policyConfigRepoMock.Object,
                    Mock.Of<IFundingStreamConfigService>(),
                    ftpFspQueryRepositoryMock.Object,
                    Mock.Of<ILogger>(),
                    lookupManagerMock.Object,
                    fspLegalDeliverableRepositoryMock.Object,
                    Mock.Of<ISiblingContractCheckService>());

            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            period = new periodType
                            {
                                periodType1 = new periodTypeType
                                {
                                    periodTypeCode = "AY"
                                }
                            },
                            startDate = new DateTime(),
                            endDate = new DateTime(),
                            contractAllocations = new List<contractAllocation>(),
                            CRMIntent = intent.RevisedNew,
                            fundingTypeCode = "GG"
                        }
                    },
                    period = new periodType
                    {
                        periodType1 = new periodTypeType
                        {
                            periodTypeCode = "AY"
                        }
                    },
                    startDate = new DateTime(),
                    endDate = new DateTime(),
                    CRMIntent = intent.RevisedNew,
                    fundingTypeCode = "GG"
                }
            };

            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            contractValidationLookupDataCreator.CreateLookupDataAndSetContractPresence(contractRequest, mockConnectionInfo.Object);

            // assert
            Assert.AreEqual(lookupReturnValue, contractRequest.contract.contracts.First().IsContractNumberWithMatchingUKPRNPeriodAndFundingTypePresentInCrm);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractValidationLookupData_ShouldNotAddPresenceCheckItemsWhenFundingTypeIsLevy()
        {
            // arrange
            var lookupManagerMock = new Mock<ILookupManager>();

            lookupManagerMock.Setup(
                l => l.GetColumnValuesForEntity<string>(It.IsAny<CrmLookupType>(), It.IsAny<string>()))
                .Returns(new List<string>());

            lookupManagerMock.Setup(
               l => l.GetColumnValuesForEntity<string>(
                   It.IsAny<CrmLookupType>(),
                   It.IsAny<string>(),
                   It.IsAny<string>(),
                   It.IsAny<List<string>>()))
               .Returns(new List<string>());

            lookupManagerMock.Setup(
              l => l.GetPeriodId(It.IsAny<string>(), It.IsAny<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeCodeType>()))
              .Returns(Guid.Empty);

            lookupManagerMock.Setup(
              l => l.GetFundingTypeId(It.IsAny<string>()))
              .Returns(Guid.Empty);

            lookupManagerMock
                .Setup(m => m.GetUnitOfProcurementReferenceData())
                .Returns(new List<UnitOfProcurement>());

            var ftpFspQueryRepositoryMock = new Mock<IFundingTypePeriodFundingStreamPeriodQueryRepository>();
            ftpFspQueryRepositoryMock.Setup(m => m.GetByFundingType(It.IsAny<string>()))
                                     .Returns(new List<FundingTypePeriodFundingStreamPeriod>());

            var policyConfigRepoMock = new Mock<IPolicyConfigRepository>();
            policyConfigRepoMock.Setup(m => m.GetAllContractTypes(It.IsAny<ConnectionInfo>())).Returns(new List<string>());
            policyConfigRepoMock.Setup(m => m.GetAllRegionTypes(It.IsAny<ConnectionInfo>())).Returns(new List<string>());

            var fspLegalDeliverableRepositoryMock = new Mock<IFundingStreamPeriodLegalDeliverableRepository>();
            fspLegalDeliverableRepositoryMock.Setup(m => m.GetAllProfileLegalFspDeliverables())
                .Returns(new List<FundingStreamPeriodLegalDeliverable> { new FundingStreamPeriodLegalDeliverable(string.Empty, 0, true, "", 0) });

            var contractValidationLookupDataCreator =
                new ContractCreateDomain.Endpoint.Infrastructure.ContractValidationLookupDataCreator(
                    policyConfigRepoMock.Object,
                    Mock.Of<IFundingStreamConfigService>(),
                    ftpFspQueryRepositoryMock.Object,
                    Mock.Of<ILogger>(),
                    lookupManagerMock.Object,
                    fspLegalDeliverableRepositoryMock.Object,
                    Mock.Of<ISiblingContractCheckService>());

            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            period = new periodType
                            {
                                periodType1 = new periodTypeType
                                {
                                    periodTypeCode = "AY"
                                }
                            },
                            startDate = new DateTime(),
                            endDate = new DateTime(),
                            contractAllocations = new List<contractAllocation>(),
                            CRMIntent = intent.New,
                            fundingTypeCode = "LEVY"
                        }
                    },
                    period = new periodType
                    {
                        periodType1 = new periodTypeType
                        {
                            periodTypeCode = "AY"
                        }
                    },
                    startDate = new DateTime(),
                    endDate = new DateTime(),
                    CRMIntent = intent.New,
                    fundingTypeCode = "LEVY"
                }
            };

            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            var lookupData = contractValidationLookupDataCreator.CreateLookupDataAndSetContractPresence(contractRequest, mockConnectionInfo.Object);

            // assert
            Assert.IsFalse(lookupData.PresenceCheckItems.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractValidationLookupDataCreator_ShouldHandleMultipleChildContracts()
        {
            // arrange
            var lookupManagerMock = new Mock<ILookupManager>();

            lookupManagerMock.Setup(
                l => l.GetColumnValuesForEntity<string>(It.IsAny<CrmLookupType>(), It.IsAny<string>()))
                .Returns(new List<string>());

            lookupManagerMock.Setup(
               l => l.GetColumnValuesForEntity<string>(
                   It.IsAny<CrmLookupType>(),
                   It.IsAny<string>(),
                   It.IsAny<string>(),
                   It.IsAny<List<string>>()))
               .Returns(new List<string>());

            lookupManagerMock.Setup(
              l => l.GetPeriodId(It.IsAny<string>(), It.IsAny<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeCodeType>()))
              .Returns(Guid.Empty);

            lookupManagerMock.Setup(
              l => l.GetFundingTypeId(It.IsAny<string>()))
              .Returns(Guid.Empty);

            lookupManagerMock
                .Setup(m => m.GetUnitOfProcurementReferenceData())
                .Returns(new List<UnitOfProcurement>());

            var ftpFspQueryRepositoryMock = new Mock<IFundingTypePeriodFundingStreamPeriodQueryRepository>();
            ftpFspQueryRepositoryMock.Setup(m => m.GetByFundingType(It.IsAny<string>()))
                                     .Returns(new List<FundingTypePeriodFundingStreamPeriod>());

            var policyConfigRepoMock = new Mock<IPolicyConfigRepository>();
            policyConfigRepoMock.Setup(m => m.GetAllContractTypes(It.IsAny<ConnectionInfo>())).Returns(new List<string>());
            policyConfigRepoMock.Setup(m => m.GetAllRegionTypes(It.IsAny<ConnectionInfo>())).Returns(new List<string>());


            var fspLegalDeliverableRepositoryMock = new Mock<IFundingStreamPeriodLegalDeliverableRepository>();
            fspLegalDeliverableRepositoryMock.Setup(m => m.GetAllProfileLegalFspDeliverables())
                .Returns(new List<FundingStreamPeriodLegalDeliverable> { new FundingStreamPeriodLegalDeliverable(string.Empty, 0, true, "", 0) });

            var contractValidationLookupDataCreator =
                new ContractCreateDomain.Endpoint.Infrastructure.ContractValidationLookupDataCreator(
                    policyConfigRepoMock.Object,
                    Mock.Of<IFundingStreamConfigService>(),
                    ftpFspQueryRepositoryMock.Object,
                    Mock.Of<ILogger>(),
                    lookupManagerMock.Object,
                    fspLegalDeliverableRepositoryMock.Object,
                    Mock.Of<ISiblingContractCheckService>());

            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                        {
                            new contractType
                            {
                                period = new periodType
                                {
                                    periodType1 = new periodTypeType
                                    {
                                        periodTypeCode = "AY"
                                    }
                                },
                                startDate = new DateTime(),
                                endDate = new DateTime(),
                                contractAllocations = new List<contractAllocation>
                                {
                                    new contractAllocation
                                    {
                                        contractAllocationNumber = "TEST"
                                    }
                                },
                                CRMIntent = intent.New,
                                fundingTypeCode = "FTC"
                            },
                            new contractType
                            {
                                period = new periodType
                                {
                                    periodType1 = new periodTypeType
                                    {
                                        periodTypeCode = "AY"
                                    }
                                },
                                startDate = new DateTime(),
                                endDate = new DateTime(),
                                contractAllocations = new List<contractAllocation>
                                {
                                    new contractAllocation
                                    {
                                        contractAllocationNumber = "TEST"
                                    }
                                },
                                CRMIntent = intent.New,
                                fundingTypeCode = "FTC"
                            }
                        },
                    period = new periodType
                    {
                        periodType1 = new periodTypeType
                        {
                            periodTypeCode = "AY"
                        }
                    },
                    startDate = new DateTime(),
                    endDate = new DateTime(),
                    CRMIntent = intent.New,
                    fundingTypeCode = "FTC"
                }
            };

            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            var lookupData = contractValidationLookupDataCreator.CreateLookupDataAndSetContractPresence(contractRequest, mockConnectionInfo.Object);

            // assert no exception thrown - pass
            Assert.IsTrue(lookupData.PresenceCheckItems.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractValidationLookupData_ShouldSetProfileFspDeliverables()
        {
            // arrange
            var lookupManagerMock = new Mock<ILookupManager>();
            lookupManagerMock.Setup(
                l => l.IsContractNumberWithMatchingUkprnPeriodAndFundingTypePresentInCrm(It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<int>(),
                    It.IsAny<Guid>(),
                    It.IsAny<Guid>())).Returns(true);

            lookupManagerMock.Setup(
                l => l.GetColumnValuesForEntity<string>(It.IsAny<CrmLookupType>(), It.IsAny<string>()))
                .Returns(new List<string>());

            lookupManagerMock.Setup(
               l => l.GetColumnValuesForEntity<string>(
                   It.IsAny<CrmLookupType>(),
                   It.IsAny<string>(),
                   It.IsAny<string>(),
                   It.IsAny<List<string>>()))
               .Returns(new List<string>());

            lookupManagerMock.Setup(
              l => l.GetPeriodId(It.IsAny<string>(), It.IsAny<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeCodeType>()))
              .Returns(Guid.Empty);

            lookupManagerMock.Setup(
              l => l.GetFundingTypeId(It.IsAny<string>()))
              .Returns(Guid.Empty);

            lookupManagerMock
                .Setup(m => m.GetUnitOfProcurementReferenceData())
                .Returns(new List<UnitOfProcurement>());

            lookupManagerMock.Setup(m => m.GetPkColumnValuesForEntity(CrmLookupType.SubStatus, It.IsAny<string>(), It.IsAny<IEnumerable<string>>()))
                .Returns(new List<Guid>());

            var ftpFspQueryRepositoryMock = new Mock<IFundingTypePeriodFundingStreamPeriodQueryRepository>();
            ftpFspQueryRepositoryMock.Setup(m => m.GetByFundingType(It.IsAny<string>()))
                                     .Returns(new List<FundingTypePeriodFundingStreamPeriod>());

            var policyConfigRepoMock = new Mock<IPolicyConfigRepository>();
            policyConfigRepoMock.Setup(m => m.GetAllContractTypes(It.IsAny<ConnectionInfo>())).Returns(new List<string>());
            policyConfigRepoMock.Setup(m => m.GetAllRegionTypes(It.IsAny<ConnectionInfo>())).Returns(new List<string>());

            var fspLegalDeliverableRepositoryMock = new Mock<IFundingStreamPeriodLegalDeliverableRepository>();
            fspLegalDeliverableRepositoryMock.Setup(m => m.GetAllProfileLegalFspDeliverables(It.IsAny<ConnectionInfo>()))
                .Returns(new List<FundingStreamPeriodLegalDeliverable> { new FundingStreamPeriodLegalDeliverable(string.Empty, 0, true, "", 1)});

            var contractValidationLookupDataCreator =
                new ContractCreateDomain.Endpoint.Infrastructure.ContractValidationLookupDataCreator(
                    policyConfigRepoMock.Object,
                    Mock.Of<IFundingStreamConfigService>(),
                    ftpFspQueryRepositoryMock.Object,
                    Mock.Of<ILogger>(),
                    lookupManagerMock.Object,
                    fspLegalDeliverableRepositoryMock.Object,
                    Mock.Of<ISiblingContractCheckService>());

            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            period = new periodType
                            {
                                periodType1 = new periodTypeType
                                {
                                    periodTypeCode = "AY"
                                }
                            },
                            startDate = new DateTime(),
                            endDate = new DateTime(),
                            contractAllocations = new List<contractAllocation>(),
                            CRMIntent = intent.RevisedNew,
                            fundingTypeCode = "GG"
                        }
                    },
                    period = new periodType
                    {
                        periodType1 = new periodTypeType
                        {
                            periodTypeCode = "AY"
                        }
                    },
                    startDate = new DateTime(),
                    endDate = new DateTime(),
                    CRMIntent = intent.RevisedNew,
                    fundingTypeCode = "GG"
                }
            };

            var mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());

            // act
            var lookupData = contractValidationLookupDataCreator.CreateLookupDataAndSetContractPresence(contractRequest, mockConnectionInfo.Object);

            // assert
            Assert.IsNotNull(lookupData.ProfileFundingStreamPeriodDeliverables, "ProfileFundingStreamPeriodDeliverables should not be null");
            Assert.AreEqual(1, lookupData.ProfileFundingStreamPeriodDeliverables.Count, "ProfileFundingStreamPeriodDeliverables has not been populated");
        }
    }
}