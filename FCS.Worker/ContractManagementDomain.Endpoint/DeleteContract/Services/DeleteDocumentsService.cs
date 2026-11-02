namespace ContractManagementDomain.Endpoint.DeleteContract.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    public class DeleteDocumentsService : IDeleteDocumentsService
    {
        private readonly ICrmContractAttributesRepository _contractAttributesRepository;
        private readonly IOffice365Adapter _office365Adapter;

        public DeleteDocumentsService(ICrmContractAttributesRepository contractAttributesRepository, IOffice365Adapter office365Adapter)
        {
            _contractAttributesRepository = contractAttributesRepository;
            _office365Adapter = office365Adapter;
        }

        public void DeleteDocumentsForContract(string contractNumber, int version)
        {
            ContractAttributes contractAttributes =
                _contractAttributesRepository.GetAttributesForContract(contractNumber, version);

            string fileNameWithVersionPrefix = $"{contractAttributes.Ukprn}_{contractNumber}_v{version}";

            IReadOnlyCollection<FileDetails> foldersToClean = new List<FileDetails>
            {
                new FileDetails(folderName: GetFolderName(CommonUtil.ContractAppendicesFolderName, contractAttributes.FundingType, contractAttributes.Period),
                                fileNamePrefix: fileNameWithVersionPrefix),
                new FileDetails(folderName: GetFolderName(CommonUtil.ContractMergedDocumentFolderName, contractAttributes.FundingType, contractAttributes.Period),
                                fileNamePrefix: fileNameWithVersionPrefix),
                new FileDetails(folderName: GetFolderName(CommonUtil.ContractTermsAndConditionsFolderName, contractAttributes.FundingType, contractAttributes.Period),
                                fileNamePrefix: $"{contractAttributes.Ukprn}_{contractNumber}")
            };

            foldersToClean.ToList().ForEach(folderToClean => RemoveMatchingFilesFromFolder(folderToClean.FolderName, folderToClean.FileNamePrefix));
        }

        private void RemoveMatchingFilesFromFolder(string folderName, string fileNamePrefix)
        {
            var fileNames = _office365Adapter.GetFilenamesByFileNameStartText(folderName, fileNamePrefix);

            fileNames.ToList().ForEach(fileName => _office365Adapter.DeleteFile(fileName, folderName));
        }

        private string GetFolderName(string folderNameUnformatted, string fundingType, string period)
        {
            return folderNameUnformatted.Replace("{FundingType}", fundingType)
                .Replace("{Period}", period);
        }

        private class FileDetails
        {
            public FileDetails(string folderName, string fileNamePrefix)
            {
                FolderName = folderName;
                FileNamePrefix = fileNamePrefix;
            }

            public string FolderName { get; }

            public string FileNamePrefix { get; }
        }
    }
}
