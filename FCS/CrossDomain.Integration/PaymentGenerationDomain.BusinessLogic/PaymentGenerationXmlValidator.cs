namespace PaymentGenerationDomain.BusinessLogic
{
    using System.Collections.Generic;
    using System.Xml;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using Common;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class PaymentGenerationXmlValidator : IPaymentGenerationXmlValidator
    {
        private const string PaymentGenerationCorporateSchemaResourceName = "SFA.FCT.CrossDomain.Integration.Entities.PaymentGeneration.payments_generation_corporate_schema.xsd";

        private const string PaymentGenerationCorporateSchemaNamespace = "urn:sfa:schemas:paymentsaggregation";

        private readonly XmlSchemaSet _schemas; 

        public PaymentGenerationXmlValidator()
        {
            _schemas = new XmlSchemaSet();
            ErrorMessages = new List<XmlValidationError>();

            var schema = typeof(OrganisationExtensions).Assembly.GetManifestResourceStream(PaymentGenerationCorporateSchemaResourceName);
            if (schema != null)
            {
                _schemas = new XmlSchemaSet();
                // ReSharper disable once AssignNullToNotNullAttribute
                _schemas.Add(PaymentGenerationCorporateSchemaNamespace, new XmlTextReader(schema));
            }
        }

        public XDocument XDocumentForValidation { get; set; }

        public IPaymentCorpSchemaMapper Mapper { get; set; }

        public ILogger Logger { get; set; }

        public XmlSchemaSet Schemas
        {
            get { return _schemas; }
        }
        
        public List<XmlValidationError> ErrorMessages { get; set; }
       
        public bool Validate(PaymentPeriod paymentToValidate)
        {

            Logger.LogInformation(PaymentGenerationDomainLoggingEventId.ProcessPaymentHandleStarted,
                "Performing validation for payment period with due date: {0} and Funding stream short code: {1}",
                paymentToValidate.DueDate, paymentToValidate.FundingStreamShortCode);
            var errors = false;

            XDocumentForValidation = Mapper.ToXml(paymentToValidate);
            
            XDocumentForValidation.Validate(
                    Schemas,
                    (o, e) =>
                    {
                        ErrorMessages.Add(new XmlValidationError
                        {
                            LineNumber = e.Exception.LineNumber,
                            LinePosition = e.Exception.LinePosition,
                            ErrorMessage = e.Exception.Message
                        });
                        errors = true;
                    });
            return !errors;
        }
    }
}
