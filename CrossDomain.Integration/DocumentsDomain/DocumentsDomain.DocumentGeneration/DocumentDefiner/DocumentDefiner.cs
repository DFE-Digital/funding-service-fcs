namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using Framework.Logging.NullObjects;
    using Framework.Logging.Interfaces;

    public class DocumentDefiner : IDocumentDefiner
    {
        private readonly IDocumentPartFinder _partFinder;

        public DocumentDefiner(IDocumentPartFinder partFinder)
        {
            _partFinder = partFinder;
            Logger = new LoggerNullObject();
        }

        public ILogger Logger { get; set; }

        public DocumentGenerationRequest[] GetDocumentParts(string masterContractNumber, contractType contract)
        {
            IDictionary<string, DocumentGenerationRequest> partsRequiredDictionary = new Dictionary<string, DocumentGenerationRequest>();
            var headerDocumentNameList = new List<string>();

            var templateContainer = ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"];

            foreach (var creator in _partFinder.GetDocumentPartCreators(contract))
            {
                Logger.LogVerbose("DocumentDefiner asking {0} if document is requried", creator.GetType().Name);
                if (creator.IsDocumentPartRequired(contract))
                {
                    Logger.LogVerbose("DocumentDefiner calling {0} to supply document parts", creator.GetType().Name);

                    var partDictionary = creator.SupplyDocumentGenerationRequest(masterContractNumber, contract, templateContainer);

                    Logger.LogVerbose("{0} returned {1} documents parts", creator.GetType().Name, partsRequiredDictionary.Count);

                    var partsDictionary = partsRequiredDictionary.Concat(partDictionary);
                    partsRequiredDictionary = partsDictionary.ToDictionary(e => e.Key, e => e.Value);

                    if (creator.IsHeaderDocumentRequired)
                    {
                        headerDocumentNameList.Add(creator.RequiredHeaderDocumentName);
                    }
                }
            }

            foreach (var headerName in headerDocumentNameList.Distinct())
            {
                foreach (IDocumentHeaderCreator creator in _partFinder.GetDocumentHeaderCreators())
                {
                    if (creator.CanSupplyHeader(headerName))
                    {
                        Logger.LogVerbose("Adding header {0} to the document", headerName);
                        var header = creator.SupplyDocumentGenerationRequest(masterContractNumber, contract, templateContainer);
                        partsRequiredDictionary.Add(header.Item1, header.Item2);
                    }
                }
            }

            return (from entry in partsRequiredDictionary orderby entry.Key select entry.Value).ToArray();
        }

        public FctFile GetTargetFileName(contractType childContract)
        {
            var details = GetContractDetails(childContract);

            var fctfile = new FctFile()
            {
                Filename = $"{details.UKPRN}_{details.ContractNumber}_v{details.ContractVersionNumber}.pdf",
                FileContainer = ConfigurationManager.AppSettings["DocumentGeneration.TargetContainer"]
            };

            return fctfile;
        }

        public string GetTnCFileNameFilter(contractType childContract)
        {
            var details = GetContractDetails(childContract);
            return $"{details.UKPRN}_{details.ContractNumber}";
        }

        public ContractIdentificationDetails GetContractDetails(contractType childContract)
        {
            if (childContract.hierarchyType != hierarchyType.CONTRACT)
            {
                throw new InvalidOperationException("DocumentDefiner.GetContractDetails not called with child contract.");
            }

            return new ContractIdentificationDetails
            {
                UKPRN = childContract.contractor.ukprn,
                ContractNumber = childContract.contractNumber,
                ContractVersionNumber = childContract.contractVersionNumber
            };
        }
    }
}
