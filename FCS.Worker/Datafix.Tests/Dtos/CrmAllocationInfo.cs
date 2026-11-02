namespace Datafix.Tests.Dtos
{
    using System;
    using System.Collections.Generic;

    public class CrmAllocationInfo
    {
        public CrmAllocationInfo(Guid id, IReadOnlyCollection<CrmDeliverableInfo> deliverables)
        {
            Id = id;
            Deliverables = deliverables;
        }

        public Guid Id { get;  }

        public IReadOnlyCollection<CrmDeliverableInfo> Deliverables { get; }
    }
}
