namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.Dtos
{
    public class FundingAgreementTemplate
    {
        public FundingAgreementTemplate(string templateName, string extraPagesTemplate)
        {
            TemplateName = templateName;
            ExtraPagesTemplate = extraPagesTemplate;
        }

        public string TemplateName { get; }

        public string ExtraPagesTemplate { get; }
    }
}
