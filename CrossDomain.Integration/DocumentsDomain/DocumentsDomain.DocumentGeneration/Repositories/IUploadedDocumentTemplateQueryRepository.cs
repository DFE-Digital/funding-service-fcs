namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Repositories
{
    using System;

    public interface IUploadedDocumentTemplateQueryRepository
    {
        DateTime GetDateUploaded(string templateName);
    }
}