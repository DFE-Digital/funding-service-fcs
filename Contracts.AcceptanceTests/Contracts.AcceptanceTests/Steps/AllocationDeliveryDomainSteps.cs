namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDeliveryDomain.Common.DataStore.Model;
    using Extensions;
    using Infrastructure.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TechTalk.SpecFlow;
    using Utilities;
    using NUnit.Framework.Legacy;

    [Binding]
    public class AllocationDeliveryDomainSteps
    {
        [Then(@"the Actuals Audit contains the following")]
        public void ThenTheActualsAuditContainsTheFollowing(Table table)
        {
            bool CompareTableRowToAuditRecord(TableRow row, AllocationDeliverablePeriodActualAudit a)
            {
                return
                    a.CollectionType == row["CollectionType"] &&
                    a.CollectionReturnCode == row["CollectionReturnCode"] &&
                    a.CollectionReturnPeriod == row.ParseInt("CollectionReturnPeriod") &&
                    a.ContractAllocationNumber == row["AllocationNumber"] &&
                    a.ContractNumber == row["ContractNumber"] &&
                    a.ContractVersion == row.ParseInt("ContractVersion") &&
                    a.ContractSubVersion == row.ParseInt("ContractSubVersion") &&
                    a.AllocationStartDate.Date == row.ParseDate("AllocationStartDate").Date &&
                    a.AllocationEndDate.Date == row.ParseDate("AllocationEndDate").Date &&
                    a.OrganisationId == row["OrganisationId"] &&
                    a.Ukprn == row["UKPRN"] &&
                    a.FundingStreamPeriodCode == row["FundingStreamPeriodCode"] &&
                    a.UopCode == row["UopCode"] &&
                    a.DeliverableCode == row.ParseInt("DeliverableCode") &&
                    a.ParentDeliverableCode == row.ParseInt("ParentDeliverableCode") &&
                    a.Period == row["Period"] &&
                    a.PeriodTypeCode == row["PeriodTypeCode"] &&
                    Convert.ToDecimal(a.ActualValue) == row.ParseDecimal("ActualValue") &&
                    a.ActualVolume == row.ParseInt("ActualVolume");
            }

            List<string> allocationNumbers =
                table.Rows
                .Select(r => r["AllocationNumber"])
                .Distinct()
                .ToList();

            List<TableRow> unMatchedRows = new List<TableRow>();

            var poller = new CheckResultPoller(() =>
            {
                List<AllocationDeliverablePeriodActualAudit> storedAudits =
                    allocationNumbers
                    .SelectMany(ActualsAuditRepository.GetActualAuditsForAllocation)
                    .ToList();

                unMatchedRows = table.Rows
                    .Where(row => !storedAudits.Exists(a => CompareTableRowToAuditRecord(row, a)))
                    .ToList();

                return unMatchedRows.Count == 0;
            }, 10, 2);

            bool foundAllAudits = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

            ClassicAssert.IsTrue(foundAllAudits, $"Not all audits were found. Could not find: {unMatchedRows.ToHeaderAndValueString()}");
        }
    }
}
