namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories.CrmReplicaRepo
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class sfa_contracttransitionhistory
    {
        public Guid Id { get; set; }

        public DateTime? SinkCreatedOn { get; set; }

        public DateTime? SinkModifiedOn { get; set; }

        public int? statecode { get; set; }

        public int? statuscode { get; set; }

        public int? sfa_newstatus { get; set; }

        public int? sfa_previousstatus { get; set; }

        public Guid? modifiedonbehalfby { get; set; }

        [StringLength(128)]
        public string modifiedonbehalfby_entitytype { get; set; }

        public Guid? sfa_contractapprovalrequestedfrom { get; set; }

        [StringLength(128)]
        public string sfa_contractapprovalrequestedfrom_entitytype { get; set; }

        public Guid? sfa_newsubstatus { get; set; }

        [StringLength(128)]
        public string sfa_newsubstatus_entitytype { get; set; }

        public Guid? createdonbehalfby { get; set; }

        [StringLength(128)]
        public string createdonbehalfby_entitytype { get; set; }

        public Guid? sfa_contractapprovedby { get; set; }

        [StringLength(128)]
        public string sfa_contractapprovedby_entitytype { get; set; }

        public Guid? modifiedby { get; set; }

        [StringLength(128)]
        public string modifiedby_entitytype { get; set; }

        public Guid? createdby { get; set; }

        [StringLength(128)]
        public string createdby_entitytype { get; set; }

        public Guid? sfa_action { get; set; }

        [StringLength(128)]
        public string sfa_action_entitytype { get; set; }

        public Guid? sfa_actionby { get; set; }

        [StringLength(128)]
        public string sfa_actionby_entitytype { get; set; }

        public Guid? sfa_contract { get; set; }

        [StringLength(128)]
        public string sfa_contract_entitytype { get; set; }

        public Guid? sfa_actionrequestedfrom { get; set; }

        [StringLength(128)]
        public string sfa_actionrequestedfrom_entitytype { get; set; }

        public Guid? organizationid { get; set; }

        [StringLength(128)]
        public string organizationid_entitytype { get; set; }

        public Guid? sfa_previoussubstatus { get; set; }

        [StringLength(128)]
        public string sfa_previoussubstatus_entitytype { get; set; }

        [StringLength(100)]
        public string createdonbehalfbyyominame { get; set; }

        [StringLength(100)]
        public string sfa_newsubstatusname { get; set; }

        [StringLength(200)]
        public string sfa_contractapprovedbyname { get; set; }

        [StringLength(100)]
        public string sfa_previousowner { get; set; }

        [StringLength(100)]
        public string sfa_previouscontractowner { get; set; }

        [StringLength(100)]
        public string sfa_name { get; set; }

        [StringLength(20)]
        public string sfa_contractname { get; set; }

        [StringLength(200)]
        public string sfa_actionbyyominame { get; set; }

        [StringLength(100)]
        public string sfa_actionname { get; set; }

        [StringLength(100)]
        public string sfa_previoussubstatusname { get; set; }

        public string sfa_comments { get; set; }

        [StringLength(200)]
        public string sfa_contractapprovalrequestedfromname { get; set; }

        public int? importsequencenumber { get; set; }

        [StringLength(100)]
        public string organizationidname { get; set; }

        [StringLength(200)]
        public string sfa_actionbyname { get; set; }

        [StringLength(100)]
        public string sfa_newcontractowner { get; set; }

        [StringLength(100)]
        public string sfa_newowner { get; set; }

        public int? utcconversiontimezonecode { get; set; }

        [StringLength(100)]
        public string createdbyyominame { get; set; }

        [StringLength(200)]
        public string sfa_actionrequestedfromyominame { get; set; }

        [StringLength(100)]
        public string modifiedbyname { get; set; }

        public long? versionnumber { get; set; }

        [StringLength(100)]
        public string modifiedbyyominame { get; set; }

        public int? timezoneruleversionnumber { get; set; }

        public Guid? sfa_contracttransitionhistoryid { get; set; }

        public DateTime? sfa_actionon { get; set; }

        public DateTime? modifiedon { get; set; }

        [StringLength(200)]
        public string sfa_contractapprovalrequestedfromyominame { get; set; }

        [StringLength(100)]
        public string modifiedonbehalfbyyominame { get; set; }

        [StringLength(100)]
        public string createdbyname { get; set; }

        public DateTime? createdon { get; set; }

        [StringLength(100)]
        public string createdonbehalfbyname { get; set; }

        [StringLength(200)]
        public string sfa_contractapprovedbyyominame { get; set; }

        [StringLength(200)]
        public string sfa_actionrequestedfromname { get; set; }

        [StringLength(100)]
        public string modifiedonbehalfbyname { get; set; }

        public DateTime? overriddencreatedon { get; set; }
    }
}
