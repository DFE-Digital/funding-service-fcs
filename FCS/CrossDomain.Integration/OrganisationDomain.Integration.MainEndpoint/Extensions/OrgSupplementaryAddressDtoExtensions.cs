namespace OrganisationDomain.Integration.MainEndpoint.Extensions
{
    using Entities;
    using Messages.Dtos;

    public static class OrgSupplementaryAddressDtoExtensions
    {
        public static OrgSupplementaryAddress ToDomainAddress(this OrgSupplementaryAddressDto address)
        {
            return new OrgSupplementaryAddress
            {
                Line1 = address.Line1,
                Line2 = address.Line2,
                Line3 = address.Line3,
                Line4 = address.Line4,
                Town = address.Town,
                County = address.County,
                Postcode = address.Postcode
            };
        }
    }
}