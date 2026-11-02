namespace SFA.FCT.PerformanceManagementDomain.FundingClaimImportEndpoint
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Text;
    using CrossDomain.Integration.Common.Serializers;
    using CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.CorporateSchema._1_0;
    using CrossDomain.Integration.Messages.Commands;
    using DataStore.Models;
    using DataStore.Repositories;
    using Framework.Logging.Interfaces;
    using Logging;
    using NServiceBus;
    using FundingClaim = CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.CorporateSchema._1_0.FundingClaim;
    
    public class FundingClaimsPoller : IHandleMessages<InitiateFundingClaimImportCommand>
    {
        //private readonly IDedsService _dedsService;
        private readonly IBus _bus;
        private readonly ILogger _logger;
        private readonly IFundingClaimRepository _fundingClaimRepository;
        //private readonly IDedsPollerContext _dedsPollerContext;
        private readonly int _pageSize;
        private static DateTime _lastClosedCollectionTime;

        public FundingClaimsPoller( //IDedsService dedsService,
            IBus bus,
            ILogger logger, 
            IFundingClaimRepository fundingClaimRepository)
            //IDedsPollerContext dedsPollerContext)
        {
            _bus = bus;
            _logger = logger;
            _fundingClaimRepository = fundingClaimRepository;
            _pageSize = int.Parse(ConfigurationManager.AppSettings["DcfsFunidngCliaimsRetrievalPageSize"]);
        }

        public void Handle(InitiateFundingClaimImportCommand message)
        {
            _logger.LogInformation(
                PerformanceManagementLoggingId.FundingClaimPollingPollClosedCollectionsCommandArrived,
                $"Funding Claims Import {nameof(InitiateFundingClaimImportCommand)} arrived, starting DEDS import process with values DcfsFundingClaimsRetrievalPageSize: {_pageSize}");
        }

        public void Handle(string IClosedCollectionEventCommand, string placeholder1)//IClosedCollectionEventCommand message)
        {
        }

        public void Handle(string IClosedCollectionEventCommand, string placeholder1, string placeholder2)
        {

            var fundingClaims = new List<string>(); // call deds and return funding claims

            List<DataStore.Models.FundingClaim> dataStoreFundingClaims = 
                fundingClaims
                .Select(DeserializeFundingClaim)
                .Select(FundingClaimTransformer.CorpSchemaFundingClaimToDataStoreFundingClaim)
                .ToList();

            _fundingClaimRepository.AddFundingClaims(dataStoreFundingClaims);
        }

        public void Handle(string IClosedCollectionEventCommand, string placeholder1, string placeholder2, string placeholder3)//SendReportedActualsLoadedCommand message)
        {
        }

        private FundingClaim DeserializeFundingClaim(string serializedFundingClaim)
        {
            return serializedFundingClaim.DeserializeXml<FundingClaim>();
        }
    }
}
