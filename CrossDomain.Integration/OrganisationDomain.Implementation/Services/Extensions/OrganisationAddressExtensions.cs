namespace OrganisationDomain.Implementation.Extensions
{
    using Integration.DataStore.Model;
    using Integration.Entities;

    public static class OrganisationAddressExtensions
    {
        public static Address ToDbAddress(this OrgSupplementaryAddress address)
        {
            return new Address
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