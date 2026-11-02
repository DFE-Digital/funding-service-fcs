namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Extensions
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.DeliveryAllocation;
    using CrossDomain.Integration.Entities.PaymentSchedule;

    public static class OrganisationReferenceTypeExtensions
    {
        public static CrossDomain.Integration.Entities.PaymentSchedule.Organisation ToOrganisation(
            this organisationReferenceType organisationReferenceType)
        {
            return new Organisation
            {
                MainOrganisationIdentifier = organisationReferenceType.organisationIdentifier,
                OrganisationIdentifiers = new List<OrganisationIdentifier>
                {
                    new OrganisationIdentifier
                    {
                        OrganisationId = organisationReferenceType.GetUkprn().ToString()
                    }
                }
            };
        }
    }
}
