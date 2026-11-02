namespace FCT.Operations.Common.Tests.Tools
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.OverrideDate;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Model;

    [TestClass]
    public class ActualsPollingResetTools
    {
        // connection settings
        private const string AzureStorageConnectionString = "";
        private const string AzureTableSuffix = "OAT";
        private const string SqlConnectionString = "";

        // reset values
        private static readonly DateTime SystemOverrideDateToSet = new DateTime(2020, 09, 04, 20, 00, 00, DateTimeKind.Utc);
        private static readonly DateTime LastClosedCollectionDateToSet = new DateTime(2020, 09, 02, 15, 00, 00, DateTimeKind.Utc);

        private static readonly ActualsCollectionInfo[] CollectionsToRemove =
        {
            new ActualsCollectionInfo {CollectionType = "ESF", CollectionReturnCode = "ESF56"},
            new ActualsCollectionInfo {CollectionType = "ILR2021", CollectionReturnCode = "R01"},
            new ActualsCollectionInfo {CollectionType = "APPS", CollectionReturnCode = "APPS40"}
        };
        private const string CollectionReturnPeriodToRemoveFromActualsAudit = "202008";

        [TestMethod, TestCategory("DataDependentOAT")]
        public void ResetSystemToReceiveActuals()
        {
            /* Uncomment this section if clearing down the Azure table storage staging for DEDS

            AzureTableStore azureTableStore = new AzureTableStore(AzureStorageConnectionString);

            // set LastClosedTime on all entries in ClosedCollectionHistory
            List<ClosedCollectionHistory> closedCollectionHistories = azureTableStore.GetRows<ClosedCollectionHistory>($"ClosedCollectionHistory{AzureTableSuffix}").ToList();
            if (!closedCollectionHistories.Any())
            {
                Assert.Fail("We have to have some closed collection histories to set with the last closed time.");
            }
            closedCollectionHistories.ForEach(cch =>
            {
                cch.LastClosedTime = LastClosedCollectionDateToSet;
                azureTableStore.ReplaceRow($"ClosedCollectionHistory{AzureTableSuffix}", cch);
            });

            // delete the 3 remaining azure staging tables, these will be recreated when actuals are pulled
            try { azureTableStore.DeleteTable($"ActualsCollectionTypeSummary{AzureTableSuffix}"); } catch (Microsoft.WindowsAzure.Storage.StorageException) { }
            try { azureTableStore.DeleteTable($"ActualAllocationGroupEntity{AzureTableSuffix}"); } catch (Microsoft.WindowsAzure.Storage.StorageException) { }
            try { azureTableStore.DeleteTable($"ReportedActual{AzureTableSuffix}"); } catch (Microsoft.WindowsAzure.Storage.StorageException) { }
            
             */

            MonitoringDeliverablesDbContext monitoringDeliverablesDbContext = new MonitoringDeliverablesDbContext(new SqlConnection(SqlConnectionString));
            OverrideDateDBContext overrideDateDbContext = new OverrideDateDBContext(new SqlConnection(SqlConnectionString));

            // clear down MonitoringDeliverables.SummarisedActual for SLD
            monitoringDeliverablesDbContext.Database.ExecuteSqlCommand("TRUNCATE TABLE MonitoringDeliverables.SummarisedActual");

            // set a row in MonitoringDeliverables.ClosedCollection with the appropriate ClosedTime for SLD
            monitoringDeliverablesDbContext.Database.ExecuteSqlCommand("DELETE FROM MonitoringDeliverables.ClosedCollection");
            monitoringDeliverablesDbContext.ClosedCollections.Add(new ClosedCollection("TEST", "TEST01", LastClosedCollectionDateToSet, 0));
            monitoringDeliverablesDbContext.SaveChanges();

            CollectionsToRemove.ForEach(collection =>
            {
                // clear down actuals audit by collection type/return code
                monitoringDeliverablesDbContext.Database.ExecuteSqlCommand(
                    "DELETE FROM MonitoringDeliverables.AllocationDeliverablePeriodActualAudit WHERE CollectionType = @collectionType AND CollectionReturnCode = @collectionReturnCode",
                    new SqlParameter("@collectionType", collection.CollectionType),
                    new SqlParameter("@collectionReturnCode", collection.CollectionReturnCode));

                // clear down actuals audit by collection return period
                monitoringDeliverablesDbContext.Database.ExecuteSqlCommand(
                    "DELETE FROM MonitoringDeliverables.AllocationDeliverablePeriodActualAudit WHERE CollectionReturnPeriod = @collectionReturnPeriod",
                    new SqlParameter("@collectionReturnPeriod", CollectionReturnPeriodToRemoveFromActualsAudit));

                // clear down payment instruction audit by collection type/return code
                monitoringDeliverablesDbContext.Database.ExecuteSqlCommand(
                    "DELETE FROM MonitoringDeliverables.PaymentInstructionAudit WHERE CollectionType = @collectionType AND CollectionReturnCode = @collectionReturnCode",
                    new SqlParameter("@collectionType", collection.CollectionType),
                    new SqlParameter("@collectionReturnCode", collection.CollectionReturnCode));

                // clear down payment instruction audit by collection return period
                monitoringDeliverablesDbContext.Database.ExecuteSqlCommand(
                    "DELETE FROM MonitoringDeliverables.PaymentInstructionAudit WHERE CollectionReturnPeriod = @collectionReturnPeriod",
                    new SqlParameter("@collectionReturnPeriod", CollectionReturnPeriodToRemoveFromActualsAudit));

                // clear down HeldReportedActualGroup by collection type/return code
                monitoringDeliverablesDbContext.Database.ExecuteSqlCommand(
                    "DELETE FROM MonitoringDeliverables.HeldReportedActualGroup WHERE CollectionType = @collectionType AND CollectionReturnCode = @collectionReturnCode",
                    new SqlParameter("@collectionType", collection.CollectionType),
                    new SqlParameter("@collectionReturnCode", collection.CollectionReturnCode));
            });

            // set override date
            overrideDateDbContext.Database.ExecuteSqlCommand("DELETE FROM OverrideDate.OverrideDate");
            overrideDateDbContext.OverrideDate.Add(new OverrideDate { SystemOverrideDate = SystemOverrideDateToSet });
            overrideDateDbContext.SaveChanges();
        }

        [TestMethod, TestCategory("DataDependentOAT")]
        public void SetSystemOverrideDate()
        {
            OverrideDateDBContext overrideDateDbContext = new OverrideDateDBContext(new SqlConnection(SqlConnectionString));

            // clear out and set override date
            overrideDateDbContext.Database.ExecuteSqlCommand("DELETE FROM OverrideDate.OverrideDate");
            overrideDateDbContext.Database.ExecuteSqlCommand("DELETE FROM OverrideDate.OverrideDateWithKey");
            overrideDateDbContext.OverrideDate.Add(new OverrideDate { SystemOverrideDate = SystemOverrideDateToSet });
            overrideDateDbContext.SaveChanges();
        }

        private class ActualsCollectionInfo
        {
            public string CollectionType { get; set; }

            public string CollectionReturnCode { get; set; }
        }
    }
}
