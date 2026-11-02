namespace OrganisationDomain.Integration.MainEndpoint.Extensions
{
    using DataStore.Model;
    using Entities;
    using Messages.Dtos;

    public static class OrgSupplementaryAddressExtensions
    {
        public static OrgSupplementaryAddressDto ToDtoAddress(this OrgSupplementaryAddress address)
        {
            return new OrgSupplementaryAddressDto
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