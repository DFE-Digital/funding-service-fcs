namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.CrmReplicaRepo
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class sfa_subnominalaggregation
    {
        public Guid Id { get; set; }

        public DateTime? SinkCreatedOn { get; set; }

        public DateTime? SinkModifiedOn { get; set; }

        public int? statecode { get; set; }

        public int? statuscode { get; set; }

        public int? sfa_paymenttype { get; set; }

        public bool? sfa_posted { get; set; }

        public Guid? sfa_stagingsubnominalid { get; set; }

        [StringLength(128)]
        public string sfa_stagingsubnominalid_entitytype { get; set; }

        public Guid? sfa_provider { get; set; }

        [StringLength(128)]
        public string sfa_provider_entitytype { get; set; }

        public Guid? createdonbehalfby { get; set; }

        [StringLength(128)]
        public string createdonbehalfby_entitytype { get; set; }

        public Guid? modifiedby { get; set; }

        [StringLength(128)]
        public string modifiedby_entitytype { get; set; }

        public Guid? modifiedonbehalfby { get; set; }

        [StringLength(128)]
        public string modifiedonbehalfby_entitytype { get; set; }

        public Guid? createdby { get; set; }

        [StringLength(128)]
        public string createdby_entitytype { get; set; }

        public Guid? organizationid { get; set; }

        [StringLength(128)]
        public string organizationid_entitytype { get; set; }

        public Guid? sfa_fundingstreamperiod { get; set; }

        [StringLength(128)]
        public string sfa_fundingstreamperiod_entitytype { get; set; }

        [StringLength(100)]
        public string createdonbehalfbyyominame { get; set; }

        [StringLength(100)]
        public string organizationidname { get; set; }

        public decimal? sfa_aggregatedvalue { get; set; }

        [StringLength(100)]
        public string modifiedbyyominame { get; set; }

        public DateTime? overriddencreatedon { get; set; }

        public DateTime? modifiedon { get; set; }

        public long? versionnumber { get; set; }

        public int? timezoneruleversionnumber { get; set; }

        [StringLength(100)]
        public string createdbyname { get; set; }

        public int? importsequencenumber { get; set; }

        [StringLength(100)]
        public string sfa_subnominalaggregatekey { get; set; }

        public DateTime? createdon { get; set; }

        [StringLength(100)]
        public string sfa_name { get; set; }

        public int? utcconversiontimezonecode { get; set; }

        [StringLength(100)]
        public string createdonbehalfbyname { get; set; }

        [StringLength(100)]
        public string modifiedbyname { get; set; }

        [StringLength(160)]
        public string sfa_providername { get; set; }

        [StringLength(100)]
        public string sfa_subnominalcode { get; set; }

        [StringLength(100)]
        public string sfa_periodtypecode { get; set; }

        public Guid? sfa_subnominalaggregationid { get; set; }

        [StringLength(100)]
        public string createdbyyominame { get; set; }

        [StringLength(100)]
        public string modifiedonbehalfbyyominame { get; set; }

        [StringLength(100)]
        public string sfa_stagingsubnominalidname { get; set; }

        [StringLength(100)]
        public string modifiedonbehalfbyname { get; set; }

        [StringLength(100)]
        public string sfa_fundingstreamperiodname { get; set; }

        [StringLength(160)]
        public string sfa_provideryominame { get; set; }

        [StringLength(100)]
        public string sfa_period { get; set; }
    }
}
