namespace FCT.Operations.FundingConfirmationReport.Services
{
    using System.Collections.Generic;
    using Aspose.Cells;
    using DTOs;

    public interface IExcelReportGenerator
    {
        Workbook GenerateWorkbook(IReadOnlyCollection<ReportRow> reportRows, string title);
    }
}