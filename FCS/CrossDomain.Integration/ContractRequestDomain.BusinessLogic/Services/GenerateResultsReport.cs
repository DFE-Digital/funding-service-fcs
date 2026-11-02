namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Services
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Aspose.Cells;
    using Interfaces;
    using CrossDomain.Integration.Entities.ContractRequest;
    using Common;
    using CrossDomain.Integration.Common;
    using Extensions;

    public class GenerateResultsReport : IGenerateResultsReport
    {
        private const string ResultsColumnHeader = "Results";
        private const string ContractSheetName = "Contract";
        private const string ContractAllocationSheetName = "Contract Allocation";
        private const string DeliverableSheetName = "Deliverable";
        private const string SuccessMsg = "Success";
        private const string FailedMsg = "Failed";
        private const string InconclusiveMsg = "Operation has timed out. Please check if Contract has been created.";

        private const string ContractNumberHeader = "Contract Number";
        private const string MasterContractReferenceNumberHeader = "Master Contract Reference Number";
        private const string ContractAllocationNumberHeader = "Contract Allocation Number";

        private const int ContractNumberColumnOnContractsSheet = 1;
        private const int MasterContractNumberColumnOnContractsSheet = 4;
        private const int ContractNumberColumnOnAllocationsSheet = 1;
        private const int ContractAllocationsColumnOnAllocationsSheet = 2;
        private const int ContractAllocationsColumnOnDeliverablesSheet = 1;
        private const int MaxNumberOfCharactersInACell = 1000;

        public byte[] GenerateReport(byte[] originalFileContents, ContractRequestResult[] results, ExcelLocation[] locationMapping)
        {
            byte[] outputFileContents = null;

            using (Stream licenseStream = LicenseManager.GetAsposeLicense())
            {
                License license = new License();
                license.SetLicense(licenseStream);
            }

            using (var inputStream = new MemoryStream(originalFileContents))
            {
                using (var outputStream = new MemoryStream())
                {
                    Workbook wb = new Workbook(inputStream);

                    UpdateContracts(wb.Worksheets[ContractSheetName], results, locationMapping);
                    UpdateContractAllocations(wb.Worksheets[ContractAllocationSheetName], results, locationMapping);
                    UpdateDeliverables(wb.Worksheets[DeliverableSheetName], results, locationMapping);

                    wb.Save(outputStream, SaveFormat.Xlsx);
                    outputFileContents = outputStream.ToArray();
                }
            }

            return outputFileContents;
        }

        private string GetResultsMessage(ContractRequestResult result)
        {
            if (result != null)
            {
                if (result.Errors != null)
                {
                    HashSet<string> resultMessage = new HashSet<string> {FailedMsg};
                    foreach (errorInfoType error in result.Errors)
                    {
                        string level;
                        switch (error.level)
                        {
                            case errorInfoTypeLevel.MasterContract:
                            case errorInfoTypeLevel.Contract:
                                level = ContractSheetName;
                                break;
                            case errorInfoTypeLevel.Allocation:
                                level = ContractAllocationSheetName;
                                break;
                            case errorInfoTypeLevel.Deliverable:
                            case errorInfoTypeLevel.DeliverablePeriod:
                                level = DeliverableSheetName;
                                break;
                            default:
                                level = string.Empty;
                                break;
                        }

                        resultMessage.Add($"\n[{level}] {error.Value}");
                    }

                    return string.Join(string.Empty, resultMessage);
                }
                else
                {
                    return SuccessMsg;
                }
            }
            else
            {
                return InconclusiveMsg;
            }
        }

        private void UpdateContracts(Worksheet sheet, ContractRequestResult[] results, ExcelLocation[] locatorMappings)
        {
            if (sheet != null)
            {
                int errorColumn = CreateResultsColumn(sheet);

                int numRows = sheet.Cells.GetLastDataRow(0) + 1;
                for (int i = 1; i < numRows; i++)
                {
                    if (!IsRowBlank(sheet.Cells.Rows[i], errorColumn))
                    {
                        ExcelLocation location = locatorMappings.FirstOrDefault<ExcelLocation>(x => x.Sheet == sheet.Name && x.Row == i);
                        if (location != null)
                        {
                            ContractRequestResult result = results.FirstOrDefault(c => c.CorrelationId == location.ContractRequestId);
                            InsertResultsMessage(result, sheet.Cells.Rows[i][errorColumn]);

                            if (result != null && result.ContractNumbers != null)
                            {
                                if (result.ContractNumbers.Count > 0)
                                {
                                    if (result.ContractNumbers.Any(x => x.Key == location.ContractRequestId)
                                        && result.ContractNumbers.Any(y => y.Key == location.CorrelationId))
                                    {
                                        string masterContractNum = result.ContractNumbers[location.ContractRequestId];
                                        string contractNum = result.ContractNumbers[location.CorrelationId];
                                        UpdateField(
                                            masterContractNum,
                                            sheet,
                                            i,
                                            MasterContractNumberColumnOnContractsSheet,
                                            MasterContractReferenceNumberHeader);
                                        UpdateField(
                                            contractNum,
                                            sheet,
                                            i,
                                            ContractNumberColumnOnContractsSheet,
                                            ContractNumberHeader);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        private void UpdateContractAllocations(Worksheet sheet, ContractRequestResult[] results, ExcelLocation[] locatorMappings)
        {
            if (sheet != null)
            {
                int errorColumn = CreateResultsColumn(sheet);
                int numRows = sheet.Cells.GetLastDataRow(0) + 1;
                for (int i = 1; i < numRows; i++)
                {
                    if (!IsRowBlank(sheet.Cells.Rows[i], errorColumn))
                    {
                        ExcelLocation location = locatorMappings.FirstOrDefault<ExcelLocation>(x => x.Sheet == sheet.Name && x.Row == i);
                        if (location != null)
                        {
                            ContractRequestResult result = results.FirstOrDefault(c => c.CorrelationId == location.ContractRequestId);

                            InsertResultsMessage(result, sheet.Cells.Rows[i][errorColumn]);

                            if (result != null && result.ContractNumbers != null)
                            {
                                if (result.ContractNumbers.Any(x => x.Key == location.ParentId)
                                    && result.ContractNumbers.Any(y => y.Key == location.CorrelationId))
                                {
                                    string contractNum = result.ContractNumbers[location.ParentId];
                                    string allocationNum = result.ContractNumbers[location.CorrelationId];

                                    UpdateField(
                                        contractNum,
                                        sheet,
                                        i,
                                        ContractNumberColumnOnAllocationsSheet,
                                        ContractNumberHeader);
                                    UpdateField(
                                        allocationNum,
                                        sheet,
                                        i,
                                        ContractAllocationsColumnOnAllocationsSheet,
                                        ContractAllocationNumberHeader);
                                }
                            }
                        }
                    }
                }
            }
        }

        private void UpdateDeliverables(Worksheet sheet, ContractRequestResult[] results, ExcelLocation[] locatorMappings)
        {
            var locatorMappingsDictionary = locatorMappings.ToDictionary(k => k.Sheet + "#" + k.Row.ToString(), v => v);
            var resultsDictionary = results.ToDictionary(k => k.CorrelationId, v => v);

            if (sheet != null)
            {
                int errorColumn = CreateResultsColumn(sheet);

                int numRows = sheet.Cells.GetLastDataRow(0) + 1;
                for (int i = 1; i < numRows; i++)
                {
                    if (!IsRowBlank(sheet.Cells.Rows[i], errorColumn))
                    {
                        string locatorMappingKey = sheet.Name + "#" + i.ToString();
                        ExcelLocation location = locatorMappingsDictionary.ContainsKey(locatorMappingKey) ? locatorMappingsDictionary[locatorMappingKey] : null;

                        if (location != null)
                        {
                            ContractRequestResult result =
                                location.ContractRequestId != null && resultsDictionary.ContainsKey(location.ContractRequestId)
                                        ? resultsDictionary[location.ContractRequestId]
                                        : null;

                            InsertResultsMessage(result, sheet.Cells.Rows[i][errorColumn]);

                            if (result != null && result.ContractNumbers != null)
                            {
                                string allocationNum = result.ContractNumbers[location.ParentId];
                                UpdateField(allocationNum, sheet, i, ContractAllocationsColumnOnDeliverablesSheet, ContractAllocationNumberHeader);
                            }
                        }
                    }
                }
            }
        }

        private void UpdateField(string newValue, Worksheet sheet, int row, int column, string expectedColumnName)
        {
            if (!string.IsNullOrEmpty(newValue) &&
                string.Compare(sheet.Cells.Rows[0][column].StringValue.Trim(), expectedColumnName, StringComparison.InvariantCultureIgnoreCase) == 0)
            {
               
                sheet.Cells.Rows[row][column].Value = newValue.Truncate(MaxNumberOfCharactersInACell);
            }
        }

        private bool IsRowBlank(Row row, int numColumnsToExpect)
        {
            for (int i = 0; i < numColumnsToExpect; i++)
            {
                if (!string.IsNullOrWhiteSpace(row[i].StringValue))
                {
                    return false;
                }
            }

            return true;
        }

        private void InsertResultsMessage(ContractRequestResult result, Cell cell)
        {
            Style style = cell.GetStyle();
            style.IsTextWrapped = true;
            cell.SetStyle(style);
            cell.Value = GetResultsMessage(result).Truncate(MaxNumberOfCharactersInACell);
        }

        private int CreateResultsColumn(Worksheet sheet)
        {
            int errorColumn = sheet.Cells.Rows[0].LastCell.Column + 1;
            sheet.Cells.Rows[0][errorColumn].Value = ResultsColumnHeader;
            sheet.Cells.SetColumnWidth(errorColumn, 80);
            return errorColumn;
        }
    }
}