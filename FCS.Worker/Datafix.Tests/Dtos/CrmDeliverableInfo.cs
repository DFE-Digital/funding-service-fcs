namespace Datafix.Tests.Dtos
{
    using System;

    public class CrmDeliverableInfo
    {
        public CrmDeliverableInfo(Guid id, int deliverableCode)
        {
            Id = id;
            DeliverableCode = deliverableCode;
        }

        public Guid Id { get; }
        public int DeliverableCode { get; }
    }
}
