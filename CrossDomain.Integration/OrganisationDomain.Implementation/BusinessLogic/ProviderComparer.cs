namespace OrganisationDomain.Implementation.BusinessLogic
{
    using System.Collections.Generic;
    using System.Linq;
    using DataAccess;
    using Integration.Entities;
    using Exceptions;

    public class ProviderComparer : IProviderComparer
    {
        public IOrganisationRepository Repository { get; set; }

        public List<ProviderSequence> CpdsProviders { get; set; }

        public List<ProviderSequence> GetChanges()
        {
            var fctProviders = Repository.GetFctProviderSummary();

            if (CpdsProviders == null)
            {
                throw new ProviderSummaryUnavailableException(@"Did not retrieve the external Provider Summary. ""CpdsProviders"" is null.");
            }

            if (fctProviders == null)
            {
                throw new ProviderSummaryUnavailableException(
                    @"Could not retrieve Provider Summary from local data store. ""fctProviders"" is null.");
            }

            var changed = from fctProvider in fctProviders
                join cpdsProvider in CpdsProviders
                    on new { fctProvider.Ukprn, fctProvider.Upin } equals
                    new { cpdsProvider.Ukprn, cpdsProvider.Upin }
                where fctProvider.SequenceNumber != cpdsProvider.SequenceNumber
                select new ProviderSequence
                {
                    Ukprn = fctProvider.Ukprn,
                    Upin = fctProvider.Upin
                };

            changed = changed.ToList();

            if (!changed.Any())
            {
                changed = null;
            }

            return (List<ProviderSequence>)changed;
        }
    }
}