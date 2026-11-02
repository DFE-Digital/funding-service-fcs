namespace OrganisationDomain.Integration.CpdsEndpoint
{
    using System;
    using System.Xml;
    using System.Xml.Linq;
    using Implementation.BusinessLogic;
    using Messages.Commands;
    using NServiceBus;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Common;
    using System.Threading.Tasks;

    public class GetOrganisationDetailsHandler : IHandleMessages<GetOrganisationDetails>
    {
        private readonly ICpdsOrganisationRetriever _cpdsOrganisationRetriever;
        private readonly ILogger _logger;

        public GetOrganisationDetailsHandler(ICpdsOrganisationRetriever cpdsOrganisationRetriever, ILogger logger)
        {
            _cpdsOrganisationRetriever = cpdsOrganisationRetriever;
            _logger = logger;
           
        }

        public async Task Handle(GetOrganisationDetails message, IMessageHandlerContext context)
        {
            _logger.LogInformation(OrganisationDomainEventLoggingId.GetOrgDetailsHandler, message.GetType() + " message received. ProcessId:{0}, Ukprn:{1}. Upin {2}", message.ProcessId, message.Ukprn, message.Upin);

            XDocument provider;
            try
            {
                provider = _cpdsOrganisationRetriever.GetProviderByUkprnAndUpin(message.Ukprn, message.Upin);
            }
            catch (Exception e)
            {
                if (e is XmlException
                    || e is NullReferenceException)
                {
                    _logger.LogError(OrganisationDomainEventLoggingId.GetOrgDetailsError, "Error trying to process CPDS response. Ukprn:{0} - {1}", message.Ukprn, e.ToString());
                }
                else
                {
                    _logger.LogError(OrganisationDomainEventLoggingId.GetOrgDetailsError, "Error {0}", e.ToString());
                }

                throw;
            }

            var command = new ProcessOrganisationDetails
            {
                ProcessId = message.ProcessId,
                ChangedProvider = provider
            };

            await context.Send(command).ConfigureAwait(false);
        }
    }
}
