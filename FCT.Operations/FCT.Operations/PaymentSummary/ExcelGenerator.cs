namespace FCT.Operations.PaymentSummary
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Aspose.Cells;
    using Extensions;
    using License = Aspose.Cells.License;
    using FCT.Operations.PaymentSummary.Services;
    using System;

    public class ExcelGenerator : IExcelGenerator
    {
        private const int HeaderRow = 3;
        private const int FirstExcelDataRow = 5; // excel starts at 1 rather than 0
        private const int FspColStartIndex = 2;


        public Workbook GenerateWorkbook(IReadOnlyCollection<PaymentSummaryLine> paymentSummaryLines, IReadOnlyCollection<PaymentSummaryLine> payment1619SummaryLines, ReportingPeriod reportingPeriod, IPaymentSummaryReportService service)
        {
            SetupAsposeLicence();

            using (var stream = GetStreamForTemplate())
            {
                int sheetCount = 0;
                Workbook workbook = new Workbook(stream);

                workbook.BuiltInDocumentProperties.Title = reportingPeriod.ToPaymentSummaryReportWorkbookTitle();
                workbook.BuiltInDocumentProperties.LastSavedBy = "FCS";
                var dfeSummaryLines = paymentSummaryLines.Where(pl => pl.AgencyPayment == "DFE").ToList();
                var dwpSummaryLines = paymentSummaryLines.Where(pl => pl.AgencyPayment == "DWP").ToList();

                int providerLine = 4;

                for (int i = 0; i < 3; i++)
                {
                    var sheet = workbook.Worksheets[i];

                    if (sheetCount == 0)
                    {
                        var dfeLine = service.FilterOutUnnecessaryLines(dfeSummaryLines);
                        GenerateWorksheet(dfeLine, providerLine, sheet);
                        sheetCount = 1;
                        providerLine = 4;
                    }
                    else if (sheetCount == 1)
                    {
                        var dwpLine = service.FilterOutUnnecessaryLines(dwpSummaryLines);
                        GenerateWorksheet(dwpLine, providerLine, sheet);
                        sheetCount = 2;
                    }
                    else if (sheetCount == 2)
                    {

                        var payment1619Line = service.FilterOutUnnecessaryLines1619(payment1619SummaryLines);
                        Generate1619Worksheet(payment1619Line, providerLine, sheet);
                    }
                    UpdatePeriod(sheet.Cells, reportingPeriod.Period);


                }

                return workbook;
            }
        }



        private void Generate1619Worksheet(IReadOnlyCollection<PaymentSummaryLine> paymentSummaryLines, int providerLine, Worksheet sheet)
        {
            const int ukprnColIndex = 0;
            const int parentProviderNameColIndex = 1;
            const int childUkprnColIndex = 2;
            const int childProviderNameColIndex = 3;
            const int Fsp1619ColStartIndex = 4;

            if (paymentSummaryLines.Any())
            {
                // Collect all unique FSPs across all payments
                var fspNames = paymentSummaryLines
                    .SelectMany(p => p.Payments)
                    .Select(p => p.Fsp)
                    .Distinct()
                    .OrderBy(fsp => fsp)
                    .ToList();

                var amountPaidColIndex = Fsp1619ColStartIndex + fspNames.Count;

                AddFspColumns(sheet.Cells, fspNames, Fsp1619ColStartIndex);

                var groupedLines = paymentSummaryLines
                    .GroupBy(psl => new { psl.Ukprn, psl.ChildUkprn })
                    .OrderBy(group => group.Key.Ukprn);

                foreach (var group in groupedLines)
                {
                    var representative = group.First();

                    // Only sum Totalpaid from RowNum == 1 to avoid duplication
                    var totalPaid = group
                        .SelectMany(g => g.Payments)
                        .Where(p => p.RowNum == 1)
                        .Sum(p => p.Totalpaid);

                    sheet.Cells.InsertRow(providerLine);
                    sheet.Cells.SetRowHeight(providerLine, 15);

                    sheet.Cells[providerLine, ukprnColIndex].PutValue(representative.Ukprn);
                    sheet.Cells[providerLine, ukprnColIndex].SetProviderCellFormatAndStyle();

                    sheet.Cells[providerLine, parentProviderNameColIndex].PutValue(representative.ParentTradingName);
                    sheet.Cells[providerLine, parentProviderNameColIndex].SetProviderCellFormatAndStyle();

                    sheet.Cells[providerLine, childUkprnColIndex].PutValue(representative.ChildUkprn);
                    sheet.Cells[providerLine, childUkprnColIndex].SetProviderCellFormatAndStyle();

                    sheet.Cells[providerLine, childProviderNameColIndex].PutValue(representative.ChildTradingName);
                    sheet.Cells[providerLine, childProviderNameColIndex].SetProviderCellFormatAndStyle();

                    var amountpaidCell = sheet.Cells[providerLine, amountPaidColIndex];
                    amountpaidCell.PutValue(totalPaid);
                    amountpaidCell.Set1619PaymentValueDefaultStyle();
                    amountpaidCell.SetDataRowFormatAndStyle1619();
                    amountpaidCell.SetProviderCellFormatAndStyle1619();

                    int fspCol = Fsp1619ColStartIndex;

                    // Sum payments per FSP across all rows
                    foreach (var fspCode in fspNames)
                    {
                        var paymentTotal = group
                            .SelectMany(g => g.Payments)
                            .Where(p => p.Fsp == fspCode)
                            .Sum(p => p.Payment);

                        var cell = sheet.Cells[providerLine, fspCol++];
                        cell.PutValue(paymentTotal);
                        cell.Set1619PaymentValueDefaultStyle();
                        cell.SetDataRowFormatAndStyle();
                    }

                    providerLine++;
                }

                AddFspColumnFormulas1619(sheet.Cells, providerLine, amountPaidColIndex, Fsp1619ColStartIndex);
                AddFspColumnFormulas(sheet.Cells, providerLine, fspNames.Count, Fsp1619ColStartIndex);
                UpdateGrandTotalHeaderRow(sheet.Cells, 1, providerLine + 1, Fsp1619ColStartIndex, fspNames.Count);
                UpdateGrandTotalHeaderRow1619(sheet.Cells, 1, providerLine + 1, amountPaidColIndex, paymentSummaryLines.Count);
                TidyUkprnProviderNameCellBordersfor1619(sheet.Cells, ukprnColIndex, parentProviderNameColIndex, childUkprnColIndex, childProviderNameColIndex, amountPaidColIndex);
            }
        }





        private void GenerateWorksheet(IReadOnlyCollection<PaymentSummaryLine> paymentSummaryLines, int providerLine, Worksheet sheet)
        {
            const int ukprnColIndex = 0;
            const int providerNameColIndex = 1;
            if (paymentSummaryLines.Any())
            {

                var fspNames = paymentSummaryLines.First().Payments.Select(p => p.Fsp).ToList();
                AddFspColumns(
                    sheet.Cells,
                    fspNames,
                    FspColStartIndex);

                paymentSummaryLines
                    .OrderBy(psl => psl.Ukprn)
                    .ToList()
                    .ForEach(paymentSummaryLine =>
                    {
                        sheet.Cells.InsertRow(providerLine);
                        sheet.Cells.SetRowHeight(providerLine, 15);
                        var ukprnCell = sheet.Cells[providerLine, ukprnColIndex];
                        ukprnCell.PutValue(paymentSummaryLine.Ukprn);
                        ukprnCell.SetProviderCellFormatAndStyle();
                        var providerNameCell = sheet.Cells[providerLine, providerNameColIndex];
                        providerNameCell.PutValue(paymentSummaryLine.ProviderName);
                        providerNameCell.SetProviderCellFormatAndStyle();

                        int fspCol = FspColStartIndex;
                        paymentSummaryLine.Payments
                                .OrderBy(p => p.Fsp)
                                .ToList()
                                .ForEach(fspPayment =>
                                {
                                    var cell = sheet.Cells[providerLine, fspCol++];
                                    cell.PutValue(fspPayment.Payment);
                                    cell.SetPaymentValueDefaultStyle();
                                    cell.SetDataRowFormatAndStyle();
                                });

                        providerLine++;
                    });

                AddFspColumnFormulas(sheet.Cells, providerLine, fspNames.Count, FspColStartIndex);
                AddRowTotalFormulas(sheet.Cells, FspColStartIndex + fspNames.Count, paymentSummaryLines.Count);
                UpdateGrandTotalHeaderRow(sheet.Cells, 1, providerLine + 1, FspColStartIndex, fspNames.Count);
                TidyUkprnProviderNameCellBorders(sheet.Cells, ukprnColIndex, providerNameColIndex);
            }

        }

        private static void AddFspColumns(Cells cells, IReadOnlyCollection<string> fspNames, int fspCol)
        {
            fspNames
                .OrderBy(fsp => fsp)
                .ToList()
                .ForEach(fspName =>
                {
                    cells.InsertColumn(fspCol);
                    cells.SetColumnWidth(fspCol, 19);
                    var cell = cells[HeaderRow, fspCol];
                    cell.PutValue(fspName);
                    cell.SetFspHeaderStyle();

                    fspCol++;
                });
        }

        private static void AddFspColumnFormulas(Cells cells, int columnTotalRowNumber, int numColumns, int fspColIndex)
        {
            Enumerable.Range(fspColIndex, numColumns)
                .ToList()
                .ForEach(colIndex =>
                {
                    var columnLetter = colIndex.GetExcelColumnName();
                    var cell = cells[columnTotalRowNumber, colIndex];
                    cell.Formula = $"SUM({columnLetter}{FirstExcelDataRow}:{columnLetter}{columnTotalRowNumber})";
                    cell.SetPaymentValueDefaultStyle();
                    cell.SetBold();
                });
        }

        private static void AddFspColumnFormulas1619(Cells cells, int columnTotalRowNumber, int colIndex, int fspColIndex)
        {

            var columnLetter = colIndex.GetExcelColumnName();
            var cell = cells[columnTotalRowNumber, colIndex];
            cell.Formula = $"SUM({columnLetter}{FirstExcelDataRow}:{columnLetter}{columnTotalRowNumber})";
            cell.Set1619PaymentValueDefaultStyle();


        }

        private static void AddRowTotalFormulas(Cells cells, int rowTotalColumnIndex, int numRows)
        {
            var lastColumnLetter = (rowTotalColumnIndex - 1).GetExcelColumnName();
            var firstColumnLetter = FspColStartIndex.GetExcelColumnName();
            var grandTotalRowIndex = numRows + HeaderRow + 1;
            Enumerable.Range(HeaderRow + 1, numRows + 1)
                .ToList()
                .ForEach(rowNum =>
                {
                    var excelRowNum = rowNum + 1;
                    var cell = cells[rowNum, rowTotalColumnIndex];
                    cell.Formula = $"SUM({firstColumnLetter}{excelRowNum}:{lastColumnLetter}{excelRowNum})";
                    cell.SetPaymentValueDefaultStyle();
                    cell.SetBold();
                    if (rowNum != grandTotalRowIndex)
                    {
                        cell.SetDataRowFormatAndStyle();
                    }
                });
        }

        private static void AddRowTotalFormulas1619(Cells cells, int rowTotalColumnIndex, int numRows)
        {

            var lastColumnLetter = (rowTotalColumnIndex).GetExcelColumnName();
            var firstColumnLetter = FspColStartIndex.GetExcelColumnName();
            var grandTotalRowIndex = numRows + HeaderRow + 1;
            Enumerable.Range(HeaderRow + 1, numRows + 1)
                .ToList()
                .ForEach(rowNum =>
                {
                    var excelRowNum = rowNum + 1;
                    var cell = cells[rowNum, rowTotalColumnIndex];
                    cell.Formula = $"SUM({lastColumnLetter}{excelRowNum})";
                    cell.SetPaymentValueDefaultStyle();
                    cell.SetBold();
                    if (rowNum != grandTotalRowIndex)
                    {
                        cell.SetDataRowFormatAndStyle();
                    }
                });
        }





        private static void UpdateGrandTotalHeaderRow(Cells cells, int grandTotalHeaderRowIndex, int grandTotalRowIndex, int fspColIndex, int numColumns)
        {
            Enumerable.Range(fspColIndex, numColumns)
                .ToList()
                .ForEach(colIndex =>
                {
                    var columnLetter = colIndex.GetExcelColumnName();
                    var cell = cells[grandTotalHeaderRowIndex, colIndex];
                    cell.Formula = $"{columnLetter}{grandTotalRowIndex}";
                    cell.Set1619PaymentValueDefaultStyle();
                    cell.SetBold();
                    cell.CenterHorizontalAlignment();
                });
        }

        private static void UpdateGrandTotalHeaderRow1619(Cells cells, int grandTotalHeaderRowIndex, int grandTotalRowIndex, int fspColIndex, int numColumns)
        {
            Enumerable.Range(fspColIndex, 1)
                .ToList()
                .ForEach(colIndex =>
                {
                    var columnLetter = colIndex.GetExcelColumnName();
                    var cell = cells[grandTotalHeaderRowIndex, colIndex];
                    cell.Formula = $"{columnLetter}{grandTotalRowIndex}";
                    cell.SetPaymentValueDefaultStyle();
                    cell.SetBold();
                    cell.CenterHorizontalAlignment();
                });
        }

        private static void TidyUkprnProviderNameCellBorders(Cells cells, int ukprnColIndex, int providerNameColIndex)
        {
            cells[HeaderRow, ukprnColIndex].SetBottomBorderMedium();
            cells[HeaderRow, providerNameColIndex].SetBottomBorderMedium();
        }
        private static void TidyUkprnProviderNameCellBordersfor1619(Cells cells, int ukprnColIndex, int providerNameColIndex, int childUkprnColIndex, int childproviderNameColIndex, int amountPaidColIndex)
        {
            cells[HeaderRow, ukprnColIndex].SetBottomBorderMedium();
            cells[HeaderRow, providerNameColIndex].SetBottomBorderMedium();
            cells[HeaderRow, childUkprnColIndex].SetBottomBorderMedium();
            cells[HeaderRow, childproviderNameColIndex].SetBottomBorderMedium();
            cells[HeaderRow, amountPaidColIndex].SetBottomBorderMedium();
        }

        private static void UpdatePeriod(Cells cells, string period)
        {
            var cell = cells[0, 0];
            cell.PutValue($"{period} Payments");
        }

        private static Stream GetStreamForTemplate()
        {
            return typeof(ExcelGenerator).Assembly.GetManifestResourceStream(
                $"FCT.Operations.Resources.PaymentSummaryTemplate.xlsx");
        }

        private static void SetupAsposeLicence()
        {
            using (Stream licenseStream = LicenseManager.GetAsposeLicense())
            {
                License license = new License();
                license.SetLicense(licenseStream);
            }
        }
    }
}
