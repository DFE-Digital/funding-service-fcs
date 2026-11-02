namespace PaymentGenerationDomain.BusinessLogic
{
    public class XmlValidationError
    {
        public int LineNumber { get; set; }

        public int LinePosition { get; set; }

        public string ErrorMessage { get; set; }
    }
}
