namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System.IO;
    using Infrastructure.Services;
    using NUnit.Framework;
    using Pages;
    using TechTalk.SpecFlow;
    using Xrm.TestFramework;

    [Binding]
    public class LoadBasicOrgDataSteps
    {
        private readonly ContractLoadPage _contractLoadPage;

        public LoadBasicOrgDataSteps(ContractLoadPage contractLoadPage)
        {
            _contractLoadPage = contractLoadPage;
        }

        [Given(@"Bulk Upload file '(.*)' file exists at '(.*)' with a UKPRN '(.*)'")]
        public void GivenBulkUploadFileFileExistsAtWithAUkprn(string fileName, string filePath, int ukprn)
        {
            _contractLoadPage.InputFilePath = Path.Combine(filePath, fileName);

            Assert.IsTrue(File.Exists(_contractLoadPage.InputFilePath), "Input file does not exist");
        }

        [Then(@"UKPRN '(.*)' has not been duplicated in CRM")]
        public void ThenTheOrganisationUkprnRecordIsNotDuplicatedInCrmSystem(int ukprn)
        {
            XrmPackageEntity orgEntity = XrmService.Configuration.Entity("account");

            XrmService.Connection.GetUniqueRecord(orgEntity, ukprn.ToString(), "sfa_ukprn");
        }
    }
}