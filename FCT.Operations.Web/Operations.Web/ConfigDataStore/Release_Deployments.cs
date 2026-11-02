namespace Operations.Web.ConfigDataStore
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Config.Release_Deployments")]
    public partial class Release_Deployments
    {
        [Key]
        public int deployment_id { get; set; }

        public int release_id { get; set; }

        public int env_id { get; set; }

        [StringLength(50)]
        public string deployment_status { get; set; }

        [StringLength(100)]
        public string created_by { get; set; }

        [StringLength(100)]
        public string modified_by { get; set; }

        public DateTime? created_at { get; set; }

        public DateTime? modified_at { get; set; }

        public virtual Environment Environment { get; set; }

        public virtual Release Release { get; set; }
    }
}
