namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Runtime.Caching;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Services;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class ContractValidationLookupDataCreatorUnitTests
    {
        private static readonly Guid FundingTypeId = Guid.NewGuid();
        private static readonly Guid PeriodId = Guid.NewGuid();
        private static readonly Guid SubStatusId = Guid.NewGuid();

        private Mock<IPolicyConfigRepository> _policyConfigRepository;
        private Mock<IFundingStreamConfigService> _fundingStreamConfigService;
        private Mock<IFundingTypePeriodFundingStreamPeriodQueryRepository> _ftpFspRepository;
        private Mock<IFundingStreamPeriodLegalDeliverableRepository> _legalDeliverableRepository;
        private Mock<ILookupManager> _lookupManager;
        private Mock<ILogger> _logger;
        private ContractValidationLookupDataCreator _creator;
        private List<PresenceCheckItem> _checkedItems;

        // The static cache keeps the first value it sees for the whole test process, so reset it to avoid leaking into other test classes.
        private static void ResetStaticCaches()
        {
            MemoryCache.Default.Remove("fscLocalEnterprisePartnerships");
            MemoryCache.Default.Remove("fscDeliverableData");

            var field = typeof(ContractManagement.DataStore.Repositories.ValidationLookupDataCache)
                .GetField("LookupDataByType", System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Static);
            var cache = field.GetValue(null);
            cache.GetType().GetMethod("Clear").Invoke(cache, null);
        }

        [TestCleanup]
        public void Cleanup()
        {
            ResetStaticCaches();
        }

        [TestInitialize]
        public void Setup()
        {
            ResetStaticCaches();

            _policyConfigRepository = new Mock<IPolicyConfigRepository>();
            _policyConfigRepository.Setup(p => p.GetAllContractTypes()).Returns(new[] { "Type A" });
            _policyConfigRepository.Setup(p => p.GetAllRegionTypes()).Returns(new[] { "Region A" });

            _fundingStreamConfigService = new Mock<IFundingStreamConfigService>();
            _fundingStreamConfigService.Setup(f => f.GetFullDeliverableStructure(It.IsAny<string>()))
                .Returns(() => new FSCDeliverableStructureDefinitionResponse
                {
                    DeliverableStructureList = new List<DeliverableConfigurationType>()
                });

            _ftpFspRepository = new Mock<IFundingTypePeriodFundingStreamPeriodQueryRepository>();
            _ftpFspRepository.Setup(f => f.GetByFundingType(It.IsAny<string>()))
                .Returns(new[] { new FundingTypePeriodFundingStreamPeriod("FT", "FP", "FS") });

            _legalDeliverableRepository = new Mock<IFundingStreamPeriodLegalDeliverableRepository>();
            _legalDeliverableRepository.Setup(f => f.GetAllProfileLegalFspDeliverables())
                .Returns(new List<FundingStreamPeriodLegalDeliverable>());

            _logger = new Mock<ILogger>();

            _lookupManager = new Mock<ILookupManager>();
            _lookupManager.Setup(l => l.GetColumnValuesForEntity<string>(It.IsAny<CrmLookupType>(), It.IsAny<string>()))
                .Returns(new List<string> { "Value" });
            _lookupManager.Setup(l => l.GetColumnValuesForEntity<string>(
                    It.IsAny<CrmLookupType>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<IEnumerable<string>>()))
                .Returns(new List<string> { "LEP 1" });
            _lookupManager.Setup(l => l.GetUnitOfProcurementReferenceData())
                .Returns(new List<UnitOfProcurement> { new UnitOfProcurement("U1", "Proc", "FSP") });
            _lookupManager.Setup(l => l.GetFundingTypeId(It.IsAny<string>())).Returns(FundingTypeId);
            _lookupManager.Setup(l => l.GetPeriodId(It.IsAny<string>(), It.IsAny<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.periodTypeCodeType>()))
                .Returns(PeriodId);
            _lookupManager.Setup(l => l.GetOptionsetValue(It.IsAny<string>(), It.IsAny<string>())).Returns(1);
            _lookupManager.Setup(l => l.GetPkColumnValuesForEntity(CrmLookupType.SubStatus, "sfa_statusid", It.IsAny<IEnumerable<string>>()))
                .Returns(new List<Guid> { SubStatusId });
            _lookupManager.Setup(l => l.GetMatchingTenderAwardRefsForAllocation(It.IsAny<IList<string>>()))
                .Returns(new List<MatchingTenderAwardReferenceItem>());
            _lookupManager.Setup(l => l.AreMultipleOverlappingContractsAllowedForFundingType(It.IsAny<string>())).Returns(true);

            _checkedItems = null;
            _lookupManager.Setup(l => l.CheckForPresence(It.IsAny<IEnumerable<PresenceCheckItem>>()))
                .Callback<IEnumerable<PresenceCheckItem>>(items => _checkedItems = items.ToList());

            _creator = new ContractValidationLookupDataCreator(
                _policyConfigRepository.Object,
                _fundingStreamConfigService.Object,
                _ftpFspRepository.Object,
                _logger.Object,
                _lookupManager.Object,
                _legalDeliverableRepository.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ShouldReturnStaticLookupsWithoutPresenceChecks_WhenContractIsNull()
        {
            var result = _creator.CreateLookupDataAndSetContractPresence(null);

            Assert.IsNotNull(result.ContractTypes);
            Assert.IsNotNull(result.LocalEnterprisePartnerships);
            Assert.IsNotNull(result.UnitsOfProcurement);
            Assert.IsNotNull(result.InvestmentPriorities);
            Assert.IsNotNull(result.RegionTypes);
            Assert.IsNotNull(result.SpecificationTitles);
            Assert.IsNotNull(result.ProfileFundingStreamPeriodDeliverables);
            Assert.AreEqual(0, result.PresenceCheckItems.Count);
            _lookupManager.Verify(l => l.CheckForPresence(It.IsAny<IEnumerable<PresenceCheckItem>>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ShouldCachePartnershipsBetweenCalls()
        {
            _creator.CreateLookupDataAndSetContractPresence(null);
            _creator.CreateLookupDataAndSetContractPresence(null);

            _lookupManager.Verify(l => l.GetColumnValuesForEntity<string>(
                CrmLookupType.LocalEnterprisePartnership, It.IsAny<string>(), "sfa_organisationcategory", It.IsAny<IEnumerable<string>>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetUpdateDraftContractData_ShouldReturnContractTypesPartnershipsAndProcurement()
        {
            var result = _creator.GetUpdateDraftContractData();

            Assert.IsNotNull(result.ContractTypes);
            CollectionAssert.AreEqual(new[] { "LEP 1" }, result.LocalEnterprisePartnerships);
            Assert.IsNotNull(result.UnitsOfProcurement);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ForNewIntent_ShouldCreatePresenceItemsForMasterAndSubContracts()
        {
            var request = BuildRequest(ContractRequest.Intent.New, "FT");

            var result = _creator.CreateLookupDataAndSetContractPresence(request);

            Assert.AreEqual(2, result.PresenceCheckItems.Count);
            Assert.AreEqual(2, _checkedItems.Count);
            Assert.IsNotNull(result.FundingTypePeriodFundingStreamPeriods);
            Assert.IsTrue(result.MultipleOverlappingContractsAllowedForFundingType);
            Assert.IsNotNull(result.MatchingTenderAwardReferenceItems);
            Assert.IsTrue(result.FscDeliverableStructureData.ContainsKey("FSP1"));
            Assert.AreEqual(1, result.FscDeliverableStructureData.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ShouldSetPresentFlagsThroughPresenceItemCallbacks()
        {
            var request = BuildRequest(ContractRequest.Intent.New, "FT");

            var result = _creator.CreateLookupDataAndSetContractPresence(request);
            result.PresenceCheckItems[0].IsPresent = true;
            result.PresenceCheckItems[1].IsPresent = true;

            Assert.IsTrue(request.contract.IsPresentInCrm);
            Assert.IsTrue(request.contract.contracts[0].IsContractWithMatchingUKPRNPeriodAndFundingTypePresentInCrm);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ShouldPassTenderAwardReferencesToLookup()
        {
            var request = BuildRequest(ContractRequest.Intent.New, "FT");
            IList<string> passed = null;
            _lookupManager.Setup(l => l.GetMatchingTenderAwardRefsForAllocation(It.IsAny<IList<string>>()))
                .Callback<IList<string>>(r => passed = r)
                .Returns(new List<MatchingTenderAwardReferenceItem>());

            _creator.CreateLookupDataAndSetContractPresence(request);

            CollectionAssert.AreEqual(new[] { "TAR-1" }, passed.ToArray());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ShouldRequestDeliverableStructureOncePerFundingStreamPeriod()
        {
            var request = BuildRequest(ContractRequest.Intent.New, "FT");
            request.contract.contracts[0].contractAllocations.Add(
                new ContractRequest.contractAllocation { fundingStreamPeriodCode = "FSP1" });
            request.contract.contracts[0].contractAllocations.Add(
                new ContractRequest.contractAllocation { fundingStreamPeriodCode = "FSP2" });
            request.contract.contracts[0].contractAllocations.Add(
                new ContractRequest.contractAllocation { fundingStreamPeriodCode = string.Empty });

            var result = _creator.CreateLookupDataAndSetContractPresence(request);

            Assert.AreEqual(2, result.FscDeliverableStructureData.Count);
            _fundingStreamConfigService.Verify(f => f.GetFullDeliverableStructure("FSP1"), Times.Once);
            _fundingStreamConfigService.Verify(f => f.GetFullDeliverableStructure("FSP2"), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ShouldReuseCachedDeliverableStructureOnSecondCall()
        {
            var request = BuildRequest(ContractRequest.Intent.New, "FT");

            _creator.CreateLookupDataAndSetContractPresence(request);
            var second = _creator.CreateLookupDataAndSetContractPresence(BuildRequest(ContractRequest.Intent.New, "FT"));

            _fundingStreamConfigService.Verify(f => f.GetFullDeliverableStructure("FSP1"), Times.Once);
            Assert.IsNotNull(second.FscDeliverableStructureData["FSP1"]);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ShouldAddNewDeliverableStructureToExistingCache()
        {
            _creator.CreateLookupDataAndSetContractPresence(BuildRequest(ContractRequest.Intent.New, "FT", "FSP1"));
            var second = _creator.CreateLookupDataAndSetContractPresence(BuildRequest(ContractRequest.Intent.New, "FT", "FSP9"));

            Assert.IsTrue(second.FscDeliverableStructureData.ContainsKey("FSP9"));
            _fundingStreamConfigService.Verify(f => f.GetFullDeliverableStructure("FSP9"), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ForAmendment_ShouldAddNumberAndStatusPresenceItemsPerSubContract()
        {
            var request = BuildRequest(ContractRequest.Intent.Amendment, "FT");
            _lookupManager.Setup(l => l.IsContractNumberWithMatchingUkprnPeriodAndFundingTypePresentInCrm(
                    "C-1", "M-1", 10001234, PeriodId, FundingTypeId)).Returns(true);
            _lookupManager.Setup(l => l.AreAnyNonWithdrawnOrSupersededDraftContractsWithContractNumber("C-1")).Returns(true);

            var result = _creator.CreateLookupDataAndSetContractPresence(request);

            Assert.AreEqual(5, result.PresenceCheckItems.Count);
            var approved = result.PresenceCheckItems.Single(p => p.ColumnValuesOneOfThese.Count > 0);
            Assert.AreEqual(SubStatusId, approved.ColumnValuesOneOfThese[0].Value);
            Assert.IsTrue(request.contract.contracts[0].IsContractNumberWithMatchingUKPRNPeriodAndFundingTypePresentInCrm);
            Assert.IsTrue(request.contract.contracts[0].IsNonWithdrawnOrSupersededDraftContractWithContractNumberPresentInCrm);
            Assert.IsNotNull(result.FundingTypePeriodFundingStreamPeriods);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ForAmendment_ShouldSetStatusPresenceFlagsViaCallbacks()
        {
            var request = BuildRequest(ContractRequest.Intent.UpdateDraftAmendment, "FT");

            var result = _creator.CreateLookupDataAndSetContractPresence(request);
            foreach (var item in result.PresenceCheckItems.Skip(2))
            {
                item.IsPresent = true;
            }

            var sub = request.contract.contracts[0];
            Assert.IsTrue(sub.IsDraftContractWithContractNumberPresentInCrm);
            Assert.IsTrue(sub.IsApprovedContractWithContractNumberPresentInCrm);
            Assert.IsTrue(sub.IsWithdrawnContractWithContractNumberPresentInCrm);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ForNewAmendment_ShouldAddMasterContractNumberPresenceItem()
        {
            var request = BuildRequest(ContractRequest.Intent.NewAmendment, "FT");

            var result = _creator.CreateLookupDataAndSetContractPresence(request);

            Assert.AreEqual(3, result.PresenceCheckItems.Count);
            result.PresenceCheckItems[2].IsPresent = true;
            Assert.IsTrue(request.contract.IsMasterContractWithMatchingMasterContractNumberPresentInCrm);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ForNewAmendment_ShouldThrow_WhenContractIsNotMasterHierarchy()
        {
            var request = BuildRequest(ContractRequest.Intent.NewAmendment, "FT");
            request.contract.hierarchyType = ContractRequest.hierarchyType.CONTRACT;

            ThrowsHelper.Throws<InvalidOperationException>(
                () => _creator.CreateLookupDataAndSetContractPresence(request));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ForIntentWithoutFtpFspLookup_ShouldNotQueryFundingTypePeriods()
        {
            var request = BuildRequest(ContractRequest.Intent.DeleteDraft, "FT");

            var result = _creator.CreateLookupDataAndSetContractPresence(request);

            Assert.IsNull(result.FundingTypePeriodFundingStreamPeriods);
            _ftpFspRepository.Verify(f => f.GetByFundingType(It.IsAny<string>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ForLevyContract_ShouldCheckExistingDraftOrApprovedLevyContract()
        {
            var request = BuildRequest(ContractRequest.Intent.New, "LEVY");
            _lookupManager.Setup(l => l.IsExistingLevyContractWithDraftOfApprovedStatusForUkprnPresentInCrm(10001234, FundingTypeId))
                .Returns(true);

            var result = _creator.CreateLookupDataAndSetContractPresence(request);

            Assert.IsTrue(request.contract.contracts[0].IsDraftOrApprovedContractForUkprnPresentInCrm);
            Assert.AreEqual(0, result.PresenceCheckItems.Count);
            _lookupManager.Verify(l => l.CheckForPresence(It.IsAny<IEnumerable<PresenceCheckItem>>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ForLevyContract_ShouldSkipLevyLookup_WhenFundingTypeIdIsUnknown()
        {
            var request = BuildRequest(ContractRequest.Intent.New, "LEVY");
            request.contract.contracts[0].fundingTypeCode = null;

            _creator.CreateLookupDataAndSetContractPresence(request);

            _lookupManager.Verify(l => l.IsExistingLevyContractWithDraftOfApprovedStatusForUkprnPresentInCrm(It.IsAny<int>(), It.IsAny<Guid>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ShouldThrow_WhenPeriodTypeCodeIsInvalid()
        {
            var request = BuildRequest(ContractRequest.Intent.New, "FT");
            request.contract.contracts[0].period.periodType1.periodTypeCode = "NOT_A_PERIOD";

            ThrowsHelper.Throws<Exception>(() => _creator.CreateLookupDataAndSetContractPresence(request));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateLookupData_ShouldOmitPeriodColumn_WhenPeriodHasNoPeriodTypeCode()
        {
            var request = BuildRequest(ContractRequest.Intent.New, "FT");
            request.contract.contracts[0].period = null;

            var result = _creator.CreateLookupDataAndSetContractPresence(request);

            var subItem = result.PresenceCheckItems[1];
            Assert.IsFalse(subItem.ColumnValues.Any(c => c.Column == CrmContractFieldName.PeriodId));
            Assert.AreEqual(2, subItem.ColumnValues.Count);
        }

        private static ContractRequest.contractRequestType BuildRequest(
            ContractRequest.Intent intent, string fundingTypeCode, string fundingStreamPeriodCode = "FSP1")
        {
            var allocation = new ContractRequest.contractAllocation
            {
                fundingStreamPeriodCode = fundingStreamPeriodCode,
                tenderAwardReference = "TAR-1"
            };

            var subContract = new ContractRequest.contractType
            {
                contractNumber = "C-1",
                fundingTypeCode = fundingTypeCode,
                hierarchyType = ContractRequest.hierarchyType.CONTRACT,
                period = new ContractRequest.periodType
                {
                    period = "1819",
                    periodType1 = new ContractRequest.periodTypeType { periodTypeCode = "AY" }
                }
            };
            subContract.contractor.ukprn = 10001234;
            subContract.contractAllocations.Add(allocation);

            var master = new ContractRequest.contractType
            {
                contractNumber = "M-1",
                fundingTypeCode = fundingTypeCode,
                hierarchyType = ContractRequest.hierarchyType.MASTERCONTRACT,
                CRMIntent = intent,
                startDate = new DateTime(2018, 8, 1),
                endDate = new DateTime(2019, 7, 31),
                period = new ContractRequest.periodType
                {
                    period = "1819",
                    periodType1 = new ContractRequest.periodTypeType { periodTypeCode = "AY" }
                }
            };
            master.contractor.ukprn = 10001234;
            master.contracts.Add(subContract);

            return new ContractRequest.contractRequestType { contract = master };
        }
    }
}
