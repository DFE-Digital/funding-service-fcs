namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.CrmReplicaRepo
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class sfa_fundingclaimreconciliation
    {
        public Guid Id { get; set; }

        public DateTime? SinkCreatedOn { get; set; }

        public DateTime? SinkModifiedOn { get; set; }

        public int? statecode { get; set; }

        public int? statuscode { get; set; }

        public int? sfa_statuscode { get; set; }

        public int? sfa_substatus { get; set; }

        public int? sfa_servicestatus { get; set; }

        public Guid? modifiedonbehalfby { get; set; }

        [StringLength(128)]
        public string modifiedonbehalfby_entitytype { get; set; }

        public Guid? owningteam { get; set; }

        [StringLength(128)]
        public string owningteam_entitytype { get; set; }

        public Guid? sfa_claimtypeid { get; set; }

        [StringLength(128)]
        public string sfa_claimtypeid_entitytype { get; set; }

        public Guid? createdonbehalfby { get; set; }

        [StringLength(128)]
        public string createdonbehalfby_entitytype { get; set; }

        public Guid? owninguser { get; set; }

        [StringLength(128)]
        public string owninguser_entitytype { get; set; }

        public Guid? sfa_providerid { get; set; }

        [StringLength(128)]
        public string sfa_providerid_entitytype { get; set; }

        public Guid? owningbusinessunit { get; set; }

        [StringLength(128)]
        public string owningbusinessunit_entitytype { get; set; }

        public Guid? modifiedby { get; set; }

        [StringLength(128)]
        public string modifiedby_entitytype { get; set; }

        public Guid? createdby { get; set; }

        [StringLength(128)]
        public string createdby_entitytype { get; set; }

        public Guid? sfa_fundingperiodid { get; set; }

        [StringLength(128)]
        public string sfa_fundingperiodid_entitytype { get; set; }

        public Guid? sfa_allocationgroupid { get; set; }

        [StringLength(128)]
        public string sfa_allocationgroupid_entitytype { get; set; }

        public Guid? ownerid { get; set; }

        [StringLength(128)]
        public string ownerid_entitytype { get; set; }

        [StringLength(100)]
        public string sfa_systemimport { get; set; }

        [StringLength(100)]
        public string createdonbehalfbyyominame { get; set; }

        public string sfa_serviceresponse { get; set; }

        [StringLength(100)]
        public string owneridname { get; set; }

        public decimal? sfa_cappedclaimedvalue { get; set; }

        public decimal? sfa_adjustedcappedclaimedvalue { get; set; }

        [StringLength(450)]
        public string sfa_allocationgroupidname { get; set; }

        [StringLength(100)]
        public string sfa_name { get; set; }

        public decimal? sfa_plannedvalue { get; set; }

        public int? importsequencenumber { get; set; }

        [StringLength(160)]
        public string sfa_provideridname { get; set; }

        [StringLength(100)]
        public string modifiedonbehalfbyyominame { get; set; }

        public int? utcconversiontimezonecode { get; set; }

        [StringLength(100)]
        public string createdbyyominame { get; set; }

        [StringLength(100)]
        public string modifiedbyname { get; set; }

        public long? versionnumber { get; set; }

        [StringLength(100)]
        public string modifiedbyyominame { get; set; }

        public int? timezoneruleversionnumber { get; set; }

        [StringLength(450)]
        public string sfa_claimtypeidname { get; set; }

        public decimal? sfa_claimadjustmentvalue { get; set; }

        [StringLength(4000)]
        public string owneridtype { get; set; }

        public Guid? sfa_fundingclaimreconciliationid { get; set; }

        public decimal? sfa_reconciliationvalue { get; set; }

        [StringLength(100)]
        public string owneridyominame { get; set; }

        public DateTime? modifiedon { get; set; }

        [StringLength(160)]
        public string sfa_provideridyominame { get; set; }

        public DateTime? sfa_statuslastupdateddate { get; set; }

        public int? sfa_claimversionnumber { get; set; }

        [StringLength(100)]
        public string createdbyname { get; set; }

        public DateTime? createdon { get; set; }

        public decimal? sfa_proposedreconciliationvalue { get; set; }

        [StringLength(100)]
        public string sfa_ukprn { get; set; }

        [StringLength(100)]
        public string createdonbehalfbyname { get; set; }

        [StringLength(100)]
        public string modifiedonbehalfbyname { get; set; }

        public decimal? sfa_claimedvalue { get; set; }

        public DateTime? overriddencreatedon { get; set; }

        [StringLength(100)]
        public string sfa_fundingperiodidname { get; set; }

        [StringLength(160)]
        public string owningbusinessunitname { get; set; }

        public decimal? sfa_earningsboostvalue { get; set; }
    }
}
