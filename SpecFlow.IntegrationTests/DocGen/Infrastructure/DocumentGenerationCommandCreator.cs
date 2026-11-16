namespace DocGenTests.Infrastructure
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    //using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NUnit.Framework;
    using SFA.FCT.ContractCreateDomain.Implementation.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public static class DocumentGenerationCommandCreator
    {
        public static DocumentGenerationCommand ToDocumentGenerationCommand(string filePath)
        {
            string path = filePath.Replace(@"\", ".");
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"DocGenTests.{path}"))
            {
                dataLoadResults dataLoadResults = ExcelFileParser.ReadFile(stream, "");

                var controlSheet = dataLoadResults.GetSheet("Control Sheet");
                string period = GetCellValue(controlSheet, "Period", 0);
                string periodTypeCode = GetCellValue(controlSheet, "PeriodTypeCode", 0);
                string fundingTypeCode = GetCellValue(controlSheet, "FundingTypeCode", 0);

                FundingConfigurationType fundingConfigurationType = FundingStreamConfigService.GetReferenceData(period, periodTypeCode, fundingTypeCode);
                dataLoadResults.ReferenceData = new dataLoadResultsReferenceData{FundingConfiguration = fundingConfigurationType};

                contractRequestType[] contractRequestTypes = new DataLoadResultsTransformer().Transform(dataLoadResults);

                Assert.AreEqual(1, contractRequestTypes.Length, "We can only process spreadsheets with one contract");

                ExtendedContractType extendedContractType = ContractDtoTransformer.TransformToCorpContractType(contractRequestTypes.First());

                ContractValueAggregator.Aggregate(extendedContractType);

                ContractDeliverableEnricher contractDeliverableEnricher = new ContractDeliverableEnricher(new FundingStreamConfigService());

                contractDeliverableEnricher.Enrich(extendedContractType);

                Contract corpChildContract = ContractDtoTransformer.TransformToCorpContract(extendedContractType.contracts.First());

                return new DocumentGenerationCommand
                {
                    CorporateContract = corpChildContract,
                    MasterContractNumber = extendedContractType.contractNumber,
                    CorrelationId = ""
                };
            }
        }

        private static string GetCellValue(sheetType sheet, string columnName, int rowNumber)
        {
            string errorMessage;
            if (sheet.row.Count() > rowNumber)
            {
                var cell = sheet.row[rowNumber].GetCellValue(columnName);
                if (cell != null)
                {
                    return cell;
                }

                errorMessage = "Cell value not found.";
            }
            else
            {
                errorMessage = "Row not found.";
            }

            throw new Exception(errorMessage);
        }
    }
}
