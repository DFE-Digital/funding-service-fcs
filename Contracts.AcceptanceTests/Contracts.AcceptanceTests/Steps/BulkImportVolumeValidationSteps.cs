namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using MoreLinq;
    using NUnit.Framework;
    using Pages;
    using TechTalk.SpecFlow;
    using Utilities;

    [Binding, Scope(Feature = "BulkImportVolumeValidation 18304")]
    public class BulkImportVolumeValidationSteps
    {
        private readonly PlannedValueCalcForEsfStepsPageObject _pageObject = new PlannedValueCalcForEsfStepsPageObject();

        [When(@"I retrieve the latest contract details from CRM for provider '(.*)'")]
        public void WhenIRetrieveTheLatestContractDetailsFromCrmForProvider(int ukprn)
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: () =>
                {
                    PlannedValueCalcForEsfStepsPageObject.ContractInfo contractInfo = _pageObject.GetLatestContractInfoByUkprn(ukprn);
                    _pageObject.RetrievedContractForValidation = contractInfo;
                    return contractInfo != null;
                },
                maxNumChecks: 50,
                waitIntervalSeconds: 2);
            bool hasContractBeenCreated = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            Assert.IsTrue(hasContractBeenCreated, "The contract has not been created in CRM.");
        }

        [Then(@"the planned volume data recorded in CRM against the latest version of the contract is as follows")]
        public void ThenThePlannedVolumeDataRecordedInCrmAgainstTheLatestVersionOfTheContractIsAsFollows(TransformedTable table)
        {
            table.Rows
                .SelectMany(ExtractDeliverablePeriodsWithPlannedVolumesFromTableRow)
                .ForEach(dpToValidate =>
                {
                    PlannedValueCalcForEsfStepsPageObject.AllocationInfo matchingAllocation =
                        _pageObject.RetrievedContractForValidation.Allocations.SingleOrDefault(a => a.AllocationNumber == dpToValidate.AllocationNumber);
                    Assert.NotNull(matchingAllocation, $"Allocation: {dpToValidate.AllocationNumber} not returned from CRM.");

                    PlannedValueCalcForEsfStepsPageObject.DeliverableInfo matchingDeliverable =
                        matchingAllocation.Deliverables.SingleOrDefault(d => d.DeliverableCode == dpToValidate.DeliverableCode);
                    Assert.NotNull(matchingDeliverable, $"Deliverable: {dpToValidate.DeliverableCode} not returned from CRM.");
                    Assert.AreEqual(dpToValidate.TotalPlannedVolume, matchingDeliverable.TotalPlannedVolume, $"Total planned volume incorrect for Deliverable: {dpToValidate.DeliverableCode}.");

                    PlannedValueCalcForEsfStepsPageObject.DeliverablePeriodInfo matchingDeliverablePeriod =
                        matchingDeliverable.DeliverablePeriods.SingleOrDefault(dp => dp.Month == dpToValidate.Month && dp.Year == dpToValidate.Year);
                    Assert.NotNull(matchingDeliverablePeriod, $"Deliverable Period: {dpToValidate} not returned from CRM.");
                    Assert.AreEqual(dpToValidate.PlannedVolume, matchingDeliverablePeriod.PlannedVolume, $"Planned volume incorrect for Deliverable Period: {dpToValidate}.");
                });
        }

        private IList<PlannedValueCalcForEsfStepsPageObject.DeliverablePeriodValidateInfo> ExtractDeliverablePeriodsWithPlannedVolumesFromTableRow(TableRow row)
        {
            int[] years = { 2016, 2017 };
            int[] months = Enumerable.Range(1, 12).ToArray();
            DateTime[] periods = months.SelectMany(m => years.Select(y => new DateTime(y, m, 1))).ToArray();

            var deliverablePeriods = new List<PlannedValueCalcForEsfStepsPageObject.DeliverablePeriodValidateInfo>();

            foreach (DateTime period in periods)
            {
                string columnHeading = $"{period.ToString("MMM")}-{period.ToString("yy")}";
                if (row.ContainsKey(columnHeading))
                {
                    deliverablePeriods.Add(new PlannedValueCalcForEsfStepsPageObject.DeliverablePeriodValidateInfo
                    {
                        ContractNumber = row["ContractNumber"],
                        AllocationNumber = row["AllocationRef"],
                        DeliverableCode = int.Parse(row["DeliverableCode"]),
                        Year = period.Year,
                        Month = period.Month,
                        PlannedVolume = GetNullableDecimalValueFromCell(row[columnHeading]),
                        TotalPlannedVolume = GetNullableDecimalValueFromCell(row["Total"])
                    });
                }
            }

            return deliverablePeriods;
        }

        private static decimal? GetNullableDecimalValueFromCell(string cellValue)
        {
            decimal d;

            if (cellValue.Contains("?") || !decimal.TryParse(cellValue, out d))
            {
                return null;
            }

            return d;
        }
    }
}