namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract
{
    using System.Linq;

    public partial class Period
    {
        public virtual bool ShouldSerializefundingStreamPeriods()
        {
            return true; // need to check
          //  return (fundingStreamPeriods != null && fundingStreamPeriods.Any());
        }
    }
}
