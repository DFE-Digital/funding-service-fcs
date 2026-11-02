namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Infrastructure.Repositories;
    using Infrastructure.Services;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Sdk;
    using NUnit.Framework;
    using Pages;
    using Pages.DTO;
    using TechTalk.SpecFlow;
    using Utilities;
    using Xrm.TestFramework;
    using Xrm.TestFramework.Utils;
    using ActionRetrier = Utilities.ActionRetrier;

    [Binding]
    public class ValidateSyntaxOfEachRecordSteps  
    {
        private readonly ContractLoadPage _contractLoadStep;
        private readonly List<XrmWebEntity> _allContracts = new List<XrmWebEntity>();
        
        public ValidateSyntaxOfEachRecordSteps(ContractLoadPage contractLoadPage)
        {
            _contractLoadStep = contractLoadPage;
        }

        [BeforeScenario("CBR007")]
        public void SetupServicesAndData()
        {
            // Create Organisation and add it to list
            CreateOrgAndCaseLoad("10092000", "TEST", "Active", "Active", "Unassigned");

            CreateOrgAndCaseLoad("19990000", "NACRO", "Active", "Active", "Unassigned");
        }

        [AfterScenario("DBR008", "FSR001")]
        public void ThenTheContractIsRemovedFromCRM()
        {
            _contractLoadStep.GetCreatedEntities();
            _contractLoadStep.DeleteContracts();
        }

        [AfterScenario("DBR008", "ValidateSyntaxOfEachRecord")]
        private void TestTeardown()
        {
            _contractLoadStep.DeleteContracts();
        }

        [AfterScenario("CBR007")]
        private void TestTeardown2()
        {
            // Reverse contracts so master is the last to be deleted - this has a Referential, Restrict Delete relationship
            _allContracts.Reverse();

            _allContracts.ForEach(c =>
            {
                c.Delete();
            });
        }

        [BeforeScenario("ReportPerformance")]
        public void SetupPerfReporting()
        {
            _contractLoadStep.DateStarted = DateTime.Now;
        }

        [AfterScenario("ReportPerformance")]
        public void ReportPerformance()
        {
            // if the results report if not generated then the maximum wait time was exceeded
            //bool isMaxTimeExceeded = !_contractLoadStep.ResultsReportFileGenerated;
            string title = ScenarioContext.Current.ScenarioInfo.Title;
            Exception testError = ScenarioContext.Current.TestError;
            bool hasPassed = testError == null;

            DateTime started = _contractLoadStep.DateStarted;

            DateTime completed = _contractLoadStep.DateCompleted == started.Add(new TimeSpan())
                ? DateTime.Now
                : _contractLoadStep.DateCompleted;

            if (hasPassed)
            {
                Assert.Pass($"FCSPERFTEST|{title}|{started}|{completed}|Pass||FCSPERFTEST");
            }
            else
            {
                Assert.Fail($"FCSPERFTEST|{title}|{started}|{completed}|Fail|{testError.Message}|FCSPERFTEST");
            }

            // No possible null ref exception on testError.Message - if maxTimeExceeded test has error
            //Assert.Fail($"FCSPERFTEST|{title}|{started}|{DateTime.Now}|Fail|{testError?.Message}|FCSPERFTEST");
        }

        [Given(@"there are no files prefixed '(.*)' in the Sharepoint '(.*)' folder")]
        public void GivenThereAreNoFilesPrefixedInTheSharepointFolder(string fileNamePrefix, string folderName)
        {
            ActionRetrier.RetryWhenExceptionThrown(() =>
                _contractLoadStep.DeleteFilesWithPrefixInFolder(fileNamePrefix: fileNamePrefix, folderName: folderName));
        }

        [Given(@"a copy of the file '(.*)' in '(.*)' exists in the Sharepoint '(.*)' folder")]
        [When(@"a copy of '(.*)' from '(.*)' is put in the Sharepoint '(.*)' folder")]
        [Given(@"file '(.*)' is copied from '(.*)' to the Sharepoint '(.*)' folder")]
        [When(@"file '(.*)' is copied from '(.*)' to the Sharepoint '(.*)' folder")]
        public void GivenACopyOfTheFileInExistsInTheSharepointFolder(string localResourceFileName, string localResourceFolder, string destinationSharePointFolder)
        {
            _contractLoadStep.CopyNonRenamedResourceFileIntoFolder(localResourceFileName, localResourceFolder, destinationSharePointFolder);
        }

        [Given(@"a file named '(.*)' exists in '(.*)'")]
        [Given(@"a file prefixed '(.*)' exists in '(.*)'")]
        [Given(@"an excel spreadsheet '(.*)' exist at '(.*)'")]
        public void GivenAnExcelSpreadsheetExistAt(string p0, string p1)
        {
            _contractLoadStep.Initialize();
            _contractLoadStep.InputFilePath = Path.Combine(p1, p0);



            Assert.IsTrue(File.Exists(_contractLoadStep.InputFilePath), "Input file does not exist");
        }

        [Given(@"an excel spreadsheet '(.*)' exists in '(.*)' containing '(.*)' contracts")]
        [Given(@"an excel spreadsheet '(.*)' exists at '(.*)' containing '(.*)' contracts")]
        [Given(@"an excel spreadsheet '(.*)' exist at '(.*)' containing '(.*)' contracts")]
        public void GivenAnExcelSpreadsheetExistAtContainingContracts(string p0, string p1, int p2)
        {
            _contractLoadStep.Initialize();
            _contractLoadStep.InputFilePath = Path.Combine(p1, p0);

            _contractLoadStep.NumberOfContractsToCreate = p2;

            Assert.IsTrue(File.Exists(_contractLoadStep.InputFilePath), "Input file does not exist");
        }

        [Given(@"the contracts are all in approved state")]
        public void GivenTheContractsAreAllInApprovedState()
        {
           foreach (string contractNumber in _contractLoadStep.ContractNumbersFromFile)
           {
              _contractLoadStep.UpdateContractStatus(contractNumber, "Approved", "Approved");
           }
        }

        [Given(@"UKPRN field '(.*)' contains '(.*)' on the '(.*)' tab of the excel spreadsheet")]
        public void UKPRNGivenFieldContainsOnTheTabOfTheExcelSpreadsheet(string p0, string p1, string p2)
        {
            string excelValue = ExcelHelper.GetCellValue(_contractLoadStep.InputFilePath, p2, p0);
            Assert.AreEqual(p1, excelValue);
            if (!string.IsNullOrEmpty(p1))
            {
                _contractLoadStep.Ukprns.Add(p1.ToString());
            }
        }

        [Given(@"field '(.*)' contains '(.*)' on the '(.*)' tab of the excel spreadsheet")]
        public void GivenFieldContainsOnTheTabOfTheExcelSpreadsheet(string p0, string p1, string p2)
        {
            string excelValue = ExcelHelper.GetCellValue(_contractLoadStep.InputFilePath, p2, p0);
            if (excelValue == null)
            {
                Assert.IsTrue(string.IsNullOrEmpty(p1));    
            }
            else
            {
                Assert.AreEqual(p1, excelValue);
            }
        }
        
        [Given(@"field  '(.*)' contains '(.*)' on the '(.*)' tab of the excel spreadsheet")]
        public void GivenField_ContainsOnTheTabOfTheExcelSpreadsheet(string p0, string p1, string p2)
        {
            GivenFieldContainsOnTheTabOfTheExcelSpreadsheet(p0, p1, p2);
        }

        [When(@"the file is copied to the Sharepoint '(.*)' folder")]
        [When(@"the file for syntax validation is copied from the source location to the '(.*)'")]
        public void WhenTheFileForSyntaxValidationIsCopiedFromTheSourceLocationToThe(string p0)
        {
            _contractLoadStep.InitializeUkprnList(_contractLoadStep.Ukprns);
            _contractLoadStep.CopyFile();
            _contractLoadStep.ClearResultsReportsCache();
        }

        [When(@"the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values")]
        public void WhenTheFileIsCopiedToTheSharepointInputFolderAndAllParameterValuesInTheSpreadsheetHaveBeenUpdatedToActualValues()
        {
            _contractLoadStep.InitializeUkprnList(_contractLoadStep.Ukprns);
            _contractLoadStep.CopyFileWithTransformedFeatureVariables();
            _contractLoadStep.ClearResultsReportsCache();
        }

        [When(@"the contract request service has finished processing valid records")]
        public void WhenTheContractRequestServiceHasFinishedProcessingValidRecords()
        {
            //_contractLoadStep.StartPolling(delegate { });
            //_contractLoadStep.WaitTillFileLoaded();
        }

        [Then(@"there are '(.*)' files prefixed '(.*)' in the Sharepoint '(.*)' folder")]
        [Then(@"there is '(.*)' file prefixed '(.*)' in the Sharepoint '(.*)' folder")]
        public void ThenThereIsAreFileSPrefixedInTheSharepointFolder(int expectedFileCount, string fileNamePrefix, string folderName)
        {
            bool areCorrectNumberOfFilesInFolder = _contractLoadStep.AreCorrectNumberOfFilesWithPrefixInFolder(
                expectedFileCount: expectedFileCount,
                fileNamePrefix: fileNamePrefix,
                folderName: folderName,
                doesFileNameMatch: fileName => true);

            Assert.IsTrue(areCorrectNumberOfFilesInFolder, $"Did not find expected {expectedFileCount} files prefixed {fileNamePrefix} in folder {folderName}.");
        }

        [Then(@"there is '(.*)' file prefixed '(.*)' in the Sharepoint '(.*)' folder and marked as Rejected")]
        [Then(@"there are '(.*)' files prefixed '(.*)' in the Sharepoint '(.*)' folder and marked as Rejected")]
        public void ThenThereIsAreFileSPrefixedInTheSharepointFolderAndMarkedAsRejected(int expectedFileCount, string fileNamePrefix, string folderName)
        {
            bool areCorrectNumberOfFilesInFolder = _contractLoadStep.AreCorrectNumberOfFilesWithPrefixInFolder(
                expectedFileCount: expectedFileCount,
                fileNamePrefix: fileNamePrefix,
                folderName: folderName,
                doesFileNameMatch: fileName => fileName.Contains("Rejected"));

            Assert.IsTrue(areCorrectNumberOfFilesInFolder, $"Did not find expected {expectedFileCount} files prefixed {fileNamePrefix} in folder {folderName} and marked as Rejected.");
        }

        [Then(@"there is '(.*)' file prefixed '(.*)' in the Sharepoint '(.*)' folder and suffixed '(.*)'")]
        [Then(@"there are '(.*)' files prefixed '(.*)' in the Sharepoint '(.*)' folder and suffixed '(.*)'")]
        public void ThenThereIsAreFileSPrefixedInTheSharepointFolderWithFileSuffix(int expectedFileCount, string fileNamePrefix, string folderName, string fileNameSuffix)
        {
            bool areCorrectNumberOfFilesInFolder = _contractLoadStep.AreCorrectNumberOfFilesWithPrefixInFolder(
                expectedFileCount: expectedFileCount,
                fileNamePrefix: fileNamePrefix,
                folderName: folderName,
                doesFileNameMatch: fileName => fileName.EndsWith(fileNameSuffix));

            Assert.IsTrue(areCorrectNumberOfFilesInFolder, $"Did not find expected {expectedFileCount} files prefixed {fileNamePrefix} in folder {folderName} and suffixed {fileNameSuffix}.");
        }

        [Then(@"there is '(.*)' file prefixed '(.*)' in the Sharepoint '(.*)' folder and suffixed '(.*)' and marked as Rejected")]
        [Then(@"there are '(.*)' files prefixed '(.*)' in the Sharepoint '(.*)' folder and suffixed '(.*)' and marked as Rejected")]
        public void ThenThereIsAreFileSPrefixedInTheSharepointFolderAndSuffixedAndMarkedAsRejected(int expectedFileCount, string fileNamePrefix, string folderName, string fileNameSuffix)
        {
            bool areCorrectNumberOfFilesInFolder = _contractLoadStep.AreCorrectNumberOfFilesWithPrefixInFolder(
                expectedFileCount: expectedFileCount,
                fileNamePrefix: fileNamePrefix,
                folderName: folderName,
                doesFileNameMatch: fileName => fileName.EndsWith(fileNameSuffix) && fileName.Contains("Rejected"));

            Assert.IsTrue(areCorrectNumberOfFilesInFolder, $"Did not find expected {expectedFileCount} files prefixed {fileNamePrefix} in folder {folderName} and suffixed {fileNameSuffix} and marked as Rejected.");
        }

        [Then(@"a new contract has been created in Crm for Valid records")]
        public void ThenANewContractHasBeenCreatedInCrmForValidRecords()
        {
           // _contractLoadStep.StartPolling(delegate { });
          //  _contractLoadStep.WaitTillFileLoaded();

         //   Assert.IsTrue(_contractLoadStep.IsDataInCrm, "Contract is not loaded in CRM");
        }

        [Then(@"a syntax report showing file success should exist in the Sharepoint Reports folder")]
        [Then(@"a syntax report should exist in the Sharepoint Reports folder")]
        [Then(@"I should see a file for syntax validation success report")]
        public void WhenThereIsASyntaxValidationSuccessReport()
        {
            _contractLoadStep.WaitTillFileLevelErrorFileGenerated();
            Assert.IsTrue(_contractLoadStep.CheckFileLevelReport("Success"), "Success message not detected in the Syntax Report");
        }

        [Then(@"a syntax report showing file failure should exist in the Sharepoint Reports folder")]
        public void ThenASyntaxReportShowingAFailureShouldExistInTheSharepointReportsFolder()
        {
            _contractLoadStep.WaitTillFileLevelErrorFileGenerated();
            Assert.IsTrue(_contractLoadStep.CheckFileLevelReport("Failed"), "Failure message not detected in the Syntax Report");
        }

        [Then(@"I should see a file for syntax validation report")]
        public void ThenIShouldSeeAFileForSyntaxValidationReport()
        {
            _contractLoadStep.WaitTillFileLevelErrorFileGenerated();
            Assert.IsTrue(_contractLoadStep.FileLevelErrorFileGenerated, "Syntax validation report not Generated");
        }

        [Then(@"the syntax report includes the phrase '(.*)'")]
        [Then(@"syntax validation report contains '(.*)'")]
        public void ThenSyntaxValidationReportContainsAmendment(string p0)
        {
            Assert.IsTrue(_contractLoadStep.CheckFileLevelReport(p0), "Error Message not returned");
        }

        [Then(@"a results report should exist in the Sharepoint Reports folder")]
        [Then(@"a results report excel spreadsheet is generated in the storage")]
        public void ThenAResultsReportExcelSpreadsheetIsGeneratedInTheStorage()
        {
            _contractLoadStep.WaitTillResultsReportFileGenerated();
            Assert.IsTrue(_contractLoadStep.ResultsReportFileGenerated, "Result Report file does not exist.");
        }

        [Then(@"a results report excel spreadsheet is generated in storage in less than (.*) seconds")]
        [Then(@"a results report excel spreadsheet is generated in the storage less than (.*) seconds")]
        public void ThenAResultsReportExcelSpreadsheetIsGeneratedInTheStorageLessThanSeconds(int p0)
        {
            _contractLoadStep.MaxSecondsToWait = p0;
            _contractLoadStep.WaitTillResultsReportFileGeneratedInterval = p0;
            ThenAResultsReportExcelSpreadsheetIsGeneratedInTheStorage();
        }

        [Then(@"results report is generated in (.*) seconds")]
        public void ThenResultsReportIsGeneratedInSeconds(int p0)
        {
          Assert.IsTrue(_contractLoadStep.isTheReportGeneratedInTime(p0), "Timed part of test exceeded time allowed: "); 

           //ScenarioContext.Current.Pending();
        }
        
        [Then(@"'(.*)' is present in cell '(.*)' of the '(.*)' tab of the results report")]
        [Then(@"'(.*)' is displayed in field '(.*)' on the '(.*)' tab of the result report")]
        public void ThenIsDisplayedInFieldOnTheTabOfTheResultReport(string expectedText, string cellIdentifier, string workbookTab)
        {
            // need to get the results report excel file from blob and read cell values
            string results = _contractLoadStep.GetCellValueFromResultsReport(workbookTab, cellIdentifier);

            Assert.IsTrue(results.Replace(" ", string.Empty).Contains(expectedText.Replace(" ", string.Empty)), "Test expected \n<" + expectedText + "> but found \n<" + results + "> \nStarted on " + _contractLoadStep.DateStarted + " Finished on " + DateTime.Now);
        }

        [Then(@"'(.*)' is displayed in Row '(.*)' of the '(.*)' Column on the '(.*)' tab of the result report")]
        public void ThenIsDisplayedInRowOfTheColumnOnTheTabOfTheResultReport(string p0, int p1, string p2, string p3)
        {
            ThenIsInRowOfTheColumnOnTheTabOfTheResultReport(p0, p1, p2, p3);
        }

        [Then(@"'(.*)' is in Row '(.*)' of the '(.*)' Column on the '(.*)' tab of the result report")]
        public void ThenIsInRowOfTheColumnOnTheTabOfTheResultReport(string p0, int p1, string p2, string p3)
        {
            string results = _contractLoadStep.GetCellValueByColumnNameFromResultsReport(p3, p1, p2);

            Assert.IsTrue(results.Replace(" ", string.Empty).Contains(p0.Replace(" ", string.Empty)), "Expected Response is not available: " + p0 + "; Actually: " + results + "\nStarted on " + _contractLoadStep.DateStarted + " Finished on " + DateTime.Now);
        }

        [Then(@"field '(.*)' Contract is not created in CRM")]
        public void ThenFieldContractIsNotCreatedInCRM(string p0)
        {
            // cannot test for empty ukprn in crm
        }

        [Then(@"no contracts exist in CRM for UKPRN '(.*)'")]
        [Then(@"Contract with UKPRN of '(.*)' is not created in CRM")]
        public void ThenContractWithUKPRNOfIsNotCreatedInCRM(string p0)
        {
            var count = _contractLoadStep.GetCountOfContractsInCrmForUkPrns(new List<object>() { p0 });

            Assert.IsTrue(count == 0, "Contract is loaded in CRM");
        }

        [Then(@"the contract data is now removed")]
        public void ThenTheContractDataIsNowRemoved()
        {
            _contractLoadStep.DeleteContractsInCrmUsingContractNumbersOnSpreadsheet();
        }

        [Given(@"there is no contract data for any UKPRNs beginning with '(.*)'")]
        [Given(@"the contract data is now removed for ukprn beginning with '(.*)'")]
        public void GivenTheContractDataIsNowRemovedForUkprnBeginningWith(String p0)
        {
           _contractLoadStep.DeleteContractWithPartUKPRNNumber(p0);
        }

        [Then(@"all contracts have been successful")]
        public void ThenAllContractsHaveBeenSuccessful()
        {
            Assert.IsTrue(_contractLoadStep.HaveAllContractsOnSpreadsheetBeenLoadedSuccessfully(), "We have some failing contracts");
        }

        [Then(@"the draft contract header on the latest version of the contract is as follows")]
        [Then(@"the draft contract header details for the latest version of the contract have been updated as follows")]
        public void ThenTheDraftContractHeaderDetailsForTheLatestVersionOfTheContractHaveBeenUpdatedAsFollows(TransformedTable table)
        {
            List<SimpleContractHeader> simpleContractHeaders = new List<SimpleContractHeader>();
            foreach (var row in table.Rows)
            {
                simpleContractHeaders.Add(new SimpleContractHeader()
                {
                    MasterContractNumber = row["MasterContractNumber"],
                    ContractNumber = row["ContractNumber"],
                    ContractVersionNumber = int.Parse(row["ContractVersionNumber"]),
                    Ukprn = row["UKPRN"],
                    ContractStartDate = DateTime.ParseExact(row["ContractStartDate"], "dd/MM/yyyy", CultureInfo.InvariantCulture),
                    ContractEndDate = DateTime.ParseExact(row["ContractEndDate"], "dd/MM/yyyy", CultureInfo.InvariantCulture),
                    ContractPeriod = int.Parse(row["Period"]),
                    ContractType = row["ContractType"],
                    ContractValue = decimal.Parse(row["ContractValue"])
                });
            }
            Assert.IsTrue(_contractLoadStep.ContractHeadersMatch(simpleContractHeaders), "Contract headers do not match");
        }

        [Then(@"the draft contract allocations on the latest version of the contract are as follows")]
        [Then(@"the draft contract allocations details for the latest version of the contract have been updated as follows")]
        public void ThenTheDraftContractAllocationsDetailsForTheLatestVersionOfTheContractHaveBeenUpdatedAsFollows(TransformedTable table)
        {
            List<SimpleContractAllocation> simpleContractAllocations = new List<SimpleContractAllocation>();
            foreach (var row in table.Rows)
            {
                simpleContractAllocations.Add(new SimpleContractAllocation(row["AllocationRef"])
                {
                    ContractNumber = row["ContractNumber"],
                    FundingStreamCode = row["FundingStreamCode"],
                    AllocationStartDate = DateTime.ParseExact(row["AllocationStartDate"],"dd/MM/yyyy", CultureInfo.InvariantCulture),
                    AllocationEndDate = DateTime.ParseExact(row["AllocationEndDate"], "dd/MM/yyyy", CultureInfo.InvariantCulture),
                    AllocationValue = decimal.Parse(row["AllocationValue"]),
                    UoPName = row["UoPName"],
                    UoPCode = row["UoPCode"],
                    AllocationDescription = row["AllocationDescription"],
                    LEPCode = row["LEPCode"],
                    LEPName = row["LEPName"],
                    TenderSpecificationReference = row["TenderSpecificationReference"],
                    LotReference = row["LotReference"],
                    TenderAwardReference = row["TenderAwardReference"],
                    InvestmentPriority = row["InvestmentPriority"],
                    AgreementNumber = row["AgreementNumber"],
                    ActivityDescription = row["ActivityDescription"],
                    SpecificationTitle = row["SpecificationTitle"],
                    RegionType = row["RegionType"]
                });
            }

            List<Entity> allocationsinCrm = null;

            foreach (SimpleContractAllocation simpleAllocation in simpleContractAllocations)
            {
                if (allocationsinCrm == null || allocationsinCrm.All(m => m.GetAttributeValue("sfa_contractallocationnumber").ToString() != simpleAllocation.AllocationNumber))
                {
                    allocationsinCrm = _contractLoadStep.GetCrmAllocationsFromLatestContract(simpleAllocation.ContractNumber);
                }

                if (allocationsinCrm == null || allocationsinCrm.Count < 1)
                {
                    Assert.Fail($"No matching allocations found in CRM for contract {simpleAllocation.ContractNumber}");
                }

                Entity allocation = allocationsinCrm.FirstOrDefault(m => m.GetAttributeValue("sfa_contractallocationnumber").ToString() == simpleAllocation.AllocationNumber);
                if (allocation == null)
                {
                    Assert.Fail($"No matching allocations found in for allocation {simpleAllocation.AllocationNumber}");
                }

                Assert.AreEqual(simpleAllocation.ActivityDescription, (allocation.GetAttributeValue("sfa_projectdescription") ?? string.Empty).ToString(), $"ActivityDescription not as expected for allocation {simpleAllocation.AllocationNumber}");
                Assert.AreEqual(simpleAllocation.AgreementNumber, (allocation.GetAttributeValue("sfa_agreementnumber") ?? string.Empty).ToString(), $"AgreementNumber not as expected for allocation {simpleAllocation.AllocationNumber}");
                Assert.AreEqual(simpleAllocation.AllocationDescription, (allocation.GetAttributeValue("sfa_description") ?? string.Empty).ToString(), $"AllocationDescription not as expected for allocation {simpleAllocation.AllocationNumber}");
                Assert.AreEqual(simpleAllocation.AllocationEndDate, DateTime.Parse(allocation.GetAttributeValue("sfa_enddate").ToString()).Date, $"AllocationEndDate not as expected for allocation {simpleAllocation.AllocationNumber}");
                Assert.AreEqual(simpleAllocation.AllocationStartDate, DateTime.Parse(allocation.GetAttributeValue("sfa_startdate").ToString()).Date, $"AllocationStartDate not as expected for allocation {simpleAllocation.AllocationNumber}");
                Assert.AreEqual(simpleAllocation.AllocationValue, allocation.GetAttributeValue<decimal>("sfa_maximumcontractvalue"), $"AllocationValue not as expected for allocation {simpleAllocation.AllocationNumber}");
                Assert.AreEqual(simpleAllocation.FundingStreamCode, new AcceptanceTestUtils().GetFundingStreamCodeFromAllocation(allocation), $"FundingStreamCode not as expected for allocation {simpleAllocation.AllocationNumber}");
                Assert.AreEqual(simpleAllocation.InvestmentPriority, (allocation.GetAttributeValue("sfa_priority") ?? string.Empty).ToString(), $"InvestmentPriority not as expected for allocation {simpleAllocation.AllocationNumber}");
                Assert.AreEqual(simpleAllocation.LEPCode, (allocation.GetAttributeValue("sfa_lepcode") ?? string.Empty).ToString(), $"LEPCode not as expected for allocation {simpleAllocation.AllocationNumber}");
                Assert.AreEqual(simpleAllocation.LEPName, (allocation.GetAttributeValue("sfa_lepname") ?? string.Empty).ToString(), $"LEPName not as expected for allocation {simpleAllocation.AllocationNumber}");
                Assert.AreEqual(simpleAllocation.LotReference, (allocation.GetAttributeValue("sfa_lotreference") ?? string.Empty).ToString(), $"LotReference not as expected for allocation {simpleAllocation.AllocationNumber}");
                Assert.AreEqual(simpleAllocation.RegionType, (allocation.GetAttributeValue("sfa_regiontype") ?? string.Empty).ToString(), $"RegionType not as expected for allocation {simpleAllocation.AllocationNumber}");
                Assert.AreEqual(simpleAllocation.TenderSpecificationReference, (allocation.GetAttributeValue("sfa_ittreference") ?? string.Empty).ToString(), $"TenderSpecificationReference not as expected for allocation {simpleAllocation.AllocationNumber}");
                Assert.AreEqual(simpleAllocation.TenderAwardReference, (allocation.GetAttributeValue("sfa_awardreference") ?? string.Empty).ToString(), $"TenderAwardReference not as expected for allocation {simpleAllocation.AllocationNumber}");
            }
        }

        [Then(@"the draft contract deliverables details for the latest version of the contract have been updated as follows")]
        public void ThenTheDraftContractDeliverablesDetailsForTheLatestVersionOfTheContractHaveBeenUpdatedAsFollows(TransformedTable table)
        {
            List<SimpleContractDeliverable> simpleContractDeliverables = new List<SimpleContractDeliverable>();
            foreach (var row in table.Rows)
            {
                SimpleContractDeliverable simpleContractDeliverable = new SimpleContractDeliverable()
                {
                    ContractNumber = row["ContractNumber"],
                    AllocationReference = row["AllocationRef"],
                    DeliverableCode = row["DeliverableCode"],
                    Description = row["DeliverableDescription"],
                    Name = row["DeliverableName"],
                    Periods = new List<SimpleContractDeliverablePeriod>()
                };
                foreach (string header in row.Keys)
                {
                    DateTime dt;
                    if (DateTime.TryParse("01-" + header, out dt))
                    {
                        simpleContractDeliverable.Periods.Add(new SimpleContractDeliverablePeriod()
                        {
                            Name = header,
                            PlannedValue = decimal.Parse(row[header])
                        });
                    }
                }

                simpleContractDeliverables.Add(simpleContractDeliverable);
            }

            Assert.IsTrue(_contractLoadStep.ContractDeliverableMatch(simpleContractDeliverables), "One or more Contract Deliverables not as expected");
            Assert.IsTrue(_contractLoadStep.ContractDeliverablePeriodsMatch(simpleContractDeliverables), "Contract deliverable periods do not match");

        }

        [Then(@"the draft contract deliverable volume details for the latest version of the contract have been updated as follows")]
        public void ThenTheDraftContractDeliverableVolumeDetailsHaveBeenUpdatedAsFollows(Table table)
        {
            List<SimpleContractDeliverable> simpleContractDeliverables = new List<SimpleContractDeliverable>();

            foreach (var row in table.Rows)
            {
                SimpleContractDeliverable simpleContractDeliverable = new SimpleContractDeliverable()
                {
                    ContractNumber = row["ContractNumber"],
                    AllocationReference = row["AllocationRef"],
                    DeliverableCode = row["DeliverableCode"],
                    Periods = new List<SimpleContractDeliverablePeriod>()
                };
                foreach (string header in row.Keys)
                {
                    DateTime dt;
                    if (DateTime.TryParse("01-" + header, out dt))
                    {
                        SimpleContractDeliverablePeriod simpleContractDeliverablePeriod = new SimpleContractDeliverablePeriod()
                        {
                            Name = header,
                            PlannedVolume = int.Parse(row[header])
                        };
                        simpleContractDeliverable.Periods.Add(simpleContractDeliverablePeriod);
                    }
                }
                simpleContractDeliverables.Add(simpleContractDeliverable);
            }

            Assert.IsTrue(_contractLoadStep.ContractDeliverablePeriodsVolumesMatch(simpleContractDeliverables), "Contract deliverable period volumes do not match");
        }

        [Then(@"the total time taken is less than (.*) seconds")]
        public void ThenTheTotalTimeTakenIsLessThan(int p0)
        {
            var diffTimeSpan = DateTime.Now - _contractLoadStep.DateStarted;
            _contractLoadStep.TestDuration = diffTimeSpan;
            Assert.IsTrue(diffTimeSpan.TotalSeconds <= p0, "Timed part of test exceeded time allowed: " + diffTimeSpan.TotalSeconds);
            Console.WriteLine($"Total time taken: {diffTimeSpan.TotalSeconds} seconds");
        }

        private static void CreateOrgAndCaseLoad(string ukprn, string orgId, string orgName, string caseloadStatus, string adviserName)
        {
            var status = CrmStatusRepository.GetStatus(caseloadStatus);
            Account account = new Account
            {
                sfa_OrganisationID = orgId,
                sfa_UKPRN = ukprn,
                sfa_Status = status,
                Name = orgName
            };

            Guid organisationId = CrmConnectionFactory.GetNonRetryingConnection().Create(account);

            sfa_caseload caseload = new sfa_caseload
            {
                sfa_OrganisationId = new EntityReference(Account.EntityLogicalName, organisationId),
                sfa_UKPRN = ukprn,
                sfa_Status = status,
                sfa_organisationname = orgName,
                OwnerId = CrmTeamRepository.GetTeamEntityReference(adviserName)
            };

            CrmConnectionFactory.GetNonRetryingConnection().Create(caseload);
        }
    }
}