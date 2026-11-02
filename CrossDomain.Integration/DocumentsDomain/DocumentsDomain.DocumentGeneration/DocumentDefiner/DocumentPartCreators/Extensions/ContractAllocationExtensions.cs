namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Extensions
{
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using CrossDomain.Integration.Common.Serializers;
    using CrossDomain.Integration.Entities.CorporateContract;

    internal static class ContractAllocationExtensions
    {
        private const string Zero = "0";

        internal static string GetAllocationValue(this contractAllocationsContractAllocation contractAllocation)
        {
            if (contractAllocation == null)
            {
                return Zero;
            }

            return contractAllocation.maximumContractValue.ToString(CultureInfo.InvariantCulture);
        }

        internal static string GetDeliverableVolume(this contractAllocationsContractAllocation contractAllocation, int deliverableCode)
        {
            if (contractAllocation == null)
            {
                return Zero;
            }

            contractDeliverablesTypeContractDeliverable contractDeliverable = GetDeliverableForDeliverableCode(contractAllocation, deliverableCode);

            return contractDeliverable.plannedVolume.ToString(CultureInfo.InvariantCulture);
        }

        internal static string GetMay17Value(this contractAllocationsContractAllocation contractAllocation)
        {
            // Planned value from period May 2017 for deliverable code 1 for this contract allocation

            if (contractAllocation == null)
            {
                return Zero;
            }

            contractDeliverablesTypeContractDeliverable contractDeliverable = GetDeliverableForDeliverableCode(contractAllocation, 1);

            return GetPlannedValueForYearAndPeriod(contractDeliverable: contractDeliverable, year: 2017, period: 5);
        }

        internal static string GetJul17Value(this contractAllocationsContractAllocation contractAllocation)
        {
            // Planned value from period July 2017 for deliverable code 1 for this contract allocation

            if (contractAllocation == null)
            {
                return Zero;
            }

            contractDeliverablesTypeContractDeliverable contractDeliverable = GetDeliverableForDeliverableCode(contractAllocation, 1);

            return GetPlannedValueForYearAndPeriod(contractDeliverable: contractDeliverable, year: 2017, period: 7);
        }

        internal static string GetOct17Value(this contractAllocationsContractAllocation contractAllocation)
        {
            // Planned value from period October 2017 for deliverable code 1 for this contract allocation

            if (contractAllocation == null)
            {
                return Zero;
            }

            contractDeliverablesTypeContractDeliverable contractDeliverable = GetDeliverableForDeliverableCode(contractAllocation, 1);

            return GetPlannedValueForYearAndPeriod(contractDeliverable: contractDeliverable, year: 2017, period: 10);
        }

        internal static string GetSept17Value(this contractAllocationsContractAllocation contractAllocation)
        {
            if (contractAllocation == null)
            {
                return Zero;
            }

            contractDeliverablesTypeContractDeliverable contractDeliverable = GetDeliverableForDeliverableCode(contractAllocation, 1);

            return GetPlannedValueForYearAndPeriod(contractDeliverable: contractDeliverable, year: 2017, period: 9);
        }

        internal static string GetDec17Value(this contractAllocationsContractAllocation contractAllocation)
        {
            if (contractAllocation == null)
            {
                return Zero;
            }

            contractDeliverablesTypeContractDeliverable contractDeliverable = GetDeliverableForDeliverableCode(contractAllocation, 1);

            return GetPlannedValueForYearAndPeriod(contractDeliverable: contractDeliverable, year: 2017, period: 12);
        }

        internal static string GetNov17Value(this contractAllocationsContractAllocation contractAllocation)
        {
            if (contractAllocation == null)
            {
                return Zero;
            }

            contractDeliverablesTypeContractDeliverable contractDeliverable = GetDeliverableForDeliverableCode(contractAllocation, 1);

            return GetPlannedValueForYearAndPeriod(contractDeliverable: contractDeliverable, year: 2017, period: 11);
        }

        internal static string GetMar18Value(this contractAllocationsContractAllocation contractAllocation)
        {

            if (contractAllocation == null)
            {
                return Zero;
            }

            contractDeliverablesTypeContractDeliverable contractDeliverable = GetDeliverableForDeliverableCode(contractAllocation, 1);

            return GetPlannedValueForYearAndPeriod(contractDeliverable: contractDeliverable, year: 2018, period: 3);
        }

        internal static string GetApr18Value(this contractAllocationsContractAllocation contractAllocation)
        {
            if (contractAllocation == null)
            {
                return Zero;
            }

            contractDeliverablesTypeContractDeliverable contractDeliverable = GetDeliverableForDeliverableCode(contractAllocation, 1);

            return GetPlannedValueForYearAndPeriod(contractDeliverable: contractDeliverable, year: 2018, period: 4);
        }

        internal static string GetJan18Value(this contractAllocationsContractAllocation contractAllocation)
        {
            if (contractAllocation == null)
            {
                return Zero;
            }

            contractDeliverablesTypeContractDeliverable contractDeliverable = GetDeliverableForDeliverableCode(contractAllocation, 1);

            return GetPlannedValueForYearAndPeriod(contractDeliverable: contractDeliverable, year: 2018, period: 1);
        }

        internal static string GetFeb18Value(this contractAllocationsContractAllocation contractAllocation)
        {
            if (contractAllocation == null)
            {
                return Zero;
            }

            contractDeliverablesTypeContractDeliverable contractDeliverable = GetDeliverableForDeliverableCode(contractAllocation, 1);

            return GetPlannedValueForYearAndPeriod(contractDeliverable: contractDeliverable, year: 2018, period: 2);
        }
        
        internal static string GetSep18Value(this contractAllocationsContractAllocation contractAllocation)
        {
            if (contractAllocation == null)
            {
                return Zero;
            }

            contractDeliverablesTypeContractDeliverable contractDeliverable = GetDeliverableForDeliverableCode(contractAllocation, 1);

            return GetPlannedValueForYearAndPeriod(contractDeliverable: contractDeliverable, year: 2018, period: 9);
        }

        internal static string GetDeliverablePeriodPlannedValue(this contractAllocationsContractAllocation contractAllocation, int deliverableCode, int year, int period)
        {
            if (contractAllocation == null)
            {
                return Zero;
            }

            contractDeliverablesTypeContractDeliverable contractDeliverable = GetDeliverableForDeliverableCode(contractAllocation, 1);

            return GetPlannedValueForYearAndPeriod(contractDeliverable: contractDeliverable, year: year, period: period);
        }

        internal static contractAllocationsContractAllocation Clone(this contractAllocationsContractAllocation contractAllocation)
        {
            // not ideal - deep clone
            var xml = contractAllocation.SerializeToXml();
            return xml.DeserializeXml<contractAllocationsContractAllocation>();
        }

        public static IReadOnlyCollection<contractDeliverablePeriodsTypeContractDeliverablePeriod> GetDeliverablePeriodsForDeliverables(this contractAllocationsContractAllocation allocation, IEnumerable<int> deliverableCodes)
        {
            return allocation.GetAllDeliverables()
                .Where(d => deliverableCodes.Contains(d.deliverable.deliverableCode))
                .SelectMany(d => d.contractDeliverablePeriods)
                .ToList();
        }

        private static string GetPlannedValueForYearAndPeriod(contractDeliverablesTypeContractDeliverable contractDeliverable, int year, int period)
        {
            string plannedValue = null;

            if (contractDeliverable != null)
            {
                plannedValue = contractDeliverable.contractDeliverablePeriods.FirstOrDefault(dp => dp.year == year && dp.period == period)
                   ?.plannedValue.ToString(CultureInfo.InvariantCulture);
            }

            return plannedValue ?? Zero;
        }

        private static contractDeliverablesTypeContractDeliverable GetDeliverableForDeliverableCode(contractAllocationsContractAllocation contractAllocation, int deliverableCode)
        {
            return contractAllocation.contractDeliverables.SingleOrDefault(d => d.deliverable.deliverableCode == deliverableCode);
        }
    }
}
