namespace OrganisationDomain.Implementation.BusinessLogic
{
    using System;
    using System.Collections.Generic;
    using System.ServiceModel;
    using Converters;
    using Integration.Entities;
    using SFA.FCT.Framework.Logging.Interfaces;
    using OrganisationDomain.Common;

    public class CpdsSummaryRetriever : ICpdsSummaryRetriever
    {
        private readonly GatewayServiceContract _gatewayServiceContract;
        private readonly ICpdsProviderConverter _cpdsProviderConverter;
        private readonly ILogger _logger;

        public CpdsSummaryRetriever(GatewayServiceContract gatewayServiceContract, ICpdsProviderConverter cpdsProviderConverter, ILogger logger)
        {
            _gatewayServiceContract = gatewayServiceContract;
            _cpdsProviderConverter = cpdsProviderConverter;
            _logger = logger;
        }

        public List<ProviderSequence> RetrieveSummary()
        {
            var req = new GProvByNameRequest();
            GProvByNameResponse resp;
            try
            {
                resp = _gatewayServiceContract.GetProviderSummaryByName(req);
            }
            catch (Exception e) 
            {   
                _logger.LogError(OrganisationDomainEventLoggingId.CpdsSummaryRetrieverError,  "Contact with (external) CPDS has failed. Error occurred trying to call GetProviderSummaryByName. {0}", e.ToString());
                throw;
            }

            _cpdsProviderConverter.CpdsXml = resp.RawCPDSResponse;
            return _cpdsProviderConverter.ConvertXmlToProviders();
        }
    }
}
