namespace SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation
{
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [SuppressMessage("StyleCop.CSharp.NamingRules", "SA1300:ElementMustBeginWithUpperCaseLetter", Justification = "as per schema")]
    public partial class contractDeliverableType
    {
        private bool _allowPlannedValueForCalculation = true;

        public bool ShouldSerializecontractDeliverables()
        {
            return contractDeliverablesField?.Count > 0;
        }

        [XmlIgnore]
        public bool AllowPlannedValueForCalculation
        {
            get { return _allowPlannedValueForCalculation; }
            set { _allowPlannedValueForCalculation = value; }
        }
    }
}
