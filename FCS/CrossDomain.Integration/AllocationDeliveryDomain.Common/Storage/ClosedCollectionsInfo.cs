namespace SFA.FCT.AllocationDeliveryDomain.Common.Storage
{
    using System;
    using Microsoft.WindowsAzure.Storage.Table;

    public class ClosedCollectionsInfo : TableEntity
    {
        public DateTime DateOfLastSuccessfulRun { get; set; }
    }
}
