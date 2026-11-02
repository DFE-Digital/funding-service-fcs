namespace OrganisationDomain.Implementation.BusinessLogic
{
    using System.Collections.Generic;
    using DataAccess;
    using Integration.Entities;

    public interface IProviderComparer
    {
        IOrganisationRepository Repository { get; set; }

        List<ProviderSequence> CpdsProviders { get; set; }

        List<ProviderSequence> GetChanges();
    }
}
