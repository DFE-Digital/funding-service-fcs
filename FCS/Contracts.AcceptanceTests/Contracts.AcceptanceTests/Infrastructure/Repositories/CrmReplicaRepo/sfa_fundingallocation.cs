namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.CrmReplicaRepo
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class sfa_fundingallocation
    {
        public Guid Id { get; set; }

        public DateTime? SinkCreatedOn { get; set; }

        public DateTime? SinkModifiedOn { get; set; }

        public int? statecode { get; set; }

        public int? statuscode { get; set; }

        public int? sfa_status { get; set; }

        public int? sfa_processaction { get; set; }

        public int? sfa_serviceresponse { get; set; }

        public int? sfa_holdreason { get; set; }

        public int? sfa_substatus { get; set; }

        public Guid? owningteam { get; set; }

        [StringLength(128)]
        public string owningteam_entitytype { get; set; }

        public Guid? sfa_contracttypeid { get; set; }

        [StringLength(128)]
        public string sfa_contracttypeid_entitytype { get; set; }

        public Guid? sfa_fspgroupid { get; set; }

        [StringLength(128)]
        public string sfa_fspgroupid_entitytype { get; set; }

        public Guid? createdonbehalfby { get; set; }

        [StringLength(128)]
        public string createdonbehalfby_entitytype { get; set; }

        public Guid? transactioncurrencyid { get; set; }

        [StringLength(128)]
        public string transactioncurrencyid_entitytype { get; set; }

        public Guid? sfa_fundingtype { get; set; }

        [StringLength(128)]
        public string sfa_fundingtype_entitytype { get; set; }

        public Guid? sfa_provider { get; set; }

        [StringLength(128)]
        public string sfa_provider_entitytype { get; set; }

        public Guid? sfa_period { get; set; }

        [StringLength(128)]
        public string sfa_period_entitytype { get; set; }

        public Guid? modifiedonbehalfby { get; set; }

        [StringLength(128)]
        public string modifiedonbehalfby_entitytype { get; set; }

        public Guid? modifiedby { get; set; }

        [StringLength(128)]
        public string modifiedby_entitytype { get; set; }

        public Guid? sfa_releasegroup { get; set; }

        [StringLength(128)]
        public string sfa_releasegroup_entitytype { get; set; }

        public Guid? createdby { get; set; }

        [StringLength(128)]
        public string createdby_entitytype { get; set; }

        public Guid? owningbusinessunit { get; set; }

        [StringLength(128)]
        public string owningbusinessunit_entitytype { get; set; }

        public Guid? owninguser { get; set; }

        [StringLength(128)]
        public string owninguser_entitytype { get; set; }

        public Guid? ownerid { get; set; }

        [StringLength(128)]
        public string ownerid_entitytype { get; set; }

        public decimal? sfa_value_base { get; set; }

        public decimal? sfa_value { get; set; }

        [StringLength(100)]
        public string createdonbehalfbyname { get; set; }

        public int? timezoneruleversionnumber { get; set; }

        [StringLength(50)]
        public string sfa_ukprn { get; set; }

        [StringLength(4000)]
        public string owneridtype { get; set; }

        [StringLength(100)]
        public string modifiedonbehalfbyname { get; set; }

        public long? versionnumber { get; set; }

        [StringLength(100)]
        public string modifiedbyyominame { get; set; }

        [StringLength(100)]
        public string sfa_periodname { get; set; }

        [StringLength(100)]
        public string sfa_fundingversion { get; set; }

        public int? importsequencenumber { get; set; }

        public DateTime? createdon { get; set; }

        [StringLength(100)]
        public string createdbyyominame { get; set; }

        [StringLength(100)]
        public string sfa_contracttypeidname { get; set; }

        public DateTime? overriddencreatedon { get; set; }

        [StringLength(100)]
        public string modifiedonbehalfbyyominame { get; set; }

        [StringLength(100)]
        public string createdonbehalfbyyominame { get; set; }

        [StringLength(50)]
        public string sfa_contract { get; set; }

        [StringLength(100)]
        public string sfa_releasegroupname { get; set; }

        [StringLength(100)]
        public string owneridyominame { get; set; }

        [StringLength(100)]
        public string sfa_fspgroupidname { get; set; }

        [StringLength(100)]
        public string transactioncurrencyidname { get; set; }

        [StringLength(160)]
        public string sfa_providername { get; set; }

        [StringLength(100)]
        public string createdbyname { get; set; }

        public int? utcconversiontimezonecode { get; set; }

        [StringLength(100)]
        public string modifiedbyname { get; set; }

        public string sfa_comments { get; set; }

        public DateTime? modifiedon { get; set; }

        [StringLength(100)]
        public string sfa_intent { get; set; }

        public int? sfa_contractversion { get; set; }

        [StringLength(160)]
        public string sfa_provideryominame { get; set; }

        [StringLength(100)]
        public string sfa_allocationfundingstream { get; set; }

        public decimal? exchangerate { get; set; }

        [StringLength(100)]
        public string sfa_name { get; set; }

        [StringLength(100)]
        public string owneridname { get; set; }

        [StringLength(100)]
        public string sfa_fundingtypename { get; set; }

        public Guid? sfa_fundingallocationid { get; set; }

        [StringLength(160)]
        public string owningbusinessunitname { get; set; }

        [StringLength(50)]
        public string sfa_queuedduetocontract { get; set; }

        public DateTime? sfa_queuedon { get; set; }
    }
}
