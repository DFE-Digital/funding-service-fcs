namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using AllocationDeliveryDomain.Common.DataStore.Model;
    using CrossDomain.Integration.OverrideDate;
    using CrossDomain.Integration.OverrideDate.DataStore.Extensions;
    using Pages;
    using TechTalk.SpecFlow;

    [Binding]
    public class EnrichActualsSteps
    {
        private readonly EnrichReportedActualsPageObject _enrichPageObject;
        private readonly RetrieveSummarisedActualsPageObject _retrieveSummarisedActualsPageObject;
        private readonly OverrideDateDBContext _overrideDateDbContext;

        public EnrichActualsSteps(EnrichReportedActualsPageObject pageObject, RetrieveSummarisedActualsPageObject retrieveSummarisedActualsPageObject)
        {
            _enrichPageObject = pageObject;
            _retrieveSummarisedActualsPageObject = retrieveSummarisedActualsPageObject;

            _overrideDateDbContext = new OverrideDateDBContext();
            _overrideDateDbContext.SetOverrideDate("04/10/2015");
        }

        [AfterScenario("RetainActualsAuditTrail")]
        public void RemoveData()
        {
            _enrichPageObject.RemoveDataInCrm();
            _overrideDateDbContext.ResetOverrideDate();

            // note ClearAllocationDeliverablePeriodActualAudits doesn't actually use the passed in actual audits
            // if it is changed so it does, this won't work
            _enrichPageObject.ClearAllocationDeliverablePeriodActualAudits(null);
        }

        [Given(@"An approved contract '(.*)' for Ukprn '(.*)' with Allocation '(.*)' exists in Dynamics CRM")]
        public void GivenAnApprovedContractForUkprnWithAllocationExistsInDynamicsCRM(string p0, string p1, string p2)
        {
            _enrichPageObject.CreateDataInCrm(p0, p1, p2);
        }

        [Given(@"the following data is available in the Monitoring Deliverable Repository")]
        public void GivenTheFollowingDataIsAvailableInTheMonitoringDeliverableRepository(Table table)
        {
            var allocationDeliverablePeriods = table.Rows
                .Select(r => new AllocationDeliverablePeriod
                {
                    FundingStreamPeriodCode = r["FundingStreamPeriodCode"],
                    AllocationEndDate = DateTime.ParseExact(r["AllocationEndDate"], "dd/MM/yyyy", CultureInfo.InvariantCulture),
                    AllocationStartDate = DateTime.ParseExact(r["AllocationStartDate"], "dd/MM/yyyy", CultureInfo.InvariantCulture),
                    ContractNumber = r["Contract Number"],
                    ContractAllocationNumber = r["ContractAllocationNumber"],
                    ContractSubVersionNumber = int.Parse(r["Contract sub version"]),
                    ContractVersionNumber = int.Parse(r["Contract Version"]),
                    DeliverableCode = int.Parse(r["DeliverableCode"]),
                    OrganisationId = r["OrganisationId"],
                    Period = r["Period"],
                    Ukprn = r["UKPRN"],
                    UopCode = r["UoPCode"]
                }).ToList();

            _enrichPageObject.ClearAllocationDeliverablePeriods(allocationDeliverablePeriods);
            _enrichPageObject.StoreAllocationDeliverablePeriods(allocationDeliverablePeriods);
        }

        [Then(@"the DEDS stub is cleared")]
        public void ThenTheDEDSStubIsCleared()
        {
            _retrieveSummarisedActualsPageObject.ClearStorage(true, false, false, false, false, false);
        }

        [Then(@"the AllocationDeliverablePeriodActualAudit table includes the following")]
        [Then(@"the following are stored in the Data Store")]
        public void ThenTheFollowingAreStoredInTheDataStore(Table table)
        {
            IEnumerable<AllocationDeliverablePeriodActualAudit> allocationDeliverablePeriodActualAudits = table.Rows
              .Select(r => new AllocationDeliverablePeriodActualAudit
              {
                  CollectionType = r["CollectionType"],
                  CollectionReturnCode = r["CollectionReturnCode"],
                  OrganisationId = r["OrganisationId"],
                  PeriodTypeCode = r["PeriodTypeCode"],
                  Period = r["Period"],
                  FundingStreamPeriodCode = r["FundingStreamPeriodCode"],
                  DeliverableCode = int.Parse(r["DeliverableCode"]),
                  ContractAllocationNumber = r["AllocationNumber"],
                  ContractNumber = r["ContractNumber"],
                  ActualValue = double.Parse(r["ActualValue"]),
                  ActualVolume = long.Parse(r["ActualVolume"]),
                  Ukprn = r["UKPRN"],
                  ContractVersion = int.Parse(r["ContractVersion"]),
                  ContractSubVersion = int.Parse(r["ContractSubVersion"]),
                  CollectionReturnPeriod = int.Parse(r["CurrentPeriod"]),
                  AllocationStartDate =
                      DateTime.ParseExact(r["AllocationStartDate"], "dd/MM/yyyy", CultureInfo.InvariantCulture),
                  AllocationEndDate =
                      DateTime.ParseExact(r["AllocationEndDate"], "dd/MM/yyyy", CultureInfo.InvariantCulture),
                  ParentDeliverableCode = int.Parse(r["ParentDeliverableCode"]),
                  UopCode = r["UopCode"]
              });

            _enrichPageObject.ExpectedDataStoreRowCount = allocationDeliverablePeriodActualAudits.Count();
            _enrichPageObject.WaitTillAllocationDeliverablePeriodActualAuditPopulated();
            _enrichPageObject.ValidateAllocationDeliverablePeriodActualAudit(allocationDeliverablePeriodActualAudits);
        }

        [Then(@"the override date is changed to\t'(.*)'")]
        public void ThenTheOverrideDateIsChangedTo(string p0)
        {
            _overrideDateDbContext.SetOverrideDate(p0);
        }

    }
}
