namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Linq;
    using AllocationDelivery.DataStore.Model;
    using CrossDomain.Integration.Entities.Xrm;
    using Extensions;
    using Infrastructure.Repositories;
    using NUnit.Framework;
    using Pages;
    using Pages.DTO;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using TechTalk.SpecFlow;
    using Utilities;

    [Binding, Scope(Feature = "NCSContractAmendmentLifecycle 17531")]
    public class NcsContractAmendmentLifecycleSteps
    {
        private readonly ContractRepositoryPageObject _contractRepositoryPageObject;
        private readonly ADMonitoringDomainPageObject _adMonitoringDomainPageObject;
        private readonly PaymentManagementPageObject _paymentManagementPageObject;
        private readonly RetrieveSummarisedActualsPageObject _retrieveSummarisedActualsPageObject;

        public NcsContractAmendmentLifecycleSteps(
            ContractRepositoryPageObject contractRepositoryPageObject,
            ADMonitoringDomainPageObject adMonitoringDomainPageObject,
            PaymentManagementPageObject paymentManagementPageObject,
            RetrieveSummarisedActualsPageObject retrieveSummarisedActualsPageObject)
        {
            _contractRepositoryPageObject = contractRepositoryPageObject;
            _adMonitoringDomainPageObject = adMonitoringDomainPageObject;
            _paymentManagementPageObject = paymentManagementPageObject;
            _retrieveSummarisedActualsPageObject = retrieveSummarisedActualsPageObject;
        }

        [When(@"I retrieve the latest contract details from CRM for provider '(.*)' for FundingType '(.*)' and period '(.*)'")]
        [Then(@"I retrieve the latest contract details from CRM for provider '(.*)' for FundingType '(.*)' and period '(.*)'")]
        public void WhenIRetrieveTheLatestContractDetailsFromCRMForProviderForFundingTypeAndPeriod(int ukprn, string fundingType, int period)
        {
            sfa_contract contract = _contractRepositoryPageObject.RetrieveLatestContractDataAndSetState(ukprn.ToString(), fundingType, period.ToString());
            Assert.IsTrue(contract != null, $"There is no contract in CRM for UKPRN {ukprn} with FundingType {fundingType} and period {period}");
        }

        [Then(@"the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events")]
        [When(@"the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events")]
        public void ThenTheAllocationDeliveryMonitoringServiceAtomFeedContainsTheFollowingAllocationDeliveryPerformanceEvents(TransformedTable table)
        {
            List<SimpleContractAllocation> contractAllocationsToCheck = table.Rows
                .Select(r => new SimpleContractAllocation(
                    GetAllocationNumber(r["AllocationNumber"]),
                    Convert.ToInt32(r["ContractVersionNumber"]),
                    (AllocationDeliveryEntryCategory)Enum.Parse(typeof(AllocationDeliveryEntryCategory), r["AllocationDeliveryEntryCategory"])))
                .ToList();

            CheckResultPoller resultPoller = new CheckResultPoller(
                checkResult: () => _adMonitoringDomainPageObject.VerifyAllocationsAreInFeed(contractAllocationsToCheck),
                maxNumChecks: 18,
                waitIntervalSeconds: 5);

            bool allEventsFound = resultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            Assert.IsTrue(allEventsFound, "Not all expected allocation delivery performance events are in retrieved atom feed");
        }

        [Given(@"the following closed collections are available in DCFS")]
        [Then(@"the following closed collections are available in DCFS")]               // really a given, but used as a then. better way??
        public void GivenTheFollowingClosedCollectionsAreAvailableInDcfs(Table table)
        {
            var reportedActuals = table.Rows
                .Select(r => new ReportedActual
                {
                    CollectionReturnCode = r["CollectionReturnCode"],
                    OrganisationId = r["OrganisationId"],
                    PeriodTypeCode = r["PeriodTypeCode"],
                    Period = r["Period"],
                    FundingStreamPeriodCode = r["FundingStreamPeriodCode"],
                    CollectionType = r["CollectionType"],
                    ContractAllocationNumber = GetAllocationNumber(r["ContractAllocationNumber"]),
                    UoPCode = r["UoPCode"],
                    DeliverableCode = r["DeliverableCode"],
                    ActualVolume = long.Parse(r["ActualVolume"]),
                    ActualValue = ParseDoubleValue(r["ActualValue"])
                });

            _retrieveSummarisedActualsPageObject.StoreClosedCollectionActuals(reportedActuals);
        }

        [Then(@"the PaymentSchedule\.DeliverablePayment table contains the following values")]
        [Then(@"PAAS table PaymentSchedule\.DeliverablePayment contains the following values")]
        public void ThenPAASTablePaymentSchedule_DeliverablePaymentContainsTheFollowingValues(TransformedTable table)
        {
            foreach (var row in table.Rows)
            {
                DeliverablePayment stepDeliverablePayment = TransformTableRowToDeliverablePayment(row);

                string context =
                    $" Allocation number: {stepDeliverablePayment.AllocationNumber} - version: {stepDeliverablePayment.VersionNumber} - " +
                    $"deliverableCode: {stepDeliverablePayment.DeliverableCode} - Period: {stepDeliverablePayment.Period}";

                DeliverablePayment paasDeliverablePayment = null;
                var checkResultPoller = new CheckResultPoller(checkResult: () =>
                {
                    paasDeliverablePayment =
                        PaymentSchedulePolicyRepository.GetDeliverablePaymentByKey(
                            stepDeliverablePayment.AllocationNumber,
                            stepDeliverablePayment.VersionNumber,
                            stepDeliverablePayment.DeliverableCode,
                            stepDeliverablePayment.Period);

                    return
                        PaymentSchedulePolicyRepository.HaveDeliverablePaymentsGotEquivalentCalcValues(
                            stepDeliverablePayment, paasDeliverablePayment);
                },
                maxNumChecks: 24,
                waitIntervalSeconds: 5);

                checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

                Assert.AreEqual(stepDeliverablePayment.PeriodTypeCode, paasDeliverablePayment.PeriodTypeCode, "PeriodTypeCode was not equal to expected value." + context);
                Assert.AreEqual(stepDeliverablePayment.PlannedVolume, paasDeliverablePayment.PlannedVolume, "PlannedVolume was not equal to expected value." + context);
                Assert.AreEqual(stepDeliverablePayment.PlannedValue, paasDeliverablePayment.PlannedValue, "PlannedValue was not equal to expected value." + context);
                Assert.AreEqual(stepDeliverablePayment.ProfilePaymentAmount, paasDeliverablePayment.ProfilePaymentAmount, "ProfilePaymentAmount was not equal to expected value." + context);
                Assert.AreEqual(stepDeliverablePayment.CappedPaymentAmount, paasDeliverablePayment.CappedPaymentAmount, "CappedPaymentAmount was not equal to expected value." + context);
                Assert.AreEqual(stepDeliverablePayment.BalancingPaymentAmount, paasDeliverablePayment.BalancingPaymentAmount, "BalancingPaymentAmount was not equal to expected value." + context);
                Assert.AreEqual(stepDeliverablePayment.ReconciliationPaymentAmount, paasDeliverablePayment.ReconciliationPaymentAmount, "ReconciliationPaymentAmount was not equal to expected value." + context);
                Assert.AreEqual(stepDeliverablePayment.NetPaymentAmount, paasDeliverablePayment.NetPaymentAmount, "NetPaymentAmount was not equal to expected value." + context);
                Assert.AreEqual(stepDeliverablePayment.ActualValue, paasDeliverablePayment.ActualValue, "ActualValue was not equal to expected value." + context);
            }
        }

        [Then(@"the Actuals Value Data is stored in CRM against the last approved version of the contract as follows")]
        public void ThenTheActualsValueDataIsStoredInCRMAgainstTheLastApprovedVersionOfTheContractAsFollows(Table actualsTable)
        {
            _paymentManagementPageObject.CheckGWTPayments(_contractRepositoryPageObject, actualsTable, dp => dp.sfa_ActualValue);
        }

        [Then(@"the Reconciliation Data is calculated as follows")]
        public void ThenTheReconciliationDataIsCalculatedAsFollows(Table reconciliationTable)
        {
            _paymentManagementPageObject.CheckGWTPayments(_contractRepositoryPageObject, reconciliationTable, dp => dp.sfa_ReconciliationPaymentAmount);
        }

        [Then(@"the Net Payments are calculated as follows")]
        public void ThenTheNetPaymentsAreCalculatedAsFollows(TransformedTable netPaymentsTable)
        {
            _paymentManagementPageObject.CheckGWTPayments(_contractRepositoryPageObject, netPaymentsTable.Value, dp => dp.sfa_NetPaymentAmount);
        }

        private string GetAllocationNumber(string rowValue)
        {
            string allocationNumber = rowValue;

            if (allocationNumber == "[AllocRef]") // for legacy tests
            {
                allocationNumber = _paymentManagementPageObject.ContractToTest.contracts.First().contractAllocations.First().contractAllocationNumber;
            }
            else if (allocationNumber.StartsWith("[AllocRef_"))
            {
                allocationNumber =
                    _contractRepositoryPageObject.GetLatestContractDataItem(
                        allocationNumber.Replace("[", "").Replace("]", ""));
            }

            Debug.Print($"GetAllocationNumber:Allocation Number is {allocationNumber}");
            return allocationNumber;
        }

        private static double? ParseDoubleValue(string doubleValueStr)
        {
            double? value = null;
            if (doubleValueStr != "?")
            {
                value = double.Parse(doubleValueStr);
            }

            return value;
        }

        private DeliverablePayment TransformTableRowToDeliverablePayment(TableRow row)
        {
            string allocationNumber = null;
            if (!row["AllocationNumber"].Contains("["))
            {
                allocationNumber = row["AllocationNumber"];
            }
            else
            {
                allocationNumber = GetAllocationNumber(row["AllocationNumber"]);
            }

            return new DeliverablePayment
            {
                AllocationNumber = allocationNumber,
                VersionNumber = int.Parse(row["VersionNumber"]),
                DeliverableCode = int.Parse(row["DeliverableCode"]),
                Period = row["Period"],
                PeriodTypeCode = (PeriodTypeCode)int.Parse(row["PeriodTypeCode"]),
                PlannedVolume = row.ParseNullableInt("PlannedVolume"),
                PlannedValue = row.ParseNullableDecimal("PlannedValue"),
                ProfilePaymentAmount = row.ParseNullableDecimal("ProfilePaymentAmount"),
                CappedPaymentAmount = row.ParseNullableDecimal("CappedPaymentAmount"),
                BalancingPaymentAmount = row.ParseNullableDecimal("BalancingPaymentAmount"),
                ReconciliationPaymentAmount = row.ParseNullableDecimal("ReconciliationPaymentAmount"),
                NetPaymentAmount = decimal.Parse(row["NetPaymentAmount"]),
                ActualValue = row.ParseNullableDecimal("ActualValue")
            };
        }
    }
}