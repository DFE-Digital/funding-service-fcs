namespace ContractRequestDomain.Tests
{
    extern alias CSICommon;
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using CSICommon::SFA.FCT.CrossDomain.Integration.Common.Storage;
    using UnitTests.Common;
    
    [TestClass]
    public class GenerateResultsReportTests
    {
        private byte[] _fileData;
        
        [TestInitialize]
        public void Setup()
        {
            using (TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.24+LOANS AY 1516 17022115090000 SynRec.xlsx"))
            {
                _fileData = TestUtils.FileToByteArray(resource.Stream);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GenerateReport_DisplaysSuccessMessageForNoErrors()
        {
            IDictionary<string, ExcelLocation> locations;
            contractRequestType[] crs = ReadFile(_fileData, out locations);
            SimulateSuccesses(crs);
            byte[] reportFileData = GenerateReport(_fileData, crs, locations);

            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract", 1, 9));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract", 2, 9));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract", 3, 9));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 1, 17));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 2, 17));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 3, 17));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 4, 17));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 5, 17));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Deliverable", 1, 12));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Deliverable", 8, 12));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GenerateReport_DisplaysContractNumbersOnSuccess()
        {
            IDictionary<string, ExcelLocation> locations;
            contractRequestType[] crs = ReadFile(_fileData, out locations);
            SimulateSuccesses(crs);
            byte[] reportFileData = GenerateReport(_fileData, crs, locations);

            Assert.AreEqual<string>("24Loans-101", ExcelHelper.GetCellValue(reportFileData, "Contract", 1, 1));
            Assert.AreEqual<string>("24Loans-102", ExcelHelper.GetCellValue(reportFileData, "Contract", 2, 1));
            Assert.AreEqual<string>("24Loans-103", ExcelHelper.GetCellValue(reportFileData, "Contract", 3, 1));
            Assert.AreEqual<string>("SFA-1001", ExcelHelper.GetCellValue(reportFileData, "Contract", 1, 4));
            Assert.AreEqual<string>("SFA-1002", ExcelHelper.GetCellValue(reportFileData, "Contract", 2, 4));
            Assert.AreEqual<string>("SFA-1003", ExcelHelper.GetCellValue(reportFileData, "Contract", 3, 4));
            Assert.AreEqual<string>("24Loans-101", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 1, 1));
            Assert.AreEqual<string>("24Loans-101", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 2, 1));
            Assert.AreEqual<string>("24Loans-101", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 3, 1));
            Assert.AreEqual<string>("24Loans-102", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 4, 1));
            Assert.AreEqual<string>("24Loans-103", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 5, 1));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GenerateReport_DisplaysContractAllocationNumbersOnSuccess()
        {
            IDictionary<string, ExcelLocation> locations;
              contractRequestType[] crs = ReadFile(_fileData, out locations);
            SimulateSuccesses(crs);
            byte[] reportFileData = GenerateReport(_fileData, crs, locations);

            Assert.AreEqual<string>("ALLB-300", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 1, 2));
            Assert.AreEqual<string>("ALLC-300", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 2, 2));
            Assert.AreEqual<string>("ALLF-300", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 3, 2));
            Assert.AreEqual<string>("ALLB-301", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 4, 2));
            Assert.AreEqual<string>("ALLB-302", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 5, 2));
            Assert.AreEqual<string>("ALLF-300", ExcelHelper.GetCellValue(reportFileData, "Deliverable", 1, 1));
            Assert.AreEqual<string>("ALLF-300", ExcelHelper.GetCellValue(reportFileData, "Deliverable", 8, 1));
            Assert.AreEqual<string>("ALLB-300", ExcelHelper.GetCellValue(reportFileData, "Deliverable", 16, 1));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GenerateReport_ReportContainsSuccessesdAndFailures()
        {
            IDictionary<string, ExcelLocation> locations;
            contractRequestType[] crs = ReadFile(_fileData, out locations);
            SimulateErrors(crs);
            byte[] reportFileData = GenerateReport(_fileData, crs, locations);

            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract", 1, 9));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract", 3, 9));

            string errorMessage = ExcelHelper.GetCellValue(reportFileData, "Contract", 2, 9);
            Assert.IsTrue(errorMessage.StartsWith("Failed"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GenerateReport_ShouldNotContainDuplicateErrorMessages()
        {
            IDictionary<string, ExcelLocation> locations;
            contractRequestType[] crs = ReadFile(_fileData, out locations);
            SimulateErrors(crs);
            byte[] reportFileData = GenerateReport(_fileData, crs, locations);

            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract", 1, 9));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract", 3, 9));

            string errorMessage = ExcelHelper.GetCellValue(reportFileData, "Contract", 2, 9);
            Assert.IsTrue(errorMessage.StartsWith("Failed"), "The error does not start with 'Failed'");
            var lines = errorMessage.Split(Environment.NewLine.ToCharArray());
            var lineGroups = lines.GroupBy(l => l).ToList();
            
            Assert.IsFalse(lineGroups.Any(g => g.Count() > 1),
                 "There is more than one line with the same message - " + lineGroups.FirstOrDefault(g => g.Count() > 1)?.Key);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GenerateReport_ErrorMessagesAreAllDisplayed_ContractLevel()
        {
            IDictionary<string, ExcelLocation> locations;
            contractRequestType[] crs = ReadFile(_fileData, out locations);
            SimulateErrors(crs);
            byte[] reportFileData = GenerateReport(_fileData, crs, locations);

            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract", 1, 9));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract", 3, 9));

            string errorMessage = ExcelHelper.GetCellValue(reportFileData, "Contract", 2, 9);
            Assert.IsTrue(errorMessage.StartsWith("Failed"));
            Assert.IsTrue(errorMessage.Contains("[Contract] ContractStartDate is not as per expected length as specified in 'Bulk Import File Specification'"));
            Assert.IsTrue(errorMessage.Contains("[Contract] ContractStartDate is not as per expected data type as specified in 'Bulk Import File Specification'"));
            Assert.IsTrue(errorMessage.Contains("[Contract Allocation] CRMIntent is not as per expected data type as specified in 'Bulk Import File Specification'"));
            Assert.IsTrue(errorMessage.Contains("[Deliverable] Value is not as per expected data type as specified in 'Bulk Import File Specification'"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GenerateReport_ErrorMessagesAreAllDisplayed_AllocationLevel()
        {
            IDictionary<string, ExcelLocation> locations;
            contractRequestType[] crs = ReadFile(_fileData, out locations);
            SimulateErrors(crs);
            byte[] reportFileData = GenerateReport(_fileData, crs, locations);

            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 1, 17));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 2, 17));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 3, 17));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 5, 17));

            string errorMessage = ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 4, 17);
            Assert.IsTrue(errorMessage.StartsWith("Failed"));
            Assert.IsTrue(errorMessage.Contains("[Contract] ContractStartDate is not as per expected length as specified in 'Bulk Import File Specification'"));
            Assert.IsTrue(errorMessage.Contains("[Contract] ContractStartDate is not as per expected data type as specified in 'Bulk Import File Specification'"));
            Assert.IsTrue(errorMessage.Contains("[Contract Allocation] CRMIntent is not as per expected data type as specified in 'Bulk Import File Specification'"));
            Assert.IsTrue(errorMessage.Contains("[Deliverable] Value is not as per expected data type as specified in 'Bulk Import File Specification'"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GenerateReport_ErrorMessagesAreAllDisplayed_DeliverableLevel()
        {
            IDictionary<string, ExcelLocation> locations;
            contractRequestType[] crs = ReadFile(_fileData, out locations);
            SimulateErrors(crs);
            byte[] reportFileData = GenerateReport(_fileData, crs, locations);

            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Deliverable", 1, 12));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Deliverable", 8, 12));

            string errorMessage = ExcelHelper.GetCellValue(reportFileData, "Deliverable", 25, 12);
            Assert.IsTrue(errorMessage.StartsWith("Failed"));
            Assert.IsTrue(errorMessage.Contains("[Contract] ContractStartDate is not as per expected length as specified in 'Bulk Import File Specification'"));
            Assert.IsTrue(errorMessage.Contains("[Contract] ContractStartDate is not as per expected data type as specified in 'Bulk Import File Specification'"));
            Assert.IsTrue(errorMessage.Contains("[Contract Allocation] CRMIntent is not as per expected data type as specified in 'Bulk Import File Specification'"));
            Assert.IsTrue(errorMessage.Contains("[Deliverable] Value is not as per expected data type as specified in 'Bulk Import File Specification'"));

            Assert.AreEqual<string>(errorMessage, ExcelHelper.GetCellValue(reportFileData, "Deliverable", 28, 12));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GenerateReport_NoContractNumbersForErrors()
        {
            IDictionary<string, ExcelLocation> locations;
            contractRequestType[] crs = ReadFile(_fileData, out locations);
            SimulateErrors(crs);
            byte[] reportFileData = GenerateReport(_fileData, crs, locations);

            Assert.AreEqual<string>("24Loans-101", ExcelHelper.GetCellValue(reportFileData, "Contract", 1, 1));
            Assert.AreEqual<string>("", ExcelHelper.GetCellValue(reportFileData, "Contract", 2, 1));
            Assert.AreEqual<string>("24Loans-103", ExcelHelper.GetCellValue(reportFileData, "Contract", 3, 1));
            Assert.AreEqual<string>("SFA-1001", ExcelHelper.GetCellValue(reportFileData, "Contract", 1, 4));
            Assert.AreEqual<string>("", ExcelHelper.GetCellValue(reportFileData, "Contract", 2, 4));
            Assert.AreEqual<string>("SFA-1003", ExcelHelper.GetCellValue(reportFileData, "Contract", 3, 4));
            Assert.AreEqual<string>("24Loans-101", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 1, 1));
            Assert.AreEqual<string>("24Loans-101", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 2, 1));
            Assert.AreEqual<string>("24Loans-101", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 3, 1));
            Assert.AreEqual<string>("", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 4, 1));
            Assert.AreEqual<string>("24Loans-103", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 5, 1));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_GenerateReport_NoAllocationNumbersForErrors()
        {
            IDictionary<string, ExcelLocation> locations;
            contractRequestType[] crs = ReadFile(_fileData, out locations);
            SimulateErrors(crs);
            byte[] reportFileData = GenerateReport(_fileData, crs, locations);

            Assert.AreEqual<string>("ALLB-300", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 1, 2));
            Assert.AreEqual<string>("ALLC-300", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 2, 2));
            Assert.AreEqual<string>("ALLF-300", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 3, 2));
            Assert.AreEqual<string>("", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 4, 2));
            Assert.AreEqual<string>("ALLB-302", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 5, 2));
            Assert.AreEqual<string>("ALLF-300", ExcelHelper.GetCellValue(reportFileData, "Deliverable", 1, 1));
            Assert.AreEqual<string>("", ExcelHelper.GetCellValue(reportFileData, "Deliverable", 25, 1));
        }


        [TestMethod, TestCategory("UnitTest")]
        public void Test_GenerateReport_MissingResultsDueToTimeout()
        {
            IDictionary<string, ExcelLocation> locations;
            contractRequestType[] crs = ReadFile(_fileData, out locations);
            SimulateSuccesses(crs);
            contractRequestType[] crsWithMissingResults = new contractRequestType[] { crs[0], crs[2] };
            byte[] reportFileData = GenerateReport(_fileData, crsWithMissingResults, locations);

            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract", 1, 9));
            Assert.AreEqual<string>("Operation has timed out. Please check if Contract has been created.", ExcelHelper.GetCellValue(reportFileData, "Contract", 2, 9));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract", 3, 9));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 1, 17));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 2, 17));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 3, 17));
            Assert.AreEqual<string>("Operation has timed out. Please check if Contract has been created.", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 4, 17));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Contract Allocation", 5, 17));
            Assert.AreEqual<string>("Success", ExcelHelper.GetCellValue(reportFileData, "Deliverable", 1, 12));
            Assert.AreEqual<string>("Operation has timed out. Please check if Contract has been created.", ExcelHelper.GetCellValue(reportFileData, "Deliverable", 25, 12));
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void BulkUploadProcessingEntity_ShouldLoad()
        {
            IEnumerable<BulkUploadProcessingEntity> bulkUploadProcessingRows = new AzureTableStore().GetRows<BulkUploadProcessingEntity>("BulkUpdateProcessingDAT", "AAA");
            var completedRows =
                bulkUploadProcessingRows
                    .Where(r => r.Complete && r.ContractRequestResult.Length > 0);

            IEnumerable<ContractRequestResult> results =
                    completedRows
                        .Select(r => new SagaContractRequestResult { SerializedContractRequestResult = r.ContractRequestResult }.GetContractRequestResult());

            Assert.IsNotNull(results);
        }


        private contractRequestType[] ReadFile(byte[] fileData, out IDictionary<string, ExcelLocation> locations)
        {
            ExcelFileParser parser = new ExcelFileParser();
            LocationMapper mapper = new LocationMapper();
            TransformToContractRequest transformer = new TransformToContractRequest();

            using (MemoryStream stream = new MemoryStream(fileData))
            {
                dataLoadResults dataLoad = parser.ReadFile(stream, "TestFile.xlsx");
                locations = mapper.GenerateExcelLocations(dataLoad);
                contractRequestType[] crs = transformer.Transform(dataLoad);
                foreach (contractRequestType cr in crs)
                {
                    mapper.UpdateWithStructuralInformation(locations, cr);
                }

                return crs;
            }
        }

        private byte[] GenerateReport(byte[] inputFileData, contractRequestType[] contractRequests, IDictionary<string, ExcelLocation> locations)
        {
            GenerateResultsReport reportGenerator = new GenerateResultsReport();
            ContractRequestResult[] results = contractRequests.Select(c => new ContractRequestResult(c)).ToArray();

            return reportGenerator.GenerateReport(inputFileData, results, locations.Values.ToArray());

        }

        private void SimulateSuccesses(contractRequestType[] contractRequests)
        {
            contractRequestType cr = contractRequests.First<contractRequestType>(c => c.contract.contractor.ukprn == 78900204);
            cr.contract.contractNumber = "SFA-1001";
            cr.contract.contracts[0].contractNumber = "24Loans-101";
            cr.contract.contracts[0].contractAllocations[0].contractAllocationNumber = "ALLB-300";
            cr.contract.contracts[0].contractAllocations[1].contractAllocationNumber = "ALLC-300";
            cr.contract.contracts[0].contractAllocations[2].contractAllocationNumber = "ALLF-300";

            cr = contractRequests.First<contractRequestType>(c => c.contract.contractor.ukprn == 78900205);
            cr.contract.contractNumber = "SFA-1002";
            cr.contract.contracts[0].contractNumber = "24Loans-102";
            cr.contract.contracts[0].contractAllocations[0].contractAllocationNumber = "ALLB-301";

            cr = contractRequests.First<contractRequestType>(c => c.contract.contractor.ukprn == 78900206);
            cr.contract.contractNumber = "SFA-1003";
            cr.contract.contracts[0].contractNumber = "24Loans-103";
            cr.contract.contracts[0].contractAllocations[0].contractAllocationNumber = "ALLB-302";
        }

        private void SimulateErrors(contractRequestType[] contractRequests)
        {
            contractRequestType cr = contractRequests.First<contractRequestType>(c => c.contract.contractor.ukprn == 78900204);
            cr.contract.contractNumber = "SFA-1001";
            cr.contract.contracts[0].contractNumber = "24Loans-101";
            cr.contract.contracts[0].contractAllocations[0].contractAllocationNumber = "ALLB-300";
            cr.contract.contracts[0].contractAllocations[1].contractAllocationNumber = "ALLC-300";
            cr.contract.contracts[0].contractAllocations[2].contractAllocationNumber = "ALLF-300";

            cr = contractRequests.First<contractRequestType>(c => c.contract.contractor.ukprn == 78900205);
            cr.errorInfo = new List<errorInfoType>();
            cr.errorInfo.Add(new errorInfoType() {
                correlationId = cr.contract.contracts[0].correlationId,
                level = errorInfoTypeLevel.Contract,
                Value = "ContractStartDate is not as per expected length as specified in 'Bulk Import File Specification'"
            });
            cr.errorInfo.Add(new errorInfoType()
            {
                correlationId = cr.contract.contracts[0].correlationId,
                level = errorInfoTypeLevel.Contract,
                Value = "ContractStartDate is not as per expected data type as specified in 'Bulk Import File Specification'"
            });
            cr.errorInfo.Add(new errorInfoType() {
                correlationId = cr.contract.contracts[0].contractAllocations[0].correlationId,
                level = errorInfoTypeLevel.Allocation,
                Value = "CRMIntent is not as per expected data type as specified in 'Bulk Import File Specification'"
            });
            cr.errorInfo.Add(new errorInfoType() {
                correlationId = cr.contract.contracts[0].contractAllocations[0].contractDeliverables[0].contractDeliverablePeriods[0].correlationId,
                level = errorInfoTypeLevel.DeliverablePeriod,
                Value = "Value is not as per expected data type as specified in 'Bulk Import File Specification'"
            });
            cr.errorInfo.Add(new errorInfoType()
            {
                correlationId = cr.contract.contracts[0].contractAllocations[0].contractDeliverables[0].contractDeliverablePeriods[1].correlationId,
                level = errorInfoTypeLevel.DeliverablePeriod,
                Value = "Value is not as per expected data type as specified in 'Bulk Import File Specification'"
            });

            cr = contractRequests.First<contractRequestType>(c => c.contract.contractor.ukprn == 78900206);
            cr.contract.contractNumber = "SFA-1003";
            cr.contract.contracts[0].contractNumber = "24Loans-103";
            cr.contract.contracts[0].contractAllocations[0].contractAllocationNumber = "ALLB-302";
        }
    }
}
