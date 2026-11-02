namespace AllocationDeliveryDomain.Endpoint.ActualsPull.Adapters
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Net.Http;
    using System.Threading.Tasks;
    using Extensions;
    using Infrastructure;
    using Newtonsoft.Json;
    using Polly;
    using DTOs = AllocationDelivery.Messages.DTOs;
    using Model = SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    public class DcAdapter : IDcAdapter
    {
        private static readonly string Url = ConfigurationManager.AppSettings["DCT:Url"];
        private static readonly string OauthClientId = ConfigurationManager.AppSettings["DCT:Oauth:ClientId"];
        private static readonly string OauthScope = ConfigurationManager.AppSettings["DCT:Oauth:Scope"];
        private static readonly string OauthClientSecret = ConfigurationManager.AppSettings["DCT:Oauth:ClientSecret"];
        private static readonly string OauthTenant = ConfigurationManager.AppSettings["DCT:Oauth:Tenant"];
        private readonly IHttpService _httpService;
        private readonly IOAuthAccessTokenFactory _authAccessTokenFactory;

        public DcAdapter(IHttpService httpService, IOAuthAccessTokenFactory authAccessTokenFactory)
        {
            _httpService = httpService;
            _authAccessTokenFactory = authAccessTokenFactory;
        }

        public async Task<IReadOnlyCollection<DTOs.ClosedCollection>> GetClosedCollectionsSince(DateTime dateFrom)
        {
            string iso8601FormatDate = dateFrom.ToString("O");

            string content = await GetJsonArrayFromRestEndpoint($"{Url}/api/v1.0/summarised-actuals/collections?closedCollectionsSince={iso8601FormatDate}&pageSize={int.MaxValue}") // cautious but default page size is 20
                .ConfigureAwait(false);

            IReadOnlyCollection<CollectionReturnDto> closedCollections = JsonConvert.DeserializeObject<IReadOnlyCollection<CollectionReturnDto>>(content);

            return closedCollections
                .Select(cc => new DTOs.ClosedCollection
                {
                    CollectionType = cc.collectionType,
                    CollectionReturnCode = cc.collectionReturnCode,
                    ClosedTime = cc.dateTime,
                    TotalRowCount = cc.TotalItems
                })
                .ToList();
        }

        public async Task<IReadOnlyCollection<Model.SummarisedActual>> GetClosedCollectionsPage(string collectionType, string collectionReturnCode, int pageNumber, int pageSize)
        {
            string content = await GetJsonArrayFromRestEndpoint($"{Url}/api/v1.0/summarised-actuals/{collectionReturnCode}/{collectionType}?pageNumber={pageNumber}&pageSize={pageSize}")
                .ConfigureAwait(false);

            IReadOnlyCollection<SummarisedActualDto> summarisedActuals = JsonConvert.DeserializeObject<IReadOnlyCollection<SummarisedActualDto>>(content);

            return summarisedActuals
                .Select(sa => new Model.SummarisedActual
                {
                    CollectionType = sa.collectionType,
                    CollectionReturnCode = sa.collectionReturnCode,
                    OrganisationId = sa.organisationId,
                    FundingStreamPeriodCode = sa.fundingStreamPeriodCode,
                    UopCode = sa.uopCode,
                    ContractAllocationNumber = sa.contractAllocationNumber,
                    Period = sa.period,
                    DeliverableCode = sa.deliverableCode,
                    ActualVolume = sa.actualVolume,
                    ActualValue = sa.actualValue,
                    DataCollectionsId = sa.id
                })
                .ToList();
        }

        private async Task<string> GetJsonArrayFromRestEndpoint(string requestUri)
        {
            return await Policy
                .Handle<Exception>(ex =>
                {
                    if (ex is HttpRequestException && ex.Message.Contains("Unauthorized"))
                    {
                        _authAccessTokenFactory.ClearCache(OauthClientId);
                    }

                    return true;
                })
                .WaitAndRetryAsync(5, _ => TimeSpan.FromSeconds(3))
                .ExecuteAsync(async () =>
                {
                    string authorizationToken = _authAccessTokenFactory.GetAccessToken(
                        clientId: DcAdapter.OauthClientId, clientSecret: DcAdapter.OauthClientSecret,
                        scope: DcAdapter.OauthScope, tenant: DcAdapter.OauthTenant);

                    string content = await _httpService.GetAsync(authorizationToken, requestUri)
                        .ConfigureAwait(false);

                    return content.GetValueOrDefault("[]");
                }).ConfigureAwait(false);
        }

        private class CollectionReturnDto
        {
            public string collectionType;
            public string collectionReturnCode;
            public DateTime dateTime;
            public int TotalItems;
        }

        private class SummarisedActualDto
        {
            public int id;
            public string collectionReturnCode;
            public string organisationId;
            public int period;
            public string fundingStreamPeriodCode;
            public string collectionType;
            public string contractAllocationNumber;
            public string uopCode;
            public int deliverableCode;
            public int? actualVolume;
            public decimal actualValue;
        }
    }
}