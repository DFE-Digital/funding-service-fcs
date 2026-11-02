namespace OrganisationDomain.Implementation.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Integration.Entities;

    public static class ProviderQueryResponseExtensions
    {
        //private const string CompanyRegistrationNumberVerificationAuthority = "Companies House";
        //private const string CharityNumberVerificationAuthority = "Charity Commission";

        //public static OrgSupplementaryDataServiceResult ToOrgSupplementaryDataServiceResult(
        //    this ProviderQueryResponse response)
        //{
        //    if (response?.MatchingProviderRecords != null && response.MatchingProviderRecords.Any())
        //    {
        //        string companyRegNumber = GetVerificationDetails(response.MatchingProviderRecords.FirstOrDefault(), CompanyRegistrationNumberVerificationAuthority);
        //        string charityNumber = GetVerificationDetails(response.MatchingProviderRecords.FirstOrDefault(), CharityNumberVerificationAuthority);

        //        AddressStructure legalAddress =
        //            response.MatchingProviderRecords.FirstOrDefault()?.ProviderContact?.FirstOrDefault(pc => pc.ContactType == "L")?.ContactAddress;

        //        return new OrgSupplementaryDataServiceResult(companyRegNumber, charityNumber, true)
        //        {
        //            LegalAddress = new OrgSupplementaryDataServiceResult.Address
        //            {
        //                Line1 = legalAddress?.Address1,
        //                Line2 = legalAddress?.Address2,
        //                Line3 = legalAddress?.Address3,
        //                Line4 = legalAddress?.Address4,
        //                Town = legalAddress?.Town,
        //                County = legalAddress?.County,
        //                Postcode = legalAddress?.PostCode
        //            }
        //        };
        //    }

        //    return new OrgSupplementaryDataServiceResult(null, false);
        //}

        //public static IReadOnlyCollection<OrgSupplementaryData> ToOrgSupplementaryDataCollection(
        //   this ProviderQueryResponse response)
        //{
        //    if (response?.MatchingProviderRecords != null && response.MatchingProviderRecords.Any())
        //    {
        //        return response.MatchingProviderRecords.Select(TransformMatchingProviderToOrgSupplementaryData).ToList();
        //    }

        //    return Enumerable.Empty<OrgSupplementaryData>().ToList();
        //}

        //private static OrgSupplementaryData TransformMatchingProviderToOrgSupplementaryData(ProviderRecordStructure providerRecordStructure)
        //{
        //    return new OrgSupplementaryData(int.Parse(providerRecordStructure.UnitedKingdomProviderReferenceNumber),
        //        GetVerificationDetails(providerRecordStructure, CompanyRegistrationNumberVerificationAuthority),
        //        GetVerificationDetails(providerRecordStructure, CharityNumberVerificationAuthority),
        //        GetLegalAddress(providerRecordStructure));
        //}

        //private static string GetVerificationDetails(ProviderRecordStructure providerRecordStructure, string verificationAuthority)
        //{
        //    return providerRecordStructure?.VerificationDetails?.FirstOrDefault(vd => vd.VerificationAuthority == verificationAuthority)?
        //                .VerificationID;
        //}

        //private static OrgSupplementaryAddress GetLegalAddress(ProviderRecordStructure providerRecordStructure)
        //{
        //    AddressStructure legalAddress =
        //        providerRecordStructure?.ProviderContact?.FirstOrDefault(pc => pc.ContactType == "L")?.ContactAddress;

        //    return new OrgSupplementaryAddress
        //    {
        //        Line1 = legalAddress?.Address1,
        //        Line2 = legalAddress?.Address2,
        //        Line3 = legalAddress?.Address3,
        //        Line4 = legalAddress?.Address4,
        //        Town = legalAddress?.Town,
        //        County = legalAddress?.County,
        //        Postcode = legalAddress?.PostCode
        //    };
        //}
    }
}
