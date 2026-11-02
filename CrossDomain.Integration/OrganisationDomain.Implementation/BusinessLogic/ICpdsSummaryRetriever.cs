namespace OrganisationDomain.Implementation.BusinessLogic
{
    using System.Collections.Generic;
    using Integration.Entities;

    public interface ICpdsSummaryRetriever
    {
        List<ProviderSequence> RetrieveSummary();
    }
}