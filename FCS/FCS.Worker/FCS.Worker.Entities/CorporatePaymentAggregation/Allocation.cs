// ReSharper disable CheckNamespace
namespace SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Globalization;
    using System.Linq;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(AnonymousType = true, Namespace = "urn:sfa:schemas:paymentsaggregation")]
    [XmlRoot(Namespace = "urn:sfa:schemas:paymentsaggregation", IsNullable = false)]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public class Allocation
    {
        public Allocation()
        {
            Organisation = new Organisation();
            AllocationPeriods = new List<AllocationPeriod>();
            schemaVersion = 3.00m;
        }

        [XmlElement(Order = 0)]
        public string AllocationNumber { get; set; }

        [XmlElement(Order = 1)]
        public int VersionNumber { get; set; }

        [XmlElement(Order = 2)]
        public string FundingStreamPeriodCode { get; set; }

        [XmlArray(Order = 3)]
        [XmlArrayItem("AllocationPeriod", IsNullable = false)]
        public List<AllocationPeriod> AllocationPeriods { get; set; }

        [XmlElement(Order = 4)]
        public Organisation Organisation { get; set; }

        [XmlAttribute]
        public decimal schemaVersion { get; set; }

        public IReadOnlyCollection<string> GetDistinctSubnominalCodes()
        {
            return AllocationPeriods.SelectMany(ap => ap.Aggregations.Select(agg => agg.SubnominalCode))
                .Distinct()
                .ToList();
        }

        public IReadOnlyCollection<string> GetDistinctAggregateKeys()
        {
            // keys look like $"{aggregation.SubnominalCode}_{allocation.AllocationNumber}_{paymentPeriod}";
            return AllocationPeriods.SelectMany(ap => ap.Aggregations.Select(agg => $"{agg.SubnominalCode}_{AllocationNumber}_{GetFormattedPeriod(ap.Period)}"))
                .Distinct()
                .ToList();
        }

        private static string GetFormattedPeriod(string period)
        {
            int monthNumber = int.Parse(period.Substring(4, 2));
            string monthName = new DateTime(2010, monthNumber, 1).ToString("MMM", CultureInfo.InvariantCulture);
            return monthName + "-" + period.Substring(2, 2);
        }
    }
}