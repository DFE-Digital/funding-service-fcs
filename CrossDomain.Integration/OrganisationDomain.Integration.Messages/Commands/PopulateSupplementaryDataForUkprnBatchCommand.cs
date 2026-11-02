namespace OrganisationDomain.Integration.Messages.Commands
{
    using System.Collections.Generic;

    public class PopulateSupplementaryDataForUkprnBatchCommand
    {
        public IList<int> UkprnBatch { get; set; }

        public bool ShouldIssueCrmNotifications { get; set; }

        public override string ToString()
        {
            return $"UKPRNs: {string.Join(", ", UkprnBatch)}";
        }
    }
}