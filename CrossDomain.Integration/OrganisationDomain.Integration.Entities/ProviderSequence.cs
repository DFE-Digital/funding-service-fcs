namespace OrganisationDomain.Integration.Entities
{
    using System;

    [Serializable]
    public class ProviderSequence
    {
        public int Ukprn { get; set; }

        public int Upin { get; set; }

        public int SequenceNumber { get; set; }
    }
}
