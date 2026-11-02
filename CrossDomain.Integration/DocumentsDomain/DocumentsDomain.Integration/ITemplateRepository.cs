namespace SFA.FCT.DocumentsDomain.Integration
{
    using System;
    using Aspose.Words;
    using Common.Models;

    public interface ITemplateRepository
    {
        Document GetTemplate(FctFile file);

        bool CheckTemplateExists(FctFile file);

        string[] GetTemplateNames(string containerName);

        string GetNameOfTemplateActiveOnDate(string containerName, string startsWith, DateTime contractStartDate);
    }
}
