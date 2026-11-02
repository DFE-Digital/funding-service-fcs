namespace FCT.Operations.FundingAllocationExtract
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using Aspose.Cells;
    using DTOs;
    using Extensions;
    using License = Aspose.Cells.License;

    public class ExcelGenerator : IExcelGenerator
    {
        private enum SheetName
        {
            Parked,
            Discarded,
        }

        private static readonly CultureInfo UkCultureInfo = new CultureInfo("en-GB");
        public Workbook GenerateWorkbook(IReadOnlyCollection<ExtractRow> parkedExtractRows, IReadOnlyCollection<ExtractRow> discardedExtractRows)
        {
            SetupAsposeLicence();

            using (var stream = GetStreamForTemplate())
            {
                var workbook = new Workbook(stream);

                workbook.BuiltInDocumentProperties.LastSavedBy = "FCS";
                workbook.BuiltInDocumentProperties.Author = "FCS";

                PopulateSheet(workbook.Worksheets["Parked"], parkedExtractRows, SheetName.Parked);
                PopulateSheet(workbook.Worksheets["Discarded"], discardedExtractRows, SheetName.Discarded);

                return workbook;
            }
        }

        private static void PopulateSheet(Worksheet sheet, IReadOnlyCollection<ExtractRow> extractRows, SheetName sheetName)
        {
            var dataRowLine = 1;

            Func<ExtractRow, DateTime> orderBy = r => r.LastParked;
            if (sheetName == SheetName.Discarded)
            {
                orderBy = r => r.LastDiscarded;
            }

            if (extractRows.Any())
            {
                extractRows
                    .OrderByDescending(orderBy)
                    .ThenBy(pfal => pfal.SubStatus)
                    .ToList()
                    .ForEach(extractRow =>
                    {
                        sheet.Cells.SetRowHeight(dataRowLine, 15);
                        PutRow(sheet.Cells, dataRowLine, extractRow, sheetName);
                        dataRowLine++;
                    });

                DisableNumberStoredAsTextError(sheet);
            }
        }

        private static void PutRow(Cells cells, int rowIndex, ExtractRow extractRow, SheetName sheetName)
        {
            string shortUkDateFormatString = UkCultureInfo.DateTimeFormat.ShortDatePattern;

            var lastParkedOrLastDiscarded = sheetName == SheetName.Parked ? extractRow.LastParked : extractRow.LastDiscarded;
            PutStringValue(cells, 0, rowIndex, lastParkedOrLastDiscarded.ToString(shortUkDateFormatString));
            PutStringValue(cells, 1, rowIndex, extractRow.FundingId);
            PutStringValue(cells, 2, rowIndex, extractRow.Ukprn);
            PutStringValue(cells, 3, rowIndex, extractRow.ProviderType);
            PutStringValue(cells, 4, rowIndex, extractRow.ProviderSubType);
            PutStringValue(cells, 5, rowIndex, extractRow.AllocationFundingStream);
            PutStringValue(cells, 6, rowIndex, extractRow.Period);
            PutStringValue(cells, 7, rowIndex, extractRow.FundingVersion);
            PutDecimalValue(cells, 8, rowIndex, extractRow.Value);
            PutStringValue(cells, 9, rowIndex, extractRow.TradingName);
            PutStringValue(cells, 10, rowIndex, extractRow.FundingPeriodCode);
            PutStringValue(cells, 11, rowIndex, extractRow.FundingTypeCode);
            PutStringValue(cells, 12, rowIndex, extractRow.FSPGroupCode);
            PutStringValue(cells, 13, rowIndex, extractRow.ContractTypeUsingProviderCategory ?? extractRow.ContractTypeUsingDefault);
            PutStringValue(cells, 14, rowIndex, extractRow.Status);
            PutStringValue(cells, 15, rowIndex, extractRow.SubStatus);

            SetCenterHorizontalAlignments(cells, rowIndex);
        }

        private static void PutStringValue(Cells cells, int colIndex, int rowIndex, string value)
        {
            var cell = cells[rowIndex, colIndex];
            cell.PutValue(value);
            cell.SetCellFormatAndStyle();
        }

        private static void PutDecimalValue(Cells cells, int colIndex, int rowIndex, decimal value)
        {
            var cell = cells[rowIndex, colIndex];
            var style = cell.GetStyle();
            style.Custom = "£#,##0.00";
            cell.SetStyle(style);

            cell.PutValue(value);
            cell.SetCellFormatAndStyle();
            cell.RightHorizontalAlignment();
        }

        private static void SetCenterHorizontalAlignments(Cells cells, int rowIndex)
        {
            cells[rowIndex, 0].CenterHorizontalAlignment();
            cells[rowIndex, 5].CenterHorizontalAlignment();
            cells[rowIndex, 6].CenterHorizontalAlignment();
            cells[rowIndex, 7].CenterHorizontalAlignment();
            cells[rowIndex, 10].CenterHorizontalAlignment();
        }

        private static void DisableNumberStoredAsTextError(Worksheet sheet)
        {
            ErrorCheckOptionCollection opts = sheet.ErrorCheckOptions;
            int index = opts.Add();
            ErrorCheckOption opt = opts[index];
            opt.SetErrorCheck(ErrorCheckType.TextNumber, false);
            opt.AddRange(CellArea.CreateCellArea(1, 0, 1000, 15));
        }

        private static Stream GetStreamForTemplate()
        {
            return typeof(ExcelGenerator).Assembly.GetManifestResourceStream(
                $"FCT.Operations.Resources.ParkingAndDiscardedExtract.xlsx");
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