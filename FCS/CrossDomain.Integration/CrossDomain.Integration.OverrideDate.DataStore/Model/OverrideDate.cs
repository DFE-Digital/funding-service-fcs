namespace SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;

    public class OverrideDate
    {
        [Key]
        public DateTime SystemOverrideDate { get; set; }
    }
}
