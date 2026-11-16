namespace OrganisationDomain.Implementation.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Implementation.Services;
    using Integration.Entities;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    
    [TestClass]
    public class ProviderQueryResponseExtensionsTests
    {
        //[TestMethod, TestCategory("UnitTest")]
        //public void ProviderQueryResponseExtensions_ShouldTransformToToOrgSupplementaryDataServiceResult_WhenSuccessful()
        //{
        //    // arrange
        //    const string companyRegNumber = "10";
        //    const string charityNumber = "9999999999";
        //    ProviderQueryResponse response = new ProviderQueryResponse
        //    {
        //        MatchingProviderRecords = new[]
        //        {
        //            new ProviderRecordStructure
        //            {
        //                VerificationDetails = new[]
        //                {
        //                    new VerificationDetailsStructure
        //                    {
        //                        VerificationAuthority = "Companies House",
        //                        VerificationID = companyRegNumber
        //                    },
        //                    new VerificationDetailsStructure
        //                    {
        //                        VerificationAuthority = "Charity Commission",
        //                        VerificationID = charityNumber
        //                    }
        //                }
        //            }
        //        }
        //    };

        //    // act
        //    var result = response.ToOrgSupplementaryDataServiceResult();

        //    // assert
        //    Assert.AreEqual(companyRegNumber, result.CompanyRegNumber, "The company reg number is not set");
        //    Assert.AreEqual(charityNumber, result.CharityNumber, "The charity number is not set");
        //    Assert.AreEqual(true, result.IsSuccessful, "The response is not successful");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ProviderQueryResponseExtensions_ShouldTransformToToOrgSupplementaryDataServiceResult_WhenNotSuccessful()
        //{
        //    // arrange
        //    ProviderQueryResponse response = new ProviderQueryResponse
        //    {
        //        MatchingProviderRecords = null
        //    };

        //    // act
        //    var result = response.ToOrgSupplementaryDataServiceResult();

        //    // assert
        //    Assert.AreEqual(false, result.IsSuccessful, "The result should not be succesful");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ProviderQueryResponseExtensions_ShouldTransformToPopulatedOrgSupplementaryDataCollection_WhenDataOneRecordPresent()
        //{
        //    // arrange
        //    const string companyRegNumber = "10";
        //    const string ukprn = "12345";
        //    const string charityNumber = "9999999999";
        //    const string legalAddressLine1 = "LegalAddressLine1";
        //    const string legalAddressLine2 = "LegalAddressLine2";
        //    const string legalAddressLine3 = "LegalAddressLine3";
        //    const string legalAddressLine4 = "LegalAddressLine4";
        //    const string legalAddressTown = "LegalAddressTown";
        //    const string legalAddressCounty = "LegalAddressCounty";
        //    const string legalAddressPostCode = "LegalAddressPostcode";

        //    ProviderQueryResponse response = new ProviderQueryResponse
        //    {
        //        MatchingProviderRecords = new []
        //        {
        //            new ProviderRecordStructure
        //            {
        //                UnitedKingdomProviderReferenceNumber = ukprn,
        //                VerificationDetails = new[]
        //                {
        //                    new VerificationDetailsStructure
        //                    {
        //                        VerificationAuthority = "Companies House",
        //                        VerificationID = companyRegNumber
        //                    },
        //                    new VerificationDetailsStructure
        //                    {
        //                        VerificationAuthority = "Charity Commission",
        //                        VerificationID = charityNumber
        //                    }
        //                },
        //                ProviderContact = new[]
        //                {
        //                    new ProviderContactStructure
        //                    {
        //                        ContactType = "L",
        //                        ContactAddress = new AddressStructure
        //                        {
        //                            Address1 = legalAddressLine1,
        //                            Address2 = legalAddressLine2,
        //                            Address3 = legalAddressLine3,
        //                            Address4 = legalAddressLine4,
        //                            Town = legalAddressTown,
        //                            County = legalAddressCounty,
        //                            PostCode = legalAddressPostCode
        //                        }
        //                    },
        //                    new ProviderContactStructure
        //                    {
        //                        ContactType = "P",
        //                        ContactAddress = new AddressStructure
        //                        {
        //                            Address1 = "PrimaryAddressLine1",
        //                            Address2 = "PrimaryAddressLine2",
        //                            Address3 = "PrimaryAddressLine3",
        //                            Address4 = "PrimaryAddressLine4",
        //                            Town = "PrimaryAddressTown",
        //                            County = "PrimaryAddressCounty",
        //                            PostCode = "PrimaryAddressPostcode"
        //                        }
        //                    }
        //                }
        //            }
        //        }
        //    };

        //    // act
        //    IReadOnlyCollection<OrgSupplementaryData> orgSupplementaryDataCollection = response.ToOrgSupplementaryDataCollection();

        //    // assert
        //    Assert.AreEqual(1, orgSupplementaryDataCollection.Count, "The number of items returned is not correct");
        //    Assert.AreEqual(ukprn, orgSupplementaryDataCollection.First().Ukprn.ToString(), "The ukprn returned is not correct");
        //    Assert.AreEqual(companyRegNumber, orgSupplementaryDataCollection.First().CompanyNumber, "The CompanyNumber returned is not correct");
        //    Assert.AreEqual(charityNumber, orgSupplementaryDataCollection.First().CharityNumber, "The charity number returned is not correct");
        //    Assert.AreEqual(legalAddressLine1, orgSupplementaryDataCollection.First().LegalAddress.Line1, "The address line 1 returned is not correct");
        //    Assert.AreEqual(legalAddressLine2, orgSupplementaryDataCollection.First().LegalAddress.Line2, "The address line 2 returned is not correct");
        //    Assert.AreEqual(legalAddressLine3, orgSupplementaryDataCollection.First().LegalAddress.Line3, "The address line 3 returned is not correct");
        //    Assert.AreEqual(legalAddressLine4, orgSupplementaryDataCollection.First().LegalAddress.Line4, "The address line 4 returned is not correct");
        //    Assert.AreEqual(legalAddressTown, orgSupplementaryDataCollection.First().LegalAddress.Town, "The Town returned is not correct");
        //    Assert.AreEqual(legalAddressCounty, orgSupplementaryDataCollection.First().LegalAddress.County, "The County returned is not correct");
        //    Assert.AreEqual(legalAddressPostCode, orgSupplementaryDataCollection.First().LegalAddress.Postcode, "The Postcode returned is not correct");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ProviderQueryResponseExtensions_ShouldTransformToPopulatedOrgSupplementaryDataCollection_WhenDataManyRecordsArePresent()
        //{
        //    // arrange
        //    const string companyRegNumber1 = "10";
        //    const string ukprn1 = "12345";
        //    const string charityNumber1 = "1111111111";
        //    const string companyRegNumber2 = "11";
        //    const string ukprn2 = "123456";
        //    const string charityNumber2 = "2222222222";

        //    const string legalAddressLine1_1 = "LegalAddressLine1_1";
        //    const string legalAddressLine2_1 = "LegalAddressLine2_1";
        //    const string legalAddressLine3_1 = "LegalAddressLine3_1";
        //    const string legalAddressLine4_1 = "LegalAddressLine4_1";
        //    const string legalAddressTown_1 = "LegalAddressTown_1";
        //    const string legalAddressCounty_1 = "LegalAddressCounty_1";
        //    const string legalAddressPostCode_1 = "LegalAddressPostcode_1";

        //    const string legalAddressLine1_2 = "LegalAddressLine1_2";
        //    const string legalAddressLine2_2 = "LegalAddressLine2_2";
        //    const string legalAddressLine3_2 = "LegalAddressLine3_2";
        //    const string legalAddressLine4_2 = "LegalAddressLine4_2";
        //    const string legalAddressTown_2 = "LegalAddressTown_2";
        //    const string legalAddressCounty_2 = "LegalAddressCounty_2";
        //    const string legalAddressPostCode_2 = "LegalAddressPostcode_2";

        //    ProviderQueryResponse response = new ProviderQueryResponse
        //    {
        //        MatchingProviderRecords = new[]
        //        {
        //            new ProviderRecordStructure
        //            {
        //                UnitedKingdomProviderReferenceNumber = ukprn1,
        //                VerificationDetails = new[]
        //                {
        //                    new VerificationDetailsStructure
        //                    {
        //                        VerificationAuthority = "Companies House",
        //                        VerificationID = companyRegNumber1
        //                    },
        //                    new VerificationDetailsStructure
        //                    {
        //                        VerificationAuthority = "Charity Commission",
        //                        VerificationID = charityNumber1
        //                    }
        //                },
        //                ProviderContact = new[]
        //                {
        //                    new ProviderContactStructure
        //                    {
        //                        ContactType = "L",
        //                        ContactAddress = new AddressStructure
        //                        {
        //                            Address1 = legalAddressLine1_1,
        //                            Address2 = legalAddressLine2_1,
        //                            Address3 = legalAddressLine3_1,
        //                            Address4 = legalAddressLine4_1,
        //                            Town = legalAddressTown_1,
        //                            County = legalAddressCounty_1,
        //                            PostCode = legalAddressPostCode_1
        //                        }
        //                    },
        //                    new ProviderContactStructure
        //                    {
        //                        ContactType = "P",
        //                        ContactAddress = new AddressStructure
        //                        {
        //                            Address1 = "PrimaryAddressLine1",
        //                            Address2 = "PrimaryAddressLine2",
        //                            Address3 = "PrimaryAddressLine3",
        //                            Address4 = "PrimaryAddressLine4",
        //                            Town = "PrimaryAddressTown",
        //                            County = "PrimaryAddressCounty",
        //                            PostCode = "PrimaryAddressPostcode"
        //                        }
        //                    }
        //                }
        //            },
        //            new ProviderRecordStructure
        //            {
        //                UnitedKingdomProviderReferenceNumber = ukprn2,
        //                VerificationDetails = new[]
        //                {
        //                    new VerificationDetailsStructure
        //                    {
        //                        VerificationAuthority = "Companies House",
        //                        VerificationID = companyRegNumber2
        //                    },
        //                    new VerificationDetailsStructure
        //                    {
        //                        VerificationAuthority = "Charity Commission",
        //                        VerificationID = charityNumber2
        //                    }
        //                },
        //                ProviderContact = new[]
        //                {
        //                    new ProviderContactStructure
        //                    {
        //                        ContactType = "L",
        //                        ContactAddress = new AddressStructure
        //                        {
        //                            Address1 = legalAddressLine1_2,
        //                            Address2 = legalAddressLine2_2,
        //                            Address3 = legalAddressLine3_2,
        //                            Address4 = legalAddressLine4_2,
        //                            Town = legalAddressTown_2,
        //                            County = legalAddressCounty_2,
        //                            PostCode = legalAddressPostCode_2
        //                        }
        //                    },
        //                    new ProviderContactStructure
        //                    {
        //                        ContactType = "P",
        //                        ContactAddress = new AddressStructure
        //                        {
        //                            Address1 = "PrimaryAddressLine1",
        //                            Address2 = "PrimaryAddressLine2",
        //                            Address3 = "PrimaryAddressLine3",
        //                            Address4 = "PrimaryAddressLine4",
        //                            Town = "PrimaryAddressTown",
        //                            County = "PrimaryAddressCounty",
        //                            PostCode = "PrimaryAddressPostcode"
        //                        }
        //                    }
        //                }
        //            }
        //        }
        //    };

        //    // act
        //    IReadOnlyCollection<OrgSupplementaryData> orgSupplementaryDataCollection = response.ToOrgSupplementaryDataCollection();

        //    // assert
        //    Assert.AreEqual(2, orgSupplementaryDataCollection.Count, "The number of items returned is not correct");
        //    Assert.IsTrue(orgSupplementaryDataCollection.Count(o => o.Ukprn == int.Parse(ukprn1)) == 1, "ukprn1  is not returned");
        //    OrgSupplementaryData orgSupplementaryData1 =
        //        orgSupplementaryDataCollection.First(o => o.Ukprn == int.Parse(ukprn1));
        //    Assert.AreEqual(companyRegNumber1, orgSupplementaryData1.CompanyNumber, "The CompanyNumber returned for ukprn1 is not correct");
        //    Assert.AreEqual(charityNumber1, orgSupplementaryData1.CharityNumber, "The CharityNumber returned for ukprn1 is not correct");
        //    Assert.AreEqual(legalAddressLine1_1, orgSupplementaryData1.LegalAddress.Line1, "The Address line 1 returned for ukprn1 is not correct");

        //    Assert.IsTrue(orgSupplementaryDataCollection.Count(o => o.Ukprn == int.Parse(ukprn2)) == 1, "ukprn2  is not returned");
        //    OrgSupplementaryData orgSupplementaryData2 =
        //        orgSupplementaryDataCollection.First(o => o.Ukprn == int.Parse(ukprn2));
        //    Assert.AreEqual(companyRegNumber2, orgSupplementaryData2.CompanyNumber, "The CompanyNumber returned for ukprn2 is not correct");
        //    Assert.AreEqual(charityNumber2, orgSupplementaryData2.CharityNumber, "The CharityNumber returned for ukprn2 is not correct");
        //    Assert.AreEqual(legalAddressLine1_2, orgSupplementaryData2.LegalAddress.Line1, "The Address line 1 returned for ukprn2 is not correct");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ProviderQueryResponseExtensions_ShouldTransformToEmptyOrgSupplementaryDataCollection_WhenEmptyResponseReceived()
        //{
        //    // arrange
        //    ProviderQueryResponse response = new ProviderQueryResponse
        //    {
        //        MatchingProviderRecords = null
        //    };

        //    // act
        //    var result = response.ToOrgSupplementaryDataCollection();

        //    // assert
        //    Assert.IsTrue(!result.Any(), "The result should be an empty collection");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ProviderQueryResponseExtensions_ToOrgSupplementaryDataServiceResult_ShouldReturnLegalAddressWhenLegalAndPrimaryContactAddressesPresent()
        //{
        //    // arrange
        //    ProviderQueryResponse response = new ProviderQueryResponse
        //    {
        //        MatchingProviderRecords = new[]
        //        {
        //            new ProviderRecordStructure
        //            {
        //                ProviderContact = new[]
        //                {
        //                    new ProviderContactStructure
        //                    {
        //                        ContactType = "L",
        //                        ContactAddress = new AddressStructure
        //                        {
        //                            Address1 = "LegalAddressLine1",
        //                            Address2 = "LegalAddressLine2",
        //                            Address3 = "LegalAddressLine3",
        //                            Address4 = "LegalAddressLine4",
        //                            Town = "LegalAddressTown",
        //                            County = "LegalAddressCounty",
        //                            PostCode = "LegalAddressPostcode"
        //                        }
        //                    },
        //                    new ProviderContactStructure
        //                    {
        //                        ContactType = "P",
        //                        ContactAddress = new AddressStructure
        //                        {
        //                            Address1 = "PrimaryAddressLine1",
        //                            Address2 = "PrimaryAddressLine2",
        //                            Address3 = "PrimaryAddressLine3",
        //                            Address4 = "PrimaryAddressLine4",
        //                            Town = "PrimaryAddressTown",
        //                            County = "PrimaryAddressCounty",
        //                            PostCode = "PrimaryAddressPostcode"
        //                        }
        //                    }
        //                }
        //            }
        //        }
        //    };

        //    // act
        //    OrgSupplementaryDataServiceResult result = response.ToOrgSupplementaryDataServiceResult();

        //    // assert
        //    Assert.IsNotNull(result.LegalAddress, "Transformed LegalAddress is null");
        //    Assert.AreEqual("LegalAddressLine1", result.LegalAddress.Line1, "Legal Address Line1 is incorrect");
        //    Assert.AreEqual("LegalAddressLine2", result.LegalAddress.Line2, "Legal Address Line2 is incorrect");
        //    Assert.AreEqual("LegalAddressLine3", result.LegalAddress.Line3, "Legal Address Line3 is incorrect");
        //    Assert.AreEqual("LegalAddressLine4", result.LegalAddress.Line4, "Legal Address Line4 is incorrect");
        //    Assert.AreEqual("LegalAddressTown", result.LegalAddress.Town, "Legal Address Town is incorrect");
        //    Assert.AreEqual("LegalAddressCounty", result.LegalAddress.County, "Legal Address County is incorrect");
        //    Assert.AreEqual("LegalAddressPostcode", result.LegalAddress.Postcode, "Legal Address Postcode is incorrect");
        //}

        //[TestMethod, TestCategory("UnitTest")]
        //public void ProviderQueryResponseExtensions_ToOrgSupplementaryDataServiceResult_ShouldReturnEmptyAddressWhenPrimaryContactAddressOnlyPresent()
        //{
        //    // arrange
        //    ProviderQueryResponse response = new ProviderQueryResponse
        //    {
        //        MatchingProviderRecords = new[]
        //        {
        //            new ProviderRecordStructure
        //            {
        //                ProviderContact = new[]
        //                {
        //                    new ProviderContactStructure
        //                    {
        //                        ContactType = "P",
        //                        ContactAddress = new AddressStructure
        //                        {
        //                            Address1 = "PrimaryAddressLine1",
        //                            Address2 = "PrimaryAddressLine2",
        //                            Address3 = "PrimaryAddressLine3",
        //                            Address4 = "PrimaryAddressLine4",
        //                            Town = "PrimaryAddressTown",
        //                            County = "PrimaryAddressCounty",
        //                            PostCode = "PrimaryAddressPostcode"
        //                        }
        //                    }
        //                }
        //            }
        //        }
        //    };

        //    // act
        //    OrgSupplementaryDataServiceResult result = response.ToOrgSupplementaryDataServiceResult();

        //    // assert
        //    Assert.IsNotNull(result.LegalAddress, "Transformed LegalAddress is null");
        //    Assert.IsNull(result.LegalAddress.Line1, "Legal Address Line1 is not null");
        //    Assert.IsNull(result.LegalAddress.Line2, "Legal Address Line2 is not null");
        //    Assert.IsNull(result.LegalAddress.Line3, "Legal Address Line3 is not null");
        //    Assert.IsNull(result.LegalAddress.Line4, "Legal Address Line4 is not null");
        //    Assert.IsNull(result.LegalAddress.Town, "Legal Address Town is not null");
        //    Assert.IsNull(result.LegalAddress.County, "Legal Address County is not null");
        //    Assert.IsNull(result.LegalAddress.Postcode, "Legal Address Postcode is not null");
        //}
    }
}
