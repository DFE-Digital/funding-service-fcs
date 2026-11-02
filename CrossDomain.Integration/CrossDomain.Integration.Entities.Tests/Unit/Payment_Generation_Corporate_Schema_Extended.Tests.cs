namespace CrossDomain.Integration.Entities.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;

    [TestClass]
    public class AllocationAttrsCTTest
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentGenerationAllocationAttrsCT_ShouldSerializeProcurementAttrsWhenTendSpecReferenceIsSet()
        {
            // arrange
            PaymentPeriod corpPaymentPeriod = new PaymentPeriod
            {
                Agency = "ESFA",
                CensusEndDate = new DateTime(2015, 8, 25),
                DueDate = new DateTime(2015, 9, 1),
                FinancialPaymentFinancialMonth = "05",
                FinancialPaymentFinancialYear = "2015",
                FundingStreamShortCode = "ESFC",
                FundingStreamPeriodStartDate = new DateTime(2015, 8, 01),
                FundingStreamPeriodEndDate = new DateTime(2016, 7, 31),
                PaymentDetails = CreatePaymentDetailsForTransaction()
            };

            string xmlcorpPaymentPeriod = corpPaymentPeriod.SerializeToXml();

            PaymentPeriod rehydratedPaymentPeriod = xmlcorpPaymentPeriod.DeserializeXml<PaymentPeriod>();

            //// assert
            Assert.IsNotNull(rehydratedPaymentPeriod.PaymentDetails.First().Allocation.ProcurementAttrs.TenderSpecReference);
                
        }

        private  List<PaymentDetail> CreatePaymentDetailsForTransaction()
        {
            const string codaAccountCode = "CodaAccountCode1";
            const string controlAccountCode = "ControlAccountCode1";
            const string dummyAccountCode = "DummyAccountCode1";
            const string element1Code = "Element1Code1";
            const decimal aggregatedValue = 50m;
            const string allocationNumber = "ALLOC-01";
            const string subnominalCode = "12345";
            const string subnominalDescription = "SubnominalDesc1";

            return new List<PaymentDetail>
            {
                new PaymentDetail
                {
                    CodaAccountCode = codaAccountCode,
                    ControlAccountCode = controlAccountCode,
                    DummyAccountCode = dummyAccountCode,
                    Element1Code = element1Code,
                    AggregatedValue = aggregatedValue,
                    Allocation = new AllocationAttrsCT()
                     {
                         AllocationNumber = allocationNumber,
                         ProcurementAttrs = new ProcurementAttrsCT
                        {
                            TenderSpecReference = "only field set"
                        }
                   },
                    SubnominalCode = subnominalCode,
                    SubnominalDescription = subnominalDescription,
                    PaymentType = PaymentDetailPaymentType.PROFILE,
                    Organisation = new Organisation
                    {
                        OrganisationId = "orgId1",
                        AlternateOrganisationIdentifiers = new List<OrganisationIdentifier>
                        {
                            new OrganisationIdentifier
                            {
                                AlternateOrganisationIdentifierName = OrganisationIdentifierAlternateOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER,
                                AlternateOrganisationIdentifier = "10040000"
                            }
                        },
                        OrganisationStatusRelationships = new List<OrganisationStatusRelationship>
                        {
                            new OrganisationStatusRelationship
                            {
                                OrganisationStatusScheme = OrganisationStatusRelationshipOrganisationStatusScheme.LEGAL,
                                OrganisationStatus = OrganisationStatusRelationshipOrganisationStatus.ACTIVE
                            }
                        }
                    }
                },
            };
        }
      
    
    }
}
