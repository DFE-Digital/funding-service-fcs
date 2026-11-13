namespace ContractCreateDomain.Endpoint.Tests.Infrastructure
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Services;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ContractValidationLookupDataCreator = Endpoint.Infrastructure.ContractValidationLookupDataCreator;

    [TestClass]
    public class ContractValidationLookupDataCreatorLookupTests
    {
        private Mock<ILookupManager> _lookupManager;
        private Mock<IFundingStreamConfigService> _fundingStreamConfig;
        private Mock<IFundingTypePeriodFundingStreamPeriodQueryRepository> _ftpFspRepository;
        private Mock<ISiblingContractCheckService> _siblingCheck;
        private ContractValidationLookupDataCreator _creator;

        [TestInitialize]
        public void Setup()
        {
            var policyConfig = new Mock<IPolicyConfigRepository>();
            policyConfig.Setup(r => r.GetAllContractTypes(It.IsAny<ConnectionInfo>())).Returns(new List<string> { "T1" });
            policyConfig.Setup(r => r.GetAllRegionTypes(It.IsAny<ConnectionInfo>())).Returns(new List<string>());

            _lookupManager = new Mock<ILookupManager>();
            _lookupManager.Setup(l => l.GetColumnValuesForEntity<string>(It.IsAny<CrmLookupType>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<List<string>>())).Returns(new List<string>());
            _lookupManager.Setup(l => l.GetUnitOfProcurementReferenceData()).Returns(new List<UnitOfProcurement>());
            _lookupManager.Setup(l => l.GetPkColumnValuesForEntity(It.IsAny<CrmLookupType>(), It.IsAny<string>(), It.IsAny<IEnumerable<string>>())).Returns(new List<Guid>());
            _lookupManager.Setup(l => l.GetPeriodId(It.IsAny<string>(), It.IsAny<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeCodeType>())).Returns(Guid.NewGuid());
            _lookupManager.Setup(l => l.GetFundingTypeId(It.IsAny<string>())).Returns(Guid.NewGuid());

            _fundingStreamConfig = new Mock<IFundingStreamConfigService>();
            _fundingStreamConfig.Setup(s => s.GetFullDeliverableStructure(It.IsAny<string>())).Returns(new FSCDeliverableStructureDefinitionResponse());
            _ftpFspRepository = new Mock<IFundingTypePeriodFundingStreamPeriodQueryRepository>();
            _siblingCheck = new Mock<ISiblingContractCheckService>();

            _creator = new ContractValidationLookupDataCreator(
                policyConfig.Object,
                _fundingStreamConfig.Object,
                _ftpFspRepository.Object,
                Mock.Of<ILogger>(),
                _lookupManager.Object,
                Mock.Of<IFundingStreamPeriodLegalDeliverableRepository>(),
                _siblingCheck.Object);
        }

        private static contractRequestType Request(Intent crmIntent, string fundingType = "Ft", hierarchyType hierarchy = hierarchyType.MASTERCONTRACT, params contractAllocation[] allocations)
        {
            return new contractRequestType
            {
                contract = new contractType
                {
                    CRMIntent = crmIntent,
                    hierarchyType = hierarchy,
                    startDate = new DateTime(2019, 8, 1),
                    endDate = new DateTime(2020, 7, 31),
                    fundingTypeCode = fundingType,
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            fundingTypeCode = fundingType,
                            contractAllocations = allocations.ToList(),
                            period = new periodType { period = "p", periodType1 = new periodTypeType { periodTypeCode = "AY" } }
                        }
                    }
                }
            };
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetUpdateDraftContractData_ReturnsContractTypesLepsAndUnitsOfProcurement()
        {
            var data = _creator.GetUpdateDraftContractData(ConnectionInfo.CreateDefault());

            Assert.IsNotNull(data.ContractTypes);
            Assert.IsNotNull(data.LocalEnterprisePartnerships);
            Assert.IsNotNull(data.UnitsOfProcurement);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_WithAllocations_LoadsDeliverableStructureOncePerFundingStreamPeriodAndSendsTenderRefs()
        {
            var contract = Request(
                Intent.New,
                "Ft",
                hierarchyType.MASTERCONTRACT,
                new contractAllocation { fundingStreamPeriodCode = "LDT-UNIQUE-1", tenderAwardReference = "T-1" },
                new contractAllocation { fundingStreamPeriodCode = "LDT-UNIQUE-1", tenderAwardReference = "T-2" },
                new contractAllocation { fundingStreamPeriodCode = "LDT-UNIQUE-2" });

            var data = _creator.CreateLookupDataAndSetContractPresence(contract, ConnectionInfo.CreateDefault());

            CollectionAssert.AreEquivalent(new[] { "LDT-UNIQUE-1", "LDT-UNIQUE-2" }, data.FscDeliverableStructureData.Keys.ToList());
            _fundingStreamConfig.Verify(s => s.GetFullDeliverableStructure("LDT-UNIQUE-1"), Times.Once);
            _lookupManager.Verify(l => l.GetMatchingTenderAwardRefsForAllocation(It.Is<IList<string>>(r => r.Count == 2 && r[0] == "T-1" && r[1] == "T-2")), Times.Once);
            _lookupManager.Verify(l => l.AreMultipleOverlappingContractsAllowedForFundingType("Ft"), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_DeliverableStructureIsServedFromCacheOnSecondRequest()
        {
            var allocation = new contractAllocation { fundingStreamPeriodCode = "LDT-CACHED" };

            _creator.CreateLookupDataAndSetContractPresence(Request(Intent.New, "Ft", hierarchyType.MASTERCONTRACT, allocation), ConnectionInfo.CreateDefault());
            var second = _creator.CreateLookupDataAndSetContractPresence(Request(Intent.New, "Ft", hierarchyType.MASTERCONTRACT, allocation), ConnectionInfo.CreateDefault());

            Assert.IsTrue(second.FscDeliverableStructureData.ContainsKey("LDT-CACHED"));
            _fundingStreamConfig.Verify(s => s.GetFullDeliverableStructure("LDT-CACHED"), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_NewIntent_LooksUpFundingTypePeriodFundingStreamPeriods()
        {
            var expected = new List<ContractManagement.DataStore.Model.FundingTypePeriodFundingStreamPeriod>();
            _ftpFspRepository.Setup(r => r.GetByFundingType("Ft", It.IsAny<ConnectionInfo>())).Returns(expected);

            var data = _creator.CreateLookupDataAndSetContractPresence(Request(Intent.New), ConnectionInfo.CreateDefault());

            Assert.AreSame(expected, data.FundingTypePeriodFundingStreamPeriods);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_LevyContract_ChecksForExistingDraftOrApprovedContractForUkprn()
        {
            _lookupManager.Setup(l => l.IsExistingLevyContractWithDraftOfApprovedStatusForUkprnPresentInCrm(It.IsAny<int>(), It.IsAny<Guid>())).Returns(true);
            var contract = Request(Intent.New, "LEVY", hierarchyType.CONTRACT);

            var data = _creator.CreateLookupDataAndSetContractPresence(contract, ConnectionInfo.CreateDefault());

            Assert.AreEqual(0, data.PresenceCheckItems.Count);
            Assert.IsTrue(contract.contract.contracts[0].IsDraftOrApprovedContractForUkprnPresentInCrm);
            _lookupManager.Verify(l => l.CheckForPresence(It.IsAny<List<PresenceCheckItem>>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_NewAmendmentWithMasterContract_AddsMasterContractNumberPresenceCheck()
        {
            var contract = Request(Intent.NewAmendment);

            var data = _creator.CreateLookupDataAndSetContractPresence(contract, ConnectionInfo.CreateDefault());

            Assert.AreEqual(3, data.PresenceCheckItems.Count);
            _lookupManager.Verify(l => l.CheckForPresence(It.IsAny<List<PresenceCheckItem>>()), Times.Once);

            data.PresenceCheckItems.Last().SetPresent(true);
            Assert.IsTrue(contract.contract.IsMasterContractWithMatchingMasterContractNumberPresentInCrm);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_NewAmendmentWithoutMasterContract_Throws()
        {
            try
            {
                _creator.CreateLookupDataAndSetContractPresence(Request(Intent.NewAmendment, "Ft", hierarchyType.CONTRACT), ConnectionInfo.CreateDefault());
                Assert.Fail("Expected InvalidOperationException");
            }
            catch (InvalidOperationException)
            {
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_AmendmentIntent_AddsDraftApprovedAndWithdrawnPresenceChecksPerSubContract()
        {
            var contract = Request(Intent.Amendment);

            var data = _creator.CreateLookupDataAndSetContractPresence(contract, ConnectionInfo.CreateDefault());

            // master + sub contract + draft/approved/withdrawn for the sub contract
            Assert.AreEqual(5, data.PresenceCheckItems.Count);
            foreach (var item in data.PresenceCheckItems)
            {
                item.SetPresent(true);
            }

            var sub = contract.contract.contracts[0];
            Assert.IsTrue(contract.contract.IsPresentInCrm);
            Assert.IsTrue(sub.IsContractWithMatchingUKPRNPeriodAndFundingTypePresentInCrm);
            Assert.IsTrue(sub.IsDraftContractWithContractNumberPresentInCrm);
            Assert.IsTrue(sub.IsApprovedContractWithContractNumberPresentInCrm);
            Assert.IsTrue(sub.IsWithdrawnContractWithContractNumberPresentInCrm);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_InvalidPeriodTypeCode_Throws()
        {
            var contract = Request(Intent.New);
            contract.contract.contracts[0].period.periodType1.periodTypeCode = "NotAPeriodType";

            try
            {
                _creator.CreateLookupDataAndSetContractPresence(contract, ConnectionInfo.CreateDefault());
                Assert.Fail("Expected an exception for the invalid period type code");
            }
            catch (Exception ex)
            {
                StringAssert.Contains(ex.Message, "NotAPeriodType");
            }
        }
    }
}
