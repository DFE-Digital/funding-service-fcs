using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
using SFA.FCT.CrossDomain.Integration.Entities;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Runtime.Caching;
using System.Data;
using System.IO;
using System.Net;
using System.Web;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Net.Http;
using System.Security.Authentication;
using System.Threading;
using Microsoft.Extensions.Configuration;
using System.Xml.Serialization;

namespace FundingAllocation.Services
{
    public class ContractDeliverableEnricher : IContractDeliverableEnricher
    {
        private const string FscDeliverableDataCacheName = "fscDeliverableData";
        private const double CacheExpiration = 30;
        private readonly ObjectCache _cache = MemoryCache.Default;
        private readonly List<string> fundingstreamToAddAggregation = new List<string> { "ASF" };
        private readonly IConfigurationRoot _configuration;

        public ContractDeliverableEnricher(IConfigurationRoot configuration)
        {
            _configuration = configuration;
        }

        public void Enrich(ExtendedContractType masterContract)
        {
            foreach (var contract in masterContract.contracts)
            {
                foreach (var contractAllocation in contract.contractAllocations)
                {
                    foreach (string fspcode in fundingstreamToAddAggregation)
                    {
                        if (contractAllocation.fundingStream.fundingStreamCode.Contains(fspcode))
                        {
                            EnrichContractAllocation(contractAllocation, contract);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Internal method to update the calculated deliverable structure with the correct Period Name and Display Order
        /// </summary>
        internal static void UpdateDeliverableStructure(List<contractDeliverablesTypeContractDeliverable> deliverables)
        {
            deliverables.ForEach(d => d.contractDeliverablePeriods.ForEach(p =>
            {
                p.periodName = GetPeriodName(p.period, p.year);
                p.displayOrder = GetDisplayOrder(p.period, p.year);
            }));
        }

        /// <summary>
        /// Internal Static method to return the period name from a datetime.
        /// </summary>
        /// <param name="date">A datetime</param>
        /// <returns>A string in the format MMM-yyyy (e.g. Aug-2014)</returns>
        internal static string GetPeriodName(DateTime date)
        {
            var returnString = new StringBuilder();

            return
                returnString.Append(date.ToString("MMM", CultureInfo.InvariantCulture))
                    .Append("-")
                    .Append(date.ToString("yy"))
                    .ToString();
        }

        /// <summary>
        /// Internal Static Overloaded method to return the period name from a year and a period.
        /// </summary>
        /// <param name="period">An integer representing the period (e.g. August = 8)</param>
        /// <param name="year">The four digit year</param>
        /// <returns>A string in the format MMM-yyyy (e.g. Aug-2014)</returns>
        internal static string GetPeriodName(int period, int year)
        {
            var date = new DateTime(year, period, 1);

            return GetPeriodName(date);
        }

        /// <summary>
        /// Internal Static method to get a display order based on a datetime
        /// </summary>
        /// <param name="date">A datetime</param>
        /// <returns>An integer formatted as yyyyMM (e.g. 15th June 2014 -> 201406)</returns>
        internal static int GetDisplayOrder(DateTime date)
        {
            var returnString = new StringBuilder();

            return
                int.Parse(
                    returnString.Append(date.Year).Append(date.ToString("MM", CultureInfo.InvariantCulture)).ToString());
        }

        /// <summary>
        /// Internal Static method to get a display order based on a year and period
        /// </summary>
        /// <param name="period">An integer representing the period (e.g. August = 8)</param>
        /// <param name="year">The four digit year</param>
        /// <returns>An integer formatted as yyyyMM (e.g. 15th June 2014 -> 201406)</returns>
        internal static int GetDisplayOrder(int period, int year)
        {
            var date = new DateTime(year, period, 1);

            return GetDisplayOrder(date);
        }

        private void EnrichContractAllocation(contractAllocationsContractAllocation contractAllocation, contractType contract)
        {
            SetPlannedValueOnDeliverablePeriods(contractAllocation.contractDeliverables);

            // Setup planned values in existing deliverables.
            SetPlannedValueAndVolumeInDeliverables(contractAllocation.contractDeliverables);

            // Changed for Nullable start and end date
            DateTime startDate = contractAllocation.startDate != DateTime.MinValue ? contractAllocation.startDate : contract.startDate.GetValueOrDefault();
            DateTime? endDate = contractAllocation.endDate != DateTime.MinValue ? contractAllocation.endDate : contract.endDate.GetValueOrDefault();

            // Invoke the FSC web service to retrieve the deliverable structure configuration data
            // (Pass in the funding stream period data for this contract)
            FSCDeliverableStructureDefinitionResponse deliverableStructure = GetDeliverableStructure(contractAllocation.fundingStreamPeriodCode);

            // Remove deliverables from existing contract that do not exist on FSC
            contractAllocation.contractDeliverables = RemoveMonitoringDeliverablesFromExistingContract(contractAllocation, deliverableStructure.DeliverableStructureList);

            // Retrieve a list of deliverable structures for all the deliverable codes which DON'T exist in the Contract Allocation
            var allocation = contractAllocation;

            var delConfigs = deliverableStructure.DeliverableStructureList
                .Where(m => m.Settings.Any(s => s.SettingCode.Contains("mandatory") && s.SettingValue == "Mandatory"))
                .OrderByDescending(d => d.DeliverableCode);

            foreach (var delConfig in delConfigs)
            {
                var alreadyExists = allocation.contractDeliverables.Where(i => i.deliverable.deliverableCode == delConfig.DeliverableCode).ToList();

                if (!alreadyExists.Any())
                {
                    // Add a new deliverable to the contract - decide whether or not the deliverable is an aggregate or not here.
                    if (deliverableStructure.DeliverableStructureList.Any(
                        m =>
                            m.ParentDetails.ParentRelationship != null &&
                            (m.ParentDetails.ParentDeliverableCode == delConfig.DeliverableCode &&
                             m.ParentDetails.ParentRelationship.Value ==
                             DeliverableParentRelationshipType.Aggregate)))
                    {
                        // Create aggregate deliverable 
                        CreateAggregateDeliverable(contractAllocation, startDate, endDate, delConfig, deliverableStructure.DeliverableStructureList);
                    }
                    else
                    {
                        // This DC has no children so empty row
                        CreateEmptyMandatoryDeliverable(contractAllocation, startDate, endDate, delConfig);
                    }
                }
                else
                {
                    if (deliverableStructure.DeliverableStructureList.Any(
                        m => m.ParentDetails.ParentRelationship != null && (m.ParentDetails.ParentDeliverableCode == delConfig.DeliverableCode &&
                                                                            m.ParentDetails.ParentRelationship.Value == DeliverableParentRelationshipType.Aggregate)))
                    {
                        // Update Aggregate Deliverable 
                        UpdateAggregateDeliverable(contractAllocation, alreadyExists.Single(), startDate, endDate, delConfig, deliverableStructure.DeliverableStructureList);
                    }
                }
            }

            //Update deliverable Name and display order at contract deliverable level
            UpdateDeliverableNameAndDisplayOrderAtContractDeliverablesLevel(contractAllocation.contractDeliverables,
                deliverableStructure);

            // Update deliverable periods with Display Order and Period Name
            UpdateDeliverableStructure(contractAllocation.contractDeliverables);

            TransformDeliverablesToHierarchicalStructure(contractAllocation, deliverableStructure);
        }

        private void SetPlannedValueOnDeliverablePeriods(List<contractDeliverablesTypeContractDeliverable> contractDeliverables)
        {
            contractDeliverables.ForEach(d => d.contractDeliverablePeriods.ForEach(dp => dp.CalculateAndSetPlannedValue()));
        }

        private void UpdateDeliverableNameAndDisplayOrderAtContractDeliverablesLevel(List<contractDeliverablesTypeContractDeliverable> contractDeliverables, FSCDeliverableStructureDefinitionResponse deliverableStructure)
        {
            foreach (var cd in contractDeliverables)
            {
                var ds =
                    deliverableStructure.DeliverableStructureList.FirstOrDefault(
                        m => m.DeliverableCode == cd.deliverable.deliverableCode);

                if (ds != null)
                {
                    cd.deliverable.deliverableName = ds.DeliverableName;
                    cd.DisplayOrder = int.Parse(ds.Settings.First(s => s.SettingCode == "displayorder").SettingValue);
                }

                if (cd.contractDeliverables.Any())
                {
                    UpdateDeliverableNameAndDisplayOrderAtContractDeliverablesLevel(cd.contractDeliverables,
                        deliverableStructure);
                }
            }
        }
        private void TransformDeliverablesToHierarchicalStructure(contractAllocationsContractAllocation contractAllocation, FSCDeliverableStructureDefinitionResponse deliverableStructure)
        {
            // Add parent deliverable Codes from funding stream config structure to each deliverable
            contractAllocation.contractDeliverables.ForEach(
                d =>
                {
                    var parent = deliverableStructure.DeliverableStructureList.SingleOrDefault(
                        x => x.DeliverableCode == d.deliverable.deliverableCode);

                    if (parent != null)
                    {
                        d.ParentDeliverableCode = parent.ParentDetails.ParentDeliverableCode;
                    }
                });

            // assemble the hierarchy and replace the flat list
            contractAllocation.contractDeliverables = contractAllocation.AssembleChildDeliverables(contractAllocation.contractDeliverables, null);
        }

        private void SetPlannedValueAndVolumeInDeliverables(List<contractDeliverablesTypeContractDeliverable> deliverables)
        {
            foreach (var deliverable in deliverables)
            {
                deliverable.plannedValue = deliverable.GetDeliverableValue();
                deliverable.plannedVolume = deliverable.AggregatedPlannedVolume;
            }
        }

        private List<contractDeliverablePeriodsTypeContractDeliverablePeriod> CreateEmptyDeliverablePeriods(DateTime startDate, DateTime? endDate)
        {
            List<contractDeliverablePeriodsTypeContractDeliverablePeriod> periods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>();

            if (endDate == null)
            {
                periods.Add(new contractDeliverablePeriodsTypeContractDeliverablePeriod
                {
                    aggregate = false,
                    year = startDate.Year,
                    period = startDate.Month,
                    periodType = new periodTypeType
                    {
                        periodTypeCode = periodTypeCodeType.CM,
                        periodTypeName = periodTypeNameType.CALENDARMONTH
                    }
                });
            }
            else
            {
                periods.AddRange(CreateEmptyDeliverablePeriodForEachMonth(startDate, endDate.Value));
            }

            return periods;
        }

        private List<contractDeliverablePeriodsTypeContractDeliverablePeriod> CreateEmptyDeliverablePeriodForEachMonth(DateTime startDate, DateTime endDate)
        {
            List<contractDeliverablePeriodsTypeContractDeliverablePeriod> periods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>();

            // NOTE: Looping through inclusive months only, ignore days (so 20/12/15 to 02/01/16 should produce two periods)
            for (var date = new DateTime(startDate.Year, startDate.Month, 1); date <= endDate; date = date.AddMonths(1))
            {
                // Build the list of periods
                contractDeliverablePeriodsTypeContractDeliverablePeriod period = new contractDeliverablePeriodsTypeContractDeliverablePeriod()
                {
                    aggregate = false,
                    year = date.Year,
                    period = date.Month,
                    periodType = new periodTypeType()
                    {
                        periodTypeCode = periodTypeCodeType.CM,
                        periodTypeName = periodTypeNameType.CALENDARMONTH
                    }
                };

                periods.Add(period);
            }

            return periods;
        }

        private void CreateEmptyMandatoryDeliverable(contractAllocationsContractAllocation contractAllocation, DateTime startDate, DateTime? endDate, DeliverableConfigurationType deliverableConfig)
        {
            // Create new deliverable row
            contractAllocation.contractDeliverables.Add(new contractDeliverablesTypeContractDeliverable()
            {
                plannedValue = 0,
                deliverable = new deliverableType()
                {
                    deliverableCode = deliverableConfig.DeliverableCode,
                    deliverableName = deliverableConfig.DeliverableName,
                    fundingStreamCode = contractAllocation.fundingStream.fundingStreamCode
                },
                deliverableDescription = deliverableConfig.DeliverableName,
                contractDeliverablePeriods = CreateEmptyDeliverablePeriods(startDate, endDate)
            });
        }

        private void PopulateProfileDeliverables(DeliverableConfigurationType deliverableConfig, List<DeliverableConfigurationType> deliverablesConfig, ref List<DeliverableConfigurationType> profileDeliverables)
        {
            if (profileDeliverables == null)
            {
                profileDeliverables = new List<DeliverableConfigurationType>();
            }

            var candidateDeliverables = deliverablesConfig.Where(m => m.ParentDetails.ParentDeliverableCode == deliverableConfig.DeliverableCode
                                                                      && m.ParentDetails.ParentRelationship == DeliverableParentRelationshipType.Aggregate);

            foreach (DeliverableConfigurationType candidateDeliverable in candidateDeliverables)
            {
                // copy any profile deliverables
                if (candidateDeliverable.Settings.Any(m => m.SettingCode.Contains("allowprofile") && m.SettingValue == "Yes"))
                {
                    profileDeliverables.Add(candidateDeliverable);
                }
                else
                {
                    // Recurse for the aggregate line
                    PopulateProfileDeliverables(candidateDeliverable, deliverablesConfig, ref profileDeliverables);
                }
            }
        }

        private void CreateAggregateDeliverable(contractAllocationsContractAllocation contractAllocation, DateTime startDate, DateTime? endDate, DeliverableConfigurationType deliverableConfig, List<DeliverableConfigurationType> deliverablesConfig)
        {
            // need to get all deliverables that make up the aggregate
            List<DeliverableConfigurationType> candidateDeliverables = null;
            PopulateProfileDeliverables(deliverableConfig, deliverablesConfig, ref candidateDeliverables);

            var aggregateDeliverable = new contractDeliverablesTypeContractDeliverable
            {
                deliverable = new deliverableType()
                {
                    deliverableCode = deliverableConfig.DeliverableCode,
                    deliverableName = deliverableConfig.DeliverableName,
                    fundingStreamCode = contractAllocation.fundingStream.fundingStreamCode,
                },
                deliverableDescription = deliverableConfig.DeliverableName,
                plannedValue = contractAllocation
                    .contractDeliverables
                    .Where(m => candidateDeliverables.Any(a => a.DeliverableCode == m.deliverable.deliverableCode))
                    .Sum(d => d.plannedValue),
                contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>()
            };

            // NOTE: Looping through inclusive months only, ignore days (so 20/12/15 to 02/01/16 should produce two periods)
            for (var date = new DateTime(startDate.Year, startDate.Month, 1); date <= endDate; date = date.AddMonths(1))
            {
                // Build the list of periods
                var period = new contractDeliverablePeriodsTypeContractDeliverablePeriod()
                {
                    aggregate = true,
                    year = date.Year,
                    period = date.Month,
                    periodType = new periodTypeType()
                    {
                        periodTypeCode = periodTypeCodeType.CM,
                        periodTypeName = periodTypeNameType.CALENDARMONTH
                    },
                    plannedValue =
                        contractAllocation
                            .contractDeliverables
                            .Where(m => candidateDeliverables.Any(a => a.DeliverableCode == m.deliverable.deliverableCode))
                            .SelectMany(n => n.contractDeliverablePeriods)
                            .Where(o => o.period == date.Month && o.year == date.Year)
                            .Sum(q => q.GetDeliverablePeriodValue(false))
                };

                aggregateDeliverable.contractDeliverablePeriods.Add(period);
            }

            contractAllocation.contractDeliverables.Add(aggregateDeliverable);
        }

        private void UpdateAggregateDeliverable(contractAllocationsContractAllocation contractAllocation, contractDeliverablesTypeContractDeliverable aggregateDeliverable, DateTime startDate, DateTime? endDate, DeliverableConfigurationType deliverableConfig, List<DeliverableConfigurationType> deliverablesConfig)
        {
            // need to get all deliverables that make up the aggregate
            List<DeliverableConfigurationType> candidateDeliverables = null;
            PopulateProfileDeliverables(deliverableConfig, deliverablesConfig, ref candidateDeliverables);

            aggregateDeliverable.plannedValue = contractAllocation
                .contractDeliverables
                .Where(m => candidateDeliverables.Any(a => a.DeliverableCode == m.deliverable.deliverableCode))
                .Sum(d => d.plannedValue);

            // Clear the existing aggregate deliverable list
            aggregateDeliverable.contractDeliverablePeriods.Clear();

            // NOTE: Looping through inclusive months only, ignore days (so 20/12/15 to 02/01/16 should produce two periods)
            for (var date = new DateTime(startDate.Year, startDate.Month, 1); date <= endDate; date = date.AddMonths(1))
            {
                // Build the list of periods
                var period = new contractDeliverablePeriodsTypeContractDeliverablePeriod()
                {
                    aggregate = true,
                    year = date.Year,
                    period = date.Month,
                    periodType = new periodTypeType()
                    {
                        periodTypeCode = periodTypeCodeType.CM,
                        periodTypeName = periodTypeNameType.CALENDARMONTH
                    },
                    plannedValue =
                        contractAllocation
                            .contractDeliverables
                            .Where(m => candidateDeliverables.Any(a => a.DeliverableCode == m.deliverable.deliverableCode))
                            .SelectMany(n => n.contractDeliverablePeriods)
                            .Where(o => o.period == date.Month && o.year == date.Year)
                            .Sum(q => q.GetDeliverablePeriodValue(false))
                };

                aggregateDeliverable.contractDeliverablePeriods.Add(period);
            }
        }

        private FSCDeliverableStructureDefinitionResponse GetDeliverableStructure(string fundingStreamPeriodCode)
        {

            var cacheData = GetCacheData();

            FSCDeliverableStructureDefinitionResponse deliverableStructure;
            if (!cacheData.ContainsKey(fundingStreamPeriodCode))
            {
                // Get filtered data
                deliverableStructure = FilterProfileDeliverableStructure(
                    GetFullDeliverableStructure(fundingStreamPeriodCode));

                cacheData.Add(fundingStreamPeriodCode, deliverableStructure);
                _cache.Set(
                    FscDeliverableDataCacheName,
                    cacheData,
                    new CacheItemPolicy
                    {
                        AbsoluteExpiration = DateTimeOffset.Now.AddMinutes(CacheExpiration)
                    });
            }
            else
            {
                deliverableStructure = cacheData.FirstOrDefault(d => d.Key == fundingStreamPeriodCode).Value;
            }

            return deliverableStructure;
        }

        private IDictionary<string, FSCDeliverableStructureDefinitionResponse> GetCacheData()
        {
            IDictionary<string, FSCDeliverableStructureDefinitionResponse> cacheData =
                _cache[FscDeliverableDataCacheName] as IDictionary<string, FSCDeliverableStructureDefinitionResponse>;

            if (cacheData == null)
            {
                cacheData = new Dictionary<string, FSCDeliverableStructureDefinitionResponse>();
            }

            return cacheData;
        }

        private List<contractDeliverablesTypeContractDeliverable> RemoveMonitoringDeliverablesFromExistingContract(contractAllocationsContractAllocation allocation, List<DeliverableConfigurationType> deliverableStructureList)
        {
            return allocation.contractDeliverables
                .Where(d => deliverableStructureList.Any(c => c.DeliverableCode.Equals(d.deliverable.deliverableCode))).ToList();
        }

        public static FSCDeliverableStructureDefinitionResponse FilterProfileDeliverableStructure(FSCDeliverableStructureDefinitionResponse deliverableStructure)
        {
            var itemsToKeep = new List<DeliverableConfigurationType>();

            DetermineItemsToKeep(deliverableStructure, itemsToKeep);

            // Now put back in order, incase it is important
            deliverableStructure.DeliverableStructureList.Clear();

            deliverableStructure.DeliverableStructureList.AddRange(itemsToKeep.OrderBy(d => d.DeliverableCode));

            return deliverableStructure;
        }
        private static void DetermineItemsToKeep(FSCDeliverableStructureDefinitionResponse deliverableStructure, List<DeliverableConfigurationType> itemsToKeep)
        {
            foreach (var deliverable in deliverableStructure.DeliverableStructureList)
            {
                // copy any profile deliverables
                if (deliverable.Settings.Any(m => m.SettingCode.Contains("allowprofile") && m.SettingValue == "Yes"))
                {
                    itemsToKeep.Add(deliverable);

                    IterateParent(deliverable, deliverableStructure, itemsToKeep);
                }
            }
        }

        private static void IterateParent(DeliverableConfigurationType deliverable, FSCDeliverableStructureDefinitionResponse deliverableStructure, List<DeliverableConfigurationType> itemsToKeep)
        {
            // make this recursive
            if (deliverable.ParentDetails != null && deliverable.ParentDetails.ParentDeliverableCode != null)
            {
                foreach (var parent in deliverableStructure.DeliverableStructureList.Where(d => d.DeliverableCode.Equals(deliverable.ParentDetails.ParentDeliverableCode)))
                {
                    if (!itemsToKeep.Contains(parent))
                    {
                        itemsToKeep.Add(parent);

                        IterateParent(parent, deliverableStructure, itemsToKeep);
                    }
                }
            }
        }

        public FSCDeliverableStructureDefinitionResponse GetFullDeliverableStructure(string fundingStreamPeriodCode)
        {
            FSCDeliverableStructureDefinitionResponse deliverableStructure;

            using (var client = new WebClient())
            {

                client.Headers[HttpRequestHeader.ContentType] = "application/xml";
                client.Headers[HttpRequestHeader.Accept] = "application/xml";
                client.Headers[HttpRequestHeader.Authorization] =
                    $"Bearer {GetAuthenticationResult("FundingStreamConfig")}";
                var url = _configuration["FscEnrichmentUrl"];

                fundingStreamPeriodCode = HttpUtility.UrlEncode(fundingStreamPeriodCode);

                var webResponse = client.DownloadString(url + "?FundingStreamPeriod=" + fundingStreamPeriodCode);
                var serialiser = new XmlSerializer(typeof(FSCDeliverableStructureDefinitionResponse));
                using (TextReader tr = new StringReader(webResponse))
                {
                    deliverableStructure = (FSCDeliverableStructureDefinitionResponse)serialiser.Deserialize(tr);
                }
            }

            return deliverableStructure;
        }


        public string GetAuthenticationResult(string appSettingsSuffix)
        {

            string aadInstance = _configuration[$"ida:AADInstance_{appSettingsSuffix}"];
            string tenant = _configuration[$"ida:Tenant_{appSettingsSuffix}"];
            string clientId = _configuration[$"ida:ClientId_{appSettingsSuffix}"];
            string appKey = _configuration[$"ida:AppKey_{appSettingsSuffix}"];
            string resourceId = _configuration[$"ida:ResourceId_{appSettingsSuffix}"];

            string authority = string.Format(aadInstance, tenant);

            int retryCount = 0;
            bool retry;

            var formContent = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string, string>("client_id", clientId),
                new KeyValuePair<string, string>("resource", resourceId),
                new KeyValuePair<string, string>("grant_type", "client_credentials"),
                new KeyValuePair<string, string>("client_secret", appKey),
            });

            do
            {
                try
                {
                    using (var httpClient = new HttpClient())
                    {
                        httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/x-www-form-urlencoded"));
                        var json = httpClient.PostAsync(authority + "/oauth2/token", formContent).Result.Content.ReadAsStringAsync().Result;
                        dynamic jsonObject = JsonConvert.DeserializeObject(json);

                        return jsonObject.access_token;
                    }
                }
                catch (Exception)
                {
                    retry = true;
                    retryCount++;
                    Thread.Sleep(3000);
                }
            }
            while (retry && (retryCount < 3));

            throw new AuthenticationException("Could not authenticate with the OAUTH2 claims provider after several attempts");
        }
    }
}
