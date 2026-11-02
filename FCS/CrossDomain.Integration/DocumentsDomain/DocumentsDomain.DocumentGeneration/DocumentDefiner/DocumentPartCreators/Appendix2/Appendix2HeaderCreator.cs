namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix2
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using Framework.Logging.NullObjects;
    using Integration;
    using Framework.Logging.Interfaces;

    public class Appendix2HeaderCreator : IDocumentHeaderCreator
    {
        public const string HeaderName = "Appendix2Header";
        private readonly ITemplateRepository _templateRepository;

        public Appendix2HeaderCreator(ITemplateRepository templateRepository)
        {
            _templateRepository = templateRepository;
            Logger = new LoggerNullObject();
        }

        public ILogger Logger { get; set; }

        public bool CanSupplyHeader(string headerName)
        {
            return headerName == HeaderName;
        }

        public Tuple<string, DocumentGenerationRequest> SupplyDocumentGenerationRequest(string masterContractNumber, contractType contract, string templateContainer)
        {
            var request = new DocumentGenerationRequest()
            {
                TemplateContainer = templateContainer,
                // Changed for Nullable start and end date
                TemplateFilename = _templateRepository.GetNameOfTemplateActiveOnDate(templateContainer, string.Format(Common.Constants.TemplateForAppendix2_Header, contract.fundingType.fundingTypeCode), contract.startDate.GetValueOrDefault()),
                MergeData = new DocumentGenerationRequestMergeData()
                {
                    MergeFields = new List<MergeFieldType>()
                    {
                        new MergeFieldType("MasterContractRef", masterContractNumber)
                    }
                }
            };

            return new Tuple<string, DocumentGenerationRequest>(Common.Constants.Position_Appendix2_HEADER, request);
        }
    }
}
