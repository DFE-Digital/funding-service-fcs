namespace OrganisationDomain.Integration.DataStoreEndpoint
{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Threading.Tasks;
    using DataStore.Model;
    using Implementation.BusinessLogic;
    using Implementation.DataAccess;
    using Implementation.Mappers;
    using Implementation.Services;
    using Messages.Commands;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities.Organisation;
    using System.Linq;
    using Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class SaveUpdatedOrganisationHandler : IHandleMessages<SaveUpdatedOrganisation>
    {
        private readonly IOrganisationRepository _repository;
        private readonly ICpdsMapper _mapper;
        private readonly ICpdsXmlValidator _validator;

        public SaveUpdatedOrganisationHandler(IOrganisationRepository repository, ICpdsMapper mapper,
            ICpdsXmlValidator validator)
        {
            _repository = repository;
            _mapper = mapper;
            _validator = validator;
        }

        public ILogger Logger { get; set; }

        public async Task Handle(SaveUpdatedOrganisation message, IMessageHandlerContext context)
        {
            Logger.LogInformation(OrganisationDomainEventLoggingId.SaveUpdatedOrganisationMessageReceived,
                $"{message.GetType()} message received. ProcessId:{message.ProcessId}.");

            Organisation org;
            try
            {
                org = _mapper.MapProviderXmlToDbEntity(message.ChangedProvider);
            }
            catch (Exception e) when (IsProviderXmlMappingException(e))
            {
                Logger.LogError(OrganisationDomainEventLoggingId.SaveUpdatedOrganisationError,
                    $"Unable to map Provider for storage. MapProviderXmlToDbEntity failed: {e.Message}");
                return;
            }

            var organisationAsCorporateSchema = _mapper.MapDbEntityToCorpSchema(org);

            // Only update the database if the transformed organisation is valid against the corporate schema
            List<OrganisationSchemaValidationError> validationErrors = new List<OrganisationSchemaValidationError>();
            if (_validator.IsOrganisationValidAgainstOrganisationCorporateSchema(organisationAsCorporateSchema, out validationErrors))
            {
                var orgBeforeUpdate = _repository.GetDetailByUkprn(org.Ukprn);

                OrgChangeDataComparer.GetNotificationMessages(beforeUpdateOrganisation: orgBeforeUpdate,
                   afterUpdateOrganisation: org).ToList()
                   .ForEach(async notification =>
                   {
                       await context.Send(new CreateProviderUpdatedNotificationCommand
                       {
                           Notification = notification,
                           Ukprn = org.Ukprn
                       }).ConfigureAwait(false);
                   });

                _repository.UpdateOrganisation(org);

                var command = new ProcessSavedOrganisation
                {
                    ProcessId = message.ProcessId,
                    ChangedOrganisation = _mapper.MapDbEntityToCorpSchema(org)
                };

                await context.Send(command).ConfigureAwait(false);
            }
            else
            {
                StringBuilder errorMessage = new StringBuilder();
                validationErrors.ForEach(
                    x =>
                        errorMessage.AppendLine(
                            $"Line number: {x.LineNumber}, Line position: {x.LinePosition}, Error message: {x.ErrorMessage}"));
                Logger.LogError(OrganisationDomainEventLoggingId.SaveUpdatedOrganisationError, errorMessage.ToString());
            }
        }
        
        private static bool IsProviderXmlMappingException(Exception e)
        {
            return e is NullReferenceException
                   || e is ArgumentNullException
                   || e is FormatException
                   || e is OverflowException;
        }
    }
}
