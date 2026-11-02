namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract
{
    using System.Linq;

    public partial class period
    {
        public virtual bool ShouldSerializefundingStreamPeriods()
        {
            return (fundingStreamPeriods != null && fundingStreamPeriods.Any());
        }
    }
}
