namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Repositories
{
    using System;
    using System.Linq;
    using DataStore;
    using DataStore.Models;

    public class UploadedDocumentTemplateRepository : IUploadedDocumentTemplateQueryRepository
    {
        private readonly DocumentsDomainDbContext _dbContext;

        public UploadedDocumentTemplateRepository(DocumentsDomainDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public DateTime GetDateUploaded(string templateName)
        {
            UploadedDocumentTemplate uploadedDocumentTemplate = _dbContext.UploadedDocumentTemplates.Single(d => d.TemplateName == templateName);

            return uploadedDocumentTemplate.DateUpLoaded;
        }
    }
}
