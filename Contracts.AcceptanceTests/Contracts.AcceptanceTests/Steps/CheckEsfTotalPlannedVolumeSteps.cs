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
    using NUnit.Framework.Legacy;

    [Binding, Scope(Feature = "CheckESFTotalPlannedVolume 17506")]
    public class CheckEsfTotalPlannedVolumeSteps
    {
        private readonly CheckEsfTotalPlannedVolumeStepsPageObject _pageObject;

        public CheckEsfTotalPlannedVolumeSteps(CheckEsfTotalPlannedVolumeStepsPageObject pageObject)
        {
            _pageObject = pageObject;
        }

        [When(@"I retrieve the latest contract details from CRM for provider '(.*)'")]
        public void WhenIRetrieveTheLatestContractDetailsFromCrmForProvider(int ukprn)
        {
            CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: () =>
                {
                    CheckEsfTotalPlannedVolumeStepsPageObject.ContractInfo contractInfo = _pageObject.GetLatestContractInfoByUkprn(ukprn);
                    _pageObject.RetrievedContractForValidation = contractInfo;
                    return contractInfo != null;
                },
                maxNumChecks: 50,
                waitIntervalSeconds: 2);
            bool hasContractBeenCreated = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsTrue(hasContractBeenCreated, "The contract has not been created in CRM.");
        }

        [Then(@"the planned volume data recorded in CRM against the latest version of the contract is as follows")]
        public void ThenThePlannedVolumeDataRecordedInCrmAgainstTheLatestVersionOfTheContractIsAsFollows(TransformedTable table)
        {
            table.Rows
                .SelectMany(ExtractDeliverablePeriodsFromTableRow)
                .ForEach(dpToValidate =>
                {
                    CheckEsfTotalPlannedVolumeStepsPageObject.AllocationInfo matchingAllocation =
                        _pageObject.RetrievedContractForValidation.Allocations.SingleOrDefault(a => a.AllocationNumber == dpToValidate.AllocationNumber);
                    ClassicAssert.NotNull(matchingAllocation, $"Allocation: {dpToValidate.AllocationNumber} not returned from CRM.");

                    CheckEsfTotalPlannedVolumeStepsPageObject.DeliverableInfo matchingDeliverable =
                        matchingAllocation.Deliverables.SingleOrDefault(d => d.DeliverableCode == dpToValidate.DeliverableCode);
                    ClassicAssert.NotNull(matchingDeliverable, $"Deliverable: {dpToValidate.DeliverableCode} not returned from CRM.");
                    ClassicAssert.AreEqual(dpToValidate.TotalPlannedVolume, matchingDeliverable.TotalPlannedVolume, $"Total planned volume incorrect for Deliverable: {dpToValidate.DeliverableCode}.");

                    CheckEsfTotalPlannedVolumeStepsPageObject.DeliverablePeriodInfo matchingDeliverablePeriod =
                        matchingDeliverable.DeliverablePeriods.SingleOrDefault(dp => dp.Month == dpToValidate.Month && dp.Year == dpToValidate.Year);
                    ClassicAssert.NotNull(matchingDeliverablePeriod, $"Deliverable Period: {dpToValidate} not returned from CRM.");
                    ClassicAssert.AreEqual(dpToValidate.PlannedVolume, matchingDeliverablePeriod.PlannedVolume, $"Planned volume incorrect for Deliverable Period: {dpToValidate}.");
                });
        }

        private IList<CheckEsfTotalPlannedVolumeStepsPageObject.DeliverablePeriodValidateInfo> ExtractDeliverablePeriodsFromTableRow(TableRow row)
        {
            int[] years = { 2016, 2017 };
            int[] months = Enumerable.Range(1, 12).ToArray();

            var deliverablePeriods = new List<CheckEsfTotalPlannedVolumeStepsPageObject.DeliverablePeriodValidateInfo>();

            foreach (int year in years)
            {
                foreach (int month in months)
                {
                    DateTime period = new DateTime(year, month, 1);
                    string columnHeading = $"{period.ToString("MMM")}-{period.ToString("yy")}";
                    if (row.ContainsKey(columnHeading))
                    {
                        deliverablePeriods.Add(new CheckEsfTotalPlannedVolumeStepsPageObject.DeliverablePeriodValidateInfo
                        {
                            ContractNumber = row["ContractNumber"],
                            AllocationNumber = row["AllocationRef"],
                            DeliverableCode = int.Parse(row["DeliverableCode"]),
                            Year = year,
                            Month = month,
                            PlannedVolume = decimal.Parse(row[columnHeading]),
                            TotalPlannedVolume = decimal.Parse(row["Total"])
                        });
                    }
                }
            }

            return deliverablePeriods;
        }
    }
}
