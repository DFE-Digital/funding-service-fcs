namespace SFA.FCT.ContractCreateDomain.Implementation.Extensions
{
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public static class ContractorExtensions
    {
        public static Address GetAddress(this Contractor contractor)
        {
            return new Address
            {
                AddressLine1 = contractor.addressLine1,
                AddressLine2 = contractor.addressLine2,
                AddressLine3 = contractor.addressLine3,
                AddressLine4 = contractor.addressLine4,
                Town = contractor.town,
                County = contractor.county,
                Postcode = contractor.postcode
            };
        }
    }
}
