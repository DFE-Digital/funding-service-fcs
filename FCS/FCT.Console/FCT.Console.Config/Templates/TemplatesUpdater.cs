namespace FCT.Console.Config.Templates
{
    using Repositories;
    using System.Linq;
    using System;
    using Extensions;

    public class TemplatesUpdater : ITemplatesUpdater
    {
        private readonly IUploadedDocumentTemplateRepository _uploadedDocumentTemplateRepository;
        private readonly ITemplateStorageRepository _templateStorageRepository;
        private IAssemblyRepository _assemblyRepository;

        public TemplatesUpdater(IUploadedDocumentTemplateRepository uploadedDocumentTemplateRepository, ITemplateStorageRepository templateStorageRepository, IAssemblyRepository assemblyRepository)
        {
            _uploadedDocumentTemplateRepository = uploadedDocumentTemplateRepository;
            _templateStorageRepository = templateStorageRepository;
            _assemblyRepository = assemblyRepository;
        }

        public void Update()
        {
            var uploadedDocumentTemplates = _uploadedDocumentTemplateRepository.GetUploadedDocumentTemplates();

            var templateFileNamesToUpload = _assemblyRepository.GetFilenamesToUpload().ToList();

            templateFileNamesToUpload.ForEach(templateFilenameToUpload =>
            {
                var templateDocumentToUpload = _assemblyRepository.GetTemplateDocumentToUpload(templateFilenameToUpload);

                var templateDocumentToUploadChecksum = templateDocumentToUpload.GetTemplateDocumentToUploadChecksum();
                var existingTemplateDocumentCheckSum = uploadedDocumentTemplates.GetExistingTemplateDocumentCheckSum(templateFilenameToUpload);

                if (existingTemplateDocumentCheckSum.TemplateDocumentHasNotAlreadyBeenAdded() ||
                    existingTemplateDocumentCheckSum.ChecksumsAreNotTheSame(templateDocumentToUploadChecksum))
                {
                    Console.WriteLine($"Uploading document template '{templateFilenameToUpload}'");

                    _templateStorageRepository.AddDocumentTemplate(templateFilenameToUpload, templateDocumentToUpload);
                    _uploadedDocumentTemplateRepository.UpsertUploadedDocumentTemplate(templateFilenameToUpload, templateDocumentToUploadChecksum);
                }
            });

            var filenamesToRemove = uploadedDocumentTemplates.GetFilenamesToRemove(templateFileNamesToUpload).ToList();

            filenamesToRemove.ForEach(templateFilenameToRemove =>
            {
                Console.WriteLine($"Removing document template '{templateFilenameToRemove}'");

                _templateStorageRepository.RemoveDocumentTemplate(templateFilenameToRemove);
                _uploadedDocumentTemplateRepository.RemoveUploadedDocumentTemplate(templateFilenameToRemove);
            });
        }
    }
}
