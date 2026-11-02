namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Services
{
    using System;

    public interface ITemplateVersionChecker
    {
        bool ShouldIncludeTemplate(string templateName, DateTime? lastApprovedContractCreated, bool isVariation);
    }
}