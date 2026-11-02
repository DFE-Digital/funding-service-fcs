namespace FCT.Operations.FundingConfirmationReport.Services
{
    using System;
    using System.Collections.Generic;
    using System.Drawing;
    using System.Linq;
    using System.IO;
    using Aspose.Cells;
    using DTOs;
    using Extensions;
    using Operations.Extensions;
    using SFA.FCS.Worker.Common.Slack;

    public class ExcelGeneratorFundingConfirmationReport : IExcelReportGenerator
    {
        private const int FspColStartIndex = 4;
        private static readonly string FontName = "Arial";
        private static readonly int FontSize = 11;

        private static readonly IDictionary<string, string> ProviderTypeDictionary = new Dictionary<string, string>
        {
            {"GFEC", "General FE College incl Tertiary"},
            {"TC", "General FE College incl Tertiary"},
            {"SFC", "Sixth Form College"},
            {
                "A&HC",
                "Special Colleges - (Agriculture and Horticulture & Art Design and Performing Arts), Specialist Designated College"
            },
            {
                "DC",
                "Special Colleges - (Agriculture and Horticulture & Art Design and Performing Arts), Specialist Designated College"
            },
            {
                "AD&PA",
                "Special Colleges - (Agriculture and Horticulture & Art Design and Performing Arts), Specialist Designated College"
            },
            {"ACAD","Academy" },
            {"HEI","Higher Education Institution" },
            {"LA","Local Authority" },
            {"OPF","Other Public Funded" },
            {"SPI","Special Post-16 Institution"},
            {"n/a", "n/a"}
        };

        public Workbook GenerateWorkbook(IReadOnlyCollection<ReportRow> reportRows, string title)
        {
            SetupAsposeLicence();

            var workbook = new Workbook();

            workbook.BuiltInDocumentProperties.LastSavedBy = "FCS";
            workbook.BuiltInDocumentProperties.Author = "FCS";
            workbook.Worksheets.Clear();
            Worksheet sheet = workbook.Worksheets.Add("Funding Confirmations");
            PopulateSheet(sheet, reportRows);
            FormatColumnHeaders(sheet.Cells);
            
            sheet.FreezePanes("D5", 4, 4);
            sheet.AutoFilter.Range = "A4:D4";
            workbook.BuiltInDocumentProperties.Title = title;
            return workbook;
        }

        private static void FormatColumnHeaders(Cells cells)
        {
            cells.Merge(0,0,2,50);
            cells.Merge(2, 0, 2, 1);
            cells.Merge(2, 1, 2, 1);
            cells.Merge(2, 2, 2, 1);
            cells.Merge(2, 3, 2, 1);
            PutStringValue(cells, 0, 0, "OFFICIAL SENSITIVE")
                .WithForegroundColour(Color.Red)
                .WithVerticalAlignment(TextAlignmentType.Top);
            PutHeaderStringValue(cells, 0, 2, "Comment", Color.LightSkyBlue).WithVerticalMediumBorder();
            PutHeaderStringValue(cells, 1, 2, "UKPRN", Color.LightSkyBlue).WithVerticalMediumBorder();
            PutHeaderStringValue(cells, 2, 2, "Provider Name", Color.LightSkyBlue).WithVerticalMediumBorder();
            PutHeaderStringValue(cells, 3, 2, "Provider Type", Color.LightSkyBlue).WithVerticalMediumBorder();
          
            cells["A4"].WithVerticalMediumBorder();
            cells["B4"].WithVerticalMediumBorder();
            cells["C4"].WithVerticalMediumBorder();
            cells.SetColumnWidth(0, 46);
            cells.SetColumnWidth(1, 12);
            cells.SetColumnWidth(2, 46);
            cells.SetColumnWidth(3, 60);
        }

        private static void PopulateSheet(Worksheet sheet, IReadOnlyCollection<ReportRow> reportRows)
        {
            var dataRowLine = 4;
            if (reportRows.Any())
            {
                var fsps = reportRows.GetDistinctFspsAndOrder();

                var fspColumnData = PopulateFspColumns(sheet.Cells, fsps);
               
                var fspColumnDataDictionary = fspColumnData.fspColumnData.ToDictionary(f => f.FspDesc);
                
                reportRows
                    .OrderBy(r => r.ProviderName)
                    .ToList()
                    .ForEach(reportRow =>
                    {
                        sheet.Cells.SetRowHeight(dataRowLine, 15);
                        PopulateRow(sheet.Cells, dataRowLine, reportRow, fspDesc => fspColumnDataDictionary[fspDesc].StartCol, fsps );
                        Enumerable.Range(4, fspColumnData.totalColumns).ToList().ForEach(colIndex =>
                        {
                            sheet.Cells[dataRowLine, colIndex].SetCellFormatAndStyleNotBorder(TextAlignmentType.Center);
                        });
                        dataRowLine++;
                    });

                var numCols = fspColumnData.totalColumns + 4;
                // set the border on the bottom
                Enumerable.Range(0, numCols).ToList()
                    .ForEach(colIndex => sheet.Cells[dataRowLine-1, colIndex].SetBottomBorderMedium());

                // set the border on the right
                Enumerable.Range(0, dataRowLine).ToList()
                    .ForEach(rowIndex => sheet.Cells[rowIndex, fspColumnData.totalColumns + 3].SetRightBorderMedium());

                // set the border on the top
                Enumerable.Range(0, numCols).ToList()
                    .ForEach(colIndex => sheet.Cells[2, colIndex].SetTopBorderMedium());

                // set the border below header
                Enumerable.Range(0, numCols).ToList()
                    .ForEach(colIndex => sheet.Cells[3, colIndex].SetBottomBorderMedium());
            }
        }

        private static (IReadOnlyCollection<FspColumnData> fspColumnData, int totalColumns) PopulateFspColumns(Cells cells, IReadOnlyCollection<(string fspDesc, int order, PaymentMethod paymentMethod)> fsps)
        {
            var fspColIndex = FspColStartIndex;
            const int fspHeaderRow = 2;
            const int fspValueColWidth = 19;
            cells.SetRowHeight(fspHeaderRow, 56);
            cells.SetRowHeight(fspHeaderRow + 1, 30);
            var fspColumnDataItems = new List<FspColumnData>();
            var totalCols = 0;

            int fpsCount = 0;
            Color GetColorForColIndex(int i) => i % 2 == 0 ? Color.AliceBlue : Color.LightGray;

            fsps.OrderBy(f => f.order).ToList().ForEach(fsp =>
            {
                var colour = GetColorForColIndex(fpsCount++);
                PutHeaderStringValue(cells, fspColIndex, fspHeaderRow, fsp.fspDesc, colour).WithVerticalMediumBorder();
                
                if (fsp.paymentMethod == PaymentMethod.PayOnInstruction)
                {
                    PutHeaderStringValue(cells, fspColIndex, fspHeaderRow +1, "Funded", colour)
                        .WithTopThinMediumLeftBorder();
                    totalCols++;
                }
                else
                {
                    cells.Merge(fspHeaderRow, fspColIndex, 1, 2);
                    var columnAHeading = GetColumnAHeading(fsp.paymentMethod);
                    PutHeaderStringValue(cells, fspColIndex, fspHeaderRow + 1, columnAHeading, colour)
                        .WithTopThinMediumLeftBorder();
                    PutHeaderStringValue(cells, fspColIndex + 1, fspHeaderRow + 1, "Funded", colour)
                        .WithTopAndLeftThinBorder();
                    totalCols += 2;
                }
                
                cells.SetColumnWidth(fspColIndex, fspValueColWidth);
                cells.SetColumnWidth(fspColIndex + 1, fspValueColWidth);
                fspColumnDataItems.Add(new FspColumnData(fsp.fspDesc, fspColIndex));
                fspColIndex += fsp.paymentMethod == PaymentMethod.PayOnInstruction ? 1 : 2;
            });
            
            return (fspColumnDataItems, totalCols);
        }

        private static string GetColumnAHeading(PaymentMethod paymentMethod)
        {
            return paymentMethod == PaymentMethod.PayOnActuals ? "Earned" : "Allocation";
        }

        private static void PopulateRow(Cells cells, int rowIndex, ReportRow reportRow,
            Func<string, int> getColumnForFsp,
            IReadOnlyCollection<(string fspDesc, int order, PaymentMethod paymentMethod)> fsps)
        {
            PutSimpleStringValue(cells, 0, rowIndex, string.Empty)
                .WithAlignment(horizontalAlignment:TextAlignmentType.Left, verticalAlignmentType:TextAlignmentType.Left)
                .WithThinBorder();
            PutIntValue(cells, 1, rowIndex, reportRow.Ukprn).WithNumberFormat().WithThinBorder();
            PutStringValue(cells, 2, rowIndex, reportRow.ProviderName);
            PutStringValue(cells, 3, rowIndex, reportRow.ProviderType);
            var fullSetOfFsps = fsps.Select(fsp => fsp.ToFspAllocationAndFunded(reportRow)).ToList();
            fullSetOfFsps
                .ForEach(fsp =>
                {
                    var fspColIndex = getColumnForFsp(fsp.Desc);
                    PutDecimalValue(cells, fspColIndex++, rowIndex, fsp.AllocationValue).WithLeftMediumBorder();
                    if (fsp.PaymentMethod != PaymentMethod.PayOnInstruction)
                    {
                        PutDecimalValue(cells, fspColIndex, rowIndex, fsp.FundedValue).WithRightMediumBorder();
                    }
                });
        }

        private static Cell PutSimpleStringValue(Cells cells, int colIndex, int rowIndex, string value)
        {
            var cell = cells[rowIndex, colIndex];
            cell.PutValue(value);
            
            return cell;
        }
        private static Cell PutStringValue(Cells cells, int colIndex, int rowIndex, string value, TextAlignmentType alignment = TextAlignmentType.Left, bool isBold = false)
        {
            var cell = cells[rowIndex, colIndex];
            cell.PutValue(value);
            if (alignment == TextAlignmentType.Center)
            {
                cell.SetCellFormatAndStyle(alignment).WithFont(FontName, FontSize, isBold);
            }
            else
            {
                cell.SetCellFormatAndStyle().WithFont(FontName, FontSize, isBold);
            }

            return cell;
        }

        private static Cell PutHeaderStringValue(Cells cells, int colIndex, int rowIndex, string value, Color color)
        {
            var cell = cells[rowIndex, colIndex];
            cell.PutValue(value);
            cell.SetBold()
                .WithAlignment()
                .SetWrap()
                .SetBackgroundColour(color)
                .WithFont(FontName, FontSize, true);
              //  .WithVerticalMediumBorder();

            return cell;
        }

        private static Cell PutDecimalValue(Cells cells, int colIndex, int rowIndex, decimal value)
        {
            var cell = cells[rowIndex, colIndex];
            var style = cell.GetStyle();
            style.Custom = "£#,##0";
            cell.SetStyle(style);
            value = value.RoundToNearestPound();
            cell.PutValue(value);
            cell.SetCellFormatAndStyle().WithFont(FontName, FontSize);
            cell.CenterHorizontalAlignment();

            return cell;
        }

        private static Cell PutIntValue(Cells cells, int colIndex, int rowIndex, int value)
        {
            var cell = cells[rowIndex, colIndex];
            var style = cell.GetStyle();
            style.Custom = "£#,##0";
            cell.SetStyle(style);
            cell.PutValue(value);
            cell.WithFont(FontName, FontSize);
            cell.CenterHorizontalAlignment();

            return cell;
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

        private static void SetupAsposeLicence()
        {
            using (Stream licenseStream = LicenseManager.GetAsposeLicense())
            {
                License license = new License();
                license.SetLicense(licenseStream);
            }
        }

        private class FspColumnData
        {
            public FspColumnData(string fspDesc, int startCol)
            {
                FspDesc = fspDesc;
                StartCol = startCol;
            }

            public string FspDesc { get; }
            public int StartCol { get; }
        }
    }
}
