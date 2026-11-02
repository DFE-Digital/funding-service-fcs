namespace SFA.FCT.Contracts.AcceptanceTests.Pages
{
    using System.Collections.Generic;
    using System.Configuration;
    using Aspose.Cells;
    using CrossDomain.Integration.Common.Storage;
    using Infrastructure;
    using MoreLinq;
    using TechTalk.SpecFlow;
    using Utilities.DTO;

    public class CdaReportPageObject
    {
        private readonly string _cdaListName = ConfigurationManager.AppSettings["CdaReportListName"];
        private const string ArchiveName = "Archive";

        public string CdaReportOutputFolder { get; } = ConfigurationManager.AppSettings["CdaReportFileSharePath"];

        public bool IsCdaCsvReportFileCreatedInDropLocation(string fileName)
        {
            string listName = _cdaListName;
            var office365StorageWrapper = new Office365StorageWrapper();
            return office365StorageWrapper.DoesFileExist(listName, fileName);
        }

        public List<CdaReportComparisonObject> GenerateCdaComparisonObjectsFromCdaReportCsvFile(string fileName)
        {
            Workbook workbook = new Workbook(fileName);
            Worksheet worksheet = workbook.Worksheets[0];
            IReadOnlyCollection<WorksheetRowReader> rowReaders = GetRowsFromSheet(worksheet);
           
            List<CdaReportComparisonObject> comparisonObjectsToReturn = new List<CdaReportComparisonObject>();
            rowReaders.ForEach(rowReader =>
            {
                    comparisonObjectsToReturn.Add(new CdaReportComparisonObject
                    {
                        Fundingstreamperiodcode = rowReader[0],
                        Ukprn = rowReader[1],
                        ProviderName = rowReader[2].Replace("\"", string.Empty),
                        DeliveryUkprn = rowReader[3],
                        DeliveryProviderName = rowReader[4].Replace("\"", string.Empty),
                        ContractAllocationNumber = rowReader[5],
                        ContractNumber = rowReader[6],
                        MasterContractReference = rowReader[7],
                        ContractAllocationStartDate = rowReader[8],
                        ContractAllocationEndDate = rowReader[9],
                        ContractVersionNumber = rowReader[10],
                        ContractStatus = rowReader[11],
                        ContractSubStatus = rowReader[12],
                        DeliverableDescription = rowReader[13].Replace("\"", string.Empty),
                        Deliverable = rowReader[14].Replace("\"", string.Empty),
                        DeliverableParent = rowReader[15].Replace("\"", string.Empty),
                        DeliverablePeriod = rowReader[16],
                        DeliverableYear = rowReader[17],
                        FinancialYear = rowReader[18],
                        PlanningUnit = rowReader[19],
                        PlannedValue = rowReader[20],
                        ActualEarned = rowReader[21],
                        PlannedVolume = rowReader[22],
                        ActualVolume = rowReader[23],
                        PayableDeliverable = rowReader[24],
                        ProfilePayment = rowReader[25],
                        BalancingPayment = rowReader[26],
                        ReconciliationPayment = rowReader[27],
                        CappingPayment = rowReader[28],
                        TotalNetPayment = rowReader[29],
                        PaymentHeld = rowReader[30],
                        PaymentPosted = rowReader[31],
                        UnitOfProcurement = rowReader[32],
                        Lep = rowReader[33],
                        SubnominalProfile = rowReader[34],
                        SubnominalReconciliation = rowReader[35],
                        SubnominalCapping = rowReader[36],
                        DeliverableMonth = rowReader[37]
                    });
            });
            return comparisonObjectsToReturn;
        }

        private IReadOnlyCollection<WorksheetRowReader> GetRowsFromSheet(Worksheet worksheet)
        {
            List<WorksheetRowReader> rows = new List<WorksheetRowReader>();
            int numRows = worksheet.Cells.GetLastDataRow(0) + 1;
            for (int i = 0; i < numRows; i++)
            {
                rows.Add(new WorksheetRowReader(worksheet.Cells.Rows[i]));
            }

            return rows;
        }

        public List<CdaReportComparisonObject> GenerateCdaComparisonObjectsFromSpecflowTable(Table table)
        {
            List<CdaReportComparisonObject> comparisonObjectsToReturn = new List<CdaReportComparisonObject>();
            table.Rows.ForEach(row =>
            {
                comparisonObjectsToReturn.Add(new CdaReportComparisonObject
                {
                    Fundingstreamperiodcode = row["FundingStreamPeriodCode"],
                    Ukprn = row["UKPRN"],
                    ProviderName = row["ProviderName"],
                    DeliveryUkprn = row["DeliveryUKPRN"],
                    DeliveryProviderName = row["DeliveryProviderName"],
                    ContractAllocationNumber = row["ContractAllocationNumber"],
                    ContractNumber = row["ContractNumber"],
                    MasterContractReference = row["MasterContractReference"],
                    ContractAllocationStartDate = row["ContractAllocationStartDate"],
                    ContractAllocationEndDate = row["ContractAllocationEndDate"],
                    ContractVersionNumber = row["ContractVersionNumber"],
                    ContractStatus = row["ContractStatus"],
                    ContractSubStatus = row["ContractSubStatus"],
                    DeliverableDescription = row["DeliverableDescription"],
                    Deliverable = row["Deliverable"],
                    DeliverableParent = row["DeliverableParent"],
                    DeliverablePeriod = row["DeliverablePeriod"],
                    DeliverableYear = row["DeliverableYear"],
                    FinancialYear = row["FinancialYear"],
                    PlanningUnit = row["PlanningUnit"],
                    PlannedValue = row["PlannedValue"],
                    ActualEarned = row["ActualEarned"],
                    PlannedVolume = row["PlannedVolume"],
                    ActualVolume = row["ActualVolume"],
                    PayableDeliverable = row["PayableDeliverable"],
                    ProfilePayment = row["ProfilePayment"],
                    BalancingPayment = row["BalancingPayment"],
                    ReconciliationPayment = row["ReconciliationPayment"],
                    CappingPayment = row["CappingPayment"],
                    TotalNetPayment = row["TotalNetPayment"] ?? "0",
                    PaymentHeld = row["PaymentHeld"],
                    PaymentPosted = row["PaymentPosted"],
                    UnitOfProcurement = row["UnitOfProcurement"],
                    Lep = row["LEP"],
                    SubnominalProfile = row["SubnominalProfile"],
                    SubnominalReconciliation = row["SubnominalReconciliation"],
                    SubnominalCapping = row["SubnominalCapping"],
                    DeliverableMonth = row["DeliverableMonth"]
                });
            });
            return comparisonObjectsToReturn;
        }

        public byte[] GetFile(string reportName)
        {
            var office365StorageWrapper = new Office365StorageWrapper();
            return office365StorageWrapper.GetFileContents(reportName, _cdaListName);
        }
    }
}
