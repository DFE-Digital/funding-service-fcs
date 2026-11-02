namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.CrmReplicaRepo
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class sfa_releasegroup
    {
        public Guid Id { get; set; }

        public DateTime? SinkCreatedOn { get; set; }

        public DateTime? SinkModifiedOn { get; set; }

        public int? statecode { get; set; }

        public int? statuscode { get; set; }

        public int? sfa_releasestatus { get; set; }

        public Guid? modifiedonbehalfby { get; set; }

        [StringLength(128)]
        public string modifiedonbehalfby_entitytype { get; set; }

        public Guid? owninguser { get; set; }

        [StringLength(128)]
        public string owninguser_entitytype { get; set; }

        public Guid? sfa_fspgroup { get; set; }

        [StringLength(128)]
        public string sfa_fspgroup_entitytype { get; set; }

        public Guid? sfa_contracttype { get; set; }

        [StringLength(128)]
        public string sfa_contracttype_entitytype { get; set; }

        public Guid? sfa_releasedby { get; set; }

        [StringLength(128)]
        public string sfa_releasedby_entitytype { get; set; }

        public Guid? createdonbehalfby { get; set; }

        [StringLength(128)]
        public string createdonbehalfby_entitytype { get; set; }

        public Guid? modifiedby { get; set; }

        [StringLength(128)]
        public string modifiedby_entitytype { get; set; }

        public Guid? createdby { get; set; }

        [StringLength(128)]
        public string createdby_entitytype { get; set; }

        public Guid? owningteam { get; set; }

        [StringLength(128)]
        public string owningteam_entitytype { get; set; }

        public Guid? sfa_fundingtype { get; set; }

        [StringLength(128)]
        public string sfa_fundingtype_entitytype { get; set; }

        public Guid? transactioncurrencyid { get; set; }

        [StringLength(128)]
        public string transactioncurrencyid_entitytype { get; set; }

        public Guid? owningbusinessunit { get; set; }

        [StringLength(128)]
        public string owningbusinessunit_entitytype { get; set; }

        public Guid? sfa_fundingperiod { get; set; }

        [StringLength(128)]
        public string sfa_fundingperiod_entitytype { get; set; }

        public Guid? ownerid { get; set; }

        [StringLength(128)]
        public string ownerid_entitytype { get; set; }

        public decimal? sfa_associatedvalue { get; set; }

        public decimal? sfa_associatedvalue_base { get; set; }

        [StringLength(100)]
        public string createdonbehalfbyyominame { get; set; }

        public DateTime? sfa_releasedon { get; set; }

        [StringLength(100)]
        public string transactioncurrencyidname { get; set; }

        [StringLength(100)]
        public string owneridname { get; set; }

        public int? sfa_associatedcount { get; set; }

        [StringLength(100)]
        public string sfa_contracttypename { get; set; }

        [StringLength(100)]
        public string sfa_fspgroupname { get; set; }

        public DateTime? sfa_associatedvalue_date { get; set; }

        [StringLength(100)]
        public string sfa_name { get; set; }

        [StringLength(200)]
        public string sfa_releasedbyname { get; set; }

        public int? importsequencenumber { get; set; }

        [StringLength(200)]
        public string sfa_releasedbyyominame { get; set; }

        public int? utcconversiontimezonecode { get; set; }

        [StringLength(100)]
        public string createdbyyominame { get; set; }

        public int? sfa_associatedvalue_state { get; set; }

        [StringLength(100)]
        public string modifiedbyname { get; set; }

        public long? versionnumber { get; set; }

        [StringLength(100)]
        public string modifiedbyyominame { get; set; }

        public int? timezoneruleversionnumber { get; set; }

        [StringLength(4000)]
        public string owneridtype { get; set; }

        public DateTime? sfa_associatedcount_date { get; set; }

        [StringLength(100)]
        public string sfa_fundingperiodname { get; set; }

        [StringLength(100)]
        public string owneridyominame { get; set; }

        public DateTime? modifiedon { get; set; }

        public decimal? exchangerate { get; set; }

        [StringLength(100)]
        public string modifiedonbehalfbyyominame { get; set; }

        public Guid? sfa_releasegroupid { get; set; }

        [StringLength(100)]
        public string createdbyname { get; set; }

        public DateTime? createdon { get; set; }

        [StringLength(100)]
        public string sfa_fundingtypename { get; set; }

        [StringLength(100)]
        public string createdonbehalfbyname { get; set; }

        public int? sfa_associatedcount_state { get; set; }

        [StringLength(100)]
        public string modifiedonbehalfbyname { get; set; }

        public DateTime? overriddencreatedon { get; set; }

        [StringLength(160)]
        public string owningbusinessunitname { get; set; }
    }
}
