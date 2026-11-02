namespace PaymentGenerationDomain.BusinessLogic.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Xml.Linq;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;

    [TestClass]
    public class PaymentGenerationXmlValidatorTests
    {
        #region constructor tests
        [TestMethod,TestCategory("UnitTest")]
        public void Constructor_ShouldInitialiseErrorList()
        {
            var validator = new PaymentGenerationXmlValidator();
            Assert.IsTrue(validator.ErrorMessages != null, "Constructor didn't initialise the error list");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Constructor_ShouldInitialisePaymentGenerationSchema()
        {
            var validator = new PaymentGenerationXmlValidator();
            Assert.IsTrue(validator.Schemas.Count > 0, "Constructor didn't initialise the schema");

        }
        #endregion

        #region Validate Tests
        [TestMethod, TestCategory("UnitTest")]
        public void Validate_ShouldReturnTrue_ForValidXml()
        {

            var testPayment = new PaymentPeriod();
            
            var mapperMock = new Mock<IPaymentCorpSchemaMapper>();
            var loggerMock = new Mock<ILogger>();

            #region setup returned xdocument

            var returnedXml = XDocument.Parse(
                "<PaymentPeriod xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' schemaVersion='3.02' xmlns='urn:sfa:schemas:paymentsaggregation'>" +
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
                "      <Allocation>" +
                "     <AllocationNumber>1</AllocationNumber>" +
                "     <VersionNumber>2</VersionNumber>" +
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
            #endregion

            mapperMock.Setup(x => x.ToXml(It.IsAny<PaymentPeriod>())).Returns(returnedXml);
            var validator = new PaymentGenerationXmlValidator()
            {
                Mapper = mapperMock.Object,
                Logger = loggerMock.Object
            };
            var result = validator.Validate(testPayment);
            Assert.IsTrue(result, "Validate didn't return true for a valid xml doc ");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_ShouldReturnTrue_ForValidXml_ForESF()
        {

            var testPayment = new PaymentPeriod();

            var mapperMock = new Mock<IPaymentCorpSchemaMapper>();
            var loggerMock = new Mock<ILogger>();

            #region setup returned xdocument

            var returnedXml = XDocument.Parse(
                "<PaymentPeriod xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' schemaVersion='3.02' xmlns='urn:sfa:schemas:paymentsaggregation'>" +
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
                "      <Allocation>" +
                "     <AllocationNumber>1</AllocationNumber>" +
                "     <VersionNumber>2</VersionNumber>" +
                "     <ProcurementAttrs>" +
                    "     <TenderSpecReference>Tender Spec Reference</TenderSpecReference>" +
                    "     <TenderSpecTitle>Tender Spec Title</TenderSpecTitle>" +
                    "     <LotReference/>" +  // Note that Lot Reference element is mandatory if Procurement Attrs are present but it can be empty
                    "     <LotSpecificationTitle>Lot specification Title</LotSpecificationTitle>" +
                    "     <AwardReference>Award Reference</AwardReference>" +
                    "     <ActivityDescription>Activity Description</ActivityDescription>" +
                    "     <InvestmentPriority>Investment Priority</InvestmentPriority>" +
                    "     <LEPCode>AAAAAA</LEPCode>" +
                    "     <LEPName>LEP Name</LEPName>" +
                    "     <RegionType>Region Type</RegionType>" +
                    "     <AgreementNumber>BAAAAAAAAAB</AgreementNumber>" +
                    "     <LearningRatePremium>12.34</LearningRatePremium>" +
                "     </ProcurementAttrs>" +
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
            #endregion

            mapperMock.Setup(x => x.ToXml(It.IsAny<PaymentPeriod>())).Returns(returnedXml);
            var validator = new PaymentGenerationXmlValidator()
            {
                Mapper = mapperMock.Object,
                Logger = loggerMock.Object
            };
            var result = validator.Validate(testPayment);
            Assert.IsTrue(result, "Validate didn't return true for a valid xml doc ");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_ShouldReturnErrors_ForValidXml_ForInvalidESF()
        {

            var testPayment = new PaymentPeriod();

            var mapperMock = new Mock<IPaymentCorpSchemaMapper>();
            var loggerMock = new Mock<ILogger>();

            #region setup returned xdocument

            var returnedXml = XDocument.Parse(
                "<PaymentPeriod xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' schemaVersion='3.02' xmlns='urn:sfa:schemas:paymentsaggregation'>" +
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
                "      <Allocation>" +
                "     <AllocationNumber>1</AllocationNumber>" +
                "     <VersionNumber>2</VersionNumber>" +
                "     <ProcurementAttrs>" +
                    "     <TenderSpecReference>Tender Spec Reference</TenderSpecReference>" +
                    "     <TenderSpecTitle>Tender Spec Title</TenderSpecTitle>" +
                    "     <LotReference/>" +  
                    "     <LotSpecificationTitle>Lot specification Title</LotSpecificationTitle>" +
                    "     <AwardReference>Award Reference</AwardReference>" +
                    "     <ActivityDescription>Activity Description</ActivityDescription>" +
                    "     <InvestmentPriority>Investment Priority</InvestmentPriority>" +
                    //"     <LEPCode>AAAAAA</LEPCode>" // Missing LEP Code + 
                    "     <LEPName>LEP Name</LEPName>" +
                    "     <RegionType>Region Type</RegionType>" +
                    "     <AgreementNumber>BAAAAAAAAAB</AgreementNumber>" +
                    "     <LearningRatePremium>12.34</LearningRatePremium>" +
                "     </ProcurementAttrs>" +
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
            #endregion

            mapperMock.Setup(x => x.ToXml(It.IsAny<PaymentPeriod>())).Returns(returnedXml);
            var validator = new PaymentGenerationXmlValidator()
            {
                Mapper = mapperMock.Object,
                Logger = loggerMock.Object
            };
            var result = validator.Validate(testPayment);
            Assert.IsTrue(validator.ErrorMessages.Count > 0, "Validate didn't return false for a invalid xml doc ");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_ShouldReturnTrue_ForValidXml_ForEsf_WithNoLotReferenceAndLotSpecificationTitle()
        {

            var testPayment = new PaymentPeriod();

            var mapperMock = new Mock<IPaymentCorpSchemaMapper>();
            var loggerMock = new Mock<ILogger>();

            #region setup returned xdocument

            var returnedXml = XDocument.Parse(
                "<PaymentPeriod xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' schemaVersion='3.02' xmlns='urn:sfa:schemas:paymentsaggregation'>" +
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
                "      <Allocation>" +
                "     <AllocationNumber>1</AllocationNumber>" +
                "     <VersionNumber>2</VersionNumber>" +
                "     <ProcurementAttrs>" +
                    "     <TenderSpecReference>Tender Spec Reference</TenderSpecReference>" +
                    "     <TenderSpecTitle>Tender Spec Title</TenderSpecTitle>" +
                    //                    "     <LotReference/>" +  // Missing Lot Reference for test
                    //"     <LotSpecificationTitle>Lot specification Title</LotSpecificationTitle>" + // Missing Lot Specification Title for test
                    "     <AwardReference>Award Reference</AwardReference>" +
                    "     <ActivityDescription>Activity Description</ActivityDescription>" +
                    "     <InvestmentPriority>Investment Priority</InvestmentPriority>" +
                    "     <LEPCode>AAAAAA</LEPCode>" +
                    "     <LEPName>LEP Name</LEPName>" +
                    "     <RegionType>Region Type</RegionType>" +
                    "     <AgreementNumber>BAAAAAAAAAB</AgreementNumber>" +
                    "     <LearningRatePremium>12.34</LearningRatePremium>" +
                "     </ProcurementAttrs>" +
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
            #endregion

            mapperMock.Setup(x => x.ToXml(It.IsAny<PaymentPeriod>())).Returns(returnedXml);
            var validator = new PaymentGenerationXmlValidator()
            {
                Mapper = mapperMock.Object,
                Logger = loggerMock.Object
            };
            var result = validator.Validate(testPayment);
            Assert.IsTrue(result, "Validate didn't return true for a valid xml doc with missing Lot Information.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_ShouldReturnFalse_ForInValidXml()
        {
            var mapperMock = new Mock<IPaymentCorpSchemaMapper>();
            var loggerMock = new Mock<ILogger>();

            var testPayment = new PaymentPeriod();
            #region setup returned xdocument

            var returnedXml = XDocument.Parse(
                "<PaymentPeriod xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' schemaVersion='1.00' xmlns='urn:sfa:schemas:paymentsaggregation'>" +
                "  <PaymentDetails>" +
                "   <PaymentDetail>" +
                "      <Organisation>" +
                "        <OrganisationId>ORG0000001</OrganisationId>" +
                "        <AlternateOrganisationIdentifiers>" +
                "         <OrganisationIdentifier>" +
                "           <AlternateOrganisationIdentifier>A</AlternateOrganisationIdentifier>" +
                "            <AlternateOrganisationIdentifierName>UKPRN</AlternateOrganisationIdentifierName>" +
                "         </OrganisationIdentifier>" +
                "        </AlternateOrganisationIdentifiers>" +
                "       <OrganisationStatusRelationships>" +
                "         <OrganisationStatusRelationship>" +
                "           <OrganisationStatusScheme>LEGAL</OrganisationStatusScheme>" +
                "            <OrganisationStatus>ACTIVE</OrganisationStatus>" +
                "         </OrganisationStatusRelationship>" +
                "       </OrganisationStatusRelationships>" +
                "     </Organisation>" +
                "     <AllocationNumber>1</AllocationNumber>" +
                "     <VersionNumber>2</VersionNumber>" +
                "     <AccountCode>A</AccountCode>" +
                "      <SubnominalCode>1</SubnominalCode>" +
                "      <PaymentType>RECONCILIATION</PaymentType>" +
                "      <SubnominalDescription>A</SubnominalDescription>" +
                "      <AggregatedValue>26</AggregatedValue>" +
                "    </PaymentDetail>" +
                "  </PaymentDetails>" +
                "  <Aency>A</Aency>" + //<----misspelled deliberately
                " <FundingStreamShortCode>A</FundingStreamShortCode>" +
                "  <FundingStreamPeriodStartDate>2015-05-22</FundingStreamPeriodStartDate>" +
                "  <FundingStreamPeriodEndDate>2015-05-22</FundingStreamPeriodEndDate>" +
                "  <CensusEndDate>2015-05-22</CensusEndDate>" +
                "<DueDate>2015-05-22</DueDate>" +
                " <FinancialPaymentFinancialYear>2015</FinancialPaymentFinancialYear>" +
                "  <FinancialPaymentFinancialMonth>01</FinancialPaymentFinancialMonth>" +
                "</PaymentPeriod>");
            #endregion
            mapperMock.Setup(x => x.ToXml(It.IsAny<PaymentPeriod>())).Returns(returnedXml);
            var validator = new PaymentGenerationXmlValidator()
            {
                Mapper = mapperMock.Object,
                Logger = loggerMock.Object
                
            };
            var result = validator.Validate(testPayment);
            Assert.IsFalse(result, "Validate didn't return false for an invalid xml doc ");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Validate_ShouldUpdateTheErrorListWithEachError_ForInValidXml()
        {
            var mapperMock = new Mock<IPaymentCorpSchemaMapper>();
            var loggerMock = new Mock<ILogger>();

            var testPayment = new PaymentPeriod();
            #region setup returned xdocument

            var returnedXml = XDocument.Parse(
                "<PaymentPeriod xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' schemaVersion='1.00' xmlns='urn:sfa:schemas:paymentsaggregation'>" +
                "  <PaymentDetails>" +
                "   <PaymentDetail>" +
                "      <Organisation>" +
                "        <OrganisationId>ORG0000001</OrganisationId>" +
                "        <AlternateOrganisationIdentifiers>" +
                "         <OrganisationIdentifier>" +
                "           <AlternateOrganisationIdentifier>A</AlternateOrganisationIdentifier>" +
                "            <AlternateOrganisationIdentifierName>UKPRN</AlternateOrganisationIdentifierName>" +
                "         </OrganisationIdentifier>" +
                "        </AlternateOrganisationIdentifiers>" +
                "       <OrganisationStatusRelationships>" +
                "         <OrganisationStatusRelationship>" +
                "           <OrganisationStatusScheme>LEGAL</OrganisationStatusScheme>" +
                "            <OrganisationStatus>ACTIVE</OrganisationStatus>" +
                "         </OrganisationStatusRelationship>" +
                "       </OrganisationStatusRelationships>" +
                "     </Organisation>" +
                "     <AllocationNumber>1</AllocationNumber>" +
                "     <VersionNumber>2</VersionNumber>" +
                "     <AccountCode>A</AccountCode>" +
                "      <SubnominalCode>1</SubnominalCode>" +
                "      <SubnominalTpe>RECONCILIATION</SubnominalTpe>" + //<--- misspelled deliberately
                "      <SubnominalDscription>A</SubnominalDscription>" + //<--- misspelled deliberately
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
            #endregion
            mapperMock.Setup(x => x.ToXml(It.IsAny<PaymentPeriod>())).Returns(returnedXml);
            var validator = new PaymentGenerationXmlValidator()
            {
                Mapper = mapperMock.Object,
                Logger = loggerMock.Object
            };
            var result = validator.Validate(testPayment);
            Assert.IsTrue(validator.ErrorMessages.Count > 0, "Validate didn't update the error list for an invalid xml doc ");
        }

        #endregion
    }
}
