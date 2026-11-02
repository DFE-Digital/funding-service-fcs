namespace Operations.Web.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Threading.Tasks;
    using Azure.Storage.Blobs;
    using Operations.Web.Dtos;
    using Operations.Web.Infrastructure;
    using Operations.Web.Repositories;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.Framework.Logging.Interfaces;
    using CrossDomainContractInformation = SFA.FCT.CrossDomain.Integration.Entities.ContractInformation;

    public class AppLevyService : IAppLevyService
    {
        private readonly IAppLevyRepository _appLevyRepository;
        private readonly ITransportMessageSender _messageSender;
        private readonly string _connectionString = ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString;
        private readonly string _commonConnectionString;
        private readonly ILogger _logger;
        private readonly IAzureTableService _azureTableService;

        public AppLevyService(IAppLevyRepository appLevyRepository, ITransportMessageSender messageSender, ILogger logger, IAzureTableService azureTableService)
        {
            _appLevyRepository = appLevyRepository;
            _messageSender = messageSender;
            _commonConnectionString = ConfigurationManager.ConnectionStrings["CommonStorageConnectionString"].ConnectionString;
            _logger = logger;
        }


        public IReadOnlyCollection<SFA.FCT.CrossDomain.Integration.Entities.ContractInformation> GetLatestContractInformationByFundingTypeAndFundingPeriod(string fundingType, string fundingPeriod)
        {
            var allLevyContracts = _appLevyRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(fundingType, fundingPeriod);

            var levyContractsPost5000 = allLevyContracts
             .Where(c => int.Parse(c.ContractNumber.Split('-').Last()) >= 5000)
             .GroupBy(c => c.ContractNumber)
             .Select(g => g.OrderByDescending(c => c.ContractVersionNumber).First())
             .ToList();
            return levyContractsPost5000;
        }

        public async Task<List<FileDto>> GetFilesAsync(string container)
        {
            if (string.IsNullOrWhiteSpace(container))
            {
                throw new ArgumentException("Container name is required.", nameof(container));
            }

            try
            {
                var storageConnectionString = new BlobServiceClient(_commonConnectionString);
                var containerClient = storageConnectionString.GetBlobContainerClient(container);

                if (await containerClient.ExistsAsync())
                {
                    var blobs = containerClient.GetBlobs();
                    return blobs.Select(b => new FileDto
                    {
                        Name = b.Name,
                        Size = b.Properties.ContentLength,
                        UploadDate = b.Properties.LastModified
                    }).OrderByDescending(b => b.UploadDate).ToList();
                }
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(1, "An error occurred while fetching files from container: {Container}", ex, container);
                throw new Exception("An error occurred while fetching files.", ex);
            }
        }


        public async Task InsertReleaseEntityAsync(ReleaseEntity release)
        {
            await _azureTableService.InsertReleaseEntityAsync(release);
        }

        public async Task<List<ReleaseEntity>> GetAllEntitiesAsync()
        {
            return await _azureTableService.GetAllEntitiesAsync();
        }


        public async Task CopyDocumentsAsync(string sourceContainer, string destinationContainer)
        {
            var sourceBlobServiceClient = new BlobServiceClient(_commonConnectionString);
            var destinationBlobServiceClient = new BlobServiceClient(_connectionString);

            var sourceContainerClient = sourceBlobServiceClient.GetBlobContainerClient(sourceContainer);
            var destinationContainerClient = destinationBlobServiceClient.GetBlobContainerClient(destinationContainer);

            var blobs = sourceContainerClient.GetBlobs().ToList();
            foreach (var blobItem in blobs)
            {
                var sourceBlobClient = sourceContainerClient.GetBlobClient(blobItem.Name);
                var destinationBlobClient = destinationContainerClient.GetBlobClient(blobItem.Name);

                await destinationBlobClient.StartCopyFromUriAsync(sourceBlobClient.Uri);
            }
        }

        public void CreateAppLevyVariation(List<AppLevyDto> items)
        {
            if (items == null || items.Count == 0)
            {
                throw new ArgumentException("Items are required.", nameof(items));
            }

            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";
            try
            {
                var approvedApprovedContracts = FilterContracts(items, "Approved", "", "");
                var approvedModifiedContracts = FilterContracts(items, "Modified", "", "");
                var approvedUnderTerminationContracts = FilterContracts(items, "UnderTermination", "", "");
                var bothBespokeRequiredApprovedContracts = FilterContracts(items, "Approved", "Y", "Y");
                var bothBespokeRequiredModifiedContracts = FilterContracts(items, "Modified", "Y", "Y");
                var bothBespokeRequiredUnderTerminationContracts = FilterContracts(items, "UnderTermination", "Y", "Y");

                var singleApprovedLetterBespokeContracts = FilterSingleBespokeContracts(items, bothBespokeRequiredApprovedContracts, "Y", "", "Approved", "Approved");
                var singleModifiedLetterBespokeContracts = FilterSingleBespokeContracts(items, bothBespokeRequiredModifiedContracts, "Y", "", "Approved", "Modified");
                var singleUnderTerminationLetterBespokeContracts = FilterSingleBespokeContracts(items, bothBespokeRequiredUnderTerminationContracts, "Y", "", "Approved", "UnderTermination");
                var singleApprovedTnCBespokeContracts = FilterSingleBespokeContracts(items, bothBespokeRequiredApprovedContracts, "", "Y", "Approved", "Approved");
                var singleModifiedTnCBespokeContracts = FilterSingleBespokeContracts(items, bothBespokeRequiredModifiedContracts, "", "Y", "Approved", "Modified");
                var singleUnderTerminationTnCBespokeContracts = FilterSingleBespokeContracts(items, bothBespokeRequiredUnderTerminationContracts, "", "Y", "Approved", "UnderTermination");


                var allLevyContracts = _appLevyRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(levyFundingType, levyFundingPeriod);
                var levyContractsPost5000 = allLevyContracts.Where(c => int.Parse(c.ContractNumber.Split('-').Last()) >= 5000).ToList();



                var filteredApprovedApprovedContracts = FilterLevyContracts(levyContractsPost5000, approvedApprovedContracts, ContractStatus.Approved, ContractSubStatus.Approved);
                var filteredApprovedModifiedContracts = FilterLevyContracts(levyContractsPost5000, approvedModifiedContracts, ContractStatus.Approved, ContractSubStatus.Modified);
                var filteredApprovedUnderTerminationContracts = FilterLevyContracts(levyContractsPost5000, approvedUnderTerminationContracts, ContractStatus.Approved, ContractSubStatus.UnderTermination);

                var filteredApprovedApprovedBespokeContracts = FilterLevyContracts(levyContractsPost5000, bothBespokeRequiredApprovedContracts, ContractStatus.Approved, ContractSubStatus.Approved);
                var filteredModifiedApprovedBespokeContracts = FilterLevyContracts(levyContractsPost5000, bothBespokeRequiredModifiedContracts, ContractStatus.Approved, ContractSubStatus.Modified);
                var filteredUnderTerminationApprovedBespokeContracts = FilterLevyContracts(levyContractsPost5000, bothBespokeRequiredUnderTerminationContracts, ContractStatus.Approved, ContractSubStatus.UnderTermination);

                var filteredsingleApprovedLetterBespokeContracts = FilterLevyContracts(levyContractsPost5000, singleApprovedLetterBespokeContracts, ContractStatus.Approved, ContractSubStatus.Approved);
                var filteredsingleModifiedLetterBespokeContracts = FilterLevyContracts(levyContractsPost5000, singleModifiedLetterBespokeContracts, ContractStatus.Approved, ContractSubStatus.Modified);
                var filteredsingleUnderTerminationLetterBespokeContracts = FilterLevyContracts(levyContractsPost5000, singleUnderTerminationLetterBespokeContracts, ContractStatus.Approved, ContractSubStatus.UnderTermination);
                var filteredsingleApprovedTnCBespokeContracts = FilterLevyContracts(levyContractsPost5000, singleApprovedTnCBespokeContracts, ContractStatus.Approved, ContractSubStatus.Approved);
                var filteredsingleModifiedTnCBespokeContracts = FilterLevyContracts(levyContractsPost5000, singleModifiedTnCBespokeContracts, ContractStatus.Approved, ContractSubStatus.Modified);
                var filteredsingleUnderTerminationTnCBespokeContracts = FilterLevyContracts(levyContractsPost5000, singleUnderTerminationTnCBespokeContracts, ContractStatus.Approved, ContractSubStatus.UnderTermination);


                AmendContracts(filteredApprovedApprovedContracts, "T&C_LEVY_2017-05-01", "LEVY1799_Amendment");
                AmendContracts(filteredApprovedModifiedContracts, "T&C_LEVY_2017-05-01", "LEVY1799_Amendment_Modified");
                AmendContracts(filteredApprovedUnderTerminationContracts, "T&C_LEVY_2017-05-01_UT", "LEVY1799_Amendment_UnderTerm", true);
                AmendContracts(filteredApprovedApprovedBespokeContracts, "T&C_LEVY_2017-05-01_", "LEVY1799_Amendment_", false, true);
                AmendContracts(filteredModifiedApprovedBespokeContracts, "T&C_LEVY_2017-05-01_", "LEVY1799_Amendment_Modified_", false, true);
                AmendContracts(filteredUnderTerminationApprovedBespokeContracts, "T&C_LEVY_2017-05-01_UT_", "LEVY1799_Amendment_UnderTerm_", true, true);

                AmendSingleBespokeContracts(filteredsingleApprovedLetterBespokeContracts, "T&C_LEVY_2017-05-01", "LEVY1799_Amendment_");
                AmendSingleBespokeContracts(filteredsingleModifiedLetterBespokeContracts, "T&C_LEVY_2017-05-01", "LEVY1799_Amendment_Modified_");
                AmendSingleBespokeContracts(filteredsingleUnderTerminationLetterBespokeContracts, "T&C_LEVY_2017-05-01_UT", "LEVY1799_Amendment_UnderTerm_");
                AmendSingleBespokeContracts(filteredsingleApprovedTnCBespokeContracts, "T&C_LEVY_2017-05-01_", "LEVY1799_Amendment", true);
                AmendSingleBespokeContracts(filteredsingleModifiedTnCBespokeContracts, "T&C_LEVY_2017-05-01_", "LEVY1799_Amendment_Modified", true);
                AmendSingleBespokeContracts(filteredsingleUnderTerminationTnCBespokeContracts, "T&C_LEVY_2017-05-01_UT_", "LEVY1799_Amendment_UnderTerm", true);
            }
            catch (Exception ex)
            {
                _logger.LogError(1, "An error occurred while creating App Levy variation.", ex);
                throw new Exception("An error occurred while creating App Levy variation.", ex);
            }
        }

        private List<AppLevyDto> FilterContracts(List<AppLevyDto> items, string subStatus, string isLetterBespoke, string isTnCBespoke)
        {
            return items.Where(status => status.ContractSubStatus == subStatus && status.IsLetterBespoke == isLetterBespoke && status.IsTnCBespoke == isTnCBespoke).ToList();
        }

        private List<AppLevyDto> FilterSingleBespokeContracts(List<AppLevyDto> items, List<AppLevyDto> bothBespokeRequiredContracts, string isLetterBespoke, string isTnCBespoke, string contractStatus, string contractSubStatus)
        {
            return items.Where(item => item.IsLetterBespoke == isLetterBespoke && item.IsTnCBespoke == isTnCBespoke &&
                                       !bothBespokeRequiredContracts.Any(a => a.ContractNumber == item.ContractNumber) &&
                                       item.ContractStatus == contractStatus && item.ContractSubStatus == contractSubStatus).ToList();
        }

        private List<CrossDomainContractInformation> FilterLevyContracts(List<CrossDomainContractInformation> levyContracts, List<AppLevyDto> contracts, ContractStatus status, ContractSubStatus subStatus)
        {
            return levyContracts.Where(c => c.ContractStatus == status && c.ContractSubStatus == subStatus && contracts.Any(a => a.ContractNumber == c.ContractNumber)).ToList();
        }

        private void AmendSingleBespokeContracts(List<CrossDomainContractInformation> contracts, string overrideTemplateName, string overrideAmendmentTemplate, bool isSingle = false)
        {
            contracts.ForEach(c =>
            {
                try
                {
                    _messageSender.Send(new AmendLevyContractCommand
                    {
                        ContractInformation = c,
                        AmendmentType = SFA.FCT.ContractManagementService.Common.AmendmentType.Variation,
                        AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                        ShouldAddPayableNonLevyAllocation = false,
                        ShouldMergeAmendmentTemplate = true,
                        OverrideTemplateName = isSingle ? $"{overrideTemplateName}{c.ContractNumber}.docx" : $"{overrideTemplateName}.docx",
                        OverrideAmendmentTemplate = isSingle ? $"{overrideAmendmentTemplate}.docx" : $"{overrideAmendmentTemplate}{c.ContractNumber}.docx"
                    }, "ContractManagementDomain.LevyAmendmentEndpoint");
                }
                catch (Exception ex)
                {
                    _logger.LogError(1, "An error occurred while amending single bespoke contract: {ContractNumber}", ex, c.ContractNumber);
                    throw;
                }
            });
        }

        private void AmendContracts(List<CrossDomainContractInformation> contracts, string overrideTemplateName, string overrideAmendmentTemplate, bool allowUnderTermination = false, bool isBoth = false)
        {
            contracts.ForEach(c =>
            {
                try
                {
                    _messageSender.Send(new AmendLevyContractCommand
                    {
                        ContractInformation = c,
                        AmendmentType = SFA.FCT.ContractManagementService.Common.AmendmentType.Variation,
                        AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                        ShouldAddPayableNonLevyAllocation = false,
                        ShouldMergeAmendmentTemplate = true,
                        AllowUnderTermination = allowUnderTermination,
                        OverrideTemplateName = isBoth ? $"{overrideTemplateName}{c.ContractNumber}.docx" : $"{overrideTemplateName}.docx",
                        OverrideAmendmentTemplate = isBoth ? $"{overrideAmendmentTemplate}{c.ContractNumber}.docx" : $"{overrideAmendmentTemplate}.docx"
                    }, "ContractManagementDomain.LevyAmendmentEndpoint");
                }
                catch (Exception ex)
                {
                    _logger.LogError(1, "An error occurred while amending contract: {ContractNumber}", ex, c.ContractNumber);
                    throw;
                }
            });
        }
    }
}