namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Runtime.Caching;
    using System.Web;
    using System.Xml.Serialization;
    using Common;
    using CrossDomain.Integration.Entities.ExcelUpload;
    using CrossDomain.Integration.Common.Authentication;
    using Framework.Logging.Interfaces;
    using Interfaces;
    

    public class FileValidationFscEnrichment : IFileValidationFscEnrichment
    {
        // Expiration time of the cache in minutes.
        private const double CacheExpiration = 30;
        private const string CacheName = "fscReferenceData";
        private static readonly object CacheLock = new object();

        private readonly ILogger _logger;
        private readonly IContractBulkUploadFileLevelValidation validator;
        private readonly Func<string, string, string, string, FundingConfigurationType> _getReferenceData;

        public FileValidationFscEnrichment(ILogger logger, IContractBulkUploadFileLevelValidation validator)
            : this(logger, validator, null)
        {
        }

        public FileValidationFscEnrichment(
            ILogger logger,
            IContractBulkUploadFileLevelValidation validator,
            Func<string, string, string, string, FundingConfigurationType> getReferenceData)
        {
            _logger = logger;
            this.validator = validator;
            _getReferenceData = getReferenceData ?? GetReferenceData;
        }

        public void Enrich(dataLoadResults dataLoadResults)
        {
            _logger.LogInformation(ContractRequestDomainEventLoggingId.FetchingFscDataForBatch, "FSC query for batch {0}", dataLoadResults.batchId);

            ObjectCache cache = MemoryCache.Default;
            FundingConfigurationType referenceData;
            List<FscDataCache> cacheData = cache[CacheName] as List<FscDataCache>;

            //ContractBulkUploadFileLevelValidation validator = new ContractBulkUploadFileLevelValidation();
            
            if (!validator.FSR_004_ValidateFileStructure(dataLoadResults))
            {
                dataLoadResults.error = validator.Errors.ToArray();
                return;
            }

            ContractBulkUpload bulkUploadData = new ContractBulkUpload(dataLoadResults);

            string period = bulkUploadData.GetCellValue(bulkUploadData.ControlSheet, ContractBulkUpload.ControlSheetPeriod, 0);
            string periodTypeCode = bulkUploadData.GetCellValue(bulkUploadData.ControlSheet, ContractBulkUpload.ControlSheetPeriodTypeCode, 0);
            string fundingTypeCode = bulkUploadData.GetCellValue(bulkUploadData.ControlSheet, ContractBulkUpload.ControlSheetFundingTypeCode, 0);

            if (cacheData == null || !cacheData.Any(c => c.Period == period && c.PeriodType == periodTypeCode && c.FundingType == fundingTypeCode))
            {
                lock (CacheLock)
                {
                    cacheData = cache[CacheName] as List<FscDataCache>;

                    if (cacheData == null || !cacheData.Any(c => c.Period == period && c.PeriodType == periodTypeCode && c.FundingType == fundingTypeCode))
                    {
                        referenceData = _getReferenceData(dataLoadResults.batchId, period, periodTypeCode, fundingTypeCode);

                        // Cache new reference data. 
                        if (cacheData == null)
                        {
                            cacheData = new List<FscDataCache>();
                        }

                        cacheData.Add(new FscDataCache
                        {
                            Period = period,
                            PeriodType = periodTypeCode,
                            FundingType = fundingTypeCode,
                            ReferenceData = referenceData
                        });

                        cache.Set(CacheName, cacheData, new CacheItemPolicy { AbsoluteExpiration = DateTimeOffset.Now.AddMinutes(CacheExpiration) });
                    }
                }
            }

            referenceData = cacheData.First(c => c.Period == period && c.PeriodType == periodTypeCode && c.FundingType == fundingTypeCode).ReferenceData;

            //// Code to remove cache data.
            //// cache.Remove("fscReferenceData");

            dataLoadResults.ReferenceData = new dataLoadResultsReferenceData { FundingConfiguration = referenceData };
        }

        private FundingConfigurationType GetReferenceData(string batchId, string period, string periodTypeCode, string fundingTypeCode)
        {
            using (var client = new WebClient())
            {
                try
                {
                    string requestArguments = string.Format("?period={0}&periodType={1}&fundingType={2}", HttpUtility.UrlEncode(period), HttpUtility.UrlEncode(periodTypeCode), HttpUtility.UrlEncode(fundingTypeCode));

                    _logger.LogInformation(ContractRequestDomainEventLoggingId.FscQueryForBatch, "Query string for batch {0}: '{1}'", batchId, requestArguments);

                    client.Headers[HttpRequestHeader.ContentType] = "application/xml";
                    client.Headers[HttpRequestHeader.Accept] = "application/xml";
                    client.Headers[HttpRequestHeader.Authorization] =
                        $"Bearer {AzureAuthenticator.GetAuthenticationResult("FundingStreamConfig")}";
                    var url = ConfigurationManager.AppSettings["FscEnrichmentUrl"];
                    if (string.IsNullOrWhiteSpace(url))
                    {
                        _logger.LogError(ContractRequestDomainEventLoggingId.ErrorFetchingFscData, "FscEnrichmentUrl configuration is missing or empty for batch {0}", batchId);
                        throw new InvalidOperationException("FscEnrichmentUrl configuration setting is not configured");
                    }
                    var webResponse = client.DownloadString(url + requestArguments);

                    var serialiser = new XmlSerializer(typeof(FundingConfigurationType));

                    using (TextReader tr = new StringReader(webResponse))
                    {
                        return (FundingConfigurationType)serialiser.Deserialize(tr);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ContractRequestDomainEventLoggingId.ErrorFetchingFscData, "Exception when fetching FSC data for batch {0}: {1}", batchId, ex.ToString());
                    throw;
                }
            }
        }
    }
}

