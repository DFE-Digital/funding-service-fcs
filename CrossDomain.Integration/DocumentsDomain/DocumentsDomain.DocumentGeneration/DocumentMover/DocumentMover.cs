namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentMover
{
    using System.Linq;
    using Common;
    using Common.Exceptions;
    using CrossDomain.Integration.Common.Exceptions;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentDefiner;
    using DocumentLocationResolver;
    using Framework.Logging.Interfaces;
    using Framework.Logging.NullObjects;
    using System;
    public class DocumentMover : IDocumentMover
    {
        private readonly IDocumentLocationResolver _documentLocationResolver;
        private readonly IDocumentDefiner _documentDefiner;
        private readonly IOffice365Adapter _office365Adapter;

        public ILogger Logger { get; set; }

        public DocumentMover(IDocumentLocationResolver documentLocationResolver, 
                            IOffice365Adapter office365Adapter,
                            IDocumentDefiner documentDefiner)
        {
            _documentLocationResolver = documentLocationResolver;
            _office365Adapter = office365Adapter;
            _documentDefiner = documentDefiner;
            Logger = new LoggerNullObject();
        }

        public void MoveContractDocumentToPublishLocation(Contract masterContract)
        {
            Validate(masterContract); 
            var childContract = masterContract.contracts.First();

            Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentMoverStart, $"Document Mover requested to move contract document for {childContract.contractNumber}");

            string contractDocumentationFileName = _documentDefiner.GetTargetFileName(childContract).Filename;

            // For Funding Type like DAS for which skip documentation merge is true, the contract document will be in appendices folder. 
            // For Non-DAS funding type where skip documnetation merge is false, the merged document (appendices and ts and cs) will be in the output merged doc library.

            string inputDocumentLocation = childContract.SkipDocumentMerge
                                        ? _documentLocationResolver.GetLocationOfAppendices(childContract) 
                                        : _documentLocationResolver.GetLocationOfMergedDocument(childContract);
            
            string publishedDocumentLocation = _documentLocationResolver.GetLocationOfPublishedDocument(childContract);

            Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentMoverMovingDocument, $"DocumentMover moving document for contract:{childContract.contractNumber} filename:{contractDocumentationFileName} from {inputDocumentLocation} to document list {publishedDocumentLocation}");

            try
            {
                _office365Adapter.MoveFile(contractDocumentationFileName, inputDocumentLocation,
                publishedDocumentLocation);
                
                Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentMoverEnd, $"Document Mover Requested completed for contract {childContract.contractNumber}");
                
            }
            catch (FileNotFoundException e)
            {
                Logger.LogError(DocumentsDomainLoggingEventId.DocumentMoverFileNotFound, e, $"Could not find merged document for contract: {childContract.contractNumber} filename: {contractDocumentationFileName} in location: {inputDocumentLocation}");

                throw new DocumentMoveException(string.Format(Constants.MergedDocumentDoesNotExistErrorMessage, childContract.contractor.ukprn, childContract.contractNumber), e);
            }
        }

        public bool IsContractDocumentAlreadyPublished(Contract masterContract)
        {
            bool result = false;

            Validate(masterContract);
            var childContract = masterContract.contracts.First();

            Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentMoverCheckIfContractDocumentAlreadyPublishedStart, $"Document Mover requested to check contract document for {childContract.contractNumber} exists in published location" );

            string contractDocumentationFileName = _documentDefiner.GetTargetFileName(childContract).Filename;
            string publishedDocumentLocation = _documentLocationResolver.GetLocationOfPublishedDocument(childContract);

            if (_office365Adapter.DoesFileExist(publishedDocumentLocation, contractDocumentationFileName))
            {
                Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentMoverContractDocumentAlreadyPublished,
                    $"Document Mover Requested for contract {childContract.contractNumber} aborted as document {contractDocumentationFileName} already exists in location {publishedDocumentLocation}");
                result = true;
            }
            
            Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentMoverCheckIfContractDocumentAlreadyPublishedEnd, $"Document Mover check for contract document for {childContract.contractNumber} existence in published lcoation completed");
            
            return result;
        }

        private void Validate(contractType contractDocument)
        {
            if (contractDocument == null)
            {
                //Logger.LogInformation(ContractDocumentMergeFailedContractNull, $"{nameof(ContractDocumentManager)} merge failed, Contract is null");
                throw new InvalidOperationException("ContractDocumentManager.MergeContractDocuments called with null contract.");
            }

            if (contractDocument.contracts.Count == 0)
            {
                //Logger.LogInformation(ContractDocumentMergeFailedContractNull, $"{nameof(ContractDocumentManager)} merge failed, Contract has no child contracts");
                throw new InvalidOperationException("ContractDocumentManager.MergeContractDocuments called with no child contracts.");
            }

            if (contractDocument.hierarchyType != hierarchyType.MASTERCONTRACT)
            {
                throw new InvalidOperationException("ContractDocumentManager.MergeContractDocuments called with child contract.");
            }

            if (contractDocument.contracts.Count != 1)
            {
                throw new InvalidOperationException("ContractDocumentManager.MergeContractDocuments must be called with single child contract.");
            }
        }
    }
}
