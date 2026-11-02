namespace OrganisationDomain.Endpoint.Xrm
{
    using System.Linq;
    using Common;
    using Integration.Messages.Commands;
    using Microsoft.Xrm.Sdk;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Task = System.Threading.Tasks.Task;

    public class UpdateXrmOrganisationHandler : IHandleMessages<UpdateXrmOrganisationCommand>
    {
        private readonly ILogger _logger;
        private readonly IOrganizationService _organizationService;

        public UpdateXrmOrganisationHandler(ILogger logger, IOrganizationService organizationService)
        {
            _logger = logger;
            _organizationService = organizationService;
        }

        public Task Handle(UpdateXrmOrganisationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(OrganisationDomainEventLoggingId.UpdateXrmOrganisationStart, $"Started update of CRM Organisation supplementary data: {message}");

            using (XrmServiceContext xrmServiceContext = new XrmServiceContext(_organizationService))
            {
                xrmServiceContext.AccountSet.Where(a => a.sfa_UKPRN == message.Ukprn)
                    .ToList()
                    .ForEach(a =>
                    {
                        var updatedAccount = new Account
                        {
                            Id = a.Id,
                            sfa_companynumber = message.CompanyNumber,
                            sfa_charitynumber = message.CharityNumber,
                            Address1_Line1 = message.Address.Line1,
                            Address1_Line2 = message.Address.Line2,
                            Address1_Line3 = message.Address.Line3,
                            Address1_Line4 = message.Address.Line4,
                            Address1_Town = message.Address.Town,
                            Address1_County = message.Address.County,
                            Address1_PostCode = message.Address.Postcode,
                            EntityState = EntityState.Changed
                        };
                        
                        _organizationService.Update(updatedAccount);
                    });
            }

            _logger.LogInformation(OrganisationDomainEventLoggingId.UpdateXrmOrganisationComplete, $"Completed update of CRM Organisation supplementary data: {message}");

            return Task.CompletedTask;
        }
    }
}
