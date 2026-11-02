namespace OrganisationDomain.Integration.Messages.Commands
{
    using SFA.FCT.CrossDomain.Integration.Entities;

    public class ProcessSavedOrganisation : BaseUpdateOrganisationCommand
    {
        public organisation ChangedOrganisation { get; set; }
    }
}
