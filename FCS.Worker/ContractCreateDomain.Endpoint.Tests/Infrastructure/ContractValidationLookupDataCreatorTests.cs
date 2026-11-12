namespace ContractCreateDomain.Endpoint.Tests.Infrastructure
{
    using System;
    using System.Collections.Generic;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ContractValidationLookupDataCreator = Endpoint.Infrastructure.ContractValidationLookupDataCreator;

    [TestClass]
    public class ContractValidationLookupDataCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractValidationLookupDataCreator_CreateLookupDataAndSetContractPresence_ShouldCheckSiblingWithDraftStatus_WhenIntentIsRevisedNew()
        {
            // arrange
            contractRequestType contract = new contractRequestType
            {
                contract = new contractType
                {
                    CRMIntent = Intent.RevisedNew,
                    startDate = new DateTime(2019,8,1),
                    endDate = new DateTime(2020, 7, 31),
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            fundingTypeCode = "Ft",
                            period = new periodType
                            {
                                period = "p",
                                periodType1 = new periodTypeType
                                {
                                    periodTypeCode = "AY"
                                }
                            }
                        }
                    },
                    fundingTypeCode = "Ft"
                }
            };
            Mock<ISiblingContractCheckService> siblingContractCheckService = new Mock<ISiblingContractCheckService>();

            // act
            GetContractValidationLookupDataCreator(siblingContractCheckService).CreateLookupDataAndSetContractPresence(contract, ConnectionInfo.CreateDefault());

            // assert
            siblingContractCheckService.Verify(s => 
                s.HasSiblingContractWithDraftStatus(
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<ConnectionInfo>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractValidationLookupDataCreator_CreateLookupDataAndSetContractPresence_ShouldCheckSiblingWithDraftStatus_WhenIntentIsNewAmendment()
        {
            // arrange
            contractRequestType contract = new contractRequestType
            {
                contract = new contractType
                {
                    CRMIntent = Intent.NewAmendment,
                    startDate = new DateTime(2019, 8, 1),
                    endDate = new DateTime(2020, 7, 31),
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            fundingTypeCode = "Ft",
                            period = new periodType
                            {
                                period = "p",
                                periodType1 = new periodTypeType
                                {
                                    periodTypeCode = "AY"
                                }
                            }
                        }
                    },
                    fundingTypeCode = "Ft"
                }
            };
            Mock<ISiblingContractCheckService> siblingContractCheckService = new Mock<ISiblingContractCheckService>();

            // act
            GetContractValidationLookupDataCreator(siblingContractCheckService).CreateLookupDataAndSetContractPresence(contract, ConnectionInfo.CreateDefault());

            // assert
            siblingContractCheckService.Verify(s =>
                s.HasSiblingContractWithDraftStatus(
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<ConnectionInfo>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractValidationLookupDataCreator_CreateLookupDataAndSetContractPresence_ShouldCheckSiblingWithDraftStatus_WhenIntentIsAmendment()
        {
            // arrange
            contractRequestType contract = new contractRequestType
            {
                contract = new contractType
                {
                    CRMIntent = Intent.Amendment,
                    startDate = new DateTime(2019, 8, 1),
                    endDate = new DateTime(2020, 7, 31),
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            fundingTypeCode = "Ft",
                            period = new periodType
                            {
                                period = "p",
                                periodType1 = new periodTypeType
                                {
                                    periodTypeCode = "AY"
                                }
                            }
                        }
                    },
                    fundingTypeCode = "Ft"
                }
            };
            Mock<ISiblingContractCheckService> siblingContractCheckService = new Mock<ISiblingContractCheckService>();

            // act
            GetContractValidationLookupDataCreator(siblingContractCheckService).CreateLookupDataAndSetContractPresence(contract, ConnectionInfo.CreateDefault());

            // assert
            siblingContractCheckService.Verify(s =>
                s.HasSiblingContractWithDraftStatus(
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<ConnectionInfo>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractValidationLookupDataCreator_CreateLookupDataAndSetContractPresence_ShouldNotCheckSiblingWithDraftStatus_WhenIntentIsNew()
        {
            // arrange
            contractRequestType contract = new contractRequestType
            {
                contract = new contractType
                {
                    CRMIntent = Intent.New,
                    startDate = new DateTime(2019, 8, 1),
                    endDate = new DateTime(2020, 7, 31),
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            fundingTypeCode = "Ft",
                            period = new periodType
                            {
                                period = "p",
                                periodType1 = new periodTypeType
                                {
                                    periodTypeCode = "AY"
                                }
                            }
                        }
                    },
                    fundingTypeCode = "Ft"
                }
            };
            Mock<ISiblingContractCheckService> siblingContractCheckService = new Mock<ISiblingContractCheckService>();

            // act
            GetContractValidationLookupDataCreator(siblingContractCheckService).CreateLookupDataAndSetContractPresence(contract, ConnectionInfo.CreateDefault());

            // assert
            siblingContractCheckService.Verify(s =>
                s.HasSiblingContractWithDraftStatus(
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<ConnectionInfo>()), Times.Never);
        }

        private ContractValidationLookupDataCreator GetContractValidationLookupDataCreator(Mock<ISiblingContractCheckService> siblingContractCheckService)
        {
            Mock<IPolicyConfigRepository> policyConfigRepositoryMock = new Mock<IPolicyConfigRepository>();
            policyConfigRepositoryMock.Setup(r => r.GetAllContractTypes(It.IsAny<ConnectionInfo>()))
                .Returns(new List<string>());
            policyConfigRepositoryMock.Setup(r => r.GetAllRegionTypes(It.IsAny<ConnectionInfo>()))
                .Returns(new List<string>());

            Mock<ILookupManager> lookupManagerMock = new Mock<ILookupManager>();
            lookupManagerMock.Setup(l => l.GetColumnValuesForEntity<string>(
                It.IsAny<CrmLookupType>(),
                It.IsAny<string>(),
                It.IsAny<string>(),
                It.IsAny<List<string>>())).Returns(new List<string>());

            lookupManagerMock.Setup(l => l.GetUnitOfProcurementReferenceData()).Returns(new List<UnitOfProcurement>());

            lookupManagerMock.Setup(l => l.GetPkColumnValuesForEntity(It.IsAny<CrmLookupType>(), It.IsAny<string>(), It.IsAny<IEnumerable<string>>())).Returns(new List<Guid>());
            lookupManagerMock.Setup(l => l.GetPeriodId(It.IsAny<string>(), It.IsAny<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeCodeType>())).Returns(Guid.NewGuid());
            lookupManagerMock.Setup(l => l.GetFundingTypeId(It.IsAny<string>())).Returns(Guid.NewGuid());


            ContractValidationLookupDataCreator creator = new ContractValidationLookupDataCreator(
                policyConfigRepositoryMock.Object,
                Mock.Of<IFundingStreamConfigService>(),
                Mock.Of<IFundingTypePeriodFundingStreamPeriodQueryRepository>(),
                Mock.Of<ILogger>(),
                lookupManagerMock.Object,
                Mock.Of<IFundingStreamPeriodLegalDeliverableRepository>(),
                siblingContractCheckService.Object
            );

            return creator;
        }

    }
}
