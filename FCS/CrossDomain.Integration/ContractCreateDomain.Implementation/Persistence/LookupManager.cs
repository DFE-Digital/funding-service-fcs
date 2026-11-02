namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Metadata;
    using Microsoft.Xrm.Sdk.Query;
    using CrossDomain.Integration.Entities.ContractRequest;
    using Implementation.Entities;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Entities;
    using MoreLinq;
    using CorporateContract = CrossDomain.Integration.Entities.CorporateContract;
    using sfa_fundingtype = CrossDomain.Integration.Entities.Xrm.sfa_fundingtype;

    public class LookupManager : ILookupManager
    {
        private readonly IDictionary<CrmLookupType, EntityCollection> _matchingEntities = new Dictionary<CrmLookupType, EntityCollection>();

        public string BatchId { get; set; }

        public IOrganizationService OrganizationService { get; set; }

        public IBatchCacheManager BatchCacheManager { get; set; }

        public IEnduringCacheManager EnduringCacheManager { get; set; }

        public void Lookup(LookupCriteria lookupCriteria)
        {
            _matchingEntities[CrmLookupType.FundingType] = GetMatchingEntitiesFromEnduringCache(CrmLookupType.FundingType);
            _matchingEntities[CrmLookupType.ContractType] = GetMatchingEntitiesFromEnduringCache(CrmLookupType.ContractType);

            // the entity for organisation is called account
            _matchingEntities[CrmLookupType.Organisation] = GetMatchingEntitiesForValues(CrmLookupType.Organisation, lookupCriteria.UkPrns);
            _matchingEntities[CrmLookupType.SubStatus] = GetMatchingEntitiesFromEnduringCache(CrmLookupType.SubStatus);
            _matchingEntities[CrmLookupType.Period] = GetMatchingEntitiesForPeriodFromEnduringCache(CrmLookupType.Period);
            _matchingEntities[CrmLookupType.FundingStreamCode] = GetMatchingEntitiesFromEnduringCache(CrmLookupType.FundingStreamCode);
            _matchingEntities[CrmLookupType.FundingStreamPeriodCode] = GetMatchingEntitiesForFundingStreamPeriodFromEnduringCache(CrmLookupType.FundingStreamPeriodCode);
            _matchingEntities[CrmLookupType.PeriodType] = GetMatchingEntitiesFromEnduringCache(CrmLookupType.PeriodType);
            _matchingEntities[CrmLookupType.UnitOfProcurement] = GetMatchingEntitiesFromEnduringCache(CrmLookupType.UnitOfProcurement);
            _matchingEntities[CrmLookupType.LocalEnterprisePartnership] = GetMatchingEntitiesForValues(CrmLookupType.LocalEnterprisePartnership, lookupCriteria.LEP);
        }

        public List<T> GetColumnValuesForEntity<T>(CrmLookupType lookupType, string columnName)
        {
            List<T> columnValues = new List<T>();
            EntityCollection entityCollection = GetMatchingEntities(lookupType, null);
            entityCollection.Entities.ForEach(entity => columnValues.Add(entity.GetAttributeValue<T>(columnName)));

            return columnValues;
        }

        public List<T> GetColumnValuesForEntity<T>(CrmLookupType lookupType, string columnName, string filterColumnName, IEnumerable<string> columnFilterValues)
        {
            List<T> columnValues = new List<T>();
            CrmLookupEntityDetail entityDetail = lookupType.GetEntityDetail();

            QueryExpression query = CreateQueryExpression(entityDetail.EntityName, filterColumnName, columnFilterValues);
            EntityCollection entityCollection = ExecuteQuery(query);

            entityCollection.Entities.ForEach(entity => columnValues.Add(entity.GetAttributeValue<T>(columnName)));
            return columnValues;
        }

        public IList<Guid> GetPkColumnValuesForEntity(CrmLookupType lookupType, string columnName, IEnumerable<string> columnFilterValues)
        {
            return EnduringCacheManager.GetPkColumnValuesForEntity(
                new LookupWithColumnFilterKey(lookupType, columnName, columnFilterValues),
                key =>
                {
                    List<Guid> columnValues = new List<Guid>();
                    CrmLookupEntityDetail entityDetail = lookupType.GetEntityDetail();

                    QueryExpression query = CreateQueryExpression(entityDetail.EntityName, entityDetail.LookupColumn, columnFilterValues);
                    EntityCollection entityCollection = ExecuteQuery(query);

                    entityCollection.Entities.ForEach(
                        entity => columnValues.Add(entity.GetAttributeValue<Guid>(columnName)));
                    return columnValues;
                });
        }

        public void CheckForPresence(IEnumerable<PresenceCheckItem> presenceCheckItems)
        {
            // the presenceCheckItems contains a list, where we have the same entity in the list with the same number of cols we only 
            // want to do one query
            var presenceCheckGroups = presenceCheckItems.GroupBy(p =>
                new
                {
                    p.EntityName,
                    NumCols = p.ColumnValues.Count(),
                    NumInCols = p.ColumnValuesOneOfThese
                });

            foreach (var presenceCheckGroup in presenceCheckGroups)
            {
                IDictionary<string, HashSet<object>> columnWithValues = AggregatePresenceCheckItems(presenceCheckGroup);
                EntityCollection entityCollection = GetMatchingEntities(presenceCheckGroup.Key.EntityName, columnWithValues);
                if (entityCollection != null)
                {
                    CheckForPresenceInEntityCollection(entityCollection, presenceCheckGroup);
                }
            }
        }

        public Guid? GetMatchingEntity(CrmLookupType lookupType, string value)
        {
            Guid? id = null;
            if (!string.IsNullOrEmpty(value) && _matchingEntities.ContainsKey(lookupType))
            {
                EntityCollection matchedEntities = _matchingEntities[lookupType];
                var lookupColumn = lookupType.GetEntityDetail().LookupColumn;
                Entity foundEntity = matchedEntities.Entities.FirstOrDefault(e => e.Attributes.Count(a => a.Key == lookupColumn && value.Equals(a.Value as string)) > 0);
                if (foundEntity != null)
                {
                    id = foundEntity.Id;
                }
            }

            return id;
        }

        public Guid? GetMatchingEntity(CrmLookupType lookupType, CrmCompositeKey compositeKey)
        {
            Guid? id = null;
            if (compositeKey.KeyFields.Count > 0 && _matchingEntities.ContainsKey(lookupType))
            {
                EntityCollection matchedEntities = _matchingEntities[lookupType];
                Entity foundEntity = GetMatchingEntity(compositeKey.KeyFields, matchedEntities);
                if (foundEntity != null)
                {
                    id = foundEntity.Id;
                }
            }

            return id;
        }

        public int? GetOptionsetValue(string optionsetName, string label)
        {
            return EnduringCacheManager.GetOptionSetValue(
                new OptionSetKey(optionsetName, label),
                delegate (OptionSetKey key)
                {
                    int? optionsetValue = null;
                    RetrieveOptionSetRequest retrieveOptionSetRequest =
                        new RetrieveOptionSetRequest
                        {
                            Name = key.OptionSetName
                        };

                    // Execute the request.
                    RetrieveOptionSetResponse retrieveOptionSetResponse =
                        (RetrieveOptionSetResponse)OrganizationService.Execute(retrieveOptionSetRequest);

                    // Access the retrieved OptionSetMetadata.
                    OptionSetMetadata retrievedOptionSetMetadata =
                        (OptionSetMetadata)retrieveOptionSetResponse.OptionSetMetadata;

                    // Get the current options list for the retrieved attribute.
                    OptionMetadata[] optionList = retrievedOptionSetMetadata.Options.ToArray();
                    foreach (OptionMetadata optionMetadata in optionList)
                    {
                        if (optionMetadata.Label.LocalizedLabels.First().Label == key.OptionSetText)
                        {
                            optionsetValue = optionMetadata.Value;
                            break;
                        }
                    }

                    return optionsetValue;
                });
        }

        public EntityCollection GetMatchingEntitiesForPeriod(CrmLookupType lookupType, HashSet<CrmCompositeKey> compositeKeys)
        {
            return BatchCacheManager.GetEntities(
                BatchId,
                lookupType,
                compositeKeys,
                () =>
                {
                    CrmLookupEntityDetail entityDetail = lookupType.GetEntityDetail();
                    EntityCollection entityCollection = new EntityCollection();
                    foreach (var compositeKey in compositeKeys)
                    {
                        QueryExpression query = CreateQueryExpressionForPeriod(entityDetail.EntityName, entityDetail.LookupColumns, compositeKey.KeyFields);
                        entityCollection.Entities.AddRange(ExecuteQuery(query).Entities);
                    }

                    return entityCollection;
                });
        }

        public Guid? GetPeriodId(string periodString, CorporateContract.periodTypeCodeType periodTypeCode)
        {
            return EnduringCacheManager.GetPeriodId(
                new PeriodKey(periodString, periodTypeCode),
                key =>
                {
                    CorporateContract.period period = new CorporateContract.period
                    {
                        period1 = periodString,
                        periodType = new CorporateContract.periodTypeType
                        {
                            periodTypeCode = periodTypeCode
                        }
                    };

                    HashSet<CrmCompositeKey> periodKey = new HashSet<CrmCompositeKey>();

                    periodKey.Add(CrmFieldMapper.GetPeriodPk(period));

                    EntityCollection matchedEntities = GetMatchingEntitiesForPeriod(CrmLookupType.Period, periodKey);
                    if (matchedEntities.Entities.Count != 1)
                    {
                        throw new Exception(string.Format("The are not Periods in CRM for period {0} and periodType {1}", periodString, periodTypeCode));
                    }

                    return matchedEntities.Entities.First().Id;
                });
        }

        public Guid? GetFundingTypeId(string fundingTypeString)
        {
            IList<string> fundingTypeList = new List<string>();
            fundingTypeList.Add(fundingTypeString);
            EntityCollection matchedEntities = GetMatchingEntitiesForValues(CrmLookupType.FundingType, fundingTypeList);
            if (matchedEntities.Entities.Count != 1)
            {
                throw new Exception(string.Format("Funding Type Code {0} does not exist in CRM.", fundingTypeString));
            }

            return matchedEntities.Entities.First().Id;
        }

        public bool CheckContractExists(string correlationId)
        {
            bool contractExists = false;

            if (!string.IsNullOrWhiteSpace(correlationId))
            {
                var currentContract = GetMatchingXrmContracts(correlationId);

                if (currentContract.Any())
                {
                    contractExists = true;
                }
            }

            return contractExists;
        }

        public DeliverablePeriodsValueData GetPaymentScheduleDeliverablePaymentsValues(string allocationNumber, int version, string deliverableCode, string period)
        {
            DeliverablePeriodsValueData deliverablePeriodsValueData = new DeliverablePeriodsValueData();
            EntityCollection entityCollection = GetPaymentScheduleDeliverablePayments(allocationNumber, version,
                deliverableCode, period);
            if (entityCollection != null && entityCollection.Entities.Count > 0)
            {
                var entity = entityCollection.Entities.Single();

                deliverablePeriodsValueData = new DeliverablePeriodsValueData()
                {
                    ActualValue = GetDecimalColumnValue(entity, "p.sfa_actualvalue") ?? 0,
                    PlannedValue = GetDecimalColumnValue(entity, "p.sfa_plannedvalue") ?? 0,
                    BalancingPaymentValue = GetDecimalColumnValue(entity, "p.sfa_balancingpaymentamount"),
                    ReconciliationPaymentValue = GetDecimalColumnValue(entity, "p.sfa_reconciliationpaymentamount"),
                    CappingPaymentValue = GetDecimalColumnValue(entity, "p.sfa_cappedpaymentamount"),
                    NetPaymentValue = GetDecimalColumnValue(entity, "p.sfa_netpaymentamount"),
                    ProfilePaymentValue = GetDecimalColumnValue(entity, "p.sfa_profilepaymentamount")
                };
            }

            return deliverablePeriodsValueData;
        }

        public IEnumerable<DeliverablePeriodsValueData> GetPaymentScheduleDeliverablePaymentsValueList(string allocationNumber, int version, string deliverableCode, string period)
        {
            List<DeliverablePeriodsValueData> deliverablePeriodsValueDataList = new List<DeliverablePeriodsValueData>();
            EntityCollection entityCollection = GetPaymentScheduleDeliverablePayments(allocationNumber, version, deliverableCode, period);
            if (entityCollection != null)
            {
                foreach (var entity in entityCollection.Entities)
                {
                    DeliverablePeriodsValueData deliverablePeriodsValueData = new DeliverablePeriodsValueData()
                    {
                        ActualValue = GetNullableColumnValue<decimal>(entity, "p.sfa_actualvalue") ?? 0,
                        PlannedValue = GetNullableColumnValue<decimal>(entity, "p.sfa_plannedvalue") ?? 0,
                        BalancingPaymentValue = GetNullableColumnValue<decimal>(entity, "p.sfa_balancingpaymentamount"),
                        ReconciliationPaymentValue = GetNullableColumnValue<decimal>(entity, "p.sfa_reconciliationpaymentamount"),
                        CappingPaymentValue = GetNullableColumnValue<decimal>(entity, "p.sfa_cappedpaymentamount"),
                        NetPaymentValue = GetNullableColumnValue<decimal>(entity, "p.sfa_netpaymentamount"),
                        ProfilePaymentValue = GetNullableColumnValue<decimal>(entity, "p.sfa_profilepaymentamount"),
                        EntityId = GetNullableColumnValue<Guid>(entity, "p.sfa_contractdeliverableperiodid").Value,
                        ModifiedOn = GetDateTimeColumnValue(entity, "modifiedon")
                    };

                    deliverablePeriodsValueDataList.Add(deliverablePeriodsValueData);
                }
            }

            return deliverablePeriodsValueDataList;
        }

        public void PopulateDeliverablePaymentsDictionary(
            ConcurrentDictionary<string, IList<DeliverablePeriodsValueData>> deliverablePeriodDictionary,
            string allocationNumber, int version)
        {
            IList<DeliverablePeriodsValueData> deliverablePeriodsValues = GetAllDeliverablePeriods(allocationNumber, version);

            foreach (var deliverablePeriodsValueData in deliverablePeriodsValues)
            {
                deliverablePeriodDictionary.AddOrUpdate(deliverablePeriodsValueData.Key,
                    new List<DeliverablePeriodsValueData> { deliverablePeriodsValueData },
                    (s, list) =>
                    {
                        list.Add(deliverablePeriodsValueData);
                        return list;
                    });
            }

        }

        private decimal? GetDecimalColumnValue(Entity entity, string columnName)
        {
            return entity.Contains(columnName)
                ? (decimal?)((AliasedValue)(entity.Attributes[columnName])).Value
                : null;
        }

        private T? GetNullableColumnValue<T>(Entity entity, string columnName) where T : struct
        {
            return entity.Contains(columnName)
                ? (T?)((AliasedValue)(entity.Attributes[columnName])).Value
                : null;
        }

        private DateTime? GetDateTimeColumnValue(Entity entity, string columnName)
        {
            return entity.Contains(columnName)
                ? ((DateTime?)(entity.Attributes[columnName]))
                : null;
        }

        private T GetColumnValue<T>(Entity entity, string columnName)
        {
            return (T)(entity.Attributes[columnName]);
        }

        public AllocationValueData GetAllocationDateValues(string allocationNumber, int version)
        {
            var allocation = new AllocationValueData();
            EntityCollection entityCollection = GetAllocationDates(allocationNumber, version);
            if (entityCollection != null && entityCollection.Entities.Count > 0)
            {
                var entity = entityCollection.Entities.Single();

                allocation.StartDate = entity.Contains("sfa_startdate") ? (DateTime?)(entity.Attributes["sfa_startdate"]) : null;
                allocation.EndDate = entity.Contains("sfa_enddate") ? (DateTime?)(entity.Attributes["sfa_enddate"]) : null;
                
            }
            return allocation;
        }

        public DateTime? GetApprovedDateForContract(string contractNumber, int version)
        {
            EntityCollection entityCollection = GetContractApprovedDate(contractNumber, version);
            var entity = entityCollection.Entities.FirstOrDefault();
            if (entity != null)
            {
                AliasedValue aliasedValue = entity.Attributes["CH.createdon"] as AliasedValue;
                if (aliasedValue != null)
                {
                    return (DateTime)aliasedValue.Value;
                }
            }
           
            return null;
        }

        public IReadOnlyCollection<MatchingTenderAwardReferenceItem> GetMatchingTenderAwardRefsForAllocation(IList<string> importedTenderAwardRefs)
        {
            QueryExpression queryExpression = CreateQueryExpressionForMatchingTenderAwardReferenceItems(importedTenderAwardRefs);
            EntityCollection duplicateTenderAwardRefs = ExecuteQuery(queryExpression);
            List<MatchingTenderAwardReferenceItem> matchingTenderAwardRefs = new List<MatchingTenderAwardReferenceItem>();

            if (duplicateTenderAwardRefs != null)
            {
                matchingTenderAwardRefs =
                    duplicateTenderAwardRefs.Entities
                    .Select(e => new MatchingTenderAwardReferenceItem(
                        contractNumber: (string)e.GetAttributeValue<AliasedValue>("c.sfa_number").Value,
                        allocationNumber: e.GetAttributeValue<string>("sfa_contractallocationnumber"),
                        tenderAwardReference: e.GetAttributeValue<string>("sfa_awardreference")))
                    .ToList();
            }

            return matchingTenderAwardRefs.AsReadOnly();
        }

        public bool AreMultipleOverlappingContractsAllowedForFundingType(string fundingTypeCode)
        {
            return
                GetMatchingEntitiesForValues(CrmLookupType.FundingType, new[] {fundingTypeCode})
                .Entities
                .Single()
                .GetAttributeValue<bool>("sfa_allowmultiplecontracts");
        }

        public IEnumerable<AllocationValueData> GetAllocationsForApprovedContract(string contractNumber)
        {
            EntityCollection entityCollection = GetDeliverablesForApprovedContract(contractNumber);

            // we now transform this to a list of AllocationValueData
            var allocations = entityCollection.Entities.GroupBy(e => new
            {
                Number = e.GetAttributeValue<AliasedValue>("a.sfa_contractallocationnumber").Value,
                MaxAliasedValue = e.GetAttributeValue<AliasedValue>("a.sfa_maximumcontractvalue").Value
            })
            .Select(y => new AllocationValueData()
            {
                ContractAllocationNumber = y.Key.Number.ToString(),
                MaximumContractValue = (decimal)y.Key.MaxAliasedValue,
                DeliverableCodes = y.Select(d => int.Parse((string)d.GetAttributeValue<AliasedValue>("d.sfa_deliverablecode").Value)).ToList()
            });

            return allocations.ToList();
        }

        public EntityCollection GetDeliverablesForApprovedContract(string contractNumber)
        {
            const string approvedStatus = "Approved";

            // first get the option set id for the status
            int? approvedStatusId = GetOptionsetValue(CrmOptionSetType.Status.GetOptionSetName(), approvedStatus);

            if (approvedStatusId.HasValue)
            {
                QueryExpression queryExpression = CreateQueryExpressionForAllocationsAndTheirDeliverables(
                    contractNumber,
                    approvedStatusId.Value);
                return ExecuteQuery(queryExpression);
            }

            return new EntityCollection();
        }

        public EntityCollection GetContractApprovedDate(string contractNumber, int version)
        {
            QueryExpression queryExpression = CreateQueryExpressionForContractHistory(contractNumber, version);
            return ExecuteQuery(queryExpression);
        }

        public EntityCollection GetPaymentScheduleDeliverablePayments(string allocationNumber, int version, string deliverableCode, string period)
        {
            QueryExpression queryExpression = CreateQueryExpressionForPaymentScheduleDeliverablePayment(allocationNumber, version, deliverableCode, period);
            return ExecuteQuery(queryExpression);
        }

        public EntityCollection GetAllocationDates(string allocationNumber, int version)
        {
            QueryExpression queryExpression = CreateQueryExpressionForAllocations(allocationNumber, version);
            return ExecuteQuery(queryExpression);
        }

        public int? GetLatestContractVersionNumberForContract(string contractNumber)
        {
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                sfa_contract contract = xrmContext.sfa_contractSet.Where(c => c.sfa_number == contractNumber)
                    .OrderByDescending(c => c.sfa_Version)
                    .FirstOrDefault();

                return contract?.sfa_Version;
            }
        }

        public bool IsContractNumberWithMatchingUkprnPeriodAndFundingTypePresentInCrm(string contractNumber,
            string masterContractNumber,
            int ukprn,
            Guid periodId,
            Guid fundingTypeId)
        {
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                IQueryable<sfa_contract> matchingContracts = from c in xrmContext.sfa_contractSet
                    join m in xrmContext.sfa_contractSet on c.sfa_ParentContractId.Id equals m.sfa_contractId
                    where c.sfa_number == contractNumber
                    where c.sfa_UKPRN == ukprn.ToString()
                    where c.sfa_PeriodId.Equals(new EntityReference(sfa_period.EntityLogicalName, periodId))
                    where
                        c.sfa_FundingType.Equals(new EntityReference(sfa_fundingtype.EntityLogicalName, fundingTypeId))
                    where m.sfa_number == masterContractNumber
                                        select c;
               
                return matchingContracts.ToList().Any();
            }
        }

        public bool AreAnyNonWithdrawnOrSupersededDraftContractsWithContractNumber(string contractNumber)
        {
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                IReadOnlyCollection<sfa_contract> contracts = xrmContext.sfa_contractSet
                    .Where(
                        c => c.sfa_number == contractNumber &&
                        c.sfa_ContractStatus.Value != (int)sfa_contractstatus.Withdrawn &&
                        c.sfa_ContractStatus.Value != (int)sfa_contractstatus.SupersededDraft)
                    .ToList();

                return contracts.Any();
            }
        }

        public bool IsExistingLevyContractWithDraftOfApprovedStatusForUkprnPresentInCrm(int ukprn, Guid fundingType)
        {
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                IReadOnlyCollection<sfa_contract> contracts =
                    xrmContext.sfa_contractSet.Where(
                        c =>
                        c.sfa_UKPRN == ukprn.ToString()
                        && (c.sfa_ContractStatus.Value == (int)sfa_contractstatus.Draft
                            || c.sfa_ContractStatus.Value == (int)sfa_contractstatus.Approved)
                        && c.sfa_sfa_fundingtype_sfa_contract_FundingType.sfa_fundingtypeId == fundingType
                        && c.sfa_HierarchyType.Value == (int)sfa_contracthierarchytype.Contract)
                        .ToList();

                return contracts.Any();
            }
        }

        private void CheckForPresenceInEntityCollection(EntityCollection matchedEntities, IEnumerable<PresenceCheckItem> presenceCheckItemsForEntity)
        {
            foreach (var presenceCheckItem in presenceCheckItemsForEntity)
            {
                int numMatchedColumns = 0;
                foreach (var entity in matchedEntities.Entities)
                {
                    foreach (var columnValue in presenceCheckItem.ColumnValues)
                    {
                        object crmColumnValue = entity.Attributes[columnValue.Column];

                        // the value in CRM maybe an optionset, we need the Value this holds for our comparison
                        if (crmColumnValue is OptionSetValue)
                        {
                            crmColumnValue = ((OptionSetValue)crmColumnValue).Value;
                        }
                        else if (crmColumnValue is EntityReference)
                        {
                            crmColumnValue = ((EntityReference)crmColumnValue).Id;
                        }

                        if (!crmColumnValue.Equals(columnValue.Value))
                        {
                            break;
                        }
                        else
                        {
                            numMatchedColumns++;
                        }
                    }

                    // if we have not found the entity or we have matched all the columns
                    if (numMatchedColumns == presenceCheckItem.ColumnValues.Count)
                    {
                        break;
                    }
                    else
                    {
                        // reset and try the next row
                        numMatchedColumns = 0;
                    }
                }

                presenceCheckItem.IsPresent = numMatchedColumns == presenceCheckItem.ColumnValues.Count;
            }
        }

        private IDictionary<string, HashSet<object>> AggregatePresenceCheckItems(IEnumerable<PresenceCheckItem> presenceCheckItems)
        {
            IDictionary<string, HashSet<object>> columnWithValues = new Dictionary<string, HashSet<object>>();

            foreach (var presenceCheckItem in presenceCheckItems)
            {
                var columnsToCheck = presenceCheckItem.ColumnValues.ToList();
                columnsToCheck.AddRange(presenceCheckItem.ColumnValuesOneOfThese);
                foreach (var columnValue in columnsToCheck)
                {
                    HashSet<object> columnValues = null;
                    if (!columnWithValues.ContainsKey(columnValue.Column))
                    {
                        columnValues = new HashSet<object>();
                        columnWithValues.Add(columnValue.Column, columnValues);
                    }
                    else
                    {
                        columnValues = columnWithValues[columnValue.Column];
                    }

                    columnValues.Add(columnValue.Value);
                }
            }

            return columnWithValues;
        }

        private Entity GetMatchingEntity(IEnumerable<ColumnValue> columnValues, EntityCollection matchedEntities)
        {
            IEnumerable<Entity> entities = matchedEntities.Entities;
            int numColumnsToCheck = columnValues.Count();
            int entityIndex = 0;
            Entity matchedEntity = null;
            foreach (var entity in entities)
            {
                int numMatchedColumns = 0;
                entityIndex++;
                foreach (var columnValue in columnValues)
                {
                    object value;
                    entity.Attributes.TryGetValue(columnValue.GetColumnNameWithAlias(), out value);
                    AliasedValue aliasedValue = value as AliasedValue;
                    if ((aliasedValue != null && aliasedValue.Value.ToString().Equals(columnValue.Value.ToString())) ||
                        (value is string && ((string)value).Equals(columnValue.Value.ToString())))
                    {
                        // the value matches
                        numMatchedColumns++;
                    }
                }

                if (numMatchedColumns == numColumnsToCheck)
                {
                    matchedEntity = entity;
                    break;
                }
            }

            return matchedEntity;
        }

        private EntityCollection GetMatchingEntities(string entityName, IDictionary<string, HashSet<object>> columnWithValues)
        {
            QueryExpression query = CreateQueryExpression(entityName, columnWithValues);
            return ExecuteQuery(query);
        }

        private EntityCollection GetMatchingEntities(CrmLookupType lookupType, IEnumerable<string> values)
        {
            return BatchCacheManager.GetEntities(
                BatchId,
                lookupType,
                values,
                () =>
                {
                    CrmLookupEntityDetail entityDetail = lookupType.GetEntityDetail();
                    QueryExpression query = CreateQueryExpression(entityDetail.EntityName, entityDetail.LookupColumn, values);
                    return ExecuteQuery(query);
                });
        }

        private EntityCollection GetMatchingEntitiesFromEnduringCache(CrmLookupType lookupType)
        {
            return EnduringCacheManager.GetEntitiesForLookupType(
                lookupType,
                () =>
                {
                    CrmLookupEntityDetail entityDetail = lookupType.GetEntityDetail();
                    QueryExpression query = CreateQueryExpression(entityDetail.EntityName, entityDetail.LookupColumn, values: Enumerable.Empty<string>());
                    return ExecuteQuery(query);
                });
        }

        public EntityCollection GetMatchingEntitiesForPeriodFromEnduringCache(CrmLookupType lookupType)
        {
            return GetMatchingEntitiesForLinkedEntityFromEnduringCache(lookupType,
                entityName =>
                    CreateQueryExpressionForPeriod(entityName, Enumerable.Empty<string>(),
                        Enumerable.Empty<ColumnValue>()));
        }

        public EntityCollection GetMatchingEntitiesForFundingStreamPeriodFromEnduringCache(CrmLookupType lookupType)
        {
            return GetMatchingEntitiesForLinkedEntityFromEnduringCache(lookupType,
                entityName =>
                    CreateQueryExpressionForFsp(entityName, Enumerable.Empty<string>(),
                        Enumerable.Empty<ColumnValue>()));
        }

        public EntityCollection GetMatchingEntitiesForLinkedEntityFromEnduringCache(CrmLookupType lookupType, Func<string, QueryExpression> getQueryExpression)
        {
            return EnduringCacheManager.GetEntitiesForLookupType(
                lookupType,
                () =>
                {
                    CrmLookupEntityDetail entityDetail = lookupType.GetEntityDetail();
                    EntityCollection entityCollection = new EntityCollection();

                    QueryExpression query = getQueryExpression(entityDetail.EntityName);
                    entityCollection.Entities.AddRange(ExecuteQuery(query).Entities);

                    return entityCollection;
                });
        }

        private EntityCollection GetMatchingEntitiesForValues(CrmLookupType lookupType, IEnumerable<string> values)
        {
            if (values != null && values.Any())
            {
                return GetMatchingEntities(lookupType, values);
            }

            return null;
        }

        private EntityCollection GetMatchingEntitiesForFundingStreamPeriod(CrmLookupType lookupType, HashSet<CrmCompositeKey> compositeKeys)
        {
            return BatchCacheManager.GetEntities(
                BatchId,
                lookupType,
                compositeKeys,
                () =>
                {
                    CrmLookupEntityDetail entityDetail = lookupType.GetEntityDetail();
                    EntityCollection entityCollection = new EntityCollection();
                    foreach (var compositeKey in compositeKeys)
                    {
                        QueryExpression query = CreateQueryExpressionForFsp(entityDetail.EntityName, entityDetail.LookupColumns, compositeKey.KeyFields);
                        entityCollection.Entities.AddRange(ExecuteQuery(query).Entities);
                    }

                    return entityCollection;
                });
        }

        private EntityCollection ExecuteQuery(QueryExpression query)
        {
            EntityCollection entityCollection = null;
            RetrieveMultipleRequest rmr = new RetrieveMultipleRequest();
            rmr.Query = query;

            ExecuteMultipleRequest emr = new ExecuteMultipleRequest();
            emr.Requests = new OrganizationRequestCollection();
            emr.Requests.Add(rmr);
            emr.Settings = new ExecuteMultipleSettings();
            emr.Settings.ReturnResponses = true;

            ExecuteMultipleResponse xmr = (ExecuteMultipleResponse)OrganizationService.Execute(emr);

            foreach (var response in xmr.Responses)
            {
                if (response.Response != null)
                {
                    foreach (var result in response.Response.Results)
                    {
                        entityCollection = result.Value as EntityCollection;
                    }
                }
            }

            return entityCollection;
        }

        public IList<DeliverablePeriodsValueData> GetAllDeliverablePeriods(string allocationNumber, int version)
        {
            const string separator = "_";
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                var deliverablePeriodList = (from c in xrmContext.sfa_contractSet
                                    join a in xrmContext.sfa_contractallocationSet on c.sfa_contractId equals a.sfa_ContractId.Id
                                    join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals d.sfa_ContractAllocationId.Id
                                    join dp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals dp.sfa_ContractDeliverableId.Id
                                            where a.sfa_contractallocationnumber == allocationNumber
                                            where c.sfa_Version.Value == version
                                            where c.sfa_ContractStatus.Value.Equals(sfa_contractstatus.Approved)

                                             select new DeliverablePeriodsValueData
                                    {
                                        PlannedValue = dp.sfa_PlannedValue ?? 0,
                                        ActualValue = dp.sfa_ActualValue ?? 0,
                                        BalancingPaymentValue = dp.sfa_BalancingPaymentAmount,
                                        CappingPaymentValue = dp.sfa_CappedPaymentAmount,
                                        NetPaymentValue = dp.sfa_NetPaymentAmount,
                                        ModifiedOn = dp.ModifiedOn,
                                        ReconciliationPaymentValue = dp.sfa_ReconciliationPaymentAmount,
                                        ProfilePaymentValue = dp.sfa_ProfilePaymentAmount,
                                   
                                        Key = a.sfa_contractallocationnumber + separator + c.sfa_Version + separator + d.sfa_DeliverableCode + separator + dp.sfa_PeriodName
                                    });

                return deliverablePeriodList.ToList();
            }
        }

        public IReadOnlyCollection<UnitOfProcurement> GetUnitOfProcurementReferenceData()
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(OrganizationService))
            {
                List<UnitOfProcurement> unitsOfProcurement = (
                    from uop in xrmContext.sfa_unitofprocurementSet
                    join fsp in xrmContext.sfa_fundingstreamperiodSet on uop.sfa_procurement equals fsp.sfa_procurement
                    select new UnitOfProcurement(uop.sfa_UoPCode, uop.sfa_procurement, fsp.sfa_fundingstreamperiodcode)
                    ).ToList();

                return unitsOfProcurement.AsReadOnly();
            }
        }

        private QueryExpression CreateQueryExpression(string entityName, string attributeName, IEnumerable<string> values)
        {
            QueryExpression query = new QueryExpression
            {
                EntityName = entityName,
                ColumnSet = new ColumnSet(true),
                Criteria = new FilterExpression()
            };

            // only add restrictions if we have any
            if (values != null)
            {
                string[] valueArray = values.ToArray();
                if (valueArray.Length > 0)
                {
                    query.Criteria.Conditions.Add(new ConditionExpression(
                        attributeName,
                        ConditionOperator.In,
                        valueArray));
                }
            }

            return query;
        }

        private QueryExpression CreateQueryExpression(string entityName, IDictionary<string, HashSet<object>> columnWithValues)
        {
            QueryExpression query = new QueryExpression
            {
                EntityName = entityName,
                ColumnSet = new ColumnSet(true),
                Criteria = new FilterExpression()
            };

            foreach (var columnName in columnWithValues.Keys)
            {
                HashSet<object> valuesSet = columnWithValues[columnName];
                query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        entityName,
                        columnName,
                        ConditionOperator.In,
                        valuesSet.ToArray()));
            }

            return query;
        }

        private QueryExpression CreateQueryExpressionForPeriod(string entityName, IEnumerable<string> attributeNames, IEnumerable<ColumnValue> values)
        {
            QueryExpression query = new QueryExpression
            {
                EntityName = entityName,
                ColumnSet = new ColumnSet(true),
                Criteria = new FilterExpression()
            };

            LinkEntity linkPeriodType = new LinkEntity()
            {
                LinkFromAttributeName = "sfa_periodtypeid",
                LinkToEntityName = "sfa_periodtype",
                LinkToAttributeName = "sfa_periodtypeid",
                JoinOperator = JoinOperator.Inner,
                Columns = new ColumnSet(true),
                EntityAlias = "pt"
            };

            query.LinkEntities.Add(linkPeriodType);

            foreach (var attributeName in attributeNames)
            {
                query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        values.Where(v => v.Column == attributeName).Select(v => v.Table).FirstOrDefault(),
                        attributeName,
                        ConditionOperator.In,
                        values.Where(v => v.Column == attributeName).Select(v => v.Value.ToString()).ToArray()));
            }

            return query;
        }

        private QueryExpression CreateQueryExpressionForMatchingTenderAwardReferenceItems(IList<string> importedTenderAwardRefs)
        {
            QueryExpression query = new QueryExpression
            {
                EntityName = CrmEntityName.ContractAllocation,
                ColumnSet = new ColumnSet("sfa_contractallocationnumber", "sfa_awardreference"),
                Criteria = new FilterExpression(),
                Distinct = true
            };

            LinkEntity linkEntityContract = new LinkEntity
            {
                LinkFromAttributeName = "sfa_contractid",
                LinkToEntityName = "sfa_contract",
                LinkToAttributeName = "sfa_contractid",
                JoinOperator = JoinOperator.Inner,
                Columns = new ColumnSet("sfa_number"),
                EntityAlias = "c"
            };

            query.LinkEntities.Add(linkEntityContract);

            query.Criteria.Conditions.Add(new ConditionExpression(
                CrmEntityName.ContractAllocation,
                "sfa_awardreference",
                ConditionOperator.In,
                (string[])importedTenderAwardRefs.ToArray()));

            return query;
        }


        private QueryExpression CreateQueryExpressionForAllocationsAndTheirDeliverables(string contractNumber, int statusId)
        {
            QueryExpression query = new QueryExpression
            {
                EntityName = CrmEntityName.Contract,
                ColumnSet = new ColumnSet("sfa_contractid"),
                Criteria = new FilterExpression()
            };

            LinkEntity linkContractAllocations = new LinkEntity()
            {
                LinkFromAttributeName = "sfa_contractid",
                LinkToEntityName = CrmEntityName.ContractAllocation,
                LinkToAttributeName = "sfa_contractid",
                JoinOperator = JoinOperator.Inner,
                Columns = new ColumnSet("sfa_contractallocationnumber", "sfa_maximumcontractvalue"),
                EntityAlias = "a"
            };

            LinkEntity linkContractDeliverables = new LinkEntity()
            {
                LinkFromAttributeName = "sfa_contractallocationid",
                LinkToEntityName = "sfa_contractdeliverable",
                LinkToAttributeName = "sfa_contractallocationid",
                JoinOperator = JoinOperator.Inner,
                Columns = new ColumnSet("sfa_deliverablecode"),
                EntityAlias = "d"
            };

            linkContractAllocations.LinkEntities.Add(linkContractDeliverables);

            query.LinkEntities.Add(linkContractAllocations);

            query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        CrmEntityName.Contract,
                        "sfa_number",
                        ConditionOperator.In,
                        contractNumber));

            query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        CrmEntityName.Contract,
                        "sfa_contractstatus",
                        ConditionOperator.In,
                        statusId));

            return query;
        }

        private QueryExpression CreateQueryExpressionForAllocations(string allocationNumber, int contractVersionNumber)
        {
            const string approvedStatus = "Approved";
            const string replacedStatus = "Replaced";

            // get the option set id for "Approved" and "Replaced" statuses
            var approvedStatusId = GetOptionsetValue(CrmOptionSetType.Status.GetOptionSetName(), approvedStatus);
            var replacedStatusId = GetOptionsetValue(CrmOptionSetType.Status.GetOptionSetName(), replacedStatus);
            

            if (approvedStatusId.HasValue && replacedStatusId.HasValue)
            {
                var statuses = new object[] { approvedStatusId.Value, replacedStatusId.Value };

                QueryExpression query = new QueryExpression
                {
                    EntityName = CrmEntityName.ContractAllocation,
                    ColumnSet = new ColumnSet("sfa_contractallocationnumber", "sfa_startdate", "sfa_enddate"),
                    Criteria = new FilterExpression()
                };

                LinkEntity linkContracts = new LinkEntity()
                {
                    LinkFromAttributeName = "sfa_contractid",
                    LinkToEntityName = CrmEntityName.Contract,
                    LinkToAttributeName = "sfa_contractid",
                    JoinOperator = JoinOperator.Inner,
                    Columns = new ColumnSet("sfa_contractid", "sfa_version"),
                };

                query.LinkEntities.Add(linkContracts);

                query.Criteria.Conditions.Add(                        
                    new ConditionExpression(                            
                        CrmEntityName.Contract,                            
                        "sfa_version",                         
                        ConditionOperator.Equal,                            
                        contractVersionNumber));

                query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        CrmEntityName.Contract,
                        "sfa_contractstatus",
                        ConditionOperator.In,
                        statuses));

                query.Criteria.Conditions.Add(                        
                    new ConditionExpression(                            
                        CrmEntityName.ContractAllocation,                            
                        "sfa_contractallocationnumber",                           
                        ConditionOperator.Equal,                            
                        allocationNumber));

                return query;
            }
            return null;
        }

        private QueryExpression CreateQueryExpressionForPaymentScheduleDeliverablePayment(string allocationNumber, int version, string deliverableCode, string period)
        {
            string periodDate;
            const string approvedStatus = "Approved";
            const string replacedStatus = "Replaced";

            DateTime dt = DateTime.ParseExact(period, "yyyyMM", new System.Globalization.CultureInfo("en-GB"));
            periodDate = dt.ToString("MMM-yy");

            // first get the option set id for the status
            int? approvedStatusId = GetOptionsetValue(CrmOptionSetType.Status.GetOptionSetName(), approvedStatus);
            int? replacedStatusId = GetOptionsetValue(CrmOptionSetType.Status.GetOptionSetName(), replacedStatus);

            List<object> statuses = new List<object>();
            statuses.Add(approvedStatusId.Value);
            statuses.Add(replacedStatusId.Value);
            

            if (approvedStatusId.HasValue)
            {

                QueryExpression query = new QueryExpression
                {
                    EntityName = CrmEntityName.Contract,
                    ColumnSet = new ColumnSet("sfa_contractid"),
                    Criteria = new FilterExpression()
                };

                LinkEntity linkContractAllocations = new LinkEntity()
                {
                    LinkFromAttributeName = "sfa_contractid",
                    LinkToEntityName = CrmEntityName.ContractAllocation,
                    LinkToAttributeName = "sfa_contractid",
                    JoinOperator = JoinOperator.Inner,
                    Columns = new ColumnSet("sfa_contractallocationnumber"),
                    EntityAlias = "a"
                };

                LinkEntity linkContractDeliverables = new LinkEntity()
                {
                    LinkFromAttributeName = "sfa_contractallocationid",
                    LinkToEntityName = CrmEntityName.ContractDeliverable,
                    LinkToAttributeName = "sfa_contractallocationid",
                    JoinOperator = JoinOperator.Inner,
                    Columns = new ColumnSet("sfa_deliverablecode"),
                    EntityAlias = "d"
                };

                LinkEntity linkContractDeliverablePeriod = new LinkEntity()
                {
                    LinkFromAttributeName = "sfa_contractdeliverableid",
                    LinkToEntityName = CrmEntityName.ContractDeliverablePeriod,
                    LinkToAttributeName = "sfa_contractdeliverableid",
                    JoinOperator = JoinOperator.Inner,
                    Columns = new ColumnSet("sfa_actualvalue", "sfa_plannedvalue",
                    "sfa_balancingpaymentamount", "sfa_reconciliationpaymentamount",
                    "sfa_cappedpaymentamount", "sfa_netpaymentamount",
                    "sfa_profilepaymentamount", "modifiedon", "sfa_contractdeliverableperiodid"
                    ),
                    EntityAlias = "p"
                };

                linkContractDeliverables.LinkEntities.Add(linkContractDeliverablePeriod);
                linkContractAllocations.LinkEntities.Add(linkContractDeliverables);
                query.LinkEntities.Add(linkContractAllocations);

                query.Criteria.Conditions.Add(
               new ConditionExpression(
                   CrmEntityName.Contract,
                   "sfa_contractstatus",
                   ConditionOperator.In,
                   statuses.ToArray()));

                query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        CrmEntityName.Contract,
                        "sfa_version",
                        ConditionOperator.In,
                        version));

                query.Criteria.Conditions.Add(
                   new ConditionExpression(
                       CrmEntityName.ContractAllocation,
                       "sfa_contractallocationnumber",
                       ConditionOperator.In,
                       allocationNumber));

                query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        CrmEntityName.ContractDeliverable,
                        "sfa_deliverablecode",
                        ConditionOperator.In,
                        deliverableCode));

                query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        CrmEntityName.ContractDeliverablePeriod,
                        "sfa_periodname",
                        ConditionOperator.In,
                        periodDate));

                return query;
            }
            return null;
        }

        private QueryExpression CreateQueryExpressionForContractHistory(string contractNumber, int version)
        {
                const string approvedStatus = "Approved";

            // first get the option set id for the status
            int? approvedStatusId = GetOptionsetValue(CrmOptionSetType.Status.GetOptionSetName(), approvedStatus);

            if (approvedStatusId.HasValue)
            {
                QueryExpression query = new QueryExpression
                {
                    EntityName = CrmEntityName.Contract,
                    ColumnSet = new ColumnSet("sfa_number", "sfa_version"),
                    Criteria = new FilterExpression()
                };

                LinkEntity linkContractAllocations = new LinkEntity()
                {
                    LinkFromAttributeName = "sfa_contractid",
                    LinkToEntityName = CrmEntityName.ContractTransitionHistory,
                    LinkToAttributeName = "sfa_contract",
                    JoinOperator = JoinOperator.Inner,
                    Columns = new ColumnSet("createdon"),
                    EntityAlias = "CH"
                };

                query.LinkEntities.Add(linkContractAllocations);
                query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        CrmEntityName.Contract,
                        "sfa_number",
                        ConditionOperator.In,
                        contractNumber));

                query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        CrmEntityName.Contract,
                        "sfa_version",
                        ConditionOperator.In,
                        version));

                query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        CrmEntityName.Contract,
                        "statuscode",
                        ConditionOperator.Equal,
                        1));

                query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        CrmEntityName.Contract,
                        "sfa_contractstatus",
                        ConditionOperator.Equal,
                        approvedStatusId.Value));

                query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        CrmEntityName.ContractTransitionHistory,
                        "sfa_name",
                        ConditionOperator.Equal,
                        "Confirm Receipt of Signed Contract"));

                return query;
            }
            return null;
        }

        private QueryExpression CreateQueryExpressionForFsp(string entityName, IEnumerable<string> attributeNames, IEnumerable<ColumnValue> values)
        {
            QueryExpression query = new QueryExpression
            {
                EntityName = entityName,
                ColumnSet = new ColumnSet(true),
                Criteria = new FilterExpression()
            };

            LinkEntity linkEntityFS = new LinkEntity()
            {
                LinkFromAttributeName = "sfa_fundingstreamcodeid",
                LinkToEntityName = "sfa_fundingstream",
                LinkToAttributeName = "sfa_fundingstreamid",
                JoinOperator = JoinOperator.Inner,
                Columns = new ColumnSet(true),
                EntityAlias = CrmFieldMapper.SfaFundingstreamAlias
            };

            LinkEntity linkEntityP = new LinkEntity()
            {
                LinkFromAttributeName = "sfa_periodid",
                LinkToEntityName = "sfa_period",
                LinkToAttributeName = "sfa_periodid",
                JoinOperator = JoinOperator.Inner,
                Columns = new ColumnSet(true),
                EntityAlias = CrmFieldMapper.SfaPeriodAlias
            };

            LinkEntity linkEntityPT = new LinkEntity()
            {
                LinkFromAttributeName = "sfa_periodtypeid",
                LinkToEntityName = "sfa_periodtype",
                LinkToAttributeName = "sfa_periodtypeid",
                JoinOperator = JoinOperator.Inner,
                Columns = new ColumnSet(true),
                EntityAlias = CrmFieldMapper.SfaPeriodTypeAlias
            };

            query.LinkEntities.Add(linkEntityFS);
            query.LinkEntities.Add(linkEntityP);
            linkEntityP.LinkEntities.Add(linkEntityPT);

            foreach (var attributeName in attributeNames)
            {
                query.Criteria.Conditions.Add(
                    new ConditionExpression(
                        values.Where(v => v.Column == attributeName).Select(v => v.Table).FirstOrDefault(),
                        attributeName,
                        ConditionOperator.In,
                        values.Where(v => v.Column == attributeName).Select(v => v.Value.ToString()).ToArray()));
            }

            return query;
        }

        /// <summary>
        /// Internal method to get a list of CRM entities representing the contract
        /// </summary>
        /// <param name="correlationId">The contract correlationId</param>
        /// <returns>A list of CRM entities corresponding to the contract correlationId</returns>
        private List<sfa_contract> GetMatchingXrmContracts(string correlationId)
        {
            using (var xrmContext = new XrmServiceContext(OrganizationService))
            {
                return (from c in xrmContext.sfa_contractSet
                        where c.sfa_Correlation == correlationId
                        select c).ToList();
            }
        }

        ////// Optional method to retrieve entity via late binding.
        ////private EntityCollection GetMatchingCollection(string correlationId)
        ////{
        ////    IDictionary<string, HashSet<object>> columnWithValues = new Dictionary<string, HashSet<object>>();
        ////    HashSet<object> columnValues = null;
        ////    columnValues = new HashSet<object>();
        ////    columnValues.Add(correlationId);
        ////    columnWithValues.Add("sfa_correlation", columnValues);
        ////    var results = GetMatchingEntities("sfa_contract", columnWithValues);
        ////    return results;
        ////}
    }
}