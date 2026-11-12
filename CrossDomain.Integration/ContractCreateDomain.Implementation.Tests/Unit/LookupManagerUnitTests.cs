namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Metadata;
    using Microsoft.Xrm.Sdk.Query;
    using Moq;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class LookupManagerUnitTests
    {
        private static readonly Guid OrganisationId = Guid.NewGuid();
        private static readonly Guid LepId = Guid.NewGuid();
        private static readonly Guid FundingTypeId = Guid.NewGuid();
        private static readonly Guid PeriodId = Guid.NewGuid();

        private Mock<IOrganizationService> _service;
        private List<QueryExpression> _queries;
        private int _optionSetRequestCount;
        private Func<QueryExpression, EntityCollection> _queryHandler;
        private Func<QueryBase, EntityCollection> _linqHandler;
        private Dictionary<string, int> _statusOptions;
        private LookupManager _lookupManager;

        [TestInitialize]
        public void Setup()
        {
            _queries = new List<QueryExpression>();
            _optionSetRequestCount = 0;
            _queryHandler = query => new EntityCollection();
            _linqHandler = query => new EntityCollection();
            _statusOptions = new Dictionary<string, int> { { "Approved", 100 }, { "Replaced", 200 } };

            _service = new Mock<IOrganizationService>();
            _service.Setup(s => s.Execute(It.IsAny<OrganizationRequest>())).Returns<OrganizationRequest>(HandleExecute);

            _lookupManager = new LookupManager
            {
                OrganizationService = _service.Object,
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager(),
                BatchId = string.Empty
            };
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetOptionsetValue_ShouldReturnValueForMatchingLabelAndCacheIt()
        {
            var first = _lookupManager.GetOptionsetValue("sfa_contractstatus", "Approved");
            var second = _lookupManager.GetOptionsetValue("sfa_contractstatus", "Approved");

            Assert.AreEqual(100, first);
            Assert.AreEqual(100, second);
            Assert.AreEqual(1, _optionSetRequestCount);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetOptionsetValue_ShouldReturnNullWhenLabelIsNotFound()
        {
            Assert.IsNull(_lookupManager.GetOptionsetValue("sfa_contractstatus", "Unknown"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetColumnValuesForEntity_ShouldReturnColumnForAllEntitiesOfLookupType()
        {
            _queryHandler = query => Collection(
                NewEntity("sfa_contracttype", sfa_name: "Type A"),
                NewEntity("sfa_contracttype", sfa_name: "Type B"));

            var values = _lookupManager.GetColumnValuesForEntity<string>(CrmLookupType.ContractType, "sfa_name");

            CollectionAssert.AreEqual(new[] { "Type A", "Type B" }, values);
            Assert.AreEqual("sfa_contracttype", _queries.Single().EntityName);
            Assert.AreEqual(0, _queries.Single().Criteria.Conditions.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetColumnValuesForEntity_ShouldFilterOnColumnValues()
        {
            _queryHandler = query => Collection(NewEntity("sfa_fundingtype", sfa_name: "Main"));

            var values = _lookupManager.GetColumnValuesForEntity<string>(
                CrmLookupType.FundingType,
                "sfa_name",
                "sfa_fundingtypecode",
                new[] { "MAIN", "AGE" });

            CollectionAssert.AreEqual(new[] { "Main" }, values);
            var condition = _queries.Single().Criteria.Conditions.Single();
            Assert.AreEqual("sfa_fundingtypecode", condition.AttributeName);
            Assert.AreEqual(ConditionOperator.In, condition.Operator);
            CollectionAssert.AreEqual(new object[] { "MAIN", "AGE" }, condition.Values.ToArray());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetPkColumnValuesForEntity_ShouldReturnIdsAndCacheTheResult()
        {
            var id = Guid.NewGuid();
            var entity = new Entity("sfa_fundingtype") { Id = id };
            entity["sfa_fundingtypeid"] = id;
            _queryHandler = query => Collection(entity);

            var first = _lookupManager.GetPkColumnValuesForEntity(CrmLookupType.FundingType, "sfa_fundingtypeid", new[] { "MAIN" });
            var second = _lookupManager.GetPkColumnValuesForEntity(CrmLookupType.FundingType, "sfa_fundingtypeid", new[] { "MAIN" });

            CollectionAssert.AreEqual(new[] { id }, first.ToList());
            CollectionAssert.AreEqual(new[] { id }, second.ToList());
            Assert.AreEqual(1, _queries.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CheckForPresence_ShouldFlagItemsFoundInCrm()
        {
            var referenceId = Guid.NewGuid();
            var entity = new Entity("sfa_contract");
            entity["sfa_number"] = "ABC";
            entity["sfa_status"] = new OptionSetValue(3);
            entity["sfa_ref"] = new EntityReference("sfa_other", referenceId);
            _queryHandler = query => Collection(entity);

            var found = new PresenceCheckItem("sfa_contract", new List<ColumnValue>
            {
                new ColumnValue { Column = "sfa_number", Value = "ABC" },
                new ColumnValue { Column = "sfa_status", Value = 3 },
                new ColumnValue { Column = "sfa_ref", Value = referenceId }
            });
            var notFound = new PresenceCheckItem("sfa_contract", new List<ColumnValue>
            {
                new ColumnValue { Column = "sfa_number", Value = "XYZ" },
                new ColumnValue { Column = "sfa_status", Value = 3 },
                new ColumnValue { Column = "sfa_ref", Value = referenceId }
            });

            _lookupManager.CheckForPresence(new[] { found, notFound });

            Assert.IsTrue(found.IsPresent);
            Assert.IsFalse(notFound.IsPresent);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CheckForPresence_ShouldLeaveItemsNotPresentWhenCrmReturnsNothing()
        {
            _queryHandler = query => null;
            var item = new PresenceCheckItem("sfa_contract", new List<ColumnValue>
            {
                new ColumnValue { Column = "sfa_number", Value = "ABC" }
            });

            _lookupManager.CheckForPresence(new[] { item });

            Assert.IsFalse(item.IsPresent);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Lookup_ShouldLoadReferenceDataSoEntitiesCanBeMatched()
        {
            var organisation = new Entity("account") { Id = OrganisationId };
            organisation["sfa_ukprn"] = "10000001";
            var lep = new Entity("account") { Id = LepId };
            lep["sfa_lepcode"] = "LEP1";
            var fundingType = new Entity("sfa_fundingtype") { Id = FundingTypeId };
            fundingType["sfa_fundingtypecode"] = "MAIN";
            var period = new Entity("sfa_period") { Id = PeriodId };
            period["sfa_period"] = "1516";
            period["pt.sfa_periodtypecode"] = new AliasedValue("sfa_periodtype", "sfa_periodtypecode", "AY");

            _queryHandler = query =>
            {
                switch (query.EntityName)
                {
                    case "account": return Collection(organisation, lep);
                    case "sfa_fundingtype": return Collection(fundingType);
                    case "sfa_period": return Collection(period);
                    default: return new EntityCollection();
                }
            };

            var criteria = new LookupCriteria();
            criteria.UkPrns.Add("10000001");
            criteria.LEP.Add("LEP1");

            _lookupManager.Lookup(criteria);

            Assert.AreEqual(OrganisationId, _lookupManager.GetMatchingEntity(CrmLookupType.Organisation, "10000001"));
            Assert.AreEqual(LepId, _lookupManager.GetMatchingEntity(CrmLookupType.LocalEnterprisePartnership, "LEP1"));
            Assert.AreEqual(FundingTypeId, _lookupManager.GetMatchingEntity(CrmLookupType.FundingType, "MAIN"));
            Assert.IsNull(_lookupManager.GetMatchingEntity(CrmLookupType.FundingType, "NOPE"));
            Assert.IsNull(_lookupManager.GetMatchingEntity(CrmLookupType.FundingType, string.Empty));
            Assert.IsNull(_lookupManager.GetMatchingEntity(CrmLookupType.RegionType, "MAIN"));

            var periodKey = CrmFieldMapper.GetPeriodPk(NewPeriod("1516", CorporateContract.periodTypeCodeType.AY));
            Assert.AreEqual(PeriodId, _lookupManager.GetMatchingEntity(CrmLookupType.Period, periodKey));

            var unknownPeriodKey = CrmFieldMapper.GetPeriodPk(NewPeriod("9999", CorporateContract.periodTypeCodeType.AY));
            Assert.IsNull(_lookupManager.GetMatchingEntity(CrmLookupType.Period, unknownPeriodKey));
            Assert.IsNull(_lookupManager.GetMatchingEntity(CrmLookupType.Period, new CrmCompositeKey()));
            Assert.IsNull(_lookupManager.GetMatchingEntity(CrmLookupType.RegionType, periodKey));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetPeriodId_ShouldReturnIdOfSinglePeriodAndCacheIt()
        {
            _queryHandler = query => Collection(new Entity("sfa_period") { Id = PeriodId });

            var first = _lookupManager.GetPeriodId("1516", CorporateContract.periodTypeCodeType.AY);
            var second = _lookupManager.GetPeriodId("1516", CorporateContract.periodTypeCodeType.AY);

            Assert.AreEqual(PeriodId, first);
            Assert.AreEqual(PeriodId, second);
            Assert.AreEqual(1, _queries.Count);
            Assert.AreEqual(1, _queries.Single().LinkEntities.Count);
            Assert.AreEqual("sfa_periodtype", _queries.Single().LinkEntities.Single().LinkToEntityName);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetPeriodId_ShouldThrowWhenPeriodIsNotInCrm()
        {
            _queryHandler = query => new EntityCollection();

            AssertThrows(() => _lookupManager.GetPeriodId("1516", CorporateContract.periodTypeCodeType.AY));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetFundingTypeId_ShouldReturnIdWhenExactlyOneMatch()
        {
            _queryHandler = query => Collection(new Entity("sfa_fundingtype") { Id = FundingTypeId });

            Assert.AreEqual(FundingTypeId, _lookupManager.GetFundingTypeId("MAIN"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetFundingTypeId_ShouldThrowWhenNoMatch()
        {
            _queryHandler = query => new EntityCollection();

            AssertThrows(() => _lookupManager.GetFundingTypeId("MAIN"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AreMultipleOverlappingContractsAllowedForFundingType_ShouldReturnFlagFromCrm()
        {
            var allowed = new Entity("sfa_fundingtype");
            allowed["sfa_allowmultiplecontracts"] = true;
            _queryHandler = query => Collection(allowed);

            Assert.IsTrue(_lookupManager.AreMultipleOverlappingContractsAllowedForFundingType("MAIN"));

            var notAllowed = new Entity("sfa_fundingtype");
            notAllowed["sfa_allowmultiplecontracts"] = false;
            _queryHandler = query => Collection(notAllowed);

            Assert.IsFalse(_lookupManager.AreMultipleOverlappingContractsAllowedForFundingType("AGE"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetPaymentScheduleDeliverablePaymentsValues_ShouldMapAliasedValues()
        {
            var entity = new Entity("sfa_contract");
            entity["p.sfa_actualvalue"] = Aliased(10m);
            entity["p.sfa_plannedvalue"] = Aliased(20m);
            entity["p.sfa_balancingpaymentamount"] = Aliased(1m);
            entity["p.sfa_reconciliationpaymentamount"] = Aliased(2m);
            entity["p.sfa_cappedpaymentamount"] = Aliased(3m);
            entity["p.sfa_netpaymentamount"] = Aliased(4m);
            entity["p.sfa_profilepaymentamount"] = Aliased(5m);
            _queryHandler = query => Collection(entity);

            var data = _lookupManager.GetPaymentScheduleDeliverablePaymentsValues("A1", 2, "3", "201601");

            Assert.AreEqual(10m, data.ActualValue);
            Assert.AreEqual(20m, data.PlannedValue);
            Assert.AreEqual(1m, data.BalancingPaymentValue);
            Assert.AreEqual(2m, data.ReconciliationPaymentValue);
            Assert.AreEqual(3m, data.CappingPaymentValue);
            Assert.AreEqual(4m, data.NetPaymentValue);
            Assert.AreEqual(5m, data.ProfilePaymentValue);

            var executedQuery = _queries.Single();
            Assert.AreEqual(5, executedQuery.Criteria.Conditions.Count);
            Assert.AreEqual("Jan-16", executedQuery.Criteria.Conditions.Last().Values.Single());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetPaymentScheduleDeliverablePaymentsValues_ShouldDefaultMissingValues()
        {
            var entity = new Entity("sfa_contract");
            _queryHandler = query => Collection(entity);

            var data = _lookupManager.GetPaymentScheduleDeliverablePaymentsValues("A1", 2, "3", "201601");

            Assert.AreEqual(0m, data.ActualValue);
            Assert.AreEqual(0m, data.PlannedValue);
            Assert.IsNull(data.BalancingPaymentValue);
            Assert.IsNull(data.NetPaymentValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetPaymentScheduleDeliverablePaymentsValues_ShouldReturnEmptyDataWhenNothingFound()
        {
            var data = _lookupManager.GetPaymentScheduleDeliverablePaymentsValues("A1", 2, "3", "201601");

            Assert.AreEqual(0m, data.ActualValue);
            Assert.AreEqual(0m, data.PlannedValue);
            Assert.IsNull(data.ProfilePaymentValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetPaymentScheduleDeliverablePaymentsValueList_ShouldMapEachEntity()
        {
            var id = Guid.NewGuid();
            var modifiedOn = new DateTime(2020, 5, 1);
            var first = new Entity("sfa_contract");
            first["p.sfa_actualvalue"] = Aliased(10m);
            first["p.sfa_plannedvalue"] = Aliased(20m);
            first["p.sfa_netpaymentamount"] = Aliased(4m);
            first["p.sfa_contractdeliverableperiodid"] = Aliased(id);
            first["modifiedon"] = modifiedOn;
            var second = new Entity("sfa_contract");
            second["p.sfa_contractdeliverableperiodid"] = Aliased(Guid.NewGuid());
            _queryHandler = query => Collection(first, second);

            var list = _lookupManager.GetPaymentScheduleDeliverablePaymentsValueList("A1", 2, "3", "201601").ToList();

            Assert.AreEqual(2, list.Count);
            Assert.AreEqual(10m, list[0].ActualValue);
            Assert.AreEqual(20m, list[0].PlannedValue);
            Assert.AreEqual(4m, list[0].NetPaymentValue);
            Assert.AreEqual(id, list[0].EntityId);
            Assert.AreEqual(modifiedOn, list[0].ModifiedOn);
            Assert.AreEqual(0m, list[1].ActualValue);
            Assert.IsNull(list[1].ModifiedOn);
            Assert.IsNull(list[1].CappingPaymentValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetPaymentScheduleDeliverablePaymentsValueList_ShouldReturnEmptyWhenCrmReturnsNull()
        {
            _queryHandler = query => null;

            Assert.AreEqual(0, _lookupManager.GetPaymentScheduleDeliverablePaymentsValueList("A1", 2, "3", "201601").Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetAllocationDateValues_ShouldReadStartAndEndDates()
        {
            var entity = new Entity("sfa_contractallocation");
            entity["sfa_startdate"] = new DateTime(2016, 8, 1);
            entity["sfa_enddate"] = new DateTime(2017, 7, 31);
            _queryHandler = query => Collection(entity);

            var allocation = _lookupManager.GetAllocationDateValues("A1", 1);

            Assert.AreEqual(new DateTime(2016, 8, 1), allocation.StartDate);
            Assert.AreEqual(new DateTime(2017, 7, 31), allocation.EndDate);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetAllocationDateValues_ShouldReturnNullDatesWhenNotSetOrNotFound()
        {
            _queryHandler = query => Collection(new Entity("sfa_contractallocation"));
            var notSet = _lookupManager.GetAllocationDateValues("A1", 1);
            Assert.IsNull(notSet.StartDate);
            Assert.IsNull(notSet.EndDate);

            _queryHandler = query => new EntityCollection();
            var notFound = _lookupManager.GetAllocationDateValues("A1", 1);
            Assert.IsNull(notFound.StartDate);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetAllocationDateValues_ShouldReturnEmptyWhenStatusOptionsAreMissing()
        {
            _statusOptions.Clear();
            _queryHandler = query => Collection(new Entity("sfa_contractallocation"));

            var allocation = _lookupManager.GetAllocationDateValues("A1", 1);

            Assert.IsNull(allocation.StartDate);
            Assert.IsNull(_queries.Single());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetApprovedDateForContract_ShouldReturnHistoryCreatedOn()
        {
            var created = new DateTime(2016, 9, 9);
            var entity = new Entity("sfa_contract");
            entity["CH.createdon"] = Aliased(created);
            _queryHandler = query => Collection(entity);

            Assert.AreEqual(created, _lookupManager.GetApprovedDateForContract("C1", 1));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetApprovedDateForContract_ShouldReturnNullWhenNoHistory()
        {
            _queryHandler = query => new EntityCollection();

            Assert.IsNull(_lookupManager.GetApprovedDateForContract("C1", 1));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetApprovedDateForContract_ShouldReturnNullWhenValueIsNotAliased()
        {
            var entity = new Entity("sfa_contract");
            entity["CH.createdon"] = DateTime.Now;
            _queryHandler = query => Collection(entity);

            Assert.IsNull(_lookupManager.GetApprovedDateForContract("C1", 1));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetMatchingTenderAwardRefsForAllocation_ShouldMapMatches()
        {
            var entity = new Entity("sfa_contractallocation");
            entity["c.sfa_number"] = Aliased("C1");
            entity["sfa_contractallocationnumber"] = "A1";
            entity["sfa_awardreference"] = "TAR1";
            _queryHandler = query => Collection(entity);

            var matches = _lookupManager.GetMatchingTenderAwardRefsForAllocation(new List<string> { "TAR1", "TAR2" });

            Assert.AreEqual(1, matches.Count);
            var match = matches.Single();
            Assert.AreEqual("C1", match.ContractNumber);
            Assert.AreEqual("A1", match.AllocationNumber);
            Assert.AreEqual("TAR1", match.TenderAwardReference);
            Assert.IsTrue(_queries.Single().Distinct);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetMatchingTenderAwardRefsForAllocation_ShouldReturnEmptyWhenCrmReturnsNull()
        {
            _queryHandler = query => null;

            Assert.AreEqual(0, _lookupManager.GetMatchingTenderAwardRefsForAllocation(new List<string> { "TAR1" }).Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetAllocationsForApprovedContract_ShouldGroupDeliverablesByAllocation()
        {
            var rows = new[]
            {
                ApprovedRow("A1", 100m, "1"),
                ApprovedRow("A1", 100m, "2"),
                ApprovedRow("A2", 50m, "3")
            };
            _queryHandler = query => Collection(rows);

            var allocations = _lookupManager.GetAllocationsForApprovedContract("C1").ToList();

            Assert.AreEqual(2, allocations.Count);
            Assert.AreEqual("A1", allocations[0].ContractAllocationNumber);
            Assert.AreEqual(100m, allocations[0].MaximumContractValue);
            CollectionAssert.AreEqual(new[] { 1, 2 }, allocations[0].DeliverableCodes.ToList());
            Assert.AreEqual("A2", allocations[1].ContractAllocationNumber);
            CollectionAssert.AreEqual(new[] { 3 }, allocations[1].DeliverableCodes.ToList());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetDeliverablesForApprovedContract_ShouldReturnEmptyWhenApprovedStatusIsUnknown()
        {
            _statusOptions.Clear();

            var result = _lookupManager.GetDeliverablesForApprovedContract("C1");

            Assert.AreEqual(0, result.Entities.Count);
            Assert.AreEqual(0, _queries.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetMatchingEntitiesForPeriodFromEnduringCache_ShouldQueryOnceAndCache()
        {
            _queryHandler = query => Collection(new Entity("sfa_period") { Id = PeriodId });

            var first = _lookupManager.GetMatchingEntitiesForPeriodFromEnduringCache(CrmLookupType.Period);
            var second = _lookupManager.GetMatchingEntitiesForPeriodFromEnduringCache(CrmLookupType.Period);

            Assert.AreSame(first, second);
            Assert.AreEqual(1, _queries.Count);
            Assert.AreEqual(1, _queries.Single().LinkEntities.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetMatchingEntitiesForFundingStreamPeriodFromEnduringCache_ShouldLinkRelatedEntities()
        {
            _queryHandler = query => Collection(new Entity("sfa_fundingstreamperiod") { Id = Guid.NewGuid() });

            var result = _lookupManager.GetMatchingEntitiesForFundingStreamPeriodFromEnduringCache(CrmLookupType.FundingStreamPeriodCode);

            Assert.AreEqual(1, result.Entities.Count);
            var executedQuery = _queries.Single();
            Assert.AreEqual("sfa_fundingstreamperiod", executedQuery.EntityName);
            Assert.AreEqual(2, executedQuery.LinkEntities.Count);
            Assert.AreEqual(1, executedQuery.LinkEntities[1].LinkEntities.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetMatchingEntitiesForPeriod_ShouldQueryEachCompositeKey()
        {
            _queryHandler = query => Collection(new Entity("sfa_period") { Id = Guid.NewGuid() });
            var keys = new HashSet<CrmCompositeKey>
            {
                CrmFieldMapper.GetPeriodPk(NewPeriod("1516", CorporateContract.periodTypeCodeType.AY)),
                CrmFieldMapper.GetPeriodPk(NewPeriod("1617", CorporateContract.periodTypeCodeType.AY))
            };

            var result = _lookupManager.GetMatchingEntitiesForPeriod(CrmLookupType.Period, keys);

            Assert.AreEqual(2, result.Entities.Count);
            Assert.AreEqual(2, _queries.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void BatchedLookups_ShouldBeCachedPerBatchId()
        {
            _lookupManager.BatchId = "batch-" + Guid.NewGuid();
            _queryHandler = query => Collection(new Entity("sfa_fundingtype") { Id = FundingTypeId });

            _lookupManager.GetFundingTypeId("MAIN");
            _lookupManager.GetFundingTypeId("MAIN");

            Assert.AreEqual(1, _queries.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LinqBasedQueries_ShouldReturnResultsFromOrganisationService()
        {
            var contract = new CrossDomain_Xrm_sfa_contractFactory().Create("C1", 3);
            _linqHandler = query => Collection(contract);

            Assert.AreEqual(3, _lookupManager.GetLatestContractVersionNumberForContract("C1"));
            Assert.IsTrue(_lookupManager.CheckContractExists("CORR"));
            Assert.IsFalse(_lookupManager.CheckContractExists(" "));
            Assert.IsTrue(_lookupManager.AreAnyNonWithdrawnOrSupersededDraftContractsWithContractNumber("C1"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LinqBasedQueries_ShouldReturnNothingWhenCrmHasNoData()
        {
            Assert.IsNull(_lookupManager.GetLatestContractVersionNumberForContract("C1"));
            Assert.IsFalse(_lookupManager.CheckContractExists("CORR"));
            Assert.IsFalse(_lookupManager.AreAnyNonWithdrawnOrSupersededDraftContractsWithContractNumber("C1"));
            Assert.IsFalse(_lookupManager.IsExistingLevyContractWithDraftOfApprovedStatusForUkprnPresentInCrm(1, Guid.NewGuid()));
            Assert.IsFalse(_lookupManager.IsContractNumberWithMatchingUkprnPeriodAndFundingTypePresentInCrm("C1", "M1", 1, Guid.NewGuid(), Guid.NewGuid()));
            Assert.AreEqual(0, _lookupManager.GetAllDeliverablePeriods("A1", 1).Count);
            Assert.AreEqual(0, _lookupManager.GetUnitOfProcurementReferenceData().Count);

            var dictionary = new ConcurrentDictionary<string, IList<SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.DeliverablePeriodsValueData>>();
            _lookupManager.PopulateDeliverablePaymentsDictionary(dictionary, "A1", 1);
            Assert.AreEqual(0, dictionary.Count);
        }

        private static void AssertThrows(Action action)
        {
            try
            {
                action();
            }
            catch (Exception)
            {
                return;
            }

            Assert.Fail("Expected an exception");
        }

        private static Entity NewEntity(string logicalName, string sfa_name)
        {
            var entity = new Entity(logicalName) { Id = Guid.NewGuid() };
            entity["sfa_name"] = sfa_name;
            return entity;
        }

        private static CorporateContract.Period NewPeriod(string name, CorporateContract.periodTypeCodeType type)
        {
            return new CorporateContract.Period
            {
                period1 = name,
                periodType = new CorporateContract.periodTypeType { periodTypeCode = type }
            };
        }

        private static AliasedValue Aliased(object value)
        {
            return new AliasedValue("entity", "attribute", value);
        }

        private static Entity ApprovedRow(string allocationNumber, decimal maximumValue, string deliverableCode)
        {
            var entity = new Entity("sfa_contract");
            entity["a.sfa_contractallocationnumber"] = Aliased(allocationNumber);
            entity["a.sfa_maximumcontractvalue"] = Aliased(maximumValue);
            entity["d.sfa_deliverablecode"] = Aliased(deliverableCode);
            return entity;
        }

        private static EntityCollection Collection(params Entity[] entities)
        {
            var collection = new EntityCollection();
            collection.Entities.AddRange(entities);
            return collection;
        }

        private OrganizationResponse HandleExecute(OrganizationRequest request)
        {
            var executeMultiple = request as ExecuteMultipleRequest;
            if (executeMultiple != null)
            {
                var query = ((RetrieveMultipleRequest)executeMultiple.Requests[0]).Query as QueryExpression;
                _queries.Add(query);
                var results = query == null ? null : _queryHandler(query);

                var item = new ExecuteMultipleResponseItem
                {
                    Response = new RetrieveMultipleResponse
                    {
                        Results = new ParameterCollection { { "EntityCollection", results } }
                    }
                };

                return new ExecuteMultipleResponse
                {
                    Results = new ParameterCollection
                    {
                        { "Responses", new ExecuteMultipleResponseItemCollection { item } }
                    }
                };
            }

            var optionSet = request as RetrieveOptionSetRequest;
            if (optionSet != null)
            {
                _optionSetRequestCount++;
                var options = new OptionMetadataCollection(
                    _statusOptions.Select(o => new OptionMetadata(new Label(o.Key, 1033), o.Value)).ToList());

                return new RetrieveOptionSetResponse
                {
                    Results = new ParameterCollection { { "OptionSetMetadata", new OptionSetMetadata(options) } }
                };
            }

            var retrieveMultiple = request as RetrieveMultipleRequest;
            if (retrieveMultiple != null)
            {
                return new RetrieveMultipleResponse
                {
                    Results = new ParameterCollection { { "EntityCollection", _linqHandler(retrieveMultiple.Query) } }
                };
            }

            throw new NotSupportedException(request.GetType().Name);
        }

        private class CrossDomain_Xrm_sfa_contractFactory
        {
            public SFA.FCT.CrossDomain.Integration.Entities.Xrm.sfa_contract Create(string number, int version)
            {
                return new SFA.FCT.CrossDomain.Integration.Entities.Xrm.sfa_contract
                {
                    sfa_contractId = Guid.NewGuid(),
                    sfa_number = number,
                    sfa_Version = version
                };
            }
        }
    }
}
