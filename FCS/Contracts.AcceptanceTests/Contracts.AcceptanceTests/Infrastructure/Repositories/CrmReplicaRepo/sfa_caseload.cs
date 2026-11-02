namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.CrmReplicaRepo
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class sfa_caseload
    {
        public Guid Id { get; set; }

        public DateTime? SinkCreatedOn { get; set; }

        public DateTime? SinkModifiedOn { get; set; }

        public int? statecode { get; set; }

        public int? statuscode { get; set; }

        public Guid? sfa_status { get; set; }

        [StringLength(128)]
        public string sfa_status_entitytype { get; set; }

        public Guid? sfa_organisationid { get; set; }

        [StringLength(128)]
        public string sfa_organisationid_entitytype { get; set; }

        public Guid? owningbusinessunit { get; set; }

        [StringLength(128)]
        public string owningbusinessunit_entitytype { get; set; }

        public Guid? createdonbehalfby { get; set; }

        [StringLength(128)]
        public string createdonbehalfby_entitytype { get; set; }

        public Guid? modifiedby { get; set; }

        [StringLength(128)]
        public string modifiedby_entitytype { get; set; }

        public Guid? modifiedonbehalfby { get; set; }

        [StringLength(128)]
        public string modifiedonbehalfby_entitytype { get; set; }

        public Guid? owninguser { get; set; }

        [StringLength(128)]
        public string owninguser_entitytype { get; set; }

        public Guid? createdby { get; set; }

        [StringLength(128)]
        public string createdby_entitytype { get; set; }

        public Guid? sfa_previousownerid { get; set; }

        [StringLength(128)]
        public string sfa_previousownerid_entitytype { get; set; }

        public Guid? owningteam { get; set; }

        [StringLength(128)]
        public string owningteam_entitytype { get; set; }

        public Guid? ownerid { get; set; }

        [StringLength(128)]
        public string ownerid_entitytype { get; set; }

        [StringLength(100)]
        public string createdonbehalfbyyominame { get; set; }

        public Guid? sfa_caseloadid { get; set; }

        [StringLength(100)]
        public string sfa_ukprn { get; set; }

        [StringLength(100)]
        public string modifiedbyyominame { get; set; }

        [StringLength(150)]
        public string sfa_organisationname { get; set; }

        public DateTime? overriddencreatedon { get; set; }

        [StringLength(100)]
        public string sfa_statusname { get; set; }

        public int? timezoneruleversionnumber { get; set; }

        [StringLength(100)]
        public string modifiedonbehalfbyname { get; set; }

        [StringLength(160)]
        public string sfa_organisationidyominame { get; set; }

        public long? versionnumber { get; set; }

        [StringLength(100)]
        public string modifiedonbehalfbyyominame { get; set; }

        [StringLength(200)]
        public string sfa_previousowneridname { get; set; }

        [StringLength(100)]
        public string createdbyname { get; set; }

        [StringLength(200)]
        public string sfa_previousowneridyominame { get; set; }

        public int? importsequencenumber { get; set; }

        [StringLength(100)]
        public string owneridname { get; set; }

        public DateTime? createdon { get; set; }

        public int? utcconversiontimezonecode { get; set; }

        [StringLength(100)]
        public string createdonbehalfbyname { get; set; }

        [StringLength(100)]
        public string modifiedbyname { get; set; }

        [StringLength(100)]
        public string createdbyyominame { get; set; }

        public DateTime? modifiedon { get; set; }

        [StringLength(160)]
        public string sfa_organisationidname { get; set; }

        [StringLength(4000)]
        public string owneridtype { get; set; }

        [StringLength(30)]
        public string sfa_previousowner { get; set; }

        [StringLength(100)]
        public string owneridyominame { get; set; }

        [StringLength(160)]
        public string owningbusinessunitname { get; set; }
    }
}
