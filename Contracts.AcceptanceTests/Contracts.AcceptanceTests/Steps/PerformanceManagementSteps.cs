namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Globalization;
    using System.Linq;
    using System.Text;
    using ContractCreateDomain.Implementation;
    using ContractCreateDomain.Implementation.Persistence;
    using CrossDomain.Integration.Common.Serializers;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.CorporateSchema._3_0;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using CrossDomain.Integration.Messages.Commands;
    using Extensions;
    using global::PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using global::PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services;
    using Infrastructure.Repositories;
    using Infrastructure.Repositories.CrmReplicaRepo;
    using Infrastructure.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using Pages;
    using Pages.DTO;
    using PerformanceManagementDomain.DataStore;
    using PerformanceManagementDomain.DataStore.Models;
    using TechTalk.SpecFlow;
    using Utilities;
    using DtoFundingClaim = CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using DtoFundingClaimReconciliation = CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using FspDeliverableClaimRepository = global::PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.FspDeliverableClaimRepository;
    using PMEFModel = PerformanceManagementDomain.DataStore.Models.Allocation;
    using sfa_contract = CrossDomain.Integration.Entities.Xrm.sfa_contract;
    using sfa_fundingclaimreconciliation = CrossDomain.Integration.Entities.Xrm.sfa_fundingclaimreconciliation;

    [Binding]
    public class PerformanceManagementSteps
    {
        private readonly PerformanceManagementPageObject _performanceManagementPageObject;
        private readonly IList<ClaimTypeInfo> _currentScenarioClaimTypeInfos = new List<ClaimTypeInfo>();
        private readonly List<DtoFundingClaim.DebatchedFundingClaim> _debatchedFundingClaims = new List<DtoFundingClaim.DebatchedFundingClaim>();
        private readonly List<string> _createdContractAllocationNumbers = new List<string>();
        private readonly List<FundingClaimReconciliation> _fundingClaimReconciliations = new List<FundingClaimReconciliation>();
        private const string BulkContractsCacheKey = "BulkContracts";
        
        public PerformanceManagementSteps(PerformanceManagementPageObject performanceManagementPageObject)
        {
            _performanceManagementPageObject = performanceManagementPageObject;
        }

        [AfterScenario("FundingClaimReconciliationCalculation")]
        public void AfterFundingClaimReconciliationCalculationScenario()
        {
            _createdContractAllocationNumbers.ForEach(_performanceManagementPageObject.DeleteAllocationFromPaaS);
        }

        [Given(@"there is no data in the CRM funding claim reconciliation tables")]
        public void GivenThereIsNoDataInTheCrmFundingClaimReconciliationTables()
        {
            _performanceManagementPageObject.RemoveAllFundingClaimClaimReconciliationData();
        }

        [Given(@"there is no data in the CRM funding claim reconciliation tables for the following UKPRNs")]
        public void GivenThereIsNoDataInTheCrmFundingClaimReconciliationTablesForTheFollowingUkprns(Table table)
        {
            table.Rows.ForEach(r => CrmFundingClaimReconciliationRepository.DeleteFundingClaimReconciliationsForUkprn(r["UKPRN"]));

            table.Rows.ForEach(r => CrmReplicatedRepository.DeleteFundingClaimReconciliationsForUkprn(r["UKPRN"]));
        }

        [Given(@"there are no notifications of type '(.*)'")]
        public void GivenThereAreNoNotificationsOfType(string notificationType)
        {
            _performanceManagementPageObject.ClearNotificationsForType(notificationType);

            CrmReplicatedRepository.ClearNotificationsForType(notificationType);
        }

        [Given(@"there are no notifications in CRM of type '(.*)' for UKPRN '(.*)'")]
        public void GivenThereAreNoNotificationsInCRMOfTypeForUKPRN(string notificationType, string ukprn)
        {
            CrmNotificationRepository.DeleteNotificationsByTypeForUkprn(notificationType, ukprn);
            CrmReplicatedRepository.DeleteNotificationsByTypeForUkprn(notificationType, ukprn);
        }

        [Given(@"there are no notifications for UKPRN '(.*)'")]
        public void GivenThereAreNoNotificationsForUKPRN(int ukprn)
        {
            CrmNotificationRepository.DeleteNotificationsThatContainUkprnInText(ukprn.ToString());
        }

        [Given(@"funding claim reconciliation data is present in the CRM funding claim reconciliation tables as follows")]
        public void GivenFundingClaimReconciliationDataIsPresentInTheCrmFundingClaimReconciliationTablesAsFollows(Table table)
        {
            table.Rows.ForEach(row =>
            {
                string ukprn = row["UKPRN"];
                string allocationGroupCode = row["AllocationGroupCode"];
                _fundingClaimReconciliations.Add(new FundingClaimReconciliation
                {
                    AllocationGroup = new AllocationGroup { AllocationGroupCode = allocationGroupCode },
                    Period = new Period { PeriodTypeCode = DtoFundingClaimReconciliation.PeriodTypeCode.AY, PeriodYear = row["FundingPeriod"] },
                    Amounts = new AmountSummary
                    {
                        PlannedValue = Convert.ToDecimal(row["PlannedValue"]),
                        ClaimedValue = Convert.ToDecimal(row["ClaimedValue"]),
                        CappedClaimedValue = Convert.ToDecimal(row["CappedClaimValue"]),
                        ProposedReconciliationValue = Convert.ToDecimal(row["ProposedReconciliationValue"]),
                        ReconciliationValue = Convert.ToDecimal(row["ReconciliationValue"])
                    },
                    ClaimType = new DtoFundingClaimReconciliation.ClaimType
                    {
                        ClaimTypeName = row["FundingClaimType"]
                    },
                    Status = (ReconciliationStatus)Enum.Parse(typeof(ReconciliationStatus), row["Status"]),
                    ClaimVersionNumber = int.Parse(row["ClaimVersionNumber"]),
                    ContractAllocations = new List<ContractAllocation>(),
                    Contractor = new Contractor { UKPRN = int.Parse(ukprn) },
                    StatusLastUpdatedDate = DateTime.UtcNow
                });
            });
        }

        [Given(@"funding claim reconciliation allocation data is present in the CRM funding claim reconciliation allocation tables as follows")]
        public void GivenFundingClaimReconciliationAllocationDataIsPresentInTheCrmFundingClaimReconciliationAllocationTablesAsFollows(Table table)
        {
            table.Rows.ForEach(row =>
            {
                int ukprn = int.Parse(row["UKPRN"]);
                string fundingPeriod = row["FundingPeriod"];
                string fundingClaimType = row["FundingClaimType"];
                string allocGroupCode = row["AllocationGroupCode"];

                FundingClaimReconciliation fundingClaimReconciliation = _fundingClaimReconciliations
                    .Single(x => x.AllocationGroup.AllocationGroupCode == allocGroupCode
                    && x.Contractor.UKPRN == ukprn
                    && x.ClaimType.ClaimTypeName == fundingClaimType
                    && x.Period.PeriodYear == fundingPeriod);

                fundingClaimReconciliation.ContractAllocations.Add(new ContractAllocation
                {
                    ContractAllocationNumber = row["AllocationRef"],
                    //FundingstreamPeriodCode = row[""],
                    AllocationStartDate = DateTime.UtcNow.AddDays(-10),
                    AllocationEndDate = DateTime.UtcNow.AddDays(10),
                    Amounts = new AmountSummary
                    {
                        PlannedValue = Convert.ToDecimal(row["PlannedValue"]),
                        ClaimedValue = Convert.ToDecimal(row["ClaimedValue"]),
                        CappedClaimedValue = Convert.ToDecimal(row["CappedClaimValue"]),
                        ProposedReconciliationValue = Convert.ToDecimal(row["ProposedReconciliationValue"]),
                        ReconciliationValue = Convert.ToDecimal(row["ReconciliationValue"])
                    },
                    Contract = new Contract
                    {
                        ContractNumber = row["ContractNumber"],
                        ContractVersionNumber = int.Parse(row["ContractVersionNumber"]),
                        ContractSubVersionNumber = int.Parse(row["ContractSubVersionNumber"])
                    }
                });
            });

            _fundingClaimReconciliations.ForEach(_performanceManagementPageObject.CreateFundingClaimReconciliationInCrm);
        }

        [Then(@"group claim data is present in the CRM funding claim reconciliation tables as follows")]
        public void ThenGroupClaimDataIsPresentInTheCrmFundingClaimReconciliationTablesAsFollows(Table table)
        {
            foreach (var row in table.Rows)
            {
                string fundingPeriod = row["FundingPeriod"];
                string fundingClaimType = row["FundingClaimType"];
                string allocationGroupCode = row["AllocationGroupCode"];
                string earningsBoost = null;
                try
                {
                    earningsBoost = row["EarningsBoostValue"];
                }
                catch
                {

                }
                sfa_fundingclaimreconciliation expectedFcr = new sfa_fundingclaimreconciliation
                {
                    sfa_ukprn = row["UKPRN"],
                    sfa_ClaimVersionNumber = Convert.ToInt32(row["ClaimVersionNumber"]),
                    sfa_PlannedValue = ParseColumnValue<decimal>(row["PlannedValue"]),
                    sfa_ClaimedValue = ParseColumnValue<decimal>(row["ClaimedValue"]),
                    sfa_ProposedReconciliationValue = ParseColumnValue<decimal>(row["ProposedReconciliationValue"]),
                    SFA_EarningsBoostValue = earningsBoost != null ? ParseColumnValue<decimal>(row["EarningsBoostValue"]) : null,
                    sfa_ReconciliationValue = ParseColumnValue<decimal>(row["ReconciliationValue"]),
                    sfa_CappedClaimedValue = ParseColumnValue<decimal>(row["CappedClaimValue"]),
                    sfa_claimadjustmentvalue = ParseColumnValue<decimal>(row["ClaimAdjustment"]),
                    sfa_adjustedcappedclaimedvalue = ParseColumnValue<decimal>(row["AdjustedCappedClaimValue"]),
                    sfa_StatusCodeEnum = (sfa_sfastatuscode)Enum.Parse(typeof(sfa_sfastatuscode), row["Status"])
                };

                sfa_fundingclaimreconciliation crmFundingclaimreconciliation = null;
                CheckResultPoller checkResultPoller = new CheckResultPoller(() =>
                {
                    crmFundingclaimreconciliation = _performanceManagementPageObject.RetrieveFundingClaimReconciliationFromCrm(fundingPeriod, fundingClaimType, allocationGroupCode, expectedFcr);

                    return crmFundingclaimreconciliation != null && crmFundingclaimreconciliation.sfa_claimadjustmentvalue.GetValueOrDefault() == expectedFcr.sfa_claimadjustmentvalue.GetValueOrDefault();
                }, maxNumChecks:40, waitIntervalSeconds:5);

                checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

                Assert.IsNotNull(crmFundingclaimreconciliation, "Funding claim does not exist in CRM");
                Assert.AreEqual(expectedFcr.sfa_PlannedValue.GetValueOrDefault(), crmFundingclaimreconciliation.sfa_PlannedValue.GetValueOrDefault(), $"Planned value not as expected for allocationGroupCode {allocationGroupCode}");
                Assert.AreEqual(expectedFcr.sfa_ClaimedValue.GetValueOrDefault(), crmFundingclaimreconciliation.sfa_ClaimedValue.GetValueOrDefault(), $"Claimed value not as expected for allocationGroupCode {allocationGroupCode}");
                Assert.AreEqual(expectedFcr.sfa_CappedClaimedValue.GetValueOrDefault(), crmFundingclaimreconciliation.sfa_CappedClaimedValue.GetValueOrDefault(), $"Capped claimed value not as expected for allocationGroupCode {allocationGroupCode}");
                Assert.AreEqual(expectedFcr.sfa_ProposedReconciliationValue.GetValueOrDefault(), crmFundingclaimreconciliation.sfa_ProposedReconciliationValue.GetValueOrDefault(), $"Proposed reconciliation value not as expected for allocationGroupCode {allocationGroupCode}");
                Assert.AreEqual(expectedFcr.sfa_ReconciliationValue.GetValueOrDefault(), crmFundingclaimreconciliation.sfa_ReconciliationValue.GetValueOrDefault(), $"Reconciliation value not as expected for allocationGroupCode {allocationGroupCode}");
                Assert.AreEqual(expectedFcr.sfa_claimadjustmentvalue.GetValueOrDefault(), crmFundingclaimreconciliation.sfa_claimadjustmentvalue.GetValueOrDefault(), $"Claim adjustment value not as expected for allocationGroupCode {allocationGroupCode}");
                Assert.AreEqual(expectedFcr.sfa_adjustedcappedclaimedvalue.GetValueOrDefault(), crmFundingclaimreconciliation.sfa_adjustedcappedclaimedvalue.GetValueOrDefault(), $"Adjusted capped claimed value not as expected for allocationGroupCode {allocationGroupCode}");
            }
        }

        [Then(@"allocation data is present in the CRM funding claim reconciliation tables as follows")]
        public void ThenAllocationDataIsPresentInTheCrmFundingClaimReconciliationTablesAsFollows(Table table)
        {
            foreach (var row in table.Rows)
            {
                string fundingPeriod = row["FundingPeriod"];
                string fundingClaimType = row["FundingClaimType"];
                string allocationGroupCode = row["AllocationGroupCode"];
                string allocationRef = row["AllocationRef"];
                // EarningBoost not required for old test case , so skip to read earnings boost
                string earningsBoost = null;
                try
                {
                    earningsBoost = row["EarningsBoostValue"];
                }
                catch
                {

                }
                sfa_fcrallocation expectedFcra = new sfa_fcrallocation
                {
                    sfa_PlannedValue = ParseColumnValue<decimal>(row["PlannedValue"]),
                    sfa_ClaimedValue = ParseColumnValue<decimal>(row["ClaimedValue"]),
                    sfa_ProposedReconciliationValue = ParseColumnValue<decimal>(row["ProposedReconciliationValue"]),
                    SFA_EarningsBoostValue = earningsBoost != null ? ParseColumnValue<decimal>(row["EarningsBoostValue"]) : null,
                    sfa_ReconciliationValue = ParseColumnValue<decimal>(row["ReconciliationValue"]),
                    sfa_CappedClaimedValue = ParseColumnValue<decimal>(row["CappedClaimValue"]),
                    sfa_claimadjustmentvalue = ParseColumnValue<decimal>(row["ClaimAdjustment"]),
                    sfa_adjustedcappedclaimedvalue = ParseColumnValue<decimal>(row["AdjustedCappedClaimValue"]),
                    sfa_claimadjustmentreason = row.ParseNullableOptionSetValue<sfa_ClaimAdjustmentReason>("ClaimAdjustmentReason")
                };

                sfa_fcrallocation crnFcra = _performanceManagementPageObject.RetrieveFundingClaimReconciliationAllocationFromCrm(fundingPeriod, fundingClaimType, allocationGroupCode, allocationRef, expectedFcra);

                Assert.IsNotNull(crnFcra, $"Funding Claim Reconciliation Allocation record not found in CRM. Alloc: {allocationRef}");
                Assert.AreEqual(expectedFcra.sfa_PlannedValue.GetValueOrDefault(), crnFcra.sfa_PlannedValue.GetValueOrDefault(), $"Planned value incorrect for allocation: {allocationRef}.");
                Assert.AreEqual(expectedFcra.sfa_ClaimedValue.GetValueOrDefault(), crnFcra.sfa_ClaimedValue.GetValueOrDefault(), $"Claimed value incorrect for allocation: {allocationRef}.");
                Assert.AreEqual(expectedFcra.sfa_CappedClaimedValue.GetValueOrDefault(), crnFcra.sfa_CappedClaimedValue.GetValueOrDefault(), $"Capped claimed value incorrect for allocation: {allocationRef}.");
                Assert.AreEqual(expectedFcra.sfa_ProposedReconciliationValue.GetValueOrDefault(), crnFcra.sfa_ProposedReconciliationValue.GetValueOrDefault(), $"Proposed reconciliation value incorrect for allocation: {allocationRef}.");
                Assert.AreEqual(expectedFcra.sfa_ReconciliationValue.GetValueOrDefault(), crnFcra.sfa_ReconciliationValue.GetValueOrDefault(), $"Reconciliation value incorrect for allocation: {allocationRef}.");
                Assert.AreEqual(expectedFcra.sfa_claimadjustmentvalue.GetValueOrDefault(), crnFcra.sfa_claimadjustmentvalue.GetValueOrDefault(), $"Claim adjustment value incorrect for allocation: {allocationRef}");
                Assert.AreEqual(expectedFcra.sfa_adjustedcappedclaimedvalue.GetValueOrDefault(), crnFcra.sfa_adjustedcappedclaimedvalue.GetValueOrDefault(), $"Adjusted capped claimed value incorrect for allocation: {allocationRef}");
                Assert.AreEqual(expectedFcra.sfa_claimadjustmentreason, crnFcra.sfa_claimadjustmentreason, $"Adjusted claim adjustment reason incorrect for allocation: {allocationRef}");
            }
        }

        [Then(@"deliverable data is present in the CRM funding claim reconciliation tables as follows")]
        public void ThenDeliverableDataIsPresentInTheCrmFundingClaimReconciliationTablesAsFollows(Table table)
        {
            foreach (var row in table.Rows)
            {
                string fundingPeriod = row["FundingPeriod"];
                string fundingClaimType = row["FundingClaimType"];
                string allocationRef = row["AllocationRef"];
                int deliverableCode = int.Parse(row["DeliverableCode"]);
                decimal plannedValue = decimal.Parse(row["PlannedValue"]);
                decimal claimedValue = decimal.Parse(row["ClaimedValue"]);

                var deliverable = _performanceManagementPageObject.GetFundingClaimReconciliationAllocationDeliverable(fundingPeriod,
                    fundingClaimType, allocationRef, deliverableCode);

                Assert.AreEqual(plannedValue, deliverable.sfa_PlannedValue);
                Assert.AreEqual(claimedValue, deliverable.sfa_ClaimedValue);
            }
        }

        [Given(@"there is no data in the funding claim stub or PAAS tables for the following claim type and period")]
        [Given(@"there is no data in the DEDS stub or PAAS tables for the following claim type and period")]
        public void GivenThereIsNoDataInTheFundingClaimStubForTheFollowingClaimTypeAndPeriod(Table table)
        {
            FundingClaimStubRepository.DeleteAllRows();
            FundingClaimApiStubRepository.DeleteAllRows();

            foreach (var row in table.Rows)
            {
                _currentScenarioClaimTypeInfos.Add(new ClaimTypeInfo(row["ClaimTypeName"], row["Period"]));
                _performanceManagementPageObject.ClearFundingClaimDataFromPaasTables(row["ClaimTypeName"], row["Period"]);
            }
        }

        [Given(@"there is no data in PAAS tables for the following claim type and period")]
        public void GivenThereIsNoDataInPAASTablesForTheFollowingClaimTypeAndPeriod(Table table)
        {
            foreach (var row in table.Rows)
            {
                _currentScenarioClaimTypeInfos.Add(new ClaimTypeInfo(row["ClaimTypeName"], row["Period"]));
                _performanceManagementPageObject.ClearFundingClaimDataFromPaasTables(row["ClaimTypeName"], row["Period"]);
            }
        }

        [Given(@"there isn't any FCR data in the DEDS stub")]
        public void GivenThereIsnTAnyFCRDataInTheFundingClaimsStub()
        {
            FundingClaimStubRepository.DeleteAllRows();
            FundingClaimApiStubRepository.DeleteAllRows();
        }

        [Given(@"funding claim data is present in the funding claim stub as follows")]
        [Given(@"funding claim data is present in the DEDS stub as follows")]
        public void GivenFundingClaimDataIsPresentInTheFundingClaimStubAsFollows(Table table)
        {
            foreach (var row in table.Rows)
            {
                _performanceManagementPageObject.CreateFundingClaim(row["OrganisationId"], int.Parse(row["UKPRN"]), int.Parse(row["ClaimVersionNumber"]), row["ClaimTypeName"], row["PeriodTypeCode"],
                    row["Period"], row["HasBeenSigned"] != "False");
            }
        }

        [Given(@"allocation data is present in the funding claim stub as follows")]
        [Given(@"allocation data is present in the DEDS stub as follows")]
        public void GivenAllocationDataIsPresentInTheFundingClaimStubAsFollows(Table table)
        {
            foreach (var row in table.Rows)
            {
                Pages.FundingClaimNaturalKey fcNaturalKey = new Pages.FundingClaimNaturalKey
                {
                    ClaimTypeName = row["ClaimTypeName"],
                    OrganisationIdentifier = row["OrganisationId"],
                    PeriodTypeCode = row["PeriodTypeCode"],
                    Period = row["Period"],
                    VersionNumber = int.Parse(row["ClaimVersionNumber"])
                };

                FundingClaimAllocationNaturalKey allocationNaturalKey = new FundingClaimAllocationNaturalKey
                {
                    ContractAllocationNumber = row["AllocationRef"],
                    FundingClaimNaturalKey = fcNaturalKey
                };

                _performanceManagementPageObject.CreateFundingClaimAllocation(allocationNaturalKey, row["FundingStreamPeriodCode"]);
            }
        }

        [Given(@"deliverable data is present in the funding claim stub as follows")]
        [Given(@"deliverable data is present in the DEDS stub as follows")]
        public void GivenDeliverableDataIsPresentInTheFundingClaimStubAsFollows(Table table)
        {
            foreach (var row in table.Rows)
            {
                Pages.FundingClaimNaturalKey fcNaturalKey = new Pages.FundingClaimNaturalKey
                {
                    ClaimTypeName = row["ClaimTypeName"],
                    OrganisationIdentifier = row["OrganisationId"],
                    PeriodTypeCode = row["PeriodTypeCode"],
                    Period = row["Period"],
                    VersionNumber = int.Parse(row["ClaimVersionNumber"])
                };

                FundingClaimAllocationNaturalKey allocationNaturalKey = new FundingClaimAllocationNaturalKey
                {
                    ContractAllocationNumber = row["AllocationRef"],
                    FundingClaimNaturalKey = fcNaturalKey
                };

                _performanceManagementPageObject.CreateFundingClaimDeliverable(allocationNaturalKey,
                    int.Parse(row["DeliverableCode"]), decimal.Parse(row["ActualValue"]),
                    decimal.Parse(row["ForecastValue"]), decimal.Parse(row["AdjustmentValue"]),
                    decimal.Parse(row["TotalValue"]));
            }
            _performanceManagementPageObject.CreateFundingClaimUnderTestInAzureTableStorage();
        }

        [When(@"data is retrieved from the DEDS stub and is consumed")]
        public void WhenDataIsRetrievedFromTheDedsStubForPeriodAndClaimTypeAndIsConsumed()
        {
            InitiateFundingClaimImportCommand command = new InitiateFundingClaimImportCommand();
            MessageSendingBus.Send("PerformanceManagementDomain.FundingClaimImport", command);
        }

        [When(@"data is retrieved from the SLD stub and is consumed")]
        public void WhenDataIsRetrievedFromTheSldStubForPeriodAndClaimTypeAndIsConsumed()
        {
            BeginFundingClaimPullCommand command = new BeginFundingClaimPullCommand();
            MessageSendingBus.Send("PerformanceManagementDomain.PullFundingClaim", command);
        }

        [Given(@"the following debatched funding claims are received")]
        public void GivenTheFollowingDebatchedFundingClaimsAreReceived(Table table)
        {
            foreach (var row in table.Rows)
            {
                DtoFundingClaim.Contractor contractor = new DtoFundingClaim.Contractor { Ukprn = Convert.ToInt32(row["UKPRN"]) };

                DtoFundingClaim.DebatchedFundingClaim debatchedFundingClaim = new DtoFundingClaim.DebatchedFundingClaim
                {
                    Contractor = contractor,
                    ClaimTypeName = (DtoFundingClaim.ClaimTypeName)Enum.Parse(typeof(DtoFundingClaim.ClaimTypeName), row["ClaimTypeName"]),
                    AllocationGroupCode = row["AllocationGroupCode"],
                    VersionNumber = Convert.ToInt32(row["ClaimVersion"]),
                    Period = row["Period"],
                    PeriodTypeCode = (DtoFundingClaim.PeriodTypeCode)Enum.Parse(typeof(DtoFundingClaim.PeriodTypeCode), row["PeriodType"])
                };

                _debatchedFundingClaims.Add(debatchedFundingClaim);
            }
        }

        [Given(@"the following funding claim allocations exist")]
        public void GivenTheFollowingFundingClaimAllocations(Table table)
        {
            foreach (var row in table.Rows)
            {
                DtoFundingClaim.DebatchedFundingClaim debatchedFundingClaim = _debatchedFundingClaims.Single(x => x.Contractor.Ukprn == Convert.ToInt32(row["UKPRN"])
                                                                                            && x.VersionNumber == Convert.ToInt32(row["ClaimVersion"])
                                                                                            && x.ClaimTypeName == (DtoFundingClaim.ClaimTypeName)Enum.Parse(typeof(DtoFundingClaim.ClaimTypeName), row["ClaimTypeName"].ToUpper())
                                                                                            && x.Period == row["Period"]
                                                                                            && x.AllocationGroupCode == row["AllocationGroupCode"]);

                _performanceManagementPageObject.CreateContractAllocationInStorage(CreateFcrContractAllocationFromRow(row));

                DtoFundingClaim.ContractAllocation contractAllocation = new DtoFundingClaim.ContractAllocation
                {
                    ContractAllocationNumber = row["AllocationRef"],
                    FundingStreamPeriodCode = row["FundingStreamPeriodCode"]
                };

                debatchedFundingClaim.ContractAllocations.Add(contractAllocation);
            }
        }

        [Given(@"the following funding claim deliverables exist")]
        public void GivenTheFollowingFundingClaimDeliverables(Table table)
        {
            List<DtoFundingClaim.ContractAllocation> allocations = _debatchedFundingClaims.SelectMany(fc => fc.ContractAllocations).ToList();

            foreach (var r in table.Rows)
            {
                DtoFundingClaim.ContractAllocation contractAllocation = allocations.Single(a => a.FundingStreamPeriodCode == r["FundingStreamPeriodCode"]
                                                                                && a.ContractAllocationNumber == r["AllocationRef"]);

                DtoFundingClaim.DeliverableLine deliverableLine = new DtoFundingClaim.DeliverableLine
                {
                    DeliverableCode = Convert.ToInt32(r["DeliverableCode"]),
                    ActualValue = Convert.ToDecimal(r["ActualValue"]),
                    ForecastValue = Convert.ToDecimal(r["ForecastValue"]),
                    AdjustmentValue = Convert.ToDecimal(r["AdjustmentValue"]),
                    PlannedValue = Convert.ToDecimal(r["PlannedValue"]),
                    ParentPlannedValue = Convert.ToDecimal(r["ParentPlannedValue"]),
                    TotalDelivery = Convert.ToDecimal(r["TotalDelivery"])
                };

                contractAllocation.DeliverableLines.Add(deliverableLine);
            }
            allocations.ForEach(a =>
            {
                var profileDeliverableCodes = Infrastructure.Repositories.FspDeliverableClaimRepository.GetProfileDeliverableCodes(a.FundingStreamPeriodCode);
                var deliverableLinesWithProfile =
                    a.DeliverableLines.Where(dl => profileDeliverableCodes.Contains(dl.DeliverableCode)).ToList();

                decimal? plannedValueForAllocation = 0;
                if (deliverableLinesWithProfile.Any())
                {
                    plannedValueForAllocation = deliverableLinesWithProfile
                        .Sum(dl => dl.PlannedValue);
                }
                if (plannedValueForAllocation == 0)
                {
                    // we need this because we have not specified the profile deliverable or we have but the planned value is not set
                    plannedValueForAllocation =
                        a.DeliverableLines.Select(dl => dl.ParentPlannedValue).Distinct().Sum();
                }

                a.PlannedValueAggregation = plannedValueForAllocation;
            });
        }

        [When(@"the funding claim reconciliation calculation is run")]
        public void WhenTheFundingClaimReconciliationCalculationIsRun()
        {
           
            IClaimReconciliationBehaviourRepository claimReconciliationBehaviourRepository = new ClaimReconciliationBehaviourRepository();
            var fspDelClaimRepo = new FspDeliverableClaimRepository();
            IContractAllocationRepository contractAllocationRepoMock = new ContractAllocationRepository();

            IClaimReconciliationAllocationGroupRepository claimAllocGroupRepo = new ClaimReconciliationAllocationGroupRepository();
            IClaimTypeRepository claimTypeRepo = new ClaimTypeRepository();
            IClaimReferenceProfileRepository claimReferenceProfileRepository = new ClaimReferenceProfileRepository();
            DeliverableGroupAmountSummaryCreator deliverableGroupAmountSummaryCreator = new DeliverableGroupAmountSummaryCreator(claimReferenceProfileRepository);

            CalculationService calculationService = new CalculationService(
                claimReconciliationBehaviourRepository,
                fspDelClaimRepo,
                contractAllocationRepoMock,
                claimAllocGroupRepo,
                claimTypeRepo,
                deliverableGroupAmountSummaryCreator);

            foreach (var debatchedFundingClaim in _debatchedFundingClaims)
            {
                using (var context = new PerformanceManagementDbContext())
                {
                    FundingClaimReconciliation fundingClaimReconciliation = calculationService
                        .Calculate(debatchedFundingClaim, new ConnectionInfo(null, context.Database.Connection)).Result;
                        
                    _fundingClaimReconciliations.Add(fundingClaimReconciliation);
                }
            }
        }

        [Then(@"group claim data is present in the calculated funding claim reconciliations as follows")]
        public void ThenGroupClaimDataIsPresentInTheCalculatedFundingClaimReconciliationsAsFollows(Table table)
        {
            foreach (var r in table.Rows)
            {
                FundingClaimReconciliation fundingClaimReconciliation = _fundingClaimReconciliations.Single(x => x.Contractor.UKPRN == Convert.ToInt32(r["UKPRN"])
                                                                                                                 && x.Period.PeriodYear == r["FundingPeriod"]
                                                                                                                 && x.ClaimType.ClaimTypeName.ToUpper() == r["ClaimTypeName"].ToUpper()
                                                                                                                 && x.AllocationGroup.AllocationGroupCode == r["AllocationGroupCode"]);
                AmountSummary reconciliationAmountSummary = fundingClaimReconciliation.Amounts;

                decimal expectedPlannedValue = Convert.ToDecimal(r["PlannedValue"]);
                decimal expectedClaimedValue = Convert.ToDecimal(r["ClaimedValue"]);
                decimal expectedCappedClaimedValue = Convert.ToDecimal(r["CappedClaimValue"]);
                decimal expectedProposedReconciliationValue = Convert.ToDecimal(r["ProposedReconciliationValue"]);
                decimal expectedReconciliationValue = Convert.ToDecimal(r["ReconciliationValue"]);

                StringBuilder allocationString = new StringBuilder();

                fundingClaimReconciliation.ContractAllocations.ForEach(
                    x => allocationString.Append(x.ContractAllocationNumber + ", "));

                Debug.WriteLine($"Testing allocations {allocationString} UKPRN: {r["UKPRN"]}, FundingPeriod: {r["FundingPeriod"]}, ClaimTypeName: {r["ClaimTypeName"]}, AllocationGroupCode: {r["AllocationGroupCode"]}.");

                Assert.AreEqual(expectedPlannedValue, reconciliationAmountSummary.PlannedValue, "PlannedValue mismatch");
                Assert.AreEqual(expectedClaimedValue, reconciliationAmountSummary.ClaimedValue, "ClaimedValue mismatch");
                Assert.AreEqual(expectedCappedClaimedValue, reconciliationAmountSummary.CappedClaimedValue, "CappedClaimedValue mismatch");
                Assert.AreEqual(expectedProposedReconciliationValue, reconciliationAmountSummary.ProposedReconciliationValue, "ProposedReconciliationValue mismatch");


                // Do we need see values on reconciliation or just proposed reconciliation.
                Assert.AreEqual(expectedReconciliationValue, reconciliationAmountSummary.ReconciliationValue.GetValueOrDefault(), "ReconciliationValue mismatch");

                Debug.WriteLine($"UKPRN: {r["UKPRN"]}, FundingPeriod: {r["FundingPeriod"]}, ClaimTypeName: {r["ClaimTypeName"]}, AllocationGroupCode: {r["AllocationGroupCode"]} success.");
            }
        }

        [Then(@"allocation data is present in the calculated funding claim reconciliations as follows")]
        public void ThenAllocationDataIsPresentInTheCalculatedFundingClaimReconciliationsAsFollows(Table table)
        {
            foreach (var r in table.Rows)
            {
                ContractAllocation contractAllocation = _fundingClaimReconciliations
                    .SelectMany(x => x.ContractAllocations)
                    .Single(a => a.ContractAllocationNumber == r["AllocationRef"]);

                AmountSummary allocationAmountSummary = contractAllocation.Amounts;

                Debug.WriteLine($"Testing allocation {r["AllocationRef"]}.");

                decimal expectedPlannedValue = Convert.ToDecimal(r["PlannedValue"]);
                decimal expectedClaimedValue = Convert.ToDecimal(r["ClaimedValue"]);
                decimal expectedCappedClaimedValue = Convert.ToDecimal(r["CappedClaimValue"]);
                decimal expectedProposedReconciliationValue = Convert.ToDecimal(r["ProposedReconciliationValue"]);
                decimal expectedReconciliationValue = Convert.ToDecimal(r["ReconciliationValue"]);

                Assert.AreEqual(expectedPlannedValue, allocationAmountSummary.PlannedValue, "PlannedValue mismatch");
                Assert.AreEqual(expectedClaimedValue, allocationAmountSummary.ClaimedValue, "ClaimedValue mismatch");
                Assert.AreEqual(expectedCappedClaimedValue, allocationAmountSummary.CappedClaimedValue, "CappedClaimedValue mismatch");
                Assert.AreEqual(expectedProposedReconciliationValue, allocationAmountSummary.ProposedReconciliationValue, "ProposedReconciliationValue mismatch");

                // Do we need see values on reconciliation or just proposed reconciliation.
                Assert.AreEqual(expectedReconciliationValue, allocationAmountSummary.ReconciliationValue.GetValueOrDefault(), "ReconciliationValue mismatch");

                Debug.WriteLine($"Allocation {r["AllocationRef"]} success.");
            }
        }

        [When(@"the following funding claim reconciliations are changed to Publish in Progress")]
        public void WhenTheStatusOfTheFollowingFundingClaimReconciliationsAreSetTo(Table table)
        {
            table.Rows.ForEach(r =>
            {
                _performanceManagementPageObject.RunWorkflow22InitiatePublishForFundingClaimReconciliation(
                    new FundingClaimReconciliationNaturalKey(r["UKPRN"], r["FundingPeriod"], r["FundingClaimType"], r["AllocationGroupCode"], int.Parse(r["ClaimVersionNumber"])));
            });
        }

        [Then(@"the following funding claim reconciliations will have a status of '(.*)'")]
        public void ThenTheStatusOfTheFollowingFundingClaimReconciliationsAreSetTo(string expectedStatus, Table table)
        {
            IEnumerable<FundingClaimReconciliationNaturalKey> fundingClaimReconciliationNaturalKeys =
                table.Rows
                .Select(r => new FundingClaimReconciliationNaturalKey(r["UKPRN"], r["FundingPeriod"], r["FundingClaimType"], r["AllocationGroupCode"], int.Parse(r["ClaimVersionNumber"])));

            bool areAllFundingClaimReconciliationsInExpectedStatus =
                _performanceManagementPageObject.AreAllGivenFundingClaimReconciliationsInGivenStatus(fundingClaimReconciliationNaturalKeys, expectedStatus);

            Assert.IsTrue(areAllFundingClaimReconciliationsInExpectedStatus, $"Not all Funding Claim Reconciliations were set to '{expectedStatus}'");
        }

        [Then(@"the following funding claim reconciliations will have a status '(.*)' and a sub status '(.*)'")]
        public void ThenTheFollowingFundingClaimReconciliationsWillHaveAStatusAndASubStatusOf(string expectedStatus, SubStatus expectedSubStatus, Table table)
        {
            IEnumerable<FundingClaimReconciliationNaturalKey> fundingClaimReconciliationNaturalKeys =
                table.Rows
                .Select(r => new FundingClaimReconciliationNaturalKey(r["UKPRN"], r["FundingPeriod"], r["FundingClaimType"], r["AllocationGroupCode"], int.Parse(r["ClaimVersionNumber"])));

            sfa_sfastatuscode expectedStatusCode = (sfa_sfastatuscode)Enum.Parse(typeof(sfa_sfastatuscode), expectedStatus);
            string expectedSubStatusCodeSanitized =
                expectedSubStatus.GetSanitizedString();

            sfa_sfasubstatuscode expectedSubStatusCode = (sfa_sfasubstatuscode)Enum.Parse(typeof(sfa_sfasubstatuscode), expectedSubStatusCodeSanitized);

            fundingClaimReconciliationNaturalKeys.ForEach(key =>
            {
                CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: () =>
                {
                    sfa_fundingclaimreconciliation fundingClaimReconciliation = _performanceManagementPageObject.GetFundingClaimReconcilationByNaturalKey(key);

                    return fundingClaimReconciliation != null &&
                           fundingClaimReconciliation.sfa_StatusCodeEnum == expectedStatusCode &&
                           fundingClaimReconciliation.sfa_substatusEnum == expectedSubStatusCode;
                },
                maxNumChecks: 20,
                waitIntervalSeconds: 5);

                bool isPresent = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();
                Assert.IsTrue(isPresent, $"We have not found Funding Claim Reconciliation {key} - with status '{expectedStatus}' and subStatus '{expectedSubStatus}'");
            });
        }

        [Then(@"the PerformanceManagement\.AtomFeed contains ItemType '(.*)' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims")]
        [Then(@"the PerformanceManagement\.AtomFeedItem contains ItemType '(.*)' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims")]
        public void ThenThePerformanceManagement_AtomFeedContainsItemTypeEventsWhichConformToTheCorporateFundingClaimReconciliationSchemaForTheFollowingClaims(int itemType, Table table)
        {
            IReadOnlyCollection<PerformanceManagementAtomFeedItemBusinessKey> performanceManagementAtomFeedItemBusinessKeys =
                table.Rows
                .Select(r => new PerformanceManagementAtomFeedItemBusinessKey(
                    ukprn: int.Parse(r["UKPRN"]),
                    period: r["FundingPeriod"],
                    claimTypeName: r["FundingClaimType"],
                    itemType: itemType,
                    allocationGroupCode: r["AllocationGroupCode"])).ToList();

            bool areAllFundingClaimReconciliationsValidOnTheFeed =
               _performanceManagementPageObject.AreAllFundingClaimReconciliationsValidOnTheFeed(performanceManagementAtomFeedItemBusinessKeys);

            Assert.IsTrue(areAllFundingClaimReconciliationsValidOnTheFeed, "Not all Funding Claim Reconciliations are valid on the feed");
        }

        [Then(@"the PerformanceManagement\.AtomFeed does not contain events with ItemType '(.*)' for the following claims")]
        public void ThenThePerformanceManagement_AtomFeedDoesNotContainEventsWithItemTypeForTheFollowingClaims(int itemType, Table table)
        {
            IReadOnlyCollection<PerformanceManagementAtomFeedItemBusinessKey> performanceManagementAtomFeedItemBusinessKeys =
               table.Rows
               .Select(r => new PerformanceManagementAtomFeedItemBusinessKey(
                   ukprn: int.Parse(r["UKPRN"]),
                   period: r["FundingPeriod"],
                   claimTypeName: r["FundingClaimType"],
                   itemType: itemType,
                   allocationGroupCode: r["AllocationGroupCode"])).ToList();

            bool areAllFundingClaimReconciliationsNotOnTheFeed =
               _performanceManagementPageObject.AreAllFundingClaimReconciliationsNotOnTheFeed(performanceManagementAtomFeedItemBusinessKeys);

            Assert.IsTrue(areAllFundingClaimReconciliationsNotOnTheFeed, "There are one or more Funding Claim Reconciliations on the feed that should not be");
        }

        [When(@"the reconciliation values on the CRM funding claim allocations are amended as follows")]
        public void WhenTheReconciliationValuesOnTheCrmFundingClaimAllocationsAreAmendedAsFollows(Table table)
        {
            string[] suppressedErrors = {
                "Cannot update this FCR Allocation since its associated Funding Claim Reconciliation is being recalculated",
                "Cannot update this FCR Allocation since a Claim Adjustment Reason is required when a non-zero Claim Adjustment Value is specified",
                "Cannot update this FCR Allocation since a Claim Adjustment Reason is only allowed if a non-zero Claim Adjustment Value has been specified"
            };

            table.Rows.ForEach(row =>
            {
                string contractAllocationNumber = row["AllocationRef"];
                string periodYear = row["FundingPeriod"];
                string claimTypeCode = row["FundingClaimType"];
                string allocationGroupCode = row["AllocationGroupCode"];
                decimal reconciliationValue = row.ParseDecimal("ReconciliationValue");
                decimal earningsboostValue = row.ParseDecimal("EarningsBoostValue");
                decimal claimAdjustment = row.ParseDecimal("ClaimAdjustment");
                OptionSetValue claimAdjustmentReason = row.ParseNullableOptionSetValue<sfa_ClaimAdjustmentReason>("ClaimAdjustmentReason");

                try
                {
                    CrmFundingClaimReconciliationAllocationRepository.SetUserEditableValues(
                        contractAllocationNumber,
                        periodYear,
                        claimTypeCode,
                        allocationGroupCode,
                        reconciliationValue,
                        earningsboostValue,
                        claimAdjustment,
                        claimAdjustmentReason);

                }
                catch (System.ServiceModel.FaultException<Microsoft.Xrm.Sdk.OrganizationServiceFault> ex) when (suppressedErrors.Contains(ex.Message))
                {
                    // error is acceptable when simulating invalid export/import operations in CRM which we will check for in subsequent steps
                }
            });
        }

        [Then(@"the override date is before the Publication Close Date for Claim Reconciliation Code '(.*)' and Allocation Group Code '(.*)'")]
        public void ThenTheOverrideDateIsBeforeThePublicationCloseDateForClaimReconciliationCodeAndAllocationGroupCode(string claimReconciliationCode, string allocationGroupCode)
        {
            Assert.IsTrue(
                _performanceManagementPageObject
                    .IsOverrideDateBeforePublicationCloseDateForClaimReconciliationAndAllocGroup
                    (claimReconciliationCode, allocationGroupCode),
                "The override date is not before the publication close date.");
        }

        [Then(@"the override date is after the Publication Close Date for Claim Reconciliation Code '(.*)' and Allocation Group Code '(.*)'")]
        public void ThenTheOverrideDateIsAfterThePublicationCloseDateForClaimReconciliationCodeAndAllocationGroupCode(string claimReconciliationCode, string allocationGroupCode)
        {
            Assert.IsFalse(
                _performanceManagementPageObject
                    .IsOverrideDateBeforePublicationCloseDateForClaimReconciliationAndAllocGroup
                    (claimReconciliationCode, allocationGroupCode),
                "The override date is before the publication close date.");
        }

        [Given("the following profile values exist in config")]
        public void GivenTheFollowingProfileValuesExistInConfig(Table table)
        {
            foreach (var row in table.Rows)
            {
                ClaimReconciliationReferenceProfileRepository.AddOrUpdateProfile(
                    row["ClaimReconciliationDeliverableGroupCode"],
                    int.Parse(row["UKPRN"]),
                    decimal.Parse(row["PlannedValue"]));
            }
        }

        [Then(@"there are no profile values in config for the following UKPRNs")]
        public void ThenThereAreNoProfileValuesInConfigForTheFollowingUKPRNs(Table table)
        {
            IReadOnlyCollection<int> ukprnsToRemove = table.Rows
                .Select(row => int.Parse(row["UKPRN"]))
                .ToList();

            ClaimReconciliationReferenceProfileRepository.RemoveByUkprns(ukprnsToRemove);
            FcrPublicationExceptionRepository.RemoveByUkprns(ukprnsToRemove);
        }

        [Given(@"the following details are on the PerformanceManagement.ClaimReconciliationPublicationException table")]
        public void GivenPublishingTheFollowingUkprnsAndFundingPeriodsWillNotResultInAnItemOnTheAtomFeed(Table table)
        {
            table.Rows.ForEach(r => FcrPublicationExceptionRepository.UpsertPublicationException(r["AllocationGroupCode"], int.Parse(r["UKPRN"])));
        }

        [Given(@"the following funding claim reconciliations have been put on hold")]
        public void GivenTheFollowingFundingClaimReconciliationsHaveBeenPutOnHold(Table table)
        {
            table.Rows.ForEach(r =>
                CrmFundingClaimReconciliationRepository.SetFundingClaimReconciliationStatusAndSubstatus(
                    r["UKPRN"],
                    r["FundingPeriod"],
                    r["FundingClaimType"],
                    r["AllocationGroupCode"],
                    int.Parse(r["ClaimVersionNumber"]),
                    sfa_sfastatuscode.Draft, 
                    sfa_sfasubstatuscode.Held));
        }

        [Given(@"the following funding claim reconciliations have been taken off hold")]
        public void GivenTheFollowingFundingClaimReconciliationsHaveBeenTakenOffHold(Table table)
        {
            table.Rows.ForEach(r =>
                CrmFundingClaimReconciliationRepository.SetFundingClaimReconciliationStatusAndSubstatus(
                    r["UKPRN"],
                    r["FundingPeriod"],
                    r["FundingClaimType"],
                    r["AllocationGroupCode"],
                    int.Parse(r["ClaimVersionNumber"]),
                    sfa_sfastatuscode.Draft,
                    sfa_sfasubstatuscode.Draft));
        }

        [Given(@"the following Funding Claim Reconciliations have a status of '(.*)' and a substatus of '(.*)'")]
        public void GivenTheFollowingFundingClaimReconciliationsHaveAStatusOfAndASubstatusOf(string status, SubStatus subStatus, Table table)
        {
            table.Rows.ForEach(row =>
            {
                string subStatusCodeSanitized = subStatus.GetSanitizedString();
                    
                CrmFundingClaimReconciliationRepository.SetFundingClaimReconciliationStatusAndSubstatus(
                    row["UKPRN"],
                    row["FundingPeriod"],
                    row["FundingClaimType"],
                    row["AllocationGroupCode"],
                    row.ParseInt("ClaimVersionNumber"),
                    (sfa_sfastatuscode)Enum.Parse(typeof(sfa_sfastatuscode), status),
                    (sfa_sfasubstatuscode)Enum.Parse(typeof(sfa_sfasubstatuscode), subStatusCodeSanitized));
            });
        }

        [Given(@"there is no data in the PerformanceManagement\.ContractAllocation or ContractAllocationDeliverable tables for the following providers")]
        public void GivenThereIsNoDataInThePerformanceManagement_ContractAllocationOrContractAllocationDeliverableTablesForTheFollowingProviders(Table table)
        {
            table.Rows.ForEach(row => PerformanceManagementContractAllocationRepository.DeleteByUkprn(int.Parse(row["UKPRN"])));
        }

        [Then(@"the following profile values are present in the PerformanceManagement\.ContractAllocation and ContractAllocationDeliverable tables")]
        public void ThenTheFollowingProfileValuesArePresentInThePerformanceManagement_ContractAllocationAndContractAllocationDeliverableTables(Table table)
        {
            table.Rows.ForEach(row =>
            {
                string allocationNumber = row["AllocationRef"];
                int ukprn = int.Parse(row["UKPRN"]);
                string contractNumber = row["ContractNumber"];
                int versionNumber = int.Parse(row["VersionNo"]);
                int deliverableCode = int.Parse(row["DeliverableCode"]);
                decimal plannedValue = decimal.Parse(row["PlannedValue"]);

                PMEFModel.ContractAllocation allocation = null;

                CheckResultPoller poller = new CheckResultPoller( 
                    checkResult: () =>
                    {
                        allocation = PerformanceManagementContractAllocationRepository.Find(allocationNumber);
                        return allocation != null;
                    },
                    maxNumChecks: 10,
                    waitIntervalSeconds: 2);

                poller.CheckResultAndWaitTillCompleteOrOutOfTime();
                
                Assert.IsNotNull(allocation, $"Allocation {allocationNumber} not found in PerformanceManagement.ContractAllocation table");
                Assert.AreEqual(ukprn, allocation.Contractor.UKPRN, $"Incorrect UKPRN for Allocation {allocationNumber}");
                Assert.AreEqual(contractNumber, allocation.Contract.ContractNumber, $"Incorrect ContractNumber for Allocation {allocationNumber}");
                Assert.AreEqual(versionNumber, allocation.Contract.VersionNumber, $"Incorrect VersionNumber for Allocation {allocationNumber}");

                ContractAllocationDeliverable deliverable = allocation.ContractAllocationDeliverables.SingleOrDefault(d => d.DeliverableCode == deliverableCode);
                Assert.IsNotNull(deliverable, $"Deliverable {deliverableCode} not found for Allocation {allocationNumber} not found in PerformanceManagement.ContractAllocationDeliverable table");
                Assert.AreEqual(plannedValue, deliverable.PlannedValue, $"Incorrect PlannedValue for Deliverable {deliverableCode}, Allocation {allocationNumber}");
            });
        }

        [Then(@"the Performance Management atom feed contains the following item type (.*) events and values")]
        [Then(@"the PerformanceManagement\.AtomFeed contains the following item type (.*) events and values")]
        public void ThenThePerformanceManagementAtomFeedContainsTheFollowingItemTypeEventsAndValues(int itemType, Table table)
        {
            table.Rows.ForEach(row =>
            {
                int ukprn = int.Parse(row["UKPRN"]);
                string claimTypeName = row["ClaimTypeName"];
                string allocationGroupName = row["AllocationGroupName"];
                string period = row["Period"];
                string atomFeedItemDescription = $"Ukprn: {ukprn}, ClaimTypeName: {claimTypeName}, AllocationGroupName: {allocationGroupName}, Period: {period}";

                AtomFeedItem atomFeedItem = null;

                CheckResultPoller poller = new CheckResultPoller(() =>
                {
                    atomFeedItem = PerformanceManagementAtomFeedItemRepository.FindByNaturalKey(ukprn, claimTypeName, allocationGroupName, period);
                    return atomFeedItem != null;
                }, maxNumChecks: 10, waitIntervalSeconds: 1);

                poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                Assert.IsNotNull(atomFeedItem, $"No matching atom feed item for {atomFeedItemDescription}");
                Assert.AreEqual(itemType, (int)atomFeedItem.ItemType, $"Atom feed item not of type {itemType} for {atomFeedItemDescription}");

                FCReconciliation corporateFcr = atomFeedItem.AtomFeedItemXml.DeserializeXml<FCReconciliation>();
                ContractAllocationAllAttrsCT corporateAllocation = corporateFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.ContractAllocation.SingleOrDefault(a => a.ContractAllocationPKeyAttrs.ContractAllocationNumber == row["AllocationNumber"]);

                Assert.IsNotNull(corporateAllocation, $"Allocation Number {row["AllocationNumber"]} not found in atom feed item {atomFeedItemDescription}");

                Assert.AreEqual(
                    decimal.Parse(row["PlannedValue"]),
                    corporateFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.PlannedValue,
                    $"PlannedValue not correct for atom feed item {atomFeedItemDescription}");

                Assert.AreEqual(
                    decimal.Parse(row["ClaimedValue"]),
                    corporateFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.ClaimedValue,
                    $"ClaimedValue not correct for atom feed item {atomFeedItemDescription}");

                Assert.AreEqual(
                    decimal.Parse(row["ProposedReconciliationValue"]),
                    corporateFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.ProposedReconciliationValue,
                    $"ProposedReconciliationValue not correct for atom feed item {atomFeedItemDescription}");

                Assert.AreEqual(
                    decimal.Parse(row["FinalReconciliationValue"]),
                    corporateFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.ReconciliationValue,
                    $"FinalReconciliationValue not correct for atom feed item {atomFeedItemDescription}");

                Assert.AreEqual(
                    decimal.Parse(row["CappedClaimedValue"]),
                    corporateFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.CappedClaimedValue,
                    $"CappedClaimedValue not correct for atom feed item {atomFeedItemDescription}");

                Assert.AreEqual(
                    row.ParseNullableDecimal("ClaimAdjustment"),
                    corporateFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.ClaimAdjustments?.ClaimAdjustmentValue,
                    $"ClaimAdjustmentValue not correct for atom feed item {atomFeedItemDescription}");

                Assert.AreEqual(
                    row.ParseNullableString("ClaimAdjustmentReason"),
                    corporateFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.ClaimAdjustments?.ClaimAdjustmentReason,
                    $"ClaimAdjustmentReason not correct for atom feed item {atomFeedItemDescription}");

                Assert.AreEqual(
                    row.ParseNullableDecimal("AdjustedCappedClaimValue"),
                    corporateFcr.FCReconciliationAllAttrs.FCReconciliationNonPKeyAttrs.AmountAttrs.AdjustedCappedClaimedValue,
                    $"AdjustedCappedClaimedValue not correct for atom feed item {atomFeedItemDescription}");
            });
        }

        [Given(@"there is no data in the PaymentSchedule\.PublishedPayableFcrAllocation table for the following allocations")]
        public void GivenThereIsNoDataInThePaymentSchedule_PublishedPayableFcrAllocationTableForTheFollowingAllocations(Table table)
        {
            IEnumerable<string> allocationNumbers = table.Rows.Select(r => r["AllocationRef"]);
            PaymentSchedulePolicyRepository.RemovePublishedPayableFcrAllocationsByKey(allocationNumbers);
        }

        [Then(@"the number of Funding Claims expected for ClaimTypeName '(.*)' and Period '(.*)' agrees with the number of Funding Claims received")]
        public void ThenTheNumberOfFundingClaimsExpectedForClaimTypeNameAndPeriodAgreesWithTheNumberOfFundingClaimsReceived(string claimTypeName, string period)
        {
            int expectedRowCount = Infrastructure.Repositories.FundingClaimCollectionImportInfoRepository
                .GetTotalRowsToImportForCollection(
                    $"{period}-{claimTypeName.Replace(" ", "")}");

            CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
            {
                int actualRowCount =
                    Infrastructure.Repositories.FundingClaimRepository.GetFundingClaimCountForCollection(
                        period: period,
                        claimTypeName: claimTypeName.Replace(" ", ""));

                return actualRowCount == expectedRowCount;
            }, maxNumChecks: 5, waitIntervalSeconds: 2);

            bool foundExpectedNumberOfRowsInStorage = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

            Assert.IsTrue(foundExpectedNumberOfRowsInStorage,
                $"Did not find expected {expectedRowCount} funding claim(s) in storage");
        }

        [Given(@"we have created '(.*)' contracts for AEBC1819 starting at this '(.*)' orgId and ukprn starts with '(.*)' and contract starts '(.*)'")]
        public void GivenWeHaveCreatedContractsForAEBCStartingAtThisOrgIdAndUkprnStartsWith(int numberOfContractsToCreate, int orgIdSuffix, int ukrpnToStart, int contractNumberToStart)
        {
            DateTime startDate = DateTime.SpecifyKind(DateTime.ParseExact("01/08/2018", "dd/MM/yyyy", CultureInfo.InvariantCulture), DateTimeKind.Utc);
            DateTime endDate = DateTime.SpecifyKind(DateTime.ParseExact("31/07/2018", "dd/MM/yyyy", CultureInfo.InvariantCulture), DateTimeKind.Utc);
            const string period = "1819";
            const string fsp = "AEBC1819";

            var collection = Enumerable.Range(0, numberOfContractsToCreate);
            var crmConnection = CrmConnectionFactory.GetConnection();

            var status = GetSubStatusEntityId("Approved");

            var contractInfos = collection.Select(i => new ContractInfo(
                $"MAIN-{contractNumberToStart}",
                $"ESFA-{contractNumberToStart}",
                ukrpnToStart++,
                $"ORG000{orgIdSuffix++}",
                $"AEC-{contractNumberToStart++}")).ToList();

            DeleteOrgs(contractInfos);

            Func<int, int> getPlannedValue = d =>
            {
                if (d == 1)
                {
                    return 10000;
                }
                if (d == 2)
                {
                    return 499;
                }
                if (d == 3)
                {
                    return 9501;
                }

                return 0;
            };

            List<contractDeliverablesTypeContractDeliverable> deliverables = Enumerable.Range(1, 10).Select(code => new contractDeliverablesTypeContractDeliverable
            {
                deliverable = new deliverableType
                {
                    deliverableCode = code,
                },
                DisplayOrder = code,
                plannedValue = getPlannedValue(code)
            }).ToList();

            List<ExtendedContract> masterContracts = contractInfos.Select(c => new ExtendedContract
            {
                contractNumber = c.MasterContractNumber,
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contractor = new contractor
                {
                    ukprn = c.Ukprn,
                    organisationIdentifier = c.OrgId,
                    legalName = "Bulk Test",
                    Status = "Active"
                },
                fundingType = new fundingType
                {
                    fundingTypeName = "Mainstream",
                    fundingTypeCode = "MAIN"
                },
                contracts = new List<ExtendedContractType>()
                {
                    new ExtendedContractType
                    {
                        contractNumber = c.ContractNumber,
                        startDate = startDate,
                        endDate = endDate,
                        contractor = new contractor
                        {
                            ukprn = c.Ukprn,
                            organisationIdentifier = c.OrgId,
                            legalName = "Bulk Test",
                            Status = "Active"
                        },
                        fundingType = new fundingType
                        {
                            fundingTypeName = "Mainstream",
                            fundingTypeCode = "MAIN"
                        },
                        amendmentType = "New",
                        hierarchyType = hierarchyType.CONTRACT,
                        contractVersionNumber = 1,
                        period = new period()
                        {
                            period1 = period,
                            fundingStreamPeriods = new List<fundingStreamPeriodsFundingStreamPeriod>()
                            {
                                new fundingStreamPeriodsFundingStreamPeriod
                                {
                                    fundingStreamPeriodCode = fsp
                                }
                            },
                            periodType = new periodTypeType
                            {
                                periodTypeCode = periodTypeCodeType.AY,
                                periodTypeName = periodTypeNameType.ACADEMICYEAR
                            }
                        },
                        contractAllocations = new List<ExtendedContractAllocation>
                        {
                            new ExtendedContractAllocation
                            {
                                contractAllocationNumber = c.AllocationNumber,
                                startDate = startDate,
                                endDate = endDate,

                                fundingStream = new fundingStream()
                                {
                                    fundingStreamCode = "AEBC"
                                },
                                period = new period()
                                {
                                    period1 = period,
                                    fundingStreamPeriods = new List<fundingStreamPeriodsFundingStreamPeriod>()
                                    {
                                        new fundingStreamPeriodsFundingStreamPeriod
                                        {
                                            fundingStreamPeriodCode = fsp
                                        }
                                    },
                                    periodType = new periodTypeType
                                    {
                                        periodTypeCode = periodTypeCodeType.AY,
                                        periodTypeName = periodTypeNameType.ACADEMICYEAR
                                    }
                                },
                                fundingStreamPeriodCode = fsp,
                                contractDeliverables = deliverables
                            }
                        }
                
                    }
                }

            }).ToList();

            ContractsManager contractsManager = new ContractsManager
            {
                OrganizationService = crmConnection,
                LookupManager = new LookupManager
                {
                    BatchCacheManager = new BatchCacheManager(),
                    EnduringCacheManager = new EnduringCacheManager(),
                    OrganizationService = crmConnection
                },
                XrmOrganisationManager = new XrmOrganisationManager
                {
                    OrgService = crmConnection
                },
                XrmWorkflowManager = new XrmWorkflowManager
                {
                    OrganizationService = crmConnection
                }
            };

            masterContracts.ForEach(m =>
            {
                Guid masterContract = contractsManager.CreateContract(m, "");

                var childContractId = CrmContractRepository.GetContractForMaster(masterContract);
                var contract = new sfa_contract
                {
                    Id = childContractId,
                    sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Approved),
                    sfa_SubStatus = new EntityReference("sfa_status", status), // Approved
                    EntityState = EntityState.Changed
                };
              
                crmConnection.Update(contract);
            });

            UpsertAllocationsAndDeliverablesIntoPerformanceManagement(masterContracts);

            ScenarioContext.Current.Set(data:masterContracts, key:BulkContractsCacheKey);
        }

        [Given(@"we have created funding claims in the stub for each contract we have just created")]
        public void GivenWeHaveCreatedFundingClaimsInTheStubForEachContractWeHaveJustCreated()
        {
            const string claimTypeName = "Final";
            const string periodTypeCode = "AY";
            const string period = "1819";
            const int claimVersion = 1;

            List<ExtendedContract> extendedContracts =
                ScenarioContext.Current.Get<List<ExtendedContract>>(key: BulkContractsCacheKey);

            extendedContracts.ForEach(m =>
            {
                m.contracts.ForEach(c =>
                {
                    _performanceManagementPageObject.CreateFundingClaim(
                        organisationId: c.contractor.organisationIdentifier,
                        ukprn: c.contractor.ukprn,
                        claimVersionNumber: claimVersion,
                        claimTypeName: claimTypeName,
                        periodTypeCode: periodTypeCode,
                        period: period,
                        hasBeenSigned: false);

                    c.contractAllocations.ForEach(ca =>
                    {
                        Pages.FundingClaimNaturalKey fcNaturalKey = new Pages.FundingClaimNaturalKey
                        {
                            ClaimTypeName = claimTypeName,
                            OrganisationIdentifier = c.contractor.organisationIdentifier,
                            PeriodTypeCode = periodTypeCode,
                            Period = period,
                            VersionNumber = claimVersion
                        };

                        FundingClaimAllocationNaturalKey allocationNaturalKey = new FundingClaimAllocationNaturalKey
                        {
                            ContractAllocationNumber = ca.contractAllocationNumber,
                            FundingClaimNaturalKey = fcNaturalKey
                        };

                        _performanceManagementPageObject.CreateFundingClaimAllocation(allocationNaturalKey, ca.fundingStreamPeriodCode);

                        ca.contractDeliverables.ForEach(d =>
                        {
                            _performanceManagementPageObject.CreateFundingClaimDeliverable(allocationNaturalKey,
                                d.deliverable.deliverableCode, 10,
                                11, 12,
                                100);
                        });
                    });
                });
            });

            _performanceManagementPageObject.CreateFundingClaimUnderTestInAzureTableStorage();
        }

        [Given(@"there are no contracts or Orgs for this FSP '(.*)'")]
        public void GivenThereAreNoContractsForThisFSP(string fspCode)
        {
            var contractIds = CrmContractRepository.GetContractIdsForFsp(fspCode);

            contractIds.GroupBy(c => c.CrmMasterId)
                .ForEach(masterGrp =>
            {
                masterGrp.ForEach(c =>
                {
                    try
                    {
                        CrmContractRepository.DeleteContract(c.CrmId);
                    }
                    catch (Exception e)
                    {
                        Assert.Fail($"Contract cannot be delete: {c}: Exception: {e.Message}");
                    }
                });

                // now delete the master
                try
                {
                    CrmContractRepository.DeleteContract(masterGrp.Key);
                }
                catch (Exception e)
                {
                    Assert.Fail($"Contract cannot be delete: {masterGrp.First().MasterContractNumber}: Exception: {e.Message}");
                }
            });

            // now delete the ogs
            contractIds.Select(c => c.OrgId).Distinct()
                .ForEach(CrmOrganisationRepository.DeleteOrgByCrmId);
        }

        [Given(@"there is FundingClaim table or Stub is empty")]
        public void GivenThereIsFundingClaimTableOrStubIsEmpty()
        {
            SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.FundingClaimRepository.RemoveAllRowsFromFundingClaimTable();

            FundingClaimStubRepository.DeleteAllRows();
            FundingClaimApiStubRepository.DeleteAllRows();
        }

        [When(@"a hold request is triggered in CRM for the following unpublished Funding Claim Reconciliations")]
        public void WhenAHoldRequestIsTriggeredInCRMForTheFollowingUnpublishedFundingClaimReconciliations(Table table)
        {
            table.Rows.ForEach(row =>
            {
                Guid fundingClaimReconciliationId = CrmFundingClaimReconciliationRepository.GetFundingClaimReconciliationIdByNaturalKey(
                    row["UKPRN"],
                    row["FundingPeriod"],
                    row["FundingClaimType"],
                    row["AllocationGroupCode"],
                    row.ParseInt("ClaimVersionNumber"));

                Guid workflowId = CrmWorkflowRepository.GetWorkFlowId("WF26: Set Funding Claim Reconciliation on Hold");

                CrmWorkflowRepository.ExecuteWorkFlow(workflowId, fundingClaimReconciliationId, "CRM Integration");
            });
        }

        [When(@"a release request is triggered in CRM for the following held Funding Claim Reconciliations")]
        public void WhenAReleaseRequestIsTriggeredInCRMForTheFollowingHeldFundingClaimReconciliations(Table table)
        {
            table.Rows.ForEach(row =>
            {
                Guid fundingClaimReconciliationId = CrmFundingClaimReconciliationRepository.GetFundingClaimReconciliationIdByNaturalKey(
                    row["UKPRN"],
                    row["FundingPeriod"],
                    row["FundingClaimType"],
                    row["AllocationGroupCode"],
                    row.ParseInt("ClaimVersionNumber"));

                Guid workflowId = CrmWorkflowRepository.GetWorkFlowId("WF27: Release Held Funding Claim Reconciliation");

                CrmWorkflowRepository.ExecuteWorkFlow(workflowId, fundingClaimReconciliationId, "CRM Integration");
            });
        }

        [Given(@"there is no data in the Reconciliation Profiling table for UKPRN '(.*)' and FundingPeriod '(.*)'")]
        public void GivenThereIsNoDataInTheReconciliationProfilingTableForUKPRNAndFundingPeriod(int ukprn, string fundingPeriod)
        {
            ClaimReconciliationReferenceDataReconProfilingRepository.Remove(ukprn, fundingPeriod);
        }

        [Given(@"the Reconciliation Profiling table includes a row for UKPRN '(.*)' and FundingPeriod '(.*)'")]
        public void GivenTheReconciliationProfilingTableIncludesARowForUKPRNAndFundingPeriod(int ukprn, string fundingPeriod)
        {
            ClaimReconciliationReferenceDataReconProfilingRepository.Add(ukprn, fundingPeriod);
        }

        private PMEFModel.ContractAllocation CreateFcrContractAllocationFromRow(TableRow row)
        {
            string allocationNumber = row["AllocationRef"];
            int ukprn = Convert.ToInt32(row["UKPRN"]);

            _createdContractAllocationNumbers.Add(allocationNumber);

            return new PMEFModel.ContractAllocation(allocationNumber, DateTime.Now.AddYears(-1), DateTime.Now.AddMonths(2))
            {
                Contract = new PMEFModel.Contract
                {
                    ApprovalDate = DateTime.Now.AddMonths(-6),
                    ContractNumber = "DummyContractNumber",
                    VersionNumber = 1,
                    SubVersionNumber = 0
                },
                FundingType = new PMEFModel.FundingType
                {
                    FundingTypeCode = "AY",
                    FundingTypeName = "ACADEMICYEAR"
                },
                Contractor = new PMEFModel.Contractor
                {
                    OrganisationIdentifier = "ORG00001",
                    LegalName = "Legal Name",
                    UKPRN = ukprn
                },
                Period = new PMEFModel.Period
                {
                    PeriodTypeName = "ACADEMICYEAR"
                },
                LastModifiedDate = DateTime.Now
            };
        }

        private void DeleteOrgs(List<ContractInfo> contractInfos)
        {
            contractInfos.ForEach(c =>
            {
                try
                {
                    CrmOrganisationRepository.DeleteOrgById(c.OrgId);
                }
                catch (Exception e)
                {
                    Assert.Fail($"Cannot delete or {c.OrgId}");
                }
            });
        }

        private static void UpsertAllocationsAndDeliverablesIntoPerformanceManagement(IReadOnlyCollection<ExtendedContract> masterContracts)
        {
            masterContracts.ForEach(m => m.contracts.ForEach(c => c.contractAllocations.ForEach(ca =>
            {

                SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation.ContractAllocation allocationModel = new SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation.ContractAllocation(ca.contractAllocationNumber, ca.startDate, ca.endDate)
                {
                    Contractor = new PMEFModel.Contractor
                    {
                        LegalName = m.contractor.legalName,
                        OrganisationIdentifier = m.contractor.organisationIdentifier,
                        UKPRN = m.contractor.ukprn
                    },

                    Contract = new SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation.Contract
                    {
                        ApprovalDate = DateTime.Now,
                        ContractNumber = c.contractNumber,
                        SubVersionNumber = c.contractSubVersionNumber,
                        VersionNumber = c.contractVersionNumber
                    },

                    FundingType = new PMEFModel.FundingType
                    {
                        FundingTypeName = m.fundingType.fundingTypeName,
                        FundingTypeCode = m.fundingType.fundingTypeCode
                    },
                    Period = new PMEFModel.Period
                    {
                        PeriodTypeName = ca.period.periodType.periodTypeName.ToString()
                    }
                };

                PerformanceManagementContractAllocationRepository.UpsertAllocation(allocationModel);
            })));
        }

        private static Guid GetSubStatusEntityId(string name)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.sfa_statusSet.Single(s => s.sfa_name == name).Id;
            }
        }

        private class ContractInfo
        {
            public ContractInfo(string contractNumber, string masterContractNumber, int ukprn, string orgId, string allocationNumber)
            {
                ContractNumber = contractNumber;
                MasterContractNumber = masterContractNumber;
                Ukprn = ukprn;
                OrgId = orgId;
                AllocationNumber = allocationNumber;
            }

            public string ContractNumber { get; }

            public string MasterContractNumber { get; }

            public int Ukprn { get; }

            public string OrgId { get; }

            public string AllocationNumber { get; }
        }

        private static T? ParseColumnValue<T>(string columnValue) where T : struct
        {
            const string nullRepresentation = "?";
            if (columnValue != nullRepresentation)
            {
                return (T)Convert.ChangeType(columnValue, typeof(T), CultureInfo.InvariantCulture);
            }

            return null;
        }

        private class ClaimTypeInfo
        {
            public ClaimTypeInfo(string claimType, string period)
            {
                ClaimType = claimType;
                Period = period;
            }

            public string ClaimType { get; }

            public string Period { get; }
        }
    }
}
