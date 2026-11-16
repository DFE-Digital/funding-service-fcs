namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using NUnit.Framework;
    using Pages;
    using TechTalk.SpecFlow;
    using CrossDomain.Integration.Entities.Xrm;
    using State;
    using Utilities;
    using NUnit.Framework.Legacy;

    [Binding]
    public class ContractDocumentationAppendiciesSteps
    {
        private readonly ContractDocumentGenerationPageObject _contractDocumentGeneration;
        private readonly ContractRepositoryPageObject _contractRepositoryPageObject;
        private readonly RetrievedContractFromCrmState _crmState;

        public ContractDocumentationAppendiciesSteps(
            ContractRepositoryPageObject contractRepositoryPageObject,
            RetrievedContractFromCrmState crmState,
            ContractDocumentGenerationPageObject contractDocumentGeneration)
        {
            _contractRepositoryPageObject = contractRepositoryPageObject;
            _crmState = crmState;
            _contractDocumentGeneration = contractDocumentGeneration;
        }

        [BeforeScenario("MergeSinglePageContractRejectWithNoTsandCs")]
        [AfterScenario("MergeSinglePageContractRejectWithNoTsandCs")]
        private void RemoveSinglePageRejectWithNoTsandCsScenarioFiles()
        {
            _contractDocumentGeneration.DeleteFile("22228860_MAIN-862_v1.pdf", "MAIN-1516-Input-Appendices");
        }

        [Given(@"a file with filename '(.*)' is created in '(.*)'")]
        [When(@"a file with filename '(.*)' is created in '(.*)'")]
        [Given(@"a file with filename '(.*)' is created in the location '(.*)'")]
        [Then(@"a file with filename '(.*)' is created in the location '(.*)'")]
        public void GivenAFileWithFilenameIsCreatedInTheLocation(TransformedString filename, string location)
        {
            _contractDocumentGeneration.UploadFileToSharePoint(location, filename.Value, "DummyPdf.pdf");
        }

        [Given(@"a file called '(.*)' is created in Sharepoint folder '(.*)'")]
        public void GivenAFileCalledIsCreatedInSharepointFolder(TransformedString filename, string location)
        {
            _contractDocumentGeneration.UploadFileToSharePoint(location, filename.Value, "JerryMouse.pdf");
        }

        [Then(@"'(.*)' files named '(.*)' concatenated with '(.*)' concatenated with '(.*)' is created in the location '(.*)'")]
        public void ThenFilesNamedConcatenatedWithConcatenatedWithIsCreatedInTheLocation(int iterations, int ukprn, string p2, string p3, string p4)
        {
            for (int x = 1; x <= iterations; x++)
            {
                string orgukprn = (ukprn + x).ToString();
                ThenAFileNamedIsCreatedInTheLocation(orgukprn + p2 + x + p3, p4);
            }
        }

        [Given(@"'(.*)' files named '(.*)' concatenated with '(.*)' concatenated with '(.*)' are created in the location '(.*)' based on file '(.*)'")]
        public void GivenFilesNamedConcatenatedWithConcatenatedWithIsCreatedInTheLocationBasedOnFile(int iterations, int ukprn, string p2, string p3, string p4, string p5)
        {
            for (int x = 1; x <= iterations; x++)
            {
                string orgukprn = (ukprn + x).ToString();
                _contractDocumentGeneration.UploadFileToSharePointBasedOnTemplate(p4, orgukprn + p2 + x + p3, p5);
            }
        }

        [Given(@"a file named '(.*)' is NOT in the location '(.*)'")]
        [Then(@"a file named '(.*)' is NOT in the location '(.*)'")]
        public void ThenAFileNamedIsNOTInTheLocation(string fileName, string location)
        {
            _contractDocumentGeneration.TargetFileName = fileName;
            _contractDocumentGeneration.DocumentLocation = location;

            int count = 1;
            bool found = true;

            while (count <= 5)
            {
                Console.WriteLine("Attempting to get pdf file, attempt number: " + count);
                found = _contractDocumentGeneration.DoesFileExist(location, fileName);
                count++;

                if (!found)
                    break;

                System.Threading.Tasks.Task.Delay(2000).Wait();
            }

            ClassicAssert.IsFalse(found, $"pdf file '{fileName}' was found at {location}");
        }

        [Given(@"all DocMerge files have been deleted for '(.*)' consecutive UKPRNs starting at '(.*)' and ContractNumbers starting at '(.*)'")]
        [Given(@"all the '(.*)' set of DocMerge files for '(.*)' and '(.*)' are cleared")]
        [Then(@"all the '(.*)' set of DocMerge files for '(.*)' and '(.*)' are cleared")]
        public void ThenAllTheSetOfDocMereFilesAreCleared(int iterations, int ukprn, string contractNumber)
        {
            string[] contractNumberParts = contractNumber.Split('-');
            string fundingType = contractNumberParts[0];
            int contractNumberInt = int.Parse(contractNumberParts[1]);

            for (int x = 1; x <= iterations; x++)
            {
                string orgukprn = (ukprn + x).ToString();

                _contractDocumentGeneration.DeleteFile($"{orgukprn}_{fundingType}-{contractNumberInt + x}_v1.pdf", "MAIN-1516-Input-Appendices");
                _contractDocumentGeneration.DeleteFile($"{orgukprn}_{fundingType}-{contractNumberInt + x}_01.pdf", "Main-1516-Input-Terms And Conditions");
                _contractDocumentGeneration.DeleteFile($"{orgukprn}_{fundingType}-{contractNumberInt + x}_v1.pdf", "Main-1516-Output-Merged Document");
            }
        }

        [Given(@"(?:a )*period (.*)")]
        public void GivenFundingTypePeriod(string p0)
        {
            _contractDocumentGeneration.FundingTypePeriod = p0;
        }

        [Then(@"the pdf file contains the following simple lines in order")]
        public void ThenThePdfFileContainsTheFollowingSimpleLinesInOrder(string multilineText)
        {
            _contractDocumentGeneration.VerifyLinesInOrderAndAssertIfNotFoundWithoutMergeData(multilineText);
        }

        [Then(@"the pdf file contains the following parameterized lines in order")]
        public void ThenThePdfFileContainsTheFollowingParameterizedLinesInOrder(TransformedString multilineText)
        {
            _contractDocumentGeneration.VerifyParameterizedLinesInOrderAndAssertIfNotFound(multilineText.Value);
        }

        [Given(@"the pdf file contains the following page lines in order")]
        [Then(@"the pdf file contains the following page lines in order")]
        public void ThenThePdfFileContainsTheFollowingPageLinesInOrder(TransformedString multilineText)
        {
            _contractDocumentGeneration.VerifyPageLinesInOrderAndAssertIfNotFound(multilineText.Value);
        }

        [Then(@"the file named '(.*)' & '(.*)' & '(.*)' created in Sharepoint location '(.*)' contains the following lines in order")]
        public void ThenAFileNamedInSharepointLocationContainsTheFollowingLinesInOrder(string ukprn, TransformedString contractNo, string filenameSuffix, string folder, TransformedString multilineText)
        {
            _contractDocumentGeneration.TargetFileName = ukprn + contractNo + filenameSuffix;
            _contractDocumentGeneration.DocumentLocation = folder;

            _contractDocumentGeneration.VerifyPageLinesInOrderAndAssertIfNotFound(multilineText);
        }

        [Then(@"the file named '(.*)' in Sharepoint location '(.*)' contains the following lines in order")]
        public void ThenAFileNamedInSharepointLocationContainsTheFollowingLinesInOrder(TransformedString filename, string folder, TransformedString multilineText)
        {
            _contractDocumentGeneration.TargetFileName = filename;
            _contractDocumentGeneration.DocumentLocation = folder;

            _contractDocumentGeneration.VerifyPageLinesInOrderAndAssertIfNotFound(multilineText);
        }

        [Then(@"the pdf file does not contain the following line")]
        public void ThenThePdfFileDoesNotContainTheFollowingLine(string multilineText)
        {
            _contractDocumentGeneration.VerifyLinesAreNotPresentInOrderAndAssertIfFound(multilineText);
        }

        [Then(@"the pdf file does not contain the following text")]
        public void ThenThePdfFileDoesNotContainTheFollowingText(string multilineText)
        {
            _contractDocumentGeneration.VerifyTextNotPresentAndAssertIfFound(multilineText);
        }

        [Given(@"I retrieve the latest contract details from CRM for provider '(.*)' for FundingType '(.*)' and period '(.*)'")]
        [When(@"I retrieve the latest contract details from CRM for provider '(.*)' for FundingType '(.*)' and period '(.*)'")]
        [Then(@"I retrieve the latest contract details from CRM for provider '(.*)' for FundingType '(.*)' and period '(.*)'")]
        public void WhenIRetrieveTheLatestContractDetailsFromCRMForProviderForFundingTypeAndPeriod(int ukprn, string fundingType, int period)
        {
            sfa_contract contract = _contractRepositoryPageObject.RetrieveLatestContractDataAndSetState(ukprn.ToString(), fundingType, period.ToString());
            ClassicAssert.IsTrue(contract != null, $"There is no contract in CRM for UKPRN {ukprn} with FundingType {fundingType} and period {period}");
        }

        private void ThenTheFileNamedExistsInTheLocation(string fileName, string location)
        {
            ClassicAssert.IsTrue(_contractDocumentGeneration.DoesFileExist(location, fileName), $"output file not found {fileName} in {location}");
        }

        [Given(@"a file for this contract exists in sharepoint location '(.*)'")]
        [When(@"a file for this contract exists in sharepoint location '(.*)'")]
        [Then(@"a file for this contract exists in sharepoint location '(.*)'")]
        public void ThenAFileForThisContractExistsInSharepointLocation(string location)
        {
            // the filename looks like this '10017851_' & '[ContractNo]' & '_v1.pdf'
            string fileName = null;
            if (_crmState.Contract != null)
            {
                fileName = _contractRepositoryPageObject.GetFileNameFromLatestContractData(
                    ukprn: _crmState.Contract.Ukprn,
                    contractNumber: _crmState.Contract.ContractNumber,
                    contractVersionNumber: _crmState.Contract.ContractVersion.ToString()
                    );
            }
            else
            {
                fileName = _contractRepositoryPageObject.GetFileNameFromLatestContractData();
            }

            _contractDocumentGeneration.DocumentLocation = location;
            _contractDocumentGeneration.TargetFileName = fileName;
            ThenTheFileNamedExistsInTheLocation(fileName, location);
        }

        private void ThenAFileNamedIsCreatedInTheLocation(string fileName, string location)
        {
            _contractDocumentGeneration.TargetFileName = fileName;
            _contractDocumentGeneration.DocumentLocation = location;

            int count = 1;
            bool found = false;

            while (count <= 10)
            {
                Console.WriteLine("Attempting to get document, attempt number: " + count);
                found = _contractDocumentGeneration.DoesFileExist(location, fileName);
                count++;

                if (found)
                    break;

                System.Threading.Tasks.Task.Delay(2000).Wait();
            }

            ClassicAssert.IsTrue(found, "output pdf file not found");
        }
    }
}