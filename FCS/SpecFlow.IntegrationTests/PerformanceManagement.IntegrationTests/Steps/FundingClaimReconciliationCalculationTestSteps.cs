namespace PerformanceManagement.IntegrationTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using Castle.Core.Internal;
    using Extensions;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using TechTalk.SpecFlow;
    using FundingClaim = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using Reconciliation = SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using NUnit.Framework;
    using PageObjects;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using State;
    using Contract = SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation.Contract;
    using ContractAllocation = SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation.ContractAllocation;
    using Contractor = SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation.Contractor;
    using FundingType = SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation.FundingType;
    using Period = SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation.Period;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;

    [Binding]
    public class FundingClaimReconciliationCalculationTestSteps
    {
        private readonly ClaimReferenceProfileValueState _claimReferenceProfileValueState;
        private readonly List<DebatchedFundingClaim> _debatchedFundingClaims = new List<DebatchedFundingClaim>();
        private readonly List<FundingClaimReconciliation> _fundingClaimReconciliations = new List<FundingClaimReconciliation>();
        private readonly PerformanceManagementPageObject _perfMgmtPageObject = new PerformanceManagementPageObject();
        private readonly List<string> _createdContractAllocationNumbers = new List<string>();

        public FundingClaimReconciliationCalculationTestSteps(
            ClaimReferenceProfileValueState claimReferenceProfileValueState)
        {
            _claimReferenceProfileValueState = claimReferenceProfileValueState;
        }

        [AfterScenario("FundingClaimReconciliationCalculation")]
        public void AfterScenario()
        {
            _createdContractAllocationNumbers.ForEach(_perfMgmtPageObject.DeleteAllocationFromPaaS);
        }

        [Given(@"there are no Allocations in PaaS \(Performance Management\)")]
        public void GivenThereAreNoAllocationsInPaaSPerformanceManagement()
        {
            _perfMgmtPageObject.DeleteAllAllocationsFromPaaS();
        }

        [Given(@"the following debatched funding claims are received")]
        public void GivenTheFollowingDebatchedFundingClaimsAreReceived(Table table)
        {
            foreach (var r in table.Rows)
            {
                FundingClaim.Contractor contractor = new FundingClaim.Contractor { Ukprn = Convert.ToInt32(r["UKPRN"]) };

                DebatchedFundingClaim debatchedFundingClaim = new DebatchedFundingClaim
                {
                    Contractor = contractor,
                    ClaimTypeName = r.ParseEnum<ClaimTypeName>("ClaimTypeName"),
                    AllocationGroupCode = r["AllocationGroupCode"],
                    VersionNumber = Convert.ToInt32(r["ClaimVersion"]),
                    Period = r["Period"],
                    PeriodTypeCode = (FundingClaim.PeriodTypeCode)Enum.Parse(typeof(FundingClaim.PeriodTypeCode), r["PeriodType"])
                };

                _debatchedFundingClaims.Add(debatchedFundingClaim);
            }
        }

        [Given(@"the following funding claim allocations exist")]
        public void GivenTheFollowingFundingClaimAllocations(Table table)
        {
            foreach (var r in table.Rows)
            {
                DebatchedFundingClaim debatchedFundingClaim = _debatchedFundingClaims.Single(x => x.Contractor.Ukprn == Convert.ToInt32(r["UKPRN"])
                                                                                            && x.VersionNumber == Convert.ToInt32(r["ClaimVersion"])
                                                                                            && x.ClaimTypeName == r.ParseEnum<ClaimTypeName>("ClaimTypeName", isUpperCaseRequired: true)
                                                                                            && x.Period == r["Period"]
                                                                                            && x.AllocationGroupCode == r["AllocationGroupCode"]);

                _perfMgmtPageObject.CreateContractAllocationInStorage(CreateFcrContractAllocationFromRow(r));

                FundingClaim.ContractAllocation contractAllocation = new FundingClaim.ContractAllocation
                {
                    ContractAllocationNumber = r["AllocationRef"],
                    FundingStreamPeriodCode = r["FundingStreamPeriodCode"]
                };

                debatchedFundingClaim.ContractAllocations.Add(contractAllocation);
            }
        }

        private ContractAllocation CreateFcrContractAllocationFromRow(TableRow row)
        {
            string allocationNumber = row["AllocationRef"];
            int ukprn = Convert.ToInt32(row["UKPRN"]);

            _createdContractAllocationNumbers.Add(allocationNumber);

            return new ContractAllocation(allocationNumber, DateTime.Now.AddYears(-1), DateTime.Now.AddMonths(2))
            {
                Contract = new Contract
                {
                    ApprovalDate = DateTime.Now.AddMonths(-6),
                    ContractNumber = "DummyContractNumber",
                    VersionNumber = 1,
                    SubVersionNumber = 0
                },
                FundingType = new FundingType
                {
                    FundingTypeCode = "AY",
                    FundingTypeName = "ACADEMICYEAR"
                },
                Contractor = new Contractor
                {
                    OrganisationIdentifier = "ORG00001",
                    LegalName = "Legal Name",
                    UKPRN = ukprn
                },
                Period = new Period
                {
                    PeriodTypeName = "ACADEMICYEAR"
                },
                LastModifiedDate = DateTime.Now
            };
        }

        [Given(@"the following funding claim deliverables exist")]
        public void GivenTheFollowingFundingClaimDeliverables(Table table)
        {
            List<FundingClaim.ContractAllocation> allocations = _debatchedFundingClaims.SelectMany(fc => fc.ContractAllocations).ToList();

            foreach (var r in table.Rows)
            {
                string fspCode = r["FundingStreamPeriodCode"];
                FundingClaim.ContractAllocation contractAllocation = allocations.Single(a => a.FundingStreamPeriodCode == fspCode
                                                                                             && a.ContractAllocationNumber == r["AllocationRef"]);
                DeliverableLine deliverableLine = new DeliverableLine
                {
                    DeliverableCode = Convert.ToInt32(r["DeliverableCode"]),
                    ActualValue = Convert.ToDecimal(r["ActualValue"]),
                    ForecastValue = Convert.ToDecimal(r["ForecastValue"]),
                    AdjustmentValue = Convert.ToDecimal(r["AdjustmentValue"]),
                    PlannedValue = Convert.ToDecimal(r["PlannedValue"]),
                    ParentPlannedValue = Convert.ToDecimal(r["ParentPlannedValue"]),
                    TotalDelivery = r.ContainsKey("TotalDelivery") ? Convert.ToDecimal(r["TotalDelivery"]) : Convert.ToDecimal(r["ActualValue"]) + Convert.ToDecimal(r["ForecastValue"]) + Convert.ToDecimal(r["AdjustmentValue"])
                };

                contractAllocation.DeliverableLines.Add(deliverableLine);
            }

            allocations.ForEach(a =>
            {
                var profileDeliverableCodes = Repositories.FspDeliverableClaimRepository.GetProfileDeliverableCodes(a.FundingStreamPeriodCode);
                var deliverableLinesWithProfile =
                    a.DeliverableLines.Where(dl => profileDeliverableCodes.Contains(dl.DeliverableCode)).ToList();

                decimal? plannedValueForAllocation = 0;
                if (deliverableLinesWithProfile.Any())
                {
                    plannedValueForAllocation = deliverableLinesWithProfile
                        .Sum(dl => dl.PlannedValue);
                }
                if(plannedValueForAllocation == 0)
                {
                    // we need this because we have not specified the profile deliverable or we have but the planned value is not set
                    plannedValueForAllocation =
                        a.DeliverableLines.Select(dl => dl.ParentPlannedValue).Distinct().Sum();
                }
                
                a.PlannedValueAggregation = plannedValueForAllocation;
            });
        }

        [Given(@"the following profile values exist in config")]
        public void GivenTheFollowingProfileValuesExistInConfig(Table table)
        {
            foreach (var row in table.Rows)
            {
                _claimReferenceProfileValueState.Values.Add(
                    new ClaimReferenceProfileValue(
                    row["ClaimReconciliationDeliverableGroupCode"],
                    int.Parse(row["Ukprn"]),
                    decimal.Parse(row["PlannedValue"])
                    ));
            }
        }

        [When(@"the funding claim reconciliation calculation is run")]
        public void WhenTheFundingClaimReconciliationCalculationIsRun()
        {
            var referenceDelGroupCodes = _claimReferenceProfileValueState.Values.Select(p => p.ClaimReconciliationDeliverableGroupCode).ToList();

            IClaimReconciliationBehaviourRepository claimReconciliationBehaviourRepository = new ClaimReconciliationBehaviourRepository();
            IFspDeliverableClaimRepository fspDelClaimRepo = new FspDeliverableClaimRepository();
            IContractAllocationRepository contractAllocationRepository = new ContractAllocationRepository();

            IClaimReconciliationAllocationGroupRepository claimAllocGroupRepo = new ClaimReconciliationAllocationGroupRepository();
            IClaimTypeRepository claimTypeRepo = new ClaimTypeRepository();
            Mock<IClaimReferenceProfileRepository> claimReferenceProfileRepository = new Mock<IClaimReferenceProfileRepository>();
            claimReferenceProfileRepository.Setup(r => r.GetPlannedValue(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
                .Returns(
                    (string code, int ukrpn, ConnectionInfo ci) =>
                    {
                        return
                             Task.FromResult(_claimReferenceProfileValueState.Values.FirstOrDefault(
                                v => v.ClaimReconciliationDeliverableGroupCode == code && v.Ukprn == ukrpn)?.PlannedValue);
                    });


            claimReferenceProfileRepository.Setup(
                m => m.IsProfileFromReferenceData(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(
                        (string code, ConnectionInfo ci) => Task.FromResult(referenceDelGroupCodes.Contains(code)));

            DeliverableGroupAmountSummaryCreator deliverableGroupAmountSummaryCreator = new DeliverableGroupAmountSummaryCreator(claimReferenceProfileRepository.Object);

            CalculationService calculationService = new CalculationService(
                claimReconciliationBehaviourRepository,
                fspDelClaimRepo,
                contractAllocationRepository,
                claimAllocGroupRepo,
                claimTypeRepo,
                deliverableGroupAmountSummaryCreator);

            foreach (var debatchedFundingClaim in _debatchedFundingClaims)
            {
                debatchedFundingClaim.ContractAllocations.ForEach(EnrichAllocation);

                using (var context = new PerformanceManagementDbContext())
                {
                    FundingClaimReconciliation fundingClaimReconciliation =
                        calculationService.Calculate(debatchedFundingClaim, new ConnectionInfo(null, context.Database.Connection), 0).Result;
                    _fundingClaimReconciliations.Add(fundingClaimReconciliation);
                }
            }
        }

        private static void EnrichAllocation(FundingClaim.ContractAllocation allocation)
        {
            // perform a potted version of the enrichment process that occurs before a debatched funding claim is calculated
            using (PaymentManagementPolicyContext paymentManagementPolicyContext = new PaymentManagementPolicyContext())
            using (PerformanceManagementDbContext performanceManagementDbContext = new PerformanceManagementDbContext())
            {
                IPolicyDeliverableRepository policyDeliverableRepository = new PolicyDeliverableRepository();
                IFspDeliverableClaimRepository _fspDeliverableClaimRepository = new FspDeliverableClaimRepository();
                IParentDeliverableResolver parentDeliverableResolver = new ParentDeliverableResolver();

                IReadOnlyCollection<PolicyDeliverable> policyDeliverables =
                    policyDeliverableRepository.GetPolicyDeliverables(allocation.FundingStreamPeriodCode, new ConnectionInfo(null, connection:paymentManagementPolicyContext.Database.Connection)).Result;

                IReadOnlyCollection<FspDeliverableClaim> allClaimGroupDeliverablesForFsp =
                    _fspDeliverableClaimRepository.GetFspDeliverablesIncludingClaimDeliverableGroup(
                        allocation.FundingStreamPeriodCode,
                        connectionInfo: new ConnectionInfo(null, paymentManagementPolicyContext.Database.Connection)).Result;

                allocation.DeliverableLines
                    .Where(d => allClaimGroupDeliverablesForFsp.Any(cgd => cgd.DeliverableCode == d.DeliverableCode))
                    .ForEach(d =>
                    {
                        int claimGroupParentDeliverableCode = parentDeliverableResolver.GetParentDeliverableWithinClaimGroup(
                            d.DeliverableCode,
                            policyDeliverables,
                            allClaimGroupDeliverablesForFsp);

                        DeliverableLine parentDeliverableLine = allocation.DeliverableLines
                            .SingleOrDefault(ad => ad.DeliverableCode == claimGroupParentDeliverableCode);

                        if (parentDeliverableLine != null)
                        {
                            d.ParentPlannedValue = parentDeliverableLine?.PlannedValue;
                        }
                    });
            }
        }

        [Then(@"group claim data is present in the calculated funding claim reconciliations as follows")]
        public void ThenGroupClaimDataIsPresentInTheCalculatedFundingClaimReconciliationsAsFollows(Table table)
        {
            foreach(var r in table.Rows)
            {
                FundingClaimReconciliation fundingClaimReconciliation = _fundingClaimReconciliations.Single(x => x.Contractor.UKPRN == Convert.ToInt32(r["UKPRN"])
                                                                                                                 && x.Period.PeriodYear == r["FundingPeriod"]
                                                                                                                 && x.ClaimType.ClaimTypeName.ToUpper() == r["ClaimTypeName"].ToUpper()
                                                                                                                 && x.AllocationGroup.AllocationGroupCode == r["AllocationGroupCode"]);
                string rowInfo = $"Ukprn: {r["UKPRN"]}";

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

                Assert.AreEqual(expectedPlannedValue, reconciliationAmountSummary.PlannedValue, $"PlannedValue mismatch - {rowInfo}");
                Assert.AreEqual(expectedClaimedValue, reconciliationAmountSummary.ClaimedValue, $"ClaimedValue mismatch - {rowInfo}");
                Assert.AreEqual(expectedCappedClaimedValue, reconciliationAmountSummary.CappedClaimedValue, $"CappedClaimedValue mismatch - {rowInfo}");
                Assert.AreEqual(expectedProposedReconciliationValue, reconciliationAmountSummary.ProposedReconciliationValue, $"ProposedReconciliationValue mismatch - {rowInfo}");
                
                
                // Do we need see values on reconciliation or just proposed reconciliation.
                Assert.AreEqual(expectedReconciliationValue, reconciliationAmountSummary.ReconciliationValue.GetValueOrDefault(), $"ReconciliationValue mismatch - {rowInfo}");

                Debug.WriteLine($"UKPRN: {r["UKPRN"]}, FundingPeriod: {r["FundingPeriod"]}, ClaimTypeName: {r["ClaimTypeName"]}, AllocationGroupCode: {r["AllocationGroupCode"]} success.");
            }
        }

        [Then(@"allocation data is present in the calculated funding claim reconciliations as follows")]
        public void ThenAllocationDataIsPresentInTheCalculatedFundingClaimReconciliationsAsFollows(Table table)
        {
            foreach (var r in table.Rows)
            {
                Reconciliation.ContractAllocation contractAllocation = _fundingClaimReconciliations
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
                Assert.AreEqual(expectedProposedReconciliationValue, allocationAmountSummary.ProposedReconciliationValue, $"ProposedReconciliationValue mismatch - {r["AllocationRef"]}");

                // Do we need see values on reconciliation or just proposed reconciliation.
                Assert.AreEqual(expectedReconciliationValue, allocationAmountSummary.ReconciliationValue.GetValueOrDefault(), "ReconciliationValue mismatch");

                Debug.WriteLine($"Allocation {r["AllocationRef"]} success.");
            }
        }
    }
}
