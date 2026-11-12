namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Runtime.Caching;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities;
    using Implementation.Entities;
    using Entities;
    using MoreLinq;
    using Services;
    using Framework.Logging.Interfaces;
    using ContractRequest = CrossDomain.Integration.Entities.ContractRequest;
    using CorporateContract = CrossDomain.Integration.Entities.CorporateContract;

    public class ContractValidationLookupDataCreator : IContractValidationLookupDataCreator
    {
        public static readonly string[] ContractStatusesForDraft = { "Unassigned", "In Review" };

        // Expiration time of the cache in minutes.
        private const double CacheExpiration = 30;
        private const string LocalEnterprisePartnershipsCacheName = "fscLocalEnterprisePartnerships";
        private const string FscDeliverableDataCacheName = "fscDeliverableData";
        private const string DraftContractStatus = "Draft";
        private const string ApprovedContractStatus = "Approved";
        private const string ApprovedContractSubStatus = "Approved";
        private const string UnderTerminationSubStatus = "Under Termination";
        private const string WithdrawnContractStatus = "Withdrawn";
        private static readonly object CacheLock = new object();
        private ObjectCache cache = MemoryCache.Default;

        private readonly IPolicyConfigRepository _policyConfigRepository;
        private readonly IFundingStreamConfigService _fundingStreamConfigurationService;
        private readonly ILookupManager _lookupManager;
        private readonly IFundingTypePeriodFundingStreamPeriodQueryRepository _fundingTypePeriodFundingStreamPeriodQueryRepository;
        private readonly IFundingStreamPeriodLegalDeliverableRepository _fundingStreamPeriodLegalDeliverableRepository;
        private readonly ILogger _logger;

        public ContractValidationLookupDataCreator(IPolicyConfigRepository policyConfigRepository, IFundingStreamConfigService fundingStreamConfigurationService, IFundingTypePeriodFundingStreamPeriodQueryRepository fundingTypePeriodFundingStreamPeriodQueryRepository, ILogger logger, ILookupManager lookupManager, IFundingStreamPeriodLegalDeliverableRepository fspLegalDeliverableRepository)
        {
            _policyConfigRepository = policyConfigRepository;
            _fundingStreamConfigurationService = fundingStreamConfigurationService;
            _fundingTypePeriodFundingStreamPeriodQueryRepository = fundingTypePeriodFundingStreamPeriodQueryRepository;
            _logger = logger;
            _lookupManager = lookupManager;
            _fundingStreamPeriodLegalDeliverableRepository = fspLegalDeliverableRepository;
        }

        private List<string> ContractTypes =>
            ValidationLookupDataCache.Get(ValidationLookupType.ContractType, _policyConfigRepository.GetAllContractTypes).ToList();

        // Collection of LEPs may be updated while the application is running
        // and therefore cannot use ValidationLookupDataCache
        private List<string> LocalEnterprisePartnerships
        {
            get
            {
                List<string> cacheData = cache[LocalEnterprisePartnershipsCacheName] as List<string>;

                if (cacheData == null)
                {
                    lock (CacheLock)
                    {
                        cacheData = _lookupManager.GetColumnValuesForEntity<string>(
                            CrmLookupType.LocalEnterprisePartnership,
                            CrmLookupType.LocalEnterprisePartnership.GetEntityDetail().LookupColumn,
                            "sfa_organisationcategory",
                            new List<string> { "229660001" });
                        cache.Set(LocalEnterprisePartnershipsCacheName, cacheData, new CacheItemPolicy { AbsoluteExpiration = DateTimeOffset.Now.AddMinutes(CacheExpiration) });
                    }
                }

                return cacheData;
            }
        }

        private IReadOnlyCollection<UnitOfProcurement> UnitsOfProcurement => 
            ValidationLookupDataCache.Get(ValidationLookupType.UnitOfProcurement, _lookupManager.GetUnitOfProcurementReferenceData);

        private List<string> InvestmentPriorities =>
            ValidationLookupDataCache.Get(ValidationLookupType.InvestmentPriority, 
                () => _lookupManager.GetColumnValuesForEntity<string>(
                        CrmLookupType.InvestmentPriority,
                        CrmLookupType.InvestmentPriority.GetEntityDetail().LookupColumn));


        private List<string> RegionTypes =>
            ValidationLookupDataCache.Get(ValidationLookupType.RegionType, _policyConfigRepository.GetAllRegionTypes).ToList();

        private List<string> SpecificationTitles =>
            ValidationLookupDataCache.Get(ValidationLookupType.SpecificationTitle, 
                () => _lookupManager.GetColumnValuesForEntity<string>(
                    CrmLookupType.SpecificationTitle,
                    CrmLookupType.SpecificationTitle.GetEntityDetail().LookupColumn));

        private IReadOnlyCollection<FundingStreamPeriodLegalDeliverable> ProfileFspLegalDeliverables =>
            ValidationLookupDataCache.Get(ValidationLookupType.FspLegalDeliverable,
                () => _fundingStreamPeriodLegalDeliverableRepository.GetAllProfileLegalFspDeliverables());
        
        public ContractValidationLookupData CreateLookupDataAndSetContractPresence(ContractRequest.contractRequestType contract)
        {
            var lookupData = new ContractValidationLookupData();

            if (contract != null)
            {
                if (IsPresenceCheckItemsRequired(contract))
                {
                    // create presenceCheckItem for the master
                    lookupData.PresenceCheckItems.Add(CreatePresenceCheckItemForContract(contract.contract));
                    foreach (var subContract in contract.contract.contracts)
                    {
                        lookupData.PresenceCheckItems.Add(CreatePresenceCheckItemForSubContract(subContract));
                    }

                    if (IsIntentRequiringExistingContractNumberLookup(contract.contract.CRMIntent))
                    {
                        AddPresenceCheckItemsToLookupForExistingContractsWithContractNumber(contract, lookupData);
                    }

                    if (IsIntentRequiringExistingMasterContractNumberLookup(contract.contract.CRMIntent))
                    {
                        AddPresenceCheckItemsToLookupForMasterContractWithMasterContractNumber(contract, lookupData);
                    }

                    if (lookupData.PresenceCheckItems.Count > 0)
                    {
                        _lookupManager.CheckForPresence(lookupData.PresenceCheckItems);
                    }
                }
                else
                {
                    AddPresenceCheckItemsToLookupForExistingDraftOrApprovedContractsForUkprn(contract, lookupData);
                }

                if (IsIntentRequiringFtpFspLookup(contract.contract.CRMIntent))
                {
                    lookupData.FundingTypePeriodFundingStreamPeriods = 
                        _fundingTypePeriodFundingStreamPeriodQueryRepository.GetByFundingType(contract.contract.fundingTypeCode);
                }

                IList<string> importedTenderAwardReferencesWithAllocationNumbers = new List<string>();

                lookupData.FscDeliverableStructureData = new Dictionary<string, FSCDeliverableStructureDefinitionResponse>();
                foreach (var allocation in contract.GetAllocations())
                {
                    if (!string.IsNullOrEmpty(allocation.fundingStreamPeriodCode))
                    {
                        if (!lookupData.FscDeliverableStructureData.ContainsKey(allocation.fundingStreamPeriodCode))
                        {
                            lookupData.FscDeliverableStructureData.Add(allocation.fundingStreamPeriodCode,
                                FscDeliverableStructureData(allocation.fundingStreamPeriodCode));
                        }
                        }

                    if (!string.IsNullOrEmpty(allocation.tenderAwardReference))
                    {
                        // Add the award ref to the list of of ones found
                        importedTenderAwardReferencesWithAllocationNumbers.Add(allocation.tenderAwardReference);
                    }
                }

                // Invoke method to return matching ones from the CRM
                lookupData.MatchingTenderAwardReferenceItems = _lookupManager.GetMatchingTenderAwardRefsForAllocation(importedTenderAwardReferencesWithAllocationNumbers);

                // Get the allow multiple/overlapping contracts flag based on funding code type from the contract
                lookupData.MultipleOverlappingContractsAllowedForFundingType =
                    _lookupManager.AreMultipleOverlappingContractsAllowedForFundingType(contract.contract.fundingTypeCode);
            }

            lookupData.ContractTypes = ContractTypes;
            lookupData.LocalEnterprisePartnerships = LocalEnterprisePartnerships;
            lookupData.UnitsOfProcurement = UnitsOfProcurement.ToList();
            lookupData.InvestmentPriorities = InvestmentPriorities;
            lookupData.RegionTypes = RegionTypes;
            lookupData.SpecificationTitles = SpecificationTitles;
            lookupData.ProfileFundingStreamPeriodDeliverables = ProfileFspLegalDeliverables;

            return lookupData;
        }

        public ContractValidationLookupData GetUpdateDraftContractData()
        {
            return new ContractValidationLookupData
            {
                ContractTypes = ContractTypes,
                LocalEnterprisePartnerships = LocalEnterprisePartnerships,
                UnitsOfProcurement = UnitsOfProcurement.ToList()
            };
        }

        private void AddPresenceCheckItemsToLookupForExistingContractsWithContractNumber(ContractRequest.contractRequestType contract, ContractValidationLookupData lookupData)
        {
            foreach (var subContract in contract.contract.contracts)
            {
                PresenceCheckItem existingDraftWithContractNumberPresenceCheck =
                    CreatePresenceCheckItemForContractWithContractNumberAndStatus(
                        subContract, DraftContractStatus, present => subContract.IsDraftContractWithContractNumberPresentInCrm = present);

                PresenceCheckItem existingApprovedWithContractNumberPresenceCheck =
                    AddSubStatusCheckToPresenceCheckItem(
                        CreatePresenceCheckItemForContractWithContractNumberAndStatus(
                            subContract, ApprovedContractStatus, present => subContract.IsApprovedContractWithContractNumberPresentInCrm = present),
                        new [] { ApprovedContractSubStatus, UnderTerminationSubStatus });

                PresenceCheckItem existingWithdrawnWithContractNumberPresenceCheck =
                    CreatePresenceCheckItemForContractWithContractNumberAndStatus(
                        subContract, WithdrawnContractStatus, present => subContract.IsWithdrawnContractWithContractNumberPresentInCrm = present);

                lookupData.PresenceCheckItems.AddRange(new[] 
                {
                    existingDraftWithContractNumberPresenceCheck,
                    existingApprovedWithContractNumberPresenceCheck,
                    existingWithdrawnWithContractNumberPresenceCheck
                });

                subContract.IsContractNumberWithMatchingUKPRNPeriodAndFundingTypePresentInCrm = _lookupManager.IsContractNumberWithMatchingUkprnPeriodAndFundingTypePresentInCrm(
                        subContract.contractNumber,
                        contract.contract.contractNumber,
                        contract.contract.contractor.ukprn,
                        GetPeriodId(subContract).Value,
                        GetFundingTypeId(subContract).Value);

                subContract.IsNonWithdrawnOrSupersededDraftContractWithContractNumberPresentInCrm =
                    IsNonWithdrawnOrSupersededDraftContractWithContractNumberPresentInCrm(subContract.contractNumber);
            }
        }

        private void AddPresenceCheckItemsToLookupForExistingDraftOrApprovedContractsForUkprn(ContractRequest.contractRequestType contract, ContractValidationLookupData lookupData)
        {
            foreach (var subContract in contract.contract.contracts)
            {
                var fundingTypeId = GetFundingTypeId(subContract);

                if (fundingTypeId != null)
                {
                    subContract.IsDraftOrApprovedContractForUkprnPresentInCrm =
                        _lookupManager.IsExistingLevyContractWithDraftOfApprovedStatusForUkprnPresentInCrm(
                            contract.contract.contractor.ukprn,
                            fundingTypeId.Value);
                }

                _logger.LogInformation(
                    9001,
                    "Got lookup data master {0} contractNumber {1} ukprn {2} period {3} result {4}",
                    contract.contract.contractNumber,
                    subContract.contractNumber,
                    contract.contract.contractor.ukprn,
                    subContract.period.periodType1.periodTypeCode,
                    subContract.IsDraftOrApprovedContractForUkprnPresentInCrm);
            }
        }

        private bool IsNonWithdrawnOrSupersededDraftContractWithContractNumberPresentInCrm(string contractNumber)
        {
            return _lookupManager.AreAnyNonWithdrawnOrSupersededDraftContractsWithContractNumber(contractNumber);
        }

        private void AddPresenceCheckItemsToLookupForMasterContractWithMasterContractNumber(ContractRequest.contractRequestType contract, ContractValidationLookupData lookupData)
        {            
            lookupData.PresenceCheckItems.Add(CreatePresenceCheckItemForMasterContractWithMasterContractNumber(contract.contract, present => contract.contract.IsMasterContractWithMatchingMasterContractNumberPresentInCrm = present));
        }

        private bool IsIntentRequiringExistingContractNumberLookup(ContractRequest.Intent intent)
        {
            return intent == ContractRequest.Intent.Amendment || intent == ContractRequest.Intent.UpdateDraftAmendment || intent == ContractRequest.Intent.RevisedNew;
        }

        private bool IsIntentRequiringExistingMasterContractNumberLookup(ContractRequest.Intent intent)
        {
            return intent == ContractRequest.Intent.NewAmendment;
        }

        private bool IsIntentRequiringFtpFspLookup(ContractRequest.Intent intent)
        {
            return intent == ContractRequest.Intent.NewAmendment
                   || intent == ContractRequest.Intent.New
                   || intent == ContractRequest.Intent.RevisedNew
                   || intent == ContractRequest.Intent.UpdateDraft
                   || intent == ContractRequest.Intent.Amendment
                   || intent == ContractRequest.Intent.UpdateDraftAmendment;
        }

        private FSCDeliverableStructureDefinitionResponse FscDeliverableStructureData(string fundingStreamPeriodCode)
        {
            IDictionary<string, FSCDeliverableStructureDefinitionResponse> cacheData =
                cache[FscDeliverableDataCacheName] as IDictionary<string, FSCDeliverableStructureDefinitionResponse>;

            FSCDeliverableStructureDefinitionResponse deliverableStructure = null;

            if (cacheData == null || !cacheData.ContainsKey(fundingStreamPeriodCode))
            {
                // Get data
                deliverableStructure = FundingStreamConfigServiceHelper.FilterProfileDeliverableStructure(
                    _fundingStreamConfigurationService.GetFullDeliverableStructure(fundingStreamPeriodCode));

                if (cacheData == null)
                {
                    cacheData = new Dictionary<string, FSCDeliverableStructureDefinitionResponse>();
                }

                cacheData.Add(fundingStreamPeriodCode, deliverableStructure);
                cache.Set(FscDeliverableDataCacheName, cacheData, new CacheItemPolicy { AbsoluteExpiration = DateTimeOffset.Now.AddMinutes(CacheExpiration) });
            }
            else
            {
                deliverableStructure = cacheData.FirstOrDefault(d => d.Key == fundingStreamPeriodCode).Value;
            }

            return deliverableStructure;
        }

        private PresenceCheckItem CreatePresenceCheckItemForSubContract(ContractRequest.contractType contract)
        {
            List<ColumnValue> columnValues = new List<ColumnValue>();
            ColumnValue ukprnColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.Ukprn,
                Value = contract.contractor.ukprn.ToString()
            };
            columnValues.Add(ukprnColumnValue);
            
            ColumnValue periodColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.PeriodId,
                Value = GetPeriodId(contract)
            };            
            if (periodColumnValue.Value != null)
            {
                columnValues.Add(periodColumnValue);
            }

            ColumnValue fundingTypeCodeColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.FundingType,
                Value = GetFundingTypeId(contract)
            };
            columnValues.Add(fundingTypeCodeColumnValue);

            return new PresenceCheckItem(CrmEntityName.Contract, columnValues) { OriginalObject = contract, SetPresent = present => contract.IsContractWithMatchingUKPRNPeriodAndFundingTypePresentInCrm = present };
        }

        private PresenceCheckItem CreatePresenceCheckItemForContract(ContractRequest.contractType contract)
        {
            List<ColumnValue> columnValues = new List<ColumnValue>();
            ColumnValue ukprnColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.Ukprn,

                // in the CRM this is held as a string
                Value = contract.contractor.ukprn.ToString()
            };

            const CrmOptionSetType contractHierarchyType = CrmOptionSetType.HierarchyType;

            ColumnValue contractHierarchyTypeColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.HierarchyType,
                Value = _lookupManager.GetOptionsetValue(contractHierarchyType.GetOptionSetName(), contractHierarchyType.GetOptionValue(contract.hierarchyType.ToString()))
            };
            ColumnValue periodColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.PeriodId,
                Value = GetPeriodId(contract)
            };
            columnValues.Add(ukprnColumnValue);
            columnValues.Add(contractHierarchyTypeColumnValue);
            if (periodColumnValue.Value != null)
            {
                columnValues.Add(periodColumnValue);
            }

            ColumnValue fundingTypeCodeColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.FundingType,
                Value = GetFundingTypeId(contract)
            };

            columnValues.Add(fundingTypeCodeColumnValue);

            ColumnValue startDateColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.StartDate,
                Value = contract.startDate.Value.ToUniversalTime()
            };

            columnValues.Add(startDateColumnValue);

            ColumnValue endDateColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.EndDate,
                Value = contract.endDate.Value.ToUniversalTime()
            };

            columnValues.Add(endDateColumnValue);

            return new PresenceCheckItem(CrmEntityName.Contract, columnValues) { OriginalObject = contract, SetPresent = present => contract.IsPresentInCrm = present };
        }

        private PresenceCheckItem CreatePresenceCheckItemForMasterContractWithMasterContractNumber(
            ContractRequest.contractType contract, Action<bool> setPresent)
        {
            if (contract.hierarchyType != CrossDomain.Integration.Entities.ContractRequest.hierarchyType.MASTERCONTRACT)
            {
                throw new InvalidOperationException("Only a Master Contract should be checked for existance here");
            }

            List<ColumnValue> columnValues = new List<ColumnValue>();

            ColumnValue contractNumberColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.Number,
                Value = contract.contractNumber
            };

            columnValues.Add(contractNumberColumnValue);

            PresenceCheckItem presenceCheckItem = new PresenceCheckItem(CrmEntityName.Contract, columnValues) { OriginalObject = contract, SetPresent = setPresent };

            return presenceCheckItem;
        }

        private PresenceCheckItem CreatePresenceCheckItemForContractWithContractNumberAndStatus(ContractRequest.contractType contract, string status, Action<bool> setPresent)
        {
            const string contractStatusOptionSet = "sfa_contractstatus";
            List<ColumnValue> columnValues = new List<ColumnValue>();

            ColumnValue contractNumberColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.Number,
                Value = contract.contractNumber
            };

            columnValues.Add(contractNumberColumnValue);

            ColumnValue statusColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.ContractStatus,
                Value = _lookupManager.GetOptionsetValue(contractStatusOptionSet, status)
            };

            PresenceCheckItem presenceCheckItem = new PresenceCheckItem(CrmEntityName.Contract, columnValues) { OriginalObject = contract, SetPresent = setPresent };

            columnValues.Add(statusColumnValue);

            return presenceCheckItem;
        }

        private PresenceCheckItem AddSubStatusCheckToPresenceCheckItem(PresenceCheckItem presenceCheckItem, string[] subStatuses)
        {
            const string primaryKey = "sfa_statusid";
            IList<Guid> statusPrimaryKeys = _lookupManager.GetPkColumnValuesForEntity(CrmLookupType.SubStatus, primaryKey, subStatuses);
            statusPrimaryKeys.ForEach(statusPk =>
            {
                ColumnValue subStatusColumnValue = new ColumnValue
                {
                    Column = CrmContractFieldName.SubStatus,
                    Value = statusPk
                };
                presenceCheckItem.ColumnValuesOneOfThese.Add(subStatusColumnValue);
            });

            return presenceCheckItem;
        }

        private Guid? GetFundingTypeId(ContractRequest.contractType contract)
        {
            Guid? guid = null;
            if (contract.fundingTypeCode != null)
            {
                guid = _lookupManager.GetFundingTypeId(contract.fundingTypeCode);
            }

            return guid;
        }

        private Guid? GetPeriodId(ContractRequest.contractType contract)
        {
            Guid? guid = null;
            CorporateContract.periodTypeCodeType periodTypeCode;
            if (contract.period != null && contract.period.periodType1 != null && !string.IsNullOrEmpty(contract.period.periodType1.periodTypeCode))
            {
                if (Enum.TryParse(contract.period.periodType1.periodTypeCode, out periodTypeCode))
                {
                    PeriodInfo periodInfo = new PeriodInfo
                    {
                        Period = contract.period.period,
                        PeriodTypeCode = periodTypeCode
                    };

                    guid = _lookupManager.GetPeriodId(periodInfo.Period, periodInfo.PeriodTypeCode);
                }
                else
                {
                    throw new Exception("The period type code is not valid - " + contract.period.periodType1.periodTypeCode);
                }
            }

            return guid;
        }

        private static bool IsPresenceCheckItemsRequired(ContractRequest.contractRequestType contract)
        {
            return !contract.IsLevyContract();
        }

        /// <summary>
        /// This is usefull if we decide to cache the period guids
        /// </summary>
        private class PeriodInfo
        {
            public string Period { get; set; }

            public CorporateContract.periodTypeCodeType PeriodTypeCode { get; set; }

            public override bool Equals(object obj)
            {
                bool isEqual = false;
                PeriodInfo other = obj as PeriodInfo;
                if (other != null && Period != null)
                {
                    isEqual = Period.Equals(other.Period) && PeriodTypeCode == other.PeriodTypeCode;
                }

                return isEqual;
            }

            public override int GetHashCode()
            {
                if (Period != null)
                {
                    return Period.GetHashCode() ^ PeriodTypeCode.GetHashCode();
                }

                return PeriodTypeCode.GetHashCode();
            }
        }
    }
}