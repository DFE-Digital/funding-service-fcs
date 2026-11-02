namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using System.Runtime.Caching;
    using System.Text;
    using CrossDomain.Integration.Entities;
    using CrossDomain.Integration.Entities.CorporateContract;
    using Implementation.Services;

    public class ContractDeliverableEnricher : IContractDeliverableEnricher
    {
        private const string FscDeliverableDataCacheName = "fscDeliverableData";
        private const double CacheExpiration = 30;
        private readonly ObjectCache _cache = MemoryCache.Default;

        private readonly IFundingStreamConfigService _fundingStreamConfigurationService;

        public ContractDeliverableEnricher(IFundingStreamConfigService fscService)
        {
            _fundingStreamConfigurationService = fscService;
        }

        // Only exists to support Acceptance test set WhenTheContractIsEnrichedWithFullDeliverableStructureAndAggregateTotals
        public void Enrich(contractType masterContract)
        {
            foreach (var contract in masterContract.contracts)
            {
                foreach (var contractAllocation in contract.contractAllocations)
                {
                    EnrichContractAllocation(contractAllocation, contract);
                }
            }
        }

        public void Enrich(ExtendedContractType masterContract)
        {
            foreach (var contract in masterContract.contracts)
            {
                foreach (var contractAllocation in contract.contractAllocations)
                {
                    EnrichContractAllocation(contractAllocation, contract);
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
                        if (endDate == DateTime.MinValue)
                        {
                            endDate = null;
                        }
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

            if (endDate == null || endDate == DateTime.MinValue)
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
                deliverableStructure = FundingStreamConfigServiceHelper.FilterProfileDeliverableStructure(
                    _fundingStreamConfigurationService.GetFullDeliverableStructure(fundingStreamPeriodCode));

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
    }
}