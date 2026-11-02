namespace SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract
{
    using System.Linq;

    public partial class contractDeliverablesTypeContractDeliverable
    {
        public virtual bool ShouldSerializedeliverableOrganisationRelationships()
        {
            return (deliverableOrganisationRelationships != null && deliverableOrganisationRelationships.Any());
        }

        public virtual bool ShouldSerializecontractDeliverables()
        {
            return (contractDeliverables != null && contractDeliverables.Any());
        }
    }

}
