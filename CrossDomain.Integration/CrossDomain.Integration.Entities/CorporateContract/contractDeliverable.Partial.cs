namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateContract
{
    using System.Diagnostics.CodeAnalysis;
    using System.Linq;
    using System.Xml.Serialization;

    [SuppressMessage("StyleCop.CSharp.NamingRules", "SA1300:ElementMustBeginWithUpperCaseLetter", Justification = "as per schema")]
    // ReSharper disable once InconsistentNaming
    public partial class contractDeliverablesTypeContractDeliverable
    {
        [XmlIgnore]
        public int? ParentDeliverableCode { get; set; } 

        public decimal GetDeliverableValue()
        {
            return contractDeliverablePeriods.Sum(dp => dp.plannedValue);
        }

        public decimal GetDeliverableUnitCost()
        {
            return this.unitCost;
        }

        public decimal GetDeliverableVolume()
        {
            return contractDeliverablePeriods.Sum(dp => dp.plannedVolume);
        }

        public decimal GetDeliverableVolumeCost()
        {
            return contractDeliverablePeriods.Sum(dp => this.unitCost * dp.plannedVolume);
        }

        public int AggregatedPlannedVolume => contractDeliverablePeriods.Sum(dp => dp.plannedVolume);

        public decimal AggregatedPlannedValue => contractDeliverablePeriods.Sum(dp => dp.plannedValue);

        [System.Xml.Serialization.XmlElementAttribute(Order = 9)]
        public int DisplayOrder { get; set; }

        public override bool Equals(object obj)
        {
            if (obj is contractDeliverablesTypeContractDeliverable other)
            {
                return this.deliverable.deliverableCode == other.deliverable.deliverableCode;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return deliverable.deliverableCode.GetHashCode();
        }
    }
}
