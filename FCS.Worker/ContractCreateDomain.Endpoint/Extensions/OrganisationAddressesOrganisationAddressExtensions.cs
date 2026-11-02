namespace ContractCreateDomain.Endpoint.Extensions
{
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities;

    public static class OrganisationAddressesOrganisationAddressExtensions
    {
        public static Address ToAddress(this organisationAddressesOrganisationAddress schemaAddress)
        {
            return new Address
            {
                AddressLine1 = schemaAddress.addressLine1,
                AddressLine2 = schemaAddress.addressLine2,
                AddressLine3 = schemaAddress.addressLine3,
                AddressLine4 = schemaAddress.addressLine4,
                County = schemaAddress.county,
                Postcode = schemaAddress.postcode,
                Town = schemaAddress.town
            };
        }
    }
}
