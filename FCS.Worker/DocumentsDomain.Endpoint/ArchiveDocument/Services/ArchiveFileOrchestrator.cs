namespace DocumentsDomain.Endpoint.ArchiveDocument.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.DocumentsDomain.Common;

    public class ArchiveFileOrchestrator : IArchiveFileOrchestrator
    {
        private readonly IOffice365Adapter _office365Adapter;

        public ArchiveFileOrchestrator(IOffice365Adapter office365Adapter)
        {
            _office365Adapter = office365Adapter;
        }

        public IReadOnlyCollection<FileInfo> OrchestrateForNotification(Contract corporateContract)
        {
            var childContract = corporateContract.contracts.First();
            string fundingTypeCode = childContract.fundingType.fundingTypeCode;
            string period = childContract.period.period1;
            string appendicesFolder = DocumentFolderLocation.GetLocationOfAppendices(fundingTypeCode, period);

            string filePrefix = $"{childContract.contractor.ukprn}_{childContract.contractNumber}";

            return GetFileInfos(appendicesFolder, filePrefix, FileAction.Delete, ContractAmendmentType.Notification);
        }

        public IReadOnlyCollection<FileInfo> OrchestrateForNonNotification(Contract corporateContract)
        {
            var childContract = corporateContract.contracts.First();
            string fundingTypeCode = childContract.fundingType.fundingTypeCode;
            string period = childContract.period.period1;
            string appendicesFolder = DocumentFolderLocation.GetLocationOfAppendices(fundingTypeCode, period);

            string filePrefix = $"{childContract.contractor.ukprn}_{childContract.contractNumber}";

            var filesToDelete = GetFileInfos(appendicesFolder, filePrefix, FileAction.Delete, ContractAmendmentType.NotSet);

            string publishedFolder = DocumentFolderLocation.GetLocationOfPublishedDocument(fundingTypeCode, period);

            filesToDelete.AddRange(GetFileInfos(publishedFolder, filePrefix, FileAction.Archive, ContractAmendmentType.NotSet));

            return filesToDelete;
        }

        private List<FileInfo> GetFileInfos(string folderName, string filePrefix, FileAction fileAction, ContractAmendmentType amendmentType)
        {
            return GetMatchingFiles(folderName, filePrefix)
                .Select(fileName => new FileInfo(fileName, folderName: folderName, fileAction: fileAction, amendmentType: amendmentType))
                .ToList();
        }

        private IReadOnlyCollection<string> GetMatchingFiles(string folder, string filePrefix)
        {
            return _office365Adapter.GetFilenamesByFileNameStartText(folder, filePrefix) as List<string>;
        }
    }
}
