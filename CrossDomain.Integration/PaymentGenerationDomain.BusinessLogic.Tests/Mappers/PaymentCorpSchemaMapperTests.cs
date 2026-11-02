namespace PaymentGenerationDomain.BusinessLogic.Tests.Mappers
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using System.Xml.Linq;
    using BusinessLogic.Mappers;
    using Integration.DataStore.Dtos;
    using Integration.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;

    [TestClass]
    public class PaymentCorpSchemaMapperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentCorpSchemaMapper_MapSubnominalAggregationToPaymentCorpSchema_ShouldMapSubnominalAggregationDbEntity_To_PaymentCorpSchema()
        {
            // arrange
            const string agency = "SFA";
            const string financeShortCode = "1618AP";
            PaymentTimetable paymentTimetable = CreateTestPaymentTimetable();
            List<SubnominalAggregationDto> subnominalAggregations = new List<SubnominalAggregationDto>
            {
                new SubnominalAggregationDto
                {
                    AllocationNumber = "ALLOC-01",
                    AllocationVersionNumber = 2,
                    SubnominalCode = "12345",
                    PaymentType = "PROFILE",
                    AggregatedValue = 60.50m,
                    AgencyCode = agency,
                    FinanceShortCode = financeShortCode,
                    StartDate = new DateTime(2015, 08, 01),
                    EndDate = new DateTime(2015, 07, 31),
                    Ukprn = 10040000,
                    OrganisationId = "OrgId1",
                    ShortDescription = "SubnominalCode1 Description"
                }
            };

            PaymentCorpSchemaMapper paymentTCorpSchemaMapper = new PaymentCorpSchemaMapper();

            // act
            PaymentPeriod paymentPeriod = paymentTCorpSchemaMapper.MapSubnominalAggregationToCorpPaymentSchema(subnominalAggregations, paymentTimetable, new List<EsfAllocationData>(), agency,
                It.IsAny<DateTime>(),
                It.IsAny<DateTime>(),
                financeShortCode);

            // assert
            Assert.AreEqual(financeShortCode, paymentPeriod.FundingStreamShortCode, "The FundingStreamShortCode was not mapped");
            Assert.AreEqual(agency, paymentPeriod.Agency, "The Agency was not mapped");
            Assert.IsTrue(paymentPeriod.FinancialPaymentFinancialMonth == "05", "The Financial Month was not mapped");
            Assert.IsTrue(paymentPeriod.FinancialPaymentFinancialYear == "2015", "The Financial Year was not mapped");
            Assert.IsTrue(paymentPeriod.DueDate == new DateTime(2015, 08, 22), "The Due Date was not mapped");
            Assert.IsTrue(paymentPeriod.CensusEndDate == new DateTime(2015, 08, 25), "The Census End Date was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Allocation.AllocationNumber == "ALLOC-01", "The allocation number was not mapped");
            Assert.AreEqual(2, paymentPeriod.PaymentDetails.First().Allocation.VersionNumber, "Allocation version number was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().AggregatedValue == 60.50m, "The aggregated value was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().SubnominalCode == "12345", "the subnominal code was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().PaymentType == PaymentDetailPaymentType.PROFILE,"The subnominal type was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().SubnominalDescription == "SubnominalCode1 Description", "The subnominal description was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Organisation.OrganisationId == "OrgId1", "The organisation id was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Organisation.AlternateOrganisationIdentifiers.First().AlternateOrganisationIdentifier == "10040000", "The alternate org Id was not mapped");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentCorpSchemaMapper_MapSubnominalAggregationToPaymentCorpSchema_ShouldMapSubnominalAggregationDbEntity_To_PaymentCorpSchemaForEsfFields()
        {
            // arrange
            const string agency = "SFA";
            const string financeShortCode = "1618AP";
            PaymentTimetable paymentTimetable = CreateTestPaymentTimetable();
            List<SubnominalAggregationDto> subnominalAggregations = new List<SubnominalAggregationDto>
            {
                new SubnominalAggregationDto
                {
                    AllocationNumber = "ALLOC-01",
                    AllocationVersionNumber = 2,
                    SubnominalCode = "12345",
                    PaymentType = "PROFILE",
                    AggregatedValue = 60.50m,
                    AgencyCode = agency,
                    FinanceShortCode = financeShortCode,
                    StartDate = new DateTime(2015, 08, 01),
                    EndDate = new DateTime(2015, 07, 31),
                    ShortDescription = "SubnominalCode1 Description",
                    Ukprn = 10040000,
                    OrganisationId = "OrgId1"
                }
            };

            List<EsfAllocationData> esfAllocationData = CreateEsfAllocationData();

            PaymentCorpSchemaMapper paymentTCorpSchemaMapper = new PaymentCorpSchemaMapper();

            // act
            PaymentPeriod paymentPeriod = paymentTCorpSchemaMapper.MapSubnominalAggregationToCorpPaymentSchema(subnominalAggregations, paymentTimetable, esfAllocationData, agency,
                It.IsAny<DateTime>(),
                It.IsAny<DateTime>(),
                financeShortCode);

            // assert
            Assert.AreEqual(financeShortCode, paymentPeriod.FundingStreamShortCode, "The FundingStreamShortCode was not mapped");
            Assert.AreEqual(agency, paymentPeriod.Agency, "The Agency was not mapped");
            Assert.IsTrue(paymentPeriod.FinancialPaymentFinancialMonth == "05", "The Financial Month was not mapped");
            Assert.IsTrue(paymentPeriod.FinancialPaymentFinancialYear == "2015", "The Financial Year was not mapped");
            Assert.IsTrue(paymentPeriod.DueDate == new DateTime(2015, 08, 22), "The Due Date was not mapped");
            Assert.IsTrue(paymentPeriod.CensusEndDate == new DateTime(2015, 08, 25), "The Census End Date was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Allocation.AllocationNumber == "ALLOC-01", "The allocation number was not mapped");
            Assert.AreEqual(2, paymentPeriod.PaymentDetails.First().Allocation.VersionNumber, "Allocation version number was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Allocation.ProcurementAttrs.LEPCode == "LEP 01", "The LEP code was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Allocation.ProcurementAttrs.AgreementNumber == "Alloc-01 agreement", "The AgreementNumber was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Allocation.ProcurementAttrs.ActivityDescription == "Activity 1", "The ActivityDescription was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Allocation.ProcurementAttrs.AwardReference == "Alloc-01 Reference", "The AwardReference was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Allocation.ProcurementAttrs.InvestmentPriority == "Priority 1", "The InvestmentPriority was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Allocation.ProcurementAttrs.LEPName == "LEP 01 Name", "The LEPName was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Allocation.ProcurementAttrs.LearningRatePremium == 10.010m, "The LearningRatePremium was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Allocation.ProcurementAttrs.LotReference == "LOT 1 Reference", "The LotReference was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Allocation.ProcurementAttrs.RegionType == "Region Type 1", "The RegionType was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Allocation.ProcurementAttrs.LotSpecificationTitle == "Specification 1", "The LotSpecificationTitle was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Allocation.ProcurementAttrs.TenderSpecReference == "Tender Specification 1", "The TenderSpecReference was not mapped");

            Assert.IsTrue(paymentPeriod.PaymentDetails.First().AggregatedValue == 60.50m, "The aggregated value was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().SubnominalCode == "12345", "the subnominal code was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().PaymentType == PaymentDetailPaymentType.PROFILE, "The subnominal type was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().SubnominalDescription == "SubnominalCode1 Description", "The subnominal description was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Organisation.OrganisationId == "OrgId1", "The organisation id was not mapped");
            Assert.IsTrue(paymentPeriod.PaymentDetails.First().Organisation.AlternateOrganisationIdentifiers.First().AlternateOrganisationIdentifier == "10040000", "The alternate org Id was not mapped");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentCorpSchemaMapper_MapSubnominalAggregationToCorpPaymentSchema_ShouldReturnNullProcurementAttrsCTWhenThereIsNoEsfAllocationData()
        {
            // arrange
            PaymentTimetable paymentTimetable = CreateTestPaymentTimetable();
            List<SubnominalAggregationDto> subnominalAggregations = new List<SubnominalAggregationDto>
            {
                new SubnominalAggregationDto
                {
                    AllocationNumber = "ALLOC-01",
                    SubnominalCode = "12345",
                    PaymentType = "PROFILE",
                    AggregatedValue = 60.50m,
                    AgencyCode = "SFA",
                    FinanceShortCode = "1618AP",
                    StartDate = new DateTime(2015, 08, 01),
                    EndDate = new DateTime(2015, 07, 31),
                    ShortDescription = "SubnominalCode1 Description",
                    Ukprn = 10040000,
                    OrganisationId = "OrgId1"
                }
            };

            PaymentCorpSchemaMapper paymentTCorpSchemaMapper = new PaymentCorpSchemaMapper();

            // act
            PaymentPeriod paymentPeriod = paymentTCorpSchemaMapper.MapSubnominalAggregationToCorpPaymentSchema(subnominalAggregations, paymentTimetable, new List<EsfAllocationData>(), It.IsAny<string>(),
                It.IsAny<DateTime>(),
                It.IsAny<DateTime>(),
                It.IsAny<string>());

            // assert
            Assert.IsNull(paymentPeriod.PaymentDetails.First().Allocation.ProcurementAttrs, "ProcurementAttrs Should be null when there is no esfAllocationData");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentCorpSchemaMapper_MapSubnominalAggregationToCorpPaymentSchema_ShouldReturnProcurementAttrsCTWithValuesWhentThereIsEsfAllocationData()
        {
            // arrange
            PaymentTimetable paymentTimetable = CreateTestPaymentTimetable();
            List<SubnominalAggregationDto> subnominalAggregations = new List<SubnominalAggregationDto>
            {
                new SubnominalAggregationDto
                {
                    AllocationNumber = "ALLOC-01",
                    SubnominalCode = "12345",
                    PaymentType = "PROFILE",
                    AggregatedValue = 60.50m,
                    AgencyCode = "SFA",
                    FinanceShortCode = "1618AP",
                    StartDate = new DateTime(2015, 08, 01),
                    EndDate = new DateTime(2015, 07, 31),
                    ShortDescription = "SubnominalCode1 Description",
                    Ukprn = 10040000,
                    OrganisationId = "OrgId1"
                }
            };

            List<EsfAllocationData> esfAllocationData = CreateEsfAllocationData();

            PaymentCorpSchemaMapper paymentTCorpSchemaMapper = new PaymentCorpSchemaMapper();

            // act
            PaymentPeriod paymentPeriod = paymentTCorpSchemaMapper.MapSubnominalAggregationToCorpPaymentSchema(subnominalAggregations, paymentTimetable, esfAllocationData, It.IsAny<string>(),
                It.IsAny<DateTime>(),
                It.IsAny<DateTime>(),
                It.IsAny<string>());

            // assert
            Assert.IsNotNull(paymentPeriod.PaymentDetails.First().Allocation.ProcurementAttrs, "ProcurementAttrs Should contain data when there is esfAllocationData");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentCorpSchemaMapper_ToXml_ShouldMapPaymentPeriodToXDocument()
        {
            // arrange
            PaymentPeriod testPayment = new PaymentPeriod
            {
                Agency = "A",
                CensusEndDate =
                    DateTime.ParseExact("22/05/2015 13:01:00", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture),
                DueDate =
                    DateTime.ParseExact("22/05/2015 13:01:00", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture),
                FinancialPaymentFinancialMonth = "01",
                FinancialPaymentFinancialYear = "2015",
                FundingStreamPeriodEndDate =
                    DateTime.ParseExact("22/05/2015 13:01:00", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture),
                FundingStreamPeriodStartDate =
                    DateTime.ParseExact("22/05/2015 13:01:00", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture),
                FundingStreamShortCode = "A",
                PaymentDetails = new List<PaymentDetail>
                {
                    new PaymentDetail
                    {
                        AggregatedValue = 26,
                        Allocation = new AllocationAttrsCT
                        {
                            AllocationNumber = "1",
                            VersionNumber = 2,
                            ProcurementAttrs = null
                        }
                        ,
                        Organisation = new Organisation
                        {
                            OrganisationId = "ORG0000001",
                            OrganisationStatusRelationships = new List<OrganisationStatusRelationship>
                            {
                                new OrganisationStatusRelationship
                                {
                                    OrganisationStatus = OrganisationStatusRelationshipOrganisationStatus.ACTIVE,
                                    OrganisationStatusScheme =
                                        OrganisationStatusRelationshipOrganisationStatusScheme.LEGAL
                                }
                            },
                            AlternateOrganisationIdentifiers = new List<OrganisationIdentifier>
                            {
                                new OrganisationIdentifier
                                {
                                    AlternateOrganisationIdentifier = "A",
                                    AlternateOrganisationIdentifierName =
                                        OrganisationIdentifierAlternateOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                                }
                            }
                        }
                        ,
                        SubnominalCode = "1",
                        SubnominalDescription = "A",
                        PaymentType = PaymentDetailPaymentType.RECONCILIATION
                        
                    }

                }
            };

            XDocument expectedXml = XDocument.Parse("<PaymentPeriod xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' schemaVersion='3.02' xmlns='urn:sfa:schemas:paymentsaggregation'>" +
                "  <PaymentDetails>" +
                "   <PaymentDetail>" +
                "      <Organisation>" +
                "        <OrganisationId>ORG0000001</OrganisationId>" +
                "        <AlternateOrganisationIdentifiers>" +
                "         <OrganisationIdentifier>" +
                "           <AlternateOrganisationIdentifier>A</AlternateOrganisationIdentifier>" +
                "            <AlternateOrganisationIdentifierName>UK PROVIDER REFERENCE NUMBER</AlternateOrganisationIdentifierName>" +
                "         </OrganisationIdentifier>" +
                "        </AlternateOrganisationIdentifiers>" +
                "       <OrganisationStatusRelationships>" +
                "         <OrganisationStatusRelationship>" +
                "           <OrganisationStatusScheme>LEGAL</OrganisationStatusScheme>" +
                "            <OrganisationStatus>ACTIVE</OrganisationStatus>" +
                "         </OrganisationStatusRelationship>" +
                "       </OrganisationStatusRelationships>" +
                "     </Organisation>" +
                "     <Allocation>" +
                "          <AllocationNumber>1</AllocationNumber>" +
                "          <VersionNumber>2</VersionNumber>" +
                "      </Allocation>" + 
                "      <SubnominalCode>1</SubnominalCode>" +
                "      <PaymentType>RECONCILIATION</PaymentType>" +
                "      <SubnominalDescription>A</SubnominalDescription>" +
                "      <AggregatedValue>26</AggregatedValue>" +
                "    </PaymentDetail>" +
                "  </PaymentDetails>" +
                "  <Agency>A</Agency>" +
                " <FundingStreamShortCode>A</FundingStreamShortCode>" +
                "  <FundingStreamPeriodStartDate>2015-05-22</FundingStreamPeriodStartDate>" +
                "  <FundingStreamPeriodEndDate>2015-05-22</FundingStreamPeriodEndDate>" +
                "  <CensusEndDate>2015-05-22</CensusEndDate>" +
                "<DueDate>2015-05-22</DueDate>" +
                " <FinancialPaymentFinancialYear>2015</FinancialPaymentFinancialYear>" +
                "  <FinancialPaymentFinancialMonth>01</FinancialPaymentFinancialMonth>" +
                "</PaymentPeriod>");

            PaymentCorpSchemaMapper paymentTCorpSchemaMapper = new PaymentCorpSchemaMapper();

            // act
            XDocument returnedXml = paymentTCorpSchemaMapper.ToXml(testPayment);

            // assert
            Assert.IsTrue(XNode.DeepEquals(XDocument.Parse(returnedXml.Root.ToString()),  
                XDocument.Parse(expectedXml.Root.ToString())),"To Xml didn't return the expected Xml");
        }

        private static List<EsfAllocationData> CreateEsfAllocationData()
        {
            return new List<EsfAllocationData>
            {
                new EsfAllocationData
                {
                    LEPCode = "LEP 01",
                    AgreementNumber = "Alloc-01 agreement",
                    ContractAllocationNumber = "Alloc-01",
                    ActivityDescription = "Activity 1",
                    AwardReference = "Alloc-01 Reference",
                    ContractNumber = "SFA-01",
                    InvestmentPriority = "Priority 1",
                    LEPName = "LEP 01 Name",
                    LearningRatePremium = "10.01",
                    LotReference = "LOT 1 Reference",
                    RegionType = "Region Type 1",
                    SpecificationTitle = "Specification 1",
                    TenderSpecReference = "Tender Specification 1"
                },
                new EsfAllocationData
                {
                    LEPCode = "LEP 02",
                    AgreementNumber = "Alloc-02 agreement",
                    ContractAllocationNumber = "ALLOC-02",
                    ActivityDescription = "Activity 2",
                    AwardReference = "Alloc-02 Reference",
                    ContractNumber = "SFA-02",
                    InvestmentPriority = "Priority 2",
                    LEPName = "LEP 02 Name",
                    LearningRatePremium = "10.01",
                    LotReference = "LOT 2",
                    RegionType = "Region Type 2",
                    SpecificationTitle = "Specification 2",
                    TenderSpecReference = "Tender Specification 2"
                }
            };
        }

        private static PaymentTimetable CreateTestPaymentTimetable()
        {
            return new PaymentTimetable
            {
                FundingStreamPeriodCode = "16-18APPS1516",
                CalendarPeriodType = "CM",
                CalendarPeriod = "201508",
                FinancialPeriodType = "FM",
                FinancialPeriod = "201505",
                CensusEndDate = new DateTime(2015, 08, 25),
                PaymentDueDate = new DateTime(2015, 08, 22)
            };
        }
    }
}
