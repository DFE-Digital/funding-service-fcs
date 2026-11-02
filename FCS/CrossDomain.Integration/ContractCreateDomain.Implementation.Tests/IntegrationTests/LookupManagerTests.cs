namespace SFA.FCT.ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Contract.XrmAdapterService.Tests.Utils;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Entities;
    using Persistence;
    using Persistence.Entities;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using contractType = CrossDomain.Integration.Entities.ContractRequest.contractType;
    using CorporateContract = CrossDomain.Integration.Entities.CorporateContract;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass()]
    public class LookupManagerTests : IntegrationTestBase
    {

        [TestMethod, TestCategory("IntegrationTest")]
        public void LookupManager_AreMultipleOverlappingContractsAllowedForFundingType_ShouldReturnTrueForFundingTypeThatAllowsMultipleOverlappingContracts()
        {
            const string fundingType = "ESF";
            ILookupManager lookupManager = GetLookupManager();

            bool multipleOverlappingContractsAllowedForFundingType = lookupManager.AreMultipleOverlappingContractsAllowedForFundingType(fundingType);

            Assert.IsTrue(multipleOverlappingContractsAllowedForFundingType, "EOF funding type should return true");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LookupManager_AreMultipleOverlappingContractsAllowedForFundingType_ShouldReturnFalseForFundingTypeThatDisallowsMultipleOverlappingContracts()
        {
            const string fundingType = "MAIN";
            ILookupManager lookupManager = GetLookupManager();

            bool multipleOverlappingContractsAllowedForFundingType = lookupManager.AreMultipleOverlappingContractsAllowedForFundingType(fundingType);

            Assert.IsFalse(multipleOverlappingContractsAllowedForFundingType, "MAIN funding type should return false");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ShouldLookupFundingTypes()
        {
            const string fundingTypeAge = "AGE";
            const string fundingTypeEof = "EOF";
            var lookupManager = GetLookupManager();
            LookupCriteria lookupCiteria = new LookupCriteria();
            lookupCiteria.FundingTypes.Add(fundingTypeAge);
            lookupCiteria.FundingTypes.Add(fundingTypeEof);
            lookupManager.Lookup(lookupCiteria);
            Guid? guid = lookupManager.GetMatchingEntity(CrmLookupType.FundingType, fundingTypeAge);
            Assert.IsNotNull(guid, string.Format("Funding Type {0} not present", fundingTypeAge));
            guid = lookupManager.GetMatchingEntity(CrmLookupType.FundingType, fundingTypeEof);
            Assert.IsNotNull(guid, string.Format("Funding Type {0} not present", fundingTypeEof));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ShouldLookupFundingStream()
        {
            const string fundingStream1618 = "16-18 APPS";
            const string fundingStreamAsto = "ASTO";
            var lookupManager = GetLookupManager();
            LookupCriteria lookupCiteria = new LookupCriteria();
            lookupCiteria.FundingStreams.Add(fundingStream1618);
            lookupCiteria.FundingStreams.Add(fundingStreamAsto);
            lookupManager.Lookup(lookupCiteria);
            Guid? guid = lookupManager.GetMatchingEntity(CrmLookupType.FundingStreamCode, fundingStream1618);
            Assert.IsNotNull(guid, string.Format("Funding Stream Code {0} not present", fundingStream1618));
            guid = lookupManager.GetMatchingEntity(CrmLookupType.FundingStreamCode, fundingStreamAsto);
            Assert.IsNotNull(guid, string.Format("Funding Stream Code {0} not present", fundingStreamAsto));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LookupManager_Lookup_ShouldGetFundingStreamPeriodCodes()
        {
            // arrange
            const string fundingStreamPeriodCode = "LEVY1799";

            CorporateContract.contractAllocationsContractAllocation contractAllocation = new CorporateContract.contractAllocationsContractAllocation
            {
                period = new CorporateContract.period
                {
                    period1 = "1799",
                    periodType = new CorporateContract.periodTypeType
                    {
                        periodTypeCode = CorporateContract.periodTypeCodeType.LEVY
                    }
                },
                fundingStream = new CorporateContract.fundingStream
                {
                    fundingStreamCode = "LEVY"
                }
            };

            CrmCompositeKey compositeKey = CrmFieldMapper.GetFundingStreamPeriodPk(contractAllocation);

            var lookupManager = GetLookupManager();
            lookupManager.BatchId = Guid.NewGuid().ToString();
            LookupCriteria lookupCiteria = new LookupCriteria
            {
                FundingStreamPeriods = new HashSet<CrmCompositeKey> {compositeKey}
            };

            // act
            lookupManager.Lookup(lookupCiteria);
           
            Guid? guid = lookupManager.GetMatchingEntity(CrmLookupType.FundingStreamPeriodCode, compositeKey);

            // assert
            Assert.IsNotNull(guid, $"Funding Stream Period Code {fundingStreamPeriodCode} not present");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LookupManager_Lookup_ShouldGetPeriod()
        {
            // arrange
            const string fundingPeriod = "LEVY1799";

            CorporateContract.period period = new CorporateContract.period
            {
                period1 = "1799",
                periodType = new CorporateContract.periodTypeType
                {
                    periodTypeCode = CorporateContract.periodTypeCodeType.LEVY
                }
            };
               
            CrmCompositeKey compositeKey = CrmFieldMapper.GetPeriodPk(period);

            var lookupManager = GetLookupManager();
            lookupManager.BatchId = Guid.NewGuid().ToString();
            LookupCriteria lookupCiteria = new LookupCriteria
            {
                Periods = new HashSet<CrmCompositeKey> { compositeKey }
            };

            // act
            lookupManager.Lookup(lookupCiteria);

            Guid? guid = lookupManager.GetMatchingEntity(CrmLookupType.Period, compositeKey);

            // assert
            Assert.IsNotNull(guid, $"Funding Period Code {fundingPeriod} not present");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ShouldGetColumnValuesForEntity()
        {
            const string contractTypeColumnName = "sfa_name";
            var lookupManager = GetLookupManager();
            var columnValues = lookupManager.GetColumnValuesForEntity<string>(CrmLookupType.ContractType, contractTypeColumnName);
            Assert.IsTrue(columnValues.Count > 0);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LookupManager_ShouldGetLatestVersionForContract()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";
            const string masterContractRef = "SFA_MSTR3";
            const string firstChildContractRef = "MAIN_NEW3";

            // arrange
            DeleteContractsWithContractNumber(firstChildContractRef);
            DeleteContractsWithContractNumber(masterContractRef);
            CorporateContract.ExtendedContract masterContract = GetExtendedCorpContract();
            masterContract.contractNumber = masterContractRef;
            masterContract.contracts[0].contractNumber = firstChildContractRef;
            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;
            contractsManager.CreateContract(masterContract, correlationId);
            var lookupManager = GetLookupManager();

            // act
            int? latestContractNumber = lookupManager.GetLatestContractVersionNumberForContract(firstChildContractRef);
            
            // assert
            Assert.AreEqual(1, latestContractNumber);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LookupManager_AreAnyNonWithdrawnContractsWithContractNumber_ShouldReturnFalseIfNonWithdrawnContractsDoNotExist()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";
            const string masterContractRef = "SFA_MSTR8";
            const string firstChildContractRef = "MAIN_WD1";

            // arrange
            DeleteContractsWithContractNumber(firstChildContractRef);
            DeleteContractsWithContractNumber(masterContractRef);
            CorporateContract.ExtendedContract masterContract = GetExtendedCorpContract();
            masterContract.contractNumber = masterContractRef;
            masterContract.contracts[0].contractNumber = firstChildContractRef;
            masterContract.contracts[0].contractStatus = new CorporateContract.contractStatusType { status = "Withdrawn" };
            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;
            contractsManager.CreateContract(masterContract, correlationId);
            var lookupManager = GetLookupManager();
            UpdateStatusOnContract(firstChildContractRef, sfa_contractstatus.Withdrawn);

            // act
            bool nonWithdrawnContractsExist = lookupManager.AreAnyNonWithdrawnOrSupersededDraftContractsWithContractNumber(firstChildContractRef);

            // assert
            Assert.AreEqual(false, nonWithdrawnContractsExist);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LookupManager_AreAnyNonWithdrawnContractsWithContractNumber_ShouldReturnTrueIfNonWithdrawnContractsExist()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";
            const string masterContractRef = "SFA_MSTR9";
            const string firstChildContractRef = "MAIN_AP1";

            // arrange
            DeleteContractsWithContractNumber(firstChildContractRef);
            DeleteContractsWithContractNumber(masterContractRef);
            CorporateContract.ExtendedContract masterContract = GetExtendedCorpContract();
            masterContract.contractNumber = masterContractRef;
            masterContract.contracts[0].contractNumber = firstChildContractRef;
            masterContract.contracts[0].contractStatus = new CorporateContract.contractStatusType { status = "Approved" };
            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;
            contractsManager.CreateContract(masterContract, correlationId);
            var lookupManager = GetLookupManager();
            UpdateStatusOnContract(firstChildContractRef, sfa_contractstatus.Approved);

            // act
            bool nonWithdrawnContractsExist = lookupManager.AreAnyNonWithdrawnOrSupersededDraftContractsWithContractNumber(firstChildContractRef);

            // assert
            Assert.AreEqual(true, nonWithdrawnContractsExist);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LookupManager_ShouldReturnNullForLatestVersionOfContractWhenTheContractDoesNotExist()
        {
            const string firstChildContractRef = "XYXY";

            // arrange
          
            var lookupManager = GetLookupManager();

            // act
            int? latestContractNumber = lookupManager.GetLatestContractVersionNumberForContract(firstChildContractRef);

            // assert
            Assert.AreEqual(null, latestContractNumber);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LookupManager_ShouldReturnTrue_When_IsContractNumberWithMatchingUkprnPeriodAndFundingTypePresentInCrm_isCalledWhenContractPresent()
        {
            const string masterContractNumber = "SFA-3224";
            const string contractNumber = "MAIN-1712";
            const int ukprn = 12345678;
            const string batchId = "XX";
            const string correlationId = "ZZZ";
            const string status = "Active";

            // arrange
            DeleteContractsWithContractNumber(contractNumber);
            DeleteContractsWithContractNumber(masterContractNumber);
            CorporateContract.ExtendedContract masterContract = GetExtendedCorpContract();
            masterContract.contractNumber = masterContractNumber;
            masterContract.contracts[0].contractNumber = contractNumber;
            masterContract.contracts[0].contractor.ukprn = ukprn;
            masterContract.contractor.ukprn = ukprn;
            masterContract.contracts[0].contractor.Status = status;
            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;
            contractsManager.CreateContract(masterContract, correlationId);
            CorporateContract.ExtendedContractType childContractType = masterContract.contracts.First();

            var lookupManager = GetLookupManager();
            Guid? fundingTypeId = lookupManager.GetFundingTypeId(masterContract.fundingType.fundingTypeCode);
            Guid? periodId = lookupManager.GetPeriodId(childContractType.period.period1, childContractType.period.periodType.periodTypeCode);

            // act
            bool isContractPresent = lookupManager.IsContractNumberWithMatchingUkprnPeriodAndFundingTypePresentInCrm(contractNumber,
                masterContractNumber,
                ukprn,
                periodId.Value,
                fundingTypeId.Value);
            // assert
            Assert.AreEqual(true, isContractPresent);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LookupManager_ShouldReturnFalse_When_IsContractNumberWithMatchingUkprnPeriodAndFundingTypePresentInCrm_isCalledWhenContractNotPresent()
        {
            const string masterContractNumber = "SFA-3224";
            const string contractNumber = "MAIN-1712";
            const int ukprn = 12345678;
            const string batchId = "XX";

            // arrange
            DeleteContractsWithContractNumber(contractNumber);
            DeleteContractsWithContractNumber(masterContractNumber);
            CorporateContract.ExtendedContract masterContract = GetExtendedCorpContract();
            masterContract.contractNumber = masterContractNumber;
            masterContract.contracts[0].contractNumber = contractNumber;
            masterContract.contracts[0].contractor.ukprn = ukprn;
            masterContract.contractor.ukprn = ukprn;
            var contractsManager = CreateContractsManager();
            contractsManager.BatchId = batchId;          
            CorporateContract.ExtendedContractType childContractType = masterContract.contracts.First();

            var lookupManager = GetLookupManager();
            Guid? fundingTypeId = lookupManager.GetFundingTypeId(masterContract.fundingType.fundingTypeCode);
            Guid? periodId = lookupManager.GetPeriodId(childContractType.period.period1, childContractType.period.periodType.periodTypeCode);

            // act
            bool isContractPresent = lookupManager.IsContractNumberWithMatchingUkprnPeriodAndFundingTypePresentInCrm(contractNumber,
                masterContractNumber,
                ukprn,
                periodId.Value,
                fundingTypeId.Value);

            // assert
            Assert.AreEqual(false, isContractPresent);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void ShouldChLookupManager_ShouldGetLatestVersionForContractDataDependent()
        {
            // arrange
            var lookupManager = GetLookupManager();

            // act
            int? latestContractNumber = lookupManager.GetLatestContractVersionNumberForContract("ESIF-641");

            // assert
            Assert.AreEqual(2, latestContractNumber);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void ShouldCheckForPresenceOfSingleItem()
        {
            /**
             * This test relies on specific data in CRM so may not always pass
             */
            var lookupManager = GetLookupManager();
            List<PresenceCheckItem> presenceCheckItems = new List<PresenceCheckItem>();
            List<ColumnValue> columnValues = new List<ColumnValue>();
            ColumnValue ukprnColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.Ukprn,
                Value = "10000544"
            };
            const CrmOptionSetType contractHierarchyType = CrmOptionSetType.HierarchyType;

            ColumnValue contractHierarchyTypeColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.HierarchyType,
                Value = lookupManager.GetOptionsetValue(contractHierarchyType.GetOptionSetName(), contractHierarchyType.GetOptionValue(CorporateContract.hierarchyType.CONTRACT.ToString()))
            };
            ColumnValue periodColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.PeriodId,
                Value = lookupManager.GetPeriodId("1516", CorporateContract.periodTypeCodeType.AY)
            };
            columnValues.Add(ukprnColumnValue);
            columnValues.Add(contractHierarchyTypeColumnValue);
            columnValues.Add(periodColumnValue);

            PresenceCheckItem contractPresenceCheckItem = new PresenceCheckItem(CrmEntityName.Contract, columnValues);
            presenceCheckItems.Add(contractPresenceCheckItem);

            // now get the status primary keys that we will use when we lookup a draft
            IList<Guid> statusPrimaryKeys = GetStatusPrimaryKeys(ContractValidationLookupDataCreator.ContractStatusesForDraft);
            Assert.IsTrue(statusPrimaryKeys.Count > 0, "The statuses in CRM do not contain these - " + string.Join(", ", ContractValidationLookupDataCreator.ContractStatusesForDraft));
            statusPrimaryKeys.ToList().ForEach(statusPk =>
            {
                ColumnValue subStatusColumnValue = new ColumnValue
                {
                    Column = CrmContractFieldName.SubStatus,
                    Value = statusPk
                };
                contractPresenceCheckItem.ColumnValuesOneOfThese.Add(subStatusColumnValue);
            });

            lookupManager.CheckForPresence(presenceCheckItems);
            Assert.IsTrue(contractPresenceCheckItem.IsPresent);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void ShouldCheckForPresenceOfMultipleItems()
        {
            /**
             * This test relies on specific data in CRM so may need always pass
             */
            const string contractStatusOptionSet = "sfa_contractstatus";
            var lookupManager = GetLookupManager();
            List<PresenceCheckItem> presenceCheckItems = new List<PresenceCheckItem>();
            List<ColumnValue> draftColumnValues = new List<ColumnValue>();
            ColumnValue ukprnColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.Ukprn,
                Value = "10000671" //10000671
            };
            const CrmOptionSetType contractHierarchyType = CrmOptionSetType.HierarchyType;

            ColumnValue contractHierarchyTypeColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.HierarchyType,
                Value = lookupManager.GetOptionsetValue(contractHierarchyType.GetOptionSetName(), contractHierarchyType.GetOptionValue(CorporateContract.hierarchyType.CONTRACT.ToString()))
            };
            ColumnValue periodColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.PeriodId,
                Value = lookupManager.GetPeriodId("1516", CorporateContract.periodTypeCodeType.AY)
            };


            ColumnValue ukprnNotPresentColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.Ukprn,
                Value = "10000671"
            };

            ColumnValue draftStatusColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.ContractStatus,
                Value = lookupManager.GetOptionsetValue(contractStatusOptionSet, "Draft")
            };

            ColumnValue approvedStatusColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.ContractStatus,
                Value = lookupManager.GetOptionsetValue(contractStatusOptionSet, "Approved")
            };

            ColumnValue withdrawnStatusColumnValue = new ColumnValue
            {
                Column = CrmContractFieldName.ContractStatus,
                Value = lookupManager.GetOptionsetValue(contractStatusOptionSet, "Withdrawn")
            };

            var contract = new contractType();
            draftColumnValues.Add(ukprnColumnValue);
            draftColumnValues.Add(contractHierarchyTypeColumnValue);
            draftColumnValues.Add(periodColumnValue);
            draftColumnValues.Add(draftStatusColumnValue);

            List<ColumnValue> approvedContractPresentColumnValues = new List<ColumnValue>();
            approvedContractPresentColumnValues.Add(ukprnNotPresentColumnValue);
            approvedContractPresentColumnValues.Add(contractHierarchyTypeColumnValue);
            approvedContractPresentColumnValues.Add(periodColumnValue);
            approvedContractPresentColumnValues.Add(approvedStatusColumnValue);

            List<ColumnValue> withdrawnContractPresentColumnValues = new List<ColumnValue>();
            withdrawnContractPresentColumnValues.Add(ukprnNotPresentColumnValue);
            withdrawnContractPresentColumnValues.Add(contractHierarchyTypeColumnValue);
            withdrawnContractPresentColumnValues.Add(periodColumnValue);
            withdrawnContractPresentColumnValues.Add(withdrawnStatusColumnValue);

            PresenceCheckItem draftContractPresenceCheckItem = new PresenceCheckItem(CrmEntityName.Contract, draftColumnValues);
            draftContractPresenceCheckItem.SetPresent =
                present => contract.IsDraftContractWithContractNumberPresentInCrm = present;

            PresenceCheckItem approvedContractPresenceCheckItem = new PresenceCheckItem(CrmEntityName.Contract, approvedContractPresentColumnValues);
            approvedContractPresenceCheckItem.SetPresent =
               present => contract.IsApprovedContractWithContractNumberPresentInCrm = present;

            PresenceCheckItem withdrawnContractPresenceCheckItem = new PresenceCheckItem(CrmEntityName.Contract, withdrawnContractPresentColumnValues);
            withdrawnContractPresenceCheckItem.SetPresent =
               present => contract.IsWithdrawnContractWithContractNumberPresentInCrm = present;

            presenceCheckItems.Add(draftContractPresenceCheckItem);
            presenceCheckItems.Add(approvedContractPresenceCheckItem);
            presenceCheckItems.Add(withdrawnContractPresenceCheckItem);


            lookupManager.CheckForPresence(presenceCheckItems);
            Assert.IsTrue(contract.IsDraftContractWithContractNumberPresentInCrm, "contract.IsDraftContractWithContractNumberPresentInCrm");
            Assert.IsTrue(contract.IsApprovedContractWithContractNumberPresentInCrm, "contract.IsApprovedContractWithContractNumberPresentInCrm.IsPresent");
            //Assert.IsTrue(contract.IsWithdrawnContractWithContractNumberPresentInCrm, "contract.IsWithdrawnContractWithContractNumberPresentInCrm.IsPresent");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ShouldGetPeriodIdForPeriodAndPeriodType()
        {
            var lookupManager = GetLookupManager();
            Guid? guidOfPeriod = lookupManager.GetPeriodId("1516", CorporateContract.periodTypeCodeType.AY);
            Assert.IsTrue(guidOfPeriod.HasValue);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ShouldGetUnitOfProcurement()
        {
            const string UopWm = "UWM";
            var lookupManager = GetLookupManager();
            LookupCriteria lookupCiteria = new LookupCriteria();
            lookupCiteria.UnitsOfProcurement.Add(UopWm);
            lookupManager.Lookup(lookupCiteria);

            Guid? guid = lookupManager.GetMatchingEntity(CrmLookupType.UnitOfProcurement, UopWm);
            Assert.IsNotNull(guid, string.Format("Unit Of Procurement {0} not present", UopWm));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ShouldGetLEPs()
        {
            const string lepCode = "E37001";
            var lookupManager = GetLookupManager();
            LookupCriteria lookupCiteria = new LookupCriteria();
            lookupCiteria.LEP.Add(lepCode);
            lookupManager.Lookup(lookupCiteria);
            Guid? guid = lookupManager.GetMatchingEntity(CrmLookupType.LocalEnterprisePartnership, lepCode);
            Assert.IsNotNull(guid, string.Format("LocalEnterprisePartnership {0} not present", lepCode));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void LookupManager_GetUnitOfProcurementReferenceData_ShouldGetUnitOfProcurementReferenceData()
        {
            // arrange
            ILookupManager lookupManager = GetLookupManager();

            // act
            IEnumerable<UnitOfProcurement> uopReferenceData = lookupManager.GetUnitOfProcurementReferenceData();

            // assert
            Assert.IsNotNull(uopReferenceData, "Returned reference data was null.");
            Assert.IsTrue(uopReferenceData.Any(), "Returned reference data was empty.");
            Assert.IsNotNull(uopReferenceData.SingleOrDefault(uop => uop.Code == "UEE" && uop.Procurement == "OLASS" && uop.FundingStreamPeriodCode == "OLASS1516"), "Specific UOP data was not present.");
            Assert.IsNotNull(uopReferenceData.SingleOrDefault(uop => uop.Code == "UEE" && uop.Procurement == "OLASS" && uop.FundingStreamPeriodCode == "OLASS1617"), "Specific UOP data was not present.");
            Assert.IsNotNull(uopReferenceData.SingleOrDefault(uop => uop.Code == "0000000001" && uop.Procurement == "NCS" && uop.FundingStreamPeriodCode == "NCS-I1718"), "Specific UOP data was not present.");
            Assert.IsNotNull(uopReferenceData.SingleOrDefault(uop => uop.Code == "0000000001" && uop.Procurement == "NCS" && uop.FundingStreamPeriodCode == "NCS-P1718"), "Specific UOP data was not present.");
        }

        [TestMethod, TestCategory("DataDependent")]
        public void ShouldCheckContractCorrelationId()
        {
            const string correlationId = "bfe001da"; //requires a valid record with specific correlationId
            var lookupManager = GetLookupManager();
            var exists = lookupManager.CheckContractExists(correlationId);
            Assert.IsTrue(exists, string.Format("Contract Exists {0}", correlationId));
        }

        [TestMethod, TestCategory("DataDependent")]
        public void ShouldGetApprovedDateForContract()
        {
            var lookupManager = GetLookupManager();
            const string contractNumber = "MAIN-2522";
            int version = 1;
            DateTime? result = lookupManager.GetApprovedDateForContract(contractNumber, version);

            Assert.IsNotNull(result);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void ShouldGetPaymentScheduleDeliverablePaymentsValues()
        {
            var lookupManager = GetLookupManager();
            const string allocationNumber = "AGE-201";
            int version = 1;
            string deliverableCode = "1";
            string period = "201504";
            DeliverablePeriodsValueData result = lookupManager.GetPaymentScheduleDeliverablePaymentsValues(allocationNumber, version, deliverableCode, period);

            Assert.IsNotNull(result);
        }

        [TestMethod, TestCategory("DataDependent")]
        public void ShouldGetDraftContractsFromCrm()
        {
            const int draftStatus = 229660000;
            var columnValues = new List<ColumnValueCriteria>()
            {
                new ColumnValueCriteria(CrmContractFieldName.ContractStatus, ConditionOperator.Equal, draftStatus)

            };
            CrmLookupCriteria lookupCriteria = new CrmLookupCriteria() { EntityName = CrmEntityName.Contract, LookupCriteria = columnValues };

            Dictionary<string, ContractInfo> contractInfos = new Dictionary<string, ContractInfo>();
            IList<Entity> draftContracts = CrmManager.GetCrmEntities(lookupCriteria);

            // we now need to do a group by to find contract numbers with multiple drafts
            foreach (var draftContractEntity in draftContracts)
            {
                string contractNumber = draftContractEntity.GetAttributeValue<string>(CrmContractFieldName.Number);
                if (!contractInfos.ContainsKey(contractNumber))
                {
                    contractInfos[contractNumber] = new ContractInfo(contractNumber);
                }

                contractInfos[contractNumber].NumDraft++;
            }

            IList<ContractInfo> contractsWithMoreThanOneDraft = contractInfos.Values.Where(v => v.NumDraft > 1).ToList();

            int count = contractsWithMoreThanOneDraft.Count();

            Assert.IsTrue(count > 0);

        }

        private IList<Guid> GetStatusPrimaryKeys(IEnumerable<string> statues)
        {
            const string pkColumnName = "sfa_statusid";
            IList<Guid> primaryKeys = GetLookupManager()
                .GetPkColumnValuesForEntity(CrmLookupType.SubStatus, pkColumnName, statues);

            return primaryKeys;
        }

        private static IContractsManager CreateContractsManager()
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            return new ContractsManager
            {
                LookupManager = new LookupManager
                {
                    BatchCacheManager = new BatchCacheManager(),
                    EnduringCacheManager = new EnduringCacheManager(),
                    OrganizationService = organizationService
                },
                OrganizationService = organizationService,
                XrmOrganisationManager = new XrmOrganisationManager
                {
                    OrgService = organizationService
                },
                XrmWorkflowManager = new XrmWorkflowManager
                {
                    OrganizationService = organizationService
                }
            };
        }

        private ILookupManager GetLookupManager()
        {
            return new LookupManager
            {
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager(),
                OrganizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService()
            };
        }

        private class ContractInfo
        {
            public ContractInfo(string contractNumber)
            {
                ContractNumber = contractNumber;
            }

            public string ContractNumber { get; }

            public int NumDraft { get; set; }
        }
    }
}