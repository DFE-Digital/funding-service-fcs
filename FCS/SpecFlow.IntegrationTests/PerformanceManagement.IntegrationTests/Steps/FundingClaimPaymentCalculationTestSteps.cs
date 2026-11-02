namespace PerformanceManagement.IntegrationTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using NUnit.Framework;
    using PageObjects;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.FundingClaimReconciliation.Dto;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Repositories;
    using TechTalk.SpecFlow;

    [Binding]
    public class FundingClaimPaymentCalculationTestSteps
    {
        private readonly PaymentManagementPageObject _paymentManagementPageObject = new PaymentManagementPageObject(
            PayCalcPolicyQueryRepository.CreateInstance());

        private readonly List<DeliverablePeriodResult> _deliverablePeriodResults = new List<DeliverablePeriodResult>();
        
        [Given(@"the following deliverable payments information exists in the deliverable payments table")]
        public void GivenTheFollowingDeliverablePaymentsInformationExistsInTheDeliverablePaymentsTable(Table table)
        {
            _paymentManagementPageObject.ClearPaasDeliverablePeriodData(table.Rows.Select(x => x["AllocationNumber"]).Distinct().ToList());

            var delPaymentList = new List<DeliverablePayment>();

            table.Rows.ToList().ForEach(row =>
            {
                delPaymentList.Add(new DeliverablePayment
                {
                    AllocationNumber = row["AllocationNumber"],
                    VersionNumber = int.Parse(row["VersionNumber"]),
                    DeliverableCode = int.Parse(row["DeliverableCode"]),
                    Period= row ["Period"],
                    PeriodTypeCode = PeriodTypeCode.AY,
                    PlannedVolume = int.Parse(row["PlannedVolumne"]),
                    PlannedValue = decimal.Parse(row["PlannedValue"]),
                    ProfilePaymentAmount = decimal.Parse(row["ProfilePaymentAmount"]),
                    CappedPaymentAmount = decimal.Parse(row["CappedPaymentAmount"]),
                    BalancingPaymentAmount = decimal.Parse(row["BalancingPaymentAmount"]),
                    ReconciliationPaymentAmount = decimal.Parse(row["ReconciliationPaymentAmount"]),
                    NetPaymentAmount = decimal.Parse(row["NetPaymentAmount"]),
                    ActualValue = 0,
                    ActualVolume = 0,
                    CollectionReturnCode = "R12"
                });
            });

            _paymentManagementPageObject.SetDeliverablePayments(delPaymentList);
        }

        [Given(@"allocation data is present in the calculated funding claim reconciliations as follows")]
        public void GivenAllocationDataIsPresentInTheCalculatedFundingClaimReconciliationsAsFollows(Table table)
        {
            table.Rows.ToList().ForEach(row =>
            {
                var allocationNumber = row["AllocationRef"];
                decimal reconciliationValue = decimal.Parse(row["ReconciliationValue"]);
                string fundingStreamPeriodCode = row["FundingStreamPeriodCode"];

                _paymentManagementPageObject.SetAllocationInfo(allocationNumber, reconciliationValue, fundingStreamPeriodCode);
            });
        }

        [Given(@"the calculation date is '(.*)'")]
        public void GivenTheCalculationDateIs(string calculationDate)
        {
            // fetch the en-GB culture
            CultureInfo ukCulture = new CultureInfo("en-GB");
            _paymentManagementPageObject.SetCalculationDate(DateTime.Parse(calculationDate, ukCulture.DateTimeFormat));
        }

        [Given(@"the following funding claims reconciliations are published")]
        [When(@"the following funding claims reconciliations are published")]
        public void WhenTheFollowingFundingClaimsReconciliationsArePublished(Table table)
        {
            table.Rows.ToList().ForEach(row => _paymentManagementPageObject.HandleFundingClaimReconciliationPublishedEvent(row["AllocationRef"]));
        }

        [Given(@"the Deliverable Payments are as follows")]
        [Then(@"the Deliverable Payments are as follows")]
        public void ThenTheDeliverablePaymentsAreAsFollows(Table table)
        {
            List<DeliverablePayment> deliverablePayments = null;

            table.Rows.ToList().ForEach(row =>
            {
                string allocationNumber = row["AllocationNumber"];
                int deliverableCode = int.Parse(row["DeliverableCode"]);
                string period = row["Period"];
                int versionNumber =  int.Parse(row["VersionNumber"]);

                if(deliverablePayments == null || deliverablePayments?.First().AllocationNumber != allocationNumber)
                {
                    deliverablePayments = _paymentManagementPageObject.GetDeliverablePayments(allocationNumber, versionNumber);
                }

                DeliverablePayment matchingRecord = deliverablePayments.SingleOrDefault(dpr =>
                    dpr.AllocationNumber == allocationNumber
                    && dpr.DeliverableCode == deliverableCode
                    && dpr.Period == period);

                Assert.IsNotNull(matchingRecord,$"Allocation NUmber {allocationNumber} del code {deliverableCode} period {period}");
                AssertRowIsEqualToResult(row, matchingRecord);
            });
        }

        [Then(@"the Deliverable Payments do not contain the following")]
        public void ThenTheDeliverablePaymentsDoNotContainTheFollowing(Table table)
        {
            List<DeliverablePayment> deliverablePayments = null;

            table.Rows.ToList().ForEach(row =>
            {
                string allocationNumber = row["AllocationNumber"];
                int deliverableCode = int.Parse(row["DeliverableCode"]);
                string period = row["Period"];
                int versionNumber = int.Parse(row["VersionNumber"]);

                if (deliverablePayments == null || deliverablePayments?.First().AllocationNumber != allocationNumber)
                {
                    deliverablePayments = _paymentManagementPageObject.GetDeliverablePayments(allocationNumber, versionNumber);
                }

                DeliverablePayment matchingRecord = deliverablePayments.SingleOrDefault(dpr =>
                    dpr.AllocationNumber == allocationNumber
                    && dpr.DeliverableCode == deliverableCode
                    && dpr.Period == period);

                Assert.IsNull(matchingRecord,$"Allocation Number {allocationNumber} del code {deliverableCode} and period {period} exists in database");
                
            });
        }
        
        [Given(@"the override date is '(.*)'")]
        public void GivenTheOverrideDateIs(string overrideDate)
        {
            _paymentManagementPageObject.SetOverrideDate(overrideDate);
        }

        [Given(@"there is no payment schedule data for contract '(.*)' version '(.*)'")]
        public void GivenThereIsNoPaymentScheduleDataForContractAndMasterContract(string contractNumber, string version)
        {
            _paymentManagementPageObject.ClearContractData(contractNumber);
            _paymentManagementPageObject.ContractVersion = int.Parse(version);
            _paymentManagementPageObject.ContractNumber = contractNumber;
        }

        [Given(@"the approved contract allocations details for the latest version of the contract are as follows")]
        public void GivenTheApprovedContractAllocationsDetailsForTheLatestVersionOfTheContractAreAsFollows(Table table)
        {
            var allocations = new List<ExtendedAllocation>();
            foreach (TableRow row in table.Rows)
            {
                var allocation = new ExtendedAllocation()
                {
                    Allocation = new Allocation
                    {
                        ContractNumber = row["ContractNumber"],
                        AllocationNumber = row["AllocationRef"],
                        FundingStreamPeriodCode = row["FundingStreamPeriodCode"],
                        ContractVersionNumber = _paymentManagementPageObject.ContractVersion,
                        VersionNumber = _paymentManagementPageObject.ContractVersion,
                        AllocationStartDate = DateTime.ParseExact(row["AllocationStartDate"], "dd/MM/yyyy", CultureInfo.InvariantCulture),
                        AllocationEndDate = DateTime.ParseExact(row["AllocationEndDate"], "dd/MM/yyyy", CultureInfo.InvariantCulture),
                    },

                    FundingStreamPeriodType = row["FundingStreamPeriodType"]
                };

                if (row.ContainsKey("EsfRegionType"))
                {
                    allocation.EsfData = new ExtendedAllocation.EsfAllocationData
                    {
                        RegionType = row["EsfRegionType"],
                        InvestmentPriority = row["EsfInvestmentPriority"]
                    };
                }

                _paymentManagementPageObject.Ukprn = row["UKPRN"];

                allocations.Add(allocation);
            }

            _paymentManagementPageObject.AddContractAllocations(allocations);
            _paymentManagementPageObject.AddOrganisationIdentifiers(allocations);
        }

        [When(@"the contract is amended as follows")]
        public void WhenTheContractIsAmendedAsFollows(Table table)
        {
            bool incrementContractVersion = true;
            table.Rows.GroupBy(x => x["AllocationRef"]).ToList().ForEach(group =>
            {
                var payments = ConstructDeliverablePayments(group.Select(x => x).ToList());
                
                _paymentManagementPageObject.ApproveAmendedContract(payments, incrementContractVersion);
                incrementContractVersion = false;
            });
        }

        private List<DeliverableCodePayments> ConstructDeliverablePayments(List<TableRow> deliverableRowsForAllocation)
        {
            var payments = new List<DeliverableCodePayments>();
            foreach (var row in deliverableRowsForAllocation)
            {
                var deliverableCode = int.Parse(row["DeliverableCode"]);
                DeliverableCodePayments deliverablePayments = new DeliverableCodePayments
                {
                    DeliverableCode = deliverableCode,
                };

                var parentCode = row["ParentDeliverableCode"];
                if (!string.IsNullOrWhiteSpace(parentCode) && parentCode != "0" && parentCode != "?")
                {
                    deliverablePayments.ParentDeliverableCode = int.Parse(parentCode);
                }

                for (int i = 3; i < row.Keys.Count; i++)
                {
                    DateTime dt;
                    var period = row.Keys.ElementAt(i);
                    if (DateTime.TryParse("01-" + period, out dt))// && row[i] != "?")
                    {
                        var payment = new DeliverablePayment
                        {
                            AllocationNumber = row["AllocationRef"],
                            DeliverableCode = deliverableCode,
                            Period = dt.ToString("yyyyMM"),
                            PeriodTypeCode = PeriodTypeCode.CM,
                            VersionNumber = _paymentManagementPageObject.ContractVersion
                        };

                        if (row[i] != "?")
                        {
                            payment.PlannedValue = decimal.Parse(row[i]);
                        }

                        deliverablePayments.Payments.Add(payment);
                    }
                }

                payments.Add(deliverablePayments);
            }

            return payments.OrderBy(p => p.DeliverableCode).ToList();
        }

        private void AssertRowIsEqualToResult(TableRow row, DeliverablePayment deliverablePayment)
        {
            decimal tolerance = 1;
            var period = row["Period"];
            var plannedValue = decimal.Parse(row["PlannedValue"]);
            var profilePaymentAmount = decimal.Parse(row["ProfilePaymentAmount"]);
            var cappedPaymentAmount = decimal.Parse(row["CappedPaymentAmount"]);
            var balancingPaymentAmount = decimal.Parse(row["BalancingPaymentAmount"]);
            var reconciliationPaymentAmount = decimal.Parse(row["ReconciliationPaymentAmount"]);
            var netPaymentAmount = decimal.Parse(row["NetPaymentAmount"]);

            var allocationNumber = row["AllocationNumber"];
            var versionNumber = row["VersionNumber"];
            var deliverableCode = row["DeliverableCode"];

            Assert.AreEqual(plannedValue, deliverablePayment.PlannedValue, $"Expected planned value for allocation {allocationNumber} version {versionNumber} deliverable code {deliverableCode} period  {period} is {plannedValue} which is different than calculated value -{deliverablePayment.PlannedValue}");
            Assert.IsTrue(ValuesAreWithinTolerance(balancingPaymentAmount, deliverablePayment.BalancingPaymentAmount.GetValueOrDefault(), tolerance), $"Expected balancing payment for allocation {allocationNumber} version {versionNumber}  deliverable code {deliverableCode} period - {period} is {balancingPaymentAmount} different than calculated value - {deliverablePayment.BalancingPaymentAmount.GetValueOrDefault()}");
            Assert.IsTrue(ValuesAreWithinTolerance(profilePaymentAmount, deliverablePayment.ProfilePaymentAmount.GetValueOrDefault(), tolerance), $"Expected profile payment for allocation {allocationNumber} version {versionNumber}  deliverable code {deliverableCode} period - {period} is {profilePaymentAmount} different than calculated value - {deliverablePayment.ProfilePaymentAmount.GetValueOrDefault()}");
            Assert.IsTrue(ValuesAreWithinTolerance(cappedPaymentAmount, deliverablePayment.CappedPaymentAmount.GetValueOrDefault(), tolerance), $"Expected capped payment for allocation {allocationNumber} version {versionNumber}  deliverable code {deliverableCode} period - {period} is {cappedPaymentAmount} different than calculated value - {deliverablePayment.CappedPaymentAmount.GetValueOrDefault()}");
            Assert.IsTrue(ValuesAreWithinTolerance(reconciliationPaymentAmount, deliverablePayment.ReconciliationPaymentAmount.GetValueOrDefault(), tolerance), $"Expected reconciliationPaymentAmount payment for allocation {allocationNumber} version {versionNumber}  deliverable code {deliverableCode} period - {period} is {reconciliationPaymentAmount} different than calculated value - {deliverablePayment.ReconciliationPaymentAmount.GetValueOrDefault()}");
            Assert.IsTrue(ValuesAreWithinTolerance(netPaymentAmount, deliverablePayment.NetPaymentAmount, tolerance), $"Expected Net payment for allocation {allocationNumber} version {versionNumber}  deliverable code {deliverableCode} period - {period} is {netPaymentAmount} different than calculated value - {deliverablePayment.NetPaymentAmount}");
        }


        private bool ValuesAreWithinTolerance(decimal expectedValue, decimal actualValue, decimal tolerance)
        {
            return Math.Abs(expectedValue - actualValue) < tolerance;
        }
    }
}
