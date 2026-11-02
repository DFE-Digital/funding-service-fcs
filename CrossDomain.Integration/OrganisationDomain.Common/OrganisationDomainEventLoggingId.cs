namespace OrganisationDomain.Common
{
    using SFA.FCT.CrossDomain.Integration.Common;

    public class OrganisationDomainEventLoggingId
    {
        public const int GetOrganisationHandlerMessageReceived = LoggingEventId.OrganisationDomainStart;
        public const int GetOrganisationHandlerError = LoggingEventId.OrganisationDomainStart + 1;

        public const int GetUpdatedOrganisationsMessageReceived = LoggingEventId.OrganisationDomainStart + 4;
        public const int GetUpdatedOrganisationsError = LoggingEventId.OrganisationDomainStart + 5;

        public const int SaveUpdatedOrganisationMessageReceived = LoggingEventId.OrganisationDomainStart + 7;
        public const int SaveUpdatedOrganisationError = LoggingEventId.OrganisationDomainStart + 8;

        public const int UpdateOrganisationSagaOrgUpdateMessageReceived = LoggingEventId.OrganisationDomainStart + 10;
        public const int UpdateOrganisationSagaProviderSummaryMessageReceived = LoggingEventId.OrganisationDomainStart + 11;
        public const int UpdateOrganisationSagaUpdatedOrgsMessageReceived = LoggingEventId.OrganisationDomainStart + 12;
        public const int UpdateOrganisationSagaProcessOrgsMessageReceived = LoggingEventId.OrganisationDomainStart + 10;
        public const int UpdateOrganisationSagaProcessSavedOrgsMessageReceived = LoggingEventId.OrganisationDomainStart + 10;
        public const int UpdateOrganisationSagaTimeout = LoggingEventId.OrganisationDomainStart + 10;

        public const int GetProviderSummaryHandler = LoggingEventId.OrganisationDomainStart + 20;
        public const int GetProviderSummaryError = LoggingEventId.OrganisationDomainStart + 21;

        public const int GetOrgDetailsHandler = LoggingEventId.OrganisationDomainStart + 30;
        public const int GetOrgDetailsError = LoggingEventId.OrganisationDomainStart + 31;

        public const int CpdsOrgRetrieverError = LoggingEventId.OrganisationDomainStart + 40;
        public const int CpdsOrgRetrieverRawCPDS = LoggingEventId.OrganisationDomainStart + 41;

        public const int CpdsSummaryRetrieverError = LoggingEventId.OrganisationDomainStart + 50;

        public const int InitiateOrgSupplementaryDataPopulationStart = LoggingEventId.OrganisationDomainStart + 60;
        public const int InitiateOrgSupplementaryDataPopulationComplete = LoggingEventId.OrganisationDomainStart + 61;

        public const int ErrorCallingUkrlpService = LoggingEventId.OrganisationDomainStart + 62;
        public const int ProviderNotFoundInUkrlpService = LoggingEventId.OrganisationDomainStart + 63;

        public const int PopulateSupplementaryDataForUkprnBatchStart = LoggingEventId.OrganisationDomainStart + 70;
        public const int PopulateSupplementaryDataForUkprnBatchComplete = LoggingEventId.OrganisationDomainStart + 71;

        public const int UpdateXrmOrganisationStart = LoggingEventId.OrganisationDomainStart + 72;
        public const int UpdateXrmOrganisationComplete = LoggingEventId.OrganisationDomainStart + 73;

        public const int UpdateSupplementaryOrgDataChangesStart = LoggingEventId.OrganisationDomainStart + 74;
        public const int UpdateSupplementaryOrgDataChangesComplete = LoggingEventId.OrganisationDomainStart + 75;
        public const int UpdateSupplementaryBatchOfDataStart = LoggingEventId.OrganisationDomainStart + 76;
        public const int UpdateSupplementaryBatchOfDataEnd = LoggingEventId.OrganisationDomainStart + 77;
        public const int UpdateSupplementaryBatchUpdatingOrg = LoggingEventId.OrganisationDomainStart + 78;
        public const int PopulationServiceUpdatingOrganisation = LoggingEventId.OrganisationDomainStart + 79;
        public const int UpdateSupplementaryOrgDataChangesRetrievedChanges = LoggingEventId.OrganisationDomainStart + 80;
        public const int ChangeServiceUpdatingOrganisation = LoggingEventId.OrganisationDomainStart + 81;

        public const int CreateProviderUpdatedNotificationStart = LoggingEventId.OrganisationDomainStart + 82;
        public const int CreateProviderUpdatedNotificationComplete = LoggingEventId.OrganisationDomainStart + 83;
        public const int CheckConnectivityCommandReceived = LoggingEventId.OrganisationDomainStart + 84;
        public const int CheckConnectivityCommandComplete = LoggingEventId.OrganisationDomainStart + 85;
    }
}
