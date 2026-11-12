namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System.IO;
    using System.Linq;
    using TechTalk.SpecFlow;
    using Infrastructure.Repositories;
    using Infrastructure.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using CrossDomain.Integration.Common.Storage;
    using DocumentsDomain.DataStore.Models;
    using Extensions;
    using MoreLinq;
    using Utilities;
    using NUnit.Framework.Legacy;

    [Binding]
    public class DocumentsDomainSteps
    {
        [Given(@"there is no data in the document archive or the associated control table")]
        public void GivenThereIsNoDataInTheDocumentArchiveOrTheAssociatedControlTable()
        {
            ArchivedDocumentRepository.RemoveAll();

            string containerName = $"fcs-document-archive{AzureBlobStorageHelper.GetEnvironmentSuffix()}";
            AzureStorageWrapper.CreateIfNotExists(containerName);
            AzureBlobStorageHelper.RemoveAll(containerName);
        }

        [Then(@"there is '(.*)' file prefixed '(.*)' in the document archive and the associated control table")]
        [Then(@"there are '(.*)' files prefixed '(.*)' in the document archive and the associated control table")]
        public void ThenThereIsFilePrefixedInTheDocumentArchiveAndTheAssociatedControlTable(int expectedRowCount, string fileNamePrefix)
        {
            var archivedDocuments = ArchivedDocumentRepository.GetArchivedDocumentsThatHaveFilenamePrefix(fileNamePrefix);

            ClassicAssert.AreEqual(expectedRowCount, archivedDocuments.Count,
                $"Unexpected number of control table rows present with filename prefix '{fileNamePrefix}'");

            string containerName = $"fcs-document-archive{AzureBlobStorageHelper.GetEnvironmentSuffix()}";
            AzureStorageWrapper.CreateIfNotExists(containerName);

            var missingArchivedDocument = archivedDocuments
                .FirstOrDefault(archivedDocument => 
                    AzureStorageWrapper.DoesBlockBlobExist(new FctFile(fileContainer: containerName, filename: archivedDocument.Key.ToString())) == false);

            ClassicAssert.IsNull(missingArchivedDocument, $"The document '{missingArchivedDocument?.FileName}' is missing in document archive (blob storage)");
        }

        [Given(@"Sharepoint file '(.*)' in '(.*)' is copied to '(.*)' as '(.*)'")]
        [When(@"Sharepoint file '(.*)' in '(.*)' is copied to '(.*)' as '(.*)'")]
        [Then(@"Sharepoint file '(.*)' in '(.*)' is copied to '(.*)' as '(.*)'")]
        public void GivenSharepointFileInIsCopiedToAs(TransformedString sharepointFile, string sharepointFolder, string localFolder, TransformedString localFile)
        {
            byte[] fileContents = SharepointDocumentRepository.GetDocumentBytes(folderName: sharepointFolder, fileName: sharepointFile.Value);

            string fullFilePath = $"../../{localFolder}/{localFile}";
            Directory.CreateDirectory(Path.GetDirectoryName(fullFilePath));
            File.WriteAllBytes(fullFilePath, fileContents);

        }

        [Given(@"the following NLAP NewStarts profile values exist in config")]
        public void GivenTheFollowingNlapNewStartsProfileValuesExistInConfig(Table table)
        {
            NlapFundingConfig Transform(TableRow row) => new NlapFundingConfig(
                row.ParseInt("UKPRN"),
                row.ParseDecimal("16-18NewStarts2021"),
                row.ParseDecimal("AdultNewStarts2021"),
                row.ParseDecimal("16-18NewStartsEstimatedFutureFunding"),
                row.ParseDecimal("AdultNewStartsEstimatedFutureFunding"));

            table.Rows
                .Select(Transform)
                .ForEach(NlapFundingConfigRepository.AddOrUpdate);
        }

        [Given(@"there is no NLAP NewStarts profile data in config for UKPRN '(.*)'")]
        [Then(@"there is no NLAP NewStarts profile data in config for UKPRN '(.*)'")]
        public void GivenThereIsNoNlapNewStartsProfileDataInConfigForUkprn(int ukprn)
        {
            NlapFundingConfigRepository.RemoveByUkprn(ukprn);
        }


        [Given(@"there are no Sector-based Work Academies profile values in config for UKPRN '(.*)'")]
        [Then(@"there are no Sector-based Work Academies profile values in config for UKPRN '(.*)'")]
        public void GivenThereAreNoSectorBasedWorkAcademiesProfileValuesInConfigForUkprn(int ukprn)
        {
            ContractReferenceConfigRepository.RemoveByUkprn(ukprn);
        }

        [Given(@"the following Sector-based Work Academies profile values exist in config")]
        public void GivenTheFollowingSectorBasedWorkAcademiesProfileValuesExistInConfig(TransformedTable table)
        {
            ContractReferenceConfig Transform(TableRow row) => new ContractReferenceConfig(
                    row.ParseInt("UKPRN"),
                    row["FSPCode"],
                    row.ParseDecimal("Aug20-Mar21"),
                    row.ParseDecimal("Apr21-Jul21"));

            table.Rows
                .Select(Transform)
                .ForEach(ContractReferenceConfigRepository.AddOrUpdate);
        }
    }
}