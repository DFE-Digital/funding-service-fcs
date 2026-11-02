namespace OrganisationDomain.Integration.MainEndpoint
{
    using System.Collections.Generic;
    using NServiceBus;

    public class UpdateOrganisationSagaData : ContainSagaData
    {
        public virtual string ProcessId { get; set; }

        public virtual bool IsTimeoutAlreadyScheduled { get; set; }

        public virtual int State { get; set; }

        public virtual IDictionary<int, bool> OrganisationStatus { get; set; }
    }
}
