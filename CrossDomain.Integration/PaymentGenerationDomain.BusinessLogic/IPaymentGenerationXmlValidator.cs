namespace PaymentGenerationDomain.BusinessLogic
{
    extern alias Entities;
    using System.Collections.Generic;
    using System.Xml.Linq;
    using System.Xml.Schema;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration;

    public interface IPaymentGenerationXmlValidator
    {
        XDocument XDocumentForValidation { get; set; }

        XmlSchemaSet Schemas { get; }

        List<XmlValidationError> ErrorMessages { get; set; }

        bool Validate(PaymentPeriod documentToValidate);
    }
}