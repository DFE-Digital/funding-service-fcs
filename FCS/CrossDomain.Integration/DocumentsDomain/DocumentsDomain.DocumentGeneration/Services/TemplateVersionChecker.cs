namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Services
{
    using System;
    using Repositories;

    public class TemplateVersionChecker : ITemplateVersionChecker
    {
        private readonly IUploadedDocumentTemplateQueryRepository _uploadedDocumentTemplateQueryRepository;

        public TemplateVersionChecker(IUploadedDocumentTemplateQueryRepository uploadedDocumentTemplateQueryRepository)
        {
            _uploadedDocumentTemplateQueryRepository = uploadedDocumentTemplateQueryRepository;
        }

        public bool ShouldIncludeTemplate(string templateName, DateTime? createdDateForNonNotificationApprovedContract, bool isVariation)
        {
            if (createdDateForNonNotificationApprovedContract.HasValue && isVariation)
            {
                var dateUploaded = _uploadedDocumentTemplateQueryRepository.GetDateUploaded(templateName);

                return dateUploaded > createdDateForNonNotificationApprovedContract;
            }

            return true; // no approved contract
        }
    }
}
