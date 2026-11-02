namespace SFA.FCT.DocumentsDomain.DocumentGeneration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Aspose.Words;
    using Common;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentCreator;
    using DocumentDefiner;
    using DocumentMerger;
    using DocumentLocationResolver;
    using Framework.Logging.Interfaces;
    using Framework.Logging.NullObjects;
    using Common.Commands;
    using ContractManagement.DataStore.Repositories;

    public class DocumentGenerator : IDocumentGenerator
    {
        private readonly ICorporateContractValidator _contractValidator;
        private readonly IDocumentDefiner _documentDefiner;
        private readonly IDocumentCreator _documentCreator;
        private readonly IDocumentMerger _documentMerger;
        private readonly IDocumentLocationResolver _documentLocationResolver;
        private readonly IFundingTypeFundingPeriodQueryRepository _fundingTypeFundingPeriodQueryRepository;

        public DocumentGenerator(
            ICorporateContractValidator contractValidator,
            IDocumentDefiner documentDefiner,
            IDocumentCreator documentCreator,
            IDocumentMerger documentMerger,
            IDocumentLocationResolver documentLocationResolver,
            IFundingTypeFundingPeriodQueryRepository fundingTypeFundingPeriodQueryRepository)
        {
            _contractValidator = contractValidator;
            _documentDefiner = documentDefiner;
            _documentCreator = documentCreator;
            _documentMerger = documentMerger;
            _documentLocationResolver = documentLocationResolver;
            _fundingTypeFundingPeriodQueryRepository = fundingTypeFundingPeriodQueryRepository;

            Logger = new LoggerNullObject();
        }

        public ILogger Logger { get; set; }

        public DocumentSaveCommand GenerateDocument(string correlationId, contract contract, string masterContractNumber)
        {
            // Guard conditions
            ValidateContract(contract);

            var mergeRequest = new DocumentConvertRequest();
            var document = new byte[0];

            bool documentsRequired = _fundingTypeFundingPeriodQueryRepository.Get(contract.fundingType.fundingTypeCode,
                contract.period.periodType.periodTypeCode + contract.period.period1).DocumentsRequired;

            if (documentsRequired)
            {
                var contractDetails = _documentDefiner.GetContractDetails(contract);

                Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentGeneratorProducing, "Producing documents for correlationId:{0} Ukprn:{1} ContractNumber:{2} Version:v{3}", correlationId, contractDetails.UKPRN, contractDetails.ContractNumber, contractDetails.ContractVersionNumber);

                // Detect Document Parts
                var documentParts = _documentDefiner.GetDocumentParts(masterContractNumber, contract);

                Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentGeneratorPartsCount, "Found {0} document parts to create", documentParts.Length);

                // generate the document
                if (documentParts.Any())
                {
                    int index = 1;
                    foreach (var part in documentParts)
                    {
                        Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentGeneratorUsingTemplate, "Document part {0} using template file {1}:{2} ", index, part.TemplateContainer, part.TemplateFilename);

                        // Create new document
                        Document response = _documentCreator.CreateDocument(part);

                        part.MutateGeneratedDocument?.Invoke(response);

                        if (mergeRequest.DocConvertRequests == null)
                        {
                            mergeRequest.DocConvertRequests = new List<DocumentConvertRequestPart>();
                        }

                        mergeRequest.DocConvertRequests.Add(new DocumentConvertRequestPart()
                        {
                            SequenceNumber = index++,
                            GroupId = part.GroupId,
                            DocPart = response,
                            IsNewPageRequired = part.IsNewPageRequired
                        });
                    }

                    mergeRequest.TargetFile = _documentDefiner.GetTargetFileName(contract);

                    Logger.LogInformation(DocumentsDomainLoggingEventId.DocumentGenreatorTargetDecided, "Target file decided and will be {0}", mergeRequest.TargetFile.Filename);

                    // Merge Documents
                    document = _documentMerger.MergeDocuments(mergeRequest);
                }
                 
                return new DocumentSaveCommand
                {
                    ContractNumber = contractDetails.ContractNumber,
                    ContractVersionNumber = contractDetails.ContractVersionNumber,
                    FCTDocumentDatabus = document,
                    DocumentLocation = _documentLocationResolver.GetLocationOfAppendices(contract),
                    TargetFileName = mergeRequest.TargetFile != null ? mergeRequest.TargetFile.Filename : null,
                    UKPRN = contractDetails.UKPRN.ToString(),
                    Contract = contract,
                    CorrelationId = correlationId
                };
            }

            // otherwise say one is not required
            return null;
        }

        private void ValidateContract(contract contract)
        {
            var validateMessage = _contractValidator.Validate(contract);

            if (!string.IsNullOrEmpty(validateMessage))
            {
                throw new ArgumentException(validateMessage);
            }
        }
    }
}