namespace ContractRequestDomain.Tests
{
    using System;
    using System.IO;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;

    [TestClass]
    public class TransformToContractRequestTests
    {
        private dataLoadResults _transformInputDataLoadResults;
        private dataLoadResults _transNumbersInput;
        private dataLoadResults _deliverableOrgDataLoadResults;
        TransformToContractRequest _transformer;

        [TestInitialize]
        public void Initialize()
        {
            _transformer = new TransformToContractRequest();
            ExcelFileParser parser = new ExcelFileParser();
            byte[] fileData = TestUtils.ResourceToByteArray("ContractRequestDomain.Tests", @"Resources.24+LOANS AY 1516 17022115090000 Transform.xlsx");
            
            using (MemoryStream stream = new MemoryStream(fileData))
            {
                _transformInputDataLoadResults = parser.ReadFile(stream, "TestFile.xlsx");
                
            }

            fileData = TestUtils.ResourceToByteArray("ContractRequestDomain.Tests", @"Resources.24+LOANS AY 1516 17022115090000 TransformWithNumbers.xlsx");
            using (MemoryStream stream = new MemoryStream(fileData))
            {
                _transNumbersInput = parser.ReadFile(stream, "TestFile.xlsx");
            }

            System.Diagnostics.Debug.WriteLine((_transformInputDataLoadResults.workbook == null) ? "Workbook is null" : "Workbook is not null");
        }

        

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_MasterContractsExtractedSuccessfully_IfNumbersAreUsedTest()
        {
            contractRequestType[] crs = _transformer.Transform(_transNumbersInput);
            Assert.AreEqual<int>(1, crs.Length);
            Assert.AreEqual<int>(2, crs[0].contract.contracts.Count);
            Assert.AreEqual<int>(3, crs[0].contract.contracts[0].contractAllocations.Count);
            Assert.AreEqual<int>(1, crs[0].contract.contracts[0].contractAllocations[0].contractDeliverables.Count);
            Assert.AreEqual<int>(12, crs[0].contract.contracts[0].contractAllocations[0].contractDeliverables[0].contractDeliverablePeriods.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_MasterContractsExtractedSuccessfullyTest()
        {
            contractRequestType[] crs = _transformer.Transform(_transformInputDataLoadResults);
            Assert.AreEqual<int>(6, crs.Length);
            Assert.AreEqual<int>(2, crs.First<contractRequestType>(c => c.contract.contractNumber == "SFA-1234").contract.contracts.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DataLoadResultsTransformer_AllocationCountIsCorrect_AfterTransformingToContractRequestType()
        {
            contractRequestType[] crs = _transformer.Transform(_transformInputDataLoadResults);

            var masterContract = crs.First<contractRequestType>(c => c.contract.contractor.ukprn == 78900204).contract;
            var subContract = masterContract.contracts[0];

            Assert.AreEqual<int>(3, subContract.contractAllocations.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DataLoadResultsTransformer_DeliverablesCountAreCorrect_AfterTransformingToContractRequestType()
        {
            contractRequestType[] crs = _transformer.Transform(_transformInputDataLoadResults);

            var masterContract = crs.First<contractRequestType>(c => c.contract.contractor.ukprn == 78900204).contract;
            var subContract = masterContract.contracts[0];
            var allocationF = subContract.contractAllocations.First(a => a.fundingStreamCode == "24+ ALLF");
            var allocationB = subContract.contractAllocations.First(a => a.fundingStreamCode == "24+ ALLB");

            Assert.AreEqual<int>(2, allocationF.contractDeliverables.Count);
            Assert.AreEqual<int>(12, allocationF.contractDeliverables[0].contractDeliverablePeriods.Count);
            Assert.AreEqual<int>(12, allocationF.contractDeliverables[1].contractDeliverablePeriods.Count);

            Assert.AreEqual<int>(1, allocationB.contractDeliverables.Count);
            Assert.AreEqual<int>(12, allocationB.contractDeliverables[0].contractDeliverablePeriods.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_MasterContractAttributesAreCorrectTest()
        {
            contractRequestType[] crs = _transformer.Transform(_transformInputDataLoadResults);

            var masterContract = crs.First<contractRequestType>(c => c.contract.contractor.ukprn == 78900204).contract;
            Assert.AreEqual<string>("24+LOANS", masterContract.fundingTypeCode);
            Assert.AreEqual<hierarchyType>(hierarchyType.MASTERCONTRACT, masterContract.hierarchyType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_SubContractAttributesAreCorrectTest()
        {
            contractRequestType[] crs = _transformer.Transform(_transformInputDataLoadResults);

            var masterContract = crs.First<contractRequestType>(c => c.contract.contractor.ukprn == 78900204).contract;
            var subContract = masterContract.contracts[0];

            Assert.AreEqual<DateTime>(TestUtils.GetUtcDateTime("01/08/2015"), subContract.startDate.Value);
            Assert.AreEqual<DateTime>(TestUtils.GetUtcDateTime("31/07/2016"), subContract.endDate.Value);
            Assert.AreEqual<intent>(intent.New, subContract.CRMIntent);
            Assert.AreEqual<string>("AY", subContract.period.periodType1.periodTypeCode);
            Assert.AreEqual<string>("1516", subContract.period.period);
            Assert.AreEqual<amendmentType>(amendmentType.None, subContract.amendmentType);
            Assert.AreEqual<string>("AT Data 24Plus", subContract.description);
            Assert.AreEqual<string>("Contract for Services", subContract.contractType1);
            Assert.AreEqual<hierarchyType>(hierarchyType.CONTRACT, subContract.hierarchyType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_AllocationAttributesAreCorrectTest()
        {
            Assert.AreEqual<int>(5, _transformInputDataLoadResults.workbook.Length);
            Assert.AreEqual<string>("Control Sheet", _transformInputDataLoadResults.workbook[0].name);
            Assert.AreEqual<string>("Contract", _transformInputDataLoadResults.workbook[1].name);

            contractRequestType[] crs = _transformer.Transform(_transformInputDataLoadResults);

            var masterContract = crs.First<contractRequestType>(c => c.contract.contractor.ukprn == 78900204).contract;
            var allocation = masterContract.contracts[0].contractAllocations.First(a => a.fundingStreamCode == "24+ ALLB");

            Assert.AreEqual<DateTime>(TestUtils.GetUtcDateTime("01/08/2015"), allocation.startDate.Value);
            Assert.AreEqual<DateTime>(TestUtils.GetUtcDateTime("31/07/2016"), allocation.endDate.Value);
            Assert.AreEqual<intent>(intent.New, allocation.CRMIntent);
            Assert.AreEqual<string>("AY", allocation.period.periodType1.periodTypeCode);
            Assert.AreEqual<string>("1516", allocation.period.period);
            Assert.AreEqual<string>("123", allocation.LEPCode);
            Assert.AreEqual<string>("0000000456", allocation.UoPCode);
            Assert.AreEqual<string>("itt-ref", allocation.tenderSpecificationReference);
            Assert.AreEqual<string>("lot-ref", allocation.lotReference);
            Assert.AreEqual<string>("awardref", allocation.tenderAwardReference);
            Assert.AreEqual<string>("desciption1", allocation.activityDescription);
            Assert.AreEqual<string>("High", allocation.investmentPriority);
            Assert.AreEqual<string>("AT Allocation Data 24Plus", allocation.description);
            Assert.AreEqual("agreement1", allocation.agreementNumber);
            Assert.AreEqual("spec", allocation.specificationTitle);
            Assert.AreEqual("Transition", allocation.regionType);
            Assert.AreEqual("1.1", allocation.learningRatePremium);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_DeliverableAttributesAreCorrectTest()
        {
            Assert.IsNotNull(_transformInputDataLoadResults.workbook);
            Assert.AreEqual<int>(5, _transformInputDataLoadResults.workbook.Length);
            Assert.AreEqual<string>("Control Sheet", _transformInputDataLoadResults.workbook[0].name);
            Assert.AreEqual<string>("Contract", _transformInputDataLoadResults.workbook[1].name);

            contractRequestType[] crs = _transformer.Transform(_transformInputDataLoadResults);

            var masterContract = crs.First<contractRequestType>(c => c.contract.contractor.ukprn == 78900204).contract;
            var allocation = masterContract.contracts[0].contractAllocations.First(a => a.fundingStreamCode == "24+ ALLF");
            var deliverable = allocation.contractDeliverables.First(d => d.deliverable.deliverableCode == 1);

            Assert.AreEqual<intent>(intent.New, deliverable.CRMIntent);
            Assert.AreEqual<string>("24+ ALLF", deliverable.deliverable.fundingStreamCode);
            Assert.AreEqual<string>("Loans Submitted", deliverable.deliverable.deliverableName);
            Assert.AreEqual<string>("AT Deliverable Data 24Plus", deliverable.deliverableDescription);
            Assert.AreEqual<decimal>(25.52m, deliverable.unitCost.Value);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_DeliverablePeriodsAttributesAreCorrectTest()
        {
            Assert.IsNotNull(_transformInputDataLoadResults.workbook);
            Assert.AreEqual<int>(5, _transformInputDataLoadResults.workbook.Length);
            Assert.AreEqual<string>("Control Sheet", _transformInputDataLoadResults.workbook[0].name);
            Assert.AreEqual<string>("Contract", _transformInputDataLoadResults.workbook[1].name);

            contractRequestType[] crs = _transformer.Transform(_transformInputDataLoadResults);

            var masterContract = crs.First<contractRequestType>(c => c.contract.contractor.ukprn == 78900204).contract;
            var allocation = masterContract.contracts[0].contractAllocations.First(a => a.fundingStreamCode == "24+ ALLF");
            var period = allocation.contractDeliverables.First(d => d.deliverable.deliverableCode == 1).contractDeliverablePeriods[0];

            Assert.AreEqual<int>(8, period.period);
            Assert.AreEqual<int>(2015, period.year);
            Assert.AreEqual<decimal>(5540.00m, period.plannedValue.Value);
            Assert.AreEqual<int>(2555, period.plannedVolume.Value);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TransformToContractRequest_MapsFundingConfigurationAndCorrelatesErrors()
        {
            var contractRow = _transformInputDataLoadResults.GetSheet("Contract").row[0];
            var allocationRows = _transformInputDataLoadResults.GetSheet("Contract Allocation").row;
            var deliverableRows = _transformInputDataLoadResults.GetSheet("Deliverable").row;
            var contractCorrelationId = Guid.NewGuid();
            var allocationCorrelationId = Guid.NewGuid();
            var deliverableCorrelationId = Guid.NewGuid();
            contractRow.id = contractCorrelationId.ToString();
            allocationRows.ToList().ForEach(row => row.id = allocationCorrelationId.ToString());
            deliverableRows.ToList().ForEach(row => row.id = deliverableCorrelationId.ToString());

            var fundingConfiguration = new SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload.FundingConfigurationDataType
            {
                FundingTypeCode = "24+LOANS",
                FundingStreamCode = allocationRows[0].GetCellValue("FundingStreamCode"),
                FundingStreamId = "stream-id",
                FundingStreamName = "Stream name",
                FundingStreamCodeId = "stream-code-id",
                FundingStreamPeriodCode = "stream-period",
                Period = "1516",
                PeriodTypeCode = "AY",
                PeriodTypeName = "Academic Year"
            };
            _transformInputDataLoadResults.ReferenceData = new dataLoadResultsReferenceData
            {
                FundingConfiguration = new FundingConfigurationType
                {
                    FundingConfigurationList = new[] { fundingConfiguration }
                }
            };
            _transformInputDataLoadResults.error = new[]
            {
                new errorInfo { correlationId = contractCorrelationId.ToString(), Value = "Contract error" },
                new errorInfo { correlationId = allocationCorrelationId.ToString(), Value = "Allocation error" },
                new errorInfo { correlationId = deliverableCorrelationId.ToString(), Value = "Deliverable error" },
                new errorInfo { correlationId = Guid.NewGuid().ToString(), Value = "Unmatched error" }
            };
            var results = _transformer.Transform(_transformInputDataLoadResults);
            var result = results.Single(contractRequest =>
                contractRequest.contract.correlationId == contractCorrelationId.ToString());
            var allocation = results.SelectMany(contractRequest => contractRequest.contract.contracts)
                .SelectMany(contract => contract.contractAllocations)
                .First(item => item.correlationId == allocationCorrelationId.ToString());
            var deliverable = allocation.contractDeliverables
                .First(item => item.correlationId == deliverableCorrelationId.ToString());

            Assert.AreEqual("stream-period", result.FundingConfiguration[0].FundingStreamPeriodCode);
            Assert.AreEqual("stream-period", allocation.fundingStreamPeriodCode);
            var errors = results.SelectMany(contractRequest => contractRequest.errorInfo).ToList();
            Assert.AreEqual(3, errors.Count);
            Assert.IsTrue(errors.Any(error =>
                error.correlationId == contractCorrelationId.ToString() &&
                error.level == errorInfoTypeLevel.MasterContract));
            Assert.IsTrue(errors.Any(error =>
                error.correlationId == allocationCorrelationId.ToString() &&
                error.level == errorInfoTypeLevel.Allocation));
            Assert.IsTrue(errors.Any(error =>
                error.correlationId == deliverableCorrelationId.ToString() &&
                error.level == errorInfoTypeLevel.Deliverable));
            Assert.IsNotNull(deliverable);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TransformToContractRequest_UnitCostIsNull_ShouldReturnNullUnitCost()
        {
            // arrange
            var delSheet =_transformInputDataLoadResults.workbook.Single(w => w.name == "Deliverable");
            foreach (var row in delSheet.row)
            {
                var unitCosts = row.cell.Where(c => c.columnName == "UnitCost");

                foreach (var unitCost in unitCosts)
                {
                    unitCost.Value = string.Empty;
                }
            }

            // act
            contractRequestType[] crs = _transformer.Transform(_transformInputDataLoadResults);

            var masterContract = crs.First<contractRequestType>(c => c.contract.contractor.ukprn == 78900204).contract;
            var allocation = masterContract.contracts[0].contractAllocations.First(a => a.fundingStreamCode == "24+ ALLF");
            var deliverable = allocation.contractDeliverables.First(d => d.deliverable.deliverableCode == 1);
            var period = deliverable.contractDeliverablePeriods[0];

            // assert
            Assert.AreEqual(null, period.unitCost);
            Assert.AreEqual(null, deliverable.unitCost);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TransformToContractRequest_PlannedValueIsNull_ShouldReturnNullPlannedValue()
        {
            // arrange
            var delSheet = _transformInputDataLoadResults.workbook.Single(w => w.name == "Deliverable");
            foreach (var row in delSheet.row)
            {
                var plannedValues = row.cell.Where(c => c.columnName == "Value");

                foreach (var plannedValue in plannedValues)
                {
                    plannedValue.Value = string.Empty;
                }
            }

            // act
            contractRequestType[] crs = _transformer.Transform(_transformInputDataLoadResults);

            var masterContract = crs.First<contractRequestType>(c => c.contract.contractor.ukprn == 78900204).contract;
            var allocation = masterContract.contracts[0].contractAllocations.First(a => a.fundingStreamCode == "24+ ALLF");
            var deliverable = allocation.contractDeliverables.First(d => d.deliverable.deliverableCode == 1);
            var period = deliverable.contractDeliverablePeriods[0];

            // assert
            Assert.AreEqual(null, period.plannedValue);
            Assert.AreEqual(null, deliverable.plannedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TransformToContractRequest_PlannedVolumeIsNull_ShouldReturnNullPlannedVolume()
        {
            // arrange
            var delSheet = _transformInputDataLoadResults.workbook.Single(w => w.name == "Deliverable");
            foreach (var row in delSheet.row)
            {
                var plannedVolumes = row.cell.Where(c => c.columnName == "Volume");

                foreach (var plannedVolume in plannedVolumes)
                {
                    plannedVolume.Value = string.Empty;
                }
            }

            // act
            contractRequestType[] crs = _transformer.Transform(_transformInputDataLoadResults);

            var masterContract = crs.First<contractRequestType>(c => c.contract.contractor.ukprn == 78900204).contract;
            var allocation = masterContract.contracts[0].contractAllocations.First(a => a.fundingStreamCode == "24+ ALLF");
            var deliverable = allocation.contractDeliverables.First(d => d.deliverable.deliverableCode == 1);
            var period = deliverable.contractDeliverablePeriods[0];

            // assert
            Assert.AreEqual(null, period.plannedVolume);
            Assert.AreEqual(null, deliverable.plannedVolume);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TransformToContractRequest_ShouldUseDeliveryOrganisationToRelateDeliverablesToAllocationWhenDeliveryOrganisationIsPresent()
        {
            // arrange
            byte[] fileData = TestUtils.ResourceToByteArray("ContractRequestDomain.Tests", @"Resources.24+LOANS AY DeliverableOrgTransform.xlsx");
            ExcelFileParser parser = new ExcelFileParser();
            using (MemoryStream stream = new MemoryStream(fileData))
            {
                _deliverableOrgDataLoadResults = parser.ReadFile(stream, "TestFile.xlsx");
            }

            TransformToContractRequest transformToContractRequest = new TransformToContractRequest();

            // act
            contractRequestType[] contractRequestTypes = transformToContractRequest.Transform(_deliverableOrgDataLoadResults);

            // assert
            Assert.AreEqual(1, contractRequestTypes.Length, "There are too many contracts");
            var contractRequest = contractRequestTypes.First();
            Assert.AreEqual(2, contractRequest.contract.contracts[0].contractAllocations.Count, "The number of allocations is incorrect");
            contractAllocation firstContractAllocation = contractRequest.contract.contracts[0].contractAllocations[0];
            contractAllocation secondContractAllocation = contractRequest.contract.contracts[0].contractAllocations[1];
            Assert.AreEqual(2, firstContractAllocation.contractDeliverables.Count, "The number of deliverables on the first allocation is wrong");
            Assert.AreEqual(1, secondContractAllocation.contractDeliverables.Count, "The number of deliverables on the second allocation is wrong");
        }
    }
}
