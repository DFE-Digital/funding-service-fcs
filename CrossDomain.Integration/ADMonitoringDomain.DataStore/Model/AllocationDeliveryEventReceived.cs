using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ADMonitoringDomain.DataStore.Model
{
    public class AllocationDeliveryEventReceived : ISerializeToType
    {
        [Key]
        [Column(Order = 1)]
        public string AllocationNumber { get; set; }

        [Key]
        [Column(Order = 2)]
        public int VersionNumber { get; set; }

        [Key]
        [Column(Order = 3)]
        public string CategoryName { get; set; }

        [Key]
        [Column(Order = 4)]
        public string EventName { get; set; }

        public DateTime EventReceived { get; set; }    

        [NotMapped]
        public object Object { get; set; }

        public string ObjectType { get; set; }

        public string SerializedXml { get; set; }
    }
}
