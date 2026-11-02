namespace SFA.FCT.DocumentsDomain.DocumentGeneration.ContractDocumentMerger
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Text.RegularExpressions;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DocumentDefiner;
    using DocumentLocationResolver;
    using Framework.Logging.Interfaces;
    using Framework.Logging.NullObjects;
    using Common.Exceptions;
    using static CrossDomain.Integration.Common.DocumentMergeReasonForError;
    using static Common.DocumentsDomainLoggingEventId;

    public class ContractDocumentManager : IContractDocumentManager
    {
        private readonly IDocumentDefiner _documentDefiner;
        private readonly IDocumentLocationResolver _documentLocationResolver;
        private readonly IOffice365Adapter _officeAdapter;
        private readonly IPdfMerger _pdfMerger;
        private const string FileExtension = ".pdf";

        public ILogger Logger { get; set; }

        public ContractDocumentManager(
              IDocumentDefiner documentDefiner,
              IDocumentLocationResolver documentlocationResolver,
              IOffice365Adapter officeAdapter,
              IPdfMerger pdfMerger)
        {
            _documentDefiner = documentDefiner;
            _documentLocationResolver = documentlocationResolver;
            _officeAdapter = officeAdapter;
            _pdfMerger = pdfMerger;
            Logger = new LoggerNullObject();
        }

        public void MergeContractDocuments(contract contractDocument)
        {
            Validate(contractDocument);

            Logger.LogInformation(ContractDocumentMergerMerging, $"{nameof(ContractDocumentManager)} merging contract:{contractDocument.contracts[0].contractNumber}");

            var fileName = _documentDefiner.GetTargetFileName(contractDocument.contracts.First()).Filename;
            var tncFilter= _documentDefiner.GetTnCFileNameFilter(contractDocument.contracts.First());
            var appendicesFileLocation = _documentLocationResolver.GetLocationOfAppendices(contractDocument.contracts.First());
            var tsAndCsFileLocation = _documentLocationResolver.GetLocationOfTermsAndConditions(contractDocument.contracts.First());
            var mergedDocumentLocation = _documentLocationResolver.GetLocationOfMergedDocument(contractDocument.contracts.First());

            try
            {
                var documentsToMerge = GetAppendices(fileName, appendicesFileLocation).Concat(GetTsAndCs(tncFilter, tsAndCsFileLocation,contractDocument.contracts.First()));
                var orderedDocs = OrderDocuments(documentsToMerge, contractDocument.contracts.First());
                var targetPdf = _pdfMerger.MergeDocumentation(orderedDocs);

                _officeAdapter.UploadFileWithOverwrite(fileName, targetPdf, mergedDocumentLocation);

                Logger.LogInformation(ContractDocumentMergeComplete, $"{nameof(ContractDocumentManager)} merging finished for contract:{contractDocument.contracts[0].contractNumber}");
            }
            catch (Exception ex)
            {
                Logger.LogError(ContractDocumentMergeError, $"{nameof(ContractDocumentManager)} merging failed for contract:{contractDocument.contracts[0].contractNumber} because {ex.Message}");
                throw;
            }
        }

        private void Validate(contractType contractDocument)
        {
            if (contractDocument == null)
            {
                Logger.LogInformation(ContractDocumentMergeFailedContractNull, $"{nameof(ContractDocumentManager)} merge failed, Contract is null");
                throw new InvalidOperationException("ContractDocumentManager.MergeContractDocuments called with null contract.");
            }

            if (contractDocument.contracts.Count == 0)
            {
                Logger.LogInformation(ContractDocumentMergeFailedContractNull, $"{nameof(ContractDocumentManager)} merge failed, Contract has no child contracts");
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

        private Dictionary<string, byte[]> GetAppendices(string fileName, string appendicesFileLocation)
        {
            var appendicesFileName = fileName.Replace(FileExtension, "_50.pdf");

            try
            {
                return new Dictionary<string, byte[]>
                {
                    {appendicesFileName, _officeAdapter.GetFileContents(fileName, appendicesFileLocation)}
                };
            }
            catch (Exception ex)
            {
                Logger.LogError(ContractDocumentMergeError, $"Error accessing appendices file: {fileName}", ex);
                throw new AppendicesNotFoundException($"Error accessing appendices file: {fileName}", ex);
            }
        }

        private Dictionary<string, byte[]> GetTsAndCs(string tncFileFilter, string tsAndCsFileLocation, contractType contract )
        {
            var result = _officeAdapter.GetFilesByFileNameStartText(tsAndCsFileLocation, tncFileFilter);

            if (!result.Any())
                throw new DocumentMergeException(DocumentMergeFormattedErrorMessage(DocumentNotUploaded, contract.contractor.ukprn.ToString(),contract.contractNumber));

            return result;
        }

        private static List<KeyValuePair<int, byte[]>> OrderDocuments(IEnumerable<KeyValuePair<string, byte[]>> documentsToMerge, contractType contract)
        {
            var dictionary = new Dictionary<int, byte[]>();

            try
            {
                foreach (var doc in documentsToMerge)
                {
                    var fileName = Path.GetFileNameWithoutExtension(doc.Key);
                    //// ReSharper disable once InvertIf
                    if (!string.IsNullOrEmpty(fileName))
                    {
                        var match = Regex.Match(fileName, @"\d+$");
                        var number = int.Parse(match.Success ? match.Value : string.Empty);
                        dictionary.Add(number, doc.Value);
                    }
                }
            }
            catch (ArgumentException ex)
            {
                throw new DocumentMergeException(DocumentMergeFormattedErrorMessage(DocumentIncorrectOrderNumber50, contract.contractor.ukprn.ToString(), contract.contractNumber), ex);
            }

            return dictionary.OrderBy(x => x.Key).ToList();
        }
    }
}
